local Matrices = {}

local vectors = require(hex3D.path .. '.vectors')
local vectorNormalize = vectors.vectorNormalize
local crossProduct = vectors.crossProduct
local vectorMultiplier = vectors.vectorMultiplier

function Matrices.transformationMatrix(translation, rotation, scale)
    local tz = translation
    local ca, cb, cc = math.cos(rotation[3]), math.cos(rotation[2]), math.cos(rotation[1])
    local sa, sb, sc = math.sin(rotation[3]), math.sin(rotation[2]), math.sin(rotation[1])
    --First three is rotation (idk how it works, see wikipedia), the fourth one is translation with camera
    local matrix = {
        ca*cb, ca*sb*sc - sa*cc, ca*sb*cc + sa*sc, -tz[1],
        sa*cb, sa*sb*sc + ca*cc, sa*sb*cc - ca*sc, -tz[2],
        -sb, cb*sc, cb*cc, -tz[3],
        0, 0, 0, 1
    }
    local sx, sy, sz = scale[1], scale[2], scale[3]
    matrix[1], matrix[2],  matrix[3]  = matrix[1] * sx, matrix[2]  * sy, matrix[3]  * sz
    matrix[5], matrix[6],  matrix[7]  = matrix[5] * sx, matrix[6]  * sy, matrix[7]  * sz
    matrix[9], matrix[10], matrix[11] = matrix[9] * sx, matrix[10] * sy, matrix[11] * sz

    return matrix
end

function Matrices.projectionMatrix(fov, near, far, screenRatio)
    local top = near* math.tan(fov/2)
    local bottom = -1* top
    local right = top * screenRatio
    local left = -1*right
    return{
        near/right, 0, 0, 0,
        0, near/bottom, 0, 0,
        0, 0, far/(far-near), -far*near/(far-near),
        0, 0, 1, 0
    }
end

function Matrices.lookAt(position, viewDirection, cameraUp)
    local forward = vectorNormalize({position[1] - viewDirection[1], position[2] - viewDirection[2], position[3] - viewDirection[3]})
    local right = vectorNormalize(crossProduct(cameraUp, forward))
    local up = crossProduct(right, forward)
    local viewMatrix = {
        right[1], right[2], right[3], -vectorMultiplier(right, position),
        up[1], up[2], up[3], -vectorMultiplier(up, position),
        forward[1], forward[2], forward[3], -vectorMultiplier(forward, position),
        0, 0, 0, 1
    }
    return viewMatrix
end

return Matrices