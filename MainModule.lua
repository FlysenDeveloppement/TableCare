--[[
	
	Updates:
		The metatables for the function LoadCareFor() are now stable.
		The table.deleteeall() function is back.
		When a table is permanent lock and you call a function using the metatable, it will return a warn in the output and return the table and args..
		Added arguments for the :UntrackIndexInstance and the :UntrackIndexPlayer functions.
		Erased metatables bug patch.
		WorkonClient delete
		Added meta_save function (When save, you can load the table one time and after, the saved table will be deleted [Like a temporary table.])
		Added comparators for the function TableCareFor(table).
		Added SetIndexFunction.
		Added UntrackToFunction to untrack a tracked function.

	API:
	
	  local TableCare = require(game.ReplicatedStorage.TableCare)
	  you can also use require(7879906070) for automatic updates 
	  Documentation: https://devforum.roblox.com/t/tablecare-v-101-module-to-manage-tables-more-easier/1533465
	  Version: 1.0.2
	  
	 
	License: 
	
	  Licenced under the MIT licence.     
	  		MIT License

			Copyright (c) 2021 Tom Flysen

			Permission is hereby granted, free of charge, to any person obtaining a copy
			of this software and associated documentation files (the "Software"), to deal
			in the Software without restriction, including without limitation the rights
			to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
			copies of the Software, and to permit persons to whom the Software is
			furnished to do so, subject to the following conditions:

			The above copyright notice and this permission notice shall be included in all
			copies or substantial portions of the Software.

			THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
			IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
			FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
			AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
			LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
			OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
			SOFTWARE.
	  
	Authors:
	
	  Flysen (@Tom_minecraft) - November 1st, 2021 - Created the file.    


--]]


local TableCare = {LoadedTables = {}; TrackedEvents = {}; ChangedIdentities = {}; FunctionsSignals = {}; MetaLoadedTables = {}}
TableCare.__index = TableCare

local Signal = require(script.Signal)

local ClientAllowed = script:GetAttribute("WorkOnClient")

TableCare.NewIndexAdded = Signal.new()

local RunService = game:GetService("RunService")

local function _GetTableType(t)
	local Number = 0
	local Other = 0
	
	for k, v in pairs(t) do
		if typeof(k) == "number" then
			Number += 1
		else
			Other += 1
		end
	end
	
	if Number > Other then
		return "Mixed"
	else
		return "Dictionnary"
	end
end

function _ChangeIdentityRetry(tab, id, add_operator)
	if not add_operator then add_operator = 0 end

	add_operator += 1

	if TableCare.ChangedIdentities[id] then
		if TableCare.ChangedIdentities[id..add_operator] then
			_ChangeIdentityRetry(tab, id, add_operator)
		else
			TableCare.ChangedIdentities[id..add_operator] = tab
			return id..add_operator
		end
	else
		TableCare.ChangedIdentities[id] = tab
		return id
	end
end

function _SpinNewId(check_table)
	local id = math.random(1,10000000)
	if check_table[id] then
		_SpinNewId()
	else
		return id
	end
end

function TableCare.checksimilar(tab1, tab2)
	 
	if not tab1 then error("[TableCare]: Error for the .checksimilar() function, argument #1 can't be find.") end
	local common_elements = {}
	
	for k, v in pairs(tab1) do
		if table.find(tab2, v) then
			table.insert(common_elements, v)
		end
	end
	
	return common_elements
end

function TableCare.deleteall(tab, element)
	 
	if not tab then error("[TableCare]: Error for the .deleteall() function, argument #1 can't be find.") end
	local get_event_id = math.random()

	repeat
		table.remove(tab, table.find(tab, element))
	until not table.find(tab, element)
	
	return tab
end

--[[function TableCare.clearwithout(tab, element_one, element_two, element_three)
	if not tab then
		error("[TableCare]: Error for the .clearwithout() function, argument #1 can't be find.")
	end
	
	local index = 0
	
	for i = 1, #tab do
		
	end
	
	return tab
end--]]

