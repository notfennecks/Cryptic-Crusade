extends KinematicBody2D

export (int) var player_speed  #Exported variable for player run speed.
export (int) var jump_height  #Exported variable for player jump height.
export (int) var gravity  #Exported variable for gravity applied to player.
export (int) var max_jumps  #Exported variable for max player jumps.
export (int) var level = 1  #Exported variabe for what level the player is in

var jump_count = 0 #Variable that tracks jump count.
var just_landed = false
var p_direction = "right"
var invincible = false

export (PackedScene) var AfterImage
var after_image_count = 0

var pre_angle  #Variable for storing angle before calculation.

export (float) var arrow_rate  #exported variable for how fast the arrow shoots.
var can_shoot = true  #If the player can fire an arrow.
signal shoot  #Signal that tracks if the player shot.
var angle  #Variable for storing 360 angle in relation between player and mouse.

enum {IDLE, RUN, JUMP, DEAD, HURT}  #Declaring states as enumerated types.
var state  #Variable state to track current state.
export (int) var max_health = 100
var health
var experience = 0
var experience_total = 0
var experience_required = get_required_experience(level + 1) #experience required is determined by the get required experience function
signal experience_gained #create experience gained signal
signal level_up

export (bool) var Bow = false
export (bool) var Sword = false

enum {NEUTRAL, FIRE, ICE, DARK, LIGHT} #Declaring all possible stances as enumerated types.
var stance  #Variable for tracking current stance.
var can_switch_stance = true #Variable for if the player can change their stance.

var stance_particles = [ "Fire", "Ice", "Dark", "Light" ]

var velocity = Vector2()  #Variable velocity to store and apply player movement.
onready var exp_bar = get_parent().get_child(0).get_child(2).get_child(1)
onready var health_bar = get_parent().get_child(0).get_child(2).get_child(0)
onready var hud = get_parent().get_child(0).get_child(2)

func _ready():  #Runs function soon as scene is loaded.
	health = max_health
	change_stance(NEUTRAL)  #Changes stance to NEUTRAL.
	change_state(IDLE)  #Changes state to IDLE.
	$ArrowTimer.wait_time = arrow_rate
	connect("experience_gained", exp_bar, "gain_experience")
	connect("level_up", exp_bar, "level_up")
	health_bar.max_value = max_health

func change_state(new_state):  #Runs function when state needs to be changed. Taking the new_state as argument.
	state = new_state  #Sets the state variable to the state it needs to change to.
	match state:  #Matches the state with its correct name and runs the embedded code.
		IDLE:
			$Sprite.animation = "Idle"  #Switches to correct idle animation based on current stance.
			$Sprite.playing = true
		RUN:
			$Sprite.animation = "Run"
			$Sprite.playing = true
		JUMP:
			print("Jump state")
		DEAD:
			get_tree().reload_current_scene()
		HURT:
			$Sprite/AnimationPlayer.play("Hurt")
			$Hurt.play()
			$HurtTimer.start()
			invincible = true


func change_stance(new_stance):  #Runs function when stance needs to be changed. Taking new_stance as argument.
	stance = new_stance  #Sets the stance variable to the stance player wanted to change to.
	match stance:  #Matches the current stance with its respective name and runs embedded code.
		NEUTRAL:
			print("Neutral stance")
			$Sprite.self_modulate = Color(1, 1, 1, 1)
			for i in range(stance_particles.size()):
				get_node(stance_particles[i]).hide()
		FIRE:
			print("Fire stance")
			$Sprite.self_modulate = Color(1, 0, 0, 1)
			get_node(stance_particles[0]).show()
			for i in range(stance_particles.size()):
				if i == 0:
					continue
				get_node(stance_particles[i]).hide()
		ICE:
			print("Ice stance")
			$Sprite.self_modulate = Color(.45, 1, 1, 1)
			get_node(stance_particles[1]).show()
			for i in range(stance_particles.size()):
				if i == 1:
					continue
				get_node(stance_particles[i]).hide()
		DARK:
			print("Dark stance")
			$Sprite.self_modulate = Color(.61, .3, 1, 1)
			get_node(stance_particles[2]).show()
			for i in range(stance_particles.size()):
				if i == 2:
					continue
				get_node(stance_particles[i]).hide()
		LIGHT:
			print("Light stance")
			$Sprite.self_modulate = Color(1, 1, .42, 1)
			get_node(stance_particles[3]).show()
			for i in range(stance_particles.size()):
				if i == 3:
					continue
				get_node(stance_particles[i]).hide()
		
