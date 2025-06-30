extends Control

@onready var heart_label     = $HeartPotionLabel
@onready var heart_btn       = $HeartUseButton
@onready var exp_label       = $ExpPotionLabel
@onready var exp_btn         = $ExpUseButton
@onready var special_label   = $SpecialPotionLabel
@onready var special_btn     = $SpecialUseButton
@onready var close_btn       = $CloseButton
@onready var toast_label     = $ToastLabel

func _ready():
    update_inventory()

    heart_btn.pressed.connect(_on_heart_use)
    exp_btn.pressed.connect(_on_exp_use)
    special_btn.pressed.connect(_on_special_use)
    close_btn.pressed.connect(_on_close)

# 인벤토리 수량 업데이트
func update_inventory():
    heart_label.text = "하트물약: %d개" % GameState.heart_potions
    exp_label.text = "경험치물약: %d개" % GameState.exp_potions
    special_label.text = "스페셜물약: %d개" % GameState.special_potions

# 하트물약 사용
func _on_heart_use():
    if GameState.heart_potions > 0:
        GameState.heart_potions -= 1
        GameState.player_hp = min(GameState.player_hp + 30, GameState.player_maxhp)
        _show_toast("하트물약을 사용해 체력이 회복되었습니다!")
    else:
        _show_toast("하트물약이 없습니다!")
    update_inventory()
    var status_menu = get_tree().root.find_child("StatusMenu", true, false)
    if status_menu:
        status_menu.update_status()

# 경험치물약 사용
func _on_exp_use():
    if GameState.exp_potions > 0:
        GameState.exp_potions -= 1
        GameState.gain_exp(30)
        _show_toast("경험치물약을 사용해 경험치를 얻었습니다!")
    else:
        _show_toast("경험치물약이 없습니다!")
    update_inventory()
    var status_menu = get_tree().root.find_child("StatusMenu", true, false)
    if status_menu:
        status_menu.update_status()

# 스페셜물약 사용
func _on_special_use():
    if GameState.special_potions > 0:
        GameState.special_potions -= 1
        GameState.player_hp = min(GameState.player_hp + 50, GameState.player_maxhp)
        GameState.gain_exp(50)
        _show_toast("스페셜물약을 사용해 체력과 경험치를 얻었습니다!")
    else:
        _show_toast("스페셜물약이 없습니다!")
    update_inventory()
    var status_menu = get_tree().root.find_child("StatusMenu", true, false)
    if status_menu:
        status_menu.update_status()

# 인벤토리 닫기
func _on_close():
    visible = false
    $"../용사".visible = true

    var btns = get_parent().get_node_or_null("menu_container")
    if btns:
        btns.visible = true

# 토스트 메시지 표시
func _show_toast(msg: String):
    toast_label.text = msg
    toast_label.visible = true
    await get_tree().create_timer(1.0).timeout
    toast_label.visible = false
