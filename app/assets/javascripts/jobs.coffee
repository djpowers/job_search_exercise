ready = ->
  $('#results a').click (e) ->
    window.open $(this).attr('href'), 'Popup', 'height=750,width=1000'
    e.preventDefault()

$(document).ready(ready)
$(document).on('page:load', ready)
