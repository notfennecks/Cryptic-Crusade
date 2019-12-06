extends KinematicBody2D

export (int) var speed #export speed
export (int) var gravity #export gravity

var velocity = Vector2() #velocity is a Vector2 value
var facing = 1 #facing has a value of 1
var health

export (PackedScene) var Wood
export (PackedScene) var Iron

signal resource_dropped(type1, amount1, type2, amount2, spawn_center, spawn_area)

var spawn_area
var spawn_center
var rand_position = Vector2(0, 0)

func _ready():
	health = 1
	print(get_parent().name)
	connect("resource_dropped", get_parent(), "drop_resources")

func _physics_process(delta):
	$Sprite.flip_h = velocity.x > 0 #flip the sprite if he is going the other way so it does not look like hes moonwalking
	velocity.y += gravity * delta #identify y velocity
	velocity.x = facing * speed #identify the x velocity
	velocity = move_and_slide(velocity,Vector2(0,-1)) #change what velocity means only in this function
	for idx in range(get_slide_count()): #loop until you detect the collision or loop and count how many times you collide
		var collision = get_slide_collision(idx) #give info about last collision in move and slide
		if collision.normal.x != 0: #if the collisions x position is not 0
			facing = sign(collision.normal.x) #explain what is facing in the function
			velocity.y = -100 #turn the y velocity to -100
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider.name == "Player":
			return

func take_damage():
	spawn_center = $ResourceSpawnArea.global_position
	spawn_area = $ResourceSpawnArea/CollisionShape2D.shape.extents
	emit_signal("resource_dropped", Wood, 2, Iron, 3, spawn_center, spawn_area)
	health -= 1
	$CollisionShape2D.disabled = true
	set_physics_process(false)
	queue_free()