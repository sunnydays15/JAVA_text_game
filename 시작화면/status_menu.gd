extends Control

@onready var status_label = $status_label
@onready var back_button = $back_button

func _ready():
    back_button.pressed.connect(_on_back_pressed)
    update_status()

func update_status():
    var gs = GameState
    status_label.text = """===== 플레이어 상태 =====
이름: %s
레벨: %d
경험치: %d / %d
체력: %d / %d
공격력 : %d
무기: %s
방어구: %s
처치한 몬스터 수: %d
=========================""" % [
        gs.player_name,
        gs.player_lv,
        gs.player_exp,
        gs.next_exp,
        gs.player_hp,
        gs.player_maxhp,
        gs.player_atk,
        gs.weapon,
        gs.armor,
        gs.monster_kills
    ]

func _on_back_pressed():
    var d_menu = get_tree().root.find_child("DungeonMenu", true, false)
    d_menu.visible = true
    self.visible = false
