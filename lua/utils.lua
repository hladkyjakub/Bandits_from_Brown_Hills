function Shake_Screen(Table)
    --Example call: Shake_Screen({Time=1000, Strength=10}) 
    local total_ms=0
    while true do
        dx=math.random(-Table.Strength, Table.Strength)
        dy=math.random(-Table.Strength, Table.Strength)
        ms=math.random(30, 60)
        wesnoth.interface.scroll(dx, dy)
        if total_ms+ms>Table.Time then
            ms=Table.Time-total_ms
            wesnoth.interface.delay(ms)
            wesnoth.interface.scroll(-dx, -dy)
            return
        end
        total_ms=total_ms+ms
        wesnoth.interface.delay(ms)
        wesnoth.interface.scroll(-dx, -dy)
    end
end