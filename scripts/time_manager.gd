extends CanvasLayer
class_name TimeManager

## Echtzeit-Uhr (HH:MM:SS) + Pause-Button

@onready var time_label: Label = $TimePanel/HBox/TimeLabel
@onready var pause_btn: Button = $TimePanel/HBox/PauseBtn

var elapsed: float = 0.0
var paused: bool = false

func _ready() -> void:
	pause_btn.pressed.connect(_on_pause_pressed)
	_update_label()

func _process(delta: float) -> void:
	if not paused:
		elapsed += delta
		_update_label()

func _update_label() -> void:
	var total := int(elapsed)
	var h := total / 3600
	var m := (total % 3600) / 60
	var s := total % 60
	time_label.text = "%02d:%02d:%02d" % [h, m, s]

func _on_pause_pressed() -> void:
	paused = not paused
	pause_btn.text = "▶ WEITER" if paused else "⏸ PAUSE"
	# Auch den restlichen Game-Tree pausieren (optional, für echte Pause)
	get_tree().paused = paused
	# Damit der Button selbst noch klickbar bleibt
	pause_btn.process_mode = Node.PROCESS_MODE_ALWAYS
	time_label.process_mode = Node.PROCESS_MODE_ALWAYS

func is_paused() -> bool:
	return paused

func get_elapsed() -> float:
	return elapsed
