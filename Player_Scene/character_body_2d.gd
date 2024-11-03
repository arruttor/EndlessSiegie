extends CharacterBody2D



# Variáveis configuráveis para gravidade, velocidade, pulo e atrito
var gravity = 25
var speed = 300.0
var jump_force = 800
var friction = 1.0
var shoot_interval = 0.3  # Intervalo entre disparos (em segundos)
var time_since_last_shot = 0.0  # Tempo decorrido desde o último disparo

func _ready() -> void:
	# Definimos a animação inicial do personagem
	$AnimatedSprite2D.play("idle")
func _process(delta: float) -> void:
	time_since_last_shot +=delta
	apply_gravity()
	handle_movement()
	handle_jump()
	play_animation()
	move_and_slide()

# Função para aplicar gravidade
func apply_gravity() -> void:
	if !is_on_floor():
		velocity.y += gravity

# Função para controlar o movimento do personagem
func handle_movement() -> void:
	if Input.is_action_pressed("tiro"):
		velocity.x = lerp(velocity.x, 0.0, friction)
		if time_since_last_shot >= shoot_interval:
			time_since_last_shot = 0
			var bullet = preload("res://scenes/Bullet_Scene/Bullet.tscn").instantiate()
			bullet.get_node("Area2D").set_direction(-1 if $AnimatedSprite2D.flip_h else 1)  # Define a direção baseada no flip_h
			get_parent().add_child(bullet)
			bullet.position = position   # Define a posição inicial da bala como a posição do personagem

	elif Input.is_action_pressed("ui_left"):
		velocity.x = lerp(velocity.x, -speed, friction)
		$AnimatedSprite2D.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		velocity.x = lerp(velocity.x, speed, friction)
		$AnimatedSprite2D.flip_h = false
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

# Função para pulo do personagem
func handle_jump() -> void:
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = -jump_force

# Função para animações
func play_animation() -> void:
	if !is_on_floor():
		if $AnimatedSprite2D.animation != "Jump":
			$AnimatedSprite2D.play("Jump")
	elif Input.is_action_pressed("tiro"):
		if $AnimatedSprite2D.animation != "shoot":
			$AnimatedSprite2D.play("shoot")
	elif abs(velocity.x) > 0.1:
		if $AnimatedSprite2D.animation != "Run":
			$AnimatedSprite2D.play("Run")
	else:
		if $AnimatedSprite2D.animation != "idle":
			$AnimatedSprite2D.play("idle")
