extends Control

@onready var text_node = preload("res://screens/TextGraphNode.tscn")
@onready var JaapInfoScene = preload("res://screens/InfoScreen.tscn")
@onready var graph_edit = $VBoxContainer/GraphEdit

func _on_add_text_pressed() -> void:
	var new_node = text_node.instantiate()
	graph_edit.add_child(new_node)

func _on_info_pressed() -> void:
	var JaapInfo = JaapInfoScene.instantiate()
	JaapInfo.name = "JaapInfoPopup"
	get_tree().root.add_child(JaapInfo)
	JaapInfo.show()

func _on_graph_edit_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	if from_node != to_node:
		graph_edit.connect_node(from_node, from_port, to_node, to_port)

func _on_graph_edit_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph_edit.disconnect_node(from_node, from_port, to_node, to_port)

func _on_export_pressed() -> void:
	var source_node = get_origin_node(graph_edit.connections)
	var connections = format_connections(graph_edit.connections)
	if source_node == "" or connections.size() == 0:
		return

	var texts_list = extract_node_connection_text(source_node, connections)
	export_to_user_folder(texts_list)

func get_origin_node(connections: Array) -> String:
	var from_nodes = {}
	var to_nodes = {}
	var source_node = ""
	
	for connection in graph_edit.connections:
		from_nodes[connection.from_node] = true
		to_nodes[connection.to_node] = true
		
	for from_node in from_nodes:
		if not to_nodes.has(from_node):
			source_node = from_node
			return source_node
	#TODO what if no connections found?
	return source_node

func format_connections(connections: Array) -> Dictionary:
	var formatted_connections = {}
	#add all from nodes before adding the connection points
	for connection in connections:
		formatted_connections[connection.from_node] = {}
		
	for connection in connections:
		formatted_connections[connection.from_node][connection.from_port] = connection.to_node
		
	return formatted_connections

#recurively extract the texts of all nodes
func extract_node_connection_text(node_name: String, connections: Dictionary) -> Array:
	var texts = []
	var from_node = graph_edit.get_node(node_name)
	var connected_ports = connections.get(node_name, {})
	var from_node_TextEdits = from_node.find_children("TextEdit_*", "", false, false)
	
	for i in range(from_node_TextEdits.size()):
		texts.append(from_node_TextEdits[i].text)
		if connected_ports.has(i):
			texts.append_array(extract_node_connection_text(connected_ports[i], connections))
	return texts

func export_to_user_folder(texts_list: Array) -> void:
	var file_path = "user://exported_data.txt"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		for text in texts_list:
			file.store_line(text)
		file.close()
	print("file exported to ", file_path)
