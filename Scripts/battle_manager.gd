extends Node


@export var button_turn: Button
@export var card_slot_1: CardSlot
@export var card_slot_2: CardSlot
@export var card_slot_3: CardSlot
@export var card_slot_4: CardSlot

@onready var card_slots := [
	card_slot_1,
	card_slot_2,
	card_slot_3,
	card_slot_4
	]

func _on_turn_button_pressed() -> void:
	button_turn.disabled = false
	
	var attack_power = (
		card_slot_1.card_in_slot.card_attribute_value_1 + 
		card_slot_2.card_in_slot.card_attribute_value_1 
	)
	
	print(attack_power)
	
	
	
	#animate_card_merge(card_slot_2)
	#animate_card_merge(card_slot_3)
	animate_card_merge(card_slots)
	

	
	
var final_card
var cards_merged: Array[Card]
func animate_card_merge(card_slot_array) -> void:
	var tween = get_tree().create_tween()
	tween.connect("finished", on_tween_finished)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN_OUT)
	for card_slot in card_slot_array:
		tween.tween_property(card_slot.card_in_slot, "position", card_slot_1.position, 0.4) 
		if card_slot.card_in_slot:
			cards_merged.append(card_slot.card_in_slot)
		card_slot.card_in_slot = null
	
	final_card = cards_merged[-1]
	

func on_tween_finished():
	final_card.connect("merge_finished", on_finished_merging)
	final_card.animation_player.play("merge")


func on_finished_merging():
	print("goon")
	$"../Explosion/CPUParticles2D".emitting = true
	for card in cards_merged:
		card.queue_free()
		print("goon")
	cards_merged = []
