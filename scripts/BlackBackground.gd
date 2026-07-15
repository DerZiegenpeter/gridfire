extends ColorRect

func _ready() -> void:
    # Make sure it always fills the current viewport
    size = get_viewport_rect().size
    get_viewport().connect("size_changed", _on_viewport_size_changed)

func _on_viewport_size_changed() -> void:
    size = get_viewport_rect().size