
-- this is 1 to 1 copy of code from revised Eastern Invasion - made by Dalas

-- to make code shorter
local wml_actions = wesnoth.wml_actions

-- metatable for GUI tags
local T = wml.tag

local font_size_title = 50000
local font_size_message = 30000
local font_size_submit_text = 30000
local font_size_note = 20000
local font_family_title = "Oldania ADF Std"
local font_family_message = "Oldania ADF Std"
local font_family_submit_text = "Oldania ADF Std"
local font_family_note = "Oldania ADF Std"

-- from the Wesnoth Lua Pack
-- [item_dialog]
-- an alternative interface to pick items
-- could be used in place of [message] with [option] tags
function wml_actions.item_dialog( cfg )
	local image_and_description = T.grid {
		T.row {
			T.column {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				border = "all",
				border_size = 5,
				T.image {
					id = "image_name"
				}
			},
			T.column {
				horizontal_alignment = "left",
				border = "all",
				border_size = 5,
				T.scroll_label {
					id = "item_description"
				}
			}
		}
	}

	local buttonbox = T.grid {
		T.row {
			T.column {
				T.button {
					id = "take_button",
					return_value = 1
				}
			},
			T.column {
				T.spacer {
					width = 10
				}
			},
			T.column {
				T.button {
					id = "leave_button",
					return_value = 2
				}
			}
		}
	}

	local item_dialog = {
		definition="menu",
		T.helptip { id="tooltip_large" }, -- mandatory field
		T.tooltip { id="tooltip_large" }, -- mandatory field
		T.grid{ T.row{
			T.column{ T.label{  use_markup=true,  label="<span size='40000'> </span>"  }},
			T.column{ border="right,left,bottom", border_size=18, T.grid{
				-------------------------
				-- TITLE
				-------------------------
				T.row{ T.column{ T.image{  label="icons/banner3.png"  }}},
				T.row{ T.column{ T.label{  use_markup=true,  label="<span size='8000'> </span>"  }}},
				T.row{ T.column{
					horizontal_alignment="center",
					T.label{  id="item_name",use_markup=true, definition="title",  }
				}},
				T.row{ T.column{ T.label{  use_markup=true,  label="<span size='15000'> </span>"  }}},
				-- Image and item description
				T.row {
					T.column {
						image_and_description
					}
				},
				-- Effect description
				T.row {
					T.column {
						horizontal_alignment = "left",
						border = "all",
						border_size = 5,
						T.label {
							wrap = true,
							id = "item_effect"
						}
					}
				},
				-- banner2
				-- T.row{ T.column{ T.label{  use_markup=true,  label="<span size='15000'> </span>"  }}}, --too big space this way
				T.row{ T.column {T.image{  label="icons/banner2.png"  }}},
				T.row{ T.column{ T.label{  use_markup=true,  label="<span size='15000'> </span>"  }}},
				-- button box
				T.row {
					T.column {
						buttonbox
					}
				}
			}
		}
	}}}
	local function item_preshow(dialog)
		-- here set all widget starting values
		dialog.item_description.use_markup = true
		dialog.item_effect.use_markup = true
		dialog.item_name.label = "<span size='"..font_size_title.."' font_family='"..font_family_title.."' >"..cfg.name.."</span>"
		dialog.image_name.label = cfg.image or ""
		dialog.item_description.label = "<span size='"..font_size_message.."' font_family='"..font_family_message.."' >"..cfg.description.."</span>"
		dialog.item_effect.label = "<span size='"..font_size_note.."' font_family='"..font_family_note.."' >"..cfg.effect.."</span>"
		dialog.take_button.label = "<span size='"..font_size_submit_text.."' font_family='"..font_family_submit_text.."' >"..cfg.take_string.."</span>" or wml.error( "Missing take_string= key in [item_dialog]" )
		dialog.take_button.use_markup = true
		dialog.leave_button.label = "<span size='"..font_size_submit_text.."' font_family='"..font_family_submit_text.."' >"..cfg.leave_string.."</span>" or wml.error( "Missing leave_string= key in [item_dialog]" )
		dialog.leave_button.use_markup = true
	end

	local function sync()
		local function item_postshow(dialog)
			-- here get all widget values
		end

		local return_value = gui.show_dialog( item_dialog, item_preshow, item_postshow )

		return { return_value = return_value }
	end

	local return_table = wesnoth.sync.evaluate_single(sync)
	if return_table.return_value == 1 or return_table.return_value == -1 then
		wml.variables[cfg.variable or "item_picked"] = "yes"
	else wml.variables[cfg.variable or "item_picked"] = "no"
	end
