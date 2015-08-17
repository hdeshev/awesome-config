-- Standard awesome library
local awful = require("awful")
awful.rules = require("awful.rules")
awful.autofocus = require("awful.autofocus")
local awesome = require("awesome")
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")

local vicious = require("vicious")

function trim(s)
  return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

function eprint(message)
  io.stderr:write(message .. "\n")
end

local hostname = trim(awful.util.pread("hostname"))
local terminal = "xfce4-terminal"

-- Variable definitions
local spawn      = awful.util.spawn

local modkey     = "Mod4"

local home       = os.getenv("HOME")
local editor     = os.getenv("EDITOR") or "vim"

local editor_cmd = terminal .. " -e " .. editor

local monitor_config_script = home .. "/.screenlayout/2monitors.sh"
if awful.util.file_readable(monitor_config_script) then
  -- use pread to force waiting for child process to complete
  awful.util.pread(monitor_config_script)
end

-- Initialize theme
beautiful.init(home .. "/.config/awesome/theme.lua")

-- Layout table
layouts = {
  awful.layout.suit.floating,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.right,
  awful.layout.suit.max,
}

-- Tags/workspaces
function merge(target, offset, tags)
  for i, v in ipairs(tags) do
    target[i + offset] = v
  end
end

-- Tags 1-4 go on the first screen. 5-9 -- on the second.
-- If we have only one screen, everything goes there
SCREEN_1 = 1
SCREEN_2 = 1
if screen.count() > 1 then
  SCREEN_2 = 2
end

function screen_for_tag(tag_index)
  if tag_index <= 4 then
    return SCREEN_1
  else
    return SCREEN_2
  end
end

tags = {}

-- different tags have different layouts
merge(tags, 0, awful.tag.new({ 1, 2, 3, 4, 5 }, SCREEN_1, awful.layout.suit.tile.left))
merge(tags, 5, awful.tag.new({ 6, 7 }, SCREEN_2, awful.layout.suit.tile.left))
merge(tags, 7, awful.tag.new({ 8, 9 }, SCREEN_2, awful.layout.suit.floating))
merge(tags, 9, awful.tag.new({ "B" }, SCREEN_2, awful.layout.suit.tile.left))

main_menu = awful.menu({ items = { 
                                    -- { "Debian", debian.menu.Debian_menu.Debian },
                                    { "reload", awesome.restart },
                                    { "logoff", awesome.quit },
                                    { "open terminal", terminal }
                                  }})

launcher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = main_menu })
-- }}}

function colorize(color, string)
  return '<span color="'..color..'">'..string..'</span>'
end

-- Textclock widget
text_clock = awful.widget.textclock()

--- RAM ---
mem_widget = widget({ type = "textbox" })
vicious.register(mem_widget, vicious.widgets.mem, " $1% RAM |", 13)


--- CPU ---
cpu_widget = widget({ type = "textbox" })
vicious.register(cpu_widget, vicious.widgets.cpu, " $1% CPU |")

--- Volume ---
volume_widget = widget({ type = "textbox" })
vicious.register(volume_widget, vicious.widgets.volume, " $1% ($2) |", 2, "-D pulse Master")

-- Separator
separator = widget { type = "textbox" }
separator.text = '<span color="#ee1111"> :: </span>'

-- Create a systray
systray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
my_wibox = {}
prompt_box = {}
layout_box = {}
my_taglist = {}
my_taglist.buttons = awful.util.table.join(
  awful.button({ },        1, awful.tag.viewonly),
  awful.button({ modkey }, 1, awful.client.movetotag),
  awful.button({ },        3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, awful.client.toggletag),
  awful.button({ },        4, awful.tag.viewnext),
  awful.button({ },        5, awful.tag.viewprev)
)

tasklist = {}
tasklist.buttons = awful.util.table.join(
  awful.button({ }, 1, function (c)
    if not c:isvisible() then
      awful.tag.viewonly(c:tags()[1])
    end
    client.focus = c
    c:raise()
  end),

  awful.button({ }, 3, function ()
    if instance then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({ width=250 })
    end
  end),

  awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
    if client.focus then client.focus:raise() end
  end),

  awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
  end)
)

