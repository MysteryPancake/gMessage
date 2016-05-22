-- This used to be the menu with the battery, time and OS at the top of the iMessage window
-- It will be sorely missed

self.DetailsPanel = vgui.Create( 'DPanel', self )
self.DetailsPanel:SetSize( 0, 20 )
self.DetailsPanel:Dock( TOP )
self.DetailsPanel.BatteryNum = 0
function self.DetailsPanel:Paint( w, h )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawRect( 0, 0, w, h )
		
	local battery = system.BatteryPower()	
	local time = os.date( "%I:%M %p" )
	local systemname
		
	if system.IsWindows() then systemname = 'OS - Windows'
	elseif system.IsOSX() then systemname = 'OS - OSX'
	elseif system.IsLinux() then systemname = 'OS - Linux' 
	else systemname = 'Unknown System' end
		
	draw.SimpleText( time, 'gMessageFont', w / 2, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER ) -- draw the time
	draw.SimpleText( systemname, 'gMessageFont', 2, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER ) -- draw the system
		
	if battery <= 100 then -- draw the battery inside rectangle bit
		if battery <= 10 then
			surface.SetDrawColor( 255, 0, 0, 255 )
		else
			surface.SetDrawColor( 0, 0, 0, 255 )
		end
		surface.DrawRect( w - 40, h / 2 - 8 / 2, battery / 100 * 30, 8 )
		draw.SimpleText( battery .. '%', 'gMessageFont', w - 45, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
	else
		surface.SetDrawColor( 0, 255, 0, 255 )
		surface.DrawRect( w - 40, h / 2 - 8 / 2, self.BatteryNum, 8 )
		draw.SimpleText( 'Charging', 'gMessageFont', w - 45, h / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		self.BatteryNum = math.min( 30, self.BatteryNum + ( 30 * RealFrameTime() / 2 ) )
		if self.BatteryNum == 30 then self.BatteryNum = 0 end
	end
		
	local margin = 3 -- the battery's margin
		
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawOutlinedRect( w - 40 - margin, h / 2 - 8 / 2 - margin, 30 + ( margin * 2 ), 8 + ( margin * 2 ) )
	surface.DrawRect( w - 7, h / 2 - 8 / 2, 2, 8 )
		
	surface.SetDrawColor( 160, 160, 160, 255 )
	surface.DrawLine( -1, h - 1, w, h - 1 )
		
end
