#ifdef GL_ES
precision lowp float;
#endif

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}




varying vec4 v_fragmentColor;

void main()
{
//  vec2 ras = vec2(CC_Random01[0], CC_Random01[1]);
    gl_FragColor = vec4(1, 0.5, gl_FragCoord.x, 1);
//    vec2 yeah = gl_FragCoord.xy * CC_Random01[0];
  //  gl_FragColor = vec4(0.7 + rand(yeah* 1.0) / 0.3, rand(yeah * 2.0), rand(yeah *31.0),  1.0);
    
}
