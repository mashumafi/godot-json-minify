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

func instance():
	if null == __cache__:
		var data = __data__.get_string_from_utf8()
		__data__.resize(0) # free the data
		var parsed_json = JSON.parse(data)
		if OK != parsed_json.error:
			var format = [parsed_json.error_line, parsed_json.error_string]
			var error_string = "%d: %s" % format
			print(error_string)
			return null
		__cache__ = parsed_json.result
	return __cache__
