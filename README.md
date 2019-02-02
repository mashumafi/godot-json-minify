# godot-json-minify
Add JSON resource with minification to godot

This addon will allow calling `load` on `*.json` files to load them as resources. It takes out some of the manual process of loading JSON files and also can allow you to preload your files too.

```gdscript
func example():
	var json = preload('example.json')
	print(json.instance()) # parse the json file
```
