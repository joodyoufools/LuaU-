local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local BG = Color3.fromRGB(20, 9, 16)
local PANEL = Color3.fromRGB(17, 7, 19)
local PANEL_LIGHT = Color3.fromRGB(29, 11, 31)
local PLUM = Color3.fromRGB(96, 20, 66)
local PLUM_DEEP = Color3.fromRGB(74, 18, 46)
local PLUM_BRIGHT = Color3.fromRGB(206, 62, 148)
local PLUM_CLEAR = Color3.fromRGB(255, 110, 196)
local LAVENDER = Color3.fromRGB(233, 178, 221)
local CREAM = Color3.fromRGB(252, 236, 250)
local FADED = Color3.fromRGB(198, 158, 182)
local HEAD = Enum.Font.Arcade
local BODY = Enum.Font.Gotham
local BODY_BOLD = Enum.Font.Code

local function mk(cls, props)
	local i = Instance.new(cls)
	for k, v in pairs(props) do
		if k ~= "Parent" then i[k] = v end
	end
	i.Parent = props.Parent
	return i
end
local function corner(r, p)
	mk("UICorner", { CornerRadius = UDim.new(0, r), Parent = p })
end
local function stroke(c, t, tr, p)
	mk("UIStroke", { Color = c, Thickness = t, Transparency = tr, Parent = p })
end

local twinkles = {}
RunService.Heartbeat:Connect(function()
	local now = os.clock()
	for idx = #twinkles, 1, -1 do
		local s = twinkles[idx]
		if s.Parent then
			s.TextTransparency = 0.15 + (math.sin(now * s:GetAttribute("sp") + s:GetAttribute("ph")) + 1) * 0.22
		else
			table.remove(twinkles, idx)
		end
	end
end)

local function sparkle(parent, pos, scale)
	local s = mk("TextLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = pos,
		Size = UDim2.fromScale(scale, scale),
		Text = "\u{2756}",
		Font = Enum.Font.SourceSans,
		TextScaled = true,
		TextColor3 = LAVENDER,
		TextTransparency = 0.2,
		ZIndex = 45,
		Parent = parent,
	})
	mk("UIAspectRatioConstraint", { AspectRatio = 1, Parent = s })
	s:SetAttribute("sp", 1 + math.random() * 1.5)
	s:SetAttribute("ph", math.random() * 6.28)
	table.insert(twinkles, s)
	return s
end

local sg = mk("ScreenGui", {
	Name = "LottieHowToPlay", ResetOnSpawn = false,
	IgnoreGuiInset = true, DisplayOrder = 30, Parent = playerGui,
})

local btn = mk("TextButton", {
	BackgroundColor3 = PLUM,
	BackgroundTransparency = 0,
	BorderSizePixel = 0,
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0.5, 14, 1, -16),
	Size = UDim2.fromOffset(isMobile and 158 or 186, 46),
	Text = "\u{2756}  HOW TO PLAY  \u{2756}",
	Font = BODY_BOLD,
	TextSize = 15,
	TextColor3 = CREAM,
	AutoButtonColor = false,
	ZIndex = 10,
	Parent = sg,
})
corner(6, btn)
stroke(PLUM_CLEAR, 2.6, 0, btn)
mk("UIGradient", { Color = ColorSequence.new(PLUM_BRIGHT, PLUM_DEEP), Rotation = 90, Parent = btn })
local gloss = mk("Frame", {
	Size = UDim2.fromScale(1, 0.5), BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	BorderSizePixel = 0, ZIndex = 11, Parent = btn,
})
corner(6, gloss)
mk("UIGradient", {
	Rotation = 90,
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.86),
		NumberSequenceKeypoint.new(1, 1),
	}),
	Parent = gloss,
})
local bullet = mk("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 13, 0.5, 0),
	Size = UDim2.fromOffset(7, 7), Rotation = 45, BackgroundColor3 = LAVENDER,
	BackgroundTransparency = 0.2, BorderSizePixel = 0, ZIndex = 12, Parent = btn,
})
mk("UICorner", { CornerRadius = UDim.new(0.2, 0), Parent = bullet })
btn.MouseEnter:Connect(function()
	TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = PLUM_BRIGHT }):Play()
end)
btn.MouseLeave:Connect(function()
	TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = PLUM }):Play()
end)

