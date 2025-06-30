# GameState.gd  (Project → Project Settings → Autoload 로 등록!)
extends Node

enum { ST_DUNGEON_MENU, ST_BATTLE }

var state        : int    = ST_DUNGEON_MENU
var player_name  : String = ""
var weapon       : String = "초보자의 검"
var armor        : String = "초보자의 방패"
var monster_kills: int    = 0
var floor        : int    = 1
var room         : int    = 1             # 1~5
var player_hp    : int    = 100
var player_maxhp : int    = 100
var player_atk   : int    = 15
var player_lv    : int    = 1
var player_exp   : int    = 0
var next_exp     : int    = 100
var monster      : Dictionary = {}        # {name, hp, maxhp, atk, sprite}

# 인벤토리
var heart_potions   : int = 0
var exp_potions     : int = 0
var special_potions : int = 0

func add_item(item_name: String, amount: int = 1) -> void:
    match item_name:
        "heart_potion":
            heart_potions += amount
        "exp_potion":
            exp_potions += amount
        "special_potion":
            special_potions += amount
            
func drop_loot() -> Array:
    var dropped_items := []

    if randi_range(0, 100) < 30:
        add_item("heart_potion")
        dropped_items.append("하트물약")

    if randi_range(0, 100) < 20:
        add_item("exp_potion")
        dropped_items.append("경험치물약")

    if randi_range(0, 100) < 5:
        add_item("special_potion")
        dropped_items.append("스페셜물약")
        
    return dropped_items


func gain_exp(amount:int) -> void:
    player_exp += amount
    while player_exp >= next_exp:
        player_exp -= next_exp
        player_lv  += 1
        player_maxhp += 10
        player_hp     = player_maxhp
        player_atk   += 3
        next_exp     = int(next_exp * 1.1)

# -------- 층/방 이동 ----------
func advance_room():
    if floor % 10 == 0:
        floor += 1
        room  = 1
        return

    if room == 5:
        room = 1
        floor += 1
    else:
        room += 1
        
# 몬스터 기본 스펙 (레벨1 기준)
var MONSTERS := {
    "슬라임": { base_hp = 20,  base_atk = 3, base_exp = 10, sprite = preload("res://에셋/적/슬라임.png") },
    "고블린": { base_hp = 35,  base_atk = 5, base_exp = 15, sprite = preload("res://에셋/적/고블린.png") },
    "오크"  : { base_hp = 50,  base_atk = 8, base_exp = 25, sprite = preload("res://에셋/적/오크.png") },
    "해골"  : { base_hp = 40,  base_atk = 6, base_exp = 20, sprite = preload("res://에셋/적/해골.png") },
    "좀비"  : { base_hp = 45,  base_atk = 7, base_exp = 22, sprite = preload("res://에셋/적/좀비.png") },
    "슬라임킹": { base_hp = 80, base_atk = 12, base_exp = 50, sprite = preload("res://에셋/적/슬라임킹.PNG") },
    "오크킹": { base_hp = 150, base_atk = 20, base_exp = 100, sprite = preload("res://에셋/적/오크킹.PNG") },
    "골드드래곤": { base_hp = 250, base_atk = 30, base_exp = 200, sprite = preload("res://에셋/적/골드드래곤.PNG") },
}

# 층에 맞는 몬스터 풀 반환
func _pool_for_floor(f:int) -> Array:
    if f == 10:  return ["슬라임킹"]
    if f == 20:  return ["오크킹"]
    if f == 30:  return ["골드드래곤"]
    if f >= 21:  return ["오크", "해골", "좀비"]
    if f >= 11:  return ["고블린", "오크"]
    return ["슬라임", "고블린"]

func create_monster() -> void:
    var pool = _pool_for_floor(floor)
    var name = pool.pick_random()
    var lv   = clamp(floor + randi_range(-1,1), 1, 30)
    var spec = MONSTERS[name]
    
    monster = {
        name   = name,
        level  = lv,
        maxhp  = spec.base_hp  + (lv-1)*5,
        hp     = spec.base_hp  + (lv-1)*5,
        atk    = spec.base_atk + (lv-1)*2,
        exp    = spec.base_exp + (lv-1)*3,
        sprite = spec.sprite
    }

func reset() -> void:
    state        = ST_DUNGEON_MENU
    player_name  = ""
    weapon       = "초보자의 검"
    armor        = "초보자의 방패"
    monster_kills= 0
    floor        = 1
    room         = 1             # 1~5
    player_hp    = 100
    player_maxhp = 100
    player_atk   = 15
    player_lv    = 1
    player_exp   = 0
    next_exp     = 100
    monster      = {}        # {name, hp, maxhp, atk, sprite}