function TableCare.kiss(tab1, tab2)
	 
	if not tab1 then error("[TableCare]: Error for the .kiss() function, argument #1 can't be find.") end
	for k, v in pairs(tab2) do
		table.insert(tab1, v)
	end
	
	return tab1
end

function TableCare.save_table(tab, id, erase)	
	 
	if not tab then error("[TableCare]: Error for the .save_table() function, argument #1 can't be find.") end
	if not erase then erase = false end
	
	if not id then
		local split = string.split(tostring(tab), " ")
		table.remove(split, 1)
		id = table.concat(split, " ")
	end
	
	if erase == false then
		if TableCare.LoadedTables[id] then return error("[TableCare]: Id for the table "..tab.." is already used. Try to put a different id.") end
	end
	
	TableCare.LoadedTables[id] = {}
	
	local t = _GetTableType(tab)
	
	for k, v in pairs(tab) do
		if t == "Dictionnary" then
			TableCare.LoadedTables[id][k] = v
		else
			table.insert(TableCare.LoadedTables[id], v)
		end
	end
	
	return id
end

function TableCare.meta_save(tab, save_id)
	if not tab then error("[TableCare]: Error for the .save_table() function, argument #1 can't be find.") end

	if not save_id then
		local split = string.split(tostring(tab), " ")
		table.remove(split, 1)
		save_id = table.concat(split, " ")
	end

	TableCare.MetaLoadedTables[save_id] = {}

	local t = _GetTableType(tab)

	for k, v in pairs(tab) do
		if t == "Dictionnary" then
			TableCare.MetaLoadedTables[save_id][k] = v
		else
			table.insert(TableCare.MetaLoadedTables[save_id], v)
		end
	end

	return save_id
end

function TableCare.load_table(tab_id, tab)
	 
	if not tab_id then error("[TableCare]: Error for the .load_table() function, argument #1 can't be find.") end
	if not tab then tab = {} end
	
	if TableCare.LoadedTables[tab_id] then
		local t = _GetTableType(TableCare.LoadedTables[tab_id])

		for k, v in pairs(TableCare.LoadedTables[tab_id]) do
			if t == "Dictionnary" then
				tab[k] = v
			else
				table.insert(tab, v)
			end
		end

		return tab
	end
	
	if TableCare.MetaLoadedTables[tab_id] then
		local t = _GetTableType(TableCare.MetaLoadedTables[tab_id])

		for k, v in pairs(TableCare.MetaLoadedTables[tab_id]) do
			if t == "Dictionnary" then
				tab[k] = v
			else
				table.insert(tab, v)
			end
		end
		
		TableCare.MetaLoadedTables[tab_id] = nil
		return tab
	end
end

function TableCare.unload_table(tab_id)
	 
	if not tab_id then error("[TableCare]: Error for the .unload_table() function, argument #1 can't be find.") end
	TableCare.LoadedTables[tab_id] = nil
	TableCare.MetaLoadedTables[tab_id] = nil
end

function TableCare.random_id(f)
	 
	local get_id 

	if f == "load" then
		get_id = _SpinNewId(TableCare.LoadedTables)
	elseif f == "track_event" then
		get_id = _SpinNewId(TableCare.TrackedEvents)
	else
		get_id = math.random(1,10000000000)
	end

	return get_id
end

function TableCare.get_length(tab)
	 
	if not tab then error("[TableCare]: Error for the .get_length() function, argument #1 can't be find.") end
	local count = 0
	
	for index, value in pairs(tab) do
		count += 1
	end
	
	return count
end

function TableCare:GetLoadedTables()
	 
	return self.LoadedTables
end