local backdrop = mk("Frame", {
	BackgroundColor3 = Color3.new(0, 0, 0),
	BackgroundTransparency = 0.45,
	BorderSizePixel = 0,
	Size = UDim2.fromScale(1, 1),
	ZIndex = 40,
	Visible = false,
	Parent = sg,
})

local scale = mk("UIScale", { Scale = 1, Parent = nil })
local modal = mk("Frame", {
	BackgroundColor3 = PANEL,
	BackgroundTransparency = 0.05,
	BorderSizePixel = 0,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(isMobile and 0.94 or 0.6, 0.82),
	ZIndex = 41,
	Visible = false,
	ClipsDescendants = true,
	Parent = sg,
})
scale.Parent = modal
corner(16, modal)
stroke(LAVENDER, 1.4, 0.28, modal)
mk("UIGradient", {
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, PANEL_LIGHT),
		ColorSequenceKeypoint.new(0.5, PANEL),
		ColorSequenceKeypoint.new(1, BG),
	}),
	Rotation = 90, Parent = modal,
})
sparkle(modal, UDim2.fromScale(0.09, 0.12), 0.05)
sparkle(modal, UDim2.fromScale(0.91, 0.12), 0.05)

local header = mk("Frame", {
	BackgroundColor3 = PANEL_LIGHT, BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 0, 58), ZIndex = 42, Parent = modal,
})
mk("UIGradient", { Color = ColorSequence.new(PLUM_DEEP, PANEL), Rotation = 90, Parent = header })
mk("TextLabel", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 22, 0, 0), Size = UDim2.new(1, -74, 1, 0),
	Text = "\u{1F3AE}  How to Play",
	Font = HEAD, TextSize = isMobile and 18 or 22,
	TextColor3 = CREAM, TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 43, Parent = header,
})
local closeBtn = mk("TextButton", {
	BackgroundColor3 = PLUM_DEEP, BorderSizePixel = 0,
	AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0),
	Size = UDim2.fromOffset(36, 36), Text = "\u{2715}",
	Font = BODY_BOLD, TextSize = 18, TextColor3 = CREAM,
	AutoButtonColor = false, ZIndex = 44, Parent = header,
})
corner(10, closeBtn)
stroke(LAVENDER, 1, 0.3, closeBtn)

local scroll = mk("ScrollingFrame", {
	BackgroundTransparency = 1, BorderSizePixel = 0,
	Position = UDim2.new(0, 0, 0, 62), Size = UDim2.new(1, 0, 1, -62),
	CanvasSize = UDim2.new(),
	ScrollBarThickness = 4, ScrollBarImageColor3 = PLUM_CLEAR,
	ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 42, Parent = modal,
})
local listLayout = mk("UIListLayout", {
	Padding = UDim.new(0, 8),
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder, Parent = scroll,
})
mk("UIPadding", {
	PaddingTop = UDim.new(0, 18), PaddingBottom = UDim.new(0, 24),
	PaddingLeft = UDim.new(0, isMobile and 14 or 26),
	PaddingRight = UDim.new(0, isMobile and 14 or 26), Parent = scroll,
})

