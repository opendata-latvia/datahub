# main application namespace
window.Datahub = {}

jQuery ->
  $("input[data-auto-sluggify]").autoSluggify()