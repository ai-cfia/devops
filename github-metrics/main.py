import os

from github import Github
from datetime import datetime, timedelta, timezone
from collections import defaultdict
from dotenv import load_dotenv

ORGANIZATION_NAME = 'ai-cfia'

def main(gh_access_token, start_date, end_date, selected_repository):
    g = Github(gh_access_token)
    org = g.get_organization(ORGANIZATION_NAME)
    repos = org.get_repos()
    members = org.get_members()

    for member in members:
        USERNAME = member.login
        print(f"\n=== STATISTICS FOR {USERNAME} ===")

        assigned_issues = []
        commits_per_issue = defaultdict(int)
        issues_with_linked_pr = []
        reviews_done = []
        issue_comments = []
        issues_created = []
        prs_created = []
        prs_closed = []
        prs_merged = []

        for repo in repos:
            if repo.name in selected_repository:
                print(f"=== repository {repo.name} ===")
                print("collecting assigned issues + related commits + PR releated")
                for issue in repo.get_issues(assignee=member, since=start_date, state='all'):
                    if issue.created_at.replace(tzinfo=timezone.utc) <= end_date:
                        assigned_issues.append(issue)
                        # Commits liés à l'issue
                        commits = get_commits_related_to_issue(repo, issue, member, start_date, end_date)
                        commits_per_issue[issue.number] += len(commits)
                        # Vérifier si l'issue a un PR lié
                        linked_pr = get_linked_pr(repo, issue)
                        if linked_pr:
                            issues_with_linked_pr.append((issue, linked_pr))
                print("collecting PR reviews")
                for pr in repo.get_pulls(state='all'):
                    reviews = pr.get_reviews()
                    for review in reviews:
                        if review.user == member and start_date <= review.submitted_at.replace(tzinfo=timezone.utc) <= end_date:
                            reviews_done.append(review)
                print("collecting issue comments")
                for issue in repo.get_issues(state='all', since=start_date):
                    comments = issue.get_comments()
                    for comment in comments:
                        if comment.user == member and start_date <= comment.created_at.replace(tzinfo=timezone.utc) <= end_date:
                            issue_comments.append(comment)
                print("collecting issue created")
                for issue in repo.get_issues(creator=member.login, since=start_date, state='all'):
                    if issue.created_at.replace(tzinfo=timezone.utc) <= end_date:
                        issues_created.append(issue)
                print("collecting PR created, deleted and merged ")
                for pr in repo.get_pulls(state='all'):
                    if pr.user == member and start_date <= pr.created_at.replace(tzinfo=timezone.utc) <= end_date:
                        prs_created.append(pr)
                        if pr.merged and start_date <= pr.merged_at.replace(tzinfo=timezone.utc) <= end_date:
                            prs_merged.append(pr)
                        if pr.closed_at and not pr.merged and start_date <= pr.closed_at.replace(tzinfo=timezone.utc) <= end_date:
                            prs_closed.append(pr)
        
        print_results(USERNAME, assigned_issues, commits_per_issue, issues_with_linked_pr,
                        reviews_done, issue_comments, issues_created, prs_created, prs_merged, prs_closed)


def get_commits_related_to_issue(repo, issue, user, start_date, end_date):
    commits = []
    for commit in repo.get_commits(author=user, since=start_date, until=end_date):
        if f"#{issue.number}" in commit.commit.message:
            commits.append(commit)
    return commits

def get_linked_pr(repo, issue):
    for pr in repo.get_pulls(state='all'):
        if (f"#{issue.number}" in (pr.body or '')) or (f"#{issue.number}" in (pr.title or '')):
            return pr
    return None

def print_results(USERNAME, assigned_issues, commits_per_issue, issues_with_linked_pr,
                  reviews_done, issue_comments, issues_created, prs_created, prs_merged, prs_closed):

    print("\n--- Statistics ---\n")

    print(f"Assigned issue {USERNAME}:")
    for issue in assigned_issues:
        print(f"- [{issue.state}] {issue.title} ({issue.html_url})")

    print(f"\nCommits per issue:")
    for issue_number, count in commits_per_issue.items():
        print(f"- Issue #{issue_number}: {count} commits")

    print(f"\nIssue linked PR:")
    for issue, pr in issues_with_linked_pr:
        print(f"- Issue #{issue.number} linked PR #{pr.number}")

    print(f"\n Reviews made by {USERNAME}:")
    for review in reviews_done:
        print(f"- PR url [{review.pull_request_url}] : {review.state} ({review.submitted_at})")

    print(f"\nComments per issue:")
    for comment in issue_comments:
        print(f"- Issue url [{comment.issue_url}]: {comment.body[:30]}...")

    print(f"\nIssue created by {USERNAME}:")
    for issue in issues_created:
        print(f"- {issue.title} ({issue.html_url})")

    print(f"\nPRs created by {USERNAME}:")
    for pr in prs_created:
        print(f"- PR #{pr.number}: {pr.title} ({pr.html_url})")

    print(f"\nPRs merged by {USERNAME}:")
    for pr in prs_merged:
        print(f"- PR #{pr.number}: {pr.title} ({pr.html_url})")

    print(f"\nPRs closed (not merged) by {USERNAME}:")
    for pr in prs_closed:
        print(f"- PR #{pr.number}: {pr.title} ({pr.html_url})")

if __name__ == "__main__":
    load_dotenv()

    gh_access_token = os.getenv("GITHUB_ACCESS_TOKEN")
    start_date = os.getenv("START_DATE")
    end_date = os.getenv("END_DATE")

    selected_repository = os.getenv("SELECTED_REPOSITORY")
    repos = selected_repository.split(',')

    main(gh_access_token, start_date, end_date, repos)