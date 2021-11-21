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