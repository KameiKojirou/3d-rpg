extends StaticBody3D
class_name Passage

@export_file("*.tscn") var next_level

func travel(player: Player) -> void:
	SceneTransition.change_scene(next_level, player)
