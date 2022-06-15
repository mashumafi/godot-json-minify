extends SceneTree

const PackedJSON = preload('res://addons/json-minify/packed-json.gd')

func load_test_packed_json():
	return load('test.json')

func test_load_instance():
	var packed_json = load_test_packed_json()
	var result = packed_json.instance()
	assert(null != result)
	assert(result['glossary']["GlossDiv"]["title"] == "DEADBEEF")

func test_load():
	test_load_instance()

func run_tests():
	test_load()

func _init():
	run_tests()
	OS.exit_code = 0
	quit()