function TableCare:LoadCareFor(tab, automatic_convert_string_to_id, optional_basic_index)
	 
	if not tab then error("[TableCare]: Error for the :LoadPlusFor function, argument #1 can't be find.") end
	if getmetatable(tab) == "Locked" then warn("The table is locked! No changement can be effectued.") return tab end
	
	local meta = {}
	
	if getmetatable(tab) then
		meta = getmetatable(tab)
	end
	
	meta.__newindex = function(t, i, v)
		self.NewIndexAdded:Fire(t, i, v)
	end

	meta.__index = function(t, i)
		print("No index for the table " .. tostring(t))
		return optional_basic_index
	end
		
	meta.__add = function(t1, t2)
		local firstCount = 0
		local secondCount = 0
		
		if typeof(t1) == "table" then
			for index, value in pairs(t1) do
				firstCount += tonumber(value)
			end
		else
			firstCount += tonumber(t1)
		end
			
		if typeof(t2) == "table" then
			for index, value in pairs(t2) do
				secondCount += tonumber(value)
			end
		else
			secondCount += tonumber(t2)
		end
		
		return firstCount + secondCount
	end
		
	meta.__sub = function(t1,t2)
		local count = 0
		local sub_count = 0
		
		for index, value in pairs(t1) do
			count += tonumber(value)
		end
		
		if typeof(t2) == "table" then
			for index, value in pairs(t2) do
				sub_count += tonumber(value)
			end
		else
			sub_count += tonumber(t2)
		end
			
		return count - sub_count
	end
		
	meta.__mult = function(t1,t2)
		local first_count = 0
		local second_count = 0
			
		if typeof(t1) == "table" then
			for index, value in pairs(t1) do
				first_count += tonumber(value)
			end
		else
			first_count += tonumber(t1)
		end
			
		if typeof(t2) == "table" then
			for index, value in pairs(t2) do
				second_count += tonumber(value)
			end
		else
			second_count += tonumber(t2)
		end
			
		return first_count * second_count
	end
		
	meta.__div = function(t1,t2)
		local firstCount = 0
		local secondCount = 0
		
		if typeof(t1) =="table" then
			for index, value in pairs(t1) do
				firstCount += tonumber(value)
			end
		else
			firstCount += tonumber(t1)
		end
			
		if typeof(t2) =="table" then
			for index, value in pairs(t2) do
				secondCount += tonumber(value)
			end
		else
			secondCount += tonumber(t2)
		end

		return firstCount / secondCount
	end
		
	meta.__eq = function(t1,t2)
		local firstCount = 0
		local secondCount = 0

		if typeof(t1) == "table" then
			for index, value in pairs(t1) do
				firstCount += tonumber(value)
			end
		else
			firstCount += tonumber(t1)
		end
			
		if typeof(t2) == "table" then
			for index, value in pairs(t2) do
				secondCount += tonumber(value)
			end
		else
			secondCount += tonumber(t2)
		end
			
		if firstCount == secondCount then
			return true
		else
			return false
		end
	end
	
	meta.__lt = function(t, value)
		local value_value = 0
		local t_value = 0
		
		if typeof(value) == "table" then
			for index, v in pairs(value) do
				value_value += tonumber(v)
			end
		else
			value_value += tonumber(value)
		end
		
		if typeof(t) == "table" then
			for index, v in pairs(value) do
				value_value += tonumber(v)
			end
		else
			value_value += tonumber(t)
		end
		
		if t_value < value_value then
			return true
		else
			return false
		end
	end
	
	meta.__le = function(t, value)
		local value_value = 0
		local t_value = 0

		if typeof(value) == "table" then
			for index, v in pairs(value) do
				value_value += tonumber(v)
			end
		else
			value_value += tonumber(value)
		end

		if typeof(t) == "table" then
			for index, v in pairs(value) do
				value_value += tonumber(v)
			end
		else
			value_value += tonumber(t)
		end

		if t_value <= value_value then
			return true
		else
			return false
		end
	end
	
	if not automatic_convert_string_to_id == false or not automatic_convert_string_to_id == nil then
		meta.__tostring = function(t)
			return tostring(automatic_convert_string_to_id)
		end;
	end
	
	setmetatable(tab, meta)
	
	return tab
end

function TableCare:UnloadCareFor(tab)
	 
	if not tab then error("[TableCare]: Error for the :UnloadPlusFor function, argument #1 can't be find.") end
	if getmetatable(tab) == "Locked" then warn("The table is locked! No changement can be effectued.") return tab end
	setmetatable(tab, {})

	return tab
