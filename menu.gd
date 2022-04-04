extends Control

func _ready():
	$ver.text = ProjectSettings.get_setting("application/config/version")

func _on_bot_count_changed(value):
	$container/host/bot_count/value.text = str(value)
	$container/click.play()

func _on_max_score_changed(value):
	$container/host/max_score/value.text = str(value)
	$container/click.play()

func _on_host_pressed():
	Game.spawn_map(0)
	Game.spawn_gobot("1", 0)
	for i in $container/host/bot_count/slider.value:
		Game.spawn_gobot("bot" + str(i), 2)
	visible = false
	$drone.stop()
	Net.create_server()

func _on_connect_pressed():
	$container/connect/buttons/connect.disabled = true
	Net.create_client($container/connect/ip/edit.text)

func _on_message_ok_pressed():
	$message.visible = false

func show_message(text : String):
	$message.visible = true
	$message/container/text.text = text

func _on_main_host_pressed():
	$container/main.visible = false
	$container/host.visible = true

func _on_main_connect_pressed():
	$container/main.visible = false
	$container/connect.visible = true

func _on_main_quit_pressed():
	get_tree().quit()

func _on_host_back_pressed():
	$container/host.visible = false
	$container/main.visible = true

func _on_connect_back_pressed():
	$container/connect.visible = false
	$container/main.visible = true
