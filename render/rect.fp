varying mediump vec2 var_texcoord0;
uniform lowp sampler2D tex0;

void main() {
	vec4 tex_color = texture2D(tex0, var_texcoord0);
	gl_FragColor = vec4(tex_color.rgb, tex_color.a);
}