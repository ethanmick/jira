#
# Parses the command and fire it off to the correct place.
#

nconf = require 'nconf'
url = require 'url'
Q = require 'q'
Service = require './service'
colors = require 'colors'

exit = (msg) ->
  console.log msg if msg
  process.exit(1)

usage = ->
  console.log "Usage: jira [options] [command]"
  console.log ''
  console.log "Global Options:"
  console.log "--set-user: Sets the user globally for Jira. This is required to run commands."
  console.log "--set-pass: Sets the password globally for Jira. This is required to run commands."
  console.log "--set-url: Sets the URL to your Jira instance. It expects the URL to be in the form of 'https://example.atlassian.net'"
  console.log ''
  console.log "Commands:"
  console.log "projects list [projects]: Lists the projects in your Jira instance"
  console.log "issue: Creates a new issue."
#  console.log "projects create: Create a new project"
  exit()

nconf.argv()
  .env()
  .file(file: './config.json')

baseurl = nconf.get('set-url')
parsed = url.parse(baseurl or '')

nconf.set('user', nconf.get('set-user')) if nconf.get('set-user')
nconf.set('pass', nconf.get('set-pass')) if nconf.get('set-pass')
nconf.set('base_url', parsed.host) if parsed.host

command = nconf.get('_')[0]

nconf.save (err)->
  user = nconf.get('user')
  pass = nconf.get('pass')
  baseurl = nconf.get('base_url')

  exit('No username has been set yet! Please use $ jira --set-user Steve_Jobs') unless user
  exit('No password has been set yet! Please use $ jira --set-pass Secret$Pass') unless pass
  exit('No base url has been set yet! Please use $ jira --set-url https://example.atlassian.net') unless baseurl
  usage() unless command

  console.log 'Fetching...'.green
  jira = new Service(user, pass, baseurl)
  jira[command]().then (data)->
    console.log data
