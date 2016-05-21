concommand.Add( 'ShowMyScreenshots', function() -- How to network screenshots- 1. File.Read the filepath, then send it as a string, and on the other clients, save it as a .txt and load it as an IMaterial before removing the file quickly
		
		local pics = file.Find( "screenshots/*", "MOD" )
		local matpath = '../screenshots/'
		local newpics = {}
		
		local function GetNameForTime( time )
			time = tonumber( time )
			if os.date( '%d %B %Y', time ) == os.date( '%d %B %Y' ) then
				time = 'Today'
			elseif os.date( '%Y', time ) == os.date( '%Y' ) then
				time = os.date( '%d %B', time )
			else
				time = os.date( '%d %B %Y', time )
			end
			return time
		end
		
		for k, img in pairs( pics ) do
			local time = file.Time( 'screenshots/' .. img, 'MOD' )

			if string.GetExtensionFromFilename( img ) == 'png' or string.GetExtensionFromFilename( img ) == 'jpg' then
				newpics[ time ] = { imagepath = img, alttime = GetNameForTime( time ) }
			end
		end
		
		local picsmodified = {}
		
		local panel = vgui.Create( 'DFrame' )
		panel:SetTitle( 'Your screenshots' )
		panel:SetSize( 640, 400 )
		panel:Center()
		panel:MakePopup()
		panel.Paint = function(self,w,h)
			surface.SetDrawColor( 0, 0, 0, 200 )
			surface.DrawRect( 0, 0, w, h )
		end
		
		local scroll = vgui.Create( 'DScrollPanel', panel )
		scroll:Dock( FILL )
		
		for time, tbl in SortedPairs( newpics, true ) do
			
			if picsmodified[ tbl.alttime ] == nil then
			
				local text = vgui.Create( 'DLabel', scroll )
				text:Dock( TOP )
				text:SetText( tbl.alttime )
				
				picsmodified[ tbl.alttime ] = vgui.Create( 'DIconLayout', scroll )
				picsmodified[ tbl.alttime ]:Dock( TOP )
				picsmodified[ tbl.alttime ]:SetSpaceX( 5 )
				picsmodified[ tbl.alttime ]:SetSpaceY( 5 )

				local t = picsmodified[ tbl.alttime ]:Add( 'DImageButton' )
				t:SetSize( 150, 90 )
				t:SetImage( matpath .. tbl.imagepath )
				picsmodified[ tbl.alttime ]:Add( t )
			
			else
			
				local i = picsmodified[ tbl.alttime ]:Add( 'DImageButton' )
				i:SetSize( 150, 90 )
				i:SetImage( matpath .. tbl.imagepath )
				picsmodified[ tbl.alttime ]:Add( i )
			
			end
			
		end
		
	end )
