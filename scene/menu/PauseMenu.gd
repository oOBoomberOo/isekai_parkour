extends CenterContainer

signal resume
signal main_menu
signal exit

func _ready():
# warning-ignore:return_value_discarded
	$ButtonContainer/Resume.connect("pressed", self, "_on_resume")
# warning-ignore:return_value_discarded
	$ButtonContainer/MainMenu.connect("pressed", self, "_on_main_menu")
# warning-ignore:return_value_discarded
	$ButtonContainer/Exit.connect("pressed", self, "_on_exit")

func _on_resume():
	emit_signal("resume")
	set_pause(false)

func _on_main_menu():
	emit_signal("main_menu")
	set_pause(false)
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scene/menu/MenuManager.tscn")

func _on_exit():
	emit_signal("exit")
	get_tree().quit()

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_cancel"):
			toggle_pause()

func set_pause(value):
	get_tree().paused = value
	
	if value:
		show()
	else:
		hide()

func toggle_pause():
	set_pause(not get_tree().paused)
