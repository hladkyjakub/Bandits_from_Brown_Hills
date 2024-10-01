local AH = wesnoth.require "~add-ons/Bandits_from_Brown_Hills/ai/lua/ai_helper.lua"
local BC = wesnoth.require "~add-ons/Bandits_from_Brown_Hills/ai/lua/battle_calcs.lua"
local LS = wesnoth.require "location_set"
local H = wesnoth.require "helper"
local M = wesnoth.map

local real_ranged_attack = {}
local best_analysis = -1000
local choice_rating = -1000

local function attack_rating(analysis)
    -- if self.leader_threat then
    --     aggression = 1.0
    -- end
    -- if self.uses_leader then
    --     aggression = ai_obj:get_leader_aggression()
    -- end
    local weapon_index = 2
    local attacker_condition,defender_condition,attacker_stats,defender_stats = BC.simulate_combat_loc(analysis.src,analysis.dst,analysis.target,weapon_index)
    local value = self.chance_to_kill * self.target_value - self.avg_losses * (1.0 - aggression)
    if self.terrain_quality > self.alternative_terrain_quality then
        -- This situation looks like it might be a bad move:
        -- we are moving our attackers out of their optimal terrain
        -- into sub-optimal terrain.
        -- Calculate the 'exposure' of our units to risk.
        local exposure_mod = self.uses_leader and 2.0 or ai_obj:get_caution()
        local exposure = exposure_mod * self.resources_used * (self.terrain_quality - self.alternative_terrain_quality) * self.vulnerability / math.max(0.01, self.support)
        print(string.format("attack option has base value %f with exposure %f: %f/%f = %f", 
            value, exposure, self.vulnerability, self.support, self.vulnerability / math.max(self.support, 0.1)))
        value = value - exposure * (1.0 - aggression)
    end
    -- Prefer to attack already damaged targets.
    value = value + ((self.target_starting_damage / 3 + self.avg_damage_inflicted) - (1.0 - aggression) * self.avg_damage_taken) / 10.0
    -- If the unit is surrounded and there is no support,
    -- or if the unit is surrounded and the average damage is 0,
    -- the unit skips its sanity check and tries to break free as good as possible.
    if not self.is_surrounded or (self.support ~= 0 and self.avg_damage_taken ~= 0) then
        -- Sanity check: if we're putting ourselves at major risk,
        -- and have no chance to kill, and we're not aiding our allies
        -- who are also attacking, then don't do it.
        if self.vulnerability > 50.0 and self.vulnerability > self.support * 2.0
        and self.chance_to_kill < 0.02 and aggression < 0.75
        and not self:attack_close(self.target) then
            return -1.0
        end
    end
    if not self.leader_threat and self.vulnerability * self.terrain_quality > 0.0 and self.support ~= 0 then
        value = value * self.support / (self.vulnerability * self.terrain_quality)
    end
    value = value / ((self.resources_used / 2) + (self.resources_used / 2) * self.terrain_quality)
    if self.leader_threat then
        value = value * 5.0
    end
    print(string.format("attack on %s: attackers: %d value: %f chance to kill: %f damage inflicted: %f damage taken: %f vulnerability: %f support: %f quality: %f alternative quality: %f",
        self.target, #self.movements, value, self.chance_to_kill, self.avg_damage_inflicted, self.avg_damage_taken,
        self.vulnerability, self.support, self.terrain_quality, self.alternative_terrain_quality))
    return value
end

