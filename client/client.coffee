class Axis
  constructor: (@selector, @size, @low, @high, @defaultValue) ->
    @addStepLabels()
    @initializeSlider()

  addStepLabels: (step) ->
    step ||= (@high - @low) / 10
    console.log "Adding step labels from #{@low} to #{@high} with step #{step}"

    for cur in [@low..@high] by step
      console.log cur
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
