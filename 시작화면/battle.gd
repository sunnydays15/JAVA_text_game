extends Control

# ───────── Node 캐시 ─────────
@onready var encounter  : NinePatchRect = $EncounterPanel
@onready var mon_sprite : TextureRect   = $MonsterSprite
@onready var mon_hp     : ProgressBar   = $MonsterHPBar
@onready var ply_hp     : ProgressBar   = $PlayerHPBar
@onready var name_label : Label         = $MonsterName
@onready var attack_btn : Button        = $ButtonPanel/AttackBtn
@onready var flee_btn   : Button        = $ButtonPanel/FleeBtn
@onready var ui_nodes   := [mon_sprite, mon_hp, ply_hp, name_label, $ButtonPanel]

# ───────── Life Cycle ─────────
func _ready() -> void:
    for n in ui_nodes: if n: n.visible = false
    encounter.finished.connect(_on_encounter_done)

    attack_btn.pressed.connect(_on_attack_pressed)
    flee_btn.pressed.connect(_on_flee_pressed)

# ─ Encounter 끝 → 전투 UI 켜기 ─
func _on_encounter_done() -> void:
    encounter.hide()

    var m = GameState.monster
    mon_sprite.texture = m.sprite
    mon_sprite.scale   = Vector2.ONE         # 크기 고정
    mon_hp.max_value   = m.maxhp
    mon_hp.value       = m.hp

    ply_hp.max_value   = GameState.player_maxhp
    ply_hp.value       = GameState.player_hp
    
    if GameState.floor % 10 == 0:
        name_label.text    = "%s" % m.name
    else:
        name_label.text    = "Lv.%d  %s" % [m.level, m.name]

    for n in ui_nodes: if n: n.visible = true

# ───────── 버튼 콜백 ─────────
func _on_attack_pressed() -> void:
    _lock_buttons()

    var m = GameState.monster
    
    if randf() < 0.30:
        m.hp -= GameState.player_atk * 2
        _show_toast("치명타!")
        await get_tree().create_timer(0.5).timeout
    else:
        m.hp -= GameState.player_atk
    mon_hp.value = clamp(m.hp, 0, m.maxhp)

    if m.hp <= 0:
        _end_battle(true)
        return

    _monster_counter()          # 바로 몬스터 턴

func _on_flee_pressed() -> void:
    _lock_buttons()
    if GameState.floor % 10 == 0:
        _show_toast("보스에겐 도망칠 수 없습니다!")
        _unlock_buttons()
    elif randf() < 0.30:
        _end_battle(false, true)
    else:
        _show_toast("도망에 실패했습니다!")
        _monster_counter()

# ───────── 몬스터 턴 ─────────
func _monster_counter() -> void:
    var m = GameState.monster
    GameState.player_hp -= m.atk
    ply_hp.value = clamp(GameState.player_hp, 0, GameState.player_maxhp)

    if GameState.player_hp <= 0:
        _end_battle(false)
        return

    _unlock_buttons()

# ───────── 배틀 종료 ─────────
func _end_battle(player_win:bool, fled:bool=false) -> void:
    if player_win:
        _show_toast("승리했습니다!")
        await get_tree().create_timer(1.0).timeout
        
        if GameState.floor == 30:
            get_tree().change_scene_to_file("res://시작화면/GameClear.tscn")
            return
        
        GameState.gain_exp(GameState.monster.exp)
        GameState.monster_kills += 1
        var drops = GameState.drop_loot()
        for item in drops:
            _show_toast("%s을(를) 획득했습니다!" % item)
            await get_tree().create_timer(1.0).timeout

        GameState.advance_room()
    elif fled:
        _show_toast("무사히 도망쳤습니다!")
        GameState.advance_room()
    else:
        get_tree().change_scene_to_file("res://시작화면/GameOver.tscn")
        return

    await get_tree().create_timer(1.0).timeout
    get_tree().change_scene_to_file("res://시작화면/DungeonMenu.tscn")

# ───────── Helper ─────────
func _lock_buttons() -> void:
    attack_btn.disabled = true
    flee_btn.disabled   = true

func _unlock_buttons() -> void:
    attack_btn.disabled = false
    flee_btn.disabled   = false

func _show_toast(msg:String) -> void:
    var lbl := $ToastLabel
    lbl.text = msg
    lbl.visible = true
