extends Control

@onready var level_label: Label = %LevelLabel
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var xp_bar: TextureProgressBar = %XPBar
@onready var health_label: Label = %HealthLabel
@onready var inventory: Control = $Inventory
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_text: Label = %InteractText
@onready var loot_container_display: CenterContainer = $LootContainerDisplay



@export var player: Player

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_menu"):
		if inventory.visible:
			close_menu()
		else:
			open_menu()

func update_stats_display() -> void:
	level_label.text = str(player.stats.level)
	xp_bar.max_value = player.stats.percentage_level_up_boundary()
	xp_bar.value = player.stats.xp
	inventory.update_stats()

func update_health() -> void:
	health_bar.max_value = player.health_component.max_health
	health_bar.value = player.health_component.current_health
	health_label.text = player.health_component.get_health_string()
	
func open_menu() -> void:
	inventory.visible = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	inventory.update_gear_stats()
	
func close_menu() -> void:
	inventory.visible = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func update_interact_text(text: String) -> void:
	animation_player.stop()
	animation_player.play("FadeOutText")
	interact_text.text = text
	
func open_loot_container(loot: LootContainer) -> void:
	loot_container_display.open(loot)
