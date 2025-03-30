extends SpringArm3D

@export var target: Node3D
@export var decay: float = 10.0

func _process(delta: float) -> void:
    global_transform = global_transform.interpolate_with(
        target.global_transform,
        1.0 - exp(-decay * delta)
    )