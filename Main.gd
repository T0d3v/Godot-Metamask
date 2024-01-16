extends Control


var _callback = JavaScript.create_callback(self, "_on_get")

func _on_ConnectWallet_pressed(): #Connect the wallet utsing Ethers.js (JS in Export -> HTML5 -> Head include)
	var window = JavaScript.get_interface("window")
	window.connectMM().then(_callback)
	
func _on_get(args): #JS Callback after the connect wallet has been clicked
	var wallet_address = str(args[0])
	print(wallet_address)
	$Label.text = str("Welcome ",wallet_address)
	$ConnectWallet.disabled = true
