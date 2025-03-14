extends "res://Tanks/Tank.gd"

onready var parent = get_parent()

export (float) var turret_speed
export (int) var detect_radius

var target: Node = null

func _ready():
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius
	$DetectRadius.monitoring = true  # Ensure Area2D is active

func control(delta: float) -> void:
	if parent is PathFollow2D:
		parent.set_offset(parent.get_offset() + speed * delta)
		position = Vector2()
	else:
		# other movement code
		pass

func _process(delta: float) -> void:
	if target:
		# Get direction to the target
		var target_dir = (target.global_position - global_position).normalized()
		# Get current direction of the turret
		var current_dir = Vector2(1, 0).rotated($Turret.global_rotation)
		# Interpolate between the current direction and target direction
		$Turret.global_rotation = current_dir.linear_interpolate(target_dir, turret_speed * delta).angle()

func _on_DetectRadius_body_entered(body: Node) -> void:
		target = body

func _on_DetectRadius_body_exited(body: Node) -> void:
	if body == target:
		target = null
