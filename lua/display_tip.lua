--------------------------------------------------------------------
--- This code was originally designed by DALAS with some changes ---
---------------------- Thanks for the code <3 ----------------------
--------------------------------------------------------------------
local _ = wesnoth.textdomain "wesnoth-Bandits_from_Brown_Hills"

local font_size_title = 50000
local font_size_message = 30000
local font_size_submit_text = 30000
local font_family_title = "Oldania ADF Std"
local font_family_message = "Oldania ADF Std"
local font_family_submit_text = "Oldania ADF Std"

function display_tip(cfg)
	local T = wml.tag

	local tutor_title = cfg.title
	local tutor_message = cfg.message
	local tutor_image = cfg.image
	local submit_text = cfg.submit_text

	--###############################
	-- DEFINE GRID
	--###############################
	local grid = T.grid{ T.row{
		T.column{ T.label{  use_markup=true,  label="<span size='40000'> </span>"  }},
		T.column{ border="right,left,bottom", border_size=18, T.grid{
			-------------------------
			-- TITLE
			-------------------------
			T.row{ T.column{ T.image{  label="icons/banner3.png"  }}},
			T.row{ T.column{ T.label{  use_markup=true,  label="<span size='8000'> </span>"  }}},
			T.row{ T.column{
				horizontal_alignment="center",
				T.label{  use_markup=true, definition="title",  label="<span size='"..font_size_title.."' font_family='"..font_family_title.."' >"..tutor_title.."</span>",  } --Tip:
			}},
			T.row{ T.column{ T.label{  use_markup=true,  label="<span size='15000'> </span>"  }}},
			-------------------------
			-- INFO
			-------------------------
			T.row{ T.column{ T.grid{ T.row{
				T.column{
					horizontal_alignment="left",
					T.label{
						use_markup=true,
						label="<span size='"..font_size_message.."' font_family='"..font_family_message.."' >"..tutor_message.."</span>",
					}
				},
				T.column{ T.label{  use_markup=true,  label="<span size='80000'> </span>"  }},
				T.column{
					T.image{  label=tutor_image  }
				},
			}}}},
			T.row{ T.column{ T.label{  use_markup=true,  label="<span size='15000'> </span>"  }}},
			T.row{ T.column {T.image{  label="icons/banner2.png"  }}},
			T.row{ T.column{ T.label{  use_markup=true,  label="<span size='15000'> </span>"  }}},
			-------------------------
			-- BUTTONS
			-------------------------
			T.row{T.column{ T.grid{ T.row{
				T.column{ T.button{
					return_value=1, use_markup=true,
					label="<span size='"..font_size_submit_text.."' font_family='"..font_family_submit_text.."' >"..submit_text.."</span>",
				}},
				-- T.column{ T.label{  use_markup=true,  label="<span size='15000'>     </span>"  }},
				-- T.column{ T.button{
				-- 	return_value=2, use_markup=true,
				-- 	label=_"Disable Tip Popups & Dialogue",
				-- }},
			}}}},
		}},
		T.column{ T.label{  use_markup=true,  label="<span size='40000'> </span>"  }},
	}}

	--###############################
	-- CREATE DIALOG
	--###############################
	local result = wesnoth.sync.evaluate_single(function()
		local button = gui.show_dialog({
			definition="menu",
			T.helptip{ id="tooltip_large" }, -- mandatory field
			T.tooltip{ id="tooltip_large" }, -- mandatory field
			grid
		})
		if (button==2) then wml.variables['enable_tutorial_elements']='no' end
		return { button=button }
	end)
end
function wesnoth.wml_actions.display_tip(cfg)
	display_tip(cfg)
end