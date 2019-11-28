extends Node2D

signal attack_finished #attack finished signal
var player = get_parent()

onready var animation_player = $AnimationPlayer #declare animation player as a variable

enum {IDLE, ATTACK} #character states
var current_state = IDLE #declare the default state IDLE

export (int) var damage = 1 #sword does 1 damage for now

func _ready():
	set_physics_process(false) #set the physics process function to true
	
func attack():
	_change_state(ATTACK) #change the state to attack
	
func _change_state(new_state): #change state function with new state parameter
	current_state = new_state #change the current state to the new state
	match current_state: #match the current state
		IDLE:
			set_physics_process(false) #set the physics process function false
		ATTACK:
			set_physics_process(true) #set the physics process function true
			animation_player.play("Attack") #play the attack animation
	
func _physics_process(delta):
	pass
	
func is_owner(node): #function with a node as a parameter
	return node.weapon_path == get_path() #return the weapon path as the scripts path

func _on_AnimationPlayer_animation_finished(anim_name): #when the animation is finished
	if anim_name == "Attack": #if the animations name is attack
		_change_state(IDLE) #change the state back to IDLE
		emit_signal("attack_finished") #emit the attack finished signal

func _on_Sword_body_entered(body):
	if body.is_in_group("character"):
		return
	if body.is_in_group("enemy"):
		body.take_damage()
