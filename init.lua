require("vis")

local M = {}

local MODES = {
	[vis.modes.NORMAL] = " Normal ",
	[vis.modes.INSERT] = " Insert ",
	[vis.modes.VISUAL] = " Visual ",
	[vis.modes.REPLACE] = " Replace ",
	[vis.modes.VISUAL_LINE] = " Visual Line ",
	[vis.modes.OPERATOR_PENDING] = " Operator Pending ",
}
local Style_id = 51
local Style_inverted_id = 52

local Styles = {
	[vis.modes.NORMAL] = {
		REGULAR = 'fore:black,back:yellow',
		INVERTED = 'fore:yellow,back:black',
	},
	[vis.modes.INSERT] = {
		REGULAR = 'fore:default,back:blue',
		INVERTED = 'fore:green,back:black',
	},
	[vis.modes.VISUAL] = {
		REGULAR = 'fore:default,back:magenta',
		INVERTED = 'fore:magenta,back:black',
	},
	[vis.modes.REPLACE] = {
		REGULAR = 'fore:default,back:red',
		INVERTED = 'fore:blue,back:black',
	},
	[vis.modes.VISUAL_LINE] = {
		REGULAR = 'fore:default,back:magenta',
		INVERTED = 'fore:magenta,back:black',
	},
	[vis.modes.OPERATOR_PENDING] = {
		REGULAR = 'fore:default,back:blue',
		INVERTED = 'fore:blue,back:black',
	},
	UNFOCUSED = {
		REGULAR = 'fore:black,back:white',
		INVERTED = 'fore:white,back:black',
	},
}

-- status bar 
vis.events.subscribe(vis.events.WIN_STATUS, function(win)
	local time = os.date("%H:%M")
	local mode = MODES[vis.mode]
	local modified = " | | "
	if win.file.modified then modified = " |+| " end
	local filename = "No name given" 
	if win.file.name then filename = win.file.name end
	local cursor_status = win.selection.line..":"..win.selection.col
	local status_left = mode.." "..filename..modified
	local status_right = time .." "..cursor_status .." "
	win:status(status_left, status_right)
	for win in vis:windows() do
		if win == vis.win then
			win:style_define(Style_id, Styles[vis.mode].REGULAR)
			win:style_define(Style_inverted_id, Styles[vis.mode].INVERTED)
	else
		win:style_define(Style_id, Styles.UNFOCUSED.REGULAR)
		win:style_define(Style_inverted_id, Styles.UNFOCUSED.INVERTED)
		end
	end
	for i=0,win.width do
		win:style_pos(Style_id, i, win.height - 1)
	end
end)

-- Insert current time function
local insert_time = vis:action_register("time", function()
	local pos = vis.win.selection.pos
	local time = os.date("%H:%M")
	vis.win.file:insert(pos, time)
	vis.win.selection.pos = pos + #time
	vis.win:draw()
	vis:info("Time inserted")
end, "Insert current time")

hotkey_time = "gt"
vis:map(vis.modes.NORMAL, hotkey_time, insert_time)

-- Insert current date function
local insert_date = vis:action_register("date", function()
	local pos = vis.win.selection.pos
	local date = os.date("%d.%m.%y")
	vis.win.file:insert(pos, date)
	vis.win.selection.pos = pos + #date
	vis.win:draw()
	vis:info("Date inserted")
end, "Insert current date")

local hotkey_date = "gd"
vis:map(vis.modes.NORMAL, hotkey_date, insert_date)

return M
