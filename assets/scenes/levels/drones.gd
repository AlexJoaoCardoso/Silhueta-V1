extends Node2D


var timer
var drone = preload("res://assets/scenes/enemies/drone.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	timer.wait_time = 1
	timer.one_shot = true
	add_child(timer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(timer.is_stopped()):
		timer.start()
		#var newDrone = drone.instantiate()
		#self.add_child(newDrone)
