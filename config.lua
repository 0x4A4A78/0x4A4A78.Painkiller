Config = {}

Config.EnableOutline = true
Config.OutlineTime = 3000 -- หน่วยเป็นมิลลิวินาที

-- เขตที่สามารถใช้ไอเทมประเภท wz ได้
Config.UseZone = {
    { x = 3862.16, y = -1656.37, z = 627.75, r = 150.52 },
    { x = 3871.41, y = -1649.20, z = 627.51 },
    { x = -2877.41, y = -1736.20, z = 627.51 },
    { x = 2242.41, y = -6722.20, z = 627.51 },
    { x = 3461.41, y = 6720.20, z = 627.51 }
}
-- ไอเทมที่ใช้ได้ทั้งหมด (ไม่จำกัดอาชีพ)
Config.GeneralItems = {
    ['painkiller'] = {
        healAmount = 40,
        cooldown = 3
    },
    ['aed'] = {
        type = 'revive',
        cooldown = 0
    },
    ['painkiller_wz'] = {
        healAmount = 40,
        cooldown = 6,
        zoneOnly = true
    },
    ['aed_wz'] = {
        type = 'revive',
        cooldown = 0,
        zoneOnly = true
    }
}


Config.JobRestrictedItems = {
    ['aed_p'] = {
        allowedJobs = { 'police', 'ambulance' },
        type = 'revive',
        cooldown = 20
    },
    ['painkiller_p'] = {
        allowedJobs = { 'police', 'ambulance' },
        healAmount = 40,
        cooldown = 1
    }
}
