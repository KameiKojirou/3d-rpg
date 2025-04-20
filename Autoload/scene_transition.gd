extends CanvasLayer

@onready var fader: ColorRect = $Fader

func fade_in() -> void:
	var tween = create_tween()
	tween.tween_interval(0.1)
	tween.tween_property(fader, "color:a", 0.0, 1.0).from(1.0)

func change_scene(next_level: String, player: Player) -> void:
	var tween = create_tween()
	tween.tween_property(fader, "color:a", 1.0, 1.0)
	tween.tween_interval(0.1)
	tween.tween_callback(
		func():
			PersistentData.cache_gear(player)
			PersistentData.cache_player_data(player)
			get_tree().change_scene_to_file(next_level)
	)
