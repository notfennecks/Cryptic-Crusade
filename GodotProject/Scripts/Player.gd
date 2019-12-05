extends KinematicBody2D

export (int) var player_speed  #Exported variable for player run speed.
export (int) var jump_height  #Exported variable for player jump height.
export (int) var gravity  #Exported variable for gravity applied to player.
export (int) var max_jumps  #Exported variable for max player jumps.
export (int) var level = 1  #Exported variabe for what level the player is in
var jump_count = 0 #Variable that tracks jump count.

var pre_angle  #Variable for storing angle before calculation.

export (float) var arrow_rate  #exported variable for how fast the arrow shoots.
var can_shoot = true  #If the player can fire an arrow.
signal shoot  #Signal that tracks if the player shot.
var angle  #Variable for storing 360 angle in relation between player and mouse.

enum {IDLE, RUN, JUMP, DEAD, DASH, ATTACK, HURT, ATTACKL}  #Declaring states as enumerated types.
var state  #Variable state to track current state.
var health
var experience = 0
var experience_total = 0
var experience_required = get_required_experience(level + 1) #experience required is determined by the get required experience function
signal experience_gained(growth_data) #create experience gained signal

export (bool) var Bow = false
export (bool) var Sword = false

enum {NEUTRAL, FIRE, ICE, DARK, LIGHT} #Declaring all possible stances as enumerated types.
var stance  #Variable for tracking current stance.
var can_switch_stance = true #Variable for if the player can change their stance.
#Dictionary that stores stances and their respective idle animations.
var stance_idle = {
	0: "Idle_Neutral",
	1: "Idle_Fire",
	2: "Idle_Ice",
	3: "Idle_Dark",
	4: "Idle_Light"}
#Dictionary that stores stances and their respective run animations.
var stance_run = {
	0: "Run_Neutral",
	1: "Run_Fire",
	2: "Run_Ice",
	3: "Run_Dark",
	4: "Run_Light"}

var velocity = Vector2()  #Variable velocity to store and apply player movement.

func _ready():  #Runs function soon as scene is loaded.
	health = 10
	change_stance(NEUTRAL)  #Changes stance to NEUTRAL.
	change_state(IDLE)  #Changes state to IDLE.
	$ArrowTimer.wait_time = arrow_rate

func change_state(new_state):  #Runs function when state needs to be changed. Taking the new_state as argument.
	state = new_state  #Sets the state variable to the state it needs to change to.
	match state:  #Matches the state with its correct name and runs the embedded code.
		IDLE:
			$Sprite.animation = stance_idle[stance]  #Switches to correct idle animation based on current stance.
			$Sprite.playing = true
		RUN:
			$Sprite.animation = stance_run[stance]
			#stance_run[stance]  #Switches to correct run animation based on current stance.
			$Sprite.playing = true
		JUMP:
			$Sprite.animation = stance_run[stance]
			$Sprite.playing = true
		DEAD:
			print("dead")
		ATTACK:
			$Sword.set_position(Vector2(19,0))
			$Sword/AnimationPlayer.play("Attack")
		#HURT:
			#health -= 1
		ATTACKL:
			$Sword.set_position(Vector2(4,0))
			$Sword/AnimationPlayer.play("Attack_Left")

func change_stance(new_stance):  #Runs function when stance needs to be changed. Taking new_stance as argument.
	stance = new_stance  #Sets the stance variable to the stance player wanted to change to.
	match stance:  #Matches the current stance with its respective name and runs embedded code.
		NEUTRAL:
			print("Neutral stance")
		FIRE:
			print("Fire stance")
		ICE:
			print("Ice stance")
		DARK:
			print("Dark stance")
		LIGHT:
			print("Light stance")
		
func _on_StanceTimer_timeout():
	can_switch_stance = true
	
func _physics_process(delta):  #Function for calculating physics for player.
	velocity.y += gravity * delta  #Applies gravity to player.

	player_input()  #Refers to player_input() function so that its checking for input every frame.
	#Moves player along a vector. Refer to move_and_slide_with_snap in manuel.
	velocity = move_and_slide_with_snap(velocity, Vector2(0, 2), Vector2(0, -1), true, 4, float(deg2rad(45)), true)
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider.name == "KinematicBody2D":
			health -= 1
			if health == 0:
				get_tree().reload_current_scene()
				print("You are dead")

func _process(delta):
	var mouse_pos = get_global_mouse_position()  #Sets the mouse position every frame to a variable.
	var current_pos = position  #Sets the player position every frame to a variable.
	angle_check(mouse_pos, current_pos)  #Refers to dash_direction function to calculate direction.
	shoot(current_pos, angle)

func player_input():  #Checks for player input.
	if state == DEAD:  #If player is dead return. We do not want the player moving while dead.
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
		$Sprite.flip_h = true
	if left and is_on_floor():
		change_state(RUN)
		velocity.x -= player_speed
		$Sprite.flip_h = false
	#------------------------------------------------
	#If player wants to run in air.
	if right and state == JUMP:
		velocity.x += player_speed
		$Sprite.flip_h = true
	if left and state == JUMP:
		velocity.x -= player_speed
		$Sprite.flip_h = false
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
	#if player is on floor and attack is triggered set state to ATTACK
	if attack and is_on_floor():
		if right:
			change_state(ATTACK)
		if left:
			change_state(ATTACKL)
	#-------------------------------------------------
	#If player wants to jump.
	if jump and is_on_floor():
		velocity.y = jump_height
		jump_count += 1
		gain_experience(5)
	#Extra jumps.
	if jump and state == JUMP and jump_count < max_jumps:
		velocity.y = jump_height
		jump_count += 1
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

func get_required_experience(level): #get required experience function
	return round(pow(level, 1.8) + level * 4) #return this value

func gain_experience(amount): #gain experience function
	experience_total += amount #add amount to total experience
	experience += amount #add amount to experience
	var growth_data = [] #growth data declared as an array
	while experience >= experience_required: #while the experience is more than experience required
		experience -= experience_required #subtract experience by experience_required
		growth_data.append([experience_required, experience_required]) #store this in growth data
		level_up() #call the level_up function
	growth_data.append([experience, experience_required]) #store this in growth data if the player does not level up
	emit_signal("experience_gained", growth_data) #emit the experience gained signal and pass growth data

func level_up():  #level up function
	level += 1 #add one to level variable
	experience_required = get_required_experience(level + 1) #set the experience requirement to the next level.
	
func resource_collection(amount, type):  #Function for resource collection and addition to dictionary.
	Global.resources[type] += amount
	