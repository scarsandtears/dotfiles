local mp = require("mp")
local msg = require("mp.msg")
local assdraw = require("mp.assdraw")

local timer = nil

local update_interval = 10
local font_size = 48
local corner_margin_x = 30
local corner_margin_y = 50

local function show_clock()
    local osd_w, osd_h = mp.get_osd_size()

    local datetime = os.date("%d/%m %H:%M")

    local ass = assdraw.ass_new()
    ass:new_event()
    ass:pos(osd_w - corner_margin_x, corner_margin_y)
    ass:append(string.format("{\\an3}{\\fs%d}{\\bord2}{\\shad1}%s", font_size, datetime))

    mp.set_osd_ass(osd_w, osd_h, ass.text)
end

local function toggle_clock()
    if timer then
        timer:kill()
        timer = nil
        mp.set_osd_ass(0, 0, "")
        msg.info("Relógio desativado")
    else
        show_clock()
        timer = mp.add_periodic_timer(update_interval, show_clock)
        msg.info("Relógio ativado")
    end
end

mp.register_script_message("show-clock", toggle_clock)
