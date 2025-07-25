extends Button

#@onready var text_window = preload("res://screens/TextWindow.tscn")
@onready var text_node = preload("res://screens/TextGraphNode.tscn")
@onready var graph_edit = $"../../GraphEdit"

func _on_pressed() -> void:
	#var new_text_window = text_window.instantiate()
	#new_text_window.name = "TextWindow"
	#new_text_window.size = Vector2(200, 300)
	#new_text_window.position = Vector2(randi() % 400, randi() % 300 + 20)
	#get_tree().root.add_child(new_text_window)
	#new_text_window.show()
	var node = text_node.instantiate()
	graph_edit.add_child(node)
