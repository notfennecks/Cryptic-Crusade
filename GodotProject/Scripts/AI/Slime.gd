extends KinematicBody2D

export (int) var speed  #Export varaible for run speed.
export (int) var gravity  #Export variable applied gravity.

var velocity = Vector2()  #Sets variable with name "velocity" to empty Vector2().
var facing = 1  #Variaalbe for storing enemey direction.
var health = 3  #Variable for storing health
var invincible = false  #Variable for stroing boolean if the enemy is invincible or not.
var damage = 25

export (PackedScene) var Wood  #Varaible for storing wood resource scene.
export (PackedScene) var Iron  #Varaible for storing iron resource scene.

signal resource_dropped(type1, amount1, type2, amount2, spawn_center, spawn_area)  #Signal or dropping resources when enemy is killed.
signal updated_enemy_health  #Signal for when the health is changed.

var spawn_area  #Variable for storing area extents to determine spawn area size.
var spawn_center  #Varialbe for storing center of spawn area in which resources can spaawn in.
var rand_position = Vector2(0, 0)  #Variable that will store a random position. Set to empty Vector2() at start to prevent errors.

onready var player = get_parent().get_node("Player")


func _ready():  #Runs this function when the scene is loaded.
	emit_signal("updated_enemy_health", health)  #Emits a signal to update the enemy's health.
	$Sprite/AnimationPlayer.play("Run")  #Plays the enemies "Run" animation
	connect("resource_dropped", get_parent(), "drop_resources")  #Connects the "resource_dropped" signal to its parent (Level1-1 tree node).
	#The signal is connect to Level1-1's "drop_resources" function.
	connect("updated_enemy_health", $HealthBar, "_on_Slime_updated_enemy_health")

func _physics_process(delta):  #Function that runs every frame to apply the enemy's physics.
	$Sprite.flip_h = velocity.x > 0  #Flip the sprite based on direction it is moving.
	velocity.y += gravity * delta  #Sets enemy's gravity. Multiply by delta so that gravity magnitude is affected by framerate.
	velocity.x = facing * speed  #Stores enemy movement either left or right (facing) by speed (defined by exported variable).
	velocity = move_and_slide(velocity,Vector2(0,-1))  #This is used to apply actual movement of enemy via move_and_slide().
	for idx in range(get_slide_count()):  #Loops the amount of times the body has collided or changed direction in last call to move_and_slide().
		var collision = get_slide_collision(idx)  #Sets info about last collision in move_and_slide() to variable named "collision".
		if collision.normal.x != 0:  #If the collision's x position is not 0.
			facing = sign(collision.normal.x)  #Reverse facing variable so enemy moves in opposite x direction.
			velocity.y = -100  #Turn the y velocity to -100. So the enemy gives a little jump when it reverses direction.

func take_damage():  #Function for applying damage to enemy.
	spawn_center = $ResourceSpawnArea.global_position  #Sets global position of the node "ResourceSpawnArea" to a variable named "spawn_center".
	spawn_area = $ResourceSpawnArea/CollisionShape2D.shape.extents  #Sets shape extents to a variable name "spawn_area".
	health -= 1  #Take away 1 health from enemy.
	emit_signal("updated_enemy_health", health)  #Emit signal "updated_health" with the current health value.
	if health == 0:  #If health is 0.
		player.gain_experience(5)
		emit_signal("resource_dropped", Wood, randi() % 3, Iron, randi() % 3, spawn_center, spawn_area)  #Emitted signal used for spawning dropped resources.
		invincible = true  #Sets enemy to invincible so you cannot get more resources than intended from enemy.
		set_physics_process(false)  #Stops enemy's physics process.
		$Sprite/AnimationPlayer.play("Death")  #Play enemy "Death" animation.
		
func _on_AnimationPlayer_animation_finished(anim_name):  #When the animation player finishes an animation.
	if anim_name == "Death": #If the animation name is "Death".
		queue_free()  #Delete enemy.

func _on_DamageArea_body_entered(body):
	var target = body #
	if target.name == "Player":
		target.update_health(damage)
		print(target.name, " took ", damage, " damage!")
