extends PackedDataContainer

func set_data(filename):
	var input = File.new()
	var err = input.open(filename, File.READ)
	if err != OK:
		return err

	var json = input.get_as_text()

	input.close()

	var parsed_json = JSON.parse(json)
	if parsed_json.error != OK:
		return parsed_json.error

	__data__ = JSON.print(parsed_json.result).to_utf8()

	return OK

var __cache__ = null

func get_data(duplicate=false):
	if null == __cache__:
		__cache__ = instance()
	var result = __cache__
	if duplicate:
		result = result.duplicate()
	return result

func instance():
	var data = __data__.get_string_from_utf8()
	var parsed_json = JSON.parse(data)
	if OK != parsed_json.error:
		var format = [parsed_json.error_line, parsed_json.error_string]
		var error_string = "%d: %s" % format
		print(error_string)
		return null
	return parsed_json.result
