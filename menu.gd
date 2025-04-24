extends Node

var choose := true
var m1Ch := true
var m2Ch := false

func _ready():
	$inter.show()
	$inter/inter_1.show()
	$inter/inter_2.hide()
	$music.play()
	cam_anim_loop()

func cam_anim_loop():
	if not choose:
		return
	$animki.play("camera_move")
	await $animki.animation_finished
	cam_anim_loop()

func _on_start_pressed():
	print("START clicked, m1Ch:", m1Ch)
	print("				, m2Ch:", m2Ch)
	if m1Ch:
		choose = false
		$animki.stop()
		$animki.play("inter_1_hide")
		await $animki.animation_finished

		$inter/inter_1.hide()
		$animki.play("camera_chPos")
		await $animki.animation_finished

		$inter/inter_2.show()
		$animki.play("inter_2_show")
		await $animki.animation_finished

		m1Ch = false
		m2Ch = true
	
	#get_tree().change_scene_to_file("res://Scena_walki_2D_testowa.tscn")

func _on_back_pressed():
	print("BACK clicked, m2Ch:", m2Ch)
	print("			, m1Ch:", m1Ch)
	if m2Ch:
		choose = true
		$animki.stop()
		$animki.play("inter_2_hide")
		await $animki.animation_finished

		$inter/inter_2.hide()
		$animki.play("camera_chPos_back")
		await $animki.animation_finished

		$inter/inter_1.show()
		$animki.play("inter_1_show")
		await $animki.animation_finished

		m1Ch = true
		m2Ch = false
		cam_anim_loop()

func _on_quit_pressed():
	if m1Ch:
		choose = false
		m1Ch = false
		get_tree().quit(0)

func _on_lv_1_pressed():
	get_tree().change_scene_to_file("res://sceny/fight/l1_fight.tscn")

func _on_lv_2_pressed():
	get_tree().change_scene_to_file("res://sceny/fight/l2_fight.tscn")

func _on_lv_3_pressed():
	get_tree().change_scene_to_file("res://sceny/fight/l3_fight.tscn")
