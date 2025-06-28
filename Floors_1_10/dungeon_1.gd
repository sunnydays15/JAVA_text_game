extends Node2D

@onready var text_panel = $글상자/TextPanel

func _ready():
    text_panel.start_typing()
