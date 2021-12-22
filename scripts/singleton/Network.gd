extends Node

###Signal###
signal updateUserList;

###Variables###
var username : String;
var userList : Dictionary;
const PORT : int = 4180;
var upnp : UPNP = UPNP.new();

###Ready Function###
func _ready():
# warning-ignore:return_value_discarded
	upnp.discover(2000, 2, "InternetGatewayDevice");
	# warning-ignore:return_value_discarded
	upnp.add_port_mapping(PORT, PORT, "ChatRoom", "UDP");
	# warning-ignore:return_value_discarded
	upnp.add_port_mapping(PORT, PORT, "ChatRoom", "TCP");



###Function to create a server###
func createServer() -> void:
	var server : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new();
	# warning-ignore:return_value_discarded
	server.create_server(PORT, 32);
	get_tree().set_network_peer(server);
	enterChatRoom();

###Function to join a server###
func joinServer(ipAddress) -> void:
	var client : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new();
	# warning-ignore:return_value_discarded
	client.create_client(ipAddress, PORT);
	get_tree().set_network_peer(client);
	# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "connectionFailed");
	# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "connectionSucceeded");
	# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "serverDisconnected");

###Function when the connection succeeded###
func connectionSucceeded() -> void:
	var userData : Array = [str(get_tree().get_network_unique_id()), username];
	rpc_unreliable_id(1, "updateUser", userData);
	get_node("../Menu").connectionSuccess();

###Function when the connection has failed###
func connectionFailed() -> void:
	get_node("../Menu").connectionFailed();

###Function when the connection succeeded###
func serverDisconnected() -> void:
	resetNetworkPeer();
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/Main.tscn");
	OS.alert("Server Diconnected", "Status");

###Func to reset the network connection###
func resetNetworkPeer() -> void:
	if get_tree().has_network_peer():
		userList.clear();
		get_tree().disconnect("connection_failed", self, "connectionFailed");
		get_tree().disconnect("connected_to_server", self, "connectionSucceeded");
		get_tree().network_peer = null;

###Function to update user###
remote func updateUser(userData):
	userList[str(userData[0])] = userData[1];
	emit_signal("updateUserList");
	rpc_unreliable("clientUpdate", userList);

###Function to update the clients users list###
remote func clientUpdate(updatedUserList):
	userList = updatedUserList;
	emit_signal("updateUserList");

###Function to get into the chat room scene###
func enterChatRoom() -> void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/ChatRoom.tscn");



###Function to set the username###
func setUsername(newUsername):
	username = newUsername;
