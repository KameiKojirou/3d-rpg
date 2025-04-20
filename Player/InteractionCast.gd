extends ShapeCast3D

@export var player: Player
@export var ui: Control

func check_interactions() -> void:
	for collision in get_collision_count():
		var collider = get_collider(collision)
		if collider is LootContainer:
			ui.update_interact_text("Open Chest")
			if Input.is_action_just_pressed("interact"):
				ui.open_loot_container(collider)
				
		if collider is Passage:
			ui.update_interact_text("Travel")
			if Input.is_action_just_pressed("interact"):
				collider.travel(player)
