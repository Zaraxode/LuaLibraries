-- Step 1: Load the library and retrieve it from the global environment
loadstring(game:HttpGet("https://raw.githubusercontent.com/Zaraxode/LuaLibraries/refs/heads/main/GradientDrawing.lua"))()
local GradientDrawing = getgenv().GradientDrawing
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Step 2: Set up the rendering loop
RunService.RenderStepped:Connect(function()
    cleardrawcache() -- Essential for animations to avoid lag and memory leaks

    local t = tick()
    local screenSize = Camera.ViewportSize
    local center = screenSize / 2
    local cycle = math.abs(math.sin(t))
    local cycle2 = math.abs(math.sin(t * 0.7))

    -- Line Demo: A rotating line with full color and transparency gradients
    GradientDrawing.Line({
        From = center - Vector2.new(200, 200),
        To = center + Vector2.new(math.cos(t) * 100, math.sin(t) * 100),
        StartColor = Color3.fromHSV(cycle, 1, 1),
        EndColor = Color3.fromHSV(cycle2, 1, 1),
        StartTransparency = 0,
        EndTransparency = 1,
        Thickness = 5,
        Segments = 100,
        ZIndex = 10 -- High ZIndex to draw on top of everything
    })

    -- Square Demos:
    -- 1. Filled square with animated FillQuality and vertical gradient
    GradientDrawing.Square({
        Position = Vector2.new(50, 50),
        Size = Vector2.new(120, 120),
        StartColor = Color3.new(1, 0, 0),
        EndColor = Color3.new(1, 1, 0),
        StartTransparency = 0,
        EndTransparency = 0.5,
        Filled = true,
        Orientation = "Vertical",
        FillQuality = 0.5 + cycle * 2 -- Cycle between low and high quality fill
    })
    
    -- 2. Outline square with horizontal gradient
    GradientDrawing.Square({
        Position = Vector2.new(screenSize.X - 170, 50),
        Size = Vector2.new(120, 120),
        StartColor = Color3.new(0, 1, 1),
        EndColor = Color3.new(1, 0, 1),
        StartTransparency = 0,
        EndTransparency = 0,
        Filled = false,
        Orientation = "Horizontal",
        Thickness = 4,
        Segments = 50
    })

    -- Circle Demos:
    -- 1. Filled circle with animated radius and transparency
    GradientDrawing.Circle({
        Center = Vector2.new(110, screenSize.Y - 110),
        Radius = 40 + cycle * 20,
        StartColor = Color3.new(0, 1, 0),
        EndColor = Color3.new(0, 0, 1),
        StartTransparency = cycle,
        EndTransparency = 1 - cycle,
        Filled = true,
        FillQuality = 2
    })
    
    -- 2. Outline circle with animated color gradient
    GradientDrawing.Circle({
        Center = Vector2.new(screenSize.X - 110, screenSize.Y - 110),
        Radius = 60,
        StartColor = Color3.fromHSV(t / 5 % 1, 1, 1),
        EndColor = Color3.fromHSV((t + 1) / 5 % 1, 1, 1),
        StartTransparency = 1,
        EndTransparency = 0,
        Filled = false,
        Thickness = 4,
        Segments = 150
    })

    -- Triangle Demo: Filled triangle with per-vertex color and transparency
    local tri_offset = center - Vector2.new(0, 150)
    GradientDrawing.Triangle({
        PointA = tri_offset + Vector2.new(-50, 50),
        PointB = tri_offset + Vector2.new(50, 50),
        PointC = tri_offset + Vector2.new(math.cos(t * 2) * 20, -50 + math.sin(t * 2) * 20),
        ColorA = Color3.new(1,0,0),
        ColorB = Color3.new(0,1,0),
        ColorC = Color3.new(0,0,1),
        TransparencyA = cycle,
        TransparencyB = 0,
        TransparencyC = cycle2,
        Filled = true,
        FillQuality = 1
    })

    -- Quad Demo: Outline quad with warping vertices and per-vertex gradients
    local quad_offset = center + Vector2.new(0, 150)
    GradientDrawing.Quad({
        PointA = quad_offset + Vector2.new(-60 + math.sin(t) * 10, -60),
        PointB = quad_offset + Vector2.new(60, -60 + math.cos(t) * 10),
        PointC = quad_offset + Vector2.new(60 - math.sin(t) * 10, 60),
        PointD = quad_offset + Vector2.new(-60, 60 - math.cos(t) * 10),
        ColorA = Color3.new(1,1,0),
        ColorB = Color3.new(0,1,1),
        ColorC = Color3.new(1,0,1),
        ColorD = Color3.new(1,1,1),
        TransparencyA = 0,
        TransparencyB = 0.3,
        TransparencyC = 0.6,
        TransparencyD = 0.9,
        Filled = false,
        Thickness = 3,
        Segments = 50
    })
end)
