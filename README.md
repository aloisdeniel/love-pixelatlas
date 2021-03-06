![Logo](logo.png)

A LÖVE texture atlas loader from pixel information of an image.

## Example

```lua
local pixelatlas = require('pixelatlas')

pixelatlas.register("#86a36bff")

local image, quads = pixelatlas.load('atlas.png')

--[[
{
	<quad 1x1x16x16>,
	<quad 17x1x16x32>,
	...
}]]

```

See the complete sample : [./sample](./sample)

## Installation

Just copy the `pixelatlas.lua` file somewhere in your projects (maybe inside a `/lib/` folder) and require it accordingly.

## API

### Property `pixelmap.isCache = true`

Indicates whether the loaded atlas should be saved as lua table in the folder `.pixelatlas/<path_img>.lua` of the local storage for quicker next load.

### Function `pixelatlas.register(color)`

Registers the quad separator color. Default is `#ff0000ff`.

* *arg* `color` - `string` - `required` : the RGBA hexadecimal color of the separators pixel color (ex: `"#ff2200ff"`).

### Function `pixelatlas.load(path) : Atlas`

Loads an image, reads each of its pixels and generate all quads from the atlas.

* *arg* `path` - `string` - `required` : path the image containing the atlas.
* *returns* An `Atlas` table with an array of quads

## Roadmap / Ideas

* Add unit tests

## Copyright and license

MIT © [Aloïs Deniel](http://aloisdeniel.github.io)
