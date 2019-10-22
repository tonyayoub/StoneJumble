void main()
{
    vec4 val = texture2D(u_texture, v_tex_coord);
    
    
    if(v_tex_coord.x > 0.5)
    {
        val.g += 0.5;
    }
    gl_FragColor = val;
}


/*
 
 
 
 **************
 very simple (increase the red):
 void main()
 {
    vec4 val = texture2D(u_texture, v_tex_coord);
    val.r += 0.5;
    gl_FragColor = val;
 }
 ***********
 
 */