local StrikeMusicUI = {}

local COLORS = {
    Background = Color3.fromRGB(8, 11, 17),
    Panel = Color3.fromRGB(15, 19, 28),
    PanelSoft = Color3.fromRGB(18, 22, 32),
    PanelLight = Color3.fromRGB(25, 30, 42),
    Border = Color3.fromRGB(38, 45, 58),
    Text = Color3.fromRGB(245, 247, 255),
    Muted = Color3.fromRGB(157, 164, 180),
    Purple = Color3.fromRGB(137, 50, 235),
    PurpleBright = Color3.fromRGB(180, 80, 255),
    ProgressBack = Color3.fromRGB(42, 48, 61)
}

local TITLE_FONT = Enum.Font.GothamBold
local SECTION_TITLE_FONT = Enum.Font.GothamMedium

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = parent

    return corner
end

local function createStroke(parent, color, transparency, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or COLORS.Border
    stroke.Transparency = transparency or 0.45
    stroke.Thickness = thickness or 1
    stroke.Parent = parent

    return stroke
end

local function createLabel(parent, name, text, size, position, textSize, font, color)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = size
    label.Position = position or UDim2.new()
    label.BackgroundTransparency = 1
    label.Text = text or ""
    label.TextColor3 = color or COLORS.Text
    label.Font = font or Enum.Font.Gotham
    label.TextSize = textSize or 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.Parent = parent

    return label
end

local function createIconButton(parent, name, text, size, position)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = size
    button.Position = position or UDim2.new()
    button.BackgroundColor3 = COLORS.PanelLight
    button.BackgroundTransparency = 0.15
    button.BorderSizePixel = 0
    button.Text = text or ""
    button.TextColor3 = COLORS.Text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.AutoButtonColor = true
    button.Parent = parent
    createCorner(button, 10)

    return button
end

local function createPanel(parent, name, size, position)
    local panel = Instance.new("Frame")
    panel.Name = name
    panel.Size = size
    panel.Position = position or UDim2.new()
    panel.BackgroundColor3 = COLORS.Panel
    panel.BackgroundTransparency = 0.08
    panel.BorderSizePixel = 0
    panel.ClipsDescendants = true
    panel.Active = true
    panel.Parent = parent
    createCorner(panel, 10)
    createStroke(panel, COLORS.Border, 0.72, 1)

    return panel
end

local function createEmptyState(parent, text)
    local empty = createLabel(
        parent,
        "EmptyState",
        text,
        UDim2.new(1, -24, 0, 34),
        UDim2.new(0, 12, 0.5, -17),
        12,
        Enum.Font.GothamBold,
        COLORS.Muted
    )
    empty.TextXAlignment = Enum.TextXAlignment.Center

    return empty
end

local function clearContainer(container)
    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("GuiObject")
            or child:IsA("UIListLayout")
            or child:IsA("UIGridLayout")
        then
            child:Destroy()
        end
    end
end

local function createProgress(parent, position, size, value)
    local back = Instance.new("Frame")
    back.Name = "ProgressBack"
    back.Size = size
    back.Position = position
    back.BackgroundColor3 = COLORS.ProgressBack
    back.BorderSizePixel = 0
    back.Active = true
    back.Parent = parent
    createCorner(back, 4)

    local fill = Instance.new("Frame")
    fill.Name = "ProgressFill"
    fill.Size = UDim2.new(math.clamp(value or 0.18, 0, 1), 0, 1, 0)
    fill.BackgroundColor3 = COLORS.Purple
    fill.BorderSizePixel = 0
    fill.Parent = back
    createCorner(fill, 4)

    return back, fill
end

local function createVolumeSlider(parent, position, size, initialValue)
    local UserInputService = game:GetService("UserInputService")
    local changed = Instance.new("BindableEvent")
    local value = math.clamp(initialValue or 0.52, 0, 1)
    local dragging = false

    local back = Instance.new("Frame")
    back.Name = "VolumeSlider"
    back.Size = size
    back.Position = position
    back.BackgroundColor3 = COLORS.ProgressBack
    back.BorderSizePixel = 0
    back.Parent = parent
    createCorner(back, 4)

    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(value, 0, 1, 0)
    fill.BackgroundColor3 = COLORS.Purple
    fill.BorderSizePixel = 0
    fill.Parent = back
    createCorner(fill, 4)

    local knob = Instance.new("TextButton")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(value, -7, 0.5, -7)
    knob.BackgroundColor3 = COLORS.Text
    knob.BorderSizePixel = 0
    knob.Text = ""
    knob.AutoButtonColor = true
    knob.Active = true
    knob.Parent = back
    createCorner(knob, 7)

    local function setValue(nextValue, fireChanged)
        value = math.clamp(nextValue or 0, 0, 1)
        fill.Size = UDim2.new(value, 0, 1, 0)
        knob.Position = UDim2.new(value, -7, 0.5, -7)

        if fireChanged then
            changed:Fire(value)
        end
    end

    local function setFromX(x)
        local absoluteX = back.AbsolutePosition.X
        local width = math.max(back.AbsoluteSize.X, 1)
        setValue((x - absoluteX) / width, true)
    end

    back.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragging = true
            setFromX(input.Position.X)
        end
    end)

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragging = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging
            and (
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            )
        then
            setFromX(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragging = false
        end
    end)

    return {
        Root = back,
        Fill = fill,
        Knob = knob,
        Changed = changed.Event,
        SetValue = function(nextValue)
            setValue(nextValue, false)
        end,
        GetValue = function()
            return value
        end
    }
