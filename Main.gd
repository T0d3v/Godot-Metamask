extends Control


var window = JavaScript.get_interface("window")
var ethereum = JavaScript.get_interface("ethereum")
#var provider = JavaScript.get_interface("provider")
#var array = JavaScript.get_interface("array")

var new_chain = ""
var current_chain_ID = ""
var new_chain_ID = ""
var wallet_address = ""
var chain_name = ""
var token_symbol = ""

var connect_callback = JavaScript.create_callback(self, "connect_wallet")
var get_current_chain_callback = JavaScript.create_callback(self, "_get_current_Chain")
var new_chain_callback = JavaScript.create_callback(self, "on_chain_changed")
var get_balance_callback = JavaScript.create_callback(self, "get_balance")
var get_token_balance_callback = JavaScript.create_callback(self, "get_token_balance")

func _on_ConnectWallet_pressed(): # Connect the wallet using Ethers.js (JS in Export -> HTML5 -> Head include)
	window.connectMM().then(connect_callback)
	
func connect_wallet(args): # JS Callback after the connect wallet button has been clicked
	var wallet_address = str(args[0])
	print(wallet_address)
	$Label.text = str("Welcome ",wallet_address)
	$ConnectWallet.disabled = true
	window.getChain().then(get_current_chain_callback) # Second callback to check the current chain selected on MM
	
func _get_current_Chain(id): # Get the current MM chain
	var current_chain_ID = str(id[0])
	new_chain = current_chain_ID
	print("current chain: ",current_chain_ID)
	$Label.visible = false
	window.getBalance().then(get_balance_callback)
	
func get_new_chain(): # Get the new MM chain
	window.getChain().then(new_chain_callback)
	
func on_chain_changed(id): # Return the new chain ID
	new_chain_ID = str(id[0])
	
func _process(delta):
	if $ConnectWallet.disabled == true: # Go inside only if the wallet is connected
		new_chain = get_new_chain() # Listen to chain changed
		if new_chain_ID != current_chain_ID: # If new_chain and currentChain are different, it means the current chain as changed
			get_chain_name(new_chain_ID)
			print("chain changed for: ",chain_name,"\nID: ",new_chain_ID)
			$CurrentChain.text = str("Connected on ",chain_name)
			current_chain_ID = new_chain_ID
			window.getBalance().then(get_balance_callback)
			
func get_chain_name(id):
	if chains_ID.id_to_name.has(id):
		chain_name = chains_ID.id_to_name[str(id)].capitalize()
		token_symbol = chains_ID.id_to_symbol[str(id)].to_upper()
	else:
		chain_name = "Unknown Chain"

func _on_GetBalance_pressed(): # Fire the JS func to get the main token balance of the current chain
	window.getBalance().then(get_balance_callback)
	
func get_balance(args): # Save the main token balance of the current chain
	print(str(args[0]))
	$Balance.visible = true
	$Balance.text = str("You have: ", args[0]," ",token_symbol)

func _on_GetTokenBalance_pressed():
	window.getTokenBalance().then(get_token_balance_callback)

func get_token_balance(args): # Save the main token balance of the current chain
	print(str(args[0]))
#	$Balance.text = str("You have: ", args[0])
