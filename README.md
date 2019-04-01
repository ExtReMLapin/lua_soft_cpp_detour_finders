# lua_soft_detour_finders POC
POC detecting c/cpp function being detoured using a cpp module by checking the address of the function


Execute the file, it will generate a file in data/ with a populated database, it only checks the function from _G, detect the "lower" function, decides it's the offset and then generate the database out of it.

Then you can use the generated file to check if any cpp function was detoured.

Obviously, it's reboot/changelevel proof, that's the whole point of detecting the offset, eh.

The built DB is probably not exportable to another os/build target

![](https://i.imgur.com/xXH2lTQ.gif)



What it's not doing : 

* Detecting lua detours (that's easy to do)

* Detecting backdoors

* Detecting detours of tostring, even if i can use other ways of getting the address


it should generate this kind of file :


```Lua

local g_funcs	=	{
		SetPhysConstraintSystem	=	110328,
		SetGlobalVar	=	110992,
		LerpVector	=	114072,
		DeriveGamemode	=	109976,
		Error	=	106728,
		SetGlobal2Var	=	113232,
		OrderVectors	=	114000,
		isentity	=	108352,
		GetGlobalString	=	112072,
		SetGlobalInt	=	111136,
		RealTime	=	109112,
		ProtectedCall	=	109840,
		ismatrix	=	108480,
		DebugInfo	=	106480,
		RunString	=	107608,
		ispanel	=	108416,
		GetGlobal2Entity	=	113160,
		isstring	=	107968,
		EffectData	=	110864,
		isfunction	=	108288,
		GetGlobal2Int	=	112296,
		ParticleEffectAttach	=	109536,
		LerpAngle	=	110608,
		SysTime	=	107344,
		Vector	=	113936,
		HSVToColor	=	107480,
		isvector	=	108096,
		Msg	=	106544,
		SetGlobal2Entity	=	113088,
		GetGlobalAngle	=	111856,
		PrintMessage	=	110408,
		CreatePhysCollideBox	=	113440,
		SetGlobal2Int	=	112224,
		CompileString	=	107736,
		GetHostName	=	113376,
		GetGlobalEntity	=	112000,
		GetGlobalVector	=	111784,
		AddOriginToPVS	=	108760,
		Entity	=	110672,
		IsFirstTimePredicted	=	109240,
		BroadcastLua	=	110120,
		SetGlobalAngle	=	111352,
		GetGlobal2Var	=	113304,
		Player	=	113600,
		GetGlobalBool	=	111928,
		IsEntity	=	110192,
		type	=	107872,
		SetGlobalEntity	=	111424,
		MsgN	=	106664,
		ErrorNoHalt	=	106792,
		Path	=	114136,
		CreateConVar	=	107064,
		isangle	=	108160,
		include	=	106856,
		Matrix	=	110800,
		GetConVar_Internal	=	107136,
		RunStringEx	=	107672,
		RecipientFilter	=	114200,
		isnumber	=	108032,
		SetGlobal2Angle	=	112944,
		CurTime	=	109048,
		AddConsoleCommand	=	110256,
		TypeID	=	109776,
		GetGlobal2Angle	=	113016,
		ConVarExists	=	106920,
		GetGlobal2String	=	112728,
		PrecacheParticleSystem	=	109384,
		isbool	=	108224,
		GetGlobalFloat	=	111640,
		HTTP	=	109912,
		MsgC	=	106600,
		DropEntityIfHeld	=	108688,
		PrecacheScene	=	108832,
		SuppressHostEvents	=	108904,
		UnPredictedCurTime	=	108976,
		FrameTime	=	109176,
		GetGlobal2Bool	=	112584,
		CompileFile	=	109320,
		ParticleEffect	=	109464,
		RunConsoleCommand	=	107272,
		SetGlobalString	=	111064,
		LocalToWorld	=	108544,
		CreatePhysCollidesFromModel	=	113520,
		PrecacheSentenceFile	=	109616,
		PrecacheSentenceGroup	=	109696,
		ColorToHSV	=	107544,
		ServerLog	=	106416,
		istable	=	107904,
		SetGlobal2Bool	=	112512,
		MsgAll	=	110480,
		AddCSLuaFile	=	110048,
		GetGlobalVar	=	111568,
		GetGlobal2Float	=	112440,
		EmitSound	=	113872,
		VC‪‪‪‪‪‪‪‪‪‪‪‪	=	107608,
		DamageInfo	=	110928,
		SetGlobalFloat	=	111208,
		SetGlobalBool	=	111496,
		FindMetaTable	=	106992,
		EmitSentence	=	113800,
		BuildNetworkedVarsTable	=	112144,
		SetGlobal2Float	=	112368,
		CreateSound	=	113664,
		GetGlobal2Vector	=	112872,
		VGUIFrameTime	=	107408,
		GetGlobalInt	=	111712,
		module	=	0,
		WorldToLocal	=	108616,
		Angle	=	110544,
		SetGlobal2String	=	112656,
		SetGlobal2Vector	=	112800,
		require	=	107808,
		SetGlobalVector	=	111280,
		SoundDuration	=	11728,
}

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

```
