extends PanelContainer
class_name CallForFireUI

## Call for Fire Dialog – Bundeswehr Funkverfahren

@onready var log_label: RichTextLabel = $Margin/VBox/Log
@onready var options_container: VBoxContainer = $Margin/VBox/Options

enum Phase { START, TARGET_DESC, ENGAGEMENT, CONTROL, END }

var current_phase: Phase = Phase.START
var b_stelle_pos: Vector2
var target_grid: String = ""
var is_active := false

var log_entries: Array[String] = []

var current_target_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	visible = false

func start_call_for_fire(b_pos: Vector2) -> void:
	b_stelle_pos = b_pos
	is_active = true
	current_phase = Phase.START
	log_entries.clear()
	_add_log("[color=#88cc88]B-Stelle an Feuerleit: Feueranforderung, kommen.[/color]")
	visible = true
	_show_options_for_phase()

func _add_log(text: String) -> void:
	log_entries.append(text)
	_update_log()

func _update_log() -> void:
	var full := ""
	for entry in log_entries:
		full += entry + "\n"
	log_label.text = full
	log_label.scroll_to_line(log_label.get_line_count() - 1)

func _show_options_for_phase() -> void:
	# Clear old buttons
	for child in options_container.get_children():
		child.queue_free()

	match current_phase:
		Phase.START:
			_add_option("Ziel beschreiben (Grid)", _on_target_grid)
			_add_option("Abbrechen", _on_cancel)

		Phase.TARGET_DESC:
			_add_option("Feueranforderung fortsetzen", _on_engagement)
			_add_option("Abbrechen", _on_cancel)

		Phase.ENGAGEMENT:
			_add_option("Adjust Fire", _on_adjust_fire)
			_add_option("Fire for Effect", _on_fire_for_effect)
			_add_option("Abbrechen", _on_cancel)

		Phase.CONTROL:
			_add_option("Ende des Feuers", _on_end_fire)
			_add_option("Abbrechen", _on_cancel)

func _add_option(text: String, callback: Callable) -> void:
	var btn := Button.new()
	btn.text = text
	btn.pressed.connect(callback)
	options_container.add_child(btn)

func _on_target_grid() -> void:
	# Simulate grid input – in Zukunft per Klick auf Karte
	current_target_pos = b_stelle_pos + Vector2(randf_range(-300, 300), randf_range(-200, 200))
	target_grid = "GRID %06d %07d" % [int(current_target_pos.x * 5 + 512000), int(5480000 + (2000 - current_target_pos.y) * 5)]
	_add_log("[color=#aaffaa]B-Stelle: Ziel Grid %s, kommen.[/color]" % target_grid)
	current_phase = Phase.TARGET_DESC
	_show_options_for_phase()

func _on_engagement() -> void:
	_add_log("[color=#88cc88]Feuerleit: Roger, Ziel erfasst. Art des Feuers? Kommen.[/color]")
	current_phase = Phase.ENGAGEMENT
	_show_options_for_phase()

func _on_adjust_fire() -> void:
	_add_log("[color=#aaffaa]B-Stelle: Adjust Fire, 1 Schuss, kommen.[/color]")
	current_phase = Phase.CONTROL
	_show_options_for_phase()

func _on_fire_for_effect() -> void:
	_add_log("[color=#aaffaa]B-Stelle: Fire for Effect, 6 Schuss HE, kommen.[/color]")
	current_phase = Phase.CONTROL
	_show_options_for_phase()

func _on_end_fire() -> void:
	_add_log("[color=#88cc88]Feuerleit: Feuer beendet. Ende.[/color]")
	_end_call()

func _on_cancel() -> void:
	_add_log("[color=#ff8888]Abgebrochen. Ende.[/color]")
	_end_call()

func _end_call() -> void:
	is_active = false
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and is_active:
		_on_cancel()
