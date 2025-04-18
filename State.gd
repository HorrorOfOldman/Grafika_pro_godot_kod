extends Node

var current_health = 35
var current_mana = 30
var max_health = 35
var max_mana = 30
var damage = 20
#im więcej zaklęć, to trzeba dodać nowe puste elemanty do tablicy
var spell = ["","",""]		#nazwa
var spell_dmg = [0,0,0]		#obrażenia
var spell_cost = [0,0,0,]	#koszta
var spell_effect = [0,0,0]

func spell_init():
	# spell 1
	spell[0] = "Fireball"
	spell_dmg[0] = 30
	spell_cost[0] = 10
	spell_effect[0] = 1#podpalenie - -5punktów hp przeciwnika w następnej turze
	# spell 2
	spell[1] = "One jar"
	spell_dmg[1] = 10
	spell_cost[1] = 4
	spell_effect[1] = 0
		# spell 3
	spell[2] = "Quicksort"
	spell_dmg[2] = 50
	spell_cost[2] = 30
	spell_effect[2] = 0#brka efektów dodatkowych