function real_ranged_attack:evaluation()
    local units = AH.get_units_with_attacks({side=wesnoth.current.side,canrecruit=false})
    --local options = self:get_recruitment_pattern() --no idea what is this good for?
    best_analysis = -1000
    local analysis = AH.get_attacks_ranged_included(units, {}) --include_occupied
    local max_sims = 50000
    local num_sims = #analysis == 0 and 0 or max_sims / #analysis
    if num_sims < 20 then --this part is weird
        num_sims = 20
    end
    if num_sims > 40 then
        num_sims = 40
    end
    local max_positions = 30000
    local skip_num = 0
    if #analysis > max_positions then 
        skip_num= #analysis / max_positions
    end
    local choice_it = nil
    --std_print(analysis)
    --BfBH.table.std_print(analysis)
    for i, it in ipairs(analysis) do
        if skip_num > 0 and (i % skip_num == 0 ) then --and #it.movements > 1 ???
            goto continue
        end
        local skip_attack = false
        for _, movement in ipairs(it.src) do
            local u = units:find(movement)
            if not u then --or not self:is_allowed_unit(u) --what is_allowed_unit means?
                skip_attack = true
                break
            end
        end
        if skip_attack then
            goto continue
        end
        local att_weapon, def_weapon = BC.best_weapons(wesnoth.units.get(it.src), wesnoth.units.get(it.target), { it.dst.x, it.dst.y })
        local rating = BC.ranged_attack_rating(wesnoth.units.get(it.src), wesnoth.units.get(it.target), { it.dst.x, it.dst.y }, {att_weapon = att_weapon, def_weapon = def_weapon} ) --it:rating(self:get_aggression(), self) --get_aggression now
        std_print(it.dst.x,it.dst.y)
        std_print(rating)
        if rating > choice_rating then
            choice_it = it
            choice_rating = rating
        end
        ::continue::
    end
    if choice_rating > 0.0 then
        best_analysis = choice_it
        --BfBH.table.std_print(best_analysis)
        return 100000 --what to return?
    else
        best_analysis = -1000
        --BfBH.table.std_print(best_analysis)
        return 0
    end
end
function real_ranged_attack:execution()
    assert(choice_rating > 0.0)
    assert(best_analysis ~= -1000)
    if best_analysis ~= nil then
        --BfBH.table.std_print(best_analysis)
        local from = best_analysis.src
        local unit = wesnoth.units.get(from)
        local to = best_analysis.dst
        local target_loc = best_analysis.target
        local second_unit = wesnoth.units.get(target_loc)
        local att_weapon, def_weapon = BC.best_weapons(unit, second_unit, { best_analysis.dst.x, best_analysis.dst.y })
        if from ~= to then
            if not ai.check_move(unit, to) then
                    std_print("ERROR, didn't pass the move")
                return
            end
        end
        std_print("unit should move now")
        std_print("From: x="..from.x.." y="..from.y.."    To: x="..to.x.." y="..to.y)
        ai.move_full(unit, to)
        if not ai.check_attack(unit, second_unit, -1) then
            std_print("ERROR, execute not ok, attack cancelled")
        else
            --ai.attack(unit, second_unit, -1)
            std_print("unit should attack now, possible error, if no attack")
            wesnoth.wml_actions.do_command({
                {"attack",{weapon = (att_weapon - 1),defender_weapon = (def_weapon - 1),{"source", {x = unit.x, y = unit.y}}, {"destination", {x = second_unit.x, y = second_unit.y}}}}
            })
        end
        choice_rating=-1000
    end
end

return real_ranged_attack


-- function real_ranged_attack:evaluation()
--     local units = AH.get_units_with_attacks({
--         side = wesnoth.current.side
--     })
--     for _, unit in ipairs(units) do
--         local adjacent_enemies = {}
--         for _, loc in ipairs(table.pack(wesnoth.map.get_adjacent_hexes(unit.loc))) do
--             local unit = wesnoth.units.get(loc)
--             if unit ~= nil and wesnoth.sides.is_enemy(wesnoth.current.side,unit.side) then
--                 table.insert(adjacent_enemies, unit)
--             end
--         end
--         if #adjacent_enemies > 0 then
--             return 900000
--         end
--     end
--     return 0
-- end

-- function real_ranged_attack:execution()
--     local units = AH.get_units_with_attacks({
--         side = wesnoth.current.side
--     })
--     for _, unit in ipairs(units) do
--         local adjacent_enemies = {}
--         for _, loc in ipairs(table.pack(wesnoth.map.get_adjacent_hexes(unit.loc))) do
--             local unit = wesnoth.units.get(loc)
--             if unit ~= nil and wesnoth.sides.is_enemy(wesnoth.current.side,unit.side) then
--                 table.insert(adjacent_enemies, unit)
--             end
--         end
--         if #adjacent_enemies > 0 then
--             local target = adjacent_enemies[1]
--                 ai.attack(unit, target)
--             return
--         end
--     end
-- end
-- local reaches = LS.create()

--     for _,unit in ipairs(units) do
--         local reach
--         if reaches:get(unit.x, unit.y) then
--             reach = reaches:get(unit.x, unit.y)
--         else
--             reach = wesnoth.paths.find_reach(unit, {})
--             reaches:insert(unit.x, unit.y, reach)
--         end
--         print(reaches)
--     end