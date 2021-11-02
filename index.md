## Welcome to the TableCare page.

This module allow you to manage your tables more easier.

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

### TableCare.deleteall(table1, elements)
If element value is equal to the elements argument then, it will be delete.
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare)
local table1 = {"banana", "apple", "berry", "mouse", "dog", "berry", "horse", "berry"}

table1 = TableCare.deleteall(table1, "berry") -- return a table ({"banana", "apple", "mouse", "dog", "horse"})
```

### TableCare.clearwithout(tab, optional_element, optional_element2, optional_element3)
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

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/FlysenDeveloppement/TableCare/settings/pages). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://docs.github.com/categories/github-pages-basics/) or [contact support](https://support.github.com/contact) and we’ll help you sort it out.
