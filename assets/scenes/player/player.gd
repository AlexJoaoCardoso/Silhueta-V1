extends CharacterBody2D

const laser = preload("res://assets/scenes/player/laserBig.tscn")
@onready var timer
@onready var win_size
@onready var hp
@onready var kills

func _ready():
	# tamanho da janela
	win_size =  Vector2($"..".win_size.x,$"..".win_size.y)
	
	# timer para contagens
	timer = Timer.new()
	timer.wait_time = 0.2
	timer.one_shot = true
	add_child(timer)
	
	# inicia hp e kills e imprime
	hp = 100
	get_node("../UI/HP").text = str("HP: ",hp,"/100")
	
func _process(_delta):
	# captura WASD e move
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * 500
	move_and_slide()
	
	# rotação apontando para mouse
	rotation = find_rotation()
	
	# atira com mouse mouse
	if(Input.is_action_pressed("primary_action") && timer.is_stopped()):
		timer.start()
		shoot()

# cria novo laser, calcula posição e alvo, rotação, velocidade e cor
func shoot():
	var newLaser = laser.instantiate()
	newLaser.win_size = win_size
	newLaser.start_position = position
	newLaser.start_rotation = rotation
	newLaser.target = get_viewport().get_mouse_position()-win_size/2
	newLaser.SPEED = 700
	# 1 = azul, 0 = vermelho
	newLaser.get_child(0,false).material.set_shader_parameter("BlueOrRed",1)
	$"../Bullets".add_child(newLaser)

# acha angulo de rotação entre player e mouse
func find_rotation():
	win_size = Vector2($"..".win_size.x,$"..".win_size.y)
	var mouse_position = get_viewport().get_mouse_position()-win_size/2
	var co = mouse_position.y-position.y
	var ca = mouse_position.x-position.x
	var hip = sqrt(co*co+ca*ca)
	var ang = asin(co/hip)
	if(ca < 0):
		ang = PI/2-ang
		ang += PI
	if(ca > 0):
		ang += PI/2
	return ang
