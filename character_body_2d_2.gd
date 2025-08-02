extends CharacterBody2D
@onready var healthbar = $CanvasLayer/BarraVida
var vida: float = 0

# Todo lo necesario para que Josette funcione
func _ready():
	vida = 100
	healthbar.init_health(vida)
	
	
	
#función encargada de registrar daño y matar a personajes sin vida
func tpegaron(daño):
	vida = vida - daño
	healthbar.health = vida
	if vida <= 0.00:
		queue_free()
