-- Boilerplate to support localized strings if intllib mod is installed.
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s) return s end
end

local buttons = {}
local buttons_num = 0

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
			f = f .. "button["..
				"0,"..y..";3,1;"..
				"sfinv_button_"..minetest.formspec_escape(name)..";"..
				minetest.formspec_escape(def.title)..
				"]"
			y = y + 1
		end
		return sfinv.make_formspec(player, context, f)
	end,
	on_player_receive_fields = function(self, player, context, fields)
		if fields.sfinv_button1 then
			minetest.chat_send_player(player:get_player_name(), "Button 1 pressed!")
		end
	end,
})

-- Test
sfinv_buttons.register_button("button1", { title = "Button 1" })
sfinv_buttons.register_button("button2", { title = "Button 2" })
sfinv_buttons.register_button("button3", { title = "Button 3" })
sfinv_buttons.register_button("button4", { title = "Button 4" })
