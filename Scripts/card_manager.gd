extends Node2D
class_name CardManager

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2

var card_being_dragged: Card
var mouse_position_relative_to_card_being_dragged: Vector2
var card_being_hovered: Card
var screen_size: Vector2
var is_hovering_card: bool
var hovered_scale := Vector2(1.1, 1.1)

@export var player_hand: PlayerHand

# card stackign things

var card_list: Array[Card]



func _ready() -> void:
	screen_size = get_viewport_rect().size
	


func _process(_delta: float) -> void:
	if card_being_dragged:
		var mouse_position = get_global_mouse_position() - mouse_position_relative_to_card_being_dragged
		card_being_dragged.position = Vector2(clamp(mouse_position.x, 0, screen_size.x), clamp(mouse_position.y, 0, screen_size.y))


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Raycast
			var card = raycast_check_card()
			if card:
				start_drag(card)
		else:
			finish_drag()


func start_drag(card) -> void:
	var card_slot = raycast_check_card_slot()
	mouse_position_relative_to_card_being_dragged = card.get_local_mouse_position()
	card.card_highlight.visible = true
	card_being_dragged = card
	card_list.erase(card)
	card_list.append(card)
	card_update_z_index()
	if card_slot:
		if card_slot.interactable and card_slot.card_in_slot == card:
			card_slot.card_in_slot = null
			


func finish_drag() -> void:
	var card_slot = raycast_check_card_slot()
	if card_being_dragged:
		card_being_dragged.card_highlight.visible = false
	
		if card_slot:
			if not card_slot.card_in_slot:
				player_hand.remove_card_from_hand(card_being_dragged)
				card_being_dragged.position = card_slot.position
				card_slot.card_in_slot = card_being_dragged	
			else:
				player_hand.add_card_to_hand(card_being_dragged)
		else:
			player_hand.add_card_to_hand(card_being_dragged)
	card_being_dragged = null


func connect_card_signal(card) -> void:
	card.connect("hovered", on_card_hovered)
	card.connect("hovered_off", on_card_hovered_off)
	card_list.append(card)
	card.z_index = card_list.bsearch(card)

func on_card_hovered(card):
	if !is_hovering_card or card.z_index > card_being_hovered.z_index:
		if card_being_hovered:
			on_card_hovered_off(card_being_hovered)
		card_being_hovered = card
		is_hovering_card = true
		highlight_card(card, true)


func on_card_hovered_off(card):
	if card == card_being_hovered:
		is_hovering_card = false
		card_being_hovered = null
	highlight_card(card, false)
	if raycast_check_card():
		on_card_hovered(raycast_check_card())



func highlight_card(card: Card, hovered: bool) -> void:
	if hovered:
		card.scale = hovered_scale
	else:
		card.scale = Vector2(1.0, 1.0)


func raycast_check_card() -> Node2D:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_highest_card_in_z_index(result)
	return null


func raycast_check_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null


func get_highest_card_in_z_index(cards: Array) -> Node2D:
	var card_highest_z_index = cards[0].collider.get_parent()
	var highest_z_index = card_highest_z_index.z_index
	
	for i in range(0, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			card_highest_z_index = current_card
			highest_z_index = current_card.z_index
	return card_highest_z_index


func card_update_z_index() -> void:
	for child in get_children():	
		if child is Card:
			child.z_index = card_list.find(child) + 1
