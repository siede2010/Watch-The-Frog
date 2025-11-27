extends TileMapLayer

var solidMap : Array[Vector2i]

func mapSolid(a):
	return get_cell_tile_data(a) != null

func _ready():
	solidMap = get_used_cells().filter(mapSolid);
	for i in solidMap:
		print(i)
		print(get_cell_tile_data(i))
