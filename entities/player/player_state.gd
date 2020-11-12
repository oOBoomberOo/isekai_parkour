extends StateMachine

func _ready():
	_state = {
		"idle": $Idle,
		"run": $Run,
		"fall": $Fall,
		"jump": $Jump
	}
	
