extends Node2D
class_name Deck

const CARD_SCENE_PATH = "res://Scenes/card.tscn"
const CARD_DRAW_SPEED = 0.2
const DECK_POSITION_X = 50
const DECK_POSITION_Y = 300


@export var card_manager: CardManager
@export var player_hand: PlayerHand

var card_list_reference
var deck_list: Array = ["bruh", "gyat", "rizz", ]


func _ready() -> void:
	position.x = DECK_POSITION_X
	position.y = DECK_POSITION_Y
	
	card_list_reference = preload("res://Scripts/card_list.gd")


func draw_card() -> void:
	var card_drawn = deck_list[0]
	deck_list.pop_front()
	
	if deck_list.size() <= 0:
		$"DeckImage".visible = false
		$"Collision/CollisionShape2D".disabled = true
	
	var card_scene = preload(CARD_SCENE_PATH)

	var new_card = card_scene.instantiate()
	new_card.position.x = DECK_POSITION_X
	new_card.position.y = DECK_POSITION_Y
	card_manager.add_child(new_card)
	new_card.name = "Card"
	player_hand.add_card_to_hand(new_card, CARD_DRAW_SPEED)
	
