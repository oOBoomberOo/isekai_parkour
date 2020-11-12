extends Node2D

export (NodePath) var path

onready var target: Node2D = get_node(path)

func _process(_delta):
	position.x = target.position.x
