--[[

HistoryStack.lua

Manage history, undo & redo of objects or commands.

	Supported object commands: undo(), redo(), print()

Created by: Dave Yang / Quantumwave Interactive Inc.

	http://qwmobile.com

Latest code: https://github.com/daveyang/HistoryStack

	Version: 1.0.1

--

The MIT License (MIT)

Copyright (c) 2016 Dave Yang / Quantumwave Interactive Inc. @ qwmobile.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

--]]

local HistoryStack = {}

---------------------------------------------------------------------------

function HistoryStack:new()
	local o = {}

	-- 2 stacks
	o.undos = {}
	o.redos = {}

	self.__index = self
	return setmetatable(o, self)
end

---------------------------------------------------------------------------

-- push object to top of undo stack
function HistoryStack:add(o)
	self.undos[#self.undos+1] = o
	self.redos = {}
end

---------------------------------------------------------------------------

-- pop top-most object from undo stack and save it to redo stack
-- return it or nil if nothing to undo
function HistoryStack:delete()
	if #self.undos>=1 then
		local o = self.undos[#self.undos]
		self.undos[#self.undos] = nil
		self.redos[#self.redos+1] = o
		return o
	else
		return nil
	end
end

---------------------------------------------------------------------------

-- return number of items in stack
function HistoryStack:getNumOfItems()
	return #self.undos
end

---------------------------------------------------------------------------

-- return item i from stack, or nil if out of range
function HistoryStack:getItemAt(i)
	local n = #self.undos
	if n>=1 and i>=1 and i<=n then
		return self.undos[i]
	else
		return nil
	end
end

---------------------------------------------------------------------------

-- return whether the operation is undoable
function HistoryStack:isUndoable()
	return #self.undos>=1
end

---------------------------------------------------------------------------

-- return whether the operation is redoable
function HistoryStack:isRedoable()
	return #self.redos>=1
end

---------------------------------------------------------------------------

-- undo last operation at top of stack, execute undo() if available
function HistoryStack:undo()
	local o = self:delete()

	if o~=nil and o.undo~=nil then
		o:undo()
	end
end

---------------------------------------------------------------------------

-- redo last undo operation and save it to the undo stack
-- execute redo() if available
function HistoryStack:redo()
	if #self.redos>=1 then
		local o = self.redos[#self.redos]
		self.redos[#self.redos] = nil
		self.undos[#self.undos+1] = o

		if o~=nil and o.redo~=nil then
			o:redo()
		end
	end
end

---------------------------------------------------------------------------

-- print all objects in stack, starting from the top of stack
-- object must have a print() method
function HistoryStack:print()
	local n = #self.undos
	for i = n,1,-1 do
		local o = self:getItemAt(i)
		if o~=nil and o.print~=nil then
			o:print()
		end
	end
	print("There are ".. n .." items in the stack.")
end

---------------------------------------------------------------------------

return HistoryStack
