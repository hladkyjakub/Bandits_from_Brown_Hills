--alias l1=lua wesnoth.dofile("~add-ons/Bandits_from_Brown_Hills/test_Lua_event_1.lua")

local _ = wesnoth.textdomain "wesnoth-Bandits_from_Brown_Hills"
local my_listbox = wml.load("~add-ons/Bandits_from_Brown_Hills/my_listbox.cfg")
gui.add_widget_definition("listbox", "my_listbox", wml.get_child(my_listbox, 'listbox_definition'))
local narration_listbox = wml.load("~add-ons/Bandits_from_Brown_Hills/gui/narration_listbox.cfg")
gui.add_widget_definition("listbox", "narration_listbox", wml.get_child(narration_listbox, 'listbox_definition'))

function gui_with_listbox()
    local monsters = {
        { image = "units/trolls/grunt.png",
          string = "A troll" },
        { image = "units/monsters/cuttlefish.png",
          string = "A cuttlefish" },
        { image = "units/monsters/yeti.png",
          string = "A yeti" },
          { image = "units/trolls/grunt.png",
          string = "A troll" },
        { image = "units/monsters/cuttlefish.png",
          string = "A cuttlefish" },
        { image = "units/monsters/yeti.png",
          string = "A yeti" },
          { image = "units/trolls/grunt.png",
          string = "A troll" },
        { image = "units/monsters/cuttlefish.png",
          string = "A cuttlefish" },
        { image = "units/monsters/yeti.png",
          string = "A yeti" },
          { image = "units/trolls/grunt.png",
          string = "A troll" },
        { image = "units/monsters/cuttlefish.png",
          string = "A cuttlefish" },
        { image = "units/monsters/yeti.png",
          string = "A yeti" },
          { image = "units/trolls/grunt.png",
          string = "A troll" },
        { image = "units/monsters/cuttlefish.png",
          string = "A cuttlefish" },
        { image = "units/monsters/yeti.png",
          string = "A yeti" }
    }

    local listbox_id = "monsters"

    local listboxItem = wml.tag.grid {
        -- horizontal_grow = true,
        wml.tag.row {
            -- grow_factor = 1,
            -- vertical_grow = true,
            -- horizontal_grow = true,
            -- horizontal_alignment = "left",
            -- wml.tag.column {
            --     horizontal_alignment = "left",
            --     wml.tag.image {
            --         id = "monster_image"
            --     }
            -- },
            wml.tag.column {
                -- grow_factor = 1,
                -- vertical_grow = true,
                -- horizontal_grow = true,
                horizontal_alignment = "left",
                wml.tag.label {
                    horizontal_alignment = "left",
                    id = "label",
                    use_markup = true,
                    text_alignment = "left",
                }
            },
            -- wml.tag.column {
            --     grow_factor = 1,
            --     vertical_grow = true,
            --     horizontal_grow = true,
            --     horizontal_alignment = "left",
            --     wml.tag.spacer{

            --     }
            -- },
        }
    }
    local listboxDefinition =
    wml.tag.listbox {
        definition="my_listbox",
        id = listbox_id,
        wml.tag.list_definition {
            wml.tag.row {
                wml.tag.column {
                    grow_factor = 1,
                    horizontal_grow = true,
                    wml.tag.toggle_panel {
                        listboxItem
                    }
                }
            }
        }
        -- wml.tag.listbox {
        --     id = listbox_id,
        --     maximum_height = 400,
        --     definition="default_listbox",--"narration_listbox"
        --     wml.tag.list_definition {
        --         maximum_height = 400,
        --         wml.tag.row {
        --             wml.tag.column {
        --                 wml.tag.toggle_panel {
        --                     listboxItem
        --                 }
        --             }
        --         }
        --     }
        -- }
    }

    local dialogDefinition = {
        wml.tag.tooltip { id = "tooltip_large" },
        wml.tag.helptip { id = "tooltip_large" },
        wml.tag.grid {
            -- wml.tag.row {  -- A header
            --     wml.tag.column {
            --         border = "bottom",
            --         border_size = 10,
            --             wml.tag.label {
            --                 use_markup = true,
            --                 label = "<span size='large'>" .. _"Here there be " ..
            --                     "<span color='yellow'>" ..
            --                     _"MONSTERS!" .. "</span></span>"
            --             }
            --         }
            --     },
            wml.tag.row {  -- The body of our GUI
                wml.tag.column {
                    listboxDefinition
                }
            },
            -- wml.tag.row {
            --     wml.tag.column {
            --         wml.tag.button {
            --             id = "ok",
            --             label = _"OK"
            --         }
            --     }
            -- }
        }
    }

    local function preshow(dialog)  -- Prepare the GUI before display
        local listbox = dialog[listbox_id]
            for i, monster in ipairs(monsters) do
                --listbox[i].monster_image.label = monster.image
                listbox[i].label.label = monster.string
            end
    end
    gui.show_dialog(dialogDefinition,preshow)
end

gui_with_listbox()