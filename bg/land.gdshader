shader_type canvas_item;

// Time uniform to animate the landscape
uniform float iTime;

// Noise texture; OpenSimplexNoise is great, but any filtered texture is fine.
uniform sampler2D noise;

// Colors for the landscape
uniform vec4 lava_color: source_color = vec4(1.0, 0.2, 0.0, 1.0);
uniform vec4 rock_color: source_color = vec4(0.2, 0.1, 0.0, 1.0);
uniform vec4 smoke_color: source_color = vec4(0.1, 0.1, 0.1, 0.5);

// Function to get UV coordinates in a canvas_item shader

// Function to generate noise
float rand(vec2 uv) {
    float frequency = 1.0;
    float amplitude = 1.0;
    float output = 0.0;
    float totalAmplitude = 0.0;
    
    for (int i = 0; i < 5; i++) {
        output += texture(noise, uv * frequency).x * amplitude;
        totalAmplitude += amplitude;
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    
    return output / totalAmplitude;
}

// Function to generate distortion
vec2 noise_distortion(vec2 uv, float time, vec2 velocity) {
    float noise_value1 = texture(noise, uv + time * velocity).x;
    float noise_value2 = texture(noise, uv + vec2(0.25) + time * velocity * 1.3).x;

    float d1 = mod(uv.x + uv.y, 6.28318); // 6.28318 = 2 * PI
    float d2 = mod((uv.x + uv.y + 0.25) * 1.3, 18.84956); // 18.84956 = 6 * PI

    d1 = time * 0.07 + d1;
    d2 = time * 0.5 + d2;

    vec2 dist = vec2(
        sin(d1 + noise_value1 * 6.28318) * 0.15 + sin(d2 + noise_value2 * 18.84956) * 0.05,
        cos(d1 + noise_value1 * 6.28318) * 0.15 + cos(d2 + noise_value2 * 18.84956) * 0.05
    );

    return dist;
}

void fragment() {
    vec2 uv = UV;
    
    // Distort UV coordinates to create a dynamic effect
    vec2 dist = noise_distortion(uv, iTime, vec2(0.2, 0.3));
    vec2 uv_distorted = uv + dist;

    // Generate lava noise
    float lava_noise = rand(uv_distorted * 2.0 + iTime * 0.2);

    // Generate rock noise
    float rock_noise = rand(uv_distorted * 5.0 - iTime * 0.1);

    // Blend lava and rock colors based on noise
    vec4 color = mix(rock_color, lava_color, lava_noise);

    // Add some smoke effect
    float smoke = smoothstep(0.4, 0.6, lava_noise) * 0.5;
    color = mix(color, smoke_color, smoke);

    COLOR = color;
}
