extends Control

signal confirmed
signal cancelled

func setup(message: String) -> void:
	$ColorRect/PanelContainer/MarginContainer/VBoxContainer/Label.text = message

func _on_button_confirm_pressed() -> void:
	confirmed.emit()
	queue_free()

func _on_button_cancel_pressed() -> void:
	cancelled.emit()
	queue_free()
