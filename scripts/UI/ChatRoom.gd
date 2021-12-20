extends Control

###Variables###
onready var msgLog : RichTextLabel = get_node("MsgLog");
onready var msgEdit : TextEdit = get_node("MsgEdit");
onready var usersList : ItemList = get_node("UsersList");

###Ready function###
func _ready() -> void:
	Network.connect("updateUserList", self, "updateUserList");
	get_tree().connect("network_peer_disconnected", self, "networkPeerDisconnected");
	updateUserList();

###When Logout is pressed###
func _on_LogoutButton_pressed() -> void:
	Network.resetNetworkPeer();
	get_tree().change_scene("res://scenes/Main.tscn");

###When Send is pressed###
func _on_SendButton_pressed() -> void:
	pass;



###When a user disconnect###
func networkPeerDisconnected(userId) -> void:
	Network.userList.erase(str(userId));
	updateUserList();



###Function to update the user list###
func updateUserList() -> void:
	usersList.clear();
	for i in Network.userList:
		usersList.add_item(Network.userList[i]);
