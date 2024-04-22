shader_type spatial;

uniform sampler2D noise1: repeat_enable;


void fragment() {

	vec4 noiseTexture = texture(noise1, UV + TIME/250.0);

		
	ALBEDO = vec3(noiseTexture.rgb);
	
}
