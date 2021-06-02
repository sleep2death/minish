extends MarginContainer

onready var output = $Output
const mb := 1024 * 1024

func _physics_process(_delta):
	output.text = var2str(Performance.get_monitor(Performance.TIME_FPS)) + "\n"
	var mem = Performance.get_monitor(Performance.MEMORY_DYNAMIC) / mb
	mem = floor(mem * 1000) / 1000
	output.text += str(mem) + "MB"
