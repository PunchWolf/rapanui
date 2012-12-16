--[[
-------------------------------------------------------------------------
-- Date: 12/05/2012
-- @Author: niom
-- Multilayer is used to create HUD layer which stays stationary.
-- all objects added to he HUD layer will move with the camera movement
--
--------------------------------------------------------------------------
--]]

-- variables to make our work easier
local screen = RNFactory.screen
local viewport = screen.viewport
local layers = screen.layers
local mainlayer = layers:get(RNLayer.MAIN_LAYER)

-- create camera and place it to the main layer
local camera = MOAICamera2D.new()
--camera:setLoc(300,300)

layers:get(RNLayer.MAIN_LAYER):setCamera(camera)

--create new layers
local backgroundlayer = layers:createLayerWithPartition("background", viewport)
local parallaxlayer = layers:createLayerWithPartition("parallax", viewport)

--set camera to other layers too
backgroundlayer:setCamera(camera)
parallaxlayer:setCamera(camera)

layers:sendToBack(backgroundlayer)
layers:bringToFront(mainlayer)
layers:putOver(parallaxlayer, backgroundlayer)

--set parallax to the parallaxlayer
parallaxlayer:setParallax ( 0.5, 0.5 )

--create backgroud
--if you don't give the layer to the create, the image will be added to the mainlayer
local background = RNFactory.createImageFrom("images/background-landscape-hd.png", backgroundlayer)

--create new image to the game/mainlayer
local gameobject = RNFactory.createImageFrom("images/tile0.png", mainlayer)
gameobject.x = 100
gameobject.y = 100

--create new image to the parallax layer
local parallaxobject = RNFactory.createImageFrom("images/tile1.png", parallaxlayer)
parallaxobject.x = 200
parallaxobject.y = 200

--create new image to the background layer
local bgobject = RNFactory.createImageFrom("images/tile2.png", backgroundlayer)
bgobject.x = 300
bgobject.y = 400

--Move the camera and we can see that the parallax item moves with different
--speed compared to the items on game layer
camera:seekLoc(200, 150, 5)
