extends Area2D
class_name EntityComponentSystem

enum entity_types{
	CHARACTER = 2,
	ENEMY = 0,
	PROJECTILE = 1,
}

@export_category("Type")
@export var entity_type : entity_types = entity_types.ENEMY

@export_category("Owner")
@export var components_owner : CharacterBody2D

@export_category("Properties")
@export_group("Character-Enemy")
@export var hit_points : int = 1

@export_group("Enemy-Projectile")
@export var contact_damage : bool = true
@export var entity_piercing : bool = false

func _ready() -> void:
	if entity_type == entity_types.PROJECTILE:
		$LifeTimer.autostart = true

func _on_area_entered(area : Area2D):
	if entity_type == entity_types.CHARACTER or entity_type == entity_types.ENEMY:
		if area is EntityComponentSystem:
			if area.entity_type == entity_types.PROJECTILE or area.entity_type == entity_types.ENEMY:
				if area.contact_damage == true:
					hit_points -= 1
				if !entity_piercing:
					components_owner.queue_free()

func _on_life_timer_timeout():
	queue_free()
