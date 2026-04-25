local Vectors = {}

function Vectors.vectorNormalize(vector)
    local vectorLength = math.sqrt(vector[1]^2 + vector[2]^2 + vector[3]^2)
    local unitVector = {0, 0, 0}
    for i in ipairs(unitVector) do
        unitVector[i] = vector[i]/vectorLength
    end
    return unitVector
end

function Vectors.crossProduct(v, u)
    return {
        v[2]*u[3]-v[3]*u[2],
        v[3]*u[1]-v[1]*u[3],
        v[1]*u[2]-v[2]*u[1]
    }
end

function Vectors.vectorMultiplier(v, u)
    return v[1]*u[1] + v[2]*u[2] + v[3]*u[3]
end

return Vectors