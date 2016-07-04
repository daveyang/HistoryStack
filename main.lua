
-- main.lua
--
-- HistoryStack demo
--
-- Warning: Magic numbers ahead (mostly for buttons positioning)
-- For demo purpose only, don't do this at home (and especially at work)

local random = math.random
math.randomseed(os.time()+42) -- life is good, why not?

---------------------------------------------------------------------------

local Roll = require("Roll")
local ShowResultCmd = require("ShowResultCmd")

---------------------------------------------------------------------------

local cX = display.contentCenterX

local resultsTxt = native.newTextBox(cX, 25, 300, 252)
resultsTxt.anchorY = 0
resultsTxt.size = 18
resultsTxt.isEditable = false
resultsTxt.hasBackground = true
resultsTxt.isFontSizeScaled = true
resultsTxt.font = native.newFont("Menlo-Regular", resultsTxt.size)

---------------------------------------------------------------------------

local totalRollsTxt = display.newText("0", cX, 302, native.systemFont, resultsTxt.size)

---------------------------------------------------------------------------

local result = ShowResultCmd:new(resultsTxt, totalRollsTxt)

---------------------------------------------------------------------------

local function centerXYOfObj(o)
	local cb = o.contentBounds
	return (cb.xMin+cb.xMax)*0.5, (cb.yMin+cb.yMax)*0.5
end

---------------------------------------------------------------------------

local function setLabelForBtn(label, btn, font, fontSize)
	font = font or native.systemFontBold
	fontSize = fontSize or 18

	local x,y = centerXYOfObj(btn)
	return display.newText(label, x, y, font, fontSize)
end

---------------------------------------------------------------------------

-- simple rounded rect button factory
local function roundRectButton(x,y, w,h, label, touchHandler, r,g,b, radius)
	r = r or 0.5
	g = g or 0.5
	b = b or 0.5
	radius = radius or 15

	local bg = display.newRoundedRect(x, y, w, h, radius)
	bg.anchorX, bg.anchorY = 0,0
	bg:setFillColor(r, g, b)

	local btnLabel = setLabelForBtn(label, bg)

	local grp = display.newGroup()
	grp:insert(bg)
	grp:insert(btnLabel)
	grp.bg = bg
	grp.label = btnLabel

	if touchHandler~=nil and type(touchHandler)=="function" then
		grp:addEventListener("touch", touchHandler)
	end

	return grp
end

---------------------------------------------------------------------------

local function rollBtnOnTouch(e)
	if e.phase=="ended" then
		result:show( Roll:new(random(6), random(6), random(6)) )
	end
end

local rollBtn = roundRectButton(0,330, 320,70, "ROLL DICE", rollBtnOnTouch, 0.95,0.5,0)

---------------------------------------------------------------------------

local function undoBtnOnTouch(e)
	-- exit if button label is invisible
	if not e.target.label.isVisible then return end

	if e.phase=="ended" then result:undo() end
end

local undoBtn = roundRectButton(0,410, 155,70, "UNDO", undoBtnOnTouch)

-- cannot undo initially
undoBtn.label.isVisible = false

-- listen for button state updates
result:addEventListener("isUndoable", function(e) undoBtn.label.isVisible=e.state end)

---------------------------------------------------------------------------

local function redoBtnOnTouch(e)
	-- exit if button label is invisible
	if not e.target.label.isVisible then return end

	if e.phase=="ended" then result:redo() end
end

local redoBtn = roundRectButton(165,410, 155,70, "REDO", redoBtnOnTouch)

-- cannot redo initially
redoBtn.label.isVisible = false

-- listen for button state updates
result:addEventListener("isRedoable", function(e) redoBtn.label.isVisible=e.state end)

---------------------------------------------------------------------------
