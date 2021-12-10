extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var rng = RandomNumberGenerator.new()


onready var item = get_tree().get_root().get_node("Game/item")
var guesses = ['Metal!', 'Não reciclado!', 'Papel!', 'Plastico!', 'Vidro!']
var guess_index = 0

var NeuralNetwork = preload("res://neural/Brain.gd")
var training_data = [
	{
		"inputs": [1,0,0],#metal
		"targets": [1,0,0,0,0]
	},
	{
		"inputs": [0,1,0],#nao
		"targets": [0,1,0,0,0]
	},
	{
		"inputs": [0,0,1],#papel
		"targets": [0,0,1,0,0]
	},
	{
		"inputs": [1,1,0],#plastico
		"targets": [0,0,0,1,0]
	},
	{
		"inputs": [0,1,1],#vidro
		"targets": [0,0,0,0,1]
	}
]


onready var neural_network = NeuralNetwork.new(3, 5, 5)

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func array2guess(array):
	var max_value = array.max()
	var index = 0
	for i in range(0, array.size()):
		if array[i] == max_value:
			index = i
			break
	return index

func get_accuracy():
	var count = 0.0
	if array2guess(neural_network.predict([1,0,0])) == 0:
		count += 1
	if array2guess(neural_network.predict([0,1,0])) == 1:
		count += 1
	if array2guess(neural_network.predict([0,0,1])) == 2:
		count += 1
	if array2guess(neural_network.predict([1,1,0])) == 3:
		count += 1
	if array2guess(neural_network.predict([0,1,1])) == 4:
		count += 1
	return (count/5)*100

func guess():
	# random
	#guess_number = rng.randi_range(0,4)
	#$robot_say.text = guesses[guess_number]
	
	#var data = training_data[0]
	#neural_network.train(data.inputs, data.targets)
	
	# ['Metal!', 'Não reciclado!', 'Papel!', 'Plastico!', 'Vidro!']
	
	if item.animation == "metal":
		guess_index = array2guess(neural_network.predict([1,0,0]))
	elif item.animation == "nao":
		guess_index = array2guess(neural_network.predict([0,1,0]))
	elif item.animation == "papel":
		guess_index = array2guess(neural_network.predict([0,0,1]))
	elif item.animation == "plastico":
		guess_index = array2guess(neural_network.predict([1,1,0]))
	else:
		# vidro
		guess_index = array2guess(neural_network.predict([0,1,1]))

	$robot_say.text = guesses[guess_index]


func eval_resp(user_is_correct):
	# show resposta
	
	if user_is_correct:
		$judge.frame = 1
		$judge_msg.text = "Você acertou!"
		$judge.visible = true
		$judge_msg.visible = true
		# reforça
		#for j in range(10):
		for i in range(5):
			var data = training_data[i]
			neural_network.train(data.inputs, data.targets)
	else:
		$judge.frame = 0
		$judge_msg.text = "Você errou!"
		$judge.visible = true
		$judge_msg.visible = true
	
	
	if item.rand_anim == guess_index:
		happy()
	else:
		sad()
	


func reset():
	yield(get_tree().create_timer(1.0), "timeout")
	$judge_msg.visible = false
	$judge.visible = false
	item.rand_state()
	neutral()
	guess()
	var n = get_accuracy()
	print("ACC:",n)
	$acc.text = "Acerto:"+str(n)+"%"

func happy():
	self.frame = 2
	$robot_say.text = "Acertei!"
	reset()

func neutral():
	self.frame = 1

func sad():
	self.frame = 0
	$robot_say.text = "Errei!"
	reset()
