#
# API to interface with JIRA
#
# http://host:port/context/rest/api-name/api-version/resource-name
Rest = require 'restler'
Q = require 'q'
URL_EXTENSION = '/jira/rest/api/2/'

class Service

  constructor: (user, pass, host)->
    JiraService = Rest.service (user, pass, host)->
      @baseURL = "https://#{host}#{URL_EXTENSION}"
      @defaults.username = user
      @defaults.password = pass
      @defaults.headers =
        Accept: 'application/json'
        'Content-Type': 'application/json'
      return this
    , null,
      project_list: ->
        @get('project')
      list: ->
        @get('issues')
    @api = new JiraService(user, pass, host)

  projects: ->
    deferred = Q.defer()
    @api.project_list().on 'complete', (data)=>
      deferred.resolve(data)
    deferred.promise


module.exports = Service
