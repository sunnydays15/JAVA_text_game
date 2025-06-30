extends NinePatchRect
signal finished

@onready var label = $encounter_label
@export var typing_speed := 0.05

func _ready():
    if GameState.monster.is_empty():
        hide()                                # monster 없으면 패널 표시하지 않음
        return

    var m = GameState.monster
    
    var text : String = ""
    if GameState.floor % 10 == 0:
        text = "%d층 보스 %s이(가) 나타났습니다!" % [GameState.floor, m.name]
    else:
        text = "Level %d %s이(가) 나타났습니다!" % [m.level, m.name]
        
    await _type_out(text)
    emit_signal("finished")                   # Battle.gd 로 UI 해제 알림

func _type_out(t:String):
    for i in t.length():
        label.text += t[i]
        await get_tree().create_timer(typing_speed).timeout
