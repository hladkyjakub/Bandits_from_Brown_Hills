--This is just a blueprint for me
local _ = wesnoth.textdomain "wesnoth-Bandits_from_Brown_Hills" --Idk how to use it???
local f_side_playing = wesnoth.interface.game_display.side_playing
function wesnoth.interface.game_display.side_playing()
	local g = f_side_playing()
	if wesnoth.current.side == 1 then --add elseif for more variants
        g[1][2].tooltip="BB (Best Band)"
	else
        g[1][2].tooltip="Who cares?"
    end
	return g
end
local f_turn = wesnoth.interface.game_display.turn
function wesnoth.interface.game_display.turn()
	local g = f_turn()
	if (wesnoth.scenario.turns - wml.variables["turn_number"]) < 6 then
        g[1][2].tooltip="Turn number\n\n        Maybe we should hurry?"
    else
        g[1][2].tooltip="Turn number\n\n        Thats a lot of time!"
    end
	return g
end
local f_gold = wesnoth.interface.game_display.gold
function wesnoth.interface.game_display.gold()
	local g = f_gold()
	if type(g[1][2].text) ~= "number" then
		num = g[1][2].text:gsub("<[^>]+>", "")
	else
		num = g[1][2].text
	end
	if num and tonumber(num) < 0 then
		g[1][2].tooltip="No B*tches?\n\n        I mean 'No Gold?'"
	else
		g[1][2].tooltip="<span color='#FFD700'>Gold\n\n        Sooo shiny...</span>"
	end
	return g
end
local f_villages = wesnoth.interface.game_display.villages
function wesnoth.interface.game_display.villages()
	local g = f_villages()
	if type(g[1][2].text) ~= "number" then
		str = g[1][2].text:gsub("<[^>]+>", "")
	else
		str = g[1][2].text
	end
	num = str:match(".-/(.*)")
	if tonumber(num) < 1 then
        g[1][2].tooltip="Tribute-Paying Settlements\n\n        None in sight"
    else
        num = str:match("(.-)/")
        if tonumber(num) < 1 then
            g[1][2].tooltip="Tribute-Paying Settlements\n\n        What about getting some?"
        else
            g[1][2].tooltip="Tribute-Paying Settlements\n\n        = even more <span color='#FFD700'>gold</span>"
        end
    end
	return g
end
local f_num_units = wesnoth.interface.game_display.num_units
function wesnoth.interface.game_display.num_units()
	local g = f_num_units()
	num = tonumber(g[1][2].text)
	if num == 1 then
		g[1][2].tooltip="I\n\n        ... don't like where this is going!"
	else
		g[1][2].tooltip="My men\n\n        Very loyal... in these caves"
	end
	return g
end
local f_upkeep = wesnoth.interface.game_display.upkeep
function wesnoth.interface.game_display.upkeep()
	local g = f_upkeep()
	if type(g[1][2].text) ~= "number" then
		str = g[1][2].text:gsub("<[^>]+>", "")
	else
		str = g[1][2].text
	end
	num = str:gsub("%b()", "")
	if tonumber(num) < 1 then
		g[1][2].tooltip="Upkeep\n\n        What are you talking about?"
	else
		g[1][2].tooltip="Hell\n\n        Why does everyone demand payment?"
	end
	return g
end
local f_income = wesnoth.interface.game_display.income
function wesnoth.interface.game_display.income()
	local g = f_income()
	if type(g[1][2].text) ~= "number" then
		num = g[1][2].text:gsub("<[^>]+>", "")
	else
		num = g[1][2].text
	end
	if tonumber(num) < 0 then
		g[1][2].tooltip="Income\n\n        Why it's negative?"
	else
		g[1][2].tooltip="<span weight='bold'>Stonks!</span>"
	end
	return g
end
local f_report_countdown = wesnoth.interface.game_display.report_countdown
function wesnoth.interface.game_display.report_countdown()
	local g = f_report_countdown()
	g[2][2].tooltip="Clock\n\n        Should get a working one..."--[2][2] has to be there, becouse it has image more element
	return g
end
local f_unit_name = wesnoth.interface.game_display.unit_name
function wesnoth.interface.game_display.unit_name()
	local g = f_unit_name()
	if wesnoth.interface.get_displayed_unit() then
        local u = wesnoth.interface.get_displayed_unit()
        if u.id == "jareth" then
            g[1][2].tooltip="That's me"
        elseif u.name == "" then
            g[1][2].tooltip="Nameless creature"
        else
            g[1][2].tooltip="You know what name means right?"
        end
    end
	return g
end
local f_unit_type = wesnoth.interface.game_display.unit_type
function wesnoth.interface.game_display.unit_type()
	local g = f_unit_type()
	if wesnoth.interface.get_displayed_unit() then
        local u = wesnoth.interface.get_displayed_unit()
        g[1][2].tooltip="That's a lots of words\n\ntoo bad I'm not gonna read them"
    end
	return g
end
local f_unit_side = wesnoth.interface.game_display.unit_side
function wesnoth.interface.game_display.unit_side()
	local g = f_unit_side()
	if wesnoth.interface.get_displayed_unit() then
        local u = wesnoth.interface.get_displayed_unit()
        if u.side == 1 then
            g[1][2].tooltip="BB (Best Band)"
            g[2][2].tooltip="BB (Best Band)"
        else
            g[1][2].tooltip="Who cares?"
            g[2][2].tooltip="Who cares?"
        end
    end
	return g
