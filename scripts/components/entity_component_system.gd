extends Area2D
class_name EntityComponentSystem

enum entity_types{
	CHARACTER = 2,
	ENEMY = 0,
	PROJECTILE = 1,
}

@export_category("Type")
@export var entity_type : entity_types = entity_types.ENEMY

@export_category("Properties")
@export_group("Character-Enemy")
@export var hit_points : int = 1

@export_group("Enemy-Projectile")
@export var contact_damage : bool = true
@export var entity_piercing : bool = false
@export var character_attack : bool = false

@export_group("Targets")

func _ready() -> void:
	pass

func _on_area_entered(area : Area2D):
	if ( area is EntityComponentSystem ) and (entity_type == entity_types.PROJECTILE or entity_type == entity_types.ENEMY) and (contact_damage == true):
		if area.entity_type == EntityComponentSystem.entity_types.CHARACTER:
			area.get_parent().get_parent().injured.emit()
			print("char_died. RIP. Press F")
	if (area is EntityComponentSystem) and (entity_type == entity_types.PROJECTILE ) and (character_attack == true):
		if area.entity_type == EntityComponentSystem.entity_types.ENEMY:
			area.get_parent().death.emit()
			print("enemy died. RIP")
	
func _on_body_entered(body):
	pass
