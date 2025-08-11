extends CharacterBody2D

@onready var die_sfx: AudioStreamPlayer2D = $die_sfx
@onready var jump_sfx: AudioStreamPlayer2D = $jump_sfx
const GRAVITY : int = 1000
const MAX_VEL : int = 600
const FLAP_SPEED : int = -500
var flying : bool = false
var falling : bool = false
const START_POS = Vector2(100.0, 400.0)

var fallsound : int = 1

func _ready() -> void:
	reset()

func reset():
	falling = false
	flying = false
	position = START_POS
	set_rotation(0)

func _physics_process(delta: float) -> void:
	if flying or falling:
		velocity.y += GRAVITY * delta
		# terminal velocity
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			$AnimatedSprite2D.play()
		elif falling:
			if(fallsound == 1):
				print("Falling")
				die_sfx.play()
				fallsound = 2;
			
			set_rotation(PI/2)
			$AnimatedSprite2D.stop()
		move_and_collide(velocity * delta)
	else:
		$AnimatedSprite2D.stop()

func flap():
	velocity.y = FLAP_SPEED
	jump_sfx.play()
	
