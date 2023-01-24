extends Node2D

const Player = preload("res://player.tscn")

var level_timer = 0
var paused = false
var finished = false
var current_level_id = null
var player_node = null
var camera_node = null

var player_has_moved = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.end_zone_hit.connect(_on_end_zone_hit)
	Events.player_has_moved.connect(_on_player_has_moved)
	Events.in_game_entered.emit()

func _exit_tree():
	Events.in_game_exited.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not paused and player_has_moved:
		level_timer += delta
		Events.level_timer_changed.emit(level_timer)
		
		if Input.is_action_just_pressed("restart_level"):
			Events.try_again_pressed.emit()

func _on_player_has_moved():
	player_has_moved = true
	%HasMovedLabel.visible = false

func load_level(level_id):
	if $LevelContainer.get_child_count() > 0:
		$LevelContainer.get_child(0).queue_free()
	
	$LevelContainer.add_child(load(Levels.get_by_id(level_id).path).instantiate())
	current_level_id = level_id
	
	var player = Player.instantiate()
	var start_position = $LevelContainer.get_child(0).get_player_start_position()
	player.global_position = start_position
	add_child(player)
	player_node = player
	
	var camera = Camera2D.new()
	camera.current = true
	player.add_child(camera)
	camera_node = camera

func get_current_level_id():
	return current_level_id

func _finish_level():
	paused = true
	finished = true
	Levels.save_level_time(current_level_id, "speak", level_timer)
	Events.level_finished.emit(current_level_id, level_timer)
	%FinishedScreen.show()

func _on_end_zone_hit(zone, by):
	if "is_player" in by and by.is_player and not finished:
		_finish_level()


func disable_main_camera():
	camera_node.current = false

func enable_main_camera():
	camera_node.current = true
