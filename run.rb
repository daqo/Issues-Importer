require 'rubygems'
require 'bundler'
Bundler.require(:default)

# Modify your credentials here
BITBUCKET_USERNAME = "bitbucket username goes here"
BITBUCKET_PASSWORD = "bitbucket password goes here"
BITBUCKET_REPONAME = "bitbucket repo name goes here"

GITHUB_USERNAME = "github username goes here"
GITHUB_PASSWORD = "github password goes here"
GITHUB_REPONAME = "github repo name goes here"


# Fill BitBucketUserName and BitBucketPassword with appropariate inputs
BITBUCKET = BitBucket.new basic_auth: 'BitBucketUserName:BitBucketPassword'
GITHUB = Octokit::Client.new login: GITHUB_USERNAME, password: GITHUB_PASSWORD

def extract_issues(status)
  result = []
  start = 0

  loop do
    issues = BITBUCKET.issues.list_repo BITBUCKET_USERNAME, BITBUCKET_REPONAME, limit: 50, start: start, sort: :created_on, status: status
    break if issues.count == 0

    result += issues
    start += 50
  end

  result
end

issues = []
['new', 'open', 'on hold', 'resolved'].each do |status|
  issues += extract_issues(status)
end

issues.each do |issue|
  GITHUB.create_issue GITHUB_REPONAME, issue.title, issue.content, labels: "bitbucket"
end
