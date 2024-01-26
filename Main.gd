extends Control


var window = JavaScript.get_interface("window")
var ethereum = JavaScript.get_interface("ethereum")

var new_chain = ""
var current_chain_ID = ""
var new_chain_ID = ""
var wallet_address = ""
var chain_name = ""

var connect_callback = JavaScript.create_callback(self, "_on_get")
var get_current_chain_callback = JavaScript.create_callback(self, "_get_current_Chain")
var new_chain_callback = JavaScript.create_callback(self, "on_chain_changed")

func _on_ConnectWallet_pressed(): # Connect the wallet using Ethers.js (JS in Export -> HTML5 -> Head include)
	window.connectMM().then(connect_callback)
	
func _on_get(args): # JS Callback after the connect wallet button has been clicked
	var wallet_address = str(args[0])
	print(wallet_address)
	$Label.text = str("Welcome ",wallet_address)
	$ConnectWallet.disabled = true
	window.getChain().then(get_current_chain_callback) # Second callback to check the current chain selected on MM
	
func _get_current_Chain(id): # Get the current MM chain
	var current_chain_ID = str(id[0])
	new_chain = current_chain_ID
	print("current chain: ",current_chain_ID)
	
func get_new_chain(): # Get the new chain
	window.getChain().then(new_chain_callback)
	
func on_chain_changed(id): # Return the new chain ID
	new_chain_ID = str(id[0])
	
func _process(delta):
	if $ConnectWallet.disabled == true: # Go inside only if the wallet is connected
		new_chain = get_new_chain() # Listen to chain changed
		if new_chain_ID != current_chain_ID: # If new_chain and currentChain are different, it means the current chain as changed
			get_chain_name(new_chain_ID)
			print("chain changed for: ",chain_name,"\nID: ",new_chain_ID)
			current_chain_ID = new_chain_ID
			
func get_chain_name(id):
	if chains_ID.list.has(id):
		chain_name = chains_ID.list[str(id)].capitalize()
		
	else:
		chain_name = "Unknown Chain"


