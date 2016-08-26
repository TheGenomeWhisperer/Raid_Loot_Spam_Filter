-- Author: TheGenomeWhisperer

-- Program: To resolve the horrible raid loot spam during Garrison Fishing parties...  
-- This ONLY works in Garrison, and it only works on filtering anything but epics and Green Minnows.

-- Slash command.  You will '/lootspam enable' or '/lootspam disable' to toggle the addon on and off.  '/lootspam' will just report back if looting is currently on or off.
SLASH_RAIDLOOTSPAMFILTER1 = '/lootspam';

-- Global variables
local IsEnabled = false;

-- For fun data reporting at the end.
local totalFiltered = 0;
local totalMinnows = 0;
local totalSeaTurtles = 0;
local totalRidingTurtles = 0;
local totalStrandCrawlers = 0;

-- Items to not filter by ItemID (Frostdeep Minnow, Sea Turtle, Riding Turtle, Strand Crawler)
local toNotFilter = {"112633","46109","23720","44983"};

-- Every time an item is looted, this searches through the item link code for an itemID
function noMoreSpam(self,event,msg)
    -- Escape from the filtering.
    if IsEnabled == false then
        return;
    end
     
    local count = 0;
    for _, word in ipairs(toNotFilter) do
        if (string.match(msg, word)) then -- This is where it is determining items to NOT be filtered.
            count = count + 1;
            -- Tallying up results
            if word == "112633" then
                totalMinnows = totalMinnows + 1;
            elseif word == "46109" then
                totalSeaTurtles = totalSeaTurtles + 1;
            elseif word == "23720" then
                totalRidingTurtles = totalRidingTurtles + 1;
            elseif word == "44983" then
                totalStrandCrawlers = totalStrandCrawlers + 1;
            end
            break;
        end
    end
    
    if (count == 0) then
        totalFiltered = totalFiltered + 1;
        return true;
    else
        return false;
    end
end

-- Method for quick Access Reporting.
function FishingReport()
    local _,minnow = GetItemInfo(112633); -- Frostdeep Minnow
    local _,seaT = GetItemInfo(46109);  -- Sea Turtle
    local _,ridingT = GetItemInfo(23720);  -- Riding Turtle
    local _,sCrawl = GetItemInfo(44983);  -- Strand Crawler

    print("LOOT RESULTS:");
    print(minnow .. "x " .. totalMinnows/2);
    print(sCrawl .. "x " .. totalStrandCrawlers/2);
    print(seaT .. "x " .. totalSeaTurtles/2);
    print(ridingT .. "x " .. totalRidingTurtles/2);
end

-- Resets tracking data
function Reset()
    totalFiltered = 0;
    totalMinnows = 0;
    totalSeaTurtles = 0;
    totalRidingTurtles = 0;
    totalStrandCrawlers = 0;
end

-- Slash Command Controls...
SlashCmdList["RAIDLOOTSPAMFILTER"] = function(input)
    if input == nil or input:trim() == "" then
        if IsEnabled == true then
            FishingReport();

            print("\nTOTAL FILTERED: " .. totalFiltered);
        else
            print("Loot Filtering is Currently DISABLED");
        end
    else
        -- ENABLING FILTERING
        if input == "enable" then

            if IsEnabled == false then
                print("Loot Filtering Enabled");
            end
            IsEnabled = true;
            ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT",noMoreSpam);

        -- Sets all tracked data back to zero.
        elseif input == "reset" then
            print("All tracking data has been reset to zero");
            Reset();

        -- DISABLING FILTERING
        elseif input == "disable" then 
            if IsEnabled == true then
                print("\nLoot Filtering Has Been Disabled");
                FishingReport();
                
                -- Fun reporting back to the player.
                if totalFiltered > 99999 then
                    print("\nLOOT FILTERED: " .. totalFiltered .. "\n\nOk that is just dedication!\nYou are worthy of some kind of special prize!!! \nPlease Screenshot this and post it!");
                elseif totalFiltered > 99999 then
                    print("\nLOOT FILTERED: " .. totalFiltered .. "\n\nThe Legend is true about you, I know it!\nBefore the Legion is destroyed, a peaceful and noble Angler will acquire a mount from the depths of the sea, long thought extinct from this world, only to be awakened from the deep, and the rider of this mount will lead the final charge to victory!\n\nIt is you! Who else could block so much loot spam?");
                elseif totalFiltered > 9000 then
                    print("\nLOOT FILTERED: " .. totalFiltered .. "\n\nWhat!? Are you serious? OVER 9000!? Are you related to Nat by chance?");
                elseif totalFiltered > 7999 then
                    print("\nLOOT FILTERED: " .. totalFiltered .. "\n\nAww, just short of 9000. You should've have fished a little longer!");
                elseif totalFiltered > 6999 then
                    print("\nLOOT FILTERED: " .. totalFiltered .. "\n\nYou must LOVE fishing to have held out this long today! Well Done!");
                elseif totalFiltered > 5999 then
                    print("\nLOOT FILTERED: " .. totalFiltered .. "\n\nAre you on fire, because I thought you'd stop at 5000 and I was wrong!");
                elseif totalFiltered > 4999 then
                    print("\nLOOT FILTERED: " .. totalFiltered .. "\n\nWow! The Sen'jin fishing experts have nothing on you!");
                elseif totalFiltered > 3999 then
                    print("\nLOOT FILTERED: " .. totalFiltered .. "\n\nMaybe the legands ARE true about you afterall!");
                elseif totalFiltered > 2999 then
                    print("\nLOOT FILTERED: " .. totalFiltered .. "\n\nNat asked me personally to congratulate you for your hard work!");
                elseif totalFiltered > 1999 then
                    print("\nLOOT FILTERED: " .. totalFiltered .. "\n\nAmazing! Those fish don't catch themselves!");
                elseif totalFiltered > 999 then
                    print("\nLOOT FILTERED: " .. totalFiltered .. "\n\nYou did good, REAL good filtering over a thousand!");
                elseif totalFiltered > 499 then
                    print("\nLOOT FILTERED: " .. totalFiltered .. "\n\nWow! That's a lot!'");
                elseif totalFiltered == 1 then
                    print("\nLOOT FILTERED: " .. totalFiltered);
                else
                    print("\nLOOT FILTERED: " .. totalFiltered);
                end  
            else
                print("Loot Filtering Is Not Currently Enabled"); -- Informaing player it is already off to reassure their minds if they could not remember.
            end
            IsEnabled = false;
            -- Resetting Loot Values
            totalFiltered = 0;
            totalMinnows = 0;
            totalSeaTurtles = 0;
            totalRidingTurtles = 0;
            totalStrandCrawlers = 0;
            
        -- HELP REPORTING
        elseif input == 'help' then
            local result = "\n-------------------------------------------\n---  RAID LOOT SPAM FILTER   ---\n----          INFORMATION           ----\n-------------------------------------------";
            result = result .. "\nType to Enable Filter:      /lootspam enable";
            result = result .. "\nType to Disable Filter:     /lootspam disable";
            result = result .. "\nReset progress tracking:  /lootspam reset"
            result = result .. "\nType to Check Progrss:    /lootspam";
            print(result);
        
        -- If error in input
        else
            print("ERROR! Input not recognized.");
            print("Please type /lootspam help for info.")
        end
    end
end