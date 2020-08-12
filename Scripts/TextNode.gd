extends Area2D

export (String) var text

func _on_TextNode_body_entered(body):
	body.talk(text)
