local wibox=require("wibox")
local awful=require("awful")


local update_interval=20
local ram_info=wibox.widget.textbox()

local function update_widget(used_ram_percentage)
  ram_info.value = used_ram_percentage
end

local used_ram_script = [[
  bash -c "
  free -m | grep 'Mem:' | awk '{printf \"%d@@%d@\", $7, $2}'
  "]]

awful.widget.watch(used_ram_script, update_interval, function(widget, stdout)
                     local available = stdout:match('(.*)@@')
                     local total = stdout:match('@@(.*)@')
                     local used_ram_percentage = (total - available) / total * 100
                     update_widget(used_ram_percentage)
end)

return ram_info
