extends Node2D
class_name Deck

const CARD_SCENE_PATH = "res://Scenes/card.tscn"
const CARD_DRAW_SPEED = 0.2
const DECK_POSITION_X = 50
const DECK_POSITION_Y = 300

const STARTING_HAND_SIZE = 5


@export var card_manager: CardManager
@export var player_hand: PlayerHand

var card_list_reference
var deck_list: Array = [
	"Rune_1", "Rune_3", "Rune_1", "Rune_3", "Rune_3", "Rune_3", "Rune_1",
	"Rune_1", "Rune_3", "Rune_1", "Rune_3", "Rune_3", "Rune_3", "Rune_1"
	]


func _ready() -> void:
	deck_list.shuffle()
	position.x = DECK_POSITION_X
	position.y = DECK_POSITION_Y
	
	card_list_reference = preload("res://Scripts/card_list.gd")


func draw_card() -> void:
	var card_drawn_name = deck_list[0]
	deck_list.pop_front()
	
	if deck_list.size() <= 0:
		$"DeckImage".visible = false
		$"Collision/CollisionShape2D".disabled = true
	
	var card_scene = preload(CARD_SCENE_PATH)

	var new_card = card_scene.instantiate()
	var card_image_path = str("res://Assets/" + card_drawn_name +".png")
	new_card.card_image.texture = load(card_image_path)
	new_card.position.x = DECK_POSITION_X
	new_card.position.y = DECK_POSITION_Y
	
	# setting card attributes
	new_card.card_attribute_value_1 = card_list_reference.CARDS[card_drawn_name][0]
	new_card.card_value_1.text = str("[center]" + str(card_list_reference.CARDS[card_drawn_name][0]) + "[/center]")
	
	card_manager.add_child(new_card)
	new_card.name = "Card"
	player_hand.add_card_to_hand(new_card, CARD_DRAW_SPEED)
	new_card.animation_player.play("card_flip")
	
