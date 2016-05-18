if ( SERVER ) then

	local msgs = {} -- This table stores sent messages serverside in case new players join and get invited to a chat and need messages or request them

	util.AddNetworkString( 'sendmessage' )
	util.AddNetworkString( 'newmessage' )

	local function IsValidMsgTab( tab, ply )
		if !istable( tab ) then return end
		if next( tab ) == nil then return end
		local plyintable = false
		for k,v in pairs( tab ) do
			if !isnumber( k ) then return false end
			if !isentity( v ) then return false end
			if !v:IsPlayer() then return false end
			if v == ply then plyintable = true end
		end
		if !plyintable then return false end -- the player who sends the newmessage has to be included in the people that are part of the message group
		return true
	end
	
	net.Receive( 'newmessage', function( len, ply )
	
		local msgplys = net.ReadTable() -- the players receiving the message
		if !IsValidMsgTab( msgplys, ply ) then return end
		
		local ind = table.insert( msgs, {
			plys = msgplys,
			allmsgs = {}
		} )
		
		net.Start( 'newmessage' )
		net.WriteFloat( ind )
		net.WriteEntity( ply )
		net.Send( msgplys )
	
	end )
	
	net.Receive( 'sendmessage', function( len, ply )
	
		local msgid = net.ReadFloat() -- the message id
		
		if !isnumber( msgid ) then return end
		if msgid <= 0 then return end
		if !msgs[ msgid ] then return end
		if !IsValidMsgTab( msgs[ msgid ].plys, ply ) then return end
		
		local msg = net.ReadString() -- the message
		if !isstring( msg ) then return end
		if msg == '' then return end
			
		local time = SysTime()
			
		table.insert( msgs[ msgid ].allmsgs, {
			msg = msg,
			time = time,
			sender = ply
		} )
		
		net.Start( 'sendmessage' )
		net.WriteFloat( msgid )
		net.WriteString( msg )
		net.WriteFloat( time )
		net.WriteEntity( ply )
		net.Send( msgplys )
	
	end )

end

if ( CLIENT ) then

	net.Receive( 'newmessage', function()
	
		local msgid = net.ReadFloat()
		local sender = net.ReadEntity()
		
		if sender == LocalPlayer() then
			-- their message is set up, just set the msgid on their panel and we're done
		else
			-- ask them if they want to message some new guy
		end
		
	end )
	
	net.Receive( 'sendmessage', function()
	
		local msgid = net.ReadFloat()
		local msg = net.ReadString()
		local time = net.ReadFloat()
		local sender = net.ReadEntity()
		
		-- check their panel has the msgid allowed and on it already
		-- check their player table for the msgid to make sure the sender is in it (meaning they accepted the conversation invite)
		-- add the message to their panel
	
	end )

end
