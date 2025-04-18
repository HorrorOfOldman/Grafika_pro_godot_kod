extends Node2D

signal textbox_closed

@export var enemy :Resource = null

var current_player_health = 0
var current_player_mana = 0
var current_enemy_health = 0
var is_defending = false
var czar_id=0
var czar_ch=false

func _ready():
	State.spell_init()
	$dzwieki.play()#granie muzyczki
	set_health($EnemyContainer/ProgressBar,enemy.health, enemy.health)
	set_health($PlayerPanel/PlayerData/Label/Health,State.current_health, State.max_health)
	set_mana($PlayerPanel/PlayerData/Label/Mana,State.current_mana, State.max_mana)
	$EnemyContainer/EnemyjegoWrogość.texture = enemy.texture
	
	current_player_health = State.current_health
	current_player_mana = State.current_mana
	current_enemy_health = enemy.health
	
	$textbox.hide()
	$ActionPanel.hide()
	$EnemyContainer.hide()
	$PlayerPanel.hide()
	$GameOver.hide()
	
	display_text("Dziki %s Atakuje!"%enemy.name.to_upper())
	await self.textbox_closed
	$ActionPanel.show()
	$zaklecia.hide()
	$EnemyContainer.show()#bez tej linijki nei widać ciosmaka
	$EnemyContainer/ProgressBar.show()
	$PlayerPanel.show()
	
#-------------------------------------------------------------------
func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP: %d/%d" % [health, max_health]
func set_mana(progress_bar, mana, max_mana):
	progress_bar.value = mana
	progress_bar.max_value = max_mana	
	progress_bar.get_node("Label").text = "MP: %d/%d" % [mana, max_mana]

func _input(_event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $textbox.visible:
		$textbox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	if $textbox.has_node("Label"):
		$ActionPanel.hide()
		$zaklecia.hide()
		$textbox.show()
		$textbox/Label.text = text

func enemy_turn():
	$dzwieki/enemy_turn.play()
	display_text("%s zaprosił cię do tablicy!"%enemy.name.to_upper())
	await self.textbox_closed
	
	if is_defending:
		is_defending = false
		$AnimationPlayer.play("mini_shake")
		await $AnimationPlayer.animation_finished
		display_text("Jakimś cudem się udało wybronić!")
		await self.textbox_closed
	else:
		current_player_health -= enemy.damage
		set_health($PlayerPanel/PlayerData/Label/Health,current_player_health,State.max_health)
		$AnimationPlayer.play("shake")
		await $AnimationPlayer.animation_finished
		display_text("Jesteś bliższy do niezaliczenia semestru\n o %d punktów ECTS!"%enemy.damage)
		await self.textbox_closed
		if current_player_health<=0:
			display_text("Ujebałeś studia")
			await self.textbox_closed
			$dzwieki/player_dead.play()
			$AnimationPlayer.play("GameOver")
			$GameOver.show()
			await $AnimationPlayer.animation_finished
			await get_tree().create_timer(2.0).timeout
			get_tree().quit(0)
	$ActionPanel.show()

func _on_RUN_pressed():
	if enemy.level==1:#prosty/podstawowy przeciwnik
		display_text("Udało się spierdolić z ćwiczeń!")
		await self.textbox_closed
		await get_tree().create_timer(0.5).timeout
		get_tree().quit(0)
	
	if enemy.level==2:#przeciwnik przed którym można zwiać, ale to ależy od szczęścia(losowanie)
		var los = randi_range(1, 21)  # Losowanie liczby od 1 do 21
		print("Wylosowano:", los)  # Debug, aby zobaczyć wynik losowania
		if los<16:
			display_text("Nie udało się spierdolić!")
			await self.textbox_closed
			enemy_turn()
			
		elif los>15:
			display_text("Udało się spierdolić z ćwiczeń!")
			await self.textbox_closed
			await get_tree().create_timer(0.5).timeout
			get_tree().quit(0)

	if enemy.level==3:#przeciwnik bardzo trudny, boss, przed nim nie uciekniesz
		display_text("Przed nim nie da się spierdolić! Oczekuj śmierci!")
		await self.textbox_closed
		enemy_turn()

func _on_ATTACK_pressed():
	display_text("Pierdolnąłeś algorytmem sortowania bąbelkowego!")
	await self.textbox_closed
	
	current_enemy_health -= State.damage
	set_health($EnemyContainer/ProgressBar,current_enemy_health,enemy.health)
	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	display_text("Przyjebałeś z siłą %d punktów wpierdolu!"%State.damage)
	await self.textbox_closed
	
	if current_enemy_health <= 0:
		display_text("Ciemiężyciel %s został pokonany!"%enemy.name)
		await self.textbox_closed
		$dzwieki/dead.play()
		$dzwieki/win.play()
		$AnimationPlayer.play("enemy_died")
		await $AnimationPlayer.animation_finished
		await get_tree().create_timer(4.3).timeout
		get_tree().quit(0)
	enemy_turn()

func _on_MAGIC_pressed():
	$zaklecia.show()
	while(czar_ch):
		if current_player_mana-State.spell_cost[czar_id]<0:
			display_text("Masz za mało many na użycie czaru!")
			await self.textbox_closed
			$ActionPanel.show()
		
		else:
			display_text("Pizdnąłęś %s!"%State.spell[czar_id])
			await self.textbox_closed
	
			current_enemy_health -= State.spell_dmg[czar_id]
			current_player_mana -= State.spell_cost[czar_id]
			set_health($EnemyContainer/ProgressBar,current_enemy_health,enemy.health)
			set_mana($PlayerPanel/PlayerData/Label/Mana,current_player_mana,State.max_mana)
			$AnimationPlayer.play("enemy_damaged")
			await $AnimationPlayer.animation_finished
	
			display_text("Przyjebałeś z siłą %d punktów wpierdolu!\nUżyłeś %d punktów many!" % [State.spell_cost[czar_id], State.spell_cost[czar_id]])
			await self.textbox_closed
	
			if current_enemy_health <= 0:
				display_text("Ciemiężyciel %s został pokonany!"%enemy.name)
				await self.textbox_closed
				$AudioStreamPlayer/dead.play()
				$AudioStreamPlayer/win.play()
				$AnimationPlayer.play("enemy_died")
				await $AnimationPlayer.animation_finished
				await get_tree().create_timer(4.3).timeout
				get_tree().quit(0)
			else:
				enemy_turn()
	czar_ch=false
	
	
	

func _on_DEFEND_pressed():#do wywalenia, nie ma być opcji obrony
	is_defending = true
	display_text("Przygotowywujesz się na najgorsze!")
	await self.textbox_closed
	await get_tree().create_timer(0.25).timeout
	enemy_turn()

func _on_spell_1_pressed():
	czar_id=1
	print("wybrano zailęcie 1")
	czar_ch=true
func _on_spell_2_pressed():
	czar_id=2
	print("wybrano zaklęcie 2")
	czar_ch=true
func _on_spell_3_pressed():
	czar_id=3
	print("wybrano zaklęcie 3")
	czar_ch=true
	
