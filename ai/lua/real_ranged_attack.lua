local AH = wesnoth.require "~add-ons/Bandits_from_Brown_Hills/ai/lua/ai_helper.lua"
local BC = wesnoth.require "~add-ons/Bandits_from_Brown_Hills/ai/lua/battle_calcs.lua"
local LS = wesnoth.require "location_set"
local H = wesnoth.require "helper"
local M = wesnoth.map

    local real_ranged_attack = {}

    function real_ranged_attack:evaluation(ai)
        local units = AH.get_units_with_attacks({
            side = wesnoth.current.side
        })
        for _, unit in ipairs(units) do
            local adjacent_enemies = {}
            for _, loc in ipairs(table.pack(wesnoth.map.get_adjacent_hexes(unit.loc))) do
                local unit = wesnoth.units.get(loc)
                if unit ~= nil and wesnoth.sides.is_enemy(wesnoth.current.side,unit.side) then
                    table.insert(adjacent_enemies, unit)
                end
            end
            if #adjacent_enemies > 0 then
                return 900000
            end
        end
        return 0
    end
    
    function real_ranged_attack:execution(ai)
        local units = AH.get_units_with_attacks({
            side = wesnoth.current.side
        })
        for _, unit in ipairs(units) do
            local adjacent_enemies = {}
            for _, loc in ipairs(table.pack(wesnoth.map.get_adjacent_hexes(unit.loc))) do
                local unit = wesnoth.units.get(loc)
                if unit ~= nil and wesnoth.sides.is_enemy(wesnoth.current.side,unit.side) then
                    table.insert(adjacent_enemies, unit)
                end
            end
            if #adjacent_enemies > 0 then
                local target = adjacent_enemies[1]
                    ai.attack(unit, target)
                return
            end
        end
    end
    
    return real_ranged_attack