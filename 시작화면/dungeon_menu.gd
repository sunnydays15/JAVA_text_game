extends Control

@onready var location_label = $location_label
@onready var explore_button = $menu_container/explore_button
@onready var status_button = $menu_container/status_button
@onready var inventory_button = $menu_container/inventory_button
@onready var exit_button = $menu_container/exit_button

# 현재 위치
var current_floor = 1
var current_room = 1

func _ready():
    # 위치 표시
    update_location_text()
    
    # 버튼 연결
    explore_button.pressed.connect(_on_explore_pressed)
    status_button.pressed.connect(_on_status_pressed)
    inventory_button.pressed.connect(_on_inventory_pressed)
    exit_button.pressed.connect(_on_exit_pressed)

func update_location_text():
    location_label.text = "===== 현재 위치: %d층 %d번 방 =====" % [current_floor, current_room]

# 각 버튼의 동작
func _on_explore_pressed():
    print("탐험하기 선택!")

func _on_status_pressed():
    # 상태 메뉴 가져오기
    var status_menu = get_tree().root.find_child("StatusMenu", true, false)
    status_menu.visible = true
    
    # TextPanel 숨기기
    var text_panel = get_parent().get_node("글상자")
    text_panel.visible = false
    
    # 본인(DungeonMenu) 숨기기
    self.visible = false

func _on_inventory_pressed():
    print("인벤토리 확인 선택!")

func _on_exit_pressed():
    get_tree().quit()
