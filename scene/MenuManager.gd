extends Control

onready var popup = $PopupDialog

func _ready():
	$"Main Menu".connect("singleplayer", self, "_on_click_single_player")
	$"Main Menu".connect("multiplayer", self, "_on_click_multi_player")
	$"Main Menu".connect("option", self, "_on_click_option")

func _on_click_single_player():
	get_tree().change_scene("res://scene/World.tscn")

func _on_click_multi_player():
	show_popup("Multiplayer is not available")

func _on_click_option():
	show_popup("There's no options right now")

func show_popup(message):
	popup.get_node("Message").text = message
	popup.popup()
