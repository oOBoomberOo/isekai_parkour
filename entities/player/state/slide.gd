extends "on_ground.gd"

func _enter(_prev: Node):
	player().animator.play("slide")
	player().animator.connect("animation_finished", self, "finished")

func _exit(_new: Node):
	player().animator.disconnect("animation_finished", self, "finished")

func finished():
	emit_signal("pop")
