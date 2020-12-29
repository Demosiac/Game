extends KinematicBody2D

var movespeed=300
var bullet_speed=3000
var bullet= preload("res://Bullet.tscn")
var fire_rate=0.2
var can_fire =true
var fire_perm=false
var motion=Vector2()

func _ready():
	pass

func _physics_process(delta):
	motion.x = 0
	motion.y = 0
	if Input.is_action_pressed("move_up"):
		motion.y -=1
		$Butt/AnimationPlayer.play("WalkButt")
		if fire_perm==false and not $Chest/AnimationPlayer.is_playing(): 
			$Chest/AnimationPlayer.play("WalkChest")
	elif Input.is_action_just_released("move_up"):
		$Butt/AnimationPlayer.stop(false)
	elif Input.is_action_pressed("move_down"):
		motion.y +=1
		$Butt/AnimationPlayer.play("WalkButt")
		if fire_perm==false and not $Chest/AnimationPlayer.is_playing(): 
			$Chest/AnimationPlayer.play("WalkChest")
	elif Input.is_action_just_released("move_down"):
		$Butt/AnimationPlayer.stop(false)
		
		
	if Input.is_action_pressed("move_left"):
		motion.x -=1
		$Butt/AnimationPlayer.play("WalkButt")
		if fire_perm==false and not $Chest/AnimationPlayer.is_playing(): 
			$Chest/AnimationPlayer.play("WalkChest")
	elif Input.is_action_just_released("move_left"):
		$Butt/AnimationPlayer.stop(false)
	elif Input.is_action_pressed("move_right"):
		motion.x +=1
		$Butt/AnimationPlayer.play("WalkButt")
		if fire_perm==false and not $Chest/AnimationPlayer.is_playing(): 
			$Chest/AnimationPlayer.play("WalkChest")
	elif Input.is_action_just_released("move_right"):
		$Butt/AnimationPlayer.stop(false)
		
		
	if Input.is_action_just_pressed("ready_gun"):
		if fire_perm==false:
			$Chest/AnimationPlayer.play("DrawGun")
			fire_perm=true
		else: 
			$Chest/AnimationPlayer.play_backwards("DrawGun")
			fire_perm=false
	if Input.is_action_just_pressed("aim"):
		$Chest/AnimationPlayer.play("Aim")
	
	motion=motion.normalized()
	motion = motion.rotated(rotation+PI/2)
	motion=move_and_slide(motion*movespeed) #movenslide
	look_at(get_global_mouse_position())
	
	
	if Input.is_action_pressed("shoot") and fire_perm==true:
		fire()

func fire():
	$Chest/AnimationPlayer.play("Shoot")
	var bullet_instance=bullet.instance()
	bullet_instance.position=$Chest/Chest/Shotgun/BulletPoint.get_global_position()
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
