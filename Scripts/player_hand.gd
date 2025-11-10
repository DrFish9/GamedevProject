extends Node2D
class_name PlayerHand

const SCREEN_WIDTH = 640
const SCREEN_HEIGHT = 360

const HAND_SIZE = 10
const CARD_SCENE_PATH = "res://Scenes/card.tscn"
const CARD_WIDTH = 50
const HAND_POSITION_Y = 300

@export var card_speed: float
@export var card_manager: CardManager

var player_hand: Array[Card]
@warning_ignore("integer_division")
@onready var center_screen_x = SCREEN_WIDTH /2 + 50
@warning_ignore("integer_division")
@onready var hand_pos_y = SCREEN_HEIGHT * 3/4


func _ready() -> void:
	var card_scene = preload(CARD_SCENE_PATH)
	for i in range(HAND_SIZE):
		var new_card = card_scene.instantiate()
		card_manager.add_child(new_card)
		new_card.name = "Card"
		add_card_to_hand(new_card)


func add_card_to_hand(card):
	if card not in player_hand:
		player_hand.append(card)
		update_hand_position()
	else:
		animate_card_to_position(card, card.hand_position)


func update_hand_position():
	for i in range(player_hand.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_POSITION_Y)
		var card = player_hand[i]
		card.hand_position = new_position
		animate_card_to_position(card, new_position)


func calculate_card_position(card_index):
	var total_width: float = (player_hand.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + card_index * CARD_WIDTH - total_width / 2 
	return x_offset


func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, card_speed) 


func remove_card_from_hand(card: Card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_position()
