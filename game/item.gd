extends AnimatedSprite



var rng = RandomNumberGenerator.new()
var rand = rng.randi_range(0,2)

var animations = ['metal', 'nao', 'papel', 'plastico', 'vidro']
var rand_anim = rng.randi_range(0,4)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.play(animations[rand_anim])
	self.stop()
	pass # Replace with function body.
	
func getCurrentFrameRect() -> Rect2:
	var size = frames.get_frame(animation, frame).get_size()
	var pos = offset
	if centered:
		pos -= 0.5 * size
	return Rect2(pos, size)
	
func rand_state():
	rand_anim = rng.randi_range(0,4)
	self.play(animations[rand_anim])
	self.stop()
	
	rand = rng.randi_range(0,2)
	self.frame = rand
	print(rand)
	
func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		if getCurrentFrameRect().has_point(to_local(event.global_position)):
			rand_state()