end

function TableCare:TrackIndexPlayer(tab, bind_id, player, erase)
	 
	if not tab then error("[TableCare]: Error for the :TrackIndexPlayer function, argument #1 can't be find.") end
	if getmetatable(tab) == "Locked" then warn("The table is locked! No changement can be effectued.") return tab end
	
	if typeof(player) == "string" then
		if game.Players:FindFirstChild(player) then
			player = game.Players:FindFirstChild(player)
		else
			error("[TableCare]: Player can't be find in the players class.")
		end
	end
	if not bind_id then
		bind_id = _SpinNewId(self.TrackedEvents)
	end
	if self.TrackedEvents[bind_id] then
		if erase == true then
			self.TrackedEvents[bind_id] = Signal.new()
		else
			error("[TableCare]: This id is already used for a bind. Try with another id.")
		end
	else
		self.TrackedEvents[bind_id] = Signal.new()
	end

	local meta = {}
	if getmetatable(tab) then
		meta = getmetatable(tab)
	end
	meta.__newindex = function(t, i, v)
		local p = player

		if v == p then
			self.TrackedEvents[bind_id]:Fire(v)
		end
	end
	
	setmetatable(tab, meta)

	return tab, self.TrackedEvents[bind_id], bind_id
end

function TableCare:UntrackIndexPlayer(bind_id, optional_tab_use)
	 
	if not bind_id then error("[TableCare]: Error for the :UntrackIndexPlayer function, argument #1 can't be find.") end
	local tab = optional_tab_use or {}
	
	local meta = {}
	
	if getmetatable(tab) then
		meta = getmetatable(tab)
	end
	
	meta.__newindex = function(t,i,v)
		
	end
	
	setmetatable(tab, meta)
	
	if bind_id then
		self.TrackedEvents[bind_id]:Disconnect()
		self.TrackedEvents[bind_id] = nil
	end

	return tab
end

function TableCare:TrackIndexInstance(tab, inst, bind_id, erase)
	 
	if not tab then error("[TableCare]: Error for the :TrackIndexInstance function, argument #1 can't be find.") end
	if not typeof(inst) == "Instance" then
		error("[TableCare]: Argument #2 for the function TrackInstance must be an Instance value.")
	end
	
	if getmetatable(tab) == "Locked" then warn("The table is locked! No changement can be effectued.") return tab, nil, nil end
	
	if not bind_id then
		bind_id = _SpinNewId(self.TrackedEvents)
	end
	
	if self.TrackedEvents[bind_id] then
		if erase == true then
			self.TrackedEvents[bind_id] = Signal.new()
		else
			error("[TableCare]: This id is already used for a bind. Try with another id.")
		end
	else
		self.TrackedEvents[bind_id] = Signal.new()
	end
	
	local meta = {}
	
	if getmetatable(tab) then
		meta = getmetatable(tab)
	end
	
	meta.__newindex = function(t,i,v)
		local a = inst
		if typeof(v) == "Instance" then
			if v:IsA(a) then
				self.TrackedEvents[bind_id]:Fire(v)
			end
		end
	end
	
	setmetatable(tab, meta)
	return tab, self.TrackedEvents[bind_id], bind_id
end

function TableCare:UntrackIndexInstance(bind_id, tab1)
	 
	if not bind_id then error("[TableCare]: Error for the :UntrackIndexInstance function, argument #2 can't be find.") end
	local tab = tab1 or {}
	local meta = {}
	if getmetatable(tab) then
		meta = getmetatable(tab)
	end
	meta.__newindex = function(t, i, v)
		
	end
	
	setmetatable(tab, meta)
	if bind_id then
		self.TrackedEvents[bind_id]:Disconnect()
		self.TrackedEvents[bind_id] = nil
	end
	
	return tab
end

