extends Button

@onready var JaapInfoScene = preload("res://screens/InfoScreen.tscn")

func _on_pressed() -> void:
	var JaapInfo = JaapInfoScene.instantiate()
	JaapInfo.name = "JaapInfoPopup"
	get_tree().root.add_child(JaapInfo)
	JaapInfo.show()
