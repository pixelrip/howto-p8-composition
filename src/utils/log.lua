-- Simple Logging System
-- Provides a basic logging function for debugging Pico-8 games

-- Log a message to the log file
-- @param txt - The message to log (will be converted to string)

log = {}

function log.print(txt)
	printh(tostr(txt), "log", false)
end

-- Prints and entire table into the console
function log.table(tbl, prefix)
    prefix = prefix or ""
    for key, value in pairs(tbl) do
        log.print(prefix .. tostr(key) .. " = " .. tostr(value))
    end
end

