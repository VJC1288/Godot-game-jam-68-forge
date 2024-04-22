extends Node

const MAIN = preload("res://Scenes/main.tscn")

var currentPlayer: Player
var currentWeapon
var menusOpen: bool
var hud
var current_heat: int = 0
var current_wave: int
var input_mode: String ## Can be "Controller" or "Mouse"
var thorns_upgrades: int = 0


func reset_globals():
	currentPlayer.queue_free()
	currentWeapon.queue_free()
	current_heat = 0
	current_wave = 1
	thorns_upgrades = 0

func upgradeThorns():
	thorns_upgrades += 1
	currentPlayer.hitbox_component.has_thorns = true
	currentPlayer.hitbox_component.thorns_available = true
	currentPlayer.hitbox_component.thorns_cooldown -= 1
	hud.thorns_armor_icon.visible = true
	hud.thorns_upgrades.text = str("x",Globals.thorns_upgrades)
