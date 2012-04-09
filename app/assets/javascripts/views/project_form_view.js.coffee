class DataHub.ProjectFormView extends Backbone.View

  el: "form.project-form"

  events:
    "keyup #project_name"       : "updateShortname"
    "change #project_shortname" : "changeSluggifyMode"

  initialize: ->
    @sluggify = not @$("#project_shortname").val() or
      @$("#project_shortname").val() == Inflector.sluggify(@$("#project_name").val())

  updateShortname: (e) ->
    if @sluggify
      @$("#project_shortname").val Inflector.sluggify(@$("#project_name").val())

  changeSluggifyMode: (e) ->
    @sluggify = if value = @$("#project_shortname").val()
      value == Inflector.sluggify(@$("#project_name").val())
    else
      true
