## Welcome to the TableCare page.

This module allow you to manage your tables more easier.
![Book logo](/TableCare.png)

### Get the model:
[Get the Roblox Model](https://www.roblox.com/library/7879906070/TableCare)

## API Documentation:
### How to set up?

First, place the module script into the ReplicatedStorage. After, go in a Script or Local Script and put:
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare) -- or: require(game.ReplicatedStorage.TableCare)
```

### TableCare.checksimilar(table1, table2)
This function allow you to find all communs elements between 2 tables (table1 and table2) (Return a table with all commons elements)
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
local table1 = {"banana", "apple", "berry", "mouse", "dog", "horse"}
local table2 = {"apple", "cat", "mouse", "fox", "fly", "give"}

local common_elements = TableCare.checksimilar(table1, table2) -- return a table.
```

### TableCare.deleteall(table1, elements) --> not working for the moment.
If element value is equal to the elements argument then, it will be delete.
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
local table1 = {"banana", "apple", "berry", "mouse", "dog", "berry", "horse", "berry"}

table1 = TableCare.deleteall(table1, "berry") -- return a table ({"banana", "apple", "mouse", "dog", "horse"})
```

### TableCare.clearwithout(tab, optional_element, optional_element2, optional_element3) --> not working for the moment.
Allow you to clear all elements of the table except optional_element, optional_element2 and optional_element3
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
local table1 = {"banana", "apple", "berry", "mouse", "dog", "horse"}

table1 = TableCare.clearwithout(table1, "berry", "mouse", "horse") -- return a table ({"berry", "mouse", "horse"})
```

### TableCare.kiss(tab1, tab2)
This function allow you to insert all elements of the tab2 (type: table) in the tab1 (type: table).
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
local table1 = {"banana", "apple", "berry", "mouse", "dog", "horse"}
local table2 = {"orange", "cat", "ari", "fox", "fly", "give"}


table1 = TableCare.kiss(table1, table2) -- return a table ({"banana", "apple", "berry", "mouse", "dog", "horse", "orange", "cat", "ari", "fox", "fly", "give"})
```

### TableCare.save_table(tab1, optional_id, optional_erase)
Allow you to save tab1 (type: table) to use the table in another script with the function load_table. You can put the id in argument #2 (if not id then id will set automatically) and you can set argument 3 to true if you want to erase an old saved table with the same id. (return the saved id)
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
local table1 = {"banana", "apple", "berry", "mouse", "dog", "horse"}

local save_id = TableCare.save_table(table1, 1, false) -- return id_value | The save_id is the argument 2. If you don't put argument 2, save_id will be automatically set.
```

### TableCare.load_table(table_id, table_to_load)
load a saved table with the id (If you saved a table, id 1, so put 1 for the table_id argument (#1). The table_to_load is optional, it's where the table will be "insert".
Use the TableCare.save_table() function before using this function.
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
local copy_table = {}
wait(2)

copy_table = TableCare.load_table(1, copy_table) -- return a table.
```

### TableCare.unload_table(table_id)
Allow you to delete a loaded table with the saved table id. If I save a table with the id 1 and I will delete this save, I will use this function.
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
wait(1)
TableCare.unload_table(1) -- The argument #1 (1) is the saved table id argument (table_id).
```

### TableCare.get_length(table1)
Allow you to get the length of the table1 *(type: table)*.
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
local copy_table = {"hey", "my", "name", "is", "fox"}

local copy_length = TableCare.get_length(copy_table) -- return a number. (5)
```

### TableCare:GetLoadedTables()
Return a table with all saved tables (table id saved and the table)
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
local SavedTables = TableCare:GetLoadedTables() -- return a table with all saved tables inside.
```

### TableCare:LoadCareFor(table1, optional_custom_table_name, optional_basic_index)
This function allow you to set add functions for the table, sub functions... Allow you to use the NewIndexAdded event (to detect when an index is add for your table)
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
local actualTable = {}

actualTable = TableCare:LoadCareFor(actualTable, "My New Name Is This", 0) -- Argument 2 set the string return when you print the table.

TableCare.NewIndexAdded:Connect(function(table, index, value)
    print(tostring(table) .. " have a new index " .. index .." and the value is " .. value
end)
```

### TableCare:UnloadCareFor(table1)
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
local actualTable = {}

actualTable = TableCare:LoadCareFor(actualTable, "My New Name Is This", 0) -- Argument 2 set the string return when you print the table.

actualTable = TableCare:UnloadCareFor(actualTable) -- turn off new parameters...
```

### TableCare:TrackIndexPlayer(table, optional_bind_id, player, optional_erase) --> arg1: table, arg2: string or nil, arg3: player or player_name (string), optional_instance: boolean
This function allow you to know when a player is set to your table. 
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
local table1 = {}
  
table1, event, bind_id = TableCare:TrackIndexPlayer(table1, nil, "Tom_minecraft", false)

event:Connect(function(player)
    print("Plaeyr is set to the table")
end)
```
**TableCare:UntrackIndexPlayer(bind_id) is used to stop the event.. (unbind).**

### TableCare:TrackIndexInstance(table1, instance, optional_bind_id, optional_erase) --> arg1: table, arg2: InstanceType (string format), arg3: number or nil, arg4: boolean
Allow you to know when an Instance is set for your table.
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
local track_instance_table, event, bind_id = TableCare:TrackIndexInstance({}, "Part", 101, false)

event:Connect(function(part)
    print("The table got a part ( " .. part .. " !")
end)
```
**TableCare:UntrackIndexInstance(bind_id) is used to stop the event.. (unbind).**

### TableCare:TrackToFunction(table1, function_to_execute_when_call) --> arg1: table, arg2: function
Allow you to execute a function when the table is called as function.
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
local myTable = {}

local function_to_execute_when_call = function()
    print("execute!")
end)

myTable = TableCare:TrackToFunction(myTable, function_to_execute_when_call) -- return the table argument #1 but with new meta settings.

myTable() -- console will print "execute!"
```

### TableCare:ChangeIdentity(table1, table_name) --> arg1: table, arg2: string or number
This function allow you to set a table when the table is concat (..).
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
local myTable = {}

myTable = TableCare:ChangeIdentity(myTable, "'yo my new name is this'")

print("my new table is "..myTable) -- return in the console: my new table is 'yo my new name is this'.
```

### TableCare:PermanentLockToAccess(table1) --> arg1: table
This function lock the table and can't be set by other functions like the ChangeIdentity functions, tracktofunction function...
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
local myTable = {}

myTable = TableCare:PermanentLockToAccess(myTable) --> the table is locked and can't be set by meta tables
```

### TableCare:SetDefaultIndex(table1, value) --> arg1: table, arg2: boolean or number or string or instance...
This function allow you to return a value if a player try to get an invalid index.
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
local myTable = {"yo", "my"}

myTable = TableCare:SetDefaultIndex(myTable, "name")

print(myTable[1]) --> print in the console: yo
print(myTable[2]) --> print in the console: my
print(myTable[3]) --> print in the console : name
```

### TableCare:GetTrackedEvents()
This function return a table with all tracked events inside (like PlayerTracker...).
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
local myTable = {}

myTable = TableCare:GetTrackedEvents() -- return a table.
```

### TableCare:ClearLoadedTables()
This function clear **all** loaded tables.
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
TableCare:ClearLoadedTables()
```

### TableCare:ClearTrackedEvents()
This function clear **all** tracked events can have errors for tables set with tracked events (patch is coming).
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
TableCare:ClearTrackedEvents()
```
