extends Node3D

signal spawn_enemy_defeated(heatvalue)
signal check_music(current_wave)

const HANDATTACK = preload("res://Scenes/handattack.tscn")
const LAVASLUG = preload("res://Scenes/lavaslug.tscn")
const LAVA_BAT = preload("res://Scenes/lava_bat.tscn")
const LAVA_HAND = preload("res://Scenes/lava_hand.tscn")

@onready var spawn_timer = $SpawnTimer
@onready var positions = $Positions
@onready var wave_timer = $WaveTimer
@onready var rest_timer = $RestTimer
@onready var check_timer = $CheckTimer
@onready var snail_death = $SoundEffects/SnailDeath
@onready var bat_death = $SoundEffects/BatDeath
@onready var hand_death = $SoundEffects/HandDeath
@onready var enemy_projectiles = $EnemyProjectiles


@export var spawnerOn: bool = true
@export var waveNumber: int = 1
@export var waveTime: int = 30
@export var restTime: int = 10

var spawnableEnemies: Array = [LAVASLUG,LAVASLUG,LAVASLUG,LAVASLUG,LAVASLUG,LAVA_BAT,LAVA_BAT,LAVA_BAT,LAVA_HAND]

var currentEnemies: Array
var currentSpawn: Array

var spawnPositions: Array
var enemy: Enemy
var skipSpawn: bool = false
var resting: bool = false
var checking: bool = false

var enemyRandomnessLevel
var spawnRandomnessLevel: float = 6
var spawnTimeMin: float = 7
var spawnTimeMax: float = 7
var spawnTimeDifficultyMod: float = 1

func _ready():
	spawnPositions = positions.get_children()
	if OS.has_feature("web"):
		waveNumber = 1
	Globals.current_wave = waveNumber
	check_music.emit(waveNumber)
	startWave()

func spawn_enemies():
	if !resting and spawnerOn:
		for points in spawnPositions:
			randomizePositions()
			if skipSpawn:
				skipSpawn = false
			elif checkForHand(points):
				pass
			else:
				points.add_child(enemy)
				currentEnemies.append(enemy)
				currentSpawn.append(enemy)
	

func randomizePositions():

	if waveNumber >= 5:
		enemyRandomnessLevel = randi_range(0,8)
		var randomSpawns = randf_range(1,10)
		if randomSpawns >= spawnRandomnessLevel:
			enemy = spawnableEnemies[enemyRandomnessLevel].instantiate()
			enemy.enemy_defeated.connect(enemy_defeated)
			if enemyRandomnessLevel == 8:
				enemy.hand_attack.connect(hand_attack)
		else:
			skipSpawn = true
			
	elif waveNumber >= 3:
		enemyRandomnessLevel = randi_range(0,7)
		var randomSpawns = randf_range(1,10)
		if randomSpawns >= spawnRandomnessLevel:
			enemy = spawnableEnemies[enemyRandomnessLevel].instantiate()
			enemy.enemy_defeated.connect(enemy_defeated)
			if enemyRandomnessLevel == 8:
				enemy.hand_attack.connect(hand_attack)
		else:
			skipSpawn = true
				
	elif waveNumber >= 1:
		enemyRandomnessLevel = 0
		var randomSpawns = randf_range(1,10)
		if randomSpawns >= spawnRandomnessLevel:
			enemy = spawnableEnemies[enemyRandomnessLevel].instantiate()
			enemy.enemy_defeated.connect(enemy_defeated)
			if enemyRandomnessLevel == 6:
				enemy.hand_attack.connect(hand_attack)
		else:
			skipSpawn = true
	
func enemy_defeated(node,type,heatvalue):
	if type == "LavaSlug":
		snail_death.play()
	elif type == "LavaBat":
		bat_death.play()
	elif type == "LavaHand":
		hand_death.play()
	spawn_enemy_defeated.emit(heatvalue)
	currentEnemies.erase(node)

func startWave():
	check_music.emit(waveNumber)
	print("Spawn Interval: ",spawnTimeMin)
	wave_timer.start(waveTime)
	spawn_timer.start(randf_range((spawnTimeMin*spawnTimeDifficultyMod),(spawnTimeMax*spawnTimeDifficultyMod)))
	spawn_enemies()
	checkEmptySpawn()

func _on_wave_timer_timeout():
	if currentEnemies.is_empty():
		rest_timer.start(restTime)
		resting = true
	if spawnTimeDifficultyMod >= .035:
		spawnTimeDifficultyMod -= .035
	spawnTimeMin = 7 * spawnTimeDifficultyMod
	spawnTimeMax = 7 * spawnTimeDifficultyMod
	spawnTimeMin = clamp(spawnTimeMin, 1, 7)
	spawnTimeMax = clamp(spawnTimeMax, 1, 7)
	spawn_timer.stop()	
	wave_timer.stop()
	checking = true
	check_timer.start(1)
	
func _on_spawn_timer_timeout():
	currentSpawn.clear()
	spawn_enemies()
	checkEmptySpawn()

func _on_rest_timer_timeout():
	waveNumber += 1
	Globals.current_wave = waveNumber
	currentSpawn.clear()
	resting = false
	rest_timer.stop()
	startWave()

func reset_spawner():
	remove_enemies()
	clear_projectiles()
	currentEnemies.clear()
	currentSpawn.clear()
	checking = false
	resting = false
	waveNumber = 1
	enemyRandomnessLevel = 0
	spawnRandomnessLevel = 5
	spawnTimeMin = 7
	spawnTimeMax = 7
	spawnTimeDifficultyMod = 1
	startWave()
	
func remove_enemies():
	for spawn in currentEnemies:
		if spawn != null:
			spawn.queue_free()

func hand_attack(location):
	var attack = HANDATTACK.instantiate()
	enemy_projectiles.add_child(attack)
	attack.global_position = location
	attack.initialize()

func checkForHand(point):
	for spawn in point.get_children():
		if spawn is LavaHand:
			return true

func checkEmptySpawn():
	while currentSpawn.is_empty():
		spawn_enemies()

func _on_check_timer_timeout():
	if currentEnemies.is_empty():
		check_timer.stop()
		checking = false
		rest_timer.start(restTime)
		resting = true
	else:
		check_timer.start(1)


		
func clear_projectiles():
	var currentProjectiles = enemy_projectiles.get_children()
	print(currentProjectiles)
	for projectile in currentProjectiles:
		projectile.queue_free()
