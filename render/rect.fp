varying mediump vec2 var_texcoord0;
uniform lowp sampler2D tex0, tex1;

uniform lowp vec4 elevation_water;
uniform lowp vec4 elevation_sand;
uniform lowp vec4 elevation_grass;
uniform lowp vec4 elevation_rock;

vec3 light_direction = normalize(vec3(1.0, -1.0, 0.0));

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
	colors[LevelWater] = vec3(0.2, 0.5, 1);
	colors[LevelSand] = vec3(0.8, 0.9, 0.6);
	colors[LevelGrass] = vec3(0.2, 0.8, 0.4);
	colors[LevelRock] = vec3(0.7, 0.7, 0.7);
	colors[LevelSnow] = vec3(1, 1, 1);
	float elevation = texture2D(tex0, var_texcoord0).x;
	vec3 normal_color = texture2D(tex1, var_texcoord0).rgb;
	vec3 normal = normalize(normal_color * 2.0 - 1.0);

	float coldness = 2.0 * abs(var_texcoord0.y - 0.5) + 0.75 * pow(elevation, 2.5);
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
		if (level.name == LevelWater) {
			normal *= 0.1;
		}
	}

	float diffuse_brightness = clamp(dot(light_direction, normal), 0.0, 1.0);
	gl_FragColor = vec4((0.5 * diffuse_brightness + 0.75) * color, 1.0);
}