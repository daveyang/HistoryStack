
-- ShowResultCmd.lua

local ShowResultCmd = {}

local EvtD = require("EventDispatcher")

-- make ShowResultCmd an event dispatcher
local dispatcher = EvtD(ShowResultCmd)

local HistoryStack = require("HistoryStack")

-- this holds all operations history
local history = HistoryStack:new()

-- this holds results text history
local resultsHistory = HistoryStack:new()

---------------------------------------------------------------------------

function ShowResultCmd:new(txtBox, totalTxt)
	local o = {
		txtBox = txtBox,
		totalTxt = totalTxt,
	}

	self.__index = self
	return setmetatable(o, self)
end

---------------------------------------------------------------------------

-- compose a string for displaying the result
function ShowResultCmd:composeResult(r)
	local bigSmall

	if r.isTriple then
		bigSmall = " X"
	elseif r.isBig then
		bigSmall = " B"
	elseif r.isSmall then
		bigSmall = " S"
	else
		bigSmall = "  "
	end

	if r.isDouble and not r.isTriple then
		bigSmall = bigSmall .." 2"
	elseif r.isTriple then
		bigSmall = bigSmall .." 3"
	else
		bigSmall = bigSmall .."  "
	end

	return r.n1 .." ".. r.n2 .." ".. r.n3 .." = ".. string.format("%2d", r.sum) .. bigSmall .."\n".. self.txtBox.text
end

---------------------------------------------------------------------------

function ShowResultCmd:updateTxt()
	local rTxt = resultsHistory:getItemAt( resultsHistory:getNumOfItems() )
	if rTxt==nil then
		self.txtBox.text = ""
	else
		self.txtBox.text = rTxt.txt
	end
end

---------------------------------------------------------------------------

function ShowResultCmd:updateTotal()
	self.totalTxt.text = history:getNumOfItems()

	-- update undo and redo button states
	dispatcher:dispatchEvent( {name="isUndoable", state=history:isUndoable()} )
	dispatcher:dispatchEvent( {name="isRedoable", state=history:isRedoable()} )
end

---------------------------------------------------------------------------

function ShowResultCmd:show(r)
	history:add(r)
	-- Demo purpose only: Adding each result to stack takes up more memory
	-- For actual development, adjust the displayed text instead
	resultsHistory:add({ txt=self:composeResult(r) })
	self:updateTxt()
	self:updateTotal()
end

---------------------------------------------------------------------------

function ShowResultCmd:undo()
	history:undo()
	resultsHistory:undo()
	self:updateTxt()
	self:updateTotal()
end

---------------------------------------------------------------------------

function ShowResultCmd:redo()
	history:redo()
	resultsHistory:redo()
	self:updateTxt()
	self:updateTotal()
end

---------------------------------------------------------------------------

return ShowResultCmd
