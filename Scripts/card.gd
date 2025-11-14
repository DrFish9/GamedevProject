class_name Card
extends Node2D

signal hovered
signal hovered_off

var hand_position
var in_slot: bool
var card_type
var card_attribute_value_1


@export var card_image: Sprite2D
@export var card_highlight: Sprite2D

@export var card_attribute_1: Sprite2D
@export var card_value_1: RichTextLabel

@export var card_collision_shape: CollisionShape2D
@export var animation_player: AnimationPlayer


func _ready() -> void:
	get_parent().connect_card_signal(self)


func _process(delta: float) -> void:
	pass


func _on_card_collision_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_card_collision_mouse_exited() -> void:
	emit_signal("hovered_off", self)


func display_attributes(display: bool, speed: float):
	var tween = create_tween()
	if display:
		tween.tween_property(card_attribute_1, "position", Vector2(34.0, 34.0), speed) 
	else:
		tween.tween_property(card_attribute_1, "position", Vector2(0.0, 0.0), speed) 


signal merge_finished
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "merge":
		emit_signal("merge_finished")


# I am the goon of my rizz
# Sigma is my body, and Brainrot is my blood
# I've gooned to over a thousand gyats
# unknown to grass nor known to bathe
# have witsthood flames to create many skibidis
# yet, those hands will never hold anything
# so as i goon...
