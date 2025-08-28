extends BaseGraphNode

@onready var panel_container = $CanvasLayer/PanelContainer
@onready var panel_text = $CanvasLayer/PanelContainer/TextEdit

var marked_words = [] # {start: int, end: int, text: String}

func initialize_slot(start_text:String = "Enter text...") -> void:
	$TextEdit_0.text = start_text
	set_slot(1, true, 1, Color.MEDIUM_PURPLE, true, 1, Color.TURQUOISE)

func _on_text_edit_focus_entered() -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	panel_container.size = viewport_size * 0.8
	panel_container.position = (viewport_size - panel_container.size) / 2
	panel_container.show()
	
func _on_popup_panel_popup_hide() -> void:
	$TextEdit_0.text = panel_text.text
	panel_container.hide()

func _on_text_edit_gui_input(event: InputEvent) -> void:
	#on right click
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		$PopupMenu.position = get_viewport().get_mouse_position()
		$PopupMenu.show()
		$PopupMenu.grab_focus()
		accept_event()

func _on_text_edit_text_changed() -> void:
	var caret = {
			"col": panel_text.get_selection_from_column(),
			"line":	panel_text.get_selection_from_line()
			}
	var line = panel_text.text.split("\n")[caret["line"]]
	var updated_marks = []
	for mark in marked_words:
		if mark["start_line"] == caret["line"]:
			var word_start = find_closest_occurrence(line, mark["text"], mark["start_col"])
			if word_start != -1: 
				# found word start is at most 1 character over
				if abs(word_start - mark["start_col"]) <= 1:
					updated_marks.append({
						"start_line": mark["start_line"],
						"start_col": word_start,
						"end_line": mark["end_line"],
						"end_col": word_start + len(mark["text"]),
						"text": mark["text"]
					})
		else:
			updated_marks.append(mark)
	marked_words = updated_marks
	#print(marked_words)

func _on_popup_menu_id_pressed(id: int) -> void:
	match id:
		# on highlight text pressed
		0:
			var new_marked_word = {
				"start_line": panel_text.get_selection_from_line(),
				"start_col": panel_text.get_selection_from_column(),
				"end_line": panel_text.get_selection_to_line(),
				"end_col": panel_text.get_selection_to_column(),
				"text": panel_text.get_selected_text()
				}
			if can_add_item(marked_words, new_marked_word) and len(new_marked_word["text"]) > 0:
				marked_words.append(new_marked_word)
			#toevoegen link
			print(marked_words)

func can_add_item(existing_items: Array, new_item: Dictionary) -> bool:
	for item in existing_items:
		if item["start_line"] == new_item["start_line"]:
			if not (new_item["end_col"] <= item["start_col"] or new_item["start_col"] >= item["end_col"]):
				return false
	return true

func find_closest_occurrence(line: String, word: String, original_col: int) -> int:
	var positions = []
	var idx = -1
	while true:
		idx = line.find(word, idx + 1)
		if idx == -1:
			break
		positions.append(idx)
	if positions.size() == 0:
		return -1
	# Find the occurrence closest to the original position
	var closest = positions[0]
	var min_dist = abs(closest - original_col)
	for pos in positions:
		var dist = abs(pos - original_col)
		if dist < min_dist:
			closest = pos
		min_dist = dist
	return closest
