import os
import pytz

from github import Github
from datetime import datetime, timedelta, timezone
from collections import defaultdict
from dotenv import load_dotenv
from concurrent.futures import ThreadPoolExecutor

from export import print_results,generate_pdf_for_all_users
from utils import get_commits_related_to_issue, get_linked_pr

EST = pytz.timezone('America/Toronto')
ANY = '*'
ORGANIZATION_NAME = 'ai-cfia'
MAX_WORKERS = 50

def collect_user_data(member, repos, start_date, end_date, selected_repository):
    username = member.login
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
        if repo.name in selected_repository or selected_repository == ANY:
            for issue in repo.get_issues(assignee=member, since=start_date, state='all'):
                if issue.created_at <= end_date:
                    assigned_issues.append(issue)
                    commits = get_commits_related_to_issue(repo, issue, member, start_date, end_date)
                    commits_per_issue[issue.number] += len(commits)
                    linked_pr = get_linked_pr(repo, issue)
                    if linked_pr:
                        issues_with_linked_pr.append((issue, linked_pr))
            
            for pr in repo.get_pulls(state='all'):
                reviews = pr.get_reviews()
                for review in reviews:
                    if review.user == member and review.submitted_at is not None and start_date <= review.submitted_at <= end_date:
                        reviews_done.append(review)

            for issue in repo.get_issues(state='all', since=start_date):
                comments = issue.get_comments()
                for comment in comments:
                    if comment.user == member and start_date <= comment.created_at <= end_date:
                        issue_comments.append(comment)
            
            for issue in repo.get_issues(creator=member.login, since=start_date, state='all'):
                if issue.created_at <= end_date:
                    issues_created.append(issue)
            
            for pr in repo.get_pulls(state='all'):
                if pr.user == member and start_date <= pr.created_at <= end_date:
                    prs_created.append(pr)
                if pr.merged and start_date <= pr.merged_at <= end_date:
                    prs_merged.append(pr)
                if pr.closed_at and not pr.merged and start_date <= pr.closed_at <= end_date:
                    prs_closed.append(pr)
            
            print(f"=== repo {repo.name} done for {username}")

    return {
        'username': username,
        'assigned_issues': assigned_issues,
        'commits_per_issue': commits_per_issue,
        'issues_with_linked_pr': issues_with_linked_pr,
        'reviews_done': reviews_done,
        'issue_comments': issue_comments,
        'issues_created': issues_created,
        'prs_created': prs_created,
        'prs_merged': prs_merged,
        'prs_closed': prs_closed
    }

def main(gh_access_token, start_date_str, end_date_str, selected_repository, selected_members):
    g = Github(gh_access_token)
    org = g.get_organization(ORGANIZATION_NAME)
    repos = org.get_repos()
    members = org.get_members()
    start_date = EST.localize(datetime.strptime(start_date_str, '%Y-%m-%d'))
    end_date = EST.localize(datetime.strptime(end_date_str, '%Y-%m-%d'))
    users_data = []

    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        futures = []
        for member in members:
            if member.login in selected_members or selected_members == ANY:
                print(f"fetching github metrics for {member.login}")
                futures.append(executor.submit(collect_user_data, member, repos, start_date, end_date, selected_repository))

        for future in futures:
            user_data = future.result()
            users_data.append(user_data)
            print_results(user_data['username'], user_data['assigned_issues'], user_data['commits_per_issue'], 
                          user_data['issues_with_linked_pr'], user_data['reviews_done'], user_data['issue_comments'], 
                          user_data['issues_created'], user_data['prs_created'], user_data['prs_merged'], user_data['prs_closed'])

    generate_pdf_for_all_users(users_data, start_date_str, end_date_str)

if __name__ == "__main__":
    load_dotenv()

    gh_access_token = os.getenv("GITHUB_ACCESS_TOKEN")

    # e.g 2024-12-01 (yyyy/MM/dd)
    start_date_str = os.getenv("START_DATE")
    end_date_str = os.getenv("END_DATE")

    # from https://github.com/ai-cfia/github-workflows/blob/main/repo_project.txt
    # e.g fertiscan-backend,fertiscan-frontend,fertiscan-pipeline,nachet-backend,nachet-frontend,nachet-model,howard,github-workflows,devops,finesse-backend,finesse-frontend,finesse-data
    selected_repository = os.getenv("SELECTED_REPOSITORY")
    if not selected_repository:
        repos = ANY
    else:
        repos = selected_repository.split(',')
    
    # e.g Bob,Alice,...
    selected_members = os.getenv("SELECTED_MEMBERS")
    if not selected_members:
        members = ANY
    else:
        members = selected_members.split(',')

    main(gh_access_token, start_date_str, end_date_str, repos, members)