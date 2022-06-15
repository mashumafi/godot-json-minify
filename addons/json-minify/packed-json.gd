extends PackedDataContainer

enum Compression {
	NONE,
	FASTLZ,
	DEFLATE,
	ZSTD,
	GZIP,
	BEST
}

const COMPRESSION_MAP := {
	Compression.NONE: -1,
	Compression.FASTLZ: File.COMPRESSION_FASTLZ,
	Compression.DEFLATE: File.COMPRESSION_DEFLATE,
	Compression.ZSTD: File.COMPRESSION_ZSTD,
	Compression.GZIP: File.COMPRESSION_GZIP
}

export(bool) var binary := true
export(Compression) var compression := Compression.BEST
export(int) var original_size : int

func set_data(filename: String):
	var input := File.new()
	var err := input.open(filename, File.READ)
	if err != OK:
		return err

	var json := input.get_as_text()

	input.close()

	var parsed_json := JSON.parse(json)
	if parsed_json.error != OK:
		return parsed_json.error

	if binary:
		__data__ = var2bytes(parsed_json.result)
	else:
		__data__ = JSON.print(parsed_json.result).to_utf8()

	original_size = __data__.size()

	if self.compression == Compression.BEST:
		self.compression = _compress_data()
	else:
		var compression : int = COMPRESSION_MAP[self.compression]
		if compression != -1:
			__data__ = __data__.compress(compression)

	return OK

const COMPRESSIONS := [Compression.FASTLZ, Compression.DEFLATE, Compression.ZSTD, Compression.GZIP]
func _compress_data():
	var data := __data__
	var compression = Compression.NONE
	for c in COMPRESSIONS:
		var compresion_mode : int = COMPRESSION_MAP[c]
		var result := __data__.compress(compresion_mode)
		if result.size() < data.size():
			data = result
			compression = c
	__data__ = data
	return compression

var __cache__ = null

func instance():
	if null == __cache__:
		var data = __data__

		if self.compression == Compression.BEST:
			print("Using best compression is not valid when decoding")
			return null
		var compression : int = COMPRESSION_MAP[self.compression]
		if compression != -1:
			data = data.decompress(original_size, compression)

		if binary:
			return bytes2var(data)
		else:
			data = data.get_string_from_utf8()
			var parsed_json := JSON.parse(data)
			if OK != parsed_json.error:
				var format := [parsed_json.error_line, parsed_json.error_string]
				var error_string = "%d: %s" % format
				print("Could not parse json", error_string)
				return null
			data = parsed_json.result

		__data__.resize(0) # free the data

		__cache__ = data
	return __cache__