end

-- a variation for when you are required to take the item
function wml_actions.item_dialog_musttake( cfg )
	local image_and_description = T.grid {
		T.row {
			T.column {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				border = "all",
				border_size = 5,
				T.image {
					id = "image_name"
				}
			},
			T.column {
				horizontal_alignment = "left",
				border = "all",
				border_size = 5,
				T.scroll_label {
					id = "item_description"
				}
			}
		}
	}

	local buttonbox = T.grid {
		T.row {
			T.column {
				T.button {
					id = "take_button",
					return_value = 1
				}
			},
		}
	}

	local item_dialog = {
		definition="menu",
		T.helptip { id="tooltip_large" }, -- mandatory field
		T.tooltip { id="tooltip_large" }, -- mandatory field
		T.grid{ T.row{
			T.column{ T.label{  use_markup=true,  label="<span size='40000'> </span>"  }},
			T.column{ border="right,left,bottom", border_size=18, T.grid{
				-------------------------
				-- TITLE
				-------------------------
				T.row{ T.column{ T.image{  label="icons/banner3.png"  }}},
				T.row{ T.column{ T.label{  use_markup=true,  label="<span size='8000'> </span>"  }}},
				T.row{ T.column{
					horizontal_alignment="center",
					T.label{  id="item_name",use_markup=true, definition="title",  }
				}},
				T.row{ T.column{ T.label{  use_markup=true,  label="<span size='15000'> </span>"  }}},
				-- Image and item description
				T.row {
					T.column {
						image_and_description
					}
				},
				-- Effect description
				T.row {
					T.column {
						horizontal_alignment = "left",
						border = "all",
						border_size = 5,
						T.label {
							wrap = true,
							id = "item_effect"
						}
					}
				},
				-- banner2
				-- T.row{ T.column{ T.label{  use_markup=true,  label="<span size='15000'> </span>"  }}}, --too big space this way
				T.row{ T.column {T.image{  label="icons/banner2.png"  }}},
				T.row{ T.column{ T.label{  use_markup=true,  label="<span size='15000'> </span>"  }}},
				-- button box
				T.row {
					T.column {
						buttonbox
					}
				}
			}
		}
	}}}

	local function item_preshow(dialog)
		-- here set all widget starting values
		dialog.item_description.use_markup = true
		dialog.item_effect.use_markup = true
		dialog.item_name.label = "<span size='"..font_size_title.."' font_family='"..font_family_title.."' >"..cfg.name.."</span>"
		dialog.image_name.label = cfg.image or ""
		dialog.item_description.label = "<span size='"..font_size_message.."' font_family='"..font_family_message.."' >"..cfg.description.."</span>"
		dialog.item_effect.label = "<span size='"..font_size_note.."' font_family='"..font_family_note.."' >"..cfg.effect.."</span>"
		dialog.take_button.label = "<span size='"..font_size_submit_text.."' font_family='"..font_family_submit_text.."' >"..cfg.take_string.."</span>" or wml.error( "Missing take_string= key in [item_dialog]" )
		dialog.take_button.use_markup = true
	end

	local function sync()
		local function item_postshow(dialog)
			-- here get all widget values
		end

		local return_value = gui.show_dialog( item_dialog, item_preshow, item_postshow )

		return { return_value = return_value }
	end

	local return_table = wesnoth.sync.evaluate_single(sync)
	if return_table.return_value == 1 or return_table.return_value == -1 then
		wml.variables[cfg.variable or "item_picked"] = "yes"
	else wml.variables[cfg.variable or "item_picked"] = "no"
	end
end