end

local function applyThumbnail(target, item)
    if item and item.thumbnail_url and tostring(item.thumbnail_url) ~= "" then
        target.Image = tostring(item.thumbnail_url)
        target.ImageTransparency = 0
        return
    end

    target.Image = ""
    target.ImageTransparency = 1
end

local function createArtFrame(parent, name, size, position, item)
    local holder = Instance.new("Frame")
    holder.Name = name
    holder.Size = size
    holder.Position = position or UDim2.new()
    holder.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
    holder.BorderSizePixel = 0
    holder.ClipsDescendants = true
    holder.Parent = parent
    createCorner(holder, 8)

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 38, 175)),
        ColorSequenceKeypoint.new(0.52, Color3.fromRGB(22, 31, 58)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 13, 20))
    })
    gradient.Rotation = 25
    gradient.Parent = holder

    local image = Instance.new("ImageLabel")
    image.Name = "Image"
    image.Size = UDim2.new(1, 0, 1, 0)
    image.BackgroundTransparency = 1
    image.ScaleType = Enum.ScaleType.Crop
    image.Parent = holder
    applyThumbnail(image, item)

    return holder, image
end

local function createSection(parent, name, title, position, size)
    local section = Instance.new("Frame")
    section.Name = name
    section.Size = size
    section.Position = position
    section.BackgroundTransparency = 1
    section.BorderSizePixel = 0
    section.Parent = parent

    local titleLabel = createLabel(
        section,
        "Title",
        title,
        UDim2.new(1, -24, 0, 24),
        UDim2.new(0, 4, 0, 0),
        13,
        SECTION_TITLE_FONT,
        COLORS.Text
    )
    titleLabel.TextColor3 = Color3.fromRGB(232, 236, 246)

    local prevButton = createIconButton(section, "PrevButton", "<", UDim2.new(0, 30, 0, 28), UDim2.new(1, -70, 0, -2))
    prevButton.BackgroundTransparency = 0.42
    prevButton.TextSize = 13
    prevButton.Visible = false

    local nextButton = createIconButton(section, "NextButton", ">", UDim2.new(0, 30, 0, 28), UDim2.new(1, -34, 0, -2))
    nextButton.BackgroundTransparency = 0.42
    nextButton.TextSize = 13
    nextButton.Visible = false

    local list = Instance.new("ScrollingFrame")
    list.Name = "List"
    list.Size = UDim2.new(1, 0, 1, -34)
    list.Position = UDim2.new(0, 0, 0, 34)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.ScrollBarThickness = 0
    list.ScrollingDirection = Enum.ScrollingDirection.X
    list.ScrollingEnabled = true
    list.Active = true
    list.Parent = section

    return section, list, titleLabel, prevButton, nextButton
end

local function createCard(parent, item, width, height)
    local card = Instance.new("Frame")
    card.Name = "MusicCard"
    card.Size = UDim2.new(0, width, 0, height)
    card.BackgroundColor3 = COLORS.PanelSoft
    card.BackgroundTransparency = 0.04
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.Parent = parent
    createCorner(card, 8)
    createStroke(card, COLORS.Border, 0.55, 1)

    createArtFrame(card, "Art", UDim2.new(1, 0, 0, math.max(height - 70, 72)), UDim2.new(), item)

    local play = createIconButton(
        card,
        "PlayButton",
        "▶",
        UDim2.new(0, 28, 0, 28),
        UDim2.new(1, -36, 0, math.max(height - 100, 52))
    )
    play.BackgroundColor3 = Color3.fromRGB(235, 238, 246)
    play.TextColor3 = Color3.fromRGB(15, 16, 22)
    play.TextSize = 14
    createCorner(play, 14)

    createLabel(
        card,
        "Name",
        tostring(item and item.title or "Sin titulo"),
        UDim2.new(1, -18, 0, 20),
        UDim2.new(0, 10, 1, -56),
        11,
        Enum.Font.GothamBold,
        COLORS.Text
    )

    createLabel(
        card,
        "Artist",
        tostring(item and item.artist or "Desconocido"),
        UDim2.new(1, -18, 0, 18),
        UDim2.new(0, 10, 1, -36),
        10,
        Enum.Font.Gotham,
        COLORS.Muted
    )

    createProgress(card, UDim2.new(0, 10, 1, -14), UDim2.new(1, -20, 0, 3), 0.18)

    return card, play
end

