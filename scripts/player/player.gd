extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta):
	Controls.Player.move_node2D(self, SPEED)
