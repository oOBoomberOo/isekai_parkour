tool
extends TextureButton

class_name CustomButton

export(String) var content = "" setget set_content

func _ready() -> void:
	set_content(content)

func set_content(value):
	content = value
	if $Label != null:
		$Label.text = content
