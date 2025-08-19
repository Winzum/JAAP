extends BaseGraphNode
class_name TextGraphNode

func initialize_slot(start_text:String = "") -> void:
	$TextEdit_0.text = start_text
	set_slot(1, true, 1, Color.RED, true, 1, Color.BLUE)

#TODO merge with the method?
func add_known_field(field_port: int, field_name: String, field_text: String) -> void:
	var text_edit_new = TextEdit.new()
	text_edit_new.custom_minimum_size = Vector2(0,40)
	text_edit_new.name = field_name
	text_edit_new.text = field_text
	set_slot(field_port+1, false, 1, Color.RED, true, 1, Color.BLUE)
	add_child(text_edit_new)


# adds or removes text slots to the node. Adds if true, removes if false
func _add_node_slots(add: bool) -> void:
	var output_count = get_output_port_count()
	print(output_count)
	if add:
		var text_edit_new = TextEdit.new()
		text_edit_new.custom_minimum_size = Vector2(0,40)
		text_edit_new.name = "TextEdit_%d" % (output_count)
		set_slot(output_count + 1, false, 1, Color.RED, true, 1, Color.BLUE)
		add_child(text_edit_new)
		size.y += 40
	elif output_count > 1:
		clear_slot(output_count)
		# for now this is compensated for the popupmenu node
		get_child(output_count + 1).queue_free()
		size.y -= 40
