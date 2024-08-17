queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
print("working")

if not game:IsLoaded() then game.Loaded:Wait() end
game.Players.LocalPlayer.OnTeleport:Connect(function(State)
	if State == Enum.TeleportState.Started then
		if  queueteleport then
			queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/standzzz/test/main/testing.lua'))()")
		end
	end
end)

local Stats = game:GetService("Stats")
wait(5)
local function getUserPing()
	local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
	return ping or 0 --// Divide by 1000 to get exact ping (i think, i dont remember if it returns in ms or numbers)
end

local function glitchcommunication(action2,message2)
	local url = "https://polite-tropical-bonsai.glitch.me/submit"

	local headers = {
		["Content-Type"] = "application/json"
	}

	-- Modify the data table to include both "action" and "message"
	local data = {
		action = action2,
		message = message2
	}

	local jsonData = game:GetService("HttpService"):JSONEncode(data)

	local response = request({
		Url = url,
		Method = "POST",
		Headers = headers,
		Body = jsonData
	})

	if response.StatusCode == 200 then
		print("Data posted successfully:", response.Body)
		return response.Body
	else
		warn("Failed to post data:", response.StatusMessage)
		return false
	end
end

local HttpService = game:GetService("HttpService")
local firebaseUrl = "https://snipehanl-default-rtdb.europe-west1.firebasedatabase.app/COMPLETED.json"

function checkforfinished(code)
	local data
	local success,error = pcall(function()
		data = game:HttpGet(firebaseUrl)

	end)

	if error then print(error) end
	if success then print("got data") end
	data = game:GetService("HttpService"):JSONDecode(data)
	print(data)
	local found = false
	for i,v in pairs(data) do  
		if i == code then 
			found = true
		end
	end
	return found
end



local shouldbeattacking = false
local target = nil

--[[task.spawn(function()
	while true do 
		wait(30)
		if shouldbeattacking then
			game:GetService('ReplicatedStorage'):WaitForChild('DefaultChatSystemChatEvents'):WaitForChild('SayMessageRequest'):FireServer("Add networkin to snipe your enimies!", 'All')

		end
	end
end)--]]

function purchasearmor()
	local armor = game.Workspace.Ignored.Shop:FindFirstChild("[Medium Armor] - $1066")
	game.Players.LocalPlayer.Character.PrimaryPart.CFrame = armor:FindFirstChild("Head").CFrame
	wait(0.5)
	fireclickdetector(armor:FindFirstChild("ClickDetector"))
	wait(0.5)
	game.Players.LocalPlayer.Character:PivotTo(CFrame.new(Vector3.new(-217,27,181)) * CFrame.Angles(0, 0, 0))
end

