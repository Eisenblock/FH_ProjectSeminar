
# Global.gd
extends Node

# Array als globale Variable
var enemyList = []
var enemyList_lost = []
var ChestAttribute := {}
var AllAttrItems := {}
var enemySpawnCount = 2
var enemySpawnCount_MEdium = 0
var enemySpawnCount_high = 0
var countAttrOnChest = 0
var expAmount = 60
var learned_abilities = {}#,"fireball": true ,"circleball": true ,} 
var global_maxRooms = 1
var life_player = 20
var count_stage = 0
var enemy_kills = 0
#WeakEnemy
var enemyCount_small_min = 2
var enemyCount_small_max = 3
#MediumEnemy
var enemyCount_medium_min = 0
var enemyCount_medium_max = 2
#HighEnemy
var enemyCount_High_min = 0
var enemyCount_High_max = 0
#OlD Values
var autoShootAttribute := { }
var fireballShootAttribute := {}
var circleShootAttribute := {}
var darkShootAttribute := {}
var bumerangShootAttribute := {}
var countAttrOnAuto = 0
var countAttrOnCircle = 0
var countAttrOnFire = 0
var countAttrOnDark = 0
var countAttrOnBumerang = 0
var availableAttributes = {
	
	"tier1": {
		"base_dmg": 10,    
		"pierce_count"  : 1,  
		"count": 1,   
		"cooldown": 0.5,     
		"lifetime": 0.5,  
		"crit_chance" : 15,
		"crit_dmg": 20
			},
	"tier2": {
		"base_dmg": 20,    
		"pierce_count"  : 2,  
		"count": 2,   
		"cooldown": 1.0,   
		"lifetime": 0.7,   
		"crit_chance" : 30,
		"crit_dmg": 50         
			},
	"tier3": {
		"base_dmg": 30,    
		"pierce_count"  : 3,  
		"count": 3,   
		"cooldown": 1.5,     
		"lifetime": 0.9,   
		"crit_chance" : 50,
		"crit_dmg": 80         
			}
	}

func ResetValues() :
	autoShootAttribute.clear()
	fireballShootAttribute.clear()
	circleShootAttribute.clear()
	darkShootAttribute.clear()
	life_player = 20
	expAmount = 60
	count_stage = 0
