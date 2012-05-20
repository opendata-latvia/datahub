class Datahub.DatasetShowView extends Backbone.View
  el: "#dataset_show"

  events:
    "shown .nav-tabs a" : "initializeTab"

  initialize: (options = {}) ->
    # ensure that tab showing is done after event delegation
    # which happens after initialize
    _.defer => @showTab options.tab

  showTab: (tab) ->
    tab ||= "preview"
    @$("ul.nav-tabs a[href=##{tab}]").tab("show")

  initializeTab: (e) =>
    $target = $(e.currentTarget)
    switch $target.attr("href")
      when "#preview"
        @previewView ||= new Datahub.DatasetPreviewView el: @$("#preview")


class Datahub.DatasetPreviewView extends Backbone.View
  events:
    "keyup thead th input" : "columnFilterChanged"

  initialize: (options = {}) ->
    @initializeDataTable()

  initializeDataTable: ->
    @columnFilterValues = []
    $dataTable = @$(".table")
    # bind to click event on individual input elements
    # to prevent default th click behaviour
    $dataTable.find("thead th input").click @clickHeadInput

    @dataTable = $dataTable.dataTable
      sDom: "<'row-fluid'<'span4'l><'span8'f>r>t<'row-fluid'<'span6'i><'span6'p>>"
      sScrollX: "100%"
      bProcessing: true
      bServerSide: true
      sAjaxSource: $dataTable.data "source"
      sPaginationType: "bootstrap"
      # TODO: should be translated
      oLanguage:
        oPaginate:
          sFirst: "First"
          sLast: "Last"
          sNext: "Next"
          sPrevious: "Previous"
        sEmptyTable: "No data available in table"
        sInfo: "Showing _START_ to _END_ of _TOTAL_ entries"
        sInfoEmpty: "Showing 0 to 0 of 0 entries"
        sInfoFiltered: "(filtered from _MAX_ total entries)"
        sLengthMenu: "Show _MENU_ entries"
        sLoadingRecords: "Loading..."
        sProcessing: "Processing..."
        sSearch: "Search in all columns:"
        sZeroRecords: "No matching records found"

    # do not focus on table headers when moving with tabs between column filters
    @$("thead th").attr "tabindex", "-1"

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
