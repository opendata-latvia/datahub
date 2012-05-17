$.fn.autoSluggify = ->
  @each ->
    $target = $(this)
    $source = $($target.data("auto-sluggify"))

    shouldSluggify = ->
      not $target.val() or $target.val() == Inflector.sluggify($source.val())
    doSluggify = shouldSluggify()

    $source.on "keyup.autoSluggify", ->
      $target.val Inflector.sluggify($source.val()) if doSluggify

    $target.on "change", ->
      doSluggify = shouldSluggify()

jQuery ->
  $("input[data-auto-sluggify]").autoSluggify()
