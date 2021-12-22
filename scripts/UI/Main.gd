extends Control

###Variables###
var regex : RegEx = RegEx.new();
var emptyIpError : String = "No IP enterred";
var invalidIpError : String = "Invalid IP address";

###Ready Function###
func _ready() -> void:
# warning-ignore:return_value_discarded
	regex.compile("\\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\b");
	#The RegEx is: \b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b
	OS.set_window_fullscreen(false);


###When host button is pressed###
func _on_Host_pressed() -> void:
	Network.createServer();
	Network.userList[str(get_tree().get_network_unique_id())] = Network.username;

###When Join button is pressed###
func _on_Join_pressed() -> void:
	get_node("MainMenu").visible = false;
	get_node("JoinMenu").visible = true;

###When Quit button is pressed###
func _on_Quit_pressed() -> void:
	get_tree().quit();

###When back is pressed###
func _on_Back_pressed() -> void:
	get_node("JoinMenu").visible = false;
	get_node("MainMenu").visible = true;



###When Join Chat is pressed###
func _on_JoinChat_pressed() -> void:
	get_node("JoinMenu/Error").visible = false;
	get_node("JoinMenu/Error/ErrorLabel").text = "";

	if get_node("JoinMenu/IpAddress").text.empty() == false:
		var result = regex.search(get_node("JoinMenu/IpAddress").text);
		#If the address is valid
		if result:
			get_node("JoinMenu").visible = false;
			get_node("Connecting").visible = true;
			Network.joinServer(get_node("JoinMenu/IpAddress").text);
		#If the address is not valid
		else:
			get_node("JoinMenu/Error").visible = true;
			get_node("JoinMenu/Error/ErrorLabel").text = invalidIpError;
	#If the line is empty
	elif get_node("JoinMenu/IpAddress").text.empty() == true:
		get_node("JoinMenu/Error").visible = true;
		get_node("JoinMenu/Error/ErrorLabel").text = emptyIpError;



###Function called when the connection failed###
func connectionFailed() -> void:
	get_node("Connecting/LoadingIcon").visible = false;
	get_node("Connecting/ConnectingLabel").visible = false;
	get_node("Connecting/FailLabel").visible = true;
	yield(get_tree().create_timer(3), "timeout");
	Network.resetNetworkPeer();
	get_node("Connecting/FailLabel").visible = false;
	get_node("Connecting/LoadingIcon").visible = true;
	get_node("Connecting/ConnectingLabel").visible = true;
	get_node("Connecting").visible = false;
	get_node("JoinMenu").visible = true;

###Function called when the connection failed###
func connectionSuccess() -> void:
	get_node("Connecting/LoadingIcon").visible = false;
	get_node("Connecting/ConnectingLabel").visible = false;
	get_node("Connecting/ConnectedLabel").visible = true;
	yield(get_tree().create_timer(3), "timeout");
	Network.enterChatRoom();


###Function when the tag is updated###
func _on_Tag_text_changed(newUsername) -> void:
	if get_node("MainMenu/Tag").text.empty() == false:
		get_node("MainMenu/Host").disabled = false;
		get_node("MainMenu/Join").disabled = false;
		Network.setUsername(newUsername);
	if get_node("MainMenu/Tag").text.empty() == true:
		get_node("MainMenu/Host").disabled = true;
		get_node("MainMenu/Join").disabled = true;
