extends Node2D

@export var pipe_scene : PackedScene
@onready var die_sfx: AudioStreamPlayer2D = $die_sfx


var game_running : bool
var game_over : bool
var scroll
var score : int
var init_high_score : int
var save_data = {
	"high_score": 0
}
var hit_count : int = 1
const SCROLL_SPEED : int = 4
var screen_size : Vector2i
var ground_height : int
var pipes : Array
const PIPE_DELAY : int = 100
const PIPE_RANGE : int = 200
var ground_running : bool = true

func _ready() -> void:
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	load_high_score()
	new_game()

func new_game():
	# resetting variables
	$Bird.fallsound = 1
	hit_count = 1
	#$Pipe
	game_running = false
	game_over = false
	ground_running = true
	score = 0
	$Background/ScoreLabel.text = "Score: " + str(score)
	scroll = 0
	$GameOver.hide()
	# deletes all pipes after starting new game
	get_tree().call_group("pipes", "queue_free")
	pipes.clear()
	# generate starting pipes
	generate_pipes()
	$Bird.reset()

func _input(event: InputEvent) -> void:
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				else:
					if $Bird.flying:
						$Bird.flap()
						check_top()
				

func start_game():
	init_high_score = save_data["high_score"]
	$GameOver/HighScoreLabel.text = "High Score: " + str(init_high_score)
	game_running = true
	$Bird.flying = true
	$Bird.flap()
	# starting pipe timer
	$PipeTimer.start()

func _process(delta: float) -> void:
	if ground_running:
		scroll += SCROLL_SPEED
		if scroll >= screen_size.x:
			scroll = 0
	$Ground.position.x = -scroll
	if game_running:
		# move pipes
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED

func _on_pipe_timer_timeout():
	generate_pipes()
	
func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	pipe.score.connect(scored)
	add_child(pipe)
	pipes.append(pipe)

func check_top():
	if $Bird.position.y < 0:
		$Bird.falling = true
		stop_game()

func stop_game():
	$PipeTimer.stop()
	print("Your score: " + str(score))
	if score > save_data["high_score"]:
		print("This is your highest score!")
		save_data["high_score"] = score
		$GameOver/HighScoreLabel.text = "High Score: " + str(score)
		save_high_score()
	else:
		$GameOver/HighScoreLabel.text = "High Score: " + str(save_data["high_score"])
	$Bird.flying = false
	game_running = false
	game_over = true
	ground_running = false
	$GameOver.show()

func bird_hit():
	$Bird.falling = true
	if(hit_count == 1):
		die_sfx.play()
		hit_count = 0
	stop_game()
	pass

func scored():
	score += 1
	$Background/ScoreLabel.text = "Score: " + str(score)
	
func _on_ground_hit() -> void:
	$Bird.falling = false
	if(hit_count == 1):
		die_sfx.play()
		hit_count = 0
	stop_game()

func save_high_score():
	var file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	file.store_var(save_data)
	file.close()

func load_high_score():
	if FileAccess.file_exists("user://savegame.save"):
		var file = FileAccess.open("user://savegame.save", FileAccess.READ)
		save_data = file.get_var()
		file.close()

func _on_game_over_restart() -> void:
	new_game()

#func die_fall_sound():
	#die_sfx.play()
	
	
	
