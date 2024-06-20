function readArgs()
	
	local w = false
	local h = false
	local invert = false
	local complete = false

	local width = 0
	local height = 0
	
	for i=1,#arg do
		local num = tonumber(arg[i])
		if num ~= nil then
			if not w then
				width = num
				w = true
			elseif not h then
				height = num
				h = true
			end
			goto continue
		end

		if arg[i] == "true" then
			invert = true
		elseif arg[i] == "false" then
			invert = false
		elseif arg[i] == "complete" then
			complete = true
		end	
				
		::continue::
	end
	
	return width,height,invert,complete	

end


love.window.close()

local imagem = love.image.newImageData(arg[2])
local width,height = imagem:getDimensions()
 
local ratio = width/height
local width_scale = 200/width
local height_scale = width_scale / ratio

local w,h,invert,complete = readArgs()
if w ~= 0 then
	width_scale = w/width
	height_scale = width_scale / ratio
end
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
			new_char = (0.2126*r*255 + 0.7152*g*255 + 0.0722*b*255) / range
			if invert then new_char = #ascii + 1 - new_char end
			if new_char < 1 then new_char = 1 end
			str = str .. string.sub(ascii, new_char, new_char)
			new_px = new_px - 1
		end
		new_px = new_px + width_scale 
	end
	str = str .. "\n"
	::continue::
end

io.write(str)
love.event.quit()
