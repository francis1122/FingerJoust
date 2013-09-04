#ifdef GL_ES
precision mediump float;
#endif

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


uniform sampler2D CC_Texture0;
varying vec2 v_texCoord;

varying vec4 v_fragmentColor;


void main( ) {
    // old default shader
    // gl_FragColor = texture2D( CC_Texture0, v_texCoord );
    // new greyscale shader

      vec4 color = texture2D( CC_Texture0, v_texCoord );
    if(color.a < .9){
        gl_FragColor = vec4(0.0,0.0,0.0,0.0);
    }else{
        color.r = 1.0;
        vec2 yeah = v_texCoord * CC_Random01[0];
        color.g = 0.5 + rand(yeah)/0.5;
        color.b = 0.5 + rand(yeah * 2.0)/0.5;
        gl_FragColor = color;
    }

    
//      vec4 color = texture2D( CC_Texture0, v_texCoord );
//    float grey = color.r * 0.212 + color.g * 0.715 + color.b * 0.072;
//    float test = rand(v_texCoord);


    
  //  gl_FragColor = v_fragmentColor * vec4( 1, rand(v_texCoord * 2.0), rand(v_texCoord * 3.0), color.a);
    
//    gl_FragColor = vec4( mod(rand(v_texCoord),100.0)/100.0 , mod(rand(v_texCoord),100.0)/100.0, mod(rand(v_texCoord),100.0)/100.0, 1 );
}



