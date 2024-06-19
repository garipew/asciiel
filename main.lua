love.window.close()

local imagem = love.image.newImageData(arg[2])
local width,height = imagem:getDimensions()
 
local ratio = width/height
local width_scale = 200/width
local height_scale = width_scale / ratio

local invert = false
if #arg >= 3 then
	if arg[3] == "true" then invert = true end
end

if #arg >= 4 then
	width_scale = arg[4]/width
	height_scale = width_scale / ratio
end

if #arg >= 5 then
	height_scale = arg[5]/height
end

local ascii = "@%#*+=-:. " 
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