func _on_StanceTimer_timeout():
	can_switch_stance = true
	
func _physics_process(delta):  #Function for calculating physics for player.
	velocity.y += gravity * delta  #Applies gravity to player.

	player_input()  #Refers to player_input() function so that its checking for input every frame.
	#Moves player along a vector. Refer to move_and_slide_with_snap in manuel.
	velocity = move_and_slide_with_snap(velocity, Vector2(0, 2), Vector2(0, -1), true, 4, float(deg2rad(45)), true)
	
func _process(delta):
	if invincible == true:
		print("hurt")
	var mouse_pos = get_global_mouse_position()  #Sets the mouse position every frame to a variable.
	var current_pos = position  #Sets the player position every frame to a variable.
	angle_check(mouse_pos, current_pos)  #Refers to dash_direction function to calculate direction.
	shoot(current_pos, angle)

func player_input():  #Checks for player input.
	if state == DEAD: #If player is dead return. We do not want the player moving while dead.
		return
	velocity.x = 0  #Sets player still so that previous inpots do not effect the next ones.

	var right = Input.is_action_pressed("right")  #Variable to store right key input.
	var left = Input.is_action_pressed("left")  #Variable to store left key input.
	var jump = Input.is_action_just_pressed("jump")  #Variable to store jump key input.
	var attack = Input.is_action_just_pressed("ui_accept") #variable that stores ui_accept

	#------------------------------------------------
	#If player wants to run on floor.
	if right and is_on_floor():
		change_state(RUN)
		velocity.x += player_speed
		$Sprite.flip_h = false
		p_direction = "right"
	if left and is_on_floor():
		change_state(RUN)
		velocity.x -= player_speed
		$Sprite.flip_h = true
		p_direction = "left"
	#------------------------------------------------
	#If player wants to run in air.
	if right and state == JUMP:
		velocity.x += player_speed
		$Sprite.flip_h = false
	if left and state == JUMP:
		velocity.x -= player_speed
		$Sprite.flip_h = true
	#-------------------------------------------------
	#If player is not moving sets state to IDLE.
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	if state == JUMP and is_on_floor():
		change_state(IDLE)
	#-------------------------------------------------
	#If player is not on floor set state to JUMP.
	if state in [IDLE, RUN] and !is_on_floor():
		change_state(JUMP)
	#-------------------------------------------------
	#If player wants to jump.
	if jump and is_on_floor():
		$Sprite/AnimationPlayer.play("JumpUp")
		$JumpSound.play()
		$Sprite/JumpLeft.emitting = true
		$Sprite/JumpRight.emitting = true
		velocity.y = jump_height
		jump_count += 1
		print(level)
		for i in range(2):
			after_image_count += 1
			after_image()
			
	if velocity.y < 0 and !is_on_floor():
		$Sprite.animation = "JumpUp"
	if velocity.y > 0 and !is_on_floor():
		$Sprite.animation = "JumpDown"
	if !is_on_floor():
		just_landed = true
	if is_on_floor() and just_landed:
		$Sprite/AnimationPlayer.play("JumpDown")
		$Sprite/LandLeft.emitting = true
		$Sprite/LandRight.emitting = true
		just_landed = false
		$Sprite.rotation_degrees = 0
	#Extra jumps.
	if jump and state == JUMP and jump_count < max_jumps:
		velocity.y = jump_height
		jump_count += 1
		if $Sprite.flip_h == true:
			$Sprite/AnimationPlayer.play_backwards("Flip")
		else:
			$Sprite/AnimationPlayer.play("Flip")
	#Once player lands reset jump count.
	if is_on_floor():
		jump_count = 1
	#-------------------------------------------------
	#Stance switches
	var t = $StanceTimer
	if Input.is_action_just_pressed("neutral") and can_switch_stance:
		change_stance(NEUTRAL)
		change_state(state)
		can_switch_stance = false
		t.start()
	if Input.is_action_just_pressed("fire") and can_switch_stance:
		change_stance(FIRE)
		change_state(state)
		can_switch_stance = false
		t.start()
	if Input.is_action_just_pressed("ice") and can_switch_stance:
		change_stance(ICE)
		change_state(state)
		can_switch_stance = false
		t.start()
	if Input.is_action_just_pressed("dark") and can_switch_stance:
		change_stance(DARK)
		change_state(state)
		can_switch_stance = false
		t.start()
	if Input.is_action_just_pressed("light") and can_switch_stance:
		change_stance(LIGHT)
		change_state(state)
		can_switch_stance = false
		t.start()

