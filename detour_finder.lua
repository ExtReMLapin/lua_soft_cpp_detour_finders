function isFuncCPP(func)
	return debug.getinfo(func).source == "=[C]"
end

function isFuncNative(func)
	return string.StartWith(tostring(func),"function: builtin#")
end

function getFuncAddr(func)
	if (type(func) != "function") then error("Expecting a function") end
	if (isFuncCPP(func) == false ) then error("Expecting a CPP/C function") end
	local str = tostring(func)
	if (string.StartWith(str,"function: builtin#")) then
		str = string.Right(str, string.len(str) - 18)
		return tonumber(str)
	elseif (string.StartWith(str,"function: 0x")) then
		str = string.Right(str, string.len(str) - 10)
		local num = tonumber(str);
		return num
	else
		error"WTF"
	end
end


local tbl = {}

local lowerval = -1
local lowertext = ""

print("Finding function with lower address ...")

for k, v in pairs(_G) do
	if (type(v) != "function") then continue end
	if (isFuncCPP(v) == false ) then continue end
	if (isFuncNative(v) == true ) then continue end
	local num = getFuncAddr(v)
	tbl[k] = num

	if (lowerval == -1 or num < lowerval) then
		lowerval = num
		lowertext = k
	end

end

print("Lower func in _G is " .. lowertext .. "()")

local base_offset = lowerval
print("Rebuilding table with detected offset of " .. base_offset)
for k , v in pairs(tbl) do
	tbl[k] = tbl[k] - base_offset
end


local _outstr = "local " .. table.ToString(tbl,"g_funcs", true) .. [[


local func_comparer = nil; -- function in the _G
local lfunccomp_addr = 0; -- function addr saved in the table
local DETECTED_OFFSET = 0
for k, v in pairs(g_funcs) do -- find the first func that isn't the lower possible
	if v != 0 then
		func_comparer = _G[k]
		local str = tostring(func_comparer)
		lfunccomp_addr = tonumber(string.Right(str, string.len(str) - 10))
		DETECTED_OFFSET =lfunccomp_addr-v
	end

end
if func_comparer == nil then error("wtf, no function found") end

print("Checking for integrity ...")

for l_funcname, l_funcaddr in pairs(g_funcs) do



	local g_realfunc = _G[l_funcname]
	local str_g_addr = tostring(g_realfunc)
	local g_funcaddr =  tonumber(string.Right(str_g_addr, string.len(str_g_addr) - 10))

	if  (g_funcaddr-l_funcaddr != DETECTED_OFFSET) then -- the offset should be constant
		MsgC(Color(255,50,50), Format("FUNCTION %s ISNT AT THE RIGHT ADDRESS\n", l_funcname))
	end
end

print("Done.")

]]


file.Write("saved_funcs_addr.txt",_outstr )

print("Wrote table to saved_funcs_addr.txt")
