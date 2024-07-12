--wml.variables["line_of_sight_hexes"]
local function isLineOfSightBlocked(x1, y1, x2, y2)
    local hexes = {}
    
    -- Function to calculate the axial coordinates from cubic coordinates
    local function axialFromCubic(x, y, z)
        return x, z
    end

    -- Function to calculate the cube coordinates from axial coordinates
    local function cubicFromAxial(q, r)
        local x = q
        local z = r
        local y = -x - z
        return x, y, z
    end

    -- Function to calculate the distance between two hexes
    local function hexDistance(q1, r1, q2, r2)
        local x1, y1, z1 = cubicFromAxial(q1, r1)
        local x2, y2, z2 = cubicFromAxial(q2, r2)
        return (math.abs(x1 - x2) + math.abs(y1 - y2) + math.abs(z1 - z2)) / 2
    end
    std_print("  x1 = "..wml.variables["lua_line_of_sight_start_x"].."  y1 = "..wml.variables["lua_line_of_sight_start_y"].."  x2 = "..wml.variables["lua_line_of_sight_end_x"].."  y2 = "..wml.variables["lua_line_of_sight_end_y"])
    -- Convert start and end coordinates to axial
    local q1, r1 = axialFromCubic(x1, -x1 - y1, y1)
    local q2, r2 = axialFromCubic(x2, -x2 - y2, y2)

    -- Determine the step size for the line
    local steps = math.max(hexDistance(q1, r1, q2, r2), 1)
    local stepSize = 1 / steps

    -- Calculate the step increments in axial coordinates
    local dq = (q2 - q1) * stepSize
    local dr = (r2 - r1) * stepSize

    -- Iterate over each step and convert back to cube coordinates
    std_print("  x1 = "..x1.."  y1 = "..y1.."  x2 = "..x2.."  y2 = "..y2)
    for i = 0, steps do
        local q = q1 + dq * i
        local r = r1 + dr * i

        -- Convert axial coordinates back to cube
        local x, y, z = cubicFromAxial(q, r)

        -- Round cube coordinates to nearest integer
        local rx = math.floor(x + 0.5)
        local ry = math.floor(y + 0.5)
        local rz = math.floor(z + 0.5)

        -- Convert cube coordinates to axial
        local hx, hy = axialFromCubic(rx, ry, rz)

        -- Append the hex to the list
        table.insert(hexes, {hx, hy})
        wml.variables["line_of_sight_hexes["..i.."].x"] = hx
        wml.variables["line_of_sight_hexes["..i.."].y"] = hy
        local terrain_type=wesnoth.map.get(hx,hy)["terrain"]
        std_print("  hx = "..hx.."  hy = "..hy)
        -- MAKE HERE 2 FOR LOOPS IF MORE THAN ONE TERRAIN (X*) BLOCKS THE VISION!!!
        if string.find(tostring(terrain_type), tostring(wml.variables["lua_line_of_sight_blocking_terrains"]),1, true) then
            wml.variables["is_line_of_sight_blocked"] = "yes"
            return true
        end
    end
    wml.variables["is_line_of_sight_blocked"] = "no"
    return false
end
-- local line_of_sight_hexes = getHexesCrossed(startX, startY, endX, endY)

-- std_print("Hexes crossed by the line of sight:")
-- for _, hex in ipairs(line_of_sight_hexes) do
--     std_print(hex[1], hex[2])
   -- wml.variables["line_of_sight_hexes.x"] = hex[1]
   -- wml.variables["line_of_sight_hexes.y"] = hex[2]
-- end
--std_print("isLineOfSightBlocked runned")
isLineOfSightBlocked(tonumber(wml.variables["lua_line_of_sight_start_x"]), tonumber(wml.variables["lua_line_of_sight_start_y"]), tonumber(wml.variables["lua_line_of_sight_end_x"]), tonumber(wml.variables["lua_line_of_sight_end_y"]))
-- now put it into a wml.variable
--wml.variables["line_of_sight_hexes[$i].y"]
