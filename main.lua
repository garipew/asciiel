function readArgs()
	
	local invert = false
	local complete = false
	local color = false
	local ascii = false

	local width = 0
	local height = 0
	
	for i=1,#arg do
		local num = tonumber(arg[i])
		if num ~= nil then
			if width == 0 then
				width = num
			elseif height == 0 then
				height = num
			end
			goto continue
		end

		if arg[i] == "invert" then
			invert = true
		elseif arg[i] == "complete" then
			complete = true
		elseif arg[i] == "color" then
			color = true
		elseif arg[i] == "ascii" then
			ascii = true
		end	
				
		::continue::
	end
	
	return width,height,invert,complete,color,ascii

end


love.window.close()

local imagem = love.image.newImageData(arg[2])
local width,height = imagem:getDimensions()
 
local ratio = width/height
local width_scale = 200/width
local height_scale = width_scale / ratio

local w,h,invert,complete,color,asc = readArgs()
if w ~= 0 then
	width_scale = w/width
	height_scale = width_scale / ratio
end
if ratio <= 1 then height_scale = height_scale / 2 end
if h ~= 0 then
	height_scale = h/height
end


local ascii = " .:-=+*#%@"
if complete then ascii = " .'`^\",:;Il!i><~+_-?][}{1)(|\\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$" end
local range = 255/string.len(ascii)

local str = "" 
local new_px = 1
local new_line = 1
for j=0,height-1 do
	new_line = new_line + height_scale
	if new_line < 1 then goto continue end
	new_line = new_line - 1
	new_px = 1
	for k=0,width-1 do
		if new_px >= 1 then
			r,g,b,a = imagem:getPixel(k,j)
			r = r * 255
			g = g * 255
			b = b * 255
			new_char_pos = (0.2126*r + 0.7152*g + 0.0722*b) / range
			if invert then new_char_pos = #ascii + 1 - new_char_pos end
			if new_char_pos < 1 then new_char_pos = 1 end
			local new_char = string.sub(ascii, new_char_pos, new_char_pos)
			if not color then
				str = str .. new_char
			else
				local cor = "\x1b[38;2;" .. r .. ";" .. g .. ";" .. b .. "m"
				local fim = "\x1b[0m"
				if asc then
					str = str .. cor .. new_char .. fim
				else
					str = str .. cor .. "@" .. fim
				end
			end
			new_px = new_px - 1
		end
		new_px = new_px + width_scale 
	end
	str = str .. "\n"
	::continue::
end

io.write(str)
love.event.quit()
