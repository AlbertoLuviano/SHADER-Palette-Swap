extends Node2D

onready var spriteOptions = [get_node("/root/World/MsPacMan"),\
						get_node("/root/World/MegaMan"),\
						get_node("/root/World/MFusion")]
onready var referenceColors = [get_node("/root/World/UI/MapColors/Color01"),\
					get_node("/root/World/UI/MapColors/Color02"),\
					get_node("/root/World/UI/MapColors/Color03"),\
					get_node("/root/World/UI/MapColors/Color04"),\
					get_node("/root/World/UI/MapColors/Color05"),\
					get_node("/root/World/UI/MapColors/Color06"),\
					get_node("/root/World/UI/MapColors/Color07"),\
					get_node("/root/World/UI/MapColors/Color08"),\
					get_node("/root/World/UI/MapColors/Color09"),\
					get_node("/root/World/UI/MapColors/Color10"),\
					get_node("/root/World/UI/MapColors/Color11"),\
					get_node("/root/World/UI/MapColors/Color12")]
onready var selection = get_node("/root/World/UI/CurrentSelection")
onready var pickerColorDisplay = get_node("/root/World/UI/ColorPicker/Display")
onready var redSlider = get_node("/root/World/UI/ColorPicker/RGB/Red")
onready var greenSlider = get_node("/root/World/UI/ColorPicker/RGB/Green")
onready var blueSlider = get_node("/root/World/UI/ColorPicker/RGB/Blue")
onready var tweenNode = $Tween

var dynamicSpeed : float = 0.1
var currentSprite : int = 2
var currentColor : int = 0
var swapColors : bool = true
var updateCurrentColor : bool = true
var dynamicOn : bool = false
var selectionInfo = {0 : [Vector2(256, 56), 240, 4],\
					1 : [Vector2(153, 56), 137.14, 7],\
					2: [Vector2(96, 56), 80, 12]}
var currentPickerColor : Color = Color(0.5, 0.5, 0.5)
var dynamicColors = [Color(0.95, 0.78, 0.36),\
					Color(0.98, 0.64, 0.40),\
					Color(0.97, 0.43, 0.32),\
					Color(0.93, 0.24, 0.22),\
					Color(0.82, 0.10, 0.24)]

var grayColors = {0 : [Color(0.05, 0.05, 0.05),\
						Color(0.30, 0.30, 0.30),\
						Color(0.55, 0.55, 0.55),\
						Color(0.80, 0.80, 0.80)],\
				1 : [Color(0.05, 0.05, 0.05),\
					Color(0.20, 0.20, 0.20),\
					Color(0.35, 0.35, 0.35),\
					Color(0.50, 0.50, 0.50),\
					Color(0.65, 0.65, 0.65),\
					Color(0.80, 0.80, 0.80),\
					Color(0.95, 0.95, 0.95)],\
				2 : [Color(0.04, 0.04, 0.04),\
					Color(0.12, 0.12, 0.12),\
					Color(0.20, 0.20, 0.20),\
					Color(0.28, 0.28, 0.28),\
					Color(0.36, 0.36, 0.36),\
					Color(0.44, 0.44, 0.44),\
					Color(0.52, 0.52, 0.52),\
					Color(0.60, 0.60, 0.60),\
					Color(0.68, 0.68, 0.68),\
					Color(0.76, 0.76, 0.76),\
					Color(0.84, 0.84, 0.84),\
					Color(0.92, 0.92, 0.92)]}
var originalColors = {0 : [Color(0.0, 0.0, 0.0),\
						Color(0.88, 0.10, 0.34),\
						Color(0.0, 0.0, 0.75),\
						Color(1.0, 0.90, 0.0)],\
				1 : [Color(0.0, 0.0, 0.0),\
					Color(0.15, 0.22, 0.51),\
					Color(0.30, 0.73, 0.70),\
					Color(0.64, 0.34, 0.34),\
					Color(0.99, 0.85, 0.66),\
					Color(1.0, 1.0, 1.0),\
					Color(0.38, 0.50, 0.76)],\
				2 : [Color(0.12, 0.10, 0.37),\
					Color(0.12, 0.27, 0.56),\
					Color(0.19, 0.51, 0.97),\
					Color(0.13, 0.91, 1.0),\
					Color(0.58, 0.08, 0.21),\
					Color(0.74, 0.15, 0.19),\
					Color(0.86, 0.11, 0.31),\
					Color(0.16, 0.68, 0.28),\
					Color(0.55, 0.87, 0.49),\
					Color(0.80, 0.80, 0.11),\
					Color(0.97, 1.0, 0.12),\
					Color(1.0, 1.0, 1.0)]}