func after_image():
	var a = AfterImage.instance()
	if p_direction == "left":
		a.flip_h = true
	else:
		a.flip_h = false
		
	if after_image_count == 1:
		yield(get_tree().create_timer(.1), "timeout")
	a.position = position
	get_parent().add_child(a)
	a.fade_away()
	after_image_count = 0
		
func angle_check(mouse, pos):  #For determining angle in relation to player and mouse.
	var x = mouse.x - pos.x  #Stores x difference between mouse_pos Vector and position vector.
	var y = mouse.y - pos.y  #Stores y difference between mouse_pos Vector and position vector.
	var distance = sqrt(pow(x,2) + pow(y,2))  #Calculates distance between Vectors.
	if x == 0:  #If x is zero (so that we do not get divide by zero errors on some occasions).
		return
	pre_angle = abs(rad2deg(atan(y/x)))  #Uses arc tangent to calculate angle based on x and y component of distance.
	#--------------------------------
	#Calculates angle quadrant and add or subtracts. Because arc tangent only outputs numbers less than 90.
	if x < 0 and y < 0:
		pre_angle = 180 - pre_angle
	if x < 0 and y > 0:
		pre_angle = 180 + pre_angle
	if x > 0 and y > 0:
		pre_angle = 360 - pre_angle
	#--------------------------------
	pre_angle += 90  #Offsets angle because zero angle is going down.
	$AngleChecker.rotation_degrees = -pre_angle  #Inverts angle because negative angles go counter-clockwise.
	angle = -pre_angle + 90

func shoot(cur_pos, dir):  #Function to check for arrow shot.
	if Bow == false:
		return
	if can_shoot: #if can shoot is available
		if Input.is_action_pressed("arrow"): #and if the arrow shoot key is pressed.
			emit_signal("shoot", cur_pos, dir) #emit the shoot signal
			can_shoot = false #the chaacter can no longer shoot
			$ArrowTimer.start() #triggers the timer
			$AngleChecker/Bow.show() #shows the bow sprite

func _on_ArrowTimer_timeout(): #when this timer runs out
	can_shoot = true #the character can once again shoot
	$AngleChecker/Bow.hide() #hide the bow sprite
	
func update_health(amount):
	health -= amount
	change_state(HURT)
#	health_bar.value = health
	hud.health_bar_tween(health)
	if health == 0:
		change_state(DEAD)

func get_required_experience(level): #get required experience function
	return round(pow(level, 1.8) + level * 4) #return this value

func gain_experience(amount): #gain experience functiong
	experience_total += amount #add amount to total experience
	experience += amount #add amount to experience
	while experience >= experience_required: #while the experience is more than experience required
		experience -= experience_required #subtract experience by experience_required
		level_up() #call the level_up function
	emit_signal("experience_gained", experience, experience_required) #emit the experience gained signal and pass growth data

func level_up():  #level up function
	level += 1 #add one to level variable
	experience_required = get_required_experience(level + 1) #set the experience requirement to the next level.
	emit_signal("level_up", level)
	
func resource_collection(amount, type):  #Function for resource collection and addition to dictionary.
	Global.resources[type] += amount
	
func _on_HurtTimer_timeout():
	invincible = false