for s = 1, screen.count() do
  -- Create a promptbox for each screen
  prompt_box[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })

  -- Image box with the layout we're using
  layout_box[s] = awful.widget.layoutbox(s)
  layout_box[s]:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
    awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
    awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
    awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
  ))

  -- Create a taglist widget
  my_taglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, my_taglist.buttons)

  -- Create a tasklist widget
  tasklist[s] = awful.widget.tasklist(function(c)
    return awful.widget.tasklist.label.currenttags(c, s)
  end, tasklist.buttons)

  -- Create the wibox
  my_wibox[s] = awful.wibox({ position = "top", screen = s })

 -- Add widgets to the wibox - order matters
  my_wibox[s].widgets = {
    {
      launcher,
      my_taglist[s],
      prompt_box[s],

      layout = awful.widget.layout.horizontal.leftright
    },
    layout_box[s],
    text_clock,
    separator,
    s == 1 and systray or nil,
    separator,
    volume_widget,
    cpu_widget,
    mem_widget,
    separator,
    tasklist[s],

    layout = awful.widget.layout.horizontal.rightleft
  }
end

-- Mouse bindings
root.buttons(awful.util.table.join(
  awful.button({ }, 3, function () main_menu:toggle() end)
))

-- Key bindings
global_keys = awful.util.table.join(
  awful.key({ modkey, }, "Left",   awful.tag.viewprev       ),
  awful.key({ modkey, }, "Right",  awful.tag.viewnext       ),
  awful.key({ modkey, }, "Escape", awful.tag.history.restore),

  -- index-based focus (next/previous window)
  awful.key({ modkey, }, "n", function ()
    awful.client.focus.byidx(1)
    if client.focus then client.focus:raise() end
  end),
  awful.key({ modkey, }, "p", function ()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
  end),

  -- direction-based focus: left/down/up/right using Vim's hjkl keys
  -- doesn't work too well with maximized/minimized windows
  awful.key({ modkey, }, "h", function ()
    awful.client.focus.bydirection("left")
    if client.focus then client.focus:raise() end
  end),
  awful.key({ modkey, }, "j", function ()
    awful.client.focus.bydirection("down")
    if client.focus then client.focus:raise() end
  end),
  awful.key({ modkey, }, "k", function ()
    awful.client.focus.bydirection("up")
    if client.focus then client.focus:raise() end
  end),
  awful.key({ modkey, }, "l", function ()
    awful.client.focus.bydirection("right")
    if client.focus then client.focus:raise() end
  end),

  -- Layout manipulation
  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
  awful.key({ modkey,           }, "Tab", function ()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end),

  -- Go to next screen
  awful.key({ modkey },           "o",      function ()
    local direction = 1
    if mouse.screen == screen.count() then
      direction = -1
    end
    awful.screen.focus_relative(direction)
  end),

  -- Standard program
  awful.key({ modkey, },           "Return", function () spawn(terminal) end),

  awful.key({ modkey, "Shift" },           "l",     function () awful.tag.incmwfact( 0.05)    end),
  awful.key({ modkey, "Shift" },           "h",     function () awful.tag.incmwfact(-0.05)    end),

  -- sound & brightness
  awful.key({}, "XF86AudioPlay", function () spawn("mocp -G", false) end),
  awful.key({ modkey }, "F1", function () spawn("mocp -G", false) end),
  awful.key({}, "XF86AudioLowerVolume", function () spawn("amixer -D pulse set Master 5%-", false) end),
  awful.key({ modkey }, "F3", function () spawn("amixer -D pulse set Master 5%-", false) end),
  awful.key({}, "XF86AudioRaiseVolume", function () spawn("amixer -D pulse set Master 5%+", false) end),
  awful.key({ modkey }, "F4", function () spawn("amixer -D pulse set Master 5%+", false) end),
  awful.key({}, "XF86AudioMute", function () spawn("amixer -D pulse set Master 1+ toggle", false) end),
  awful.key({ modkey }, "F2", function () spawn("amixer -D pulse set Master 1+ toggle", false) end),
  awful.key({ modkey }, "F8", function () spawn("brightness down", false) end),
  awful.key({ modkey }, "F9", function () spawn("brightness up", false) end),

  -- prompt
  awful.key({ modkey }, "r", function () spawn("gmrun", false)                end),
  -- awful.key({ modkey, "Shift" }, "r", function () prompt_box[mouse.screen]:run() end),

  -- applications
  awful.key({ modkey }, "e", function () spawn("pcmanfm", false) end),

  -- pixel-grabbing
  awful.key({ modkey }, "F11", function () spawn("grabc 2>&1 | xclip -selection clip-board", false) end),

  -- screengrabbing
  awful.key({ modkey }, "i", function () spawn(home .. "/bin/shoot", false) end)
)

