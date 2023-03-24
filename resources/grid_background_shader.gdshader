shader_type canvas_item;

uniform vec4 background_color : source_color;
uniform vec4 grid_color : source_color;

uniform vec2 grid_offset = vec2(0,0);
uniform float grid_zoom = 1;

const float grid_intensity = 0.7;

float grid(vec2 fragCoord, float space, float gridWidth)
{
    vec2 p  = fragCoord - vec2(.5);
    vec2 size = vec2(gridWidth);
    
    vec2 a1 = mod(p - size, space);
    vec2 a2 = mod(p + size, space);
    vec2 a = a2 - a1;
       
    float g = min(a.x, a.y);
    return clamp(g, 0., 1.0);
}

void fragment() {
	vec4 col = background_color;
	
	vec2 st = FRAGCOORD.xy / grid_zoom;
	st += grid_offset;

    float m = clamp(grid(st, 10., .5) * grid(st, 100., 1.), grid_intensity, 1.0);
	
	col = mix(grid_color, col, m);
	
    COLOR = vec4(col);
}
