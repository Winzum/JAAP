extends BaseGraphNode

var marked_words = [] # {start: int, end: int, text: String}

func initialize_slot(start_text:String = "Enter text...") -> void:
	$TextEdit_0.text = start_text
	set_slot(1, true, 1, Color.MEDIUM_PURPLE, true, 1, Color.TURQUOISE)

func _on_text_edit_focus_entered() -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	$CanvasLayer/PanelContainer.size = viewport_size * 0.8
	$CanvasLayer/PanelContainer.position = (viewport_size - $CanvasLayer/PanelContainer.size) / 2
	$CanvasLayer/PanelContainer.show()
	
func _on_popup_panel_popup_hide() -> void:
	$TextEdit_0.text = $CanvasLayer/PanelContainer/TextEdit.text
	$CanvasLayer/PanelContainer.hide()

func _on_text_edit_gui_input(event: InputEvent) -> void:
	#on right click
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		$PopupMenu.position = get_viewport().get_mouse_position()
		$PopupMenu.show()
		$PopupMenu.grab_focus()
		accept_event()
