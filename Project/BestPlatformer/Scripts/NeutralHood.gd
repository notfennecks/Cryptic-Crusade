extends KinematicBody2D

export (int) var player_speed  #Exported variable for player run speed.
export (int) var jump_height  #Exported variable for player jump height.
export (int) var gravity  #Exported variable for gravity applied to player.
export (int) var max_jumps  #Exported variable for max player jumps.
var jump_count  #Variable that tracks jump count.

export (bool) var can_line_dash  #Variable that tracks if the player can line dash.
onready var dash_line = $PositionHelper/DashLine  #Sets DashLine node as variable.

enum {IDLE, RUN, JUMP, DEAD, DASH}  #Declaring states as enumerated types.
var state  #Variable state to track current state.

var velocity = Vector2()  #Variable velocity to store and apply player movement.

func _ready():  #Runs function soon as scene is loaded.
	change_state(IDLE)  #Changes state to IDLE
	jump_count = 0
	
func change_state(new_state):  #Runs function when state needs to be changed. Taking the new_state as argument.
	state = new_state  #Sets the state variable to the state it needs to change to.
	match state:  #Matches the state with its correct name and runs the embedded code.
		IDLE:
			print("idle")
		RUN:
			print("run")
		JUMP:
			print("jump")
		DEAD:
			print("dead")
			
func _physics_process(delta):  #Function for calculating physics for player.
	velocity.y += gravity * delta  #Applies gravity to player.
	
	player_input()  #Refers to player_input() function so that its checking for input every frame.
	velocity = move_and_slide(velocity, Vector2(0, -1))  #Moves player along a vector. Refer to move_and_slide in manuel.
	
func _process(delta):
	var mouse_pos = get_global_mouse_position()  #Sets the mouse position every frame to a variable.
	var current_pos = position  #Sets the player position every frame to a variable.
	dash_line(mouse_pos, current_pos) #Refers to draw_dash function to draw the dash path.
	
func player_input():  #Checks for player input.
	if state == DEAD:  #If player is dead return. We do not want the player moving while dead.
		return
	velocity.x = 0  #Sets player still so that previous inpots do not effect the next ones.
	
	var right = Input.is_action_pressed("right")  #Variable to store right key input.
	var left = Input.is_action_pressed("left")  #Variable to store left key input.
	var jump = Input.is_action_just_pressed("jump")  #Variable to store jump key input.
	
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
	#If player wants to jump.
	if jump and is_on_floor():
		velocity.y = jump_height
		jump_count += 1
	#Extra jumps.
	if jump and state == JUMP and jump_count < max_jumps:
		velocity.y = jump_height
		jump_count += 1
	#Once player lands reset jump count.
	if is_on_floor():
		jump_count = 1
	
func dash_line(mouse, pos):  #Calculates and Executes dash line.
	if can_line_dash == false:  #If player can not line dash return.
		return
	if Input.is_action_pressed("dashline"):  #If dashline input is pressed.
		dash_line.set_point_position(0, pos)  #Sets the first point of line to player position.
		dash_line.set_point_position(1, mouse)  #Sets the second point of line to mouse position.
	if Input.is_action_just_released("dashline"):  #If the dashline input is just released.
		dash_line.set_point_position(0, Vector2(0, 0))  #Resets point at first position.
		dash_line.set_point_position(1, Vector2(0, 0))  #Resets point at sceond position.
		
		$DashTween.start()  #Starts tween.
		#Interpolates position property from current player position to mouse position.
		$DashTween.interpolate_property(self, "position", null, mouse, .5, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, 0)
		set_physics_process(false)  #Stops all physics processes so that transition does not have gravity,
		set_process(false)  #Stops process so that game does not calculate alternate dash lines.

func _on_DashTween_tween_completed(object, key):  #Once tween is completed.
	set_physics_process(true)  #Sets all physics processes back to true.
	set_process(true)  #Sets all processes back to true.
