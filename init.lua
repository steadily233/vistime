require("vis")

local M = {}

local MODES = {
	[vis.modes.NORMAL] = " Normal ",
	[vis.modes.INSERT] = " Insert ",
	[vis.modes.VISUAL] = " Visual ",
}

vis.events.subscribe(vis.events.WIN_STATUS, function(win)

	local time = os.date("%H:%M")
	local mode = MODES[vis.mode]
	local modified = " | | "
	if win.file.modified then modified = " |+| " end
	local filename = "No name given" 
	if win.file.name then filename = win.file.name end
	local cursor_pos = win.selection.line..":"..win.selection.col
	local status_left = mode.." "..filename..modified
	local status_right = time .." "..cursor_pos
	win:status(status_left, status_right)
end)

return M
