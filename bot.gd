extends Controller
class_name Bot

const LOOK_SPEED : float = 10.0

# Logic
var target : BaseBody
var strafe_timer : float = 0.0
var strafe_dirs : Array = [-1.0, 0.0, 1.0]
var strafe_dir : float = 0.0

func _ready():
	var gobots = get_tree().get_nodes_in_group("gobots")
	set_target(gobots[randi() % gobots.size()])
	# Weapon testing
	body.weapon = $holder/weapons/weapon
	body.weapon.shooter = body

func _physics_process(delta):
	if !body.dead:
		process_logic(delta)
		body.process_steps(delta)
		body.process_body(delta)
		body.is_on_floor = body.is_on_floor()
		body.process_anims(delta)

func process_logic(delta):
	var target_origin = target.head.global_transform.origin
	# Visibility
	var target_visible = false
	var ray_state = body.get_world().direct_space_state
	var ray_result = ray_state.intersect_ray(body.head.global_transform.origin, target_origin, [self], 10)
	if ray_result:
		target_visible = ray_result.collider == target and !target.dead
	look_at_target(target_origin, delta)
	if target_origin.distance_squared_to(body.global_transform.origin) > 16.0:
		body.dir -= body.global_transform.basis.z
	body.action_primary = randf() <= 0.05 and target_visible
	body.action_jump = randf() <= 0.01
	random_strafe(delta)

func random_strafe(delta):
	if strafe_timer > 0.0:
		strafe_timer -= delta
	else:
		strafe_timer = rand_range(0.25, 1.0)
		strafe_dir = strafe_dirs[randi() % strafe_dirs.size()]
	body.dir += body.global_transform.basis.x * strafe_dir

func look_at_target(target_origin, delta):
	if target_origin != body.head.global_transform.origin:
		var look_target = body.head.global_transform.looking_at(target_origin, Vector3.UP)
		body.head.global_transform = body.head.global_transform.interpolate_with(look_target, delta * LOOK_SPEED)
		body.rotation.y = lerp_angle(body.rotation.y, look_target.basis.get_euler().y, delta * LOOK_SPEED)

func set_target(new_target : BaseBody):
	target = new_target
