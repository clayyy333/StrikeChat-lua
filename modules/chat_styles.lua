local ChatStyles = {}

local TweenService = game:GetService("TweenService")

local function lower(value)
    return tostring(value or ""):lower()
end

local function makeColorSequence(points)
    local keypoints = {}

    for _, point in ipairs(points) do
        table.insert(keypoints, ColorSequenceKeypoint.new(point[1], point[2]))
    end

    return ColorSequence.new(keypoints)
end

local function makeTransparencySequence(points)
    local keypoints = {}

    for _, point in ipairs(points) do
        table.insert(keypoints, NumberSequenceKeypoint.new(point[1], point[2]))
    end

    return NumberSequence.new(keypoints)
end

function ChatStyles.Get(message, Theme)
    local chatStyle = lower(message and message.chat_style)
    local chatColor = lower(message and message.chat_color)

    if chatStyle == "galaxy"
        or chatStyle == "galaxydream"
        or chatStyle == "galaxy_dream"
        or chatStyle == "chat_style_galaxy"
        or chatStyle == "chat_style_galaxy_dream"
        or chatStyle == "chat_style_cloud"
    then
        return {
            name = "GalaxyDream",
            textColor = Theme.Colors.Text,
            starColors = {
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(120, 180, 255),
                Color3.fromRGB(180, 110, 255),
                Color3.fromRGB(90, 235, 255)
            },
            gradientColors = {
                { 0.00, Theme.Colors.Panel },
                { 0.14, Color3.fromRGB(16, 26, 70) },
                { 0.28, Color3.fromRGB(54, 25, 118) },
                { 0.46, Color3.fromRGB(147, 50, 188) },
                { 0.62, Color3.fromRGB(45, 88, 190) },
                { 0.78, Color3.fromRGB(24, 185, 225) },
                { 0.90, Color3.fromRGB(54, 65, 115) },
                { 0.96, Color3.fromRGB(45, 48, 70) },
                { 1.00, Theme.Colors.Panel }
            }
        }
    end

    if chatColor == "pink"
        or chatColor == "chat_color_pink"
        or chatStyle == "cloud"
        or chatStyle == "cutecloud"
    then
        return {
            name = "CuteCloud",
            textColor = Color3.fromRGB(42, 48, 76),
            starColors = {
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(184, 244, 255),
                Color3.fromRGB(255, 223, 247)
            },
            gradientColors = {
                { 0.00, Theme.Colors.Panel },
                { 0.16, Color3.fromRGB(210, 230, 255) },
                { 0.34, Color3.fromRGB(238, 247, 255) },
                { 0.52, Color3.fromRGB(255, 223, 247) },
                { 0.72, Color3.fromRGB(216, 199, 255) },
                { 0.88, Color3.fromRGB(184, 244, 255) },
                { 0.96, Color3.fromRGB(105, 134, 148) },
                { 1.00, Theme.Colors.Panel }
            }
        }
    end

    return nil
end

function ChatStyles.GetSizing(style)
    if not style then
        return {
            minMessageHeight = 34,
            minContainerHeight = 58,
            bottomPadding = 6
        }
    end

    return {
        minMessageHeight = 20,
        minContainerHeight = 46,
        bottomPadding = 2
    }
end

function ChatStyles.GetContentZIndex(style)
    return style and 5 or 3
end

function ChatStyles.GetContainerZIndex(style)
    return style and 4 or 1
end

function ChatStyles.GetTextZIndex(style)
    return style and 5 or 1
end

function ChatStyles.GetTextColor(style, fallbackColor)
    return style and style.textColor or fallbackColor
end

function ChatStyles.ApplyBackground(container, Theme, style, containerHeight)
    if not style then
        return
    end

    local background = Instance.new("Frame")
    background.Name = style.name .. "Background"
    background.Size = UDim2.new(1, -2, 0, containerHeight - 2)
    background.Position = UDim2.new(0, 1, 0, 0)
    background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    background.BackgroundTransparency = 0
    background.BorderSizePixel = 0
    background.ZIndex = 2
    background.ClipsDescendants = true
    background.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = background

    local gradient = Instance.new("UIGradient")
    gradient.Color = makeColorSequence(style.gradientColors)
    gradient.Transparency = makeTransparencySequence({
        { 0.00, 0.70 },
        { 0.03, 0.42 },
        { 0.08, 0.14 },
        { 0.50, 0.04 },
        { 0.92, 0.18 },
        { 0.97, 0.36 },
        { 1.00, 0.18 }
    })
    gradient.Rotation = 0
    gradient.Parent = background

    local stars = Instance.new("Frame")
    stars.Name = style.name .. "Stars"
    stars.Size = UDim2.new(1, 0, 1, 0)
    stars.Position = UDim2.new(0, 0, 0, 0)
    stars.BackgroundTransparency = 1
    stars.BorderSizePixel = 0
    stars.ZIndex = 4
    stars.Parent = background

    for i = 1, 5 do
        local star = Instance.new("Frame")
        local size = math.random(7, 10)

        star.Name = style.name .. "Star"
        star.Size = UDim2.new(0, size, 0, size)
        star.Position = UDim2.new(
            math.random(12, 88) / 100,
            0,
            math.random(18, 78) / 100,
            0
        )
        star.BackgroundTransparency = 1
        star.BorderSizePixel = 0
        star.ZIndex = 4
        star.Parent = stars

        local starColor = style.starColors[((i - 1) % #style.starColors) + 1]
        local starParts = {}

        for _, rotation in ipairs({ 0, 90, 45, -45 }) do
            local isMainRay = rotation == 0 or rotation == 90
            local partLength = isMainRay and size or math.floor(size * 0.72)
            local partTransparency = isMainRay and 0.18 or 0.36

            local part = Instance.new("Frame")
            part.Name = "StarPart"
            part.AnchorPoint = Vector2.new(0.5, 0.5)
            part.Size = UDim2.new(0, partLength, 0, 2)
            part.Position = UDim2.new(0.5, 0, 0.5, 0)
            part.BackgroundColor3 = starColor
            part.BackgroundTransparency = partTransparency
            part.BorderSizePixel = 0
            part.Rotation = rotation
            part.ZIndex = 4
            part.Parent = star

            local partCorner = Instance.new("UICorner")
            partCorner.CornerRadius = UDim.new(1, 0)
            partCorner.Parent = part

            table.insert(starParts, part)
        end

        task.spawn(function()
            while star.Parent do
                local duration = math.random(15, 30) / 10
                local targetTransparency = math.random(15, 55) / 100
                local tweenInfo = TweenInfo.new(
                    duration,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut
                )

                for _, part in ipairs(starParts) do
                    local isDiagonal = part.Rotation == 45 or part.Rotation == -45

                    TweenService:Create(part, tweenInfo, {
                        BackgroundTransparency = math.clamp(
                            targetTransparency + (isDiagonal and 0.16 or 0),
                            0.15,
                            0.58
                        )
                    }):Play()
                end

                task.wait(duration)
            end
        end)
    end
end

return ChatStyles
