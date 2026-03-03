--[[
	Pajamas Runtime: Main

	The entry point for the pajamas library.
	
	To use Pajamas, you must first register a provider created for Penumbra.
	Then, to use that provider, you must create a runtime object for it.
]]

-- Variables

local Types = require("@self/Types")

local Providers = {}
local Runtimes = {}
local Pajamas = {}

-- Types

type PajamasSrc = Types.PajamasSrc
type PajamasRuntime = Types.PajamasRuntime
type RuntimeProvider = Types.RuntimeProvider

-- Local Functions

--[[ 
	Coerces a string into: boolean, number, string, nil
	Used as all inputs to Pajamas are strings for compatibility with CLI.
]]
local function parse(str: string): (boolean | number | string)?
	if str == "true" or str == "false" then
		return str == "true"
	end
	
	return tonumber(str) or str
end

--[[
	Creates a pajamas runtime object.
]]
local function createRuntime(providerName: RuntimeProvider): PajamasRuntime
	local foundRuntimeProvider = Providers[providerName]
	assert(foundRuntimeProvider, `Pajamas - createRuntime: Could not find a runtime provider for the parameter: {providerName}`)
	
	local runtimeObject = {} :: PajamasRuntime
	
	function runtimeObject:init(projectLocation: any, ...: any)
		local params: {[number]: any} = {...}
		for i = 1, #params do
			params[i] = parse(params[i])
		end
		return foundRuntimeProvider(projectLocation, params)
	end
	
	Runtimes[providerName] = runtimeObject
	return runtimeObject
end

-- Module Functions

--[[
	Creates or finds a pajamas runtime with the provided provider name. 
]]

function Pajamas.runtime<T>(providerName: T | RuntimeProvider): PajamasRuntime
	local runtime = Runtimes[providerName] or createRuntime(providerName)
	return runtime
end

--[[
	Registers a pajamas runtime provider.
]]
function Pajamas.registerRuntimeProvider<T>(providerName: T | RuntimeProvider, provider: (...any) -> boolean): ()
	assert(typeof(providerName) == "string", "Pajamas - registerRuntimeProvider: First argument must be a string.")
	assert(typeof(provider) == "function", "Pajamas - registerRuntimeProvider: Second argument must be a function.")
	
	Providers[providerName] = provider
end

return Pajamas