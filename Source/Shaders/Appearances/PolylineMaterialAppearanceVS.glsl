attribute vec3 position3DHigh;
attribute vec3 position3DLow;
attribute vec3 prevPosition3DHigh;
attribute vec3 prevPosition3DLow;
attribute vec3 nextPosition3DHigh;
attribute vec3 nextPosition3DLow;
attribute vec3 expandWidthAndLength;
attribute vec2 st;
attribute float batchId;

varying float v_width;
varying vec2 v_st;
varying float v_length;
varying float v_angle;
varying vec4 v_positionEC;

void main()
{
    float expandDir = expandWidthAndLength.x;
    float width = abs(expandWidthAndLength.y) + 0.5;
    bool usePrev = expandWidthAndLength.y < 0.0;

    vec4 p = czm_computePosition();
    vec4 prev = czm_computePrevPosition();
    vec4 next = czm_computeNextPosition();

    v_width = width;
    v_st = st;
    v_length = expandWidthAndLength.z;
    v_positionEC = czm_modelViewRelativeToEye * p;

    vec4 positionWC = getPolylineWindowCoordinates(p, prev, next, expandDir, width, usePrev, v_angle);
    gl_Position = czm_viewportOrthographic * positionWC;
}
