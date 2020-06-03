shader_type canvas_item;

uniform int numberOfColors : hint_range(1, 12);
uniform vec4 C1 : hint_color;
uniform vec4 C2 : hint_color;
uniform vec4 C3 : hint_color;
uniform vec4 C4 : hint_color;
uniform vec4 C5 : hint_color;
uniform vec4 C6 : hint_color;
uniform vec4 C7 : hint_color;
uniform vec4 C8 : hint_color;
uniform vec4 C9 : hint_color;
uniform vec4 C10 : hint_color;
uniform vec4 C11 : hint_color;
uniform vec4 C12 : hint_color;

void fragment(){
	vec4 referenceColors[12];
	referenceColors[0] = C1;
	referenceColors[1] = C2;
	referenceColors[2] = C3;
	referenceColors[3] = C4;
	referenceColors[4] = C5;
	referenceColors[5] = C6;
	referenceColors[6] = C7;
	referenceColors[7] = C8;
	referenceColors[8] = C9;
	referenceColors[9] = C10;
	referenceColors[10] = C11;
	referenceColors[11] = C12;
	
	vec4 textureColor = texture(TEXTURE, UV);
	COLOR = vec4(0.0, 0.0 ,0.0, 0.0);
	COLOR.rgb = referenceColors[int(floor(textureColor.r * float(numberOfColors)))].rgb;
	COLOR.a = textureColor.a;
}