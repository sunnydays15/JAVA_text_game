extends Control

@onready var location_label : Label = $location_label
@onready var explore_btn := $"menu_container/explore_button"
@onready var status_button = $menu_container/status_button
@onready var inventory_button = $menu_container/inventory_button
@onready var exit_button = $menu_container/exit_button

# 현재 위치
var current_floor = 1
var current_room = 1

func _ready():
    explore_btn.disabled = false   # 씬이 열릴 때 반드시 활성화
    # 위치 표시
    update_location_text()

func _notification(what):
    if what == NOTIFICATION_READY:
        update_location_text()

func update_location_text():
    if GameState.floor % 10 == 0:
        location_label.text = "===== 현재 위치: %d층 보스 방 =====" % GameState.floor
    else:
        location_label.text = "===== 현재 위치: %d층 %d번 방 =====" % [GameState.floor, GameState.room]



func _on_explore_button_pressed() -> void:
    explore_btn.disabled = true            # 중복 호출 방지
    
    var first_room := GameState.room == 1
    var can_flee   := not (GameState.floor % 10 == 0) and not first_room
    
    if can_flee and randf() < 0.30:
        GameState.advance_room()
        update_location_text()
        $"menu_container/explore_button".disabled = false       # 방만 넘겼을 땐 다시 활성
        return

    GameState.create_monster()
    GameState.state = GameState.ST_BATTLE
    get_tree().change_scene_to_file("res://시작화면/Battle.tscn")


func _on_status_button_pressed() -> void:
    var status_menu : Control = get_node_or_null("StatusMenu")
    var text_panel  : Control = get_node_or_null("../글상자")
    var btns        : Control = get_node_or_null("menu_container")

    if not status_menu:
        push_error("StatusMenu 노드를 찾지 못했습니다 → 노드 이름·위치 확인")
        return

    status_menu.visible = true
    if text_panel: text_panel.visible = false
    if btns:       btns.visible       = false


func _on_back_button_pressed() -> void:
    var status_menu : Control = get_node_or_null("StatusMenu")
    var text_panel  : Control = get_node_or_null("../글상자")
    var btns        : Control = get_node_or_null("menu_container")

    if not status_menu:
        push_error("StatusMenu 노드를 찾지 못했습니다 → 노드 이름·위치 확인")
        return

    status_menu.visible = false
    if text_panel: text_panel.visible = true
    if btns:       btns.visible       = true


func _on_inventory_button_pressed() -> void:
    var inv_menu : Control = get_node_or_null("InventoryMenu")
    var btns     : Control = get_node_or_null("menu_container")
    var text_panel = get_node_or_null("../글상자")

    if not inv_menu:
        push_error("InventoryMenu 노드를 찾지 못했습니다 → 노드 이름·위치 확인")
        return

    inv_menu.visible = true
    inv_menu.update_inventory()
    if btns: btns.visible = false
    if text_panel: text_panel.visible = false
    $"용사".visible = false


func _on_exit_button_pressed() -> void:
    get_tree().quit()
