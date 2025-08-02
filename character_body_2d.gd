extends CharacterBody2D 
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var can_doublejump: bool = false
@onready var healthbar = $CanvasLayer/BarraVida
var vida: float = 0

var light: bool = false
var medium: bool = false
var heavy: bool = false

# Establece valores iniciales para Estelle, si se puede aca iran stats tamb
func _ready():
	vida = 100.00
	healthbar.init_health(vida)
	$anim.play("idle Estelle")

#Fisicas
func _physics_process(delta: float) -> void:
	#Desactivamos todas las hitboxes de daño
	$Area2D/LightCollision.disabled = true
	$Area2D/MediumCollision.disabled = true
	$Area2D/HeavyCollision.disabled = true
	#Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta
	# En esta condición van todos los ataques que evitan que puedas moverte mientras los realizas
	if not light and not medium and not heavy:

		# Salto + Doble salto
		if Input.is_action_just_pressed("jump") and is_on_floor():
			can_doublejump = true
			velocity.y = JUMP_VELOCITY
		elif Input.is_action_just_pressed("jump") and !is_on_floor() and can_doublejump:
			can_doublejump = false  
			velocity.y = JUMP_VELOCITY

		# Moverse a los lados
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		
		#al tocar comandos activa el else y su hitbox
		if Input.is_action_just_pressed("light"):
			light = true
			$Area2D/LightCollision.disabled = false
		if Input.is_action_just_pressed("medium"):
			medium = true
			$Area2D/MediumCollision.disabled = false
		if Input.is_action_just_pressed("heavy"):
			heavy = true
			$Area2D/HeavyCollision.disabled = false
	#animación, spawn de hit box de daño y devolver variables de comandos a false al final
	else:
		if light:
			$anim.play("light")
			await($anim.animation_finished)
			$Area2D/LightCollision.disabled = true
			light = false
		if medium:
			$anim.play("medium")
			await($anim.animation_finished)
			$Area2D/MediumCollision.disabled = true
			medium = false
		if heavy:
			$anim.play("heavy")
			await($anim.animation_finished)
			$Area2D/HeavyCollision.disabled = true
			heavy = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("2player") and light==true:
		body.tpegaron(25)
	if body.is_in_group("2player") and medium==true:
		body.tpegaron(50)
	if body.is_in_group("2player") and heavy==true:
		body.tpegaron(75)
		
func tepegaron():
	vida = vida - 25
	healthbar.health = vida
