-- Function to convert a string to UTF-8
local function toUTF8(str)
    return (str:gsub('.', function(c)
        return string.format('\\%03d', string.byte(c))
    end))
end

-- Function to convert UTF-8 back to ASCII text
local function fromUTF8(str)
    return (str:gsub('\\(%d%d%d)', function(c)
        return string.char(tonumber(c))
    end))
end


-- Function to encode a string to Base64
local function base64Encode(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x)
        local r, b = '', x:byte()
        for i = 8, 1, -1 do
            r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and '1' or '0')
        end
        return r
    end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then
            return ''
        end
        local c = 0
        for i = 1, 6 do
            c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0)
        end
        return b:sub(c + 1, c + 1)
    end) .. ({ '', '==', '=' })[#data % 3 + 1])
end

-- Function to decode a Base64 string
local function base64Decode(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then
            return ''
        end
        local r, f = '', (b:find(x) - 1)
        for i = 6, 1, -1 do
            r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and '1' or '0')
        end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then
            return ''
        end
        local c = 0
        for i = 1, 8 do
            c = c + (x:sub(i, i) == '1' and 2 ^ (8 - i) or 0)
        end
        return string.char(c)
    end))
end

-- Test the functions
local originalString = "Thisiwanttoencodeanddecode="
print("Original string: ", originalString)

-- Convert the string to UTF-8
local utf8String = toUTF8(originalString)
print("UTF-8 string: ", utf8String)

-- Encode the UTF-8 string to Base64
local encodedString = base64Encode(utf8String)
print("Encoded Base64: ", encodedString)

-- Decode the Base64 string
local decodedString = base64Decode(encodedString)
print("Decoded string: ", decodedString)

-- Convert UTF-8 back to ASCII text
local asciiString = fromUTF8(decodedString)
print("ASCII string: ", asciiString)
