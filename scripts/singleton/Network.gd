extends Node

###Signal###
signal updateUserList;

###Variables###
var username : String;
var userList : Dictionary;
const PORT : int = 4180;

###Function to create a server###
func createServer():
	print("Hosting");
	var server : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new();
	server.create_server(PORT, 32);
	get_tree().set_network_peer(server);
	enterChatRoom();

###Function to join a server###
func joinServer(ipAddress):
	var client : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new();
	client.create_client(ipAddress, PORT);
	get_tree().set_network_peer(client);
	get_tree().connect("connection_failed", self, "connectionFailed");
	get_tree().connect("connected_to_server", self, "connectionSucceeded");

###Function when the connection succeeded###
func connectionSucceeded():
	get_node("../Menu").connectionSuccess();

###Function when the connection has failed###
func connectionFailed():
	get_node("../Menu").connectionFailed();

###Func to reset the network connection###
func resetNetworkPeer():
	if get_tree().has_network_peer():
		get_tree().disconnect("connection_failed", self, "connectionFailed");
		get_tree().disconnect("connected_to_server", self, "connectionSucceeded");
		get_tree().network_peer = null;
		userList.clear();



###Function to get into the chat room scene###
func enterChatRoom():
	get_tree().change_scene("res://scenes/ChatRoom.tscn");



###Function to set the username###
func setUsername(newUsername):
	username = newUsername;
