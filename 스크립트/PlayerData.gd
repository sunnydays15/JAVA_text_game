extends Resource
class_name PlayerData

var name: String = ""
var level: int = 1
var experience: int = 0
var max_experience: int = 100
var hp: int = 100
var max_hp: int = 100
var weapon: String = "초보자의 검"
var armor: String = "초보자의 방패"
var monster_kills: int = 0

func gain_experience(amount: int):
    experience += amount
    while experience >= max_experience:
        experience -= max_experience
        level += 1
        hp = max_hp
