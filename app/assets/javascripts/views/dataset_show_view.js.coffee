class Datahub.DatasetShowView extends Backbone.View
  el: "#dataset_show"

  events:
    "shown .nav-tabs a" : "initializeTab"

  initialize: (options = {}) ->
    # ensure that tab showing is done after event delegation
    # which happens after initialize
    @previewTranslations = options.previewTranslations
    _.defer => @showTab options.tab

  showTab: (tab) ->
    tab ||= "preview"
    @$("ul.nav-tabs a[href=##{tab}]").tab("show")

  initializeTab: (e) =>
    $target = $(e.currentTarget)
    switch $target.attr("href")
      when "#preview"
        @previewView ||= new Datahub.DatasetPreviewView el: @$("#preview"), translations: @previewTranslations


class Datahub.DatasetPreviewView extends Backbone.View
  events:
    "keyup thead th input" : "columnFilterChanged"

  initialize: (options = {}) ->
    @translations = options.translations
    @initializeDataTable()

  initializeDataTable: ->
    @columnFilterValues = []
    $dataTable = @$(".table")
    # bind to click event on individual input elements
    # to prevent default th click behaviour
    $dataTable.find("thead th input").click @clickHeadInput

    @dataTable = $dataTable.dataTable
      sDom: "<'row-fluid'<'span4'l><'span8'f>r>t<'row-fluid'<'span5'i><'span7'p>>"
      sScrollX: "100%"
      bProcessing: true
      bServerSide: true
      sAjaxSource: $dataTable.data "source"
      fnServerData: @fnServerData
      sPaginationType: "bootstrap"
      oLanguage: @translations

    # do not focus on table headers when moving with tabs between column filters
    @$("thead th").attr "tabindex", "-1"

  # override standard DataTebles implementation to add processing of additional returned query parameter
  fnServerData: (sUrl, aoData, fnCallback, oSettings) =>
    oSettings.jqXHR = $.ajax
      url: sUrl
      data: aoData
      success: (json) =>
        # console.log "fnServerData success", json
        @updateDownloadLinks(json.queryParams)
        $(oSettings.oInstance).trigger('xhr', oSettings)
        fnCallback(json)
      dataType: "json"
      cache: false
      type: oSettings.sServerMethod
      error: (xhr, error, thrown) ->
        if error == "parsererror"
          oSettings.oApi._fnLog( oSettings, 0, "DataTables warning: JSON data from " +
            "server could not be parsed. This is caused by a JSON formatting error." )

  updateDownloadLinks: (params) ->
    delete params.q unless params.q
    withoutPageParams = _.clone params
    delete withoutPageParams.page
    delete withoutPageParams.per_page

    @$("a[data-download-path]").each ->
      $this = $(this)
      $this.attr "href", $this.data("downloadPath") + "?" +
        $.param(if $this.data("pageParams") then params else withoutPageParams)
    @$(".download-data").show()

  clickHeadInput: (e) =>
    # ignore click to prevent sorting
    false

  columnFilterChanged: (e) ->
    $target = $(e.currentTarget)
    inputIndex = $target.closest("tr").find("input").index($target)
    @columnFilterValues[inputIndex] ?= ""
    if (value = $target.val()) isnt @columnFilterValues[inputIndex]
      @columnFilterValues[inputIndex] = value
      @dataTable.fnFilter value, inputIndex
