colors =
  low    : "rgb(60, 160, 189)"
  normal : "rgb(88, 189, 60)"
  high   : "rgb(243, 255, 134)"
  higher : "rgb(255, 168, 80)"
  highest: "rgb(255, 71, 71)"

settings:
  background: true
  color     : true
  brighter  : false
  inverse   : false
  bars      : 100
  animated  : true

command: "~/.asdf/shims/istats"

refreshFrequency: 2000

style: """
  left 15px
  top 15px
  width 315px
  height 70px
"""

render: (output) -> """
  <div id="istatsContainer"></div>
"""

update: (output, domEl) ->
  $(domEl).html(output)
