extends Node2D

@export var Coin: PackedScene
@export var playtime: int

var level
var score
var time_left
var screensize
var playing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	screensize = get_viewport_rect().size
	$Player.screensize = screensize
	$Player.hide()
	new_game()

func _process(_delta: float) -> void:
	if playing and $CoinContainer.get_child_count() == 0:
		level += 1
		time_left += 5
		spawn_coins()

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	
	$Player.start($PlayerStart.position)
	$Player.show()
	$GameTimer.start()
	spawn_coins()
	
func spawn_coins():
	# set 4 to whatever you want
	for i in range(4 + level):
		var c = Coin.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		$CoinContainer.add_child(c)
		# c.screensize = screensize # not needed 
		#(screen size is already set with Player)
		c.position = Vector2(randi_range(0, screensize.x), 
			randi_range(0, screensize.y))
		# position is important - cause set at random location

func _on_player_pickup() -> void:
	score += 1
	$HUD.update_score(score)
	
func _on_Player_hurt():
	game_over()
		
func game_over():
	playing = false
	$GameTimer.stop()
	for coin in $CoinContainer.get_children():
			coin.queue_free()
	$HUD.show_game_over()
	$Player.die()

func _on_GameTimer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()
	
