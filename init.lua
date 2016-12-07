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

sfinv.register_page("sfinv_buttons:buttons", {
	title = S("More"),
	is_in_nav = function(self, player, context)
		return buttons_num > 0
	end,
	get = function(self, player, context)
		local f = ""
		local y = 0
		for name, def in pairs(buttons) do
			if def.image ~= nil then
				f = f .. "image[0.1,"..(y+0.1)..";0.8,0.8;"..def.image.."]"
			end
			f = f .. "button["..
				"1,"..y..";3,1;"..
				button_prefix..minetest.formspec_escape(name)..";"..
				minetest.formspec_escape(def.title)..
				"]"
			y = y + 1
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

-- Test
sfinv_buttons.register_button("button1", { title = "Button 1" })
sfinv_buttons.register_button("button2", { title = "Button 2" })
sfinv_buttons.register_button("button3", { title = "Button 3" })
sfinv_buttons.register_button("button4", { title = "Button 4" })
