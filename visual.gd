extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.start("timeline")
	await Dialogic.timeline_ended
	get_tree().change_scene_to_file("res://assets/scenes/levels/level.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
