varying mediump vec2 var_texcoord0;
uniform lowp sampler2D tex0, tex1;

uniform lowp vec4 elevation_water;
uniform lowp vec4 elevation_sand;
uniform lowp vec4 elevation_grass;
uniform lowp vec4 elevation_rock;

uniform lowp vec4 color_water;
uniform lowp vec4 color_sand;
uniform lowp vec4 color_grass;
uniform lowp vec4 color_rock;

uniform lowp vec4 base_coldness;

uniform lowp vec4 light_position;

#define LevelCount 5

const int LevelWater = 0;
const int LevelSand = 1;
const int LevelGrass = 2;
const int LevelRock = 3;
const int LevelSnow = 4;

struct Level {
	float elevation;
	int name;
};

void main() {
	Level levels[4];
	levels[0] = Level(elevation_water.x, LevelWater);
	levels[1] = Level(elevation_sand.x, LevelSand);
	levels[2] = Level(elevation_grass.x, LevelGrass);
	levels[3] = Level(elevation_rock.x, LevelRock);
	
	vec3 colors[5];
	colors[LevelWater] = color_water.rgb;
	colors[LevelSand] = color_sand.rgb;
	colors[LevelGrass] = color_grass.rgb;
	colors[LevelRock] = color_rock.rgb;
	colors[LevelSnow] = vec3(1, 1, 1);
	
	float elevation = texture2D(tex0, var_texcoord0).x;

	float coldness = base_coldness.x + 2.0 * abs(var_texcoord0.y - 0.5) + 0.75 * pow(elevation, 2.5);
	Level level;
	for (int i = 0; i < LevelCount; ++i) {
		if (elevation < levels[i].elevation) {
			level = levels[i];
			break;
		}
	}

	vec3 color;
	if (coldness > 0.8 && level.name != LevelWater) {
		color = colors[LevelSnow];
	} else {
		color = colors[level.name];
	}
	
	vec3 normal;
	if (level.name == LevelWater) {
		vec3 normal_color = texture2D(tex1, fract(vec2(10.0 * var_texcoord0.x, 20.0 * var_texcoord0.y))).rgb;
		normal = 0.25 * normalize(normal_color * 2.0 - 1.0);
	} else {
		vec3 normal_color = texture2D(tex1, var_texcoord0).rgb;
		normal = normalize(normal_color * 2.0 - 1.0);
	}

	vec3 light_direction = normalize(light_position.xyz);
	float diffuse_brightness = clamp(dot(light_direction, normal), 0.0, 1.0);
	gl_FragColor = vec4((0.5 * diffuse_brightness + 0.75) * color, 1.0);
}