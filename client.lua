ESX = nil
player_interval = false
color = false
transport = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
 
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for i=1, #Config.Blips do
			local dis = GetDistanceBetweenCoords(coords, Config.Blips[i].x, Config.Blips[i].y, Config.Blips[i].z, true)
			if dis <= 3.0 then
				DisplayHelpText(Config.Blips[i].text)
				if Config.Blips[i].value == 1 then
					DrawMarker(1, Config.Blips[i].x, Config.Blips[i].y, Config.Blips[i].z + 0.30, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.5, 1.5, 1.5, 70, 163, 76, 50, false, true, 2, nil, nil, false)
				else
					DrawMarker(1, Config.Blips[i].x, Config.Blips[i].y, Config.Blips[i].z + 0.30, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 4.0, 4.0, 4.0, 70, 163, 76, 50, false, true, 2, nil, nil, false)
				end
				if IsControlJustReleased(1, 38) then
					if Config.Blips[i].value == 1 then
						-- Kupno tira
						buy_truck()
					elseif Config.Blips[i].value == 2 then
						-- Przerabianie
						transform_oil()
					elseif Config.Blips[i].value == 3 then
						-- Sprzedaz
						sell_oil()
					end
				end
			elseif dis <= 10.0 then
				if Config.Blips[i].value == 3 then
					DrawMarker(1, Config.Blips[i].x, Config.Blips[i].y, Config.Blips[i].z + 0.30, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.5, 1.5, 1.5, 158, 52, 235, 50, false, true, 2, nil, nil, false)
				else
					DrawMarker(1, Config.Blips[i].x, Config.Blips[i].y, Config.Blips[i].z + 0.30, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 4.0, 4.0, 4.0, 158, 52, 235, 50, false, true, 2, nil, nil, false)
				end
			end
		end
	end
end)
function buy_truck()
	if IsPedInAnyVehicle(GetPlayerPed(-1),  true) then
		ESX.ShowNotification("Nie możesz być w pojeździe")
	else
		if player_interval == false then
			player_interval = true
			ESX.TriggerServerCallback("paynor:pokazkotkucomaszwsrodkutojestnajdluzsegownowtymskrypcieboniktminiezabroni", function(valid)
				if valid >= Config.price then
					TriggerServerEvent("pajnor:zajebalsiano", Config.price)
					ESX.Game.SpawnVehicle(Config.VehicleName, vector3(Config.SpawnCar.x, Config.SpawnCar.y, Config.SpawnCar.z), Config.SpawnCar.h, function(spawnedVehicle)						
						Citizen.Wait(100)
							ESX.Game.SpawnVehicle(Config.VehicleTrainer, vector3(Config.SpawnCarTrainer.x, Config.SpawnCarTrainer.y, Config.SpawnCarTrainer.z), Config.SpawnCarTrainer.h, function(trailer)
							AttachVehicleToTrailer(spawnedVehicle, Config.VehicleTrainer, 10.0)
							ESX.ShowAdvancedNotification("Szef", "Dostarcz paliwo do punktu.. ", text, "CHAR_SOLOMON", 8)
								Citizen.Wait(1050)
							ESX.ShowAdvancedNotification("Szef", "Cholerka gdzie to bylo?", text, "CHAR_SOLOMON", 18)
								Citizen.Wait(1050)
							ESX.ShowAdvancedNotification("Szef", "Jedz na gps i tam poszukaj", text, "CHAR_SOLOMON", 18)	
							end)
						local plate = 'POZDRAWIAMJEBACKURWYCOSIEPODPISUJAPSEUDOLKI'
						SetVehicleNumberPlateText(spawnedVehicle, plate)
						TaskWarpPedIntoVehicle(GetPlayerPed(-1), spawnedVehicle, -1)
					end)
					SetNewWaypoint(Config.Blips[2].x, Config.Blips[3].y)
					transport = true
				else
					ESX.ShowNotification("Brakuje ci ~r~"..Config.price - valid.. "$~w~ aby ")
				end
			end)
			Citizen.Wait(2000)
			player_interval = false
		else
			ESX.ShowNotification("Poczekaj chwile zanim znów okradniesz pańswtwo.")
		end
	end
end
function transform_oil()
	if IsPedInAnyVehicle(GetPlayerPed(-1),  true) then
		vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		plate_veh = GetVehicleNumberPlateText(vehicle)
		plate_veh = tostring(plate_veh)
		if plate_veh == "POZDRAWIAMJEBACKURWYCOSIEPODPISUJAPSEUDOLKI" then
			if transport == true then
				local coords = GetEntityCoords(GetPlayerPed(-1))
				FreezeEntityPosition(vehicle, true)
				procent = 0
				while procent <= 1000 do
					ESX.Game.Utils.DrawText3D(coords, "~y~Przygotowywanie materiałów ~g~" .. tonumber(procent * 0.1) ..'%', 2.0)
					Wait(10)
					procent = procent + 1
				end
				procent = 0
				while procent <= 1000 do
					ESX.Game.Utils.DrawText3D(coords, "~r~Odbarwianie ~g~" .. tonumber(procent * 0.1) ..'%', 2.0)
					Wait(10)
					procent = procent + 1
				end
				ESX.ShowNotification("Ropa została odbarwiona jedz do punktu sprzedaży")
					color = true
					transport = false
					SetNewWaypoint(Config.Blips[3].x, Config.Blips[3].y)
				FreezeEntityPosition(vehicle, false)
			else
				ESX.ShowNotification("Nie masz ze sobą nic więcej do odbarwienia")
			end
		else
			ESX.ShowNotification("To nie jest odpowiedni pojazd")
		end
	else
		ESX.ShowNotification("Musisz być w pojeździe")
	end
end
function sell_oil()
	if IsPedInAnyVehicle(GetPlayerPed(-1),  true) then
		vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		plate_veh = GetVehicleNumberPlateText(vehicle)
		plate_veh = tostring(plate_veh)
		if plate_veh == "POZDRAWIAMJEBACKURWYCOSIEPODPISUJAPSEUDOLKI" then
			if color == true then
				value = math.random(Config.Min, Config.Max)
				TriggerServerEvent("pajnor:dawajsiano", value)
				ESX.ShowNotification("Sprzedałeś olej za "..value.."$")
				_check,trailer = GetVehicleTrailerVehicle(vehicle)
				DetachVehicleFromTrailer(vehicle)
				Citizen.Wait(150)
				DeleteEntity(trailer)
				color = false
			else
				ESX.ShowNotification("Musisz odbarwić ten olej")
			end
		else
			ESX.ShowNotification("To nie jest odpowiedni pojazd")
		end
	else
		ESX.ShowNotification("Musisz być w pojeździe")
	end
end
