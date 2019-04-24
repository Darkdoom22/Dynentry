_addon.name = 'Dynentry'
_addon.author = 'Darkdoom'
_addon.version = '0.0.1'
_addon.command = 'Dyn'
_addon.commands = {'start', 'stop','help'}
_addon.language = 'english'


-- ONLY WORKS FOR DYNAMIS - JEUNO AT THIS TIME 
-- Will run from Mog house to Trail Markings, and enter Dynamis for you. 
-- Use in conjunction with something like Scripted or EasyFarm routes to automate dyna farming and have fun!


running = false 
-- ignore the unm stuff, too lazy to remove
function check_incoming_text(original)
	local org = original:lower()
	
	if org:find('sparks of eminence, and now possess a total of 99999') ~= nil then
		running = false
	elseif org:find('one or more party/alliance members do not have the required 200 unity accolades to join the fray') ~= nil then
		running = false
		end
end
-- Commands
	function Dyn_command(...)
	if #arg > 3 then
		windower.add_to_chat(167, 'Invalid command. //Dyn help for valid options.')
	elseif #arg == 1 and arg[1]:lower() == 'start' then
		if running == false then
			running = true
			windower.add_to_chat(200, 'Dynentry starting')
			find()
		else
			windower.add_to_chat(200, 'Dynentry is already running.')
		end
	elseif #arg == 1 and arg[1]:lower() == 'stop' then
		if running == true then
			running = false
			windower.add_to_chat(200, 'Dynentry stopped')
		else
			windower.add_to_chat(200, 'Dynentry not running.')
			running = false
		end
	elseif #arg == 1 and arg[1]:lower() == 'help' then
		windower.add_to_chat(200, 'Available Options:')
		windower.add_to_chat(200, '  //Dyn start - Does the thing')
		windower.add_to_chat(200, '  //Dyn stop - Does not do the thing')
	
		windower.add_to_chat(200, '  //Dyn help - Avail Commands: //Dyn Start, //Dyn Stop, //Dyn help')
	end
end


windower.register_event('addon command', Dyn_command)
windower.register_event('incoming text', function(new, old)
	local info = windower.ffxi.get_info()
	if not info.logged_in then
		return
	else
		check_incoming_text(new)
	end
end)





-- Handles menuing

function Menu()
if running == true then
	coroutine.sleep(7)
	windower.send_command('setkey enter down')
	coroutine.sleep(0.5)
	windower.send_command('setkey enter up')
	coroutine.sleep(6)
	
	windower.send_command('setkey up down')
	coroutine.sleep(0.5)
	windower.send_command('setkey up up')
	coroutine.sleep(0.5)
	windower.send_command('setkey enter down')
	coroutine.sleep(0.5)
	windower.send_command('setkey enter up')
	
	coroutine.sleep(7200)
	find()
end
end

-- Continues looking for markings if not found initially, then does stuff if it finds them.
function Search()
if running == true then
	local target = windower.ffxi.get_mob_by_target('t')
		if target and target.name ~= "Trail Markings" then
		windower.send_command('setkey tab down')
		coroutine.sleep(0.5)
		windower.send_command('setkey tab up')
		coroutine.sleep(0.5)
		Search()
			elseif target and target.name == "Trail Markings" then
			Follow()
			end
end
end

-- Handles movement
function Follow()
	local target = windower.ffxi.get_mob_by_target('t')
	if running == true then
	if target and target.name == "Trail Markings" then

		
		--windower.add_to_chat(200, 'test')
		windower.ffxi.run(-3.14/2)
		coroutine.sleep(3)
		windower.chat.input("/lockon")
		coroutine.sleep(3)
		
		Menu()
			
			elseif target and target.name ~= "Trail Markings" then
			Search()
			coroutine.sleep(1)
			
end	
end


end

-- Starts looking for markings
function find()
	local target = windower.ffxi.get_mob_by_target('t')	
	
	
	if running == true then
	
	
	
	windower.chat.input("/targetnpc") 
	coroutine.sleep(1)
		if target and target.name == "Trail Markings"

		then
		windower.add_to_chat(200, 'Found the good stuff')
		
		Follow()
		coroutine.sleep(45)
		find()
		elseif target and target.name ~= "Trail Markings" then
		
		windower.add_to_chat(200,'Not what you are looking for')
		Search()
		coroutine.sleep(1)
		end
		find()
		coroutine.sleep(1)
	end	
	
	
end