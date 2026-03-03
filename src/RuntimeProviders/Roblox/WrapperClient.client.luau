--!strict
--!native

-- Wrapper
local Actor = script:FindFirstAncestorWhichIsA("Actor")
if not Actor then return end

local Connection: RBXScriptConnection
Connection = Actor:BindToMessage("InitializeWrapper", function(Project: Folder, ...)
	if not script:GetAttribute("CanRun") then return end
	task.synchronize()

	Connection:Disconnect()
	Connection = nil :: any

	local FoundMain = Project:FindFirstChild("Main")
	assert(FoundMain, "Pajamas - Roblox: Cannot find the Main module under the project folder!");

	(require(FoundMain) :: any)(...)
end)
