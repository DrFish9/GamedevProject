class_name Card
extends Node2D

signal hovered
signal hovered_off

var hand_position
var in_slot: bool
var card_type
var card_attribute_value_1
var card_attribute_value_operator
var card_attribute_value_type
var card_attribute_value_style
var card_attribute_value_text
var card_attribute_value_name
var highlight_locked: bool


@export var card_image: Sprite2D
@export var card_highlight: Sprite2D

@export var card_attribute_1: Sprite2D
@export var card_value_1: RichTextLabel

@export var card_description: Sprite2D
@export var card_attribute_name: RichTextLabel
@export var card_attribute_text: RichTextLabel

@export var card_collision_shape: CollisionShape2D
@export var animation_player: AnimationPlayer


var card_attributes = [0, "//", "", "", "", ""]
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



func _on_card_collision_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_card_collision_mouse_exited() -> void:
	emit_signal("hovered_off", self)


func display_attributes(display: bool, speed: float):

	var tween = create_tween()
	if display:
		tween.tween_property(card_attribute_1, "position", Vector2(34.0, 34.0), speed).from(Vector2(0, 0))
		tween.parallel().tween_property(card_attribute_1, "modulate", Color(1, 1, 1, 1), speed)
		tween.parallel().tween_property(card_attribute_1, "scale", Vector2(1.0, 1.0), speed)
		
		tween.parallel().tween_property(card_description, "position", Vector2(0.0, -80.0), speed).from(Vector2(0, 0))
		tween.parallel().tween_property(card_description, "modulate", Color(1, 1, 1, 1), speed) 
		tween.parallel().tween_property(card_description, "scale", Vector2(1.0, 1.0), speed)
	else:
		tween.tween_property(card_attribute_1, "position", Vector2(16.0, 16.0), speed).from(Vector2(34, 34))
		tween.parallel().tween_property(card_attribute_1, "modulate", Color(1, 1, 1, 0), speed)
		tween.parallel().tween_property(card_attribute_1, "scale", Vector2(0.0, 0.0), speed)
		
		tween.parallel().tween_property(card_description, "position", Vector2(0.0, 32.0), speed).from(Vector2(0, -80))
		tween.parallel().tween_property(card_description, "modulate", Color(1, 1, 1, 0), speed) 
		tween.parallel().tween_property(card_description, "scale", Vector2(0.0, 0.0), speed)
		
		
		
		


signal merge_finished
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "merge":
		emit_signal("merge_finished")







func start_shake(shake_amount, duration):
	current_shake = shake_amount
	shake_duration = duration


# I am the goon of my rizz
# Sigma is my body, and Brainrot is my blood
# I've gooned to over a thousand gyats
# unknown to grass nor known to bathe
# have witsthood flames to create many skibidis
# yet, those hands will never hold anything
# so as i goon...
