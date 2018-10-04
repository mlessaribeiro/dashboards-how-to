require 'jira-ruby'

host = "http://localhost:8082/"
username = "admin"
password = "admin"
project = "ABD"
status = "Done"

options = {
            :username => username,
            :password => password,
            :context_path => '',
            :site     => host,
            :auth_type => :basic,
            use_ssl: false
          }

client = JIRA::Client.new(options)

SCHEDULER.every '5s', :first_in => 0 do |job|
  
  client = JIRA::Client.new(options)
  # num = 0;

  allIssues = 0
  client.Issue.jql("PROJECT = \"#{project}\"").each do |issue|
    allIssues+=1
  end
  
  inProgressIssues = 0
  client.Issue.jql("PROJECT = \"#{project}\" AND STATUS = \"In Progress\"").each do |issue|
    inProgressIssues+=1
  end

  todoIssues = 0
  client.Issue.jql("PROJECT = \"#{project}\" AND STATUS = \"To Do\"").each do |issue|
    todoIssues+=1
  end

  doneIssues = 0
  client.Issue.jql("PROJECT = \"#{project}\" AND STATUS = \"Done\"").each do |issue|
    doneIssues+=1
  end

  bugToDoIssues = 0
  client.Issue.jql("project = \"ABD\" AND issuetype = \"Bug\" AND status = \"To Do\"").each do |issue|
    bugToDoIssues+=1
  end  

  send_event('jiraAllIssues', { current: allIssues})
  send_event('jiraInProgressIssues', { current: inProgressIssues})
  send_event('jiraTodoIssues', { current: todoIssues})
  send_event('jiraDoneIssues', { current: doneIssues})
  send_event('jiraBugToDoIssues', { current: bugToDoIssues})
end