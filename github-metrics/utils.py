
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
