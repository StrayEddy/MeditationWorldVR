shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform sampler2D texture_normal : hint_normal;
uniform float normal_scale : hint_range(-16,16);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform sampler2D noise;

float wave(vec2 position) {
  position += texture(noise, position / 400.0).x * 2.0 - 1.0;
  vec2 wv = 1.0 - abs(sin(position));
  return pow(1.0 - pow(wv.x * wv.y, 0.65), 4.0);
}

float height(vec2 position, float time) {
	float h = wave((position + time)*0.4);
	return h;
}

void vertex() {
	float x = TIME/10.;
	UV=UV*uv1_scale.xy+vec2(x, uv1_offset.y);
	
	vec2 pos = VERTEX.xz;
	float k = height(pos, TIME);
	VERTEX.y = k/3.;
	NORMAL = normalize(vec3(k - height(pos + vec2(30, 0.0), TIME), 30, k - height(pos + vec2(0.0, 30), TIME)));
}

void fragment() {
	vec2 base_uv = UV;
//	vec4 albedo_tex = texture(texture_albedo,base_uv);
//	ALBEDO = albedo.rgb * albedo_tex.rgb;
	ALBEDO = albedo.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
//	NORMALMAP = normalize(texture(texture_normal,base_uv).rgb);
//	NORMALMAP_DEPTH = normal_scale;
}