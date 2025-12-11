extends Node

# global references
var player_scene : PackedScene = load("res://scenes/object_scenes/player.tscn")

var spawnPoints : Array[Node2D] = []
signal spawnPointAdded
signal levelDataUpdate
# data storage

var level_list : Array[PackedScene] = [
	load("res://scenes/playfield.tscn")
]

var persistentData : Dictionary = {
	current_level = 0,
	
	player_count = 2,
	
	player_0_type = 1,
	player_1_type = 1,
	
	player_0_up = "Up_0",
	player_0_left = "Left_0",
	player_0_down = "Down_0",
	player_0_right = "Right_0",
	player_0_action = "Action_0",
	
	player_1_up = "Up_1",
	player_1_left = "Left_1",
	player_1_down = "Down_1",
	player_1_right = "Right_1",
	player_1_action = "Action_1",
}

var levelData : Dictionary = {
	
}

func set_var(n : String,value):
	persistentData[n] = value
	pass

func get_var(n : String):
	if persistentData.has(n):
		return persistentData[n]
	return null
	
func set_var_level(n : String,value):
	levelData[n] = value
	levelDataUpdate.emit(n,value)

func get_var_level(n : String):
	if levelData.has(n):
		return levelData[n]
	return null
	
func add_var_level(n : String, val : int):
	var cur = get_var_level(n)
	if cur:
		set_var_level(n,cur + val)
		levelDataUpdate.emit(n,cur + val)
		return
	set_var_level(n,val)
	levelDataUpdate.emit(n,val)

# player initialization

func add_spawn_point(node : Node2D):
	print("added", node)
	spawnPoints.append(node)
	spawnPointAdded.emit()

func rem_spawn_point(node : Node2D):
	print("removed",node)
	spawnPoints.erase(node)
	

func load_level(scene : PackedScene):
	levelData.clear()
	get_tree().change_scene_to_packed(scene)
	await get_tree().scene_changed
	add_players()
	pass

func add_players():
	var x = 0
	var y = 0
	var parent = get_tree().current_scene
	for i in get_player_count():
		var spawn_node : Node2D = await get_spawn_point()
		if spawn_node != null:
			x = spawn_node.position.x
			y = spawn_node.position.y
			parent = spawn_node.get_parent()
		
			spawn_node.queue_free()
		
		var player = player_scene.instantiate()
		player.position = Vector2(x,y)
		player.playerID = i
		player.emit_signal("set_type",get_player_type(i))
		
		var inputs = getKeyBinds(i)
		
		player.UpInput = InputEventAction.new()
		player.UpInput.action = inputs[0]
		player.LeftInput = InputEventAction.new()
		player.LeftInput.action = inputs[1]
		player.DownInput = InputEventAction.new()
		player.DownInput.action = inputs[2]
		player.RightInput = InputEventAction.new()
		player.RightInput.action = inputs[3]
		
		player.ActionInput = InputEventAction.new()
		player.ActionInput.action = inputs[4]
		
		print(player.position)
		parent.add_child(player)
		pass

func get_spawn_point():
	if spawnPoints.is_empty():
		await spawnPointAdded
	return spawnPoints.pick_random()

func get_player_count():
	return get_var("player_count")

func getKeyBinds(id : int):
	return [get_var("player_{0}_up".format([id])),
		get_var("player_{0}_left".format([id])),
		get_var("player_{0}_down".format([id])),
		get_var("player_{0}_right".format([id])),
		get_var("player_{0}_action".format([id]))]

func get_player_type(id : int):
	return get_var("player_{0}_type".format([id]))
	
