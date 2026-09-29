extends Area2D
signal pickup
signal hurt

# setup class & state variables
@export var speed: int
var velocity = Vector2()
var screensize = Vector2(480, 720)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_input()
	position += velocity * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.animation = "idle"

func start(pos):
	# called with $Player.start in Main
	set_process(true)
	position = pos
	$AnimatedSprite2D.animation = "idle"

func die():
	$AnimatedSprite2D.animation = "hurt"
	set_process(false) # dead so stop processing
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("coins"):
		area.pickup() # area would be coin object then
		emit_signal("pickup")
	if area.is_in_group("obstacles"):
		emit_signal("hurt")
		die()

func get_input():
	# reset velocity
	velocity = Vector2()
	
	# if not else if for diagonals (up + left or the like)
	if Input.is_action_just_pressed("left_pressed"):
		velocity.x -= 1
	if Input.is_action_just_pressed("right_pressed"):
		velocity.x += 1
	if Input.is_action_just_pressed("up_pressed"):
		velocity.y -= 1
	if Input.is_action_just_pressed("down_pressed"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
