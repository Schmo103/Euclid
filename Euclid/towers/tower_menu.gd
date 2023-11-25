class_name TowerMenu
extends Control

signal sell_clicked

func _ready() -> void:
	visible = false

func _on_sell_pressed():
	sell_clicked.emit()
	accept_event()
