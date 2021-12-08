function try(what)
   status, result = pcall(what[1])
   if not status then
      what[2](result)
   end
   return result
end

function catch(what)
   return what[1]
end

function check(tablex, valuex)
  for index,value in ipairs(tablex) do
    if valuex == value then return true end
  end
  return false
end

local function file_exists(file) 
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

function linesfrom(file)
  if not file_exists(file) then
    return {}
  end
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

function loadWordlist()
  x = linesfrom("./Resources/Server/SimpleManager/utils/bannedwords.txt")
  return x
end