function attack()
	local activeconnections = {
		A = nil,
		B = nil,
		C = nil,
		D = nil
	}
	local ping = getUserPing()
	local pred = 0.115

	if ping > 80 and ping < 120 then
		pred = 0.15
	elseif ping > 120 and ping < 250 then
		pred = 0.225
	elseif ping > 200 and ping < 320 then
		pred = 2.5
	elseif ping > 320 then
		pred = 3
	end


	print("attacking.../")
	local attack = true
	local gun = "[LMG]"
	local player = game.Players.LocalPlayer
	local character = game.Players.LocalPlayer.Character
	function noclipactive()
		for i,v in pairs(character:GetChildren()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end

	function grabguns()
		local lmg = game.Workspace.Ignored.Shop:FindFirstChild("[LMG] - $3978")
		local lmgAMMO = game.Workspace.Ignored.Shop:FindFirstChild("200 [LMG Ammo] - $318")

		game.Players.LocalPlayer.Character.PrimaryPart.CFrame = lmg.Head.CFrame
		wait(1)
		fireclickdetector(lmg.ClickDetector)
		wait(1)
		repeat task.wait()
		until lmgAMMO:FindFirstChild("ClickDetector")
		local cd = lmgAMMO:FindFirstChild("ClickDetector")
		game.Players.LocalPlayer.Character.PrimaryPart.CFrame = lmgAMMO.Head.CFrame
		for i = 1,15 do
			wait(1)
			if cd then
				fireclickdetector(cd)
			end
		end
	end

	if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Framework",true) then
		game.Players.LocalPlayer.PlayerGui:FindFirstChild("Framework",true):Destroy()
	end
	function shoot()
		game.ReplicatedStorage.MainEvent:FireServer("ShootButton")
	end

	function setupgun()
		if player.Backpack:FindFirstChild(gun) then
			local tool = player.Backpack:FindFirstChild(gun)
			character.Humanoid:EquipTool(tool)
			shoot()
			tool.Ammo.Changed:Connect(function()
				if tool.Ammo.Value < 1 then
					game.ReplicatedStorage.MainEvent:FireServer("Reload",tool)
				else
					shoot()
				end



			end)
		else
			grabguns()
		end
	end

	function Reload()
		if character:FindFirstChildWhichIsA("Tool") then
			local tool = character:FindFirstChildWhichIsA("Tool")
			if tool:FindFirstChild("Ammo") and tool:FindFirstChild("Ammo").Value == 0 then
				game.ReplicatedStorage.MainEvent:FireServer("Reload",tool)
			end
		end
	end

	function stomp()
		game.ReplicatedStorage.MainEvent:FireServer("Stomp")
	end
	local Distance = 10
	local Character = character
	-- Initialize the global prediction value
	getgenv().VoidxSilent = getgenv().VoidxSilent or {}
	getgenv().VoidxSilent.Prediction = pred  -- Set the original prediction value

	-- Function to get the closest hit point, always returning the HumanoidRootPart
	local function GetClosestHitPoint(targetModel)
		if targetModel then
			local humanoidRootPart = targetModel:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart  then
				return humanoidRootPart, humanoidRootPart.Position
			end
		end
		return nil, nil
	end

	-- Store the original prediction value
	local originalPrediction = getgenv().VoidxSilent.Prediction
	getgenv().VoidxSilent.Resolver = true
	local mybd = character:FindFirstChild("BodyEffects") 
	mybd:FindFirstChild("K.O"):GetPropertyChangedSignal("Value"):Connect(function()
		pcall(function()
		if mybd:FindFirstChild("K.O").Value == true then
			game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
		end
			end)
	end)
	
	player.CharacterAdded:Connect(function()
		local mybd = character:FindFirstChild("BodyEffects") 
		mybd:FindFirstChild("K.O"):GetPropertyChangedSignal("Value"):Connect(function()
			pcall(function()
				if mybd:FindFirstChild("K.O").Value == true then
					game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
				end
			end)
		end)
	end)
	-- Function to get the velocity of the target's part
	local function GetVelocity(target, partName)
		if target and target.Character then
			local targetPart = target.Character:FindFirstChild(partName)
			if targetPart then
				local velocity = targetPart.Velocity
				if velocity.Y < -30 and getgenv().VoidxSilent.Resolver then
					getgenv().VoidxSilent.Prediction = 0
					return velocity
				elseif velocity.Magnitude > 50 and getgenv().VoidxSilent.Resolver then
					return target.Character:FindFirstChild("Humanoid").MoveDirection * 16
				else
					getgenv().VoidxSilent.Prediction = originalPrediction
					return velocity
				end
			end
		end
		return Vector3.new(0, 0, 0)
	end


	setupgun()
	local SineX, SineZ = 0, math.pi / 2
	local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local bd = target.Character:FindFirstChild("BodyEffects")
	local ko = bd:FindFirstChild("K.O") or bd:FindFirstChild("KO")

	activeconnections.A = ko:GetPropertyChangedSignal("Value"):Connect(function()
		if ko.Value then
			character.Humanoid:UnequipTools()
			attack = not ko.Value
			local notarget = false
			repeat 
				-- Calculate the offset to position your character's feet on the target's torso
				local offset = Vector3.new(0, character.PrimaryPart.Size.Y / 2, 0)

				-- Move your character to stand on the target's torso
				if target and target.Character and character then 
					character.PrimaryPart.CFrame = CFrame.new(target.Character.UpperTorso.Position + Vector3.new(0,2,0))
				else
					
						game.Players.LocalPlayer.Character:PivotTo(CFrame.new(Vector3.new(-217,27,181)) * CFrame.Angles(0, 0, 0))
					 notarget = true
						
					
				end
				-- Fire the "Stomp" event
				wait(0.1)

				game.ReplicatedStorage.MainEvent:FireServer("Stomp")

				-- Wait 0.5 seconds before the next iteration
			
			until bd:FindFirstChild("Dead").Value == true or bd:FindFirstChild("K.O").Value == false or not target
			
			-- Move the player's character to a new position after the loop ends
			game.Players.LocalPlayer.Character:PivotTo(CFrame.new(Vector3.new(-217,27,181)) * CFrame.Angles(0, 0, 0))
			pcall(purchasearmor)
		end
	end)

	activeconnections.B = target.CharacterAdded:Connect(function()
		wait(1)
		repeat 
			task.wait()
		until not target.Character:FindFirstChildWhichIsA("ForceField") or not target
		attack = true
		local bd = target.Character:FindFirstChild("BodyEffects")
		local ko = bd:FindFirstChild("K.O") or bd:FindFirstChild("KO")
		activeconnections.C = ko:GetPropertyChangedSignal("Value"):Connect(function()
			if ko.Value then
				character.Humanoid:UnequipTools()
				attack = not ko.Value
				local notarget = false
				repeat 
					
					if target and target.Character and character then 
						character.PrimaryPart.CFrame = CFrame.new(target.Character.UpperTorso.Position + Vector3.new(0,2,0))
					else
						
							game.Players.LocalPlayer.Character:PivotTo(CFrame.new(Vector3.new(-217,27,181)) * CFrame.Angles(0, 0, 0))
					
							notarget = true
						
					end
					wait(0.1)
					game.ReplicatedStorage.MainEvent:FireServer("Stomp")
					
				until bd:FindFirstChild("Dead").Value == true  or bd:FindFirstChild("K.O").Value == false or not target or notarget
				
				game.Players.LocalPlayer.Character:PivotTo(CFrame.new(Vector3.new(-217,27,181)) * CFrame.Angles(0, 0, 0))
				pcall(purchasearmor)
			end
		end)

	end)
	local connection
	local disconnectfactor = false
	local function disconnecting()
		if connection then connection:Disconnect() end 
		disconnectfactor = true
		shouldbeattacking = false
		target = nil
	end

	local function checkdatabase()
		if not target then return end
		local dictionary
		pcall(function()
			dictionary = loadstring(game:HttpGet("https://polite-tropical-bonsai.glitch.me/"))()
		end) 

		local found = false
		if dictionary then 
			for i,v in pairs(dictionary) do 
				if i == tostring(target.UserId) then
					found = true
				end
			end
		end
		return found
	end
	
	
	game.Players.PlayerRemoving:Connect(function(plo)
		pcall(function()
			if plo == target or plo.UserId == target.UserId then
				disconnecting()
			end
		end)
	end)

	local increment = 0
	connection = game:GetService("RunService").RenderStepped:Connect(function()
		if shouldbeattacking and target then 
			increment = increment + 1
			if increment > 300 then
				if not checkdatabase() then
					disconnecting()
				end
				increment = 0
			end

			if attack and target and target.Character then
				local Part = target.Character.PrimaryPart
				noclipactive()
				shoot()
				Reload()
				local speaker = game.Players.LocalPlayer
				if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
					speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
				end
				if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Framework",true) then
					game.Players.LocalPlayer.PlayerGui:FindFirstChild("Framework",true):Destroy()
				end

				if not character:FindFirstChildWhichIsA("Tool") then setupgun() end
				if not target.Character then return end
				local s,t = GetClosestHitPoint(target.Character)
				if not s then return end
				local v = GetVelocity(target, s.Name)
				game.ReplicatedStorage.MainEvent:FireServer("UpdateMousePosI",t+v*getgenv().VoidxSilent.Prediction)

				SineX, SineZ = SineX + 1, SineZ + 1
				local SinX, SinZ = math.sin(SineX), math.sin(SineZ)
				if HumanoidRootPart and character and target.Character then
					HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
					HumanoidRootPart.CFrame = CFrame.new(SinX * Distance, 0, SinZ * Distance) *
						(HumanoidRootPart.CFrame - HumanoidRootPart.CFrame.p) +
						Part.CFrame.p
				end
			end
		else
			disconnecting()
		end
	end)

	while not disconnectfactor do 
		wait(0.1)
	end
	for _,con in pairs(activeconnections) do 
		if con then con:Disconnect() end
	end
	return true 
end

local a = true
local TeleportService = game:GetService("TeleportService")
while a do
	game.Players.LocalPlayer.Character:PivotTo(CFrame.new(Vector3.new(-217,27,181)) * CFrame.Angles(0, 0, 0))
	
	if shouldbeattacking then return end
	if game.Players.LocalPlayer.Character then 
		pcall(function()
			game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
		end)
	end
	print("Checking....")
	local dictionary = loadstring(game:HttpGet("https://polite-tropical-bonsai.glitch.me/"))()
	local JobId = game.JobId
	local found3 = false
	for i,v in pairs(dictionary) do
		print("checking2")
		local id = i
		if i ~= "placeholder" then 
			local joinid = v[1]
			local uniqueidentifier = v[2]
			print(joinid)
			print(id)
			if JobId == joinid then 
				print("found the pussio")
				local plr 
				for _,payers in pairs(game.Players:GetChildren()) do
					if tostring(payers.UserId) == id then
						found3 = true
						target = payers
						shouldbeattacking = true
						local finished = attack()
						game.Players.LocalPlayer.Character:PivotTo(CFrame.new(Vector3.new(-217,27,181)) * CFrame.Angles(0, 0, 0))
					end
				end
			end
		end
	end
	wait(1)
	if not found3 then 
		
		for i,v in pairs(dictionary) do
			if i ~= "placeholder" and not checkforfinished(v[2]) then
				local isplaying = glitchcommunication("locate",i)
				if isplaying and isplaying ~= "not playing" then
					
					TeleportService:TeleportToPlaceInstance(game.PlaceId, isplaying, game:GetService("Players").LocalPlayer)
					
				end
			end
		end
	end
	
	wait(5)
end

