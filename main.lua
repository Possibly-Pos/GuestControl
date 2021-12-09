--=================================================================
-- Guest/Ban Controller!
-- By p05
-- Originaly by Titch
--=================================================================
local AllowGuests     = false
local AllowGuestChat  = false
local ProfanityBlock  = false  -- This takes priority over the filter, so if you have them both set to true
local ProfanityFilter = false  -- it will default to blocking the message.
blacklist = {
	"Player1",
	"Player2",
	"Player3"
	}
-- ↑ Formatting above is how it must be or it won't work correctly.
local bannedMessage = "You've Been Banned from this server! Please contact the server owner on discord to request to be unbanned!"
local noGuestsMessage = "You must be signed in to join this server!"
local noGuestChatMessage = "Sorry chat is disabled for guest players on this server. Please register for a BeamMP Account to use the Chat functionality."
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
	chatfilter = loadWordlist()
end

function onChatMessage(id, name, message)
	local identifiers = GetPlayerIdentifiers(id)
	if identifiers == nil and not AllowGuestChat then -- the nil means they are a guest
		SendChatMessage(id, noGuestChatMessage)
		return 1
	end
	if ProfanityBlock then -- Block Profanity
		for k,p in ipairs(chatfilter) do
			if string.find(message, p, 1, true) then
				SendChatMessage(id, "You message did not go through because it contains profanity.")
				return 1
			end
		end
	end
	if ProfanityFilter then -- Remove Profanityfor k,p in ipairs(chatfilter) do
		for k,p in ipairs(chatfilter) do
			if string.find(message, p, 1, true) then
				message = string.gsub(message, p, string.rep('*', string.len(p)))
			end
		end
		message = "{"..name.."}"..message
		SendChatMessage(-1, message)
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
    return noGuestsMessage
  end
  if blocked then 
    print("onPlayerAuth Breaking, player is blocked.")
    return bannedMessage
  end
  print("End onPlayerAuth")
end

RegisterEvent("onPlayerAuth","onPlayerAuth")
RegisterEvent("onChatMessage","onChatMessage")
