hex3D = {}

hex3D.path = ...

hex3D.nearPlane = 0.01
hex3D.fieldOfView = math.rad(90)
hex3D.fpsController ={
    direction = 0,
    pitch = 0
}

local width, height = love.graphics.getDimensions()
hex3D.dimensions = {width = width, height = height}

hex3D.vertShader = love.graphics.newShader((...):gsub("%.", "/") .. "/vertex.vert")

--Camera3D
hex3D.camera = require(hex3D.path ..'.camera')
hex3D.matrix = require(hex3D.path ..'.matrices')
hex3D.vectors = require(hex3D.path ..'.vectors')
hex3D.object = require(hex3D.path ..'.object3d')


love.graphics.setDepthMode("lequal", true)

local hex3D = hex3D
_G.hex3D = nil
return hex3D