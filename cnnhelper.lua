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
	sampAddChatMessage("{FF0000}[{FFA500}CNN-Helper{FF0000}] Проверка обновлений, пожалуйста подождите!", 0xFFFFFF)
		wait(15000)
		--
--     _   _   _ _____ ___  _   _ ____  ____    _  _____ _____   
--    / \ | | | |_   _/ _ \| | | |  _ \|  _ \  / \|_   _| ____| 
--   / _ \| | | | | || | | | | | | |_) | | | |/ _ \ | | |  _|   
--  / ___ \ |_| | | || |_| | |_| |  __/| |_| / ___ \| | | |___  
-- /_/   \_\___/  |_| \___/ \___/|_|   |____/_/   \_\_| |_____|                                                                                                                                                                                                                 
--

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
                sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Загрузка обновления завершена.')
                      sampAddChatMessage((prefix..'Обновление завершено!'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': Обновление не требуется.')
            end
          end
        else
          print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end
	sampAddChatMessage("{008000}[{FFA500}CNN-Helper{008000}] Вы используете последнюю версию {FFFFFF}V-1.1", 0xFFFFFF)
	sampAddChatMessage("{008000}[{FFA500}CNN-Helper{008000}] {FFFFFF}by {008000}Adam_Nilson {FFFFFF}special for {008000}Arizona Role Play Yuma", 0xFFFFFF)
	sampAddChatMessage("{008000}[{FFA500}CNN-Helper{008000}] {FF0000}/CNN {FFFFFF}Включить/Выключить {FFFFFF}скрипт", 0xFFFFFF)
	sampAddChatMessage("{008000}[{FFA500}CNN-Helper{008000}] Скрипт не запущен", 0xFFFFFF)
	
	sampRegisterChatCommand('CNN', activateScript) 

	while true do
	 wait(0)

	end

end

function sampev.onServerMessage(color, text)
lua_thread.create(function()

  if text:find("На обработку объявлений пришло сообщение от: %a+_%a+") and not isAdChecking and not sampIsDialogActive() and activate then
        
		
		isAdChecking = true 
		
		sampAddChatMessage('{FFFFFF}*Пуф* Работенка подъехала!.', 0xFFFFFF)
		sampAddChatMessage('{FFFFFF}Скорее редактируй!.', 0xFFFFFF) 
		

		local nickname = getAdNickname(text) 
		sampSendChat('/newsredak') 
		while not sampIsDialogActive() do
		 wait(10)
		end
		local result = sendClickCurrentAd(nickname) 

		if result then 
		    sampAddChatMessage('{99FF00}Как закончишь, закрой все диалоговые окна!.', 0xFFFFFF)
		    lua_thread.create(isAdRedactingNow) 
		else
		    print('{FF0000}Ник не был найден в диалоге или не был найден открытый диалог.', 0xFFFFFF)

		end
  	end

end)
end

function isAdRedactingNow()

    sampAddChatMessage('{FFFFFF}Я пока подожду.', 0xFFFFFF)
    while true do 
	 wait(0)
	    if sampIsDialogActive() then 
		    wait(10)
		else
		    sampAddChatMessage('{00FF00}Диалог успешно закрыт.', 0xFFFFFF)
			sampAddChatMessage('{00FF00}Через {FF0000}10 {FF0000}секунд начну искать обьявления.', 0xFFFFFF)
			wait(10000)
		    isAdChecking = false 
		     break 
			 
		end
	end

end

function getAdNickname(arg)

    local mean = string.match(arg, '(%a+_%a+)') 
	print('{00FF00}Ник игрока успешно получен.', 0xFFFFFF)

	 return mean 
end

function sendClickCurrentAd(nick)

	if sampIsDialogActive() then 
	    dialogText = sampGetDialogText() 
		print('Текст открытого диалога: '..dialogText)
	    print('{00FF00}Текст открытого диалога успешно получен.', 0xFFFFFF)
	else 
	    print('{FF0000}Не найден открытый диалог.', 0xFFFFFF)
	     return false
	end

	local i = -2 

    for dialogString in string.gmatch(dialogText, '(.-\t.-\n)') do 
	    i = i + 1 
	    print('Взятая строка диалога №'..i..': '..dialogString) 

		if string.find(dialogString, nick..'\t') then 
		    print('{00FF00}Ник успешно найден в строке №'..i, 0xFFFFFF)
		    local dID = sampGetCurrentDialogId() 
		    sampSendDialogResponse(dID, 1, i, nil) 
			print('{00FF00}Успешно кликнули по строке №'..i, 0xFFFFFF)
			 return true 
		else
		    print('{FF0000}В строке №'..i..' ник не найден.', 0xFFFFFF) 
		end
	end

	 return false 

end

function activateScript()
	activate = not activate

	if activate then
		sampAddChatMessage("{008000}[{FFA500}CNN-Helper{008000}] {008000}Запущен!", 0xFFFFFF)
	else
		sampAddChatMessage("{008000}[{FFA500}CNN-Helper{008000}] {FF0000}Отключен!", 0xFFFFFF)
	end
end
