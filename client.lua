disPlayerNames = 5 --etäisyys jolta näät IDt
keyToToggleIDs = 10 --näppäin josta IDt tulee näkyviin

playerDistances = {}
showIDsAboveHead = false

Citizen.CreateThread(function()
    while true do 
        if IsControlJustPressed(0, keyToToggleIDs) then
            showIDsAboveHead = not showIDsAboveHead
			print("changed")
            Wait(50)
        end
        Wait(0)
    end
end)

RegisterFontFile("comic")
fontId = RegisterFontId("Comic Sans MS")

RegisterNetEvent('setHeadLabelDistance')
AddEventHandler('setHeadLabelDistance', function(distance)
	disPlayerNames = distance
	TriggerServerEvent("onClientHeadLabelRangeChange", distance)
end)

Citizen.CreateThread(function()
    while true do
        for id = 0, 255 do
            if GetPlayerPed(id) ~= GetPlayerPed(-1) then
                x1, y1, z1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
                playerDistances[id] = distance
            end
        end
        Citizen.Wait(1000)
    end
end)




Citizen.CreateThread(function()
    while true do
        if showIDsAboveHead then
            for id = 0, 255 do 
                if NetworkIsPlayerActive(id) then
                    if GetPlayerPed(id) ~= GetPlayerPed(-1) then
                        if (playerDistances[id] < disPlayerNames) then
                            x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                            if NetworkIsPlayerTalking(id) then
                                DrawText3D(x2, y2, z2+1, " " .. GetPlayerServerId(id) .. " | " .. GetPlayerName(id)  .. "  ~n~~g~Puhuu... ", 255,255,255)
                            else
                                DrawText3D(x2, y2, z2+1, " " .. GetPlayerServerId(id) .. " | " .. GetPlayerName(id)  .. " " , 255,255,255)
                            end
                        end  
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)


function DrawText3D(x,y,z, text, r,g,b) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 0.50*scale)
       SetTextFont(comicSans and fontId or 4)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
		SetTextProportional(true)
		SetTextCentre(true)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
       DrawText(_x, _y - 0.025)
    end
end
