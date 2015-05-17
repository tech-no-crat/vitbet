class Axis
  constructor: (@selector, @size, @low, @high, @defaultValue) ->
    @addStepLabels()
    @initializeSlider()
    @initializeStat(".avg")
    @initializeStat(".avg.weighted", 1)
    @initializeBets()

  addStepLabels: (step) ->
    step ||= (@high - @low) / 10

    for cur in [@low..@high] by step
      label = $(".templates > .step-label").clone()
      label.html(cur)
      label.css("left", @valueToPosition(cur))
      $(@selector).append label

  initializeSlider: () ->
    self = this
    $("#slider").draggable
      axis: "x"
      drag: (event, ui) ->
        ui.position.left = Math.max(0, ui.position.left)
        ui.position.left = Math.min(self.size, ui.position.left)

        $("#slider").removeClass("not-used");
        self.setValue(self.low + (ui.position.left/self.size) * (self.high-self.low))

      @setValue(@defaultValue, true)

  initializeStat: (selector, extraPixels = 0) ->
    val = parseInt($(selector + " .value").html())
    val = @valueToPosition(val)
    $(selector).css("left", (parseInt(val) + parseInt(extraPixels)) + "px")

  initializeBets: ->
    self = this
    $("#axis .bet").each ->
      val = parseInt($(this).children(".value").html())
      console.log val
      $(this).css("left", self.valueToPosition(val) + "px")

  valueToPosition: (value) -> @size * (value-@low)/(@high-@low)

  setValue: (value, move = false) ->
        self.value = value
        $("#slider #value").html(Math.floor(value))
        $("#bet-at-label").html(Math.floor(value))
        $("#bet-at").val(Math.floor(value))
        if move
          $("#slider").css("left", @valueToPosition(value))


$(document).ready ->
  new Axis("#axis", 960, 10000, 20000, 19000)
