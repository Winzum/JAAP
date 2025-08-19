extends BaseGraphNode
class_name ContextGraphNode

func initialize_slot(start_text:String = "") -> void:
	$TextEdit_0.text = start_text
	set_slot(1, true, 1, Color.SKY_BLUE, false, 1, Color.BLUE)
