-- for key, v in pairs(wml.variables["weapon.specials"]) do
--     if type(v) == "table" and string.match(v[1], "^dummy") then
--         for key2, v2 in ipairs(v) do
--             if type(v2) == "table" then
--                 for key3, v3 in pairs(v2) do
--                     if string.match(tostring(v3), "^limited_uses_") and tostring(key3) == "id" then
--                         local u_table = wml.variables["unit"]
--                         local specials = wml.get_child(wml.find_child(u_table, "attack", {name = wml.variables["weapon.name"]}), "specials")
--                         local uses = tonumber(specials[key][2].id:match("%-?%d+"))
--                         specials[key][2].id = specials[key][2].id:gsub("%-?%d+", (uses - 1))
--                         specials[key][2].name = tostring(specials[key][2].name):gsub("%-?%d+", (uses - 1))
--                         specials[key][2].description = tostring(specials[key][2].description):gsub("%-?%d+", (uses - 1))
--                         specials[key][2].special_note = tostring(specials[key][2].special_note):gsub("%-?%d+", (uses - 1))
--                         wesnoth.units.erase(wml.variables["unit.x"],wml.variables["unit.y"])
--                         wesnoth.units.to_map(u_table)
--                         if uses == 1 then
--                             wesnoth.wml_actions.modify_unit({{"filter",{id=wml.variables["unit.id"]}}, {"object",{{"effect",{apply_to="remove_attacks", special_id="limited_uses_0"}}}}})
--                         end
--                     end
--                 end
--             end
--         end
--     end
-- end

function print_table(tbl, indent)
    indent = indent or 0
    local function repeat_char(char, num)
        return string.rep(char, num)
    end
    for k, v in pairs(tbl) do
        local formatting = repeat_char("  ", indent) .. tostring(k) .. ": "
        if type(v) == "table" then
            std_print(formatting)
            print_table(v, indent + 1)
        else
            std_print(formatting .. tostring(v))
        end
    end
end
--PECKOVA VEC

-- Define sample data structures
local sampleTable = {
    key1 = "value1",
    key2 = 42,
    key3 = { nestedKey = "nestedValue" }
}

local sampleArray = { 1, 2, 3, 4, 5 }

local sampleString = "Hello, Lua!"

-- Function to recursively print a table to a file
local function printTable(table, indent)
    indent = indent or 0

    for key, value in pairs(table) do
        if type(value) == "table" then
            std_print(string.rep("  ", indent) .. key .. ":\n")
            printTable(value, indent + 1)
        else
            std_print(string.rep("  ", indent) .. key .. ": " .. tostring(value) .. type(value) .. "\n")
        end
    end
end
local function printAllVariables(classTable)
    for key, value in pairs(classTable) do
        std_print("Variable: " .. key .. ", Value: " .. tostring(value))
        --wesnoth.message("Variable: " .. key .. ", Value: " .. tostring(value))
    end
end
function isValueInTable(tbl, pattern)
    for key, v in pairs(tbl) do
        if type(v) == "table" then
            if string.match(v[1], pattern) then
                return true
            end
        end
    end
    return false
end

-- Print the sample data structures to the file
-- std_print("Sample Table:\n")
-- printTable(sampleTable)
-- 
-- std_print("\nSample Array:\n")
-- printTable(sampleArray)
-- 
-- std_print("\nSample String:\n")
-- std_print(sampleString .. "\n")
--     std_print("=========================================================================================================================================\n")
--     printTable(wml)
--     std_print("=========================================================================================================================================\n")
--     printAllVariables(wml)
--     std_print("=========================================================================================================================================\n")
--     printAllVariables(wml.get_all_vars())
  --   std_print("=========================================================================================================================================\n")
     --printAllVariables(wml.variables['unit'][1].get_all_vars())
   --  printAllVariables(wml.variables["unit"][1].get_all_vars())
   --FUNGUJE
 --   std_print(wml.variables["wenrys_stored"])
--     std_print("=========================================================================================================================================\n")
--     my_var=wml.get_variable(2)
--     printAllVariables(my_var)
  --  std_print("=========================================================================================================================================\n")
 --   printTable(wml.variables["wenrys_stored[0].attack[1]"])
 std_print(wml.variables["weapon.name"])
    std_print("=========================================================================================================================================\n")
    printTable(wml.variables["weapon.specials"])
    std_print("=========================================================================================================================================\n")
    if isValueInTable(wml.variables["weapon.specials"], "^pois") then
    wml.variables["weapon.specials.poison.name"] = "poison2"
    std_print(wml.variables["weapon.specials.name"])
    end
    std_print("=========================================================================================================================================\n")
    my_unit = wesnoth.units.get("jareth")
    std_print(type(my_unit))
    std_print("=========================================================================================================================================\n")
    --printTable(my_unit)
 --   printTable(wml.units.wenrys)
    wesnoth.units.transform(my_unit, "Orcish Assassin")
    -- funguje printTable(my_unit.__cfg[5])
    -- ne printTable(my_unit.variables.__cfg)
--     my_unit_throwing knives = my_unit.attacks.throwing knives
    std_print(#my_unit.attacks)
    -- std_print(type(my_unit_throwing knives))
   -- printTable(my_unit.attacks.throwing_knives.__cfg)
       for i, value in ipairs(my_unit.attacks) do
    std_print("Element at index", i, ":", value.type)
    for j, weaponspecial in ipairs(value.specials) do
        std_print("Element at index", j, ":") 
        printTable(weaponspecial)
    end
    end
    -- printTable(my_unit.attacks."throwing knives".specials[1])
    std_print("=========================================================================================================================================\n")
    
    std_print("=========================================================================================================================================\n")
    --local Victim_5=wesnoth.units.get(x, y)
    local u = wesnoth.units.find_on_map{ id = "jareth" }[1]
for att in wml.child_range(u.__cfg, "attack") do
    wesnoth.message(tostring(att.description))
end
   --wesnoth.set_variable(wml.variables["wenrys_stored[0].attack[1].damage[0]"],1)
    --std_print(wml.variables["wenrys_stored[0].attack[1].damage[0]"])
-- ATTACKING UNIT X=x1 Y=y1 same with defender
-- siege weapon local inrange = wesnoth.get_units{x=27, y=10, wml.tag.filter_location{radius=10}}
-- local Hero_Unit=wesnoth.units.get(1, 1)
--                 local special=""
--                 if Hero_Unit and Hero_Unit.attack then
--                     wesnoth.interface.add_chat_message("attack found: ")
--                     for k,v in Hero_Unit.attack do
--                         if Hero_Unit.attack[k].special then
--                             wesnoth.interface.add_chat_message("special found: ")
--                             for k2,v2 in Hero_Unit.attack[k].special do
--                                 wesnoth.interface.add_chat_message("special name: ")
--                                 wesnoth.interface.add_chat_message(v2)
--                             end
--                         end
--                     end
--                 end
