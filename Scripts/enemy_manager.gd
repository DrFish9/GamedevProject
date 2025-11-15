extends Node2D
class_name EnemyManager

var card_being_selected: Enemy
var mouse_position_relative_to_card_being_dragged: Vector2
var card_being_hovered: Enemy
var screen_size: Vector2
var is_hovering_card: bool

var card_list: Array[Enemy]
const ENEMY_POS_LIST = [1, 2, 3, 4]

const DEFAULT_CARD_SCALE_DOWN = 0.9
const DEFAULT_CARD_SCALE_UP = 1.1
const DEFAULT_CARD_SCALE = 1

var enemy_list_reference
var enemy_list = ["Enemy_1", "Enemy_2", "Enemy_3", "Enemy_4", "Enemy_5"]

func _ready() -> void:
	
	enemy_list_reference = preload("res://Scripts/enemy_list.gd")

func connect_card_signal(card) -> void:
	card.connect("hovered_enemy", on_card_hovered)
	card.connect("hovered_enemy_off", on_card_hovered_off)
	card_list.append(card)
	

func on_card_hovered(card: Enemy):
	
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
	if card.in_slot:
		card.scale = Vector2(DEFAULT_CARD_SCALE_DOWN, DEFAULT_CARD_SCALE_DOWN)
	#if raycast_check_card():
		#on_card_hovered(raycast_check_card()) 


func select_enemy(enemy) -> void:
	for child in get_children():
		child.unselect()
	if !enemy:
		return
	enemy.select()
	card_being_selected = enemy
	


func highlight_card(card: Enemy, hovered: bool) -> void:
	if hovered:
		card.scale = Vector2(DEFAULT_CARD_SCALE_UP, DEFAULT_CARD_SCALE_UP)
		card.display_attributes(true, 0.1)
	else:
		card.scale = Vector2(DEFAULT_CARD_SCALE, DEFAULT_CARD_SCALE)
		card.display_attributes(false, 0.1)
		




const ENEMY_SCENE_PATH = "res://Scenes/enemy.tscn"


var card_drawn_name 
func _on_spawn_enemy_pressed() -> void:
	spawn_enemy()
	
	
func spawn_enemy() -> void:
	
	
	if enemy_list:
		card_drawn_name = enemy_list[0]
		enemy_list.pop_front()
		enemy_list.append(card_drawn_name)
		var card_scene = preload(ENEMY_SCENE_PATH)


		var new_card = card_scene.instantiate()
		var card_image_path = str("res://Assets/" + card_drawn_name +".png")
		new_card.enemy_image.texture = load(card_image_path)
		
		# setting card attributes
		new_card.card_attribute_value_1 = enemy_list_reference.CARDS[card_drawn_name][0]
		new_card.card_attribute_value_operator = enemy_list_reference.CARDS[card_drawn_name][1]
		new_card.card_attribute_value_type = enemy_list_reference.CARDS[card_drawn_name][2]
		new_card.card_attribute_value_style = enemy_list_reference.CARDS[card_drawn_name][3]
		new_card.card_attribute_value_text = enemy_list_reference.CARDS[card_drawn_name][4]
		new_card.card_attribute_value_name = enemy_list_reference.CARDS[card_drawn_name][5]
		
		new_card.card_value_1.text = str("[center]" + str(enemy_list_reference.CARDS[card_drawn_name][2]) + "[/center]")
		#new_card.card_attribute_name.text = str("[center]" + str(enemy_list_reference.CARDS[card_drawn_name][5]) + "[/center]")
		#new_card.card_attribute_text.text = str("[center]" + str(enemy_list_reference.CARDS[card_drawn_name][4]) + "[/center]")
		
		new_card.position.x = 400 + randf_range(1, 30)
		new_card.position.y = 100 + randf_range(1, 100)
		
		if card_list.size() >= 3:
			for enemy in card_list:
				enemy.position = Vector2(100000000,100000000000)
				card_list.erase(enemy)
				enemy.queue_free()
		#if card_list.size() == 0:
			#new_card.position.x = 460
			#new_card.position.y = 100
		#elif card_list.size() == 1:
			#new_card.position.x = 460
			#new_card.position.y = 200
		#else:
			#var oldest_enemy = card_list[0] 
			#card_list.erase(oldest_enemy)
			#oldest_enemy.queue_free()
			#var tween = get_tree().create_tween()
			#
			#tween.tween_property(card_list[0], "position", card_list[0].position + Vector2(0, -100), 0.4)
			#
			#new_card.position.x = 460
			#new_card.position.y = 200
		
		
		add_child(new_card)
		
	else:
		print("no enemies left")
		
	
