extends Node2D
class_name InputManager

signal left_mouse_button_pressed
signal left_mouse_button_released

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_DECK = 4

@export var card_manager: CardManager
@export var player_hand: PlayerHand
@export var deck: Deck



func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("left_mouse_button_pressed")
			raycast_at_cursor()
		else:
			emit_signal("left_mouse_button_released")
			


func raycast_at_cursor() -> Node2D:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		var object_collider = get_highest_object_in_z_index(result)
		var result_collision_mask =  object_collider.collision_mask
		
		if result_collision_mask == COLLISION_MASK_CARD:
			var card_found = object_collider.get_parent()	
			if card_found:
				card_manager.start_drag(card_found)
		elif result_collision_mask == COLLISION_MASK_DECK:
			if player_hand.player_hand.size() < player_hand.MAX_HAND_SIZE:
				deck.draw_card() 
	return null
	
	
func get_highest_object_in_z_index(objects: Array) -> Area2D:
	var object_highest_z_index
	var highest_z_index
	object_highest_z_index = objects[0].collider
	highest_z_index = object_highest_z_index.get_parent().z_index
	
	for i in range(0, objects.size()):
		var current_object = objects[i].collider
		if current_object.get_parent().z_index > highest_z_index:
			object_highest_z_index = current_object
			highest_z_index = current_object.z_index
	return object_highest_z_index
