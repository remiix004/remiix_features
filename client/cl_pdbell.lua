local cooldowns = {}


exports.ox_target:addBoxZone({
    coords = vec3(440.45, -980.46, 30.89), -- coords of the target
    size = vec3(2, 2, 2),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'pd_bell',
            event = 'pdzvonek:RingBell',
            icon = 'fas fa-bell',
            label = 'Přivolat policistu'
        }
    }
})


RegisterNetEvent('pdzvonek:RingBell', function()
    local src = source 

   
    if cooldowns[src] and (GetGameTimer() - cooldowns[src]) < 150000 then -- 150000 ms = 2,5 minutes (it has cooldown)
        TriggerEvent('wasabi_notify:notify', 'Zvonek', 'Musíš počkat předtím než znovu zazvoníš!', '7000', 'info', true, icon, id)
        return
    end


    cooldowns[src] = GetGameTimer()

    -- Notification part
    local data = exports['cd_dispatch']:GetPlayerInfo()
    TriggerServerEvent('cd_dispatch:AddNotification', {
        job_table = {'police', }, 
        coords = data.coords,
        title = 'Reception',
        message = 'Someone needs help on reception.', 
        flash = 0,
        unique_id = data.unique_id,
        sound = 1,
        blip = {
            sprite = 431, 
            scale = 0, 
            colour = 3,
            flashes = false, 
            text = 'Recepce',
            time = 5,
            radius = 0,
        }
    })
end)