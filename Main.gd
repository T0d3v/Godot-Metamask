extends Control

# GET INTERFACES
var window = JavaScript.get_interface("window")
var ethereum = JavaScript.get_interface("ethereum")

# CALLBACKS
var connect_callback = JavaScript.create_callback(self, "connect_wallet")
var new_wallet_callback = JavaScript.create_callback(self, "on_wallet_changed")
var get_current_chain_callback = JavaScript.create_callback(self, "_get_current_Chain")
var new_chain_callback = JavaScript.create_callback(self, "on_chain_changed")
var get_balance_callback = JavaScript.create_callback(self, "get_balance")
var get_token_balance_callback = JavaScript.create_callback(self, "get_token_balance")

# VARS
var new_chain = ""
var current_chain_ID = ""
var new_chain_ID = ""
var chain_name = ""


var wallet_address = ""
var new_wallet_address = ""
var token_symbol = ""

func _on_ConnectWallet_pressed(): # Connect the wallet using Ethers.js (JS in Export -> HTML5 -> Head include)
	window.connectMM().then(connect_callback)
	
func connect_wallet(args): # JS Callback after the connect wallet button has been clicked
	var wallet_address = str(args[0])
	var new_wallet_address = wallet_address
#	print("1:",wallet_address)
#	print("2:",new_wallet_address)
	$Wallet.text = str("Welcome ",wallet_address)
	window.getChain().then(get_current_chain_callback) # Second callback to check the current chain selected on MM
	
func _get_current_Chain(id): # Get the current MM chain
	var current_chain_ID = str(id[0])
	new_chain = current_chain_ID
	print("current chain: ",current_chain_ID)
#	$Wallet.visible = false
	window.getBalance().then(get_balance_callback)
	
func get_new_chain(): # Get the new MM chain
	window.getChain().then(new_chain_callback)
	
func on_chain_changed(id): # Return the new chain ID
	new_chain_ID = str(id[0])
	
func get_new_wallet(): # Get the new MM Wallet
	window.connectMM().then(new_wallet_callback)
	
func on_wallet_changed(args): # Return the new wallet
#	print(args[0])
	var new_wallet_address = str(args[0])
	if str(new_wallet_address) != str(wallet_address): # Forces user to connect new wallet 
		$ConnectWallet.disabled = false
		wallet_address = new_wallet_address
		$Wallet.visible = false
		$Balance.visible = false
	
func _process(delta):
	if $ConnectWallet.disabled == true: # Go inside only if the wallet is connected
		new_wallet_address = get_new_wallet()
		new_chain = get_new_chain() # Listen to chain changed
		if new_chain_ID != current_chain_ID: # If new_chain and currentChain are different, it means the current chain as changed
			new_wallet_address = wallet_address 
			get_chain_name(new_chain_ID)
			print("chain changed for: ",chain_name,"\nID: ",new_chain_ID)
			$CurrentChain.text = str("Connected on ",chain_name)
			current_chain_ID = new_chain_ID
			window.getBalance().then(get_balance_callback)

		
func get_chain_name(id): # Compare the chain id with the chains_ID script to get the chain's name and token's symbol
	if chains_ID.id_to_name.has(id):
		chain_name = chains_ID.id_to_name[str(id)].capitalize()
		token_symbol = chains_ID.id_to_symbol[str(id)].to_upper()
	else:
		chain_name = "Unknown Chain"

func _on_GetBalance_pressed(): # Fire the JS func to get the main token balance of the current chain
	window.getBalance().then(get_balance_callback)
	
func get_balance(args): # Save the main token balance of the current chain
#	print(str(args[0]))
	$Balance.visible = true
	$Balance.text = str("You have: ", args[0]," ",token_symbol)
	$ConnectWallet.disabled = true
	$Wallet.visible = true

func _on_GetTokenBalance_pressed(): # Fire the callback in order to get the balance of the token whose contract is specified in the head include export
	window.getTokenBalance().then(get_token_balance_callback)

func get_token_balance(args): # Save the main token balance of the current chain
	print(str(args[0]))
#	$Balance.text = str("You have: ", args[0])
