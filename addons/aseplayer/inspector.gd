extends EditorInspectorPlugin

var select_file_dialog: EditorFileDialog

func can_handle(object):
	if object is AsePlayer:
		return true
	return false

func parse_property(object, type, path, hint, hint_text, usage):
	if path == "config":
		var prop := preload("config_property.gd").new()
		prop.select_file_dialog = select_file_dialog

		prop.player = object
		prop.root = object.get_parent()

		add_property_editor(path, prop)
		return true
	else:
		return false
