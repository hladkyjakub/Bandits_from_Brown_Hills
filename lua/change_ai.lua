local _ = wesnoth.textdomain "wesnoth-Bandits_from_Brown_Hills"
function wesnoth.wml_actions.change_ai(cfg)
    local side = cfg.side or 1
    for key, value in pairs(cfg) do
        if key ~= 'side' then
            wesnoth.wml_actions.modify_ai({
                action="delete",
                side=side,
                path="aspect["..key.."].facet[0]"
            })
            wesnoth.wml_actions.modify_side({
                side=side,
                {"ai",{[key]=value}}
            })
        end
    end
end

-- wesnoth.wml_actions.modify_side({side=side,{"ai",{aggression=0.7}}})
-- wesnoth.wml_actions.modify_ai({action="delete",side=2,path="aspect[".."aggression".."].facet[0]"})