func _on_mouse_entered(colorToChange):
	currentColor = colorToChange
	selection.rect_position = Vector2(14.0 + (selectionInfo.get(currentSprite)[1] * colorToChange), 438.0)
	
	updateCurrentColor = false
	redSlider.value = referenceColors[currentColor].color.r
	greenSlider.value = referenceColors[currentColor].color.g
	blueSlider.value = referenceColors[currentColor].color.b
	updateCurrentColor = true
	currentPickerColor = referenceColors[currentColor].color
	pickerColorDisplay.color = currentPickerColor

func _on_TextureColor_pressed():
	swapColors = false
	dynamicOn = false
	tweenNode.stop_all()
	
	var shaderMat = spriteOptions[currentSprite].get_material()
	
	for color in range(grayColors.get(currentSprite).size()):
		shaderMat.set_shader_param("C%s" % (color + 1), grayColors.get(currentSprite)[color])

func _on_StaticSwap_pressed():
	swapColors = true
	dynamicOn = false
	tweenNode.stop_all()
	
	var shaderMat = spriteOptions[currentSprite].get_material()
	
	for color in range(grayColors.get(currentSprite).size()):
		shaderMat.set_shader_param("C%s" % (color + 1), referenceColors[color].color)

func _onDynamicSwap_pressed():
	if !dynamicOn:
		swapColors = false
		dynamicOn = true
		
		for dynamicColor in range(selectionInfo.get(currentSprite)[2]):
			tweenNode.interpolate_property(referenceColors[dynamicColor], "color", null, dynamicColors[wrapi(dynamicColor, 0 ,5)], \
				dynamicSpeed, Tween.TRANS_LINEAR)
		tweenNode.start()

func _on_SpriteChange_pressed(spriteNo):
	if spriteNo != currentSprite:
		#change visible Sprite
		spriteOptions[currentSprite].visible = false
		currentSprite = spriteNo
		spriteOptions[currentSprite].visible = true
		
		#Rearrange reference colors
		for colorReference in range(referenceColors.size()):
			referenceColors[colorReference].visible = colorReference < selectionInfo.get(currentSprite)[2]
			if colorReference < selectionInfo.get(currentSprite)[2]:
				referenceColors[colorReference].color = originalColors.get(currentSprite)[colorReference]
		selection.rect_size = selectionInfo.get(currentSprite)[0]
		currentColor = clamp(currentColor, 0, selectionInfo.get(currentSprite)[2] - 1)
		_on_mouse_entered(currentColor)
		
		#Update number of colors in Shader
		spriteOptions[currentSprite].get_material().set_shader_param("numberOfColors", selectionInfo.get(currentSprite)[2])
		_on_StaticSwap_pressed()


func _on_ColorPicker_changed(value, color):
	if updateCurrentColor:
		match color:
			0:
				currentPickerColor.r = value
			1:
				currentPickerColor.g = value
			2:
				currentPickerColor.b = value
		pickerColorDisplay.color = currentPickerColor
		
		#Update reference shader Colors
		if swapColors:
			referenceColors[currentColor].color = currentPickerColor
			var shaderMat = spriteOptions[currentSprite].get_material()
			shaderMat.set_shader_param("C%s" % (currentColor + 1), currentPickerColor)

func _on_DynamicSwapTween_completed(object, key):
	if dynamicOn:
		tweenNode.interpolate_property(object, key, null, dynamicColors[wrapi(dynamicColors.find(object.color) + 1, 0, 5)], \
			dynamicSpeed, Tween.TRANS_LINEAR)
		tweenNode.start()

func _on_DynamicSwapTween_step(object, _key, _elapsed, value):
	var shaderMat = spriteOptions[currentSprite].get_material()
	shaderMat.set_shader_param("C%s" % (object.name.substr(5,2).to_int()), value)


func _on_DynamicSpeedValue_changed(value):
	dynamicSpeed = value