end
local f_unit_xp = wesnoth.interface.game_display.unit_xp
function wesnoth.interface.game_display.unit_xp()
	local g = f_unit_xp()
	if wesnoth.interface.get_displayed_unit() then
        local u = wesnoth.interface.get_displayed_unit()
        if u.experience == 1 then
            g[1][2].tooltip="This unit has exactlly one experience."
        elseif u.experience == 69 then
            g[1][2].tooltip="Nice!"
        elseif u.experience > (u.max_experience * 0.8) then
            if u.side == 1 then
                g[1][2].tooltip="We're going brrr!"
            else
                g[1][2].tooltip="This unit is close to level-up... keep that in mind!"
            end
        else
            g[1][2].tooltip="You don't know what XP means!?"
        end
    end
	return g
end
local f_unit_alignment = wesnoth.interface.game_display.unit_alignment
function wesnoth.interface.game_display.unit_alignment()
	local g = f_unit_alignment()
	if wesnoth.interface.get_displayed_unit() then
        local u = wesnoth.interface.get_displayed_unit()
        if u.alignment == "neutral" then
            g[1][2].tooltip="Boring"
        elseif u.alignment == "chaotic" then
            g[1][2].tooltip="Cool guys!"
        elseif u.alignment == "lawful" then
            g[1][2].tooltip="Literally the most boring aligment ever"
        elseif u.alignment == "liminal" then
            g[1][2].tooltip="Now we're talking!"
        else
            g[1][2].tooltip="Oh, I've never seen such a unit before"
        end
    end
	return g
end
local f_unit_race = wesnoth.interface.game_display.unit_race
function wesnoth.interface.game_display.unit_race()
	local g = f_unit_race()
	if wesnoth.interface.get_displayed_unit() then
        local u = wesnoth.interface.get_displayed_unit()
        if u.race == "human" then
            g[1][2].tooltip="Superior race"
        elseif u.race == "dwarf" then
            g[1][2].tooltip="Digging holes"
        elseif u.race == "naga" then
            g[1][2].tooltip="Water sss's"
        elseif u.race == "merfolk" then
            g[1][2].tooltip="WaterMan"
        elseif u.race == "lizard" then
            g[1][2].tooltip="Sss's"
        elseif u.race == "orc" then
            g[1][2].tooltip="With muscles like boulders and brain like... slightly smaller boulder"
        elseif u.race == "monster" then
            g[1][2].tooltip="What the hell is that?"
        elseif u.race == "goblin" then
            g[1][2].tooltip="Small, sneaky, and always up to no good"
        elseif u.race == "bats" then
            g[1][2].tooltip="Flying furball of fangs"
        elseif u.race == "wolf" then
            g[1][2].tooltip="Degenerated dog(cats are better)"
        else
            g[1][2].tooltip="???"
        end
    end
	return g
end
local f_terrain_info = wesnoth.interface.game_display.terrain_info
function wesnoth.interface.game_display.terrain_info()
	local g = f_terrain_info()
	if wesnoth.interface.get_selected_hex() and g ~= {} and wesnoth.interface.get_hovered_hex() == nil then
        local i = 1
        while g[i] and g[i][2] and g[i][2].tooltip ~= nil do
            if g[i][2].tooltip == "Castle" then
                g[i][2].tooltip="Fort"
            elseif g[i][2].tooltip == "Cave" then
                g[i][2].tooltip="Cavern"
            elseif g[i][2].tooltip == "Coastal Reef" then
                g[i][2].tooltip="Reef"
            elseif g[i][2].tooltip == "Deep Water" then
                g[i][2].tooltip="Depths"
            elseif g[i][2].tooltip == "Flat" then
                g[i][2].tooltip="Walkable"
            elseif g[i][2].tooltip == "Forest" then
                g[i][2].tooltip="Woods"
            elseif g[i][2].tooltip == "Frozen" then
                g[i][2].tooltip="Icy"
            elseif g[i][2].tooltip == "Fungus" then
                g[i][2].tooltip="Mushroom"
            elseif g[i][2].tooltip == "Hills" then
                g[i][2].tooltip="Knolls"
            elseif g[i][2].tooltip == "Impassable" then
                g[i][2].tooltip="How the hell have you got there!??"
            elseif g[i][2].tooltip == "Mountains" then
                g[i][2].tooltip="Massifs"
            elseif g[i][2].tooltip == "Sand" then
                g[i][2].tooltip="Beach"
            elseif g[i][2].tooltip == "Shallow Water" then
                g[i][2].tooltip="Shallows"
            elseif g[i][2].tooltip == "Swamp" then
                g[i][2].tooltip="Bog"
            elseif g[i][2].tooltip == "Unwalkable" then
                g[i][2].tooltip="Unwalkable\n\n        I mean you can try to jump into it"
            elseif g[i][2].tooltip == "Village" then
                g[i][2].tooltip="House"
            else
                g[i][2].tooltip="???"
            end
            i = i + 1
        end
    end
    return g
end