client_keys = awful.util.table.join(
  awful.key({ modkey, "Shift"},    "f",      function (c) c.fullscreen = not c.fullscreen  end),
  awful.key({ modkey },            "w",      function (c) c:kill()                         end),
  -- awful.key({ modkey, },           "t",      awful.client.floating.toggle                     ),
  awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
  awful.key({ modkey, "Shift" },           "o",      function (c)
    awful.client.movetoscreen(c)
    c:raise()
  end),
  awful.key({ modkey, "Shift" },   "r",      function (c) c:redraw()                       end),
  -- Never minimize windows!
  --awful.key({ modkey, },           "n",      function (c) c.minimized = not c.minimized    end),
  awful.key({ modkey, },           "m",      function (c)
    c.maximized_horizontal = not c.maximized_horizontal
    c.maximized_vertical   = not c.maximized_vertical
  end),
  awful.key({ modkey, "Shift" },   "m",      function (c)
    c.maximized_vertical   = not c.maximized_vertical
  end)
)

last_tag = 10

-- Bind all key numbers to tags.
for i = 1, last_tag do
  -- map numeric key (1-9) with codes 10-19 to tags 2-10 (which really look like 1-9)
  -- first tag is our special backtick tag
  local tag_key = ""
  if i < 10 then
      tag_key = "#" .. i + 9
  else
      tag_key = "#49" -- backtick/tilde key used for last tag
  end

  local current_tag = tags[i]

  global_keys = awful.util.table.join(
    global_keys,
    awful.key({ modkey }, tag_key, function ()
      awful.screen.focus(screen_for_tag(i))
      awful.tag.viewonly(current_tag)
    end),

    awful.key({ modkey, "Control" }, tag_key, function ()
      awful.screen.focus(screen_for_tag(i))
      awful.tag.viewtoggle(current_tag)
    end),

    awful.key({ modkey, "Shift" }, tag_key, function ()
      if client.focus then
        awful.screen.focus(screen_for_tag(i))
        awful.client.movetotag(current_tag)
      end
    end),

    awful.key({ modkey, "Control", "Shift" }, tag_key, function ()
      if client.focus then
        awful.screen.focus(screen_for_tag(i))
        awful.client.toggletag(current_tag)
      end
    end)
  )
end

client_buttons = awful.util.table.join(
  awful.button({ },        1, function (c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize)
)

root.keys(global_keys)

function floating(window_class)
  return {
    rule =       { class = window_class },
    properties = { floating = true },
  }
end
-- Always take the size alotted by awesome.
-- Prevent some windows from leaving out annoying gaps.
function no_size_hints(window_class)
  return {
    rule =       { class = window_class },
    properties = { size_hints_honor = false },
  }
end
-- Center window on the screen
function centered(window_class)
  return {
    rule =       { class = window_class },
    callback = awful.placement.centered
  }
end

-- Rules
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = true,
      keys = client_keys,
      buttons = client_buttons
    }
  },
  floating("MPlayer"),
  floating("Git-gui"),
  floating("Git-gui--askpass"),
  floating("Keepassx"),
  floating("File-roller"),
  floating("Gitk"),
  floating("VirtualBox"),
  floating("Thunar"),
  floating("Pcmanfm"),
  floating("Toplevel"),
  no_size_hints("Xfce4-terminal"),
  no_size_hints("Gnome-terminal"),
  no_size_hints("Lxterminal"),
  no_size_hints("X-terminal-emulator"),
  no_size_hints("Gvim"),
  {
    rule =       { class = "Thunderbird" },
    properties = { tag = tags[7] }
  },
  {
    rule =       { class = "Skype" },
    properties = { tag = tags[8], floating = true }
  },
  {
    rule =       { class = "Pidgin" },
    properties = { tag = tags[8], floating = true }
  },
  {
    rule =       { class = "Audacious" },
    properties = { tag = tags[9], floating = true }
  },
  {
    rule =       { class = "Deluge" },
    properties = { tag = tags[9] }
  },
  {
    rule =       { class = "Psyncgui" },
    properties = { tag = tags[9] }
  },
  centered("Gmrun")
}

-- Some Roxterm versions detect they are using the entire screen and set the maximized state.
-- That breaks window stacking.
function fix_roxterm(client)
    if client.class == "Roxterm" then
      client.maximized_horizontal = false
      client.maximized_vertical = false
    end
end

-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
  if not startup then
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Put windows in a smart way, only if they does not set an initial position.
    if not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_overlap(c)
      awful.placement.no_offscreen(c)
    end

    fix_roxterm(c)
  end
end)

client.add_signal("focus",   function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

spawn(home .. "/.config/awesome/autostart.sh", false)

-- Increase font size and use a more readable font for notification popups.
naughty.config.default_preset.font             = "DejaVu Sans Mono 24"

-- Go to first tag after done initializing.
local screen = mouse.screen
if tags[1] then
  awful.tag.viewonly(tags[1])
end
