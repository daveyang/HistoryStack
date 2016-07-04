
-- Roll.lua

local Roll = {}

---------------------------------------------------------------------------

function Roll:new(n1, n2, n3)
	local o = {}

	o.n1 = n1
	o.n2 = n2
	o.n3 = n3

	local sum = n1 + n2 + n3
	o.sum = sum

	o.isBig = (sum>=11) and (sum<=17)
	o.isSmall = (sum>=4) and (sum<=10)

	o.isTriple = (n1==n2) and (n2==n3)
	o.isDouble = (not o.isTriple) and ((n1==n2) or (n1==n3) or (n2==n3))

	self.__index = self
	return setmetatable(o, self)
end

---------------------------------------------------------------------------

function Roll:print()
	print(self.n1 .." ".. self.n2 .." ".. self.n3)
	print("sum = ".. self.sum)
	print("isBig = ".. tostring(self.isBig))
	print("isSmall = ".. tostring(self.isSmall))
	print("isDouble = ".. tostring(self.isDouble))
	print("isTriple = ".. tostring(self.isTriple))
	print("\n")
end

---------------------------------------------------------------------------

--[[
function Roll:undo()
	-- if there is a need, this will be executed by the HistoryStack
end

---------------------------------------------------------------------------

function Roll:redo()
	-- if there is a need, this will be executed by the HistoryStack
end
--]]
---------------------------------------------------------------------------

return Roll
