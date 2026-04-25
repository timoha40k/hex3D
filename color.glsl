vec4 effect(vec4 color, Image texture, vec2 texCoords, vec2 screenCoords)
{
    return vec4(gl_FragCoord.xyz / gl_FragCoord.w, 1.0);
}
