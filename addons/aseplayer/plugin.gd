tool
extends EditorPlugin

var plugin
var select_file_dialog

func _enter_tree():
    var base := get_editor_interface().get_base_control()

    var select_file_dialog := EditorFileDialog.new()
    select_file_dialog.add_filter("*.json")
    select_file_dialog.mode = EditorFileDialog.MODE_OPEN_FILE

    base.add_child(select_file_dialog)

    # EditorInspectorPlugin is a resource, so we use `new()` instead of `instance()`.
    plugin = preload("inspector.gd").new()
    plugin.select_file_dialog = select_file_dialog
    add_inspector_plugin(plugin)

func _exit_tree():
    remove_inspector_plugin(plugin)
