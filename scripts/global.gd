extends Node

var score = 0
var score_lable

func exit():
	get_tree().quit()

func score_count():
	score += 1
	score_lable.text = 'Score:' + str(score)
