extends GraphNode
class_name BaseGraphNode

@export var popup_container: Popup
@export var close_button: Button
@export var graph_class_name: String = "BaseGraphNode"

@onready var popup_menu: PopupMenu = popup_container.get_node("PopupMenu")
@onready var popup_rename: PopupPanel =  popup_container.get_node("PopupRename")
@onready var line_edit: LineEdit = popup_container.get_node("PopupRename/LineEdit")
@onready var graph_edit = get_parent()

func _ready() -> void:
	if close_button:
		close_button.pressed.connect(_on_close_button_pressed)
	if popup_container:
		self.gui_input.connect(_on_gui_input)
		popup_menu.index_pressed.connect(_on_popup_menu_index_pressed)
		line_edit.text_submitted.connect(_on_rename_text_submitted)

func _on_close_button_pressed() -> void:
	queue_free()

func _on_gui_input(event: InputEvent) -> void:
	#on right click
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		var popup_location = get_global_transform().origin + (event.position * graph_edit.zoom)
		popup_menu.position = popup_location
		popup_rename.position = popup_location
		popup_menu.show()
		accept_event()

func _on_popup_menu_index_pressed(index: int) -> void:
	match index:
		0:
			popup_rename.show()
			line_edit.grab_focus()
		1:
			_on_close_button_pressed()

func _on_rename_text_submitted(new_text: String) -> void:
	title = new_text
	popup_rename.hide()

#returns the text of all textedits of the current node
func get_textedit_text() -> Dictionary:
	var texts = {}
	var text_edits = find_children("TextEdit_*", "", false, false)
	for i in text_edits.size():
		texts[i] = text_edits[i].text
	return texts

func get_graph_class() -> String:
	return graph_class_name
