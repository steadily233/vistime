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

vis.events.subscribe(vis.events.WIN_STATUS, function(win)
	local time = os.date("%H:%M")
	local mode = MODES[vis.mode]
	local modified = " | | "
	if win.file.modified then modified = " |+| " end
	local filename = "No name given" 
	if win.file.name then filename = win.file.name end
	local cursor_status = win.selection.line..":"..win.selection.col
	local status_left = mode.." "..filename..modified
	local status_right = time .." "..cursor_status
	win:status(status_left, status_right)
end)

-- Insert current time function
local insert_time = vis:action_register("info", function()
	local pos = vis.win.selection.pos
	local time = os.date("%H:%M")
	vis.win.file:insert(pos, time)
	vis.win.selection.pos = pos + #time
	vis.win:draw()
	vis:info("Date inserted")
end, "Insert current time")

hotkey_time = "gt"

vis:map(vis.modes.NORMAL, hotkey_time, insert_time)

return M
