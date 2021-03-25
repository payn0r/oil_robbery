ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("paynor:pokazkotkucomaszwsrodkutojestnajdluzsegownowtymskrypcieboniktminiezabroni", function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local money = xPlayer.getMoney(_source)
	cb(money)
end)
RegisterServerEvent('pajnor:zajebalsiano') 
AddEventHandler('pajnor:zajebalsiano', function(value)
	_source = source
	xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeMoney(value)
end)
RegisterServerEvent('pajnor:dawajsiano') 
AddEventHandler('pajnor:dawajsiano', function(value)
	_source = source
	xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addAccountMoney('black_money', value)
end)

print("##==================================##")
print("LADOWANIE (^.^)")
print("zaladowano pomyslnie")
print("##==================================##")