extends Control

@onready var JaapInfoScene = preload("res://screens/InfoScreen.tscn")
@onready var graph_edit = $VBoxContainer/GraphEdit

# C#-stuff
var EpubExportScript = load("res://EpubExport.cs")
var EpubExport = EpubExportScript.new()

func _on_add_text_pressed() -> void:
	graph_edit.add_graph_node()

func _on_save_pressed() -> void:
	var data = graph_edit.get_graph_data()
	save_file(data)

func _on_load_pressed() -> void:
	var data = load_file("user://saved_data.json")
	graph_edit.set_graph_data(data)

func _on_info_pressed() -> void:
	var JaapInfo = JaapInfoScene.instantiate()
	JaapInfo.name = "JaapInfoPopup"
	get_tree().root.add_child(JaapInfo)
	JaapInfo.show()

func _on_export_txt_pressed() -> void:
	var source_node = get_origin_node(graph_edit.connections)
	var connections = graph_edit.get_formatted_connections(graph_edit.connections)
	if not (source_node == "" or connections.size() == 0):
		var texts_list = extract_node_connection_text(source_node, connections)
		export_to_user_folder(texts_list)


func _on_export_epub_pressed() -> void:
	EpubExport.PrintNTimes("testexport", 1)
	EpubExport.WriteBook()

func _on_reset_pressed() -> void:
	graph_edit.reset_graph_data()

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

#TODO refactor so both export and save function use a filebrowser
func save_file(data: Dictionary) -> void:
	var file_path = "user://saved_data.json"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	return

func load_file(file_path: String) -> Dictionary:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	return data
