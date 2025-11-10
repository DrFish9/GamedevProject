class_name Card
extends Node2D

signal hovered
signal hovered_off

var hand_position

@export var card_image: Sprite2D
@export var card_highlight: Sprite2D
@export var card_collision_shape: CollisionShape2D


func _ready() -> void:
	get_parent().connect_card_signal(self)


func _process(delta: float) -> void:
	pass


func _on_card_collision_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_card_collision_mouse_exited() -> void:
	emit_signal("hovered_off", self)


# I am the goon of my rizz
# Sigma is my body, and Brainrot is my blood
# I've gooned to over a thousand gyats
# unknown to grass nor known to bathe
# have witsthood flames to create many skibidis
# yet, those hands will never hold anything
# so as i goon...