function TableCare:TrackToFunction(tab, f)
	 
	if not tab then error("[TableCare]: Error for the :TrackToFunction function, argument #1 can't be find.") end
	if getmetatable(tab) == "Locked" then warn("The table is locked! No changement can be effectued.") return tab end
	
	if not f then
		f = function()
			warn("[TableCare]: Nothing in this function. Try to set a function in the argument #2 for :TrackToFunction")
		end
	end
	
	if not tab then
		error("[TableCare]: Error for the :ToFunction function, argument #1 can't be find.")
	end
		
	local meta = {}
	if getmetatable(tab) then
		meta = getmetatable(tab)
	end
	meta.__call = f
	setmetatable(tab, meta)
	
	return tab
end

function TableCare:UntrackToFunction(tab)
	if not tab then error("[TableCare]: Error for the :TrackToFunction function, argument #1 can't be find.") end
	if getmetatable(tab) == "Locked" then warn("The table is locked! No changement can be effectued.") return tab end
	
	local meta = {}
	if getmetatable(tab) then
		meta = getmetatable(tab)
	end
	
	meta.__call = function()
		error("[TableCare]: A table can not be called like a function.")
	end
	
	setmetatable(tab, meta)
	
	return meta
end

function TableCare:ChangeIdentity(tab, id)
	 
	if not tab then error("[TableCare]: Error for the :ChangeIdentity function, argument #1 can't be find.") end
	if getmetatable(tab) == "Locked" then warn("The table is locked! No changement can be effectued.") return tab end
	if not id then
		id = math.random(1,10000000)
	end
	
	local get_real_id = _ChangeIdentityRetry(tab, id)

	local meta = {}
	if getmetatable(tab) then
		meta = getmetatable(tab)
	end
	
	meta.__concat = function(t1, t2)
		if self.ChangedIdentities[get_real_id] == t1 then
			return get_real_id .. t2
		else
			return t1 .. get_real_id
		end
	end
	
	setmetatable(tab, meta)
	return tab
end

function TableCare:PermanentLockToAccess(tab)
	 
	if not tab then error("[TableCare]: Error for the :PermanentLockToAccess function, argument #1 can't be find.") end
	if getmetatable(tab) == "Locked" then warn("The table is locked! No changement can be effectued.") return tab end
	local meta = {}
	
	if getmetatable(tab) then
		meta = getmetatable(tab)
		meta.__metatable = "Locked"
	else
		meta.__metatable = "Locked"
		setmetatable(tab, meta)
	end
	
	return tab
end

function TableCare:SetDefaultIndex(tab, value)
	 
	if not tab then error("[TableCare]: Error for the :SetDefaultIndex function, argument #1 can't be find.") end
	if getmetatable(tab) == "Locked" then warn("The table is locked! No changement can be effectued.") return tab end
	local meta = {}
	
	if getmetatable(tab) then
		meta = getmetatable(tab)
	end
	
	meta.__index = function(t, i)
		return value
	end
	
	setmetatable(tab, meta)
	return tab
end

function TableCare:SetIndexFunction(tab, f)
	if not tab then error("[TableCare]: Error for the :SetDefaultIndex function, argument #1 can't be find.") end
	if getmetatable(tab) == "Locked" then warn("The table is locked! No changement can be effectued.") return tab end
	if not typeof(f) == "function" then warn("[TableCare]: The argument #2 of the function SetIndexFunction must be a function.") return tab end
	local meta = {}
	
	if getmetatable(tab) then
		meta = getmetatable(tab)
	end

	meta.__index = f

	setmetatable(tab, meta)
	return tab
end

function TableCare:GetTrackedEvents()
	 
	return self.TrackedEvents
end

function TableCare:ClearLoadedTables()
	 
	table.clear(self.LoadedTables)
end

function TableCare:ClearTrackedEvents()
	 
	table.clear(self.TrackedEvents)
end

setmetatable(TableCare, {
	__index = function(object, value)
		error("Attempt to get ".. tostring(value) .. " (not a valid member).")
	end,
	
	__newindex = function(object, index, value)
		error("Attempt to get " .. tostring(value) .. " (not a valid member).")
	end,
	
	__call = function(tab)
		error("Attempt to call the " .. tostring(tab).. " (not a valid function).")
	end,
})

return TableCare
