extends Control

@onready var text_node = preload("res://screens/TextGraphNode.tscn")
@onready var JaapInfoScene = preload("res://screens/InfoScreen.tscn")
@onready var graph_edit = $VBoxContainer/GraphEdit

func _on_add_text_pressed() -> void:
	var node = text_node.instantiate()
	graph_edit.add_child(node)

func _on_info_pressed() -> void:
	var JaapInfo = JaapInfoScene.instantiate()
	JaapInfo.name = "JaapInfoPopup"
	get_tree().root.add_child(JaapInfo)
	JaapInfo.show()

func _on_graph_edit_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph_edit.connect_node(from_node, from_port, to_node, to_port)

func _on_export_pressed() -> void:
	for conn in graph_edit.connections:
		var from_node = conn["from_node"]
		print(from_node)
		var to_node = conn["to_node"]
		print(to_node)
		
