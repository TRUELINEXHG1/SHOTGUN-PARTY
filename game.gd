extends Node

var player : Player

onready var main = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
onready var menu = main.get_node("menu")

# Maps
onready var map_scns = [preload("res://scenes/maps/map.tscn")]
# Controllers
onready var controllers = [
	preload("res://scenes/controllers/player.tscn"),
	preload("res://scenes/controllers/peer.tscn"),
	preload("res://scenes/controllers/bot.tscn")
]
var colors = ["#28304e", "#125624"]

func _ready():
	randomize()

func spawn_sound(stream : AudioStream, origin : Vector3, unit_db : float, lifetime : float):
	var sound = Sound.new()
	sound.lifetime = lifetime
	sound.unit_size = 1.0
	sound.bus = "Sounds"
	sound.doppler_tracking = AudioStreamPlayer3D.DOPPLER_TRACKING_PHYSICS_STEP
	sound.stream = stream
	sound.pitch_scale = rand_range(0.8, 1.2)
	sound.unit_db = unit_db
	main.main_pass.add_child(sound)
	sound.global_transform.origin = origin
	sound.play()

#func create_impact(index : int, parent : Node, pos : Vector3, norm : Vector3):
#	var impact = impact_scenes[index].instance()
#	parent.add_child(impact)
#	impact.global_transform.origin = pos + norm * 0.005
#	impact.look_at(pos + norm, Vector3(1.0, 1.0, 0.0))
#	impact.rotation = Vector3(impact.rotation.x, impact.rotation.y, rand_range(-1, 1))
#	var rand_scale = rand_range(1.0, 1.5)
#	impact.scale = Vector3(rand_scale, rand_scale, rand_scale)

func spawn_map(map_id : int):
	var map = map_scns[map_id].instance()
	main.main_pass.add_child(map)

func spawn_gobot(node_name : String, controller_type : int):
	var gobot = controllers[controller_type].instance()
	gobot.name = node_name
	main.main_pass.add_child(gobot)
	gobot.body.global_transform = get_spawn()

func remove_gobot(id : int):
	main.main_pass.get_node(str(id)).free()

func get_spawn():
	var spawns = main.main_pass.get_node_or_null("map/spawns")
	if spawns:
		return spawns.get_child(randi() % spawns.get_child_count()).global_transform
	else:
		return Transform(Basis.IDENTITY, Vector3(0.0, 10.0 + randf(), 0.0))
