--// Bloxhunt Exploit Repository //--
local Bloxhunt = {
	Utility = {};
	Exploits = {
		Hiders = {};
		Neutral = {AutoHealthRep=false;AutoEnergyRep=false};
		Seekers = {SeeProps = false}
	}
}

-- Services
local Players = game:GetService("Players")
local BindService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Utilities //--

function Bloxhunt.Utility:assignAdornment(Part, Color, Trans)
	local box = Instance.new("BoxHandleAdornment", workspace.CurrentCamera)
	box.Adornee = Part
	box.Size = Part.Size
	box.Name = Part.Parent.Name
	box.Color3 = Color
	box.Transparency = Trans
	box.ZIndex = 1
	box.AlwaysOnTop = true
	return box
end

--// Neutral Exploit Functions //--

-- Increases the amount of money you have by exploiting taunting bug
function Bloxhunt.Exploits.Neutral:addMoney(Amount)
	local totalAmount = math.ceil(Amount/2) -- This exploit adds amount by 2
	for i=1, totalAmount do
		local event = ReplicatedStorage.GameFunctions.Taunt
		event:FireServer()
	end
end

-- Gives local user all the game passes
function Bloxhunt.Exploits.Neutral:getGamepasses()
	for i,v in next, Players.LocalPlayer.Information.Gamepasses:GetChildren() do
		v.Value = true
	end
end

-- Stat change
function Bloxhunt.Exploits.Neutral:changeStat(Type, N)
	local statChange = ReplicatedStorage.GameFunctions.StatChange
	statChange:FireServer(Type, N)	
end

-- Replenish Energy
function Bloxhunt.Exploits.Neutral:replenishEnergy()
	self:changeStat("Energy", 100-Players.LocalPlayer.Information.Energy.Value)
end

-- Replenish Health
function Bloxhunt.Exploits.Neutral:replenishHealth()
	self:changeStat("Health", 100-Players.LocalPlayer.Character.Health.Value)
end

--// Seeker Specific Exploits //--

function Bloxhunt.Exploits.Seekers:findPropsWrapper()
	if (Bloxhunt.Exploits.Seekers.SeeProps) then
		for i,v in next, Players:GetChildren() do
			if (v.Character:FindFirstChild("Role").Value == "Hider" and v.Name ~= Players.LocalPlayer.Name) then
				local returnBox = Bloxhunt.Utility:assignAdornment(v.Character.HumanoidRootPart, Color3.new(0,0,1), 0.5)
				wait()
				returnBox:Destroy()
			end
 		end
	end
end

--// Hider Specific Exploits //--

-- Teleports local player to spawn so hiders cannot find
function Bloxhunt.Exploits.Hiders:saveSelf()
	Players.LocalPlayer.Character:MoveTo(Vector3.new(7.66472749e-06, 39.2799759, 2.99974847)) -- position of spawn
end

--// Initialization //--

function Bloxhunt.Exploits:pushConnections()
	-- TO-DO: CHANGE KEYBOARD INPUT WITH BUTTON PRESSES
	-- Prop ESP
	BindService:bindAction("propFind", function(togName, userInputState) 
		if (userInputState == Enum.UserInputState.Begin) then
			Bloxhunt.Exploits.Seekers.SeeProps = not Bloxhunt.Exploits.Seekers.SeeProps
		end
	end, false, Enum.KeyCode.F2)
	game:GetService("RunService").RenderStepped:Connect(self.Seekers.findPropsWrapper)
	-- Auto Regen Energy
	BindService:bindAction("Auto Regen Energy", function(togName, userInputState) 
	if (userInputState == Enum.UserInputState.Begin) then
		Bloxhunt.Exploits.Neutral.AutoEnergyRep = not Bloxhunt.Exploits.Neutral.AutoEnergyRep
	end
	end, false, Enum.KeyCode.F3)
	Players.LocalPlayer.Information.Energy.Changed:Connect(function()
		if (Bloxhunt.Exploits.Neutral.AutoEnergyRep) then
			Bloxhunt.Exploits.Neutral:replenishEnergy()
		end
	end)
	-- Auto Regen Health
	BindService:bindAction("Auto Regen Health", function(togName, userInputState) 
		if (userInputState == Enum.UserInputState.Begin) then
			Bloxhunt.Exploits.Neutral.AutoHealthRep = not Bloxhunt.Exploits.Neutral.AutoHealthRep
		end
	end, false, Enum.KeyCode.F4)
	Players.LocalPlayer.Character.Health.Changed:Connect(function()
		if (Bloxhunt.Exploits.Neutral.AutoHealthRep) then
			Bloxhunt.Exploits.Neutral:replenishHealth()
		end
	end)
end

Bloxhunt.Exploits:pushConnections()
