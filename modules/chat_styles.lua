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

    if chatStyle == "galaxy"
        or chatStyle == "galaxydream"
        or chatStyle == "galaxy_dream"
        or chatStyle == "chat_style_galaxy"
        or chatStyle == "chat_style_galaxy_dream"
    then
        return {
            name = "GalaxyDream",
            textColor = Theme.Colors.Text,
            showStars = false,
            showNebulaDust = true,
            showCosmicMist = true,
            showOrbitLines = true,
            nebulaDustColors = {
                Color3.fromRGB(118, 152, 255),
                Color3.fromRGB(172, 104, 255),
                Color3.fromRGB(76, 218, 235),
                Color3.fromRGB(232, 208, 255)
            },
            cosmicMistColors = {
                Color3.fromRGB(92, 46, 156),
                Color3.fromRGB(24, 92, 154),
                Color3.fromRGB(110, 44, 126)
            },
            orbitLineColors = {
                Color3.fromRGB(128, 170, 255),
                Color3.fromRGB(176, 120, 255)
            },
            gradientColors = {
                { 0.00, Theme.Colors.Panel },
                { 0.16, Color3.fromRGB(18, 24, 64) },
                { 0.34, Color3.fromRGB(48, 28, 96) },
                { 0.52, Color3.fromRGB(92, 38, 128) },
                { 0.72, Color3.fromRGB(32, 54, 126) },
                { 0.88, Color3.fromRGB(16, 104, 142) },
                { 0.96, Color3.fromRGB(30, 34, 58) },
                { 1.00, Theme.Colors.Panel }
            }
        }
    end

    if chatStyle == "cloud"
        or chatStyle == "cutecloud"
        or chatStyle == "cute_cloud"
        or chatStyle == "chat_style_cloud"
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

    if style.showCosmicMist then
        for i = 1, 3 do
            local mist = Instance.new("Frame")
            mist.Name = style.name .. "CosmicMist"
            mist.AnchorPoint = Vector2.new(0.5, 0.5)
            mist.Size = UDim2.new(0, math.random(96, 148), 0, math.random(20, 34))
            mist.Position = UDim2.new(
                math.random(26, 78) / 100,
                0,
                math.random(34, 70) / 100,
                0
            )
            mist.BackgroundColor3 = style.cosmicMistColors[((i - 1) % #style.cosmicMistColors) + 1]
            mist.BackgroundTransparency = 0.82
            mist.BorderSizePixel = 0
            mist.Rotation = math.random(-14, 14)
            mist.ZIndex = 3
            mist.Parent = background

            local mistCorner = Instance.new("UICorner")
            mistCorner.CornerRadius = UDim.new(1, 0)
            mistCorner.Parent = mist

            local mistGradient = Instance.new("UIGradient")
            mistGradient.Transparency = makeTransparencySequence({
                { 0.00, 1.00 },
                { 0.24, 0.68 },
                { 0.50, 0.28 },
                { 0.76, 0.68 },
                { 1.00, 1.00 }
            })
            mistGradient.Rotation = math.random(0, 180)
            mistGradient.Parent = mist
        end
    end

    if style.showOrbitLines then
        for i = 1, 3 do
            local orbit = Instance.new("Frame")
            orbit.Name = style.name .. "OrbitLine"
            orbit.AnchorPoint = Vector2.new(0.5, 0.5)
            orbit.Size = UDim2.new(0, math.random(130, 210), 0, 1)
            orbit.Position = UDim2.new(
                math.random(36, 68) / 100,
                0,
                math.random(34, 68) / 100,
                0
            )
            orbit.BackgroundColor3 = style.orbitLineColors[((i - 1) % #style.orbitLineColors) + 1]
            orbit.BackgroundTransparency = 0.78
            orbit.BorderSizePixel = 0
            orbit.Rotation = math.random(-15, 16)
            orbit.ZIndex = 3
            orbit.Parent = background

            local orbitCorner = Instance.new("UICorner")
            orbitCorner.CornerRadius = UDim.new(1, 0)
            orbitCorner.Parent = orbit

            local orbitGradient = Instance.new("UIGradient")
            orbitGradient.Transparency = makeTransparencySequence({
                { 0.00, 1.00 },
                { 0.18, 0.86 },
                { 0.50, 0.20 },
                { 0.82, 0.86 },
                { 1.00, 1.00 }
            })
            orbitGradient.Parent = orbit
        end
    end

    if style.showNebulaDust then
        for i = 1, 12 do
            local dust = Instance.new("Frame")
            local size = math.random(2, 4)

            dust.Name = style.name .. "NebulaDust"
            dust.Size = UDim2.new(0, size, 0, size)
            dust.Position = UDim2.new(
                math.random(14, 88) / 100,
                0,
                math.random(22, 76) / 100,
                0
            )
            dust.BackgroundColor3 = style.nebulaDustColors[((i - 1) % #style.nebulaDustColors) + 1]
            dust.BackgroundTransparency = math.random(50, 78) / 100
            dust.BorderSizePixel = 0
            dust.ZIndex = 4
            dust.Parent = background

            local dustCorner = Instance.new("UICorner")
            dustCorner.CornerRadius = UDim.new(1, 0)
            dustCorner.Parent = dust
        end
    end

    if style.showStars ~= false then
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
end

return ChatStyles
