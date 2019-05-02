--[[----------------------------------------------------------------------------

  Application Name: FeedbackSpot_InspectorP

  Summary:
  Using the feedback spot LED on InspectorP device

  How to Run:
  A connected InpspectorP device with internal illumination is necessary to run this sample.
  InspectorP63x: Alternate between taking live images and flashing green and red feedback spots.
  InspectorP64x/65x: Alternate between taking live images and flashing green feedback spot.
  Starting this sample is possible either by running the app (F5) or debugging (F7+F10).
  Set a breakpoint on the first row inside the main or processImage function to debug step-by-step.
  See the results in the image viewer on the DevicePage.

  More Information:
  See the tutorial "Audio-visual Feedback InspectorP".

------------------------------------------------------------------------------]]
--Start of Global Scope---------------------------------------------------------

--Creation of camera handle and configuration
local camera = Image.Provider.Camera.create()

local config = Image.Provider.Camera.V2DConfig.create()
config:setBurstLength(0) -- Continuous acquisition
config:setFrameRate(1) -- Hz
config:setShutterTime(700) -- us

camera:setConfig(config)

--Creation of viewer handle
local viewer = View.create()

--Creation of feedback LED handle
local feedbackSpot = LED.create('FEEDBACK_LED')
feedbackSpot:setColor('green')
-- Initialize constants
local toggler = true -- Toggler, to be used to alternate feedback spot color in InspectorP63x
local isInspectorP63x = string.find(Engine.getTypeName(), 'InspectorP63')
local DELAY = 300 -- ms delay between image acquisition and feedback spot

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

local function main()
  camera:enable()
  camera:start()
end
Script.register('Engine.OnStarted', main)

local function processImage(im, _)
  viewer:clear()
  viewer:addImage(im)
  viewer:present()
  Script.sleep(DELAY) -- Delay to symbolize image processing
  if isInspectorP63x then -- InspectorP63x also supports red light
    if toggler == true then
      feedbackSpot:setColor('red')
    else
      feedbackSpot:setColor('green')
    end
    toggler = not (toggler)
  end
  feedbackSpot:activate(100)
end
camera:register('OnNewImage', processImage)

--End of Function and Event Scope--------------------------------------------------
