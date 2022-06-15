extends PackedDataContainer

enum Compression {
	COMPRESSION_NONE,
	COMPRESSION_FASTLZ,
	COMPRESSION_DEFLATE,
	COMPRESSION_ZSTD,
	COMPRESSION_GZIP,
	COMPRESSION_BEST
}

var CompressionMap := {
	Compression.COMPRESSION_NONE: -1,
	Compression.COMPRESSION_FASTLZ: File.COMPRESSION_FASTLZ,
	Compression.COMPRESSION_DEFLATE: File.COMPRESSION_DEFLATE,
	Compression.COMPRESSION_ZSTD: File.COMPRESSION_ZSTD,
	Compression.COMPRESSION_GZIP: File.COMPRESSION_GZIP
}

export(bool) var binary = true
export(Compression) var compression = Compression.COMPRESSION_BEST
export(int) var original_size

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

	if binary:
		__data__ = var2bytes(parsed_json.result)
	else:
		__data__ = JSON.print(parsed_json.result).to_utf8()

	original_size = __data__.size()

	if self.compression == Compression.COMPRESSION_BEST:
		self.compression = _compress_data()
	else:
		var compression = CompressionMap[self.compression]
		if compression != -1:
			__data__ = __data__.compress(compression)

	return OK

var compressions := [Compression.COMPRESSION_FASTLZ, Compression.COMPRESSION_DEFLATE, Compression.COMPRESSION_ZSTD, Compression.COMPRESSION_GZIP]
func _compress_data():
	var data = __data__
	var compression = Compression.COMPRESSION_NONE
	for c in compressions:
		var compresion_mode = CompressionMap[c]
		var result = __data__.compress(compresion_mode)
		if result.size() < data.size():
			data = result
			compression = c
	__data__ = data
	return compression

var __cache__ = null

func instance():
	if null == __cache__:
		var data = __data__

		if self.compression == Compression.COMPRESSION_BEST:
			print("Using best compression is not valid when decoding")
			return null
		var compression = CompressionMap[self.compression]
		if compression != -1:
			data = data.decompress(original_size, compression)

		if binary:
			return bytes2var(data)
		else:
			data = data.get_string_from_utf8()
			var parsed_json = JSON.parse(data)
			if OK != parsed_json.error:
				var format = [parsed_json.error_line, parsed_json.error_string]
				var error_string = "%d: %s" % format
				print("Could not parse json", error_string)
				return null
			data = parsed_json.result

		__data__.resize(0) # free the data

		__cache__ = data
	return __cache__
