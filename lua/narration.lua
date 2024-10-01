-- to make code shorter
local wml_actions = wesnoth.wml_actions
-- starting values
local font_size_title = 70000
local font_size_message = 70000
local font_size_listbox = 40000
local font_family_title = "Oldania ADF Std"
local font_family_message = "Oldania ADF Std"
local font_family_listbox = "Oldania ADF Std"
local color_title = "#baac7d"
local color_message = "#000000"
local color_listbox = "#FFFFFF"--"#000000"
-- metatable for GUI tags
local T = wml.tag
-- [narration]
-- an alternative interface for messages
-- TODO add [options], [text_input]
local wesnoth = wesnoth
function wml_actions.narration( cfg )
	local show_when_unit_hidden = cfg.show_when_unit_hidden or false
	local speaker_unit = true
	if cfg.speaker_unit == false then speaker_unit = false end
	local left_image = cfg.left_image
	local right_image = cfg.right_image
	local message = cfg.message or ""
	local unit
	local is_unit_hidden
	if speaker_unit == true then
		local filter = wml.shallow_literal(cfg)
		table.insert(filter, wml.tag.filter_vision{side = 1})
		filter = wml.tovconfig(filter)
		unit = wesnoth.units.find_on_map(filter)[1]
		if unit == nil then
			if show_when_unit_hidden == false then
				return
			else
				is_unit_hidden = true
				local filter = wml.shallow_literal(cfg)
				filter = wml.tovconfig(filter)
				unit = wesnoth.units.find_on_map(filter)[1]
				if unit == nil then
					return
				end
			end
		else
			wesnoth.interface.scroll_to_hex(unit.x,unit.y, false, false, true)
			wesnoth.interface.highlight_hex(unit.x,unit.y)
			wesnoth.interface.select_unit(unit,false,false)
			is_unit_hidden = false
		end
	end
	--TODO NOW SET IMAGE, IF ANY IMAGE IS PASSED, TO IT, ELSE LEFT FRIEND, RIGHT ENEMY
	if (speaker_unit == true) and (left_image == nil or left_image == "" ) and (cfg.right_image == nil or cfg.right_image == "") and (left_image ~= "no_image") then

		if wesnoth.units.find_on_map({id = unit.id, {'filter_side',{{'allied_with',{side = 1}}}}})[1] == nil then
			right_image = ""..unit.portrait.."~FL(horizontal)"
		else
			left_image = unit.portrait
		end
	end
	local left_image_width, left_image_height, right_image_width, right_image_height
	if left_image == nil or left_image == "" then
		left_image_width, left_image_height = 0, 0
	else
		left_image_width, left_image_height = filesystem.image_size(left_image)
	end
	if right_image == nil or right_image == "" then
		right_image_width, right_image_height = 0, 0
	else
		right_image_width, right_image_height = filesystem.image_size(right_image)
	end
	--if unit is hidden is_unit_hidden =
	local listbox_id = "monsters"

    local listboxItem = wml.tag.grid {
        wml.tag.row {
            -- wml.tag.column {
            --     wml.tag.image {
            --         id = "monster_image"
            --     }
            -- },
            wml.tag.column {
                wml.tag.label {
                    id = "label",
					use_markup = true
                }
            }
        }
    }

    local listboxDefinition =
	wml.tag.listbox {
		id = listbox_id,
		maximum_height = 400,
		definition="narration_listbox",--"narration_listbox"
        wml.tag.list_definition {
			maximum_height = 400,
            wml.tag.row {
                wml.tag.column {
                    wml.tag.toggle_panel {
                        listboxItem
                    }
                }
            }
        }
    }
	local narration = {
		definition="borderless_window",
		T.helptip { id="helptip_large" }, -- mandatory field
        T.tooltip { id="tooltip_large" }, -- mandatory field
        maximum_height = "(gamemap_height)",
        maximum_width = "(gamemap_width)",
        height = "(gamemap_height)",
        width = "(gamemap_width)",
        automatic_placement = false,
		-- vertical_placement = "bottom",
		-- horizontal_placement = "center",
        x=0,
    	y="(screen_height-gamemap_height)",
        vertical_grow = true,
        click_dismiss = false,
		T.grid {
			horizontal_grow = true,
			vertical_grow = true,
			T.row {
				vertical_grow = true,
				T.column {
					horizontal_grow = true,
					vertical_grow = true,
					T.stacked_widget{
						id = "narration_stacked_widget_1",
						definition = "default",
						horizontal_grow = true,
						vertical_grow = true,
						T.layer{
							horizontal_grow = true,
							vertical_grow = true,
							T.row {
								horizontal_grow = true,
								vertical_grow = true,
								T.column {
									vertical_alignment="bottom",
									horizontal_alignment = "left",
									grow_factor = 0,
									border = "all",
									border_size = 0,
									T.spacer{
										id = "left_image_place_holder",
										width = left_image_width,
										height = left_image_height
									}
								},
								T.column {
									horizontal_grow = true,
									vertical_alignment="bottom",
									grow_factor = 1,
									T.stacked_widget{
										id = "narration_stacked_widget",
										definition = "default",
										horizontal_grow = true,
										vertical_grow = true,
										T.layer{
											horizontal_grow = true,
											vertical_grow = true,
											T.row {
												T.column {
													horizontal_alignment = "center",
													grow_factor = 1,
													border = "all",
													border_size = 0,
													T.label {
														definition = "title",
														text_alignment = "center",
														id = "narration_title",
													}
												}
											},
											T.row {
												vertical_grow = true,
												T.column {
													horizontal_grow = true,
													horizontal_alignment = "center",
													grow_factor = 1,
													border = "all",
													border_size = 0,
													T.label {
														definition = "my_label",
														text_alignment = "center",
														id = "narration_message",
														wrap = true
													}
												} --TODO Why two columns doest work, 2 columns everywhere needed
											},
										},
									}
								},
								T.column {
									vertical_alignment="bottom",
									horizontal_alignment = "left",
									grow_factor = 0,
									border = "all",
									border_size = 0,
									T.spacer{
										id = "right_image_place_holder",
										width = right_image_width,
										height = right_image_height
									}
								}
							}
						},
						T.layer{ --TEST
							T.row {
								T.column {
									vertical_alignment="top",
									horizontal_alignment = "left",
									T.size_lock{
										height = 400,
                   		 				width = 600,
										T.widget {
											vertical_alignment="top",
											horizontal_alignment = "left",
											T.stacked_widget{
												id = "narration_stacked_widget_1",
												definition = "default",
												horizontal_grow = true,
												vertical_grow = true,
												T.layer{
													T.row {
														T.column {
															T.drawing {
																id = "background_drawing",
																width = 600,
																height = 400,
																T.draw {
																	T.image {
																		name = "gui/paper-1.png",
																		w = "(image_width)",
																		h = "(image_height)",
																		x="(600-image_width)",
																		y="(400-image_height)",
																	}
																}
															}
														}
													}
												},
												T.layer{
													T.row {
														T.column {
															grow_factor=0,
															listboxDefinition
														},
														T.column {
															grow_factor=1,
															T.spacer{
																width =1
															}
														}
													}
												},
											}
										}
									}
								}
							}
						},
					},
				}
			}
		}
	}
