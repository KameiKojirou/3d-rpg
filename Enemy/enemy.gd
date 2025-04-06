extends CharacterBody3D

@export var max_health: float = 20.0
@onready var rig: Node3D = $Rig
@onready var health_component: HealthComponent = $HealthComponent

func _ready() -> void:
    rig.set_active_mesh(
        rig.villager_meshes.pick_random()
    )
    health_component.update_max_health(max_health)