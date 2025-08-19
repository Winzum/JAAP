extends Window

#func _ready():
	#self.connect("close_requested", Callable(self, "_on_close_requested"))

func _on_close_requested():
	queue_free()
