-- Created by Soapy7261 --

-- VARIABLES YOU CAN CHANGE --
EFFICIENCY_THRESHOLD = 80 -- You can change this if you want, but I would also recommend changing reactivity increment to be lower if you're going to increase it, but then you also run the risk of it not being actually fast enough
ADJUSTMENT_INCREMENT = 5 -- Setting this too high can cause cases where an efficiency of 80 or higher can never be reached, and too low can cause it to be too slow before error level becomes 100%

-- CODE --
LOGIC_ADAPTER = peripheral.find("fusionReactorLogicAdapter")
LOGIC_ADAPTER.adjustReactivity(-100) -- Normalize the environment for possible edge cases
os.sleep(2) -- race conditions, dont remove this unless you can somehow fix the race condition, oh and make a PR on the github please
while true do
    if math.floor(LOGIC_ADAPTER.getEfficiency()) < EFFICIENCY_THRESHOLD == true then -- Too low!
        OldEfficiency = LOGIC_ADAPTER.getEfficiency()
        LOGIC_ADAPTER.adjustReactivity(1) -- I could test to see if this is the first run since this isn't needed then, but honestly I dont care.
        if LOGIC_ADAPTER.getEfficiency() < EFFICIENCY_THRESHOLD then -- If this doesn't trigger, then we did it just by incrementing it by 1, unlikely but hey, it can happen!
            if LOGIC_ADAPTER.getEfficiency() < OldEfficiency then -- We were further than before
                while LOGIC_ADAPTER.getEfficiency() < EFFICIENCY_THRESHOLD do
                    LOGIC_ADAPTER.adjustReactivity(-1 * ADJUSTMENT_INCREMENT) -- Get the negative version of that number
                end
            else -- We're on the right path!
                while LOGIC_ADAPTER.getEfficiency() < EFFICIENCY_THRESHOLD do
                    LOGIC_ADAPTER.adjustReactivity(ADJUSTMENT_INCREMENT)
                end
            end
        end
    end
    sleep(1) -- Prevent "Too long without yielding"
end
