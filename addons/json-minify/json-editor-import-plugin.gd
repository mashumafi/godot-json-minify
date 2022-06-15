tool
extends EditorImportPlugin

const PackedJSON = preload('packed-json.gd')

enum Presets { BINARY, MINIFY }

func get_importer_name():
	return "json-minify"

func get_visible_name():
	return "JSON Minify"

func get_recognized_extensions() -> Array:
	return ["json"]

func get_save_extension():
	return "res"

func get_resource_type():
	return "PackedDataContainer"

func get_preset_count():
	return Presets.size()

func get_option_visibility(option: String, options: Dictionary):
	return true

func get_preset_name(preset: int):
	match preset:
		Presets.BINARY:
			return "Binary"
		Presets.MINIFY:
			return "Minify"
		_:
			return "Unknown"

func get_import_options(preset: int) -> Array:
	return [
		{
			'name': 'binary',
			'default_value': Presets.BINARY == preset
		},
		{
			'name': 'compression',
			'default_value': PackedJSON.Compression.BEST,
			'property_hint': PROPERTY_HINT_ENUM,
			'hint_string': PoolStringArray(PackedJSON.Compression.keys()).join(","),
			'usage': PROPERTY_USAGE_EDITOR
		}
	]

func import(source_file: String, save_path: String, options: Dictionary, r_platform_variants, r_gen_files):
	var packed_json := PackedJSON.new()
	packed_json.binary = options['binary']
	packed_json.compression = options['compression']
	var result = packed_json.set_data(source_file)
	if result != OK:
		return FAILED
	return ResourceSaver.save("%s.%s" % [save_path, get_save_extension()], packed_json)
