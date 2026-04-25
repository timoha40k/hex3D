local Object = {}
local matrix = require(hex3D.path ..'.matrices')

local transformationMatrix = matrix.transformationMatrix
local camera = require(hex3D.path .. '.camera')

local vertShader = hex3D.vertShader
local fieldOfView = hex3D.fieldOfView

Object.vertexFormat = {
        {'VertexPosition', 'float', 3},
        {'VertexTexCoord', 'float', 2},
        {"VertexNormal", 'float', 3},
        {"VertexColor", "byte", 4}
    }

function Object.getObjectVerts(path)
    local result = {}
    local faces = {}
    local position = {}
    local normals = {}
    local texture = {}
    for line in love.filesystem.lines(path) do
        local words = {}
        for word in line:gmatch("([^%s]+)") do
            table.insert(words, word)
        end


        if words[1] =='v' then
            table.insert(position, {tonumber(words[2]), tonumber(words[3]), tonumber(words[4])})
        elseif words[1] == 'vn' then
            table.insert(normals, {tonumber(words[2]), tonumber(words[3]), tonumber(words[4])})
        elseif words[1] == 'vt' then
            table.insert(texture, {tonumber(words[2]),  tonumber(words[3])})
        elseif words[1] == 'f' then
            --table.insert(faces, {words[2], words[3], words[4]})
            local vertices = {}
            for i = 2, #words do 
                local v, vt, vn = words[i]:match "(%d*)/(%d*)/(%d*)"
                v, vt, vn = tonumber(v), tonumber(vt), tonumber(vn)
                table.insert(vertices, {
                v and position[v][1] or 0,  v and position[v][2] or 0, v and position[v][3] or 0,
                vt and texture[vt][1] or 0, vt and texture[vt][2] or 0,
                vn and normals[vn][1] or 0, vn and normals[vn][2] or 0, vn and normals[vn][3] or 0})
            end
            if #vertices > 3 then
                local centralVertex = vertices[1]
                for i = 2, #vertices- 1 do 
                    table.insert(result, centralVertex)
                    table.insert(result, vertices[i])
                    table.insert(result, vertices[i + 1])
                end
            else
                for i = 1, #vertices do
                    table.insert(result, vertices[i])
                end
            end
            --print(words[2], words[3], words[4])
        end


    end

    return result
end

function Object.object3D(originalVertices, texture, translation, rotation, scale, color)
    local mesh = love.graphics.newMesh(Object.vertexFormat, originalVertices, 'triangles')
    if texture ~= nil then
        local meshTexture = love.graphics.newImage(texture)
        mesh:setTexture(meshTexture)
    end
    if type(scale) == "number" then scale = {scale, scale, scale} end
    return {
        shader = vertShader,
        mesh = mesh,
        translation = translation or {0, 0, 0},
        rotation = rotation or {0, 0, 0},
        scale = scale or {1, 1, 1},
        matrix = transformationMatrix(translation or {0, 0, 0}, rotation or {0, 0, 0}, scale or {1, 1, 1}),
        color = color or {255, 255, 255},
        draw = function(self)

            self.shader:send('projectionMatrix', camera.projectionMatrix)
            self.shader:send('transformationMatrix', self.matrix)
            self.shader:send('viewMatrix', camera.viewMatrix)

            love.graphics.setColor(love.math.colorFromBytes(self.color[1], self.color[2], self.color[3]))
            love.graphics.setShader(self.shader)
            love.graphics.draw(self.mesh)
            love.graphics.setShader()
        end,
        updateMatrix = function (self)
            self.matrix = transformationMatrix(self.translation, self.rotation, self.scale)
        end
    }
end

function Object.text2D(text, position)
    local x = (position[1]*fieldOfView)/(position[3]+math.tan(fieldOfView))
    local y = (position[2]*fieldOfView)/(position[3]+math.tan(fieldOfView))
    return {
        text = text,
        position = position,
        draw = function (self)
            love.graphics.print(self.text, x, y)
        end
    }
end

return Object