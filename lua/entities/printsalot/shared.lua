//-----------------------------------------------------------------------------------------------
//
//shared file for tnl printsalot
//
//@author Deven Ronquillo
//@version 10/9/17
//-----------------------------------------------------------------------------------------------


--[[--------------------------------------------------------
--                   Plant Parameters                     --
----------------------------------------------------------]]
ENT.Params = {
    GrowthRate = .4, -- factor for how quickly the plant grows (default about 7 minutes from seedling to harvest) and heals
    Hardiness = 1.2, -- factor for how damage-resistant the plant is (default roughly 5 pistol shots)
    SeedYield = 1, -- factor for how many seeds ON AVERAGE the plant yields per harvest (default about 1.25 seeds per harvest)
    CropYield = 1, -- factor for how many units of marijuana ON AVERAGE the plant yields per harvest (default about 3 units per harvest)
    WaterNeed = .6, -- factor for how much water the plant needs (default 100 water units every 3 minutes)
    SoilLongevity = 1, -- factor for ON AVERAGE how long the soil in a pot lasts (default soil lasts for about 5 harvests)
    LampDistance = 1 -- factor for the max distance a plant can grow from a sun map, default is about 2 meters
}

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Author = "Luna <3"

ENT.Category = "PrintsAlot"
ENT.PrintName = "PrintsAlot"
ENT.Instructions = "Why not just print more?"


function ENT:SetupDataTables()
    
    self:NetworkVar("Float",0,"CurrentHealth")
    self:NetworkVar("Float",1,"TotalMoney")
    self:NetworkVar("Float",2,"CurrentMoney")
    self:NetworkVar("Float",3,"UpTime")

    self:NetworkVar("String", 0,"Status")

    self:NetworkVar("Int", 0, "PowerDeliveryUpgrade")
    self:NetworkVar("Int", 1, "CoolingSystemUpgrade")
    self:NetworkVar("Int", 2, "EficiencyUpgrade")
    self:NetworkVar("Int", 3, "OverdriveUpgrade")
end