local order = 0
local function spacer(h)
	order += 1
	mk("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, h), LayoutOrder = order, Parent = scroll })
end

local function stepCard(num, title, body)
	order += 1
	local card = mk("Frame", {
		BackgroundColor3 = PANEL_LIGHT, BackgroundTransparency = 0.25, BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = order, Parent = scroll,
	})
	corner(12, card)
	stroke(LAVENDER, 1, 0.55, card)
	mk("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14), Parent = card })
	local inner = mk("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = card })
	mk("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 10), VerticalAlignment = Enum.VerticalAlignment.Top, Parent = inner })
	local badge = mk("Frame", { BackgroundColor3 = PLUM, BorderSizePixel = 0, Size = UDim2.fromOffset(32, 32), Parent = inner })
	corner(16, badge)
	stroke(LAVENDER, 1, 0.4, badge)
	mk("TextLabel", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = tostring(num), Font = BODY_BOLD, TextSize = 16, TextColor3 = CREAM, ZIndex = 43, Parent = badge })
	local textSide = mk("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, -42, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = inner })
	mk("UIListLayout", { Padding = UDim.new(0, 3), Parent = textSide })
	mk("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = title, Font = BODY_BOLD, TextSize = isMobile and 13 or 15, TextColor3 = CREAM, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 43, Parent = textSide })
	mk("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = body, Font = BODY, TextSize = isMobile and 12 or 13, TextColor3 = FADED, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 43, Parent = textSide })
end

local function sectionHeader(text)
	order += 1
	local f = mk("Frame", { BackgroundColor3 = PANEL_LIGHT, BackgroundTransparency = 0.2, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = order, Parent = scroll })
	corner(10, f)
	mk("UIPadding", { PaddingTop = UDim.new(0, 7), PaddingBottom = UDim.new(0, 7), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = f })
	mk("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = text, Font = HEAD, TextSize = isMobile and 14 or 17, TextColor3 = PLUM_CLEAR, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 43, Parent = f })
end

local function warningCard(text)
	order += 1
	local card = mk("Frame", { BackgroundColor3 = PLUM_DEEP, BackgroundTransparency = 0.15, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = order, Parent = scroll })
	corner(12, card)
	stroke(PLUM_CLEAR, 1.4, 0.2, card)
	mk("UIPadding", { PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14), Parent = card })
	mk("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = text, Font = BODY_BOLD, TextSize = isMobile and 13 or 15, TextColor3 = CREAM, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 43, Parent = card })
end

stepCard(1, "Join or create a show.", "Pick a Default (drawing), UGC, or Freeplay show in the browser, or make your own.")
stepCard(2, "Vote the round timers, then prepare.", "Draw your product in the studio, or pick 3 of your own UGC creations to advertise.")
stepCard(3, "Write your pitch.", "Sell it. Add a slogan, hype it up, set a poster. Preview passes moderation before it airs.")
stepCard(4, "Present live on stage.", "Your cutout floats beside you, your pitch types out, then Lottie judges you. Be good, or be funny \u{1F480}")
stepCard(5, "Crown the winner, then deal.", "Everyone votes the best product (70%) and Lottie picks her favorite (30%). Then invest, buy, and trade for Sparkles.")

spacer(4)
sectionHeader("\u{1F4A1}  Tips")
stepCard("+", "Earn Sparkles every round.", "Winners earn the most. Spend them in the Sparkle Boutique on brushes, auras and titles.")
stepCard("+", "Build a business.", "Name it, add a logo, and hire other players to advertise your items for you.")

spacer(6)
warningCard("\u{2728}  Lottie sees your ACTUAL drawing and judges it. An empty canvas gets roasted. You have been warned.")
spacer(8)

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.fromOffset(0, listLayout.AbsoluteContentSize.Y + 44)
end)

local isOpen = false
local function openModal()
	isOpen = true
	backdrop.Visible = true
	modal.Visible = true
	scale.Scale = 0.9
	modal.BackgroundTransparency = 1
	TweenService:Create(scale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
	TweenService:Create(modal, TweenInfo.new(0.25), { BackgroundTransparency = 0.05 }):Play()
end
local function closeModal()
	isOpen = false
	TweenService:Create(modal, TweenInfo.new(0.18), { BackgroundTransparency = 1 }):Play()
	task.delay(0.2, function()
		if not isOpen then
			modal.Visible = false
			backdrop.Visible = false
		end
	end)
end
btn.MouseButton1Click:Connect(function()
	if isOpen then closeModal() else openModal() end
end)
closeBtn.MouseButton1Click:Connect(closeModal)
backdrop.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
		closeModal()
	end
end)

local roundHidden = false
local function refreshVisible()
	local focus = player:GetAttribute("KharabnFocusMain") == true or player:GetAttribute("KharabnFocusBuild") == true
	btn.Visible = not roundHidden and not focus
	if (roundHidden or focus) and isOpen then closeModal() end
end
player:GetAttributeChangedSignal("KharabnFocusMain"):Connect(refreshVisible)
player:GetAttributeChangedSignal("KharabnFocusBuild"):Connect(refreshVisible)
local net = ReplicatedStorage:WaitForChild("LottieNet", 30)
if net then
	local stateChanged = net:FindFirstChild("StateChanged")
	if stateChanged then
		stateChanged.OnClientEvent:Connect(function(payload)
			local s = payload and payload.state
			roundHidden = s == "INTRO" or s == "DRAWING" or s == "PICKING" or s == "SPEECH" or s == "PRESENTING" or s == "CROWNING" or s == "INVESTING" or s == "BUILDING" or s == "DRESSING" or s == "INVESTORS" or s == "GPROMPT" or s == "GUESSING" or s == "REVEAL"
			refreshVisible()
		end)
	end
end
refreshVisible()
