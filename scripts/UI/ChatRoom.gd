extends Control

###Variables###
onready var msgLog : RichTextLabel = get_node("MsgLog");
onready var msgEdit : TextEdit = get_node("MsgEdit");
onready var usersList : ItemList = get_node("UsersList");

###Ready function###
func _ready() -> void:
# warning-ignore:return_value_discarded
	Network.connect("updateUserList", self, "updateUserList");
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "networkPeerDisconnected");
	updateUserList();

###Process function###
# warning-ignore:unused_argument
func _process(delta) -> void:
	if Input.is_action_just_pressed("send"):
		sendMessage();


###When Logout is pressed###
func _on_LogoutButton_pressed() -> void:
	Network.resetNetworkPeer();
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/Main.tscn");



###When a user disconnect###
func networkPeerDisconnected(userId) -> void:
# warning-ignore:return_value_discarded
	Network.userList.erase(str(userId));
	updateUserList();



###Function to update the user list###
func updateUserList() -> void:
	usersList.clear();
	for i in Network.userList:
		usersList.add_item(Network.userList[i]);



###Send the message###
func sendMessage() -> void:
	if not msgEdit.text == "\n":
		var msg : String = createMsg(msgEdit.text);
		rpc_unreliable("receiveMsg", msg);
		msgLog.bbcode_text += msg;
		msgEdit.text = "";
	else:
		msgEdit.text = "";

###Function to receive a message###
remote func receiveMsg(msg) -> void:
	msgLog.bbcode_text += msg;

###Func to create the message###
func createMsg(msg) -> String:
	return "[b]" + Network.username + ": " + "[/b]" + msg;
