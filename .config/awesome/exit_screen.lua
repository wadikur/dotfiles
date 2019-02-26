local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local helpers = require("helpers")
local pad = helpers.pad
local keygrabber = require("awful.keygrabber")

-- Appearance
local icon_size = beautiful.exit_screen_icon_size or 140
local text_font = beautiful.exit_screen_font or "sans 14"

-- Commands
local poweroff_command = function()
  awful.spawn.with_shell("poweroff")
  awful.keygrabber.stop(exit_screen_grabber)
end
local reboot_command = function()
  awful.spawn.with_shell("reboot")
  awful.keygrabber.stop(exit_screen_grabber)
end
local suspend_command = function()
  awful.spawn.with_shell("i3lock -i $HOME/Pictures/Wallpaper/cyberpunk.png & systemctl suspend")
  exit_screen_hide()
end
local exit_command = function()
  awesome.quit()
end
local lock_command = function()
  awful.spawn.with_shell("i3lock -i $HOME/Pictures/Wallpaper/cyberpunk.png")
  exit_screen_hide()
end

local username = os.getenv("USER")
-- Capitalize username
local goodbye_widget = wibox.widget.textbox("Goodbye " .. username:sub(1,1):upper()..username:sub(2))
goodbye_widget.font = "sans 50"

local poweroff_icon = wibox.widget.imagebox(beautiful.poweroff_icon)
poweroff_icon.resize = true
poweroff_icon.forced_width = icon_size
poweroff_icon.forced_height = icon_size
local poweroff_text = wibox.widget.textbox("Poweroff")
poweroff_text.font = text_font

local poweroff = wibox.widget{
  {
    pad(0),
    poweroff_icon,
    pad(0),
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  {
    pad(1),
    poweroff_text,
    pad(1),
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  layout = wibox.layout.fixed.vertical
}
poweroff:buttons(gears.table.join(
                 awful.button({ }, 1, function ()
                     poweroff_command()
                 end)
))

local reboot_icon = wibox.widget.imagebox(beautiful.reboot_icon)
reboot_icon.resize = true
reboot_icon.forced_width = icon_size
reboot_icon.forced_height = icon_size
local reboot_text = wibox.widget.textbox("Reboot")
reboot_text.font = text_font

local reboot = wibox.widget{
  {
    pad(0),
    reboot_icon,
    pad(0),
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  {
    pad(0),
    reboot_text,
    pad(0),
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  layout = wibox.layout.fixed.vertical
}
reboot:buttons(gears.table.join(
                   awful.button({ }, 1, function ()
                       reboot_command()
                   end)
))

local suspend_icon = wibox.widget.imagebox(beautiful.suspend_icon)
suspend_icon.resize = true
suspend_icon.forced_width = icon_size
suspend_icon.forced_height = icon_size
local suspend_text = wibox.widget.textbox("Suspend")
suspend_text.font = text_font

local suspend = wibox.widget{
  {
    pad(0),
    suspend_icon,
    pad(0),
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  {
    pad(0),
    suspend_text,
    pad(0),
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  layout = wibox.layout.fixed.vertical
}
suspend:buttons(gears.table.join(
                 awful.button({ }, 1, function ()
                     suspend_command()
                 end)
))


local exit_icon = wibox.widget.imagebox(beautiful.exit_icon)
exit_icon.resize = true
exit_icon.forced_width = icon_size
exit_icon.forced_height = icon_size
local exit_text = wibox.widget.textbox("Exit")
exit_text.font = text_font

local exit = wibox.widget{
  {
    pad(0),
    exit_icon,
    pad(0),
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  {
    pad(0),
    exit_text,
    pad(0),
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  layout = wibox.layout.fixed.vertical
}
exit:buttons(gears.table.join(
                  awful.button({ }, 1, function ()
                      exit_command()
                  end)
))

local lock_icon = wibox.widget.imagebox(beautiful.lock_icon)
lock_icon.resize = true
lock_icon.forced_width = icon_size
lock_icon.forced_height = icon_size
local lock_text = wibox.widget.textbox("Lock")
lock_text.font = text_font

local lock = wibox.widget{
  {
    pad(0),
    lock_icon,
    pad(0),
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  {
    pad(1),
    lock_text,
    pad(1),
    expand = "none",
    layout = wibox.layout.align.horizontal
  },
  layout = wibox.layout.fixed.vertical
}
lock:buttons(gears.table.join(
                   awful.button({ }, 1, function ()
                       lock_command()
                   end)
))

-- Get screen geometry
local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

-- Create the widget
exit_screen = wibox({x = 0, y = 0, visible = false, ontop = true, type = "dock", height = screen_height, width = screen_width})

exit_screen.bg = beautiful.exit_screen_bg or beautiful.wibar_bg or "#111111"
exit_screen.fg = beautiful.exit_screen_fg or beautiful.wibar_fg or "#FEFEFE"

local exit_screen_grabber
function exit_screen_hide()
  awful.keygrabber.stop(exit_screen_grabber)
  exit_screen.visible = false
end
function exit_screen_show()
  -- naughty.notify({text = "starting the keygrabber"})
  exit_screen_grabber = awful.keygrabber.run(function(_, key, event)
      if event == "release" then return end

      if     key == 's'    then
        suspend_command()
      elseif key == 'e'    then
        exit_command()
      elseif key == 'l'    then
        lock_command()
      elseif key == 'p'    then
        poweroff_command()
      elseif key == 'r'    then
        reboot_command()
      elseif key == 'Escape' or key == 'q' or key == 'x' then
        -- naughty.notify({text = "Cancel"})
        exit_screen_hide()
      -- else awful.keygrabber.stop(exit_screen_grabber)
      end
  end)
  exit_screen.visible = true
end

exit_screen:buttons(gears.table.join(
                 -- Middle click - Hide exit_screen
                 awful.button({ }, 2, function ()
                     exit_screen_hide()
                 end),
                 -- Right click - Hide exit_screen
                 awful.button({ }, 3, function ()
                     exit_screen_hide()
                 end)
))

-- Item placement
exit_screen:setup {
  pad(0),
  {
    {
      pad(0),
      goodbye_widget,
      pad(0),
      expand = "none",
      layout = wibox.layout.align.horizontal
    },
    {
      pad(0),
      {
        -- {
          poweroff,
          pad(3),
          reboot,
          pad(3),
          suspend,
          pad(3),
          exit,
          pad(3),
          lock,
          layout = wibox.layout.fixed.horizontal
        -- },
        -- widget = exit_screen_box
      },
      pad(0),
      expand = "none",
      layout = wibox.layout.align.horizontal
      -- layout = wibox.layout.fixed.horizontal
    },
    layout = wibox.layout.fixed.vertical
  },
  pad(0),
  expand = "none",
  layout = wibox.layout.align.vertical
}
