extends Control

###Variables###
var regex : RegEx = RegEx.new();
var emptyIpError : String = "No IP enterred";
var invalidIpError : String = "Invalid IP address"

###Ready Function###
func _ready():
# warning-ignore:return_value_discarded
	regex.compile("\\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\b");
	#The RegEx is: \b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b



###When host button is pressed###
func _on_Host_pressed():
	pass # Replace with function body.

###When Join button is pressed###
func _on_Join_pressed():
	get_node("MainMenu").visible = false;
	get_node("JoinMenu").visible = true;

###When Quit button is pressed###
func _on_Quit_pressed():
	get_tree().quit();

###When back is pressed###
func _on_Back_pressed():
	get_node("JoinMenu").visible = false;
	get_node("MainMenu").visible = true;



###When Join Chat is pressed###
func _on_JoinChat_pressed():
	get_node("JoinMenu/Error").visible = false;
	get_node("JoinMenu/Error/ErrorLabel").text = "";

	if get_node("JoinMenu/IpAddress").text.empty() == false:
		var result = regex.search(get_node("JoinMenu/IpAddress").text);
		#If the address is valid
		if result:
			get_node("JoinMenu").visible = false;
			get_node("Connecting").visible = true;
		#If the address is not valid
		else:
			get_node("JoinMenu/Error").visible = true;
			get_node("JoinMenu/Error/ErrorLabel").text = invalidIpError;
	#If the line is empty
	elif get_node("JoinMenu/IpAddress").text.empty() == true:
		get_node("JoinMenu/Error").visible = true;
		get_node("JoinMenu/Error/ErrorLabel").text = emptyIpError;
