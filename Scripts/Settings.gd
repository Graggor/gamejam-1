extends Node

const SAVE_PATH = "user://config.cfg"

var config = ConfigFile.new()
var settings = {
	"audio": {
		"overall": db2linear(AudioServer.get_bus_volume_db(0)),
		"music": db2linear(AudioServer.get_bus_volume_db(1)),
		"sounds": db2linear(AudioServer.get_bus_volume_db(2))
	}
}

func _ready():
	print(OS.get_user_data_dir())
	print(settings["audio"])
	#_load()
	#_save()
	print(settings["audio"])

func _load():
	var error = config.load(SAVE_PATH)
	if error != OK:
		print("Failed loading settings file. Error code %s" % error)
		return null
	else:
		for section in settings.keys():
			for key in settings[section]:
				settings[section][key] = config.get_value(section, key, null)
		_apply()

func _save():
	for section in settings.keys():
		for key in settings[section]:
			config.set_value(section, key, settings[section][key])
	config.save(SAVE_PATH)
	print(settings["audio"])

func _apply():
	AudioServer.set_bus_volume_db(0, settings["audio"]["overall"])
	AudioServer.set_bus_volume_db(1, settings["audio"]["music"])
	AudioServer.set_bus_volume_db(2, settings["audio"]["sounds"])
