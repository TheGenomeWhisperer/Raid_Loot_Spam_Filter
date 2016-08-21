-- Author: Sklug

-- Program: To resolve the horrible raid loot spam during Garrison Fishing parties...  
-- This ONLY works in Garrison, and it only works on filtering anything but epics and Green Minnows.

-- Slash command.  You will '/lootspam enable' or '/lootspam disable' to toggle the addon on and off.  '/lootspam' will just report back if looting is currently on or off.
SLASH_RAIDLOOTSPAMFILTER1 = '/lootspam';

-- Global variables
local IsEnabled = false;

-- grey = "ff9d9d9d", white = "ffffffff", green = ff1eff00", blue = "ff0070dd", epic = n/a - not filtering.
    local toFilter = {"ff9d9d9d","ffffffff","ff1eff00","ff0070dd"}
    local count = 0;
    local count2 = 0; -- protected from loot count
    -- Escape from the filtering.
    if IsEnabled == false then
        return;
    end
    for _, word in ipairs(toFilter) do
        if count == 0 then
            if (string.match(msg, word)) then
                count = count + 1;
            end
        end
        if count2 == 0 then
            if (string.match(msg,"112633")) then -- This is the itemID for frostdeep minnow.
                count2 = count2 + 1;
            end
        end
    end
    if (count > 0 and count2 == 0) then
        return true;
    else
        return false;
    end
end

-- Slash Command Controls...
SlashCmdList["RAIDLOOTSPAMFILTER"] = function(input)
    if input == nil or input:trim() == "" then
        if IsEnabled == true then
            print("Loot Filtering is Currently Enabled");
        else
            print("Loot Filtering is Currently Disabled");
        end
    else
        if input == "enable" then

            if IsEnabled == false then
                print("Loot Filtering Enabled");
            end
            IsEnabled = true;
            ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT",noMoreSpam);
        elseif input == "disable" then
            if IsEnabled == true then
                print("Loot Filtering Has Been Disabled");
            else
                print("Loot Filtering Is Not Currently Enabled");
            end
            IsEnabled = false;
        end
    end
end