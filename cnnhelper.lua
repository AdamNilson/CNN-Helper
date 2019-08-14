script_name('CNN-Helper')
script_authors('Adam_Nilson', 'special for Arizona')
script_description('This script facilitates the work of the media.')

require 'lib.moonloader'
local sampev = require 'lib.samp.events'




local isAdChecking = false 
local activate = false 



function main()

	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	sampAddChatMessage("{FF0000}[{FFA500}CNN-Helper{FF0000}] �������� ����������, ���������� ���������!", 0xFFFFFF)
		wait(15000)
		--
--     _   _   _ _____ ___  _   _ ____  ____    _  _____ _____   ______   __   ___  ____  _     _  __
--    / \ | | | |_   _/ _ \| | | |  _ \|  _ \  / \|_   _| ____| | __ ) \ / /  / _ \|  _ \| |   | |/ /
--   / _ \| | | | | || | | | | | | |_) | | | |/ _ \ | | |  _|   |  _ \\ V /  | | | | |_) | |   | ' /
--  / ___ \ |_| | | || |_| | |_| |  __/| |_| / ___ \| | | |___  | |_) || |   | |_| |  _ <| |___| . \
-- /_/   \_\___/  |_| \___/ \___/|_|   |____/_/   \_\_| |_____| |____/ |_|    \__\_\_| \_\_____|_|\_\                                                                                                                                                                                                                  
--
-- Author: http://qrlk.me/samp
--
function autoupdate(json_url, prefix, url)
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('��������� %d �� %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('�������� ���������� ���������.')
                      sampAddChatMessage((prefix..'���������� ���������!'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'���������� ������ ��������. �������� ���������� ������..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': ���������� �� ���������.')
            end
          end
        else
          print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end
	sampAddChatMessage("{008000}[{FFA500}CNN-Helper{008000}] �� ����������� ��������� ������ {FFFFFF}V-1.1", 0xFFFFFF)
	sampAddChatMessage("{008000}[{FFA500}CNN-Helper{008000}] {FFFFFF}by {008000}Adam_Nilson {FFFFFF}special for {008000}Arizona Role Play Yuma", 0xFFFFFF)
	sampAddChatMessage("{008000}[{FFA500}CNN-Helper{008000}] {FF0000}/CNN {FFFFFF}��������/��������� {FFFFFF}������", 0xFFFFFF)
	sampAddChatMessage("{008000}[{FFA500}CNN-Helper{008000}] ������ �� �������", 0xFFFFFF)
	
	sampRegisterChatCommand('CNN', activateScript) 

	while true do
	 wait(0)

	end

end

function sampev.onServerMessage(color, text)
lua_thread.create(function()

  if text:find("�� ��������� ���������� ������ ��������� ��: %a+_%a+") and not isAdChecking and not sampIsDialogActive() and activate then
        
		
		isAdChecking = true 
		
		sampAddChatMessage('{FFFFFF}*���* ��������� ���������!.', 0xFFFFFF)
		sampAddChatMessage('{FFFFFF}������ ����������!.', 0xFFFFFF) 
		

		local nickname = getAdNickname(text) 
		sampSendChat('/newsredak') 
		while not sampIsDialogActive() do
		 wait(10)
		end
		local result = sendClickCurrentAd(nickname) 

		if result then 
		    sampAddChatMessage('{99FF00}��� ���������, ������ ��� ���������� ����!.', 0xFFFFFF)
		    lua_thread.create(isAdRedactingNow) 
		else
		    print('{FF0000}��� �� ��� ������ � ������� ��� �� ��� ������ �������� ������.', 0xFFFFFF)

		end
  	end

end)
end

function isAdRedactingNow()

    sampAddChatMessage('{FFFFFF}� ���� �������.', 0xFFFFFF)
    while true do 
	 wait(0)
	    if sampIsDialogActive() then 
		    wait(10)
		else
		    sampAddChatMessage('{00FF00}������ ������� ������.', 0xFFFFFF)
			sampAddChatMessage('{00FF00}����� {FF0000}10 {FF0000}������ ����� ������ ����������.', 0xFFFFFF)
			wait(10000)
		    isAdChecking = false 
		     break 
			 
		end
	end

end

function getAdNickname(arg)

    local mean = string.match(arg, '(%a+_%a+)') 
	print('{00FF00}��� ������ ������� �������.', 0xFFFFFF)

	 return mean 
end

function sendClickCurrentAd(nick)

	if sampIsDialogActive() then 
	    dialogText = sampGetDialogText() 
		print('����� ��������� �������: '..dialogText)
	    print('{00FF00}����� ��������� ������� ������� �������.', 0xFFFFFF)
	else 
	    print('{FF0000}�� ������ �������� ������.', 0xFFFFFF)
	     return false
	end

	local i = -2 

    for dialogString in string.gmatch(dialogText, '(.-\t.-\n)') do 
	    i = i + 1 
	    print('������ ������ ������� �'..i..': '..dialogString) 

		if string.find(dialogString, nick..'\t') then 
		    print('{00FF00}��� ������� ������ � ������ �'..i, 0xFFFFFF)
		    local dID = sampGetCurrentDialogId() 
		    sampSendDialogResponse(dID, 1, i, nil) 
			print('{00FF00}������� �������� �� ������ �'..i, 0xFFFFFF)
			 return true 
		else
		    print('{FF0000}� ������ �'..i..' ��� �� ������.', 0xFFFFFF) 
		end
	end

	 return false 

end

function activateScript()
	activate = not activate

	if activate then
		sampAddChatMessage("{008000}[{FFA500}CNN-Helper{008000}] {008000}�������!", 0xFFFFFF)
	else
		sampAddChatMessage("{008000}[{FFA500}CNN-Helper{008000}] {FF0000}��������!", 0xFFFFFF)
	end
end
