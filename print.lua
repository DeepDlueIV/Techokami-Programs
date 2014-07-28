--A very simplistic printing program.

local component = require("component")
local computer = require("computer")

if not component.isAvailable("openprinter") then
  io.stderr:write("Can't print without a printer!")
  return
end

local args = {...}

if #args == 0 or (#args == 1 and args[1] == "-g") then
  io.write("Usage: print [-g] <filename>\n")
  io.write(" -g: Global path - Use a global path for the target file instead of a local path.")
  return
end

if args[1] == "-g" then
  path = args[2]
  name = args[2]
else
  path = os.getenv("PWD").."/"..args[1]
  name = args[1]
end

local lines = {}
local component = require "component"
local op = component.openprinter

print "Opening file..."
local fobj = io.open(path,"rb")

print "Reading file..."
for l in fobj:lines() do
  done = false
  while done == false do 
    if l:len() > 30 then
      table.insert(lines,l:sub(1,30))
      l=">"..l:sub(31)
    else
      table.insert(lines,l)
      done = true
    end
  end
end

fobj:close()
local counter = 0

print "Beginning to print..."
for key,value in pairs(lines) do
  if counter == 20 then
    op.setTitle(name)
    op.print()
    counter = 0
  end
  op.writeln(value)
  counter = counter + 1
end

op.setTitle(name)
op.print()