tool
extends EditorPlugin

var json_editor_import_plugin

func _enter_tree():
	add_custom_type("PackedJSON", "PackedDataContainer", preload("packed-json.gd"), preload("icon.png"))
	json_editor_import_plugin = preload("json-editor-import-plugin.gd").new()
	add_import_plugin(json_editor_import_plugin)

func _exit_tree():
	remove_import_plugin(json_editor_import_plugin)
	json_editor_import_plugin = null
	remove_custom_type("PackedJSON")
