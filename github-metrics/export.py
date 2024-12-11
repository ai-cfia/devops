import io

from reportlab.lib import colors
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak
from reportlab.lib.styles import getSampleStyleSheet

def print_results(username, assigned_issues, commits_per_issue, issues_with_linked_pr,
                  reviews_done, issue_comments, issues_created, prs_created, prs_merged, prs_closed):
    print("\n--- Statistics ---\n")

    print(f"Assigned issue {username}:")
    for issue in assigned_issues:
        print(f"- [{issue.state}] {issue.title} ({issue.html_url})")

    print(f"\nCommits per issue:")
    for issue_number, count in commits_per_issue.items():
        print(f"- Issue #{issue_number}: {count} commits")

    print(f"\nIssue linked PR:")
    for issue, pr in issues_with_linked_pr:
        print(f"- Issue #{issue.number} linked PR #{pr.number}")

    print(f"\n Reviews made by {username}:")
    for review in reviews_done:
        print(f"- PR url [{review.pull_request_url}] : {review.state} ({review.submitted_at})")

    print(f"\nComments per issue:")
    for comment in issue_comments:
        print(f"- Issue url [{comment.issue_url}]: {comment.body[:30]}...")

    print(f"\nIssue created by {username}:")
    for issue in issues_created:
        print(f"- {issue.title} ({issue.html_url})")

    print(f"\nPRs created by {username}:")
    for pr in prs_created:
        print(f"- PR #{pr.number}: {pr.title} ({pr.html_url})")

    print(f"\nPRs merged by {username}:")
    for pr in prs_merged:
        print(f"- PR #{pr.number}: {pr.title} ({pr.html_url})")

    print(f"\nPRs closed (not merged) by {username}:")
    for pr in prs_closed:
        print(f"- PR #{pr.number}: {pr.title} ({pr.html_url})")

def generate_pdf_for_all_users(users_data, start_date_str, end_date_str):
    buffer = io.BytesIO()
    doc = SimpleDocTemplate(buffer, pagesize=letter)
    styles = getSampleStyleSheet()
    flowables = []

    for user_data in users_data:
        print(f"Adding {user_data['username']} to the PDF", flush=True)
        USERNAME = user_data['username']
        assigned_issues = user_data['assigned_issues']
        commits_per_issue = user_data['commits_per_issue']
        issues_with_linked_pr = user_data['issues_with_linked_pr']
        reviews_done = user_data['reviews_done']
        issue_comments = user_data['issue_comments']
        issues_created = user_data['issues_created']
        prs_created = user_data['prs_created']
        prs_merged = user_data['prs_merged']
        prs_closed = user_data['prs_closed']

        flowables.append(Paragraph(f"<b>Statistics for {USERNAME}</b>", styles['Title']))
        flowables.append(Spacer(1, 12))

        flowables.append(Paragraph("Assigned Issues:", styles['Heading2']))
        for issue in assigned_issues:
            flowables.append(Paragraph(f"- [{issue.state}] {issue.title} ({issue.html_url})", styles['Normal']))

        flowables.append(Spacer(1, 12))
        flowables.append(Paragraph("Commits per Issue:", styles['Heading2']))
        for issue_number, count in commits_per_issue.items():
            flowables.append(Paragraph(f"- Issue #{issue_number}: {count} commits", styles['Normal']))

        flowables.append(Spacer(1, 12))
        flowables.append(Paragraph("Issues with Linked PRs:", styles['Heading2']))
        for issue, pr in issues_with_linked_pr:
            flowables.append(Paragraph(f"- Issue #{issue.number} linked PR #{pr.number}", styles['Normal']))

        flowables.append(Spacer(1, 12))
        flowables.append(Paragraph("Reviews Done:", styles['Heading2']))
        for review in reviews_done:
            flowables.append(Paragraph(f"- PR url [{review.pull_request_url}] : {review.state} ({review.submitted_at})", styles['Normal']))

        flowables.append(Spacer(1, 12))
        flowables.append(Paragraph("Issue Comments:", styles['Heading2']))
        for comment in issue_comments:
            flowables.append(Paragraph(f"- Issue url [{comment.issue_url}]: {comment.body[:30]}...", styles['Normal']))

        flowables.append(Spacer(1, 12))
        flowables.append(Paragraph("Issues Created:", styles['Heading2']))
        for issue in issues_created:
            flowables.append(Paragraph(f"- {issue.title} ({issue.html_url})", styles['Normal']))

        flowables.append(Spacer(1, 12))
        flowables.append(Paragraph("PRs Created:", styles['Heading2']))
        for pr in prs_created:
            flowables.append(Paragraph(f"- PR #{pr.number}: {pr.title} ({pr.html_url})", styles['Normal']))

        flowables.append(Spacer(1, 12))
        flowables.append(Paragraph("PRs Merged:", styles['Heading2']))
        for pr in prs_merged:
            flowables.append(Paragraph(f"- PR #{pr.number}: {pr.title} ({pr.html_url})", styles['Normal']))

        flowables.append(Spacer(1, 12))
        flowables.append(Paragraph("PRs Closed (but not merged):", styles['Heading2']))
        for pr in prs_closed:
            flowables.append(Paragraph(f"- PR #{pr.number}: {pr.title} ({pr.html_url})", styles['Normal']))

        flowables.append(PageBreak())

    # Build the PDF
    doc.build(flowables)

    # Write the buffer to a PDF file
    pdf_filename = f"github_metrics-{start_date_str}-{end_date_str}.pdf"
    with open(pdf_filename, 'wb') as f:
        f.write(buffer.getvalue())

    buffer.close()
    print(f"PDF report generated: {pdf_filename}")
