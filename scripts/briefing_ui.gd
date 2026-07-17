extends PanelContainer

@onready var title_label: Label = $Margin/VBox/Title
@onready var body_label: RichTextLabel = $Margin/VBox/Body
@onready var close_btn: Button = $Margin/VBox/CloseBtn

func _ready() -> void:
	visible = false
	close_btn.pressed.connect(_on_close)

func show_briefing(enemy_dir: String) -> void:
	title_label.text = "LAGEVORTRAG / BRIEFING"

	var text := """
[b]1. LAGE[/b]
Feindliche Kräfte bereiten einen Angriff vor.

[b]2. FEIND[/b]
Hauptangriffsrichtung: [color=#ff6666][b]%s[/b][/color]
Erwartete Kräfte: mechanisierte Infanterie + unterstützende Artillerie.
Voraussichtlicher Schwerpunkt im zentralen Abschnitt.

[b]3. EIGENE KRÄFTE[/b]
• 1× B-Stelle (Beobachtungsstelle)
• 1× Feuerleitstelle
• 2× Haubitzenzug (155 mm)

Aufstellung erfolgt tief gestaffelt entgegen der Feindrichtung.

[b]4. AUFTRAG[/b]
Herstellung der Feuerbereitschaft.
Beobachtung des Feindes aus der B-Stelle.
Auf Anforderung: Call for Fire / Feueranforderung durchführen und Ziele bekämpfen.

[b]5. FÜHRUNG & FUNK[/b]
Feuerleit ist Ansprechpartner für alle Feueranforderungen.
B-Stelle meldet Ziele und leitet das Feuer.

[center][color=#88cc88]Bereitschaft herstellen. Warten auf erste Feindsichtung.[/color][/center]
""" % enemy_dir

	body_label.text = text
	visible = true

func _on_close() -> void:
	visible = false
