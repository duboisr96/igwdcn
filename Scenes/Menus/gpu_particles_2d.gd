extends GPUParticles2D


# Called when the node enters the scene tree for the first time.

func _ready():
	var colors = [
		Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW, 
		Color.PINK, Color.ORANGE, Color.PURPLE, Color.CYAN
	]
	
	# Generate a random color for each particle
	var new_colors = []
	for i in range(amount):
		new_colors.append(colors[randi() % colors.size()])

	self.process_material.color_ramp = create_color_ramp(new_colors)
	self.emitting = true  # Start the effect

# Helper function to create a ColorRamp from an array of colors
func create_color_ramp(color_list):
	var gradient := Gradient.new()
	for i in range(color_list.size()):
		gradient.add_point(i / float(color_list.size() - 1), color_list[i])
	
	var color_ramp_texture := GradientTexture1D.new()
	color_ramp_texture.gradient = gradient
	return color_ramp_texture
