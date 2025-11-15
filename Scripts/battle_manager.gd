extends Node


@export var enemy_manager: EnemyManager
@export var card_manager: CardManager

@export var button_turn: Button
@export var card_slot_1: CardSlot
@export var card_slot_2: CardSlot
@export var card_slot_3: CardSlot
@export var card_slot_4: CardSlot
@export var card_slot_5: CardSlot

@export var merge_aura: Node2D
@export var projectile: Node2D
@export var explosion: Node2D

@onready var card_slots := [
	card_slot_1,
	card_slot_2,
	card_slot_3,
	card_slot_4,
	card_slot_5
	]
var damage_dealt


func _on_turn_button_pressed() -> void:
	
	
	damage_dealt = check_attack(card_slots)
	if check_attack(card_slots) != null && enemy_manager.card_being_selected:
		button_turn.disabled = false
		animate_card_merge(card_slots)
		
		enemy_manager.card_being_selected.damage(damage_dealt)
	
	

func check_attack(card_slot_array):
	var attack_constructed: Array
	for card_slot in card_slot_array:
			if card_slot.card_in_slot:
				var card = card_slot.card_in_slot
				cards_merged.append(card)
				if card.card_attribute_value_operator != "//":
					attack_constructed.append(card.card_attribute_value_operator)
				else:
					attack_constructed.append(card.card_attribute_value_1)
	
	print(attack_constructed)
	var stack: Array
	for item in attack_constructed:
		var item_type = typeof(item)
		
		if item_type == TYPE_INT:
			stack.push_back(item)
		elif item_type == TYPE_STRING:
			var operator: String = item
			
			# An operator needs two operands
			if stack.size() < 2:
				return null
			
			# Pop the top two operands
			# Note: 'b' is popped first, so it's the right-hand side
			var b: float = stack.pop_back()
			var a: float = stack.pop_back()

			# Perform the operation
			match operator:
				"+":
					stack.push_back(a + b)
				"-":
					stack.push_back(float(a + (-b)))
				"*":
					stack.push_back(a * b)
				"/":
					if b == 0.0:
						push_error("Division by zero!")
						return null # Return 0 or NAN
					stack.push_back(a / b)
				_:
					return null
		else:
			push_error("Invalid item in expression: Type %s." % item_type)
			return 0.0 # Return 0 or NAN
	if stack.size() == 1:
		cards_merged = []
		print(stack)
		return stack.pop_back()
	else:
		stack = []
		cards_merged = []
		
		# If the stack is empty or has too many items, the expression was malformed.
		push_error("Invalid postfix expression: Final stack size is %d (expected 1)." % stack.size())
		return null
	


var final_card
var cards_merged: Array[Card]
func animate_card_merge(card_slot_array) -> void:
	
	var tween = get_tree().create_tween()
	tween.connect("finished", on_tween_finished)
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	for card_slot in card_slot_array:
		if card_slot.card_in_slot:
			card_manager.card_list.erase(card_slot.card_in_slot)
			card_manager.card_list.append(card_slot.card_in_slot)
			card_manager.card_update_z_index()
			tween.tween_property(card_slot.card_in_slot, "position", card_slot_1.position, 0.4) 
			card_slot.card_in_slot.start_shake(3, 3)
			card_slot.card_in_slot.card_collision_shape.disabled = true
			cards_merged.append(card_slot.card_in_slot)
		card_slot.card_in_slot = null
	
	if cards_merged:
		final_card = cards_merged[-1]


func on_tween_finished():
	final_card.connect("merge_finished", on_finished_merging)
	final_card.animation_player.play("merge")
	explosion.position = card_slot_1.position
	merge_aura.get_node("CPUParticles2D").emitting = true
	

func on_finished_merging():
	projectile.position = card_slot_1.position
	for card in cards_merged:
		card.queue_free()
		
	cards_merged = []
	$"../aura/CPUParticles2D".emitting = false
	$"../Explosion/CPUParticles2D".emitting = true
	explosion.get_node("FireBoom").playing = true
	
	
	
	# declare attack ST
	
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	#$"../Fireball/CPUParticles2D".gravity = Vector2(-300.0, 0.0)
	#tween.tween_property($"../Fireball", "position", $"../Fireball".position + Vector2(100.0, -100.0), 1.5) 
	#$"../DarkBall/CPUParticles2D".orbit_velocity_min = 0.0
	#$"../DarkBall/CPUParticles2D".orbit_velocity_max = 0.0
	
	projectile.get_node("FireWoosh").playing = true
	tween.tween_property(projectile, "position", enemy_manager.card_being_selected.position, 4) 
	tween.parallel().tween_property(projectile, "scale", Vector2(1.5, 1.5), 3.2)
	tween.tween_property(projectile, "scale", Vector2(2.5, 2.5), .3)
	tween.tween_property(projectile, "scale", Vector2(0, 0), 0.3)
	tween.tween_callback(func(): 
		explosion.position = projectile.position
		explosion.get_node("CPUParticles2D").emitting = true
		explosion.get_node("FireBoom").playing = true
		)
	tween.tween_callback(func(): 
		projectile.position = Vector2(-100000, -1000000)
		projectile.scale = Vector2(1, 1)
		)
	#tween.tween_callback(func(): 
		#explosion.position = card_slot_1.position
		#)
	
	
	
	
	
