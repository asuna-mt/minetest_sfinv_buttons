-- Boilerplate to support localized strings if intllib mod is installed.
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s) return s end
end

local buttons = {}
local buttons_num = 0

local button_prefix = "sfinv_button_"

sfinv_buttons = {}


sfinv_buttons.register_button = function(name, def)
	buttons[name] = def
	buttons_num = buttons_num + 1
end

local MAX_ROWS = 9

sfinv.register_page("sfinv_buttons:buttons", {
	title = S("More"),
	is_in_nav = function(self, player, context)
		return buttons_num > 0
	end,
	get = function(self, player, context)
		local f = ""
		local y = 0
		local x = 0
		local w
		if buttons_num > MAX_ROWS then
			w = 3
		else
			w = 7
		end
		for name, def in pairs(buttons) do
			if def.show == nil or def.show(player) == true then
				if def.image ~= nil then
					f = f .. "image["..(x+0.1)..","..(y+0.1)..";0.8,0.8;"..def.image.."]"
				end
				local button_id = minetest.formspec_escape(button_prefix .. name)
				f = f .. "button["..
					(x+1)..","..y..";"..w..",1;"..
					button_id..";"..
					minetest.formspec_escape(def.title)..
					"]"
				if def.tooltip ~= nil then
					f = f .. "tooltip["..button_id..";"..
						minetest.formspec_escape(def.tooltip).."]"
				end
				y = y + 1
				if y >= MAX_ROWS then
					y = 0
					x = x + 4
				end
			end
		end
		return sfinv.make_formspec(player, context, f)
	end,
	on_player_receive_fields = function(self, player, context, fields)
		for widget_name, _ in pairs(fields) do
			local id = string.sub(widget_name, string.len(button_prefix) + 1, -1)
			if buttons[id] ~= nil and buttons[id].action ~= nil then
				buttons[id].action(player)
			end
		end
	end,
})
