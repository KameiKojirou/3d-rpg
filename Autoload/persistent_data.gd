extends Control

var gold := 0
var current_health := 0

@onready var inventory_node: Control = $InventoryNode
@onready var weapon_node: Control = $WeaponNode
@onready var shield_node: Control = $ShieldNode
@onready var armor_node: Control = $ArmorNode

func cache_gear(player: Player) -> void:
	for item in player.user_interface.inventory.item_grid.get_children():
		cache_item(item, inventory_node)
	cache_item(
		player.user_interface.inventory.get_weapon(),
		weapon_node
	)
	cache_item(
		player.user_interface.inventory.get_shield(),
		shield_node
	)
	cache_item(
		player.user_interface.inventory.get_armor(),
		armor_node
	)
	gold = player.user_interface.inventory.gold
	
func cache_player_data(player: Player) -> void:
	current_health = player.health_component.current_health
		
func get_inventory() -> Array:
	return inventory_node.get_children()
	
func get_equipped_items() -> Array:
	var equipped_items := []
	if weapon_node.get_child_count() > 0:
		equipped_items.append(weapon_node.get_child(0))
	if shield_node.get_child_count() > 0:
		equipped_items.append(shield_node.get_child(0))
	if armor_node.get_child_count() > 0:
		equipped_items.append(armor_node.get_child(0))
	return equipped_items

func cache_item(item: ItemIcon, storage_node: Control) -> void:
	item.get_parent().remove_child(item)
	storage_node.add_child(item)
