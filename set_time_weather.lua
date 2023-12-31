local Name, Author, Version, Description = script_name, script_author, script_version, script_description
local VKeys = require( 'vkeys' )

Name( 'Set Weather/Time' )
Author( 'Titanovsky' )
Version( '1.0' )
Description( '' )

print( '\n\n'..script.this.name .. ' || by ' .. script.this.version )
print( 'Version ' .. script.this.version ) 
print( script.this.description..'\n\n' ) 

local enable_auto_skill = false
local enable_auto_power = false

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampRegisterChatCommand( 'sw', SetWeather )
    sampRegisterChatCommand( 'st', SetTime )
    sampRegisterChatCommand( 'autoskill', EnableDisableAutoSkill )
    sampRegisterChatCommand( 'autopower', EnableDisableAutoPower )

    while true do
        if enable_auto_skill then
            setVirtualKeyDown( VKeys.VK_LBUTTON, true )
            wait( 100 )
            setVirtualKeyDown( VKeys.VK_LBUTTON, false )
            wait( math.random( 1243, 2800 ) )
        end

        if enable_auto_power then
            local random = math.random( 3200, 6600 )

            setVirtualKeyDown( VKeys.VK_H, true )
            --setVirtualKeyDown( 0x26, true )

            wait( random )
            setVirtualKeyDown( VKeys.VK_H, false )
            --setVirtualKeyDown( 0x26, true )

            wait( random + 500 )
        end

        wait( 1000 )
    end

    wait(-1)
end

function EnableDisableAutoSkill()
    enable_auto_skill = not enable_auto_skill 
    if not enable_auto_skill then sampAddChatMessage( '[AutoSkill] Disable', 0xFF0000 ) return end

    sampAddChatMessage( '[AutoSkill] Enable', 0xfcba03 )
end

function EnableDisableAutoPower()
    enable_auto_power = not enable_auto_power 
    if not enable_auto_power then sampAddChatMessage( '[AutoPower] Disable', 0xFF0000 ) return end

    sampAddChatMessage( '[AutoPower] Enable', 0xfcba03 )
end
  
function SetWeather( sArg )
    if ( #sArg == 0 ) then sampAddChatMessage( '[Error] Weather ID --> [0,45]', 0xFF0000 ) return end

    local id = tonumber( sArg )
    if ( id < 0 ) or ( id > 45 ) then sampAddChatMessage( '[Error] Weather ID --> [0,45]', 0xFF0000 ) return end

    forceWeatherNow( id )

    sampAddChatMessage( '[Weather] >> '..id, 0xfcba03 )
end

function SetTime( sArg )
    if ( #sArg == 0 ) then sampAddChatMessage( '[Time] ID --> [0,23]', 0xFF0000 ) patch_samp_time_set( false ) return end

    local id = tonumber( sArg )
    if not id then sampAddChatMessage( '[Time] Weather ID --> [0,23]', 0xFF0000 ) return end

    if ( id < 0 ) or ( id > 23 ) then sampAddChatMessage( '[Time] ID --> [0,23]', 0xFF0000 ) patch_samp_time_set( false ) return end

    patch_samp_time_set( true )
    setTimeOfDay( id, 0 )

    sampAddChatMessage( '[Time] >> '..id, 0xfcba03 )
end

function patch_samp_time_set(enable) -- from setWeather&Time.lua
	if enable and default == nil then
		default = readMemory(sampGetBase() + 0x9C0A0, 4, true)
		writeMemory(sampGetBase() + 0x9C0A0, 4, 0x000008C2, true)
	elseif enable == false and default ~= nil then
		writeMemory(sampGetBase() + 0x9C0A0, 4, default, true)
		default = nil
	end
end
