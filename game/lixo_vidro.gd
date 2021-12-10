extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var item = get_tree().get_root().get_node("Game/item")
onready var face = get_tree().get_root().get_node("Game/face")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):
			if item.animation == "vidro":
				face.eval_resp(true)
			else:
				face.eval_resp(false)
