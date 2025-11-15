class_name Enemy
extends Node2D

signal hovered_enemy
signal hovered_enemy_off

var hand_position
var in_slot: bool
var card_type

var enemy_health:= 100
@export_enum("Attacking", "Defending", "Special") var stance: int


@export var card_image: Sprite2D
@export var card_highlight: Sprite2D
@export var enemy_image: Sprite2D

@export var card_attribute_1: Sprite2D
@export var card_value_1: RichTextLabel

@export var card_collision_shape: CollisionShape2D
@export var animation_player: AnimationPlayer


var card_attribute_value_1
var card_attribute_value_operator
var card_attribute_value_type
var card_attribute_value_style
var card_attribute_value_text
var card_attribute_value_name

var current_shake = 0
var shake_amount = 0
var shake_duration = 1

func _physics_process(delta: float) -> void:
	current_shake -= shake_amount * delta / shake_duration
	if current_shake < 0:
		current_shake = 0
	
	card_image.position = Vector2(randf_range(-current_shake, current_shake), randf_range(-current_shake, current_shake))
	



func _ready() -> void:
	get_parent().connect_card_signal(self)





func display_attributes(display: bool, speed: float):
	var tween = create_tween()
	if display:
		tween.tween_property(card_attribute_1, "position", Vector2(0, 34.0), speed) 
		tween.parallel().tween_property(card_attribute_1, "modulate", Color(1, 1, 1, 1), speed)
		tween.parallel().tween_property(card_attribute_1, "scale", Vector2(1.0, 1.0), speed)
		card_attribute_1.z_index = 100 
	else:
		tween.tween_property(card_attribute_1, "position", Vector2(0.0, 0.0), speed) 
		tween.parallel().tween_property(card_attribute_1, "modulate", Color(1, 1, 1, 0), speed)
		tween.parallel().tween_property(card_attribute_1, "scale", Vector2(0.0, 0.0), speed) 
		card_attribute_1.z_index = -1



func start_shake(shake_amount, duration):
	current_shake = shake_amount
	shake_duration = duration


func select() -> void:
	card_highlight.visible = true
	

func unselect() -> void:
	card_highlight.visible = false


func _on_collision_mouse_entered() -> void:
	emit_signal("hovered_enemy", self) # Replace with function body.


func _on_collision_mouse_exited() -> void:
	emit_signal("hovered_enemy_off", self) # Replace with function body.
	
	
func damage(damage_dealt):
	card_attribute_value_1 = str(int(card_attribute_value_1) - damage_dealt)
	card_value_1.text = str("[center]" + str(card_attribute_value_1) + "[/center]")
	if int(card_attribute_value_1) <= 0:
		get_parent().card_list.erase(self)
		await get_tree().create_timer(7.0).timeout 
		queue_free()
