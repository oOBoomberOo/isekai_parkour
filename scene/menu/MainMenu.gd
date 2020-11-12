extends MarginContainer

signal singleplayer
signal multiplayer
signal option

func _on_pressed_singleplayer():
	emit_signal("singleplayer")

func _on_pressed_multiplayer():
	emit_signal("multiplayer")

func _on_pressed_option():
	emit_signal("option")
