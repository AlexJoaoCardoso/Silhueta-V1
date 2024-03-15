extends CharacterBody2D

#const JUMP_VELOCITY = -400.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const SPEED = 35.0
const laser = preload("res://assets/scenes/player/laser.tscn")
@onready var start
@onready var rng = RandomNumberGenerator.new()
@onready var timer
@onready var win_size

func _ready():
	# tamanho da janela e posição do drone
	win_size =  Vector2($"../..".win_size.x,$"../..".win_size.y)
	position = Vector2(rng.randf_range(-win_size.x/2,win_size.x/2),rng.randf_range(-win_size.y/2,win_size.y/2))
	start = position
	
	# timer para atirar
	timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	add_child(timer)
	
func _physics_process(delta):
	# rotação para apontar ao player
	rotation = find_rotation()
	# aproxima ao player com speed de 200 se está > 400 de distância
	if(dist(position,$"../.."/Player.position)>400):
		position = position.move_toward($"../.."/Player.position,200*delta)
		velocity+=SPEED*position.direction_to($"../.."/Player.position)*delta
	move_and_slide()
	# atira se o timer parar
	if(timer.is_stopped()):
		timer.start()
		shoot()

func dist(a:Vector2, b:Vector2):
	return sqrt(pow(b.x-a.x,2)+pow(b.y-a.y,2))

# cria novo laser, calcula posição e alvo, rotação, velocidade e cor
func shoot():
	var newLaser = laser.instantiate()
	newLaser.win_size = win_size
	newLaser.start_position = position
	newLaser.start_rotation = rotation
	newLaser.target = $"../.."/Player.position
	newLaser.SPEED = 500
	# 1 = azul, 0 = vermelho
	newLaser.get_child(0,false).material.set_shader_parameter("BlueOrRed",0)
	$"..".add_child(newLaser)

# acha angulo de rotação entre drone e player
func find_rotation():
	win_size = Vector2($"../..".win_size.x,$"../..".win_size.y)
	var player_position = $"../.."/Player.position
	var co = player_position.y-position.y
	var ca = player_position.x-position.x
	var hip = sqrt(co*co+ca*ca)
	var ang = rad_to_deg(asin(co/hip))
	if(ca < 0 && co > 0):
		ang = 90-ang
		ang += 90
	if(ca < 0 && co < 0):
		ang = abs(ang)
		ang += 180
	if(ca > 0 && co < 0):
		ang = 90-abs(ang)
		ang += 270
	return deg_to_rad(ang+90)
