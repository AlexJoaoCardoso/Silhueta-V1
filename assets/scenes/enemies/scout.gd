extends CharacterBody2D

const laser = preload("res://assets/scenes/player/laserBig.tscn")
@onready var states:Array = ["line","single","spiral"]
@onready var current_state = 1
@onready var state_timer
@onready var timer1
@onready var timer2
@onready var win_size
@onready var spiral_angle = 0
@onready var hp
@onready var max_hp

func _ready():
	# tamanho da janela
	win_size =  Vector2($"../..".win_size.x,$"../..".win_size.y)
	# timer para contagens
	state_timer = Timer.new()
	state_timer.wait_time = 3
	state_timer.one_shot = true
	add_child(state_timer)
	timer1 = Timer.new()
	timer1.wait_time = 0.2
	timer1.one_shot = true
	add_child(timer1)
	timer2 = Timer.new()
	timer2.wait_time = 0.2
	timer2.one_shot = true
	add_child(timer2)
	
	# hp inicial e posição barra de vida
	hp = 5000
	max_hp = hp
	get_node("../../UI/BossHP").text = str("Boss HP: %d/%d",hp,max_hp)
	
func _process(_delta):
	# atira se o timer parar
	if(timer1.is_stopped()):
		timer1.start()
		shootPattern(states[current_state])
		
	if(timer2.is_stopped()):
		timer2.start()
		shootPattern(states[(current_state+1)%states.size()])
	# atira se o timer parar
	if(state_timer.is_stopped()):
		state_timer.start()
		next_state()
		
func shootPattern(pattern:String):
	if(pattern == "spiral"):
		shoot_spiral(0,0.1,500)
		shoot_spiral(PI/2,0.1,500)
		shoot_spiral(PI,0.1,500)
		shoot_spiral(3*PI/2,0.1,500)
	elif(pattern == "line"):
		shoot_line()	
	elif(pattern == "single"):
		shoot_spiral(0,0,800)
		shoot_spiral(PI,0,800)
		shoot_spiral(PI/2,0,800)
		shoot_spiral(3*PI/2,0,800)
# atira laser em um círculo em linha
func shoot_line():
	for i in 10:
		var newLaser = laser.instantiate()
		newLaser.win_size = win_size
		newLaser.start_position = position
		newLaser.start_rotation = spiral_angle+i/10.0
		newLaser.target = position + Vector2(cos(spiral_angle-PI/2)*50,sin(spiral_angle-PI/2)*50)
		newLaser.SPEED = 200
		# 1 = azul, 0 = vermelho
		newLaser.get_child(0,false).material.set_shader_parameter("BlueOrRed",0)
		$"..".add_child(newLaser)
		spiral_angle += 0.3
# atira laser em uma espiral
func shoot_spiral(shift:float,angle:float,speed:float):
	var newLaser = laser.instantiate()
	newLaser.win_size = win_size
	newLaser.start_position = position
	newLaser.start_rotation = spiral_angle+shift
	spiral_angle += angle
	newLaser.target = position + Vector2(cos(spiral_angle+shift-PI/2)*50,sin(spiral_angle+shift-PI/2)*50)
	newLaser.SPEED = speed
	# 1 = azul, 0 = vermelho
	newLaser.get_child(0,false).material.set_shader_parameter("BlueOrRed",0)
	$"..".add_child(newLaser)

func next_state():
	current_state = (current_state+1)%states.size()
