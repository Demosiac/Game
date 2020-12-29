extends KinematicBody2D

var movespeed=150
var bullet_speed=2000
var bullet= preload("res://Bullet.tscn")
var fire_rate=0.2
var can_fire =true

func _ready():
	pass

func _physics_process(delta):
	var motion=Vector2()
	if Input.is_action_pressed("move_up"):
		motion.y -=1
		$Animations.play("WalkButt")
	if Input.is_action_pressed("move_down"):
		motion.y +=1
		$Animations.play("WalkButt")
	if Input.is_action_pressed("move_left"):
		motion.x -=1
		$Animations.play("WalkButt")
	if Input.is_action_pressed("move_right"):
		motion.x +=1
		$Animations.play("WalkButt")
	if Input.is_action_pressed("ready_gun"):
		$Animations.play("DrawGun")
	if Input.is_action_just_pressed("aim"):
		$Animations.play("Aim")
	motion=motion.normalized()
	motion=move_and_slide(motion*movespeed) #movenslide
	
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot"):
		fire()

func fire():
	$Animations.play("Shoot")
	var bullet_instance=bullet.instance()
	bullet_instance.position=$Chest/Shotgun/BulletPoint.get_global_position()
	bullet_instance.rotation_degrees=rotation_degrees
	bullet_instance.apply_impulse(Vector2(),Vector2(bullet_speed,0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child",bullet_instance)
	can_fire=false
	yield(get_tree().create_timer(fire_rate), "timeout")
	can_fire=true
	
func kill():
	get_tree().reload_current_scene()
func _on_Area2D_body_entered(body):
	if "Enemy" in body.name:
		kill()

