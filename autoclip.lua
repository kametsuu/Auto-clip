-- basic script info
script_name="Auto Clip"
script_description="Subtracts subtrahend frame from minuend frame and transforms that into vector"
script_author="kametsu"
script_version="0.0.1"

-- path to exe file | example:
exe = "C:\\Users\\Kametsu\\Desktop\\clipmaskfunc.exe"


function set_minuend_frame()
    -- load aegienv properties and write timeframe to file
    properties = aegisub.project_properties()
    frame = properties.video_position
    file = io.open("minuendframe.cfg", "w")

    file:write(frame)
    file:close()
end


function create_mask(sub, sel)
    -- Opening minuend timeframe
    file = io.open("minuendframe.cfg", "r")
    minuend_frame = file:read()
    file:close()

    -- get timeframe of subtrahend frame and path of video
    properties = aegisub.project_properties()
    subtrahend_frame = properties.video_position
    video_path = properties.video_file

    -- create command
    cmd = "\"\"" .. exe .. "\" \"" .. video_path .. "\" \"" ..  minuend_frame .. "," .. subtrahend_frame .. "\"\""

    -- opens io subprocess and assert command
    handle = assert(io.popen(cmd, 'r'))
    output = assert(handle:read('*a'))
    handle:close()

    -- get pointer to first sub and swap line
    pointer = sel[1]
    line = sub[pointer]
    line.text = output:sub(1, -2) .. line.text
    sub[pointer] = line

    return sel
end


-- Sets aegi macros
aegisub.register_macro("Autoclip - Base frame", "Sets minuend frame", set_minuend_frame)
aegisub.register_macro("Autoclip - Subtrahend frame & apply", "Will subtract subtrahend frame from minuend frame making clip", create_mask)

