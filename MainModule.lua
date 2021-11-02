--[[


	API:
	
	  local TableCare = require(game.ReplicatedStorage.TableCare) or require(id)
	  Documentation: https://flysendeveloppement.github.io/TableCare/
	  Version: 1.0.0
	  
	 
	License: 
	
	  Licenced under the MIT licence.     
	  
	Authors:
	
	  Flysen (@Tom_minecraft) - November 1st, 2021 - Created the file.   
--]]


local TableCare = {LoadedTables = {}; TrackedEvents = {};}
TableCare.__index = TableCare

local Signal = require(script.Signal)

TableCare.NewIndexAdded = Signal.new()

local RunService = game:GetService("RunService")

local function getTableType(t)
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
		return "Array"
	else
		return "Dictionnary"
	end
end

function spin_new_id(check_table)
	local id = math.random(1,10000000)
	if check_table[id] then
		spin_new_id()
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
	local count = 0
	
	for k, v in pairs(tab) do
		count = count + 1
		if v == element then
			table.remove(tab, v)
			count =count- 1
		end
	end
	
	return tab
end

function TableCare.clearwithout(tab, element_one, element_two, element_three)
	if not tab then
		error("[TableCare]: Error for the .clearwithout() function, argument #1 can't be find.")
	end
	local count= 0
	
	for k, v in pairs(tab) do
		count = count + 1
		if v ~= element_one or v ~= element_two or v ~= element_three then
			table.remove(tab, count)
			count = count - 1
		end
	end
	
	return tab
end

function TableCare.kiss(tab1, tab2)
	if not tab1 then error("[TableCare]: Error for the .kiss() function, argument #1 can't be find.") end
	for k, v in pairs(tab2) do
		table.insert(tab1, v)
	end
	
	return tab1
end

function TableCare.save_table(tab, id, erase)	
	if not tab then error("[TableCare]: Error for the .save_table() function, argument #1 can't be find.") end
	local split
	if not erase then erase = false end
	
	if not id then
		split = string.split(tostring(tab))
		table.remove(split, 1)

		id = table.concat(split, " ")
	end
	
	if erase == false then
		if TableCare.LoadedTables[id] then return error("[TableCare]: Id for the table "..tab.." is already used. Try to put a different id.") end
	end
	
	TableCare.LoadedTables[id] = {}
	
	local t = getTableType(tab)
	
	for k, v in pairs(tab) do
		if t == "Dictionnary" then
			TableCare.LoadedTables[id][k] = v
		else
			table.insert(TableCare.LoadedTables[id], v)
		end
	end
	
	return split
end

function TableCare.load_table(tab_id, tab)
	if not tab_id then error("[TableCare]: Error for the .load_table() function, argument #1 can't be find.") end
	if not tab then tab = {} end
	
	local t = getTableType(TableCare.LoadedTables[tab_id])
	
	for k, v in pairs(TableCare.LoadedTables[tab_id]) do
		if t == "Dictionnary" then
			tab[k] = v
		else
			table.insert(tab, v)
		end
	end
	
	return tab
end

function TableCare.unload_table(tab_id)
	if not tab_id then error("[TableCare]: Error for the .unload_table() function, argument #1 can't be find.") end
	TableCare.LoadedTables[tab_id] = nil
end

function TableCare.random_id(f)
	local get_id 

	if f == "load" then
		get_id = spin_new_id(TableCare.LoadedTables)
	elseif f == "track_event" then
		get_id = spin_new_id(TableCare.TrackedEvents)
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
	
	local meta = {
		__newindex = function(t, i, v)
			self.NewIndexAdded:Fire(t, i, v)
		end,

		__index = function(t, i)
			print("No index for the table " .. tostring(t))
			return optional_basic_index
		end,
		
		__add = function(t1, t2)
			local firstCount = 0
			local secondCount = 0
			
			for index, value in pairs(t1) do
				firstCount += tonumber(value)
			end
			
			for index, value in pairs(t2) do
				secondCount += tonumber(value)
			end
			
			return firstCount + secondCount
		end,
		
		__sub = function(t1,t2)
			local firstCount = 0
			local secondCount = 0

			for index, value in pairs(t1) do
				firstCount += tonumber(value)
			end

			for index, value in pairs(t2) do
				secondCount -= tonumber(value)
			end

			return firstCount - secondCount
		end,
		
		__mult = function(t1,t2)
			local firstCount = 0
			local secondCount = 0

			for index, value in pairs(t1) do
				firstCount += tonumber(value)
			end

			for index, value in pairs(t2) do
				secondCount += tonumber(value)
			end

			return firstCount * secondCount
		end,
		
		__div = function(t1,t2)
			local firstCount = 0
			local secondCount = 0

			for index, value in pairs(t1) do
				firstCount += tonumber(value)
			end

			for index, value in pairs(t2) do
				secondCount += tonumber(value)
			end

			return firstCount / secondCount
		end,
		
		__eq = function(t1,t2)
			local firstCount = 0
			local secondCount = 0

			for index, value in pairs(t1) do
				firstCount += tonumber(value)
			end

			for index, value in pairs(t2) do
				secondCount += tonumber(value)
			end
			
			if firstCount == secondCount then
				return true
			else
				return false
			end
		end,
	}

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
	setmetatable(tab, {})

	return tab
