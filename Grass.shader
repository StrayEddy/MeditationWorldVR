shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,vertex_lighting;

uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;

uniform float speed = 1.0;
uniform float strength = 0.1;
uniform float detail = 1.0;
uniform vec2 direction = vec2(1.0, 0.0);
uniform float heightOffset = 0.0;

void vertex() {
	float time = TIME * speed + VERTEX.x + VERTEX.z;
	float wind = (sin(time) + cos(time * detail)) * strength * max(0.0, VERTEX.y - heightOffset);
	vec2 dir = normalize(direction);
	VERTEX.xz += vec2(wind * dir.x, wind * dir.y);
	
	ROUGHNESS=roughness;
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
}
