
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
var expAmount = 100
var learned_abilities = {}#,"fireball": true ,"circleball": true ,} 
var global_maxRooms = 0
var life_player = 20
var count_stage = 0
#WeakEnemy
var enemyCount_small_min = 2
var enemyCount_small_max = 4
#MediumEnemy
var enemyCount_medium_min = 1
var enemyCount_medium_max = 2
#HighEnemy
var enemyCount_High_min = 0
var enemyCount_High_max = 0
#OlD Values
var autoShootAttribute := {}
var fireballShootAttribute := {}
var circleShootAttribute := {}
var darkShootAttribute := {}
var bumerangShootAttribute := {}
var countAttrOnAuto = 0
var countAttrOnCircle = 0
var countAttrOnFire = 0
var countAttrOnDark = 0
var countAttrOnBumerang = 0
