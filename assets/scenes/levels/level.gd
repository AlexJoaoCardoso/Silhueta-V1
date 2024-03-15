extends Node2D

const BASE_WIDTH = 1152
const BASE_HEIGHT = 642
var win_size = Vector2i(BASE_WIDTH,BASE_HEIGHT)

func _ready():
	DisplayServer.window_set_size(Vector2(BASE_WIDTH,BASE_HEIGHT))
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	# camera e UI fixas no player
	#$Camera2D.position = $Player.position
	#$UI.position = $Player.position
	
	# botão menu apertado (Esc)
	if(Input.is_action_just_pressed("menu")):
		$UI/Quit.visible = not $UI/Quit.visible
		$UI/Paused.visible = not $UI/Paused.visible
		$UI/Restart.visible = not $UI/Restart.visible
		$UI/Resume.visible = not $UI/Resume.visible
		get_tree().paused = not get_tree().paused
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# recalcula tamanho da janela
	if(DisplayServer.window_get_size() != win_size):
		win_size = DisplayServer.window_get_size()
	
	# crosshair em cima do mouse
	get_node("UI/Crosshair").position = get_viewport().get_mouse_position()-Vector2(win_size.x,win_size.y)/2
	
	# imprime e posiciona HP e tamanho da barra de vida
	get_node("UI/HP").text = str("[font_size=32][b]HP[/b]: ",%Player.hp,"/100[/font_size]")
	get_node("UI/HP").position = Vector2(-win_size.x/2+60,-win_size.y/2+45)
	if(%Player.hp>=0):
		var tam = %Player.hp if %Player.hp <= 100 else 100
		get_node("UI/HealthBar/Progress").region_rect.size.x = tam/100.0
	else:
		get_node("UI/HP").text = str("[font_size=32][b]HP[/b]: 0/100[/font_size]")
		get_node("UI/HealthBar/Progress").region_rect.size.x = 0
	get_node("UI/HealthBar").position = Vector2(-win_size.x/2+30,-win_size.y/2+30)
	
	# vida do boss
	get_node("UI/BossHP").text = str("[font_size=32][b]Boss HP[/b]: ",$Scouts/Boss.hp,"/",%Boss.max_hp,"[/font_size]")
	get_node("UI/BossHP").position = Vector2(-360,-win_size.y/2)
	get_node("UI/BossHealthBar").position = Vector2(-400,-win_size.y/2)
	if(%Boss.hp>=0):
		var tam = %Boss.hp if %Boss.hp <= %Boss.max_hp else %Boss.max_hp
		get_node("UI/BossHealthBar/Progress").region_rect.size.x = tam/1000.0
	else:
		get_node("UI/BossHP").text = str("[font_size=32][b]Boss HP[/b]: 0/",%Boss.max_hp,"[/font_size]")
		get_node("UI/BossHealthBar/Progress").region_rect.size.x = 0
	
	# imprime e posiciona kills
	
	# pausa jogo se morrer ou ganhar
	if(%Player.hp<=0):
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$UI/Restart.visible = true
		$UI/Quit.visible = true
		$UI/Defeat.visible = true
	if(%Boss.hp<=0):
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$UI/Restart.visible = true
		$UI/Quit.visible = true
		$UI/Victory.visible = true

# reseta level completo
func resetAll():
	$UI/Restart.visible = false
	$UI/Resume.visible = false
	$UI/Quit.visible = false
	$UI/Victory.visible = false
	$UI/Defeat.visible = false
	$UI/Paused.visible = false
	get_tree().paused = false
	$Player.hp = 100
	%Boss.hp = %Boss.max_hp
	$Player.kills = 0
	$Player.position = Vector2(-300,100)
	#$Camera2D.position = $Player.position
	#$UI.position = $Player.position
	for i in $Drones.get_children(false):
		if(i.is_class("CharacterBody2D") || i.is_class("Area2D")):
			i.queue_free()
	clearBullets()

func clearBullets():
	for i in $Scouts.get_children(false):
		if(i.is_class("Area2D")):
			i.queue_free()
	for i in $Bullets.get_children(false):
		if(i.is_class("Area2D")):
			i.queue_free()

# resume o jogo do jeito que está
func resumeAll():
	$UI/Restart.visible = false
	$UI/Resume.visible = false
	$UI/Quit.visible = false
	$UI/Paused.visible = false
	get_tree().paused = false
