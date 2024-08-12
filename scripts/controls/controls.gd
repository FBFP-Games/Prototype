extends Node
class_name Controls
class Player:
	extends Object
	static func move_node2D(node: Node2D, speed: int):
		var x_direction = Input.get_axis("left", "right")
		var y_direction = Input.get_axis("up", "down")
		if x_direction:
			node.velocity.x = x_direction * speed
		else:
			node.velocity.x = move_toward(node.velocity.x, 0, speed)
			
		if y_direction:
			node.velocity.y = y_direction * speed
		else:
			node.velocity.y = move_toward(node.velocity.y, 0, speed)

		node.move_and_slide()
