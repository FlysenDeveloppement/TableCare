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
local TableCare = require(game:GetService("ReplicatedStorage").TableCare) -- or: require(game.ReplicatedStorage.TableCare)
local table1 = {"banana", "apple", "berry", "mouse", "dog", "horse"}
local table2 = {"apple", "cat", "mouse", "fox", "fly", "give"}

local common_elements = TableCare.checksimilar(table1, table2) -- return a table.
```

### TableCare.deleteall(table1, elements)
If element value is equal to the elements argument then, it will be delete.
```lua
local TableCare = require(game:GetService("ReplicatedStorage").TableCare) -- or: require(game.ReplicatedStorage.TableCare)
local table1 = {"banana", "apple", "berry", "mouse", "dog", "berry", "horse", "berry"}

table1 = TableCare.deleteall(table1, "berry") -- return a table ({"banana", "apple", "mouse", "dog", "horse"})
```

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/FlysenDeveloppement/TableCare/settings/pages). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://docs.github.com/categories/github-pages-basics/) or [contact support](https://support.github.com/contact) and we’ll help you sort it out.
