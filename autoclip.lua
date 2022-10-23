----- Config (example) -----
exec = "C:\\Users\\Kametsu\\Documents\\GitHub\\autoclip.exe"
-- To set everything up so it'll work, for each slash you need to add one additional slash to escape them.


----- Basic script info -----
script_name="Auto Clip"
script_description="Subtracts subtrahend frame from minuend frame and transforms that into vector"
script_author="kametsu"
script_version="0.2"


----- Repetetive functions -----
function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function add_line(s, l, txt, p, s_, e_)
    s_ = aegisub.ms_from_frame(s_)
    e_ = aegisub.ms_from_frame(e_+1)

    l.text = txt .. l.text
    l.start_time = s_
    l.end_time = e_

    s.insert(p, l)
end

function write_to_memory(a, b, c)
    file = io.open("autoclip.cfg", "w")
    file:write(a .. '\n' .. b .. '\n' .. c)
    file:close()

end

function read_memory()
    file = io.open("autoclip.cfg", "a+")
    config = split(file:read("*all"), '\n')
    if #config == 1 then
        write_to_memory("0", "0", "0")
        return {0, 0, 0}
    else
        return config
    end
end

----- Functions -----

function apply(sub, sel, frames, erosion_, min_area_, cliptype_)
    properties = aegisub.project_properties()
    video = properties.video_file

    frames_ = frames[1] .. ',' .. frames[2] .. ',' .. frames[3]

    args = {exec, video, frames_, erosion_, min_area_, cliptype_}


    command = "\"\"" .. table.concat(args, "\" \"") .. "\"\""

    handle = assert(io.popen(command, 'r'))
    output = assert(handle:read('*a'))
    handle:close()

    commands = split(split(output, 'Done\n')[2], ';')

    pointer = sel[1]

    for i, line in pairs(commands) do
        line_split = split(line, ':')

        start = tonumber(line_split[1])
        text = line_split[2]
        
        add_line(sub, sub[pointer], text, pointer+i, start, start)
    end
end

function gui(sub, sel)
    cfg = read_memory()

    minuend_frame_ts = tonumber(cfg[1])
    subtrahend_from_frame_ts = tonumber(cfg[2])
    subtrahend_to_frame_ts = tonumber(cfg[3])

    properties = aegisub.project_properties()
    time = properties.video_position

    dialog_config=
    {
        {x=0,y=0,width=1,height=1,class="label",label="Minuend frame: "},
        {x=1,y=0,width=1,height=1,class="intedit", name="minuend",value=minuend_frame_ts},
        {x=0,y=1,width=1,height=1,class="label",label="Subtrahend frames from: "},
        {x=1,y=1,width=1,height=1,class="intedit", name="subtrahends_from",value=subtrahend_from_frame_ts},
        {x=0,y=2,width=1,height=1,class="label",label="Subtrahend frames to: "},
        {x=1,y=2,width=1,height=1,class="intedit", name="subtrahends_to",value=subtrahend_to_frame_ts},
        {x=2,y=0,width=1,height=1,class="label",label="Erosion level: "},
        {x=3,y=0,width=1,height=1,class="intedit", name="erosion",value=4},
        {x=2,y=1,width=1,height=1,class="label",label="Minimum area: "},
        {x=3,y=1,width=1,height=1,class="intedit",name="min_area",value=1000},
        {x=2,y=2,width=1,height=1,class="label",label="Clip: "},
        {x=3,y=2,width=1,height=1,class="dropdown",items={"\\iclip", "\\clip"},name="cliptype",value="\\iclip"}
    } 	
    buttons={"Set minuend","Set subtrahend from", "Set subtrahend to", "Save from input", "Apply", "Cancel"}
    pressed,res=aegisub.dialog.display(dialog_config,buttons)
    if pressed=="Cancel" then aegisub.cancel() end
    if pressed=="Set minuend" then write_to_memory(time, res.subtrahends_from, res.subtrahends_to) end
    if pressed=="Set subtrahend from" then write_to_memory(res.minuend, time, res.subtrahends_to) end
    if pressed=="Set subtrahend to" then write_to_memory(res.minuend, res.subtrahends_from, time) end
    if pressed=="Save from input" then write_to_memory(res.minuend, res.subtrahends_from, res.subtrahends_to) end
    if pressed=="Apply" then apply(sub, sel, {res.minuend, res.subtrahends_from, res.subtrahends_to}, tostring(res.erosion), tostring(res.min_area), res.cliptype) end
end


aegisub.register_macro("Autoclip", "Subtracts subtrahend frame from minuend frame and transforms that into vector", gui)