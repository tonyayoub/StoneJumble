void main()
{
    
    // Load the pixel from our original texture, and the same place in the gradient circle
    vec4 val = texture2D(u_texture, v_tex_coord);
    vec4 grad = texture2D(u_gradient, v_tex_coord);
    
    // [1 - ORIGINAL CHECK] If the original is transparent AND
    // [2 - HEALTH CHECK] The gradient image has a black value less than the remaining health AND
    // [3 - MASKING] The gradient pixel is not transparent
    

    if (grad.r > 0.0)
    {
       val.r += 0.2;
    }
    gl_FragColor = val;

}