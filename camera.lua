local matrix = require(hex3D.path ..'.matrices')
local vectors = require(hex3D.path .. '.vectors')
local vectorNormalize = vectors.vectorNormalize
local crossProduct = vectors.crossProduct

function Camera3D()
    local cam = {
        position = {0,  0,  -1},
        viewDirection = {0, 0, 0},
        upVector = {0, 1, 0},
        fov = hex3D.fieldOfView,
        nearClip = 0.01,
        farClip = 10,
        screenRatio = hex3D.dimensions.width/hex3D.dimensions.height,
        angle = {0, 0}
    }
    cam.projectionMatrix = matrix.projectionMatrix(cam.fov, cam.nearClip, cam.farClip, cam.screenRatio)
    cam.viewMatrix = matrix.lookAt(cam.position, cam.viewDirection, cam.upVector)

    function cam:updateViewDirection()
        self.viewDirection[1] = self.position[1] - math.sin(self.angle[1]) * math.cos(self.angle[2])
        self.viewDirection[2] = self.position[2] - math.sin(self.angle[2])
        self.viewDirection[3] = self.position[3] - math.cos(self.angle[1]) * math.cos(self.angle[2])
    end

    function cam:FPVmovement(dt)
        local forward = vectorNormalize({self.position[1] - self.viewDirection[1], self.position[2] - self.viewDirection[2], self.position[3] - self.viewDirection[3]})
        local right = vectorNormalize(crossProduct(self.upVector, forward))
        if love.keyboard.isDown('w') then
            self.position[1] = self.position[1] + forward[1] * dt
            self.position[2] = self.position[2] + forward[2] * dt
            self.position[3] = self.position[3] + forward[3] * dt
        end
        if love.keyboard.isDown('s') then
            self.position[1] = self.position[1] - forward[1] * dt
            self.position[2] = self.position[2] - forward[2] * dt
            self.position[3] = self.position[3] - forward[3] * dt
        end
        if love.keyboard.isDown('a') then 
            self.position[1] = self.position[1] - right[1] * dt
            self.position[2] = self.position[2] - right[2] * dt
            self.position[3] = self.position[3] - right[3] * dt
        end
        if love.keyboard.isDown('d') then 
            self.position[1] = self.position[1] + right[1] * dt
            self.position[2] = self.position[2] + right[2] * dt
            self.position[3] = self.position[3] + right[3] * dt
        end
        if love.keyboard.isDown('space') then 
            self.position[2] = self.position[2] + 1*dt
        end
        if love.keyboard.isDown('lctrl') then 
            self.position[2] = self.position[2] - 1*dt
        end
    end

    function cam:updateAngle(x, y, dx, dy)
        if love.mouse.isDown(2) then
            self.angle[1] = self.angle[1] + dx * 0.01
            self.angle[2] = math.max(math.min(self.angle[2] - dy * 0.01, math.pi/2), -math.pi/2)
        end
    end
    return cam
end

local camera = Camera3D()

return camera