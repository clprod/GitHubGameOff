extends Sprite

# class member variables go here, for example:
# var a = 2
var decrease = true

func _ready():
	set_opacity(1)
	set_fixed_process(true)

func _fixed_process(delta):
	if decrease:
		set_opacity(get_opacity()-0.01)
		if get_opacity() <= 0:
			decrease = false
	else:
		set_opacity(get_opacity()+0.01)
		if get_opacity() == 1:
			decrease = true
	
