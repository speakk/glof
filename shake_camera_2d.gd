extends Camera2D

@export var decay = 0.8  # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(50, 50)  # Maximum hor/ver shake in pixels.
@export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].

@onready var noise = FastNoiseLite.new()
var noise_y = 1

func _ready():
	randomize()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	#noise.fractal_octaves = 2
	#noise.frequency = 0.01
	#noise.fractal_gain = 1
	
	#noise.period = 4
	#noise.fractal_octaves = 2

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func shake():
	var amount = pow(trauma, trauma_power)
	print("Amount?", amount)
	noise_y += 1
	#rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	print("Getting noise", noise.get_noise_2d(noise.seed*2, noise_y))
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
	print("OFfset", offset)
