jQuery ->
  initializeWmd = (postfix) ->
    new Markdown.Editor(new Markdown.Converter(),postfix).run()

  $(".wmd-panel").each ->
    initializeWmd($(this).data("wmd"))