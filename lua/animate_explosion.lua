local Animation=wesnoth.units.create_animator()
for k,Victim in pairs(Victims) do
    --wesnoth.interface.float_label(Victim.x, Victim.y, "<span color='red'>"..Spell_Damage.."</span>")
    Animation:add(Victim, "defend", "hit")
end
Animation:run()
Animation:clear()