local function createWideRow(parent, item)
    local row = Instance.new("Frame")
    row.Name = "MusicRow"
    row.Size = UDim2.new(1, 0, 0, 48)
    row.BackgroundColor3 = COLORS.PanelSoft
    row.BackgroundTransparency = 0.78
    row.BorderSizePixel = 0
    row.Parent = parent

    createArtFrame(row, "Art", UDim2.new(0, 38, 0, 38), UDim2.new(0, 0, 0.5, -19), item)

    createLabel(
        row,
        "Name",
        tostring(item and item.title or "Sin titulo"),
        UDim2.new(1, -150, 0, 20),
        UDim2.new(0, 52, 0, 4),
        12,
        Enum.Font.GothamBold,
        COLORS.Text
    )

    createLabel(
        row,
        "Artist",
        tostring(item and item.artist or "Desconocido"),
        UDim2.new(1, -150, 0, 18),
        UDim2.new(0, 52, 0, 25),
        11,
        Enum.Font.Gotham,
        COLORS.Muted
    )

    createLabel(
        row,
        "Duration",
        tostring(item and item.duration_text or "--:--"),
        UDim2.new(0, 48, 1, 0),
        UDim2.new(1, -86, 0, 0),
        11,
        Enum.Font.Gotham,
        COLORS.Muted
    ).TextXAlignment = Enum.TextXAlignment.Right

    local more = createIconButton(row, "MoreButton", "...", UDim2.new(0, 28, 0, 28), UDim2.new(1, -32, 0.5, -14))
    more.BackgroundTransparency = 1
    more.TextColor3 = COLORS.Muted

    return row, more
end

