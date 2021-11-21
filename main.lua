--=================================================================
-- Guest/Ban Controller!
-- By p05
-- Originaly by Titch
--=================================================================

local AllowGuests    = false
local AllowGuestChat = false

--=================================================================
-- Make sure that there is no comma at the end, it will break because its stupid
--=================================================================

blacklist = {
	"Player1",
	"Player2",
	"Player3"
	}

--=================================================================
-- DO NOT TOUCH BEYOND THIS POINT
--=================================================================

require "Resources/Server/PlayerManager/utils/utils"

-- idk what this is for

local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

-- Events

function onInit()
	print("PlayerManager Loaded!")
end

function onChatMessage(id, name, message)
	local identifiers = GetPlayerIdentifiers(id)
	if identifiers == nil and not AllowGuestChat then -- the nil means they are a guest
		SendChatMessage(id, "Sorry chat is disabled for guest players on this server. Please register for a BeamMP Account to use the Chat functionality.")
		return 1
	end
end

function onPlayerAuth(name, role, isGuest)
  print("Event onPlayerAuth(name="..name..",role="..role..",guest?="..tostring(isGuest)..")")
  local playerList = GetPlayers()
  blocked = false
  -- Try-Catch Block for block check
  try {
    function()
      blocked = check(blacklist, name)
	end,
	catch {
      function(error)
        print("Error @ onPlayerAuth: " .. error)
     end
    }
  }
  if isGuest and not AllowGuest then
    print ("onPlayerAuth Breaking, player is a guest.")
    return "You must be signed in to join this server!"
  end
  if blocked then 
    print("onPlayerAuth Breaking, player is blocked.")
    return "You've Been Banned from this server! Please contact p05#8995 on discord  to request to be unbanned!"
  end
  print("End onPlayerAuth")
end

RegisterEvent("onPlayerAuth","onPlayerAuth")
RegisterEvent("onChatMessage","onChatMessage")
