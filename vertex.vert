extern mat4 transformationMatrix;
extern mat4 projectionMatrix;
extern mat4 viewMatrix;

vec4 position(mat4 transfromProjection, vec4 vertexPosition)
{
    vec4 worldPosition = transformationMatrix*vertexPosition;
    vec4 viewPosition = viewMatrix*worldPosition;
    vec4 screenPosition = projectionMatrix*viewPosition;
    return screenPosition;
}