end


function TableCare:TrackIndexPlayer(tab, bind_id, player, erase)
	if not tab then error("[TableCare]: Error for the :TrackIndexPlayer function, argument #1 can't be find.") end
	if typeof(player) == "string" then
		if game.Players:FindFirstChild(player) then
			player = game.Players:FindFirstChild(player)
		else
			error("[TableCare]: Player can't be find in the players class.")
		end
	end
	if not bind_id then
		bind_id = spin_new_id(self.TrackedEvents)
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

	local meta = {
		__newindex = function(t, i, v)
			local p = player

			if v == p then
				self.TrackedEvents[bind_id]:Fire(v)
			end
		end,

	}

	setmetatable(tab, meta)

	return tab, self.TrackedEvents[bind_id], bind_id
end

function TableCare:UntrackIndexPlayer(bind_id)
	if not bind_id then error("[TableCare]: Error for the :UntrackIndexPlayer function, argument #1 can't be find.") end
	local tab = {}
	setmetatable(tab, {})
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
	
	if not bind_id then
		bind_id = spin_new_id(self.TrackedEvents)
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
	
	local meta = {
		__newindex = function(t,i,v)
			local a = inst
			if typeof(v) == "Instance" then
				if v:IsA(a) then
					self.TrackedEvents[bind_id]:Fire(v)
				end
			end
		end,
	}
	
	setmetatable(tab, meta)
	return tab, self.TrackedEvents[bind_id], bind_id
end

function TableCare:UntrackIndexInstance(bind_id)
	if not bind_id then error("[TableCare]: Error for the :UntrackIndexInstance function, argument #1 can't be find.") end
	local tab = {}
	setmetatable(tab, {})
	if bind_id then
		self.TrackedEvents[bind_id]:Disconnect()
		self.TrackedEvents[bind_id] = nil
	end
	
	return tab
end

function TableCare:TrackToFunction(tab, f)
	if not tab then error("[TableCare]: Error for the :TrackToFunction function, argument #1 can't be find.") end
	if not f then
		f = function()
			warn("[TableCare]: Nothing in this function. Try to set a function in the argument #2 for :TrackToFunction")
		end
	end
	
	if not tab then
		error("[TableCare]: Error for the :ToFunction function, argument #1 can't be find.")
	end
	
	local meta = {
		__call = f
	}
	
	setmetatable(tab, meta)
	
	return tab
end

function TableCare:ChangeIdentity(tab, id)
	if not tab then error("[TableCare]: Error for the :ChangeIdentity function, argument #1 can't be find.") end
	if not id then
		id = math.random(1,10000000)
	end
	
	local meta = {
		__concat = function(t1, t2)
			return id
		end,
	}
	
	setmetatable(tab, meta)
	return tab
end

function TableCare:PermanentLockToAccess(tab)
	if not tab then error("[TableCare]: Error for the :PermanentLockToAccess function, argument #1 can't be find.") end
	local meta = {
		__metatable = "Locked"
	}
	
	setmetatable(tab, meta)
	return tab
end

function TableCare:SetDefaultIndex(tab, value)
	if not tab then error("[TableCare]: Error for the :SetDefaultIndex function, argument #1 can't be find.") end
	local meta = {
		__index = function(t, i)
			return value
		end,
	}
	
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
})

return TableCare