function StrikeMusicUI.Create(parent, Theme)
    local theme = Theme or {
        Font = {
            Regular = Enum.Font.Gotham,
            Bold = Enum.Font.GothamBold
        }
    }

    local gui = Instance.new("ScreenGui")
    gui.Name = "StrikeMusicGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 1
    pcall(function()
        gui.ScreenInsets = Enum.ScreenInsets.None
    end)
    gui.Parent = parent

    local root = Instance.new("Frame")
    root.Name = "Root"
    root.Size = UDim2.new(1, 0, 1, 0)
    root.BackgroundColor3 = COLORS.Background
    root.BorderSizePixel = 0
    root.Active = true
    root.Parent = gui

    local inputBlocker = Instance.new("TextButton")
    inputBlocker.Name = "InputBlocker"
    inputBlocker.Size = UDim2.new(1, 0, 1, 0)
    inputBlocker.BackgroundTransparency = 1
    inputBlocker.BorderSizePixel = 0
    inputBlocker.Text = ""
    inputBlocker.Active = true
    inputBlocker.AutoButtonColor = false
    inputBlocker.ZIndex = 0
    inputBlocker.Parent = root

    local backgroundGradient = Instance.new("UIGradient")
    backgroundGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 10, 15)),
        ColorSequenceKeypoint.new(0.58, Color3.fromRGB(13, 18, 27)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 8, 12))
    })
    backgroundGradient.Rotation = 20
    backgroundGradient.Parent = root

    local closeButton = createIconButton(root, "CloseButton", "x", UDim2.new(0, 28, 0, 28), UDim2.new(1, -34, 0, 18))
    closeButton.BackgroundTransparency = 0.35
    closeButton.TextColor3 = Color3.fromRGB(255, 223, 187)

    local minimizeButton = createIconButton(root, "MinimizeButton", "-", UDim2.new(0, 28, 0, 28), UDim2.new(1, -70, 0, 18))
    minimizeButton.BackgroundTransparency = 0.35
    minimizeButton.TextColor3 = Color3.fromRGB(255, 223, 187)

    local minimizedButton = createIconButton(gui, "MinimizedButton", "StrikeMusic", UDim2.new(0, 156, 0, 42), UDim2.new(0, 18, 1, -60))
    minimizedButton.Visible = false
    minimizedButton.TextSize = 13
    minimizedButton.BackgroundColor3 = COLORS.PanelLight
    minimizedButton.BackgroundTransparency = 0.02
    minimizedButton.ZIndex = 20

    local sideBar = createPanel(root, "Sidebar", UDim2.new(0, 242, 1, -94), UDim2.new(0, 10, 0, 72))
    sideBar.BackgroundTransparency = 0.14

    local logoMark = createLabel(
        root,
        "LogoMark",
        "",
        UDim2.new(0, 34, 0, 34),
        UDim2.new(0, 32, 0, 58),
        31,
        Enum.Font.GothamBlack,
        Color3.fromRGB(170, 75, 255)
    )
    logoMark.TextXAlignment = Enum.TextXAlignment.Center
    logoMark.Visible = false

    local logoTitle = createLabel(
        root,
        "LogoTitle",
        "StrikeMusic",
        UDim2.new(0, 170, 0, 26),
        UDim2.new(1, -220, 0, 22),
        23,
        Enum.Font.GothamBold,
        COLORS.Text
    )

    createLabel(
        root,
        "LogoSubtitle",
        "PERSONAL",
        UDim2.new(0, 110, 0, 14),
        UDim2.new(1, -218, 0, 50),
        10,
        Enum.Font.GothamBold,
        COLORS.PurpleBright
    )

    local searchHolder = createPanel(root, "SearchHolder", UDim2.new(0.4, 0, 0, 46), UDim2.new(0.3, -3, 0, 16))
    searchHolder.BackgroundColor3 = Color3.fromRGB(14, 18, 26)
    searchHolder.BackgroundTransparency = 0
    createLabel(searchHolder, "SearchIcon", "O", UDim2.new(0, 28, 1, 0), UDim2.new(0, 14, 0, 0), 14, Enum.Font.GothamBold, COLORS.Muted)

    local searchInput = Instance.new("TextBox")
    searchInput.Name = "SearchInput"
    searchInput.Size = UDim2.new(1, -92, 1, 0)
    searchInput.Position = UDim2.new(0, 48, 0, 0)
    searchInput.BackgroundTransparency = 1
    searchInput.PlaceholderText = "Busca musica o pega link para ver resultados"
    searchInput.Text = ""
    searchInput.TextColor3 = COLORS.Text
    searchInput.PlaceholderColor3 = COLORS.Muted
    searchInput.Font = theme.Font.Regular or Enum.Font.Gotham
    searchInput.TextSize = 13
    searchInput.TextXAlignment = Enum.TextXAlignment.Left
    searchInput.ClearTextOnFocus = false
    searchInput.Parent = searchHolder

    local filterButton = createIconButton(searchHolder, "FilterButton", "+", UDim2.new(0, 38, 0, 34), UDim2.new(1, -44, 0.5, -17))
    filterButton.BackgroundTransparency = 1
    filterButton.TextColor3 = COLORS.Muted

    local navItems = {
        {"Home", "Home"},
        {"Search", "Search"},
        {"YourLibrary", "Your Library"},
        {"Downloads", "Downloads"},
        {"Playlists", "Playlists"},
        {"LikedSongs", "Liked Songs"},
        {"RecentlyPlayed", "Recently Played"}
    }

    local navButtons = {}
    local navIcons = {"H", "S", "L", "D", "P", "♥", "R"}
    local navY = 8

    for index, item in ipairs(navItems) do
        local button = Instance.new("TextButton")
        button.Name = item[1] .. "Button"
        button.Size = UDim2.new(1, -30, 0, 42)
        button.Position = UDim2.new(0, 15, 0, navY)
        button.BackgroundColor3 = index == 1 and COLORS.Purple or COLORS.Panel
        button.BackgroundTransparency = index == 1 and 0.15 or 1
        button.BorderSizePixel = 0
        button.Text = ""
        button.TextColor3 = COLORS.Text
        button.Font = theme.Font.Bold or Enum.Font.GothamBold
        button.TextSize = 13
        button.TextXAlignment = Enum.TextXAlignment.Left
        button.Parent = sideBar
        createCorner(button, 9)

        local icon = createLabel(button, "Icon", navIcons[index] or "", UDim2.new(0, 32, 1, 0), UDim2.new(0, 14, 0, 0), 15, Enum.Font.GothamBold, COLORS.Text)
        icon.TextXAlignment = Enum.TextXAlignment.Center

        local text = createLabel(button, "Label", item[2], UDim2.new(1, -62, 1, 0), UDim2.new(0, 62, 0, 0), 13, theme.Font.Bold or Enum.Font.GothamBold, COLORS.Text)
        text.TextXAlignment = Enum.TextXAlignment.Left

        navButtons[item[1]] = button
        navY += 49
    end

    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, -42, 0, 1)
    divider.Position = UDim2.new(0, 21, 0, navY + 3)
    divider.BackgroundColor3 = COLORS.Border
    divider.BackgroundTransparency = 0.55
    divider.BorderSizePixel = 0
    divider.Parent = sideBar

    createLabel(sideBar, "PlaylistLabel", "PLAYLISTS", UDim2.new(1, -42, 0, 18), UDim2.new(0, 28, 0, navY + 22), 10, Enum.Font.GothamBold, COLORS.Muted)

    local playlistNames = {
        "My Favorites",
        "Workout Mix",
        "Chill Vibes",
        "Gaming Mix",
        "New Playlist"
    }

    local playlistY = navY + 58

    for index, name in ipairs(playlistNames) do
        local label = createLabel(sideBar, "Playlist" .. tostring(index), name, UDim2.new(1, -48, 0, 28), UDim2.new(0, 54, 0, playlistY), 13, Enum.Font.Gotham, COLORS.Text)
        createLabel(sideBar, "PlaylistIcon" .. tostring(index), index == 1 and "<3" or "+", UDim2.new(0, 30, 0, 28), UDim2.new(0, 28, 0, playlistY), 14, Enum.Font.GothamBold, index == 1 and COLORS.PurpleBright or COLORS.Muted).TextXAlignment = Enum.TextXAlignment.Center
        playlistY += 44
    end

    local centerPanel = createPanel(root, "CenterPanel", UDim2.new(1, -526, 1, -192), UDim2.new(0, 260, 0, 72))
    centerPanel.BackgroundTransparency = 0.19

    local centerScroll = Instance.new("ScrollingFrame")
    centerScroll.Name = "ContentScroll"
    centerScroll.Size = UDim2.new(1, 0, 1, 0)
    centerScroll.BackgroundTransparency = 1
    centerScroll.BorderSizePixel = 0
    centerScroll.CanvasSize = UDim2.new(0, 0, 0, 610)
    centerScroll.ScrollBarThickness = 3
    centerScroll.ScrollBarImageColor3 = COLORS.Purple
    centerScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    centerScroll.Active = true
    centerScroll.Parent = centerPanel

    local rightPanel = createPanel(root, "RightPanel", UDim2.new(0, 242, 1, -94), UDim2.new(1, -252, 0, 72))
    rightPanel.BackgroundTransparency = 0.08

    local bottomPlayer = createPanel(root, "BottomPlayer", UDim2.new(1, -20, 0, 80), UDim2.new(0, 10, 1, -90))
    bottomPlayer.BackgroundTransparency = 0.02

    local searchSection, searchList, searchTitle, searchPrevButton, searchNextButton = createSection(
        centerScroll,
        "SearchResultsSection",
        "RESULTADOS DE BUSQUEDA :",
        UDim2.new(0, 24, 0, 6),
        UDim2.new(1, -48, 0, 200)
    )

    local popularSection, popularList, popularTitle, popularPrevButton, popularNextButton = createSection(
        centerScroll,
        "PopularSection",
        "MAS ESCUCHADAS EN STRIKE MUSIC:",
        UDim2.new(0, 24, 0, 216),
        UDim2.new(1, -48, 0, 200)
    )

    local recentPanel = createPanel(centerScroll, "RecentPanel", UDim2.new(1, -48, 0, 150), UDim2.new(0, 24, 0, 432))
    recentPanel.BackgroundTransparency = 0.62
    createLabel(recentPanel, "Title", "Recently Played", UDim2.new(1, -100, 0, 30), UDim2.new(0, 0, 0, -34), 17, TITLE_FONT, COLORS.Text)

    local seeAllButton = createIconButton(recentPanel, "SeeAllButton", "See all", UDim2.new(0, 76, 0, 28), UDim2.new(1, -80, 0, -34))
    seeAllButton.TextSize = 11
    seeAllButton.BackgroundColor3 = COLORS.PanelLight
    seeAllButton.BackgroundTransparency = 0.28

    local recentList = Instance.new("Frame")
    recentList.Name = "List"
    recentList.Size = UDim2.new(1, -22, 1, -20)
    recentList.Position = UDim2.new(0, 11, 0, 10)
    recentList.BackgroundTransparency = 1
    recentList.Parent = recentPanel

    local recentLayout = Instance.new("UIListLayout")
    recentLayout.FillDirection = Enum.FillDirection.Vertical
    recentLayout.Padding = UDim.new(0, 2)
    recentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    recentLayout.Parent = recentList

    local rightTitle = createLabel(rightPanel, "Title", "Now Playing", UDim2.new(1, -32, 0, 30), UDim2.new(0, 16, 0, 4), 15, SECTION_TITLE_FONT, COLORS.Text)

    local nowArt = createArtFrame(rightPanel, "NowArt", UDim2.new(1, -32, 0, 168), UDim2.new(0, 16, 0, 30), nil)
    local nowTitle = createLabel(rightPanel, "NowTitle", "Nada reproduciendose", UDim2.new(1, -60, 0, 26), UDim2.new(0, 16, 0, 208), 17, TITLE_FONT, COLORS.Text)
    local heartButton = createIconButton(rightPanel, "HeartButton", "♥", UDim2.new(0, 38, 0, 38), UDim2.new(1, -60, 0, 312))
    heartButton.BackgroundTransparency = 0.82
    heartButton.TextColor3 = COLORS.PurpleBright
    heartButton.TextSize = 17
    heartButton.Size = UDim2.new(0, 32, 0, 32)
    heartButton.Position = UDim2.new(1, -48, 0, 204)
    local nowArtist = createLabel(rightPanel, "NowArtist", "Selecciona una cancion", UDim2.new(1, -32, 0, 20), UDim2.new(0, 16, 0, 236), 12, Enum.Font.Gotham, COLORS.Muted)

    local nowProgress, nowProgressFill = createProgress(rightPanel, UDim2.new(0, 16, 0, 272), UDim2.new(1, -32, 0, 4), 0)
    local currentTime = createLabel(rightPanel, "CurrentTime", "0:00", UDim2.new(0, 50, 0, 20), UDim2.new(0, 16, 0, 280), 10, Enum.Font.Gotham, COLORS.Muted)
    local totalTime = createLabel(rightPanel, "TotalTime", "0:00", UDim2.new(0, 50, 0, 20), UDim2.new(1, -66, 0, 280), 10, Enum.Font.Gotham, COLORS.Muted)
    totalTime.TextXAlignment = Enum.TextXAlignment.Right

    local controls = Instance.new("Frame")
    controls.Name = "Controls"
    controls.Size = UDim2.new(1, -32, 0, 52)
    controls.Position = UDim2.new(0, 16, 0, 308)
    controls.BackgroundTransparency = 1
    controls.Parent = rightPanel

    local shuffleButton = createIconButton(controls, "ShuffleButton", "x", UDim2.new(0, 30, 0, 30), UDim2.new(0, 0, 0.5, -15))
    local previousButton = createIconButton(controls, "PreviousButton", "|<", UDim2.new(0, 34, 0, 34), UDim2.new(0.25, -17, 0.5, -17))
    local playButton = createIconButton(controls, "PlayButton", "||", UDim2.new(0, 52, 0, 52), UDim2.new(0.5, -26, 0.5, -26))
    local nextButton = createIconButton(controls, "NextButton", ">|", UDim2.new(0, 34, 0, 34), UDim2.new(0.75, -17, 0.5, -17))
    local repeatButton = createIconButton(controls, "RepeatButton", "o", UDim2.new(0, 30, 0, 30), UDim2.new(1, -30, 0.5, -15))

    for _, button in ipairs({shuffleButton, previousButton, nextButton, repeatButton}) do
        button.BackgroundTransparency = 1
        button.TextColor3 = COLORS.Muted
    end

    playButton.BackgroundColor3 = COLORS.Purple
    playButton.TextSize = 22
    createCorner(playButton, 26)

    local queueDivider = Instance.new("Frame")
    queueDivider.Size = UDim2.new(1, -32, 0, 1)
    queueDivider.Position = UDim2.new(0, 16, 0, 382)
    queueDivider.BackgroundColor3 = COLORS.Border
    queueDivider.BackgroundTransparency = 0.72
    queueDivider.BorderSizePixel = 0
    queueDivider.Parent = rightPanel

    createLabel(rightPanel, "UpNextTitle", "Up Next", UDim2.new(1, -100, 0, 24), UDim2.new(0, 16, 0, 394), 13, SECTION_TITLE_FONT, COLORS.Text)
    local clearQueueButton = createIconButton(rightPanel, "ClearQueueButton", "Clear", UDim2.new(0, 50, 0, 24), UDim2.new(1, -66, 0, 393))
    clearQueueButton.TextSize = 11
    clearQueueButton.BackgroundColor3 = COLORS.PanelLight
    clearQueueButton.BackgroundTransparency = 0.2

    local queueList = Instance.new("Frame")
    queueList.Name = "QueueList"
    queueList.Size = UDim2.new(1, -32, 1, -456)
    queueList.Position = UDim2.new(0, 16, 0, 424)
    queueList.BackgroundTransparency = 1
    queueList.Parent = rightPanel

    local queueLayout = Instance.new("UIListLayout")
    queueLayout.FillDirection = Enum.FillDirection.Vertical
    queueLayout.Padding = UDim.new(0, 4)
    queueLayout.SortOrder = Enum.SortOrder.LayoutOrder
    queueLayout.Parent = queueList

    local bottomArt = createArtFrame(bottomPlayer, "Art", UDim2.new(0, 56, 0, 56), UDim2.new(0, 18, 0.5, -28), nil)
    local bottomTitle = createLabel(bottomPlayer, "Title", "Nada reproduciendose", UDim2.new(0, 280, 0, 24), UDim2.new(0, 94, 0, 17), 15, TITLE_FONT, COLORS.Text)
    local bottomArtist = createLabel(bottomPlayer, "Artist", "Selecciona una cancion", UDim2.new(0, 260, 0, 20), UDim2.new(0, 94, 0, 43), 12, Enum.Font.Gotham, COLORS.Muted)
    local bottomHeart = createIconButton(bottomPlayer, "HeartButton", "♥", UDim2.new(0, 30, 0, 30), UDim2.new(0, 230, 0, 45))
    bottomHeart.BackgroundTransparency = 0.82
    bottomHeart.TextColor3 = COLORS.PurpleBright
    bottomHeart.TextSize = 17
    bottomHeart.Size = UDim2.new(0, 26, 0, 26)
    bottomHeart.Position = UDim2.new(0, 218, 0, 39)

    local bottomControls = Instance.new("Frame")
    bottomControls.Name = "Controls"
    bottomControls.Size = UDim2.new(0, 390, 0, 42)
    bottomControls.Position = UDim2.new(0.5, -195, 0, 6)
    bottomControls.BackgroundTransparency = 1
    bottomControls.Parent = bottomPlayer

    createIconButton(bottomControls, "ShuffleButton", "x", UDim2.new(0, 30, 0, 30), UDim2.new(0, 42, 0.5, -15)).BackgroundTransparency = 1
    createIconButton(bottomControls, "PreviousButton", "|<", UDim2.new(0, 32, 0, 32), UDim2.new(0, 96, 0.5, -16)).BackgroundTransparency = 1
    local bottomPlay = createIconButton(bottomControls, "PlayButton", "||", UDim2.new(0, 42, 0, 42), UDim2.new(0.5, -21, 0, 0))
    bottomPlay.BackgroundColor3 = COLORS.Purple
    createCorner(bottomPlay, 21)
    createIconButton(bottomControls, "NextButton", ">|", UDim2.new(0, 32, 0, 32), UDim2.new(1, -128, 0.5, -16)).BackgroundTransparency = 1
    createIconButton(bottomControls, "RepeatButton", "o", UDim2.new(0, 30, 0, 30), UDim2.new(1, -72, 0.5, -15)).BackgroundTransparency = 1

    local bottomProgress, bottomProgressFill = createProgress(bottomPlayer, UDim2.new(0.31, 0, 0, 60), UDim2.new(0.38, 0, 0, 4), 0)
    local bottomCurrent = createLabel(bottomPlayer, "CurrentTime", "0:00", UDim2.new(0, 48, 0, 20), UDim2.new(0.28, 0, 0, 52), 10, Enum.Font.Gotham, COLORS.Muted)
    local bottomTotal = createLabel(bottomPlayer, "TotalTime", "0:00", UDim2.new(0, 48, 0, 20), UDim2.new(0.69, 0, 0, 52), 10, Enum.Font.Gotham, COLORS.Muted)
    bottomTotal.TextXAlignment = Enum.TextXAlignment.Right

    local volumeIcon = createLabel(bottomPlayer, "VolumeIcon", "V", UDim2.new(0, 26, 0, 26), UDim2.new(0.82, 0, 0.5, -13), 15, Enum.Font.GothamBold, COLORS.Muted)
    volumeIcon.TextXAlignment = Enum.TextXAlignment.Center
    local volumeSlider = createVolumeSlider(bottomPlayer, UDim2.new(0.86, 0, 0.5, -2), UDim2.new(0.1, 0, 0, 4), 0.52)

    local lists = {
        Search = searchList,
        Popular = popularList,
        Recent = recentList,
        Queue = queueList
    }

    local function attachCardCarousel(container, count, cardWidth, cardHeight, prevButton, nextButton)
        local UserInputService = game:GetService("UserInputService")
        local padding = 12
        local contentWidth = math.max((count * cardWidth) + (math.max(count - 1, 0) * padding), 0)

        container.CanvasPosition = Vector2.new(0, 0)
        container.CanvasSize = UDim2.new(0, contentWidth, 0, cardHeight)
        container:SetAttribute("StrikeMusicCarouselContentWidth", contentWidth)

        local function getVisibleWidth()
            return math.max(container.AbsoluteSize.X, 1)
        end

        local function refreshButtons()
            local visibleWidth = getVisibleWidth()
            local hasOverflow = visibleWidth > 1 and contentWidth > visibleWidth + 2

            if prevButton then
                prevButton.Visible = hasOverflow
            end

            if nextButton then
                nextButton.Visible = hasOverflow
            end
        end

        refreshButtons()
        task.defer(refreshButtons)

        local function move(direction)
            local visibleWidth = getVisibleWidth()
            local maxX = math.max(contentWidth - visibleWidth, 0)
            local step = math.max(cardWidth + padding, 1)
            local nextX = math.clamp(container.CanvasPosition.X + (direction * step), 0, maxX)
            container.CanvasPosition = Vector2.new(nextX, 0)
        end

        if prevButton and not prevButton:GetAttribute("StrikeMusicCarouselBound") then
            prevButton:SetAttribute("StrikeMusicCarouselBound", true)
            prevButton.MouseButton1Click:Connect(function()
                move(-1)
            end)
        end

        if nextButton and not nextButton:GetAttribute("StrikeMusicCarouselBound") then
            nextButton:SetAttribute("StrikeMusicCarouselBound", true)
            nextButton.MouseButton1Click:Connect(function()
                move(1)
            end)
        end

        if not container:GetAttribute("StrikeMusicDragBound") then
            container:SetAttribute("StrikeMusicDragBound", true)

            local dragging = false
            local dragStartX = 0
            local dragStartCanvasX = 0

            local function getMaxCanvasX()
                local latestContentWidth = tonumber(container:GetAttribute("StrikeMusicCarouselContentWidth")) or 0
                return math.max(latestContentWidth - getVisibleWidth(), 0)
            end

            container.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch
                then
                    dragging = true
                    dragStartX = input.Position.X
                    dragStartCanvasX = container.CanvasPosition.X
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging
                    and (
                        input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch
                    )
                then
                    local delta = input.Position.X - dragStartX
                    local nextX = math.clamp(dragStartCanvasX - delta, 0, getMaxCanvasX())
                    container.CanvasPosition = Vector2.new(nextX, 0)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch
                then
                    dragging = false
                end
            end)
        end

        return padding
    end

    local function createCardLayout(container, padding)
        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.Padding = UDim.new(0, padding)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = container

        return layout
    end

    local function renderPlaceholderCards(container, cardWidth, cardHeight, count, prevButton, nextButton)
        count = count or 4
        local padding = attachCardCarousel(container, count, cardWidth, cardHeight, prevButton, nextButton)
        createCardLayout(container, padding)

        for _ = 1, count or 4 do
            createCard(
                container,
                {
                    title = "Nombre de Musica",
                    artist = "Artista"
                },
                cardWidth,
                cardHeight
            )
        end
    end

    local function renderCards(container, items, emptyText, cardWidth, cardHeight, maxItems, prevButton, nextButton)
        clearContainer(container)

        items = items or {}

        if #items == 0 then
            if emptyText == "__placeholder_cards" then
                renderPlaceholderCards(container, cardWidth, cardHeight, maxItems or 4, prevButton, nextButton)
            elseif emptyText and emptyText ~= "" then
                if prevButton then
                    prevButton.Visible = false
                end

                if nextButton then
                    nextButton.Visible = false
                end

                container.CanvasSize = UDim2.new(0, 0, 0, 0)
                createEmptyState(container, emptyText)
            end
            return
        end

        local count = maxItems and math.min(#items, maxItems) or #items
        local padding = attachCardCarousel(container, count, cardWidth, cardHeight, prevButton, nextButton)
        createCardLayout(container, padding)

        for index, item in ipairs(items) do
            if maxItems and index > maxItems then
                break
            end

            createCard(container, item, cardWidth, cardHeight)
        end
    end

    local function renderRows(container, items, emptyText, maxItems)
        clearContainer(container)

        items = items or {}

        if #items == 0 then
            if emptyText and emptyText ~= "" then
                createEmptyState(container, emptyText)
            end
            return
        end

        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.Padding = UDim.new(0, 2)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = container

        for index, item in ipairs(items) do
            if maxItems and index > maxItems then
                break
            end

            createWideRow(container, item)
        end
    end

    minimizeButton.MouseButton1Click:Connect(function()
        root.Visible = false
        minimizedButton.Visible = true
    end)

    minimizedButton.MouseButton1Click:Connect(function()
        minimizedButton.Visible = false
        root.Visible = true
    end)

    local api = {
        Gui = gui,
        Root = root,
        CloseButton = closeButton,
        MinimizeButton = minimizeButton,
        MinimizedButton = minimizedButton,
        SearchInput = searchInput,
        FilterButton = filterButton,
        NavButtons = navButtons,
        SeeAllButton = seeAllButton,
        ClearQueueButton = clearQueueButton,
        VolumeSlider = volumeSlider,
        Buttons = {
            Play = playButton,
            Previous = previousButton,
            Next = nextButton,
            Shuffle = shuffleButton,
            Repeat = repeatButton,
            BottomPlay = bottomPlay,
            Heart = heartButton,
            BottomHeart = bottomHeart
        },
        Lists = lists,
        RenderSearchResults = function(items)
            renderCards(searchList, items, "__placeholder_cards", 150, 150, nil, searchPrevButton, searchNextButton)
        end,
        RenderPopular = function(items)
            renderCards(popularList, items, "__placeholder_cards", 150, 150, nil, popularPrevButton, popularNextButton)
        end,
        RenderRecent = function(items)
            renderRows(recentList, items, "", 3)
        end,
        RenderQueue = function(items)
            renderRows(queueList, items, "La cola esta vacia.", 5)
        end,
        SetNowPlaying = function(item, progress, currentText, totalText)
            local title = item and item.title or "Nada reproduciendose"
            local artist = item and item.artist or "Selecciona una cancion"

            nowTitle.Text = title
            nowArtist.Text = artist
            bottomTitle.Text = title
            bottomArtist.Text = artist
            currentTime.Text = currentText or "0:00"
            totalTime.Text = totalText or "0:00"
            bottomCurrent.Text = currentText or "0:00"
            bottomTotal.Text = totalText or "0:00"
            nowProgressFill.Size = UDim2.new(math.clamp(progress or 0, 0, 1), 0, 1, 0)
            bottomProgressFill.Size = UDim2.new(math.clamp(progress or 0, 0, 1), 0, 1, 0)

            local nowImage = nowArt:FindFirstChild("Image")
            local bottomImage = bottomArt:FindFirstChild("Image")

            if nowImage then
                applyThumbnail(nowImage, item)
            end

            if bottomImage then
                applyThumbnail(bottomImage, item)
            end
        end,
        Destroy = function()
            gui:Destroy()
        end
    }

    api.RenderSearchResults({})
    api.RenderPopular({})
    api.RenderRecent({})
    api.RenderQueue({})
    api.SetNowPlaying(nil, 0)

    if _G.StrikeChatLayoutMode == "mobile" then
        sideBar.Size = UDim2.new(0, 210, 1, -90)
        sideBar.Position = UDim2.new(0, 8, 0, 66)
        centerPanel.Position = UDim2.new(0, 226, 0, 66)
        centerPanel.Size = UDim2.new(1, -454, 1, -180)
        rightPanel.Size = UDim2.new(0, 210, 1, -90)
        rightPanel.Position = UDim2.new(1, -218, 0, 66)
        bottomPlayer.Size = UDim2.new(1, -16, 0, 76)
        bottomPlayer.Position = UDim2.new(0, 8, 1, -84)
        searchHolder.Position = UDim2.new(0.31, -1, 0, 14)
        searchHolder.Size = UDim2.new(0.38, 0, 0, 42)
    end

    return api
end

return StrikeMusicUI
