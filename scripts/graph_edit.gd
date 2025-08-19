extends GraphEdit
@onready var text_node = preload("res://nodes/TextGraphNode.tscn")
@onready var context_node = preload("res://nodes/ContextGraphNode.tscn")

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	if from_node != to_node:
		connect_node(from_node, from_port, to_node, to_port)

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)

func add_graph_node(data: Dictionary = {}):
	var new_node = text_node.instantiate()
	if "type" in data:
		#if data["type"] == "TextGraphNode":
			#new_node = text_node.instantiate()
		if data["type"] == "ContextGraphNode":
			new_node = context_node.instantiate()

	if "name" in data:
		new_node.name = data["name"]
	
	if "title" in data:
		new_node.title = data["title"]
	
	if "position" in data:
		var pos = data["position"]
		if typeof(pos) == TYPE_VECTOR2:
			new_node.position_offset = pos
		else:
			new_node.position_offset = str_to_var("Vector2" + pos)
	else:
		new_node.position_offset = (scroll_offset / zoom + get_size() / (2 * zoom)) - new_node.size / 2
	
	if "size" in data:
		new_node.size = str_to_var("Vector2" + data["size"])
		
	if "textedits" in data:
		var text_edits = data["textedits"]
		new_node.initialize_slot(text_edits["0"])
		for key in text_edits:
			if key != "0":
				new_node.add_known_field(int(key), "TextEdit_" + key, text_edits[key])
	else:
		new_node.initialize_slot()
	
	add_child(new_node)

#gets connections in a formatted format
func get_formatted_connections(input_connections: Array) -> Dictionary:
	var formatted_connections = {}
	#add all from nodes before adding the connection points
	for connection in input_connections:
		formatted_connections[connection.from_node] = {}
		
	for connection in input_connections:
		formatted_connections[connection.from_node][connection.from_port] = connection.to_node
		
	return formatted_connections

#gets info of all child nodes and returns it 
func get_graph_data() -> Dictionary:
	var data = {
		"nodes": [],
		"connections": {}
	}
	for node in get_children():
		if node is BaseGraphNode:
			data["nodes"].append({
				"type": node.get_graph_class(),
				"name": node.name,
				"title": node.title,
				"position": node.position_offset,
				"size": node.size,
				"textedits": node.get_textedit_text()
			})
	data["connections"] = connections
	return data

#takes graph data and fills the graph with it
func set_graph_data(data: Dictionary) -> void:
	reset_graph_data()
	for node in data["nodes"]:
		add_graph_node(node)
	connections = data["connections"]
	queue_redraw()

#removes all child nodes and resets connections
func reset_graph_data() -> void:
	for node in get_children():
		if node is BaseGraphNode:
			node.free()
	clear_connections()
