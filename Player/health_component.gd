extends Node
class_name HealthComponent

signal defeat()
signal health_changed()

@export var body: PhysicsBody3D

var armor_value := 0.0

var max_health: float
var current_health: float:
	set(value):
		current_health = max(value, 0.0)
		if current_health == 0.0:
			defeat.emit()
		health_changed.emit()
		
func update_max_health(max_hp_in: float) -> void:
	max_health = max_hp_in
	current_health = max_health
	
func take_damage(damage_in: float, is_critical: bool) -> void:
	var damage = damage_in
	var damage_blocked = damage * armor_value
	damage = damage - damage_blocked
	if is_critical:
		damage *= 2.0
		VfxManager.spawn_damage_number(damage, Color.RED, body.global_position)
	else:
		VfxManager.spawn_damage_number(damage, Color.WHITE, body.global_position)
	current_health -= damage
	
func get_health_string() -> String:
	return "%s/%s" % [current_health, max_health]
	
func update_armor_value(armor_in: float) -> void:
	armor_value = armor_in / 100.0
