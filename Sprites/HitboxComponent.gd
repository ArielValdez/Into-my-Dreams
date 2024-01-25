extends Area2D

class_name HitboxComponent

@export var health_component : HealthComponent

func damage(attack : Attack):
	if health_component:
		health_component.damage(attack)
	else:
		print_debug("No health_component added, check if necessary for this Node")
	pass
	
func contactDamage(damage : int):
	if health_component:
		health_component.contactDamage(damage)
	else:
		print_debug("No health_component added, check if necessary for this Node")
	pass
