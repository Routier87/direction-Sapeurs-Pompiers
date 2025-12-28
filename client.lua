local bossChestPos = vector3(404.606079, 183.272461, 108.050529)
local interactionDistance = 2.0

-- Raycast depuis la caméra
local function RayCastFromCamera(dist)
    local camRot = GetGameplayCamRot(2)
    local camCoord = GetGameplayCamCoord()
    local direction = vector3(
        -math.sin(math.rad(camRot.z)) * math.abs(math.cos(math.rad(camRot.x))),
         math.cos(math.rad(camRot.z)) * math.abs(math.cos(math.rad(camRot.x))),
         math.sin(math.rad(camRot.x))
    )
    local destination = camCoord + direction * dist
    local ray = StartShapeTestRay(camCoord, destination, -1, PlayerPedId(), 0)
    local _, hit, endPos = GetShapeTestResult(ray)
    return hit, endPos
end

CreateThread(function()
    while true do
        Wait(0)

        if PlayerData.job
        and PlayerData.job.name == 'pompier'
        and PlayerData.job.grade >= 10
        and IsControlPressed(0, 19) then -- ALT

            local hit, endPos = RayCastFromCamera(5.0)
            local dist = #(endPos - bossChestPos)

            if hit and dist < 0.3 then
                -- 🔵 PETIT POINT BLEU SUR LE MUR
                DrawSprite(
                    "shared",
                    "emptydot_32",
                    0.5, 0.5,
                    0.015, 0.015,
                    0.0,
                    0, 150, 255, 200
                )

                -- CLIC GAUCHE
                if IsDisabledControlJustReleased(0, 24) then
                    -- Animation (optionnelle)
                    RequestAnimDict("mini@repair")
                    while not HasAnimDictLoaded("mini@repair") do Wait(10) end
                    TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped", 8.0, -8.0, 2000, 0, 0, false, false, false)

                    Wait(1500)
                    TriggerServerEvent('pompier:openBossChest')
                    Wait(1000)
                end
            end
        end
    end
end)
