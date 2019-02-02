# godot-json-minify
Add JSON resource with minification to godot

This addon will allow calling `load` on `*.json` files to load them as resources. It takes out some of the manual process of loading JSON files and also can allow you to preload your files too.

```gdscript
func example():
	var json = preload('example.json')
	print(json.instance()) # parse the json file
```

Additionally, the resources acts as a cache for the returned instance. The text for the json is not parsed until the instance function is called. Once called, it will save the result and always return that same reference. This means, you should be careful when editing because instances can be shared across scripts. The resources also compresses the json text to reduce the size even further.

# Future goals

* Additional import options
  * Choose compression format (none, fastlz, deflate, zstd, gzip)
  * Choose output data (minify, binary)
