extends Area2D

@onready var start_position
@onready var start_rotation
@onready var target
@onready var target_position:Vector2
@onready var win_size
@onready var SPEED

func _ready():
	position = start_position
	rotation = start_rotation
	target_position = getRotation(start_position,target)
	
# calcula rotação entre dois pontos no plano cartesiano
func getRotation(start:Vector2, tar:Vector2):
	var result:Vector2 = start
	var angle = start.angle_to_point(tar)
	if(angle > 0 && angle < PI/2):
		angle = PI/2-angle
		result.x = sin(angle)*1000+start.x
		result.y = cos(angle)*1000+start.y
	elif(angle > PI/2 && angle < PI):
		angle = PI/2+angle
		result.x = sin(angle)*1000+start.x
		result.y = -cos(angle)*1000+start.y
	elif(angle > -PI && angle < -PI/2):
		angle = PI/2-angle
		result.x = sin(angle)*1000+start.x
		result.y = cos(angle)*1000+start.y
	else:
		angle = PI/2+angle
		result.x = sin(angle)*1000+start_position.x
		result.y = -cos(angle)*1000+start_position.y
	return result

func _process(delta):
	# move em direção ao alvo
	position = position.move_toward(target_position,delta*SPEED)
	
	# se moveu 3000 unidades ou bateu no alvo, destrói a si mesmo
	if(dist(position,start_position) > 3000 || position == target_position):
		self.queue_free()
	
func dist(a:Vector2, b:Vector2):
	return sqrt(pow(b.x-a.x,2)+pow(b.y-a.y,2))

# se algum corpo entrou na área de colisão
func _on_body_entered(body):
	# se um player acerta um drone
	if(body.get_parent().name == "Drones" && self.get_child(0,false).material.get_shader_parameter("BlueOrRed") == 1):
		if($".."/Player.hp < 95):
			$".."/Player.hp += 5
		$".."/Player.kills += 1
		body.queue_free()
	# se um drone acerta o player
	elif(body.name == "Player" && self.get_child(0,false).material.get_shader_parameter("BlueOrRed") == 0):
		$"../.."/Player.hp -= 10
	# se um player acerta um scout/boss
	elif(body.name == "Boss" && self.get_child(0,false).material.get_shader_parameter("BlueOrRed") == 1):
		body.hp -= 50
	# destrói a si mesmo sempre, para incluir paredes/objetos
	self.queue_free()
