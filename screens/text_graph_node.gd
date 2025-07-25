extends GraphNode

func _ready() -> void:
	set_slot(1, true, 1, Color.RED, true, 1, Color.BLUE)

# adds or removes the amount of node output slots to the node
func _add_node_slots(n: int) -> void:
	var output_count = get_output_port_count()
	if n < 0:
		var remove_count = min(-n, output_count - 1)
		for i in range(remove_count):
			clear_slot(output_count)
			get_child(output_count).queue_free()
	elif n > 0:
		for i in range(n):
			var text_edit_new = TextEdit.new()
			text_edit_new.custom_minimum_size = Vector2(0,40)
			add_child(text_edit_new)
			set_slot(output_count + 1 + i, false, 1, Color.RED, true, 1, Color.BLUE)		

func _on_close_button_pressed() -> void:
	queue_free()
