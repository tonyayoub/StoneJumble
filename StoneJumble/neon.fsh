float stepping(float t)
{
    if(t<0.)
    {
        return -1.+pow(1.+t,2.);
    }
    else
    {
        return 1.-pow(1.-t,2.);
    }
}
void mainImage( out vec4 gl_FragColor, in vec2 gl_FragCoord )
{
    vec2 uv = (gl_FragCoord*2.-u_sprite_size.xy)/u_sprite_size.y;
    gl_FragColor = vec4(0);
    uv = normalize(uv) * length(uv);
    for(int i=0;i<12;i++)
    {
        float t = u_time + float(i)*3.141592/12.*(5.+1.*stepping(sin(u_time*3.)));
        vec2 p = vec2(cos(t),sin(t));
        p *= cos(u_time + float(i)*3.141592*cos(u_time/8.));
        vec3 col = cos(vec3(0,1,-1)*3.141592*2./3.+3.141925*(u_time/2.+float(i)/5.)) * 0.5 + 0.5;
        gl_FragColor += vec4(0.05/length(uv-p*0.9)*col,1.0);
    }
    gl_FragColor.xyz = pow(gl_FragColor.xyz,vec3(3.));
    gl_FragColor.w = 1.0;
}