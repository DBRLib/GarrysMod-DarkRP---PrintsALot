//-----------------------------------------------------------------------------------------------
//
//client init file for tnl printsalot
//
//@author Deven Ronquillo
//@version 9/4/18
//-----------------------------------------------------------------------------------------------

include("shared.lua")

surface.CreateFont( "PrinterFont", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 200,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "SmolPrinterFont", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 100,
	weight = 550,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

ENT.TimeSinceLastKeyPress = 0

function ENT:Initialize()

	self.TimeSinceLastKeyPress = os.time()
end

function ENT:Draw()

	if LocalPlayer():GetPos():Distance(self:GetPos()) <= 1000 then

    	self:DrawModel()
    end

    if LocalPlayer():GetPos():Distance(self:GetPos()) <= 500 then
  
    	local SelfPos,Up,Right,Forward,Ang = self:GetPos(),self:GetUp(),self:GetRight(),self:GetForward(),self:GetAngles()

    	Ang:RotateAroundAxis(Ang:Right(), -90)
    	Ang:RotateAroundAxis(Ang:Up(), 90)


    	cam.Start3D2D(SelfPos + Forward*15 + Right*12.75 + Up*9, Ang, .01)//Genereates the front 3d2d

    		draw.RoundedBox(0, 0, 0, 2000, 900,string.ToColor(GetConVar("cl_colorZone3"):GetString()))
    		draw.RoundedBox(0, 30, 120, 1890, 690,string.ToColor(GetConVar("cl_colorZone1"):GetString()))

    		draw.SimpleText("PrintsAlot Mrk I","SmolPrinterFont", 975, 60,Color(255, 255, 255), 1, 1)
    		draw.SimpleText("$"..math.Round(self:GetCurrentMoney(), 2),"SmolPrinterFont", 975, 300,Color(255, 255, 255), 1, 1)
    		draw.SimpleText("Health: "..self:GetCurrentHealth(),"SmolPrinterFont", 975, 500,Color(255, 255, 255), 1, 1)
    	cam.End3D2D()

    	Ang:RotateAroundAxis(Ang:Forward(), -90)
    	Ang:RotateAroundAxis(Ang:Right(), 0)

    
    	local origin = SelfPos - Forward*14 + Right*13 + Up*10//the 3d2d pos
		local ang = Ang//the 3d2d angle

		local n = Vector(0, 0, 10)//calculating the normal of the plane
		n:Rotate(ang)

		local eye0 = LocalPlayer():GetShootPos()//self explanitory
		local eye = LocalPlayer():GetAimVector()

		local d = (origin - eye0):Dot(n) / eye:Dot(n)//calculate on the line intersects the plane
		local intersect = eye0 + (eye*d)//calculate where the intesection is in 3d space

		local lcl = WorldToLocal(intersect, Angle(), origin, ang-Angle(0, 0, 180))//convert the world vector to local

		//render.DrawLine(intersect, intersect + n, Color(117, 73, 50, 255), true)//the is the line showing the intersect point
	

   		cam.Start3D2D(SelfPos - Forward*14 + Right*13 + Up*10, ang, .01)//generates the rear 3d2d

    		draw.RoundedBox(0, 0, 0, 2620, 2620,string.ToColor(GetConVar("cl_colorZone3"):GetString()))
    		draw.RoundedBox(0, 30, 490, 2560, 2100,string.ToColor(GetConVar("cl_colorZone1"):GetString()))

    		draw.RoundedBox(0, 1100, 520, 1460, 390,string.ToColor(GetConVar("cl_colorZone1"):GetString()))
    		draw.RoundedBox(0, 1100, 940, 1460, 390,string.ToColor(GetConVar("cl_colorZone1"):GetString()))
    		draw.RoundedBox(0, 1100, 1370, 1460, 390,string.ToColor(GetConVar("cl_colorZone1"):GetString()))
    		draw.RoundedBox(0, 1100, 1800, 1460, 390,string.ToColor(GetConVar("cl_colorZone1"):GetString()))
    		draw.RoundedBox(0, 2170, 30, 420, 420,string.ToColor(GetConVar("cl_colorZone1"):GetString()))
    	
    		draw.SimpleText("Status: "..self:GetStatus(),"SmolPrinterFont", 30, 60,Color(255, 255, 255), 0, 1)
    		draw.SimpleText("Total: $"..math.Round(self:GetTotalMoney(), 2),"SmolPrinterFont", 30, 230,Color(255, 255, 255), 0, 1)
    		draw.SimpleText("Uptime: "..ConvertToHMS(self:GetUpTime()),"SmolPrinterFont", 30, 400,Color(255, 255, 255), 0, 1)
    		draw.SimpleText("On/Off","SmolPrinterFont", 2380, 240,Color(255, 255, 255), 1, 1)

			draw.SimpleText("Power Delivery","SmolPrinterFont", 500, 715,Color(255, 255, 255), 1, 1)
    		draw.SimpleText("Cooling System","SmolPrinterFont", 500, 1140,Color(255, 255, 255), 1, 1)
    		draw.SimpleText("Eficiency","SmolPrinterFont", 500, 1570,Color(255, 255, 255), 1, 1)
    		draw.SimpleText("Overdrive","SmolPrinterFont", 500, 1995,Color(255, 255, 255), 1, 1)

    		local y = 1130

    		for i = 1, self:GetPowerDeliveryUpgrade() do

    			draw.RoundedBox(0, y, 550, 445, 330, Color(0, 255, 0, 180))
   				y = y + 475
			end

			for i = 1, 3 - self:GetPowerDeliveryUpgrade() do

    			draw.RoundedBox(0, y, 550, 445, 330,string.ToColor(GetConVar("cl_colorZone1"):GetString()))
   				y = y + 475
			end

			y = 1130

    		for i = 1, self:GetCoolingSystemUpgrade() do

    			draw.RoundedBox(0, y, 970, 445, 330, Color(0, 255, 0, 180))
   				y = y + 475
			end

			for i = 1, 3 - self:GetCoolingSystemUpgrade() do

    			draw.RoundedBox(0, y, 970, 445, 330,string.ToColor(GetConVar("cl_colorZone1"):GetString()))
   				y = y + 475
			end

			y = 1130

    		for i = 1, self:GetEficiencyUpgrade() do

    			draw.RoundedBox(0, y, 1400, 445, 330, Color(0, 255, 0, 180))
   				y = y + 475
			end

			for i = 1, 3 - self:GetEficiencyUpgrade() do

    			draw.RoundedBox(0, y, 1400, 445, 330,string.ToColor(GetConVar("cl_colorZone1"):GetString()))
   				y = y + 475
			end

			y = 1130

    		for i = 1, self:GetOverdriveUpgrade() do

    			draw.RoundedBox(0, y, 1830, 445, 330, Color(0, 255, 0, 180))
   				y = y + 475
			end

			for i = 1, 3 - self:GetOverdriveUpgrade() do

    			draw.RoundedBox(0, y, 1830, 445, 330,string.ToColor(GetConVar("cl_colorZone1"):GetString()))
   				y = y + 475
			end

    		local x, y, w, h = 22, .6, 3.6, 3.6//box 2 pos and size mul by 3d2d delta
			local color = string.ToColor(GetConVar("cl_colorZone1"):GetString())//box color

			if (x < lcl.x) and (lcl.x < x+w) and (y < lcl.y) and (lcl.y < y+h) then

				color = string.ToColor(GetConVar("cl_colorZone3"):GetString())



				if (LocalPlayer():KeyDown(IN_USE) and ((os.time() - self.TimeSinceLastKeyPress) >= 1)) then

					net.Start("UpdatePrinterStatus")

						net.WriteEntity(self)
					net.SendToServer()

					self.TimeSinceLastKeyPress = os.time()
				end
			end// test if in range

			draw.RoundedBox(0, x*100, y*100, w*100, h*100, color)//makes box
		
			local x, y, w, h = .6, 5.2, 10, 3.9
			local color = string.ToColor(GetConVar("cl_colorZone1"):GetString())

			if (x < lcl.x) and (lcl.x < x+w) and (y < lcl.y) and (lcl.y < y+h) then 

				color = string.ToColor(GetConVar("cl_colorZone3"):GetString()) 

				if (LocalPlayer():KeyDown(IN_USE) and ((os.time() - self.TimeSinceLastKeyPress) >= 1)) then

					net.Start("UpgradePrinter")

						net.WriteEntity(self)
						net.WriteString("Power")
					net.SendToServer()

					self.TimeSinceLastKeyPress = os.time()
				end
			end

			draw.RoundedBox(0, x*100, y*100, w*100, h*100, color)

			local x, y, w, h = .6, 9.45, 10, 3.9
			local color = string.ToColor(GetConVar("cl_colorZone1"):GetString())

			if (x < lcl.x) and (lcl.x < x+w) and (y < lcl.y) and (lcl.y < y+h) then 

				color = string.ToColor(GetConVar("cl_colorZone3"):GetString())

				if (LocalPlayer():KeyDown(IN_USE) and ((os.time() - self.TimeSinceLastKeyPress) >= 1)) then

					net.Start("UpgradePrinter")

						net.WriteEntity(self)
						net.WriteString("Cooling")
					net.SendToServer()

					self.TimeSinceLastKeyPress = os.time()
				end 
			end

			draw.RoundedBox(0, x*100, y*100, w*100, h*100, color)

			local x, y, w, h = .6, 13.75, 10, 3.9
			local color = string.ToColor(GetConVar("cl_colorZone1"):GetString())

			if (x < lcl.x) and (lcl.x < x+w) and (y < lcl.y) and (lcl.y < y+h) then 

				color = string.ToColor(GetConVar("cl_colorZone3"):GetString()) 

				if (LocalPlayer():KeyDown(IN_USE) and ((os.time() - self.TimeSinceLastKeyPress) >= 1)) then

					net.Start("UpgradePrinter")

						net.WriteEntity(self)
						net.WriteString("Eficiency")
					net.SendToServer()

					self.TimeSinceLastKeyPress = os.time()
				end
			end

			draw.RoundedBox(0, x*100, y*100, w*100, h*100, color)

			local x, y, w, h = .6, 18, 10, 3.9 
			local color = string.ToColor(GetConVar("cl_colorZone1"):GetString())

			if (x < lcl.x) and (lcl.x < x+w) and (y < lcl.y) and (lcl.y < y+h) then 

				color = string.ToColor(GetConVar("cl_colorZone3"):GetString()) 

				if (LocalPlayer():KeyDown(IN_USE) and ((os.time() - self.TimeSinceLastKeyPress) >= 1)) then

					net.Start("UpgradePrinter")

						net.WriteEntity(self)
						net.WriteString("Overdrive")
					net.SendToServer()

					self.TimeSinceLastKeyPress = os.time()
				end
			end

			draw.RoundedBox(0, x*100, y*100, w*100, h*100, color)

			surface.DrawCircle(lcl.x*100, lcl.y*100, 5, Color(255, 255, 255, 255))//simple cursor

			//draw.SimpleText(tostring(lcl), "SmolPrinterFont", 90, 90, Color(100, 100, 100, 255), 0, 0)//debug data
    	cam.End3D2D()
	end
end

//--------------------------HELPER METHODS--------------------------------------

function ConvertToHMS(seconds)//converts seconds to h:m:s

    local h = 0
    local m = 0
    local s = 0

    if seconds / 3600 >= 1 then

    	h = math.floor(seconds / 3600)

    	seconds = seconds - h*3600
    end

    if seconds / 60 >= 1 then

    	m = math.floor(seconds / 60)

    	seconds = seconds - m*60
    end

    s = seconds

    return h..":"..m..":"..seconds
end