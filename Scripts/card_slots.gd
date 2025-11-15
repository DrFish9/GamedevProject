extends Node2D
class_name CardSlotManager

const SCREEN_WIDTH = 640
const SCREEN_HEIGHT = 360



func _ready() -> void:
	$CardSlot.position = Vector2(SCREEN_WIDTH/12, SCREEN_HEIGHT*2/5)
	$CardSlot2.position = Vector2(SCREEN_WIDTH*2/12, SCREEN_HEIGHT*2/5)
	$CardSlot3.position = Vector2(SCREEN_WIDTH*3/12, SCREEN_HEIGHT*2/5)
	$CardSlot4.position = Vector2(SCREEN_WIDTH*4/12, SCREEN_HEIGHT*2/5)
	$CardSlot5.position = Vector2(SCREEN_WIDTH*5/12, SCREEN_HEIGHT*2/5)
