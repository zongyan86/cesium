uniform vec4 color;
uniform vec4 gapColor;
uniform float dashLength;
uniform float dashPattern;
varying float v_angle;
varying float v_length;

const float maskLength = 16.0;

mat2 rotate(float rad) {
    float c = cos(rad);
    float s = sin(rad);
    return mat2(
        c, s,
        -s, c
    );
}

czm_material czm_getMaterial(czm_materialInput materialInput)
{
    czm_material material = czm_getDefaultMaterial(materialInput);

    vec4 positionEC = vec4(materialInput.positionToEyeEC, 1.0);
    //vec4 positionEC = czm_modelView * vec4(vec3(0.0), 1.0);
    float dashPosition = fract(v_length / (dashLength * czm_metersPerPixel(positionEC)));

    //vec2 pos = rotate(v_angle) * gl_FragCoord.xy;
    // Get the relative position within the dash from 0 to 1
    //float dashPosition = fract(pos.x / dashLength);

    // Figure out the mask index.
    float maskIndex = floor(dashPosition * maskLength);
    // Test the bit mask.
    float maskTest = floor(dashPattern / pow(2.0, maskIndex));
    vec4 fragColor = (mod(maskTest, 2.0) < 1.0) ? gapColor : color;
    if (fragColor.a < 0.005) {   // matches 0/255 and 1/255
        discard;
    }

    material.emission = fragColor.rgb;
    material.alpha = fragColor.a;
    return material;
}
