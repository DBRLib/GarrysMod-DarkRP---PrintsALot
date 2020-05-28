//-----------------------------------------------------------------------------------------------
//
//shared file for tnl printsalot
//
//@author Deven Ronquillo
//@version 7/20/17
//-----------------------------------------------------------------------------------------------

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("UpdatePrinterStatus")
util.AddNetworkString("UpgradePrinter")

ENT.CurrentHealth = 500

ENT.CurrentMoney = 0
ENT.TotalMoney = 0

ENT.InitialSpawnTime = 0
ENT.LastUpTime = 0
ENT.UpTime = 0 //in seconds
ENT.LastDownTime = 0
ENT.DownTime = 0

ENT.UpgradeTime = 1
ENT.PowerMultiplier = .25
ENT.CoolingDivisor = 1
ENT.EficiencyAddative = 0
ENT.OverdriveMultiplier = 1


function ENT:Initialize()

    self:SetModel("models/props_c17/consolebox01a.mdl")
    self:SetModelScale( self:GetModelScale()*.9 , 0)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS) 

    local Phys = self:GetPhysicsObject()
    Phys:Wake()
    Phys:SetMaterial("Metal_Box")
    
    self:SetUseType(SIMPLE_USE)

    self:SetCurrentHealth(self.CurrentHealth)
    self:SetTotalMoney(0.0)
    self:SetCurrentMoney(0.0)
    self:SetUpTime(0.0)

    self:SetStatus("Online")

    self:SetPowerDeliveryUpgrade(0)
    self:SetCoolingSystemUpgrade(0)
    self:SetEficiencyUpgrade(0)
    self:SetOverdriveUpgrade(0)

    self.InitialSpawnTime = os.time()
end

function ENT:OnTakeDamage(dmg)

    self:TakePhysicsDamage(dmg)

    if dmg:IsDamageType(DMG_BURN) or dmg:IsDamageType(DMG_PLASMA) then

        self:Ignite(15)
    end

    self.CurrentHealth = self.CurrentHealth - dmg:GetDamage()
    self:SetCurrentHealth(self.CurrentHealth)

    if self.CurrentHealth <= 0 then

        local data = EffectData()

        data:SetOrigin(self:GetPos()+self:GetUp()*10)
        data:SetScale(.8)

        util.Effect("cball_explode", data, true, true)
        util.Effect("Explosion", data, true, true)

        self:Remove()
    end
end

function ENT:Think()

    if(self:GetStatus() == "Online" && self.CurrentMoney < 25000) then

        self.UpTime = os.time() - self.InitialSpawnTime - self.DownTime

        self:IncMoney()
        self:UpdateListeners()
    elseif(self:GetStatus() == "Online" && self.CurrentMoney >= 25000) then
        
        self:SetStatus("Offline")
    end


end

function ENT:Use(activator)

    if(activator:IsPlayer()) then

        activator:addMoney( self.CurrentMoney )

        DarkRP.notify( activator, 0, 3, "You retrieved $"..math.Round(self.CurrentMoney).." Bits!")

        self.CurrentMoney = 0
        self:SetCurrentMoney(0.0)
    end
end

function ENT:OnRemove()
    --
end

function ENT:Upgrade(activator, upgrade)

    if(activator:getDarkRPVar( "money" ) > 1000 and activator:IsPlayer()) then

        local SelfPos,Up,Right,Forward,Ang = self:GetPos(),self:GetUp(),self:GetRight(),self:GetForward(),self:GetAngles()

        if(upgrade == "Power" and self:GetPowerDeliveryUpgrade() < 3 and self.UpTime >= self.UpgradeTime) then

            activator:addMoney(-500)

            self.PowerMultiplier = self.PowerMultiplier + .15

            self:SetPowerDeliveryUpgrade(self:GetPowerDeliveryUpgrade() + 1)
            self.UpgradeTime = self.UpgradeTime + (300 / self.CoolingDivisor)

            DarkRP.notify( activator, 0, 3, "You bought the level "..self:GetPowerDeliveryUpgrade().." power upgrade!")    
        
        elseif(upgrade == "Cooling" and self:GetCoolingSystemUpgrade() < 3 and self.UpTime >= self.UpgradeTime) then

            activator:addMoney(-150)

            self.CoolingDivisor = self.CoolingDivisor + .1

            self:SetCoolingSystemUpgrade(self:GetCoolingSystemUpgrade() + 1)
            self.UpgradeTime = self.UpgradeTime + (300 / self.CoolingDivisor) 

            DarkRP.notify( activator, 0, 3, "You bought the level "..self:GetCoolingSystemUpgrade().." Cooling System upgrade!")

        elseif(upgrade == "Eficiency" and self:GetEficiencyUpgrade() < 3 and self.UpTime >= self.UpgradeTime) then

            activator:addMoney(-250)

            self.EficiencyAddative = self.EficiencyAddative + 0.1

            self:SetEficiencyUpgrade(self:GetEficiencyUpgrade() + 1)
            self.UpgradeTime = self.UpgradeTime + (300 / self.CoolingDivisor)

            DarkRP.notify( activator, 0, 3, "You bought the level "..self:GetEficiencyUpgrade().." Eficiency upgrade!")
       
        elseif(upgrade == "Overdrive" and self:GetOverdriveUpgrade() < 3 and self.UpTime >= self.UpgradeTime) then

            activator:addMoney(-1000)

            self.OverdriveMultiplier = self.OverdriveMultiplier + 0.05

            self:SetOverdriveUpgrade(self:GetOverdriveUpgrade() + 1)
            self.UpgradeTime = self.UpgradeTime + (300 / self.CoolingDivisor)

            DarkRP.notify( activator, 0, 3, "You bought the Level "..self:GetOverdriveUpgrade().." Overdrive upgrade!")
        else

            DarkRP.notify( activator, 1, 3, "You are not adept enough to learn this.") 
        end
    else

        DarkRP.notify( activator, 1, 3, "You do not have enough to purchase this.")
    end


end
net.Receive("UpgradePrinter",function()

    local printer = net.ReadEntity()
    local upgrade = net.ReadString()

    local activator = printer:CPPIGetOwner()

    printer:Upgrade(activator, upgrade)
end)

function ENT:UpdateStatus()

    if(self:GetStatus() == "Offline") then

        self:SetStatus("Online")

        self.DownTime = self.DownTime + (os.time() - self.LastDownTime)
    else

        self:SetStatus("Offline")

        self.LastDownTime = os.time()
    end

    --
end
net.Receive("UpdatePrinterStatus",function()

    local printer = net.ReadEntity()

    printer:UpdateStatus()
end)

function ENT:IncMoney()

    if self.LastUpTime < self.UpTime then

        self.CurrentMoney = self.CurrentMoney + (((self.UpTime - self.LastUpTime) + self.EficiencyAddative) * self.PowerMultiplier) * self.OverdriveMultiplier

        self.TotalMoney = self.TotalMoney + (((self.UpTime - self.LastUpTime) + self.EficiencyAddative) * self.PowerMultiplier) * self.OverdriveMultiplier

        self.LastUpTime = self.UpTime
    end
end

function ENT:UpdateListeners()

    self:SetCurrentMoney(self.CurrentMoney)

    self:SetTotalMoney(self.TotalMoney)
    self:SetUpTime(self.UpTime)
end
