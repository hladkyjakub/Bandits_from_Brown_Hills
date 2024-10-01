local u_table = wml.variables["unit"]
local object = wml.find_child(wml.get_child(u_table,"modifications"),"object",{id="limited_uses"})
local limited_uses = wml.find_child(wml.get_child(wml.find_child(object, "effect", {apply_to = "attack"}), "set_specials"),"limited_uses",{id="limited_uses"})
local uses = tonumber(limited_uses.uses)
limited_uses.uses = (uses - 1)
limited_uses.name = tostring(limited_uses.name):gsub("%-?%d+", (uses - 1))
limited_uses.description = tostring(limited_uses.description):gsub("%-?%d+", (uses - 1))
limited_uses.special_note = tostring(limited_uses.special_note):gsub("%-?%d+", (uses - 1))
wesnoth.units.erase(wml.variables["unit.x"],wml.variables["unit.y"])
wesnoth.units.to_map(u_table)
local u=wesnoth.units.get({u_table.x,u_table.y})
u:transform(u.type)
if uses == 1 then
    wesnoth.units.find_on_map({x = wml.variables["unit.x"],y = wml.variables["unit.y"]})[1]:remove_modifications({ id = limited_uses.trait }, "trait")
    wesnoth.wml_actions.clear_menu_item({id = limited_uses.menu_item})
    --wesnoth.wml_actions.modify_unit({{"filter",{id=wml.variables["unit.id"]}}, {"object",{{"effect",{apply_to="remove_attacks", name = wml.variables["weapon.name"], special_id="limited_uses"}}}}}) -- This line is needed if your unit_type has a limited_uses attack -- implement disabled special if unit has more same weapons!!! (PING ME ON DISCORD< IF YOU WANT TO USE IT AND ARENT SURE WHAT IT DOES)
end