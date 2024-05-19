shader_type canvas_item;

uniform float line_thickness : hint_range(0, 20) = 1.0;  // Толщина линии
uniform vec4 outline_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);  // Цвет обводки

void fragment() {
    vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
    
    // Определяем, есть ли альфа вокруг текущего пикселя
    float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
    outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
    outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
    outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
    outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
    outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
    outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
    outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
    outline = step(1.0, outline);  // Если есть альфа, outline будет 1, иначе 0
    
    vec4 color = texture(TEXTURE, UV);
    
    // Если обводка активна и текущий пиксель прозрачный, применяем цвет обводки
    if (outline > 0.0 && color.a < 1.0) {
        COLOR = outline_color;
    } else {
        COLOR = color;
    }
}
