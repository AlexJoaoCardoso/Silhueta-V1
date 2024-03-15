extends Button

func _ready():
	self.pressed.connect(self._button_pressed)

func _process(_delta):
	pass

func _button_pressed():
	$"../..".resumeAll()
