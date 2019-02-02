extends SceneTree

const JSONEditorImportPlugin = preload('res://addons/json-minify/json-editor-import-plugin.gd')

func test_json_editor_import_plugin_new():
	JSONEditorImportPlugin.new()

func test_json_editor_import_plugin():
	test_json_editor_import_plugin_new()

const PackedJSON = preload('res://addons/json-minify/packed-json.gd')

func test_packed_json_new():
	PackedJSON.new()

func test_packed_json():
	test_packed_json_new()

func load_test_packed_json():
	return load('test.json')

func test_load_instance():
	var packed_json = load_test_packed_json()
	var result = packed_json.instance()
	assert(null != result)
	assert(result['glossary'])

func test_load():
	test_load_instance()

func run_tests():
	test_json_editor_import_plugin()
	test_packed_json()
	test_load()

func _init():
	run_tests()
	OS.exit_code = 0
	quit()