-- T.scroll_label {
-- 	definition = "text",
-- 	text_alignment = "center",
-- 	id = "narration_message",
-- }
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
    }

	--wml.get_child(wml.get_child(wml.get_child(wml.get_child(wml.get_child(def_wml, 'label_definition'), 'resolution'), 'state_enabled'), 'draw'), 'image')
	local narration_listbox = wml.load("~add-ons/Bandits_from_Brown_Hills/gui/narration_listbox.cfg")
	gui.add_widget_definition("listbox", "narration_listbox", wml.get_child(narration_listbox, 'listbox_definition'))
	local def_wml_borderless = wml.load("~add-ons/Bandits_from_Brown_Hills/gui/borderless_window.cfg")
	gui.add_widget_definition("window", "borderless_window", wml.get_child(def_wml_borderless, 'window_definition'))
	local def_wml = wml.load("~add-ons/Bandits_from_Brown_Hills/gui/my_label.cfg")
	local lbl_def = wml.get_child(def_wml, 'label_definition')
	local resolution = wml.get_child(lbl_def, 'resolution')
	local se = wml.get_child(resolution, 'state_enabled')
	local draw = wml.get_child(se, 'draw')
	local img = wml.get_child(draw, 'image')
	local strings = {"items/gohere-green.png","gui/paper-1.png"} --TODO testing
	img.name = "gui/paper-1.png"--strings[mathx.random(1, 2)] --TODO testing
	std_print(img.name)
	gui.add_widget_definition("label", "my_label", wml.get_child(def_wml, 'label_definition'))
	local function narration_preshow(dialog)
		local listbox = dialog[listbox_id]
		local i = 1
        for i, monster in ipairs(monsters) do
            -- listbox[i].monster_image.label = monster.image
            listbox[i].label.label = "<span size='"..font_size_listbox.."' font_family='"..font_family_listbox.."' color='"..color_listbox.."' >"..monsters[i].string.."</span>"
        end
		-- listbox[i].monster_image.label = monsters[i].image
        listbox[i].label.label = "<span size='"..font_size_listbox.."' font_family='"..font_family_listbox.."' color='"..color_listbox.."' >"..monsters[i].string.."</span>"
		local title
		if unit == nil then
			title = cfg.title or  "Narrator"
		else
			title = cfg.title or (tostring(unit.name) ~= "" and unit.name or unit.__cfg.language_name or "")
		end
		-- here set all widget starting values
		-- for testing wml.tag.rectangle { x = 0, y = 0, w = "(width)", h = "(height)", fill_color= "0,255,0,150"}
		-- wml.tag.text { x = 0, y = 0, w = "(width)", h = "(height)", text = message, font_size = 70, font_family = font_family_message, text_alignment = "center", text_markup = true, text_link_aware = true },
		dialog:set_canvas(1,{
			--wml.tag.rectangle { x = 0, y = 0, w = "(gamemap_width)", h = "(gamemap_height)", fill_color= "0,255,0,150"},
			-- wml.tag.text { x = left_image_width, y = "(height-text_height)", w = "(gamemap_width-"..(left_image_width + right_image_width)..")", h = "(text_height)",
			-- font_size = 70 ,maximum_width="(gamemap_width-"..(left_image_width + right_image_width)..")",actions="(set_var('th', 200))",
			-- text="MEOW"},
			wml.tag.image { x = 0, y = "(height-image_height)", w = "(image_width)", h = "(image_height)", name = left_image},
			wml.tag.image { x = "(gamemap_width-image_width)", y = "(height-image_height)", w = "(image_width)", h = "(image_height)", name = right_image},
			-- wml.tag.text { x = left_image_width, y = "(height-text_height)", w = "(gamemap_width-"..(left_image_width + right_image_width)..")", h = "(text_height)",
			-- font_size = 70 ,maximum_width="(gamemap_width-"..(left_image_width + right_image_width)..")",
			-- text="adjwo;f lafha fi. f.amd  afoijwf l.maf ,a ja;f laf maf mfawf ff; mf f efeifefsglo g;oisfkocka leze dirou pes okn ekm takze pujade n me"},
			-- wml.tag.image { x = left_image_width, y = "(gamemap_height)", h = "(image_height)", name = "gui/paper-1.png"},
		} )
		dialog.narration_stacked_widget.narration_message.visible = true
        dialog.narration_stacked_widget.narration_title.visible = true
		--dialog.on_left_click = dialog:close() BREAKS WESNOTH
		dialog.narration_title.use_markup = true
		dialog.narration_message.use_markup = true

		-- dialog.left_image.label = left_image
		-- dialog.right_image.label = right_image
		dialog.narration_title.label = "<span size='"..font_size_title.."' font_family='"..font_family_title.."' color='"..color_title.."' >"..title.."</span>"
		dialog.narration_message.label = "<span size='"..font_size_message.."' font_family='"..font_family_message.."' color='"..color_message.."' >"..message.."</span><span size='60000'>\n </span>"
		--dialog.image_name.label = cfg.image or ""
	end
	local function narration_postshow(dialog)
		-- here get all widget values
	end
	-- close_func = function close_dialog(dialog)
	-- 	dialog:close()
   	-- end
   	-- dialog:find("narration_message").on_left_click = close_func
	gui.show_dialog( narration, narration_preshow, narration_postshow )
end