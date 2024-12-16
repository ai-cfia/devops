from datetime import datetime
from time import sleep
import time

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


def check_rate_limit(g):
    rate_limit = g.get_rate_limit()
    core_rate_limit = rate_limit.core
    remaining = core_rate_limit.remaining
    reset_timestamp = core_rate_limit.reset.timestamp()
    current_timestamp = datetime.now().timestamp()

    if remaining < 100:
        sleep_time = reset_timestamp - current_timestamp + 10
        if sleep_time > 0:
            print(f"Rate limit about to be exceeded. Sleeping for {sleep_time} seconds.", flush=True)
            time.sleep(sleep_time)

def log_rate_limit(g):
    rate_limit = g.get_rate_limit()
    remaining = rate_limit.core.remaining
    reset_time = rate_limit.core.reset.strftime('%Y-%m-%d %H:%M:%S')
    print(f"Remaining requests: {remaining}, Rate limit resets at: {reset_time}", flush=True)
