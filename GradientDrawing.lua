local GradientDrawing = {}
getgenv().GradientDrawing = GradientDrawing

local DEFAULT_SEGMENTS = 200

function GradientDrawing.Line(props)
	local startPos = props.From
	local endPos = props.To
	local startColor = props.StartColor
	local endColor = props.EndColor
	local startTrans = props.StartTransparency or 0
	local endTrans = props.EndTransparency or 0
	local thickness = props.Thickness or 2
	local segments = props.Segments or DEFAULT_SEGMENTS

	if segments < 1 then segments = 1 end
	local segmentVector = (endPos - startPos) / segments

	for i = 0, segments - 1 do
		local t = (i + 0.5) / segments
		local p1 = startPos + segmentVector * i
		local p2 = startPos + segmentVector * (i + 1)
		local color = startColor:Lerp(endColor, t)
		local transparency = startTrans + (endTrans - startTrans) * t
		local line = Drawing.new("Line")
		line.Visible = true; line.From = p1; line.To = p2; line.Color = color
		line.Thickness = thickness; line.Transparency = transparency; line.ZIndex = props.ZIndex or 0
	end
end

function GradientDrawing.Square(props)
	local pos = props.Position
	local size = props.Size
	local startColor, endColor = props.StartColor, props.EndColor
	local startTrans, endTrans = props.StartTransparency or 0, props.EndTransparency or 0
	local orientation = props.Orientation or "Vertical"
	local filled = props.Filled
	local thickness = props.Thickness or 2
	local fillQuality = props.FillQuality or 1

	if filled then
		local step = 1 / fillQuality
		local segmentCount = math.floor((orientation == "Vertical" and size.Y or size.X) / step)
		for i = 0, segmentCount do
			local t = i / segmentCount
			local color = startColor:Lerp(endColor, t)
			local transparency = startTrans + (endTrans - startTrans) * t
			if orientation == "Vertical" then
				local y = pos.Y + (i * step)
				local line = Drawing.new("Line")
				line.Visible = true; line.From = Vector2.new(pos.X, y); line.To = Vector2.new(pos.X + size.X, y)
				line.Color = color; line.Thickness = step * 1.2; line.Transparency = transparency; line.ZIndex = props.ZIndex or 0
			else
				local x = pos.X + (i * step)
				local line = Drawing.new("Line")
				line.Visible = true; line.From = Vector2.new(x, pos.Y); line.To = Vector2.new(x, pos.Y + size.Y)
				line.Color = color; line.Thickness = step * 1.2; line.Transparency = transparency; line.ZIndex = props.ZIndex or 0
			end
		end
	else
		local segments = props.Segments or DEFAULT_SEGMENTS
		local p1, p2, p3, p4 = pos, pos + Vector2.new(size.X, 0), pos + size, pos + Vector2.new(0, size.Y)
		local ct1, ct2, cb1, cb2, cl1, cl2, cr1, cr2 = startColor, startColor, endColor, endColor, startColor, endColor, startColor, endColor
		local tt1, tt2, tb1, tb2, tl1, tl2, tr1, tr2 = startTrans, startTrans, endTrans, endTrans, startTrans, endTrans, startTrans, endTrans
		if orientation ~= "Vertical" then
			cl1, cl2, cr1, cr2 = startColor, startColor, endColor, endColor
			ct1, ct2, cb1, cb2 = startColor, endColor, startColor, endColor
			tl1, tl2, tr1, tr2 = startTrans, startTrans, endTrans, endTrans
			tt1, tt2, tb1, tb2 = startTrans, endTrans, startTrans, endTrans
		end
		GradientDrawing.Line({From = p1, To = p2, StartColor = ct1, EndColor = ct2, StartTransparency = tt1, EndTransparency = tt2, Thickness = thickness, Segments = segments, ZIndex = props.ZIndex})
		GradientDrawing.Line({From = p2, To = p3, StartColor = cr1, EndColor = cr2, StartTransparency = tr1, EndTransparency = tr2, Thickness = thickness, Segments = segments, ZIndex = props.ZIndex})
		GradientDrawing.Line({From = p4, To = p3, StartColor = cb1, EndColor = cb2, StartTransparency = tb1, EndTransparency = tb2, Thickness = thickness, Segments = segments, ZIndex = props.ZIndex})
		GradientDrawing.Line({From = p1, To = p4, StartColor = cl1, EndColor = cl2, StartTransparency = tl1, EndTransparency = tl2, Thickness = thickness, Segments = segments, ZIndex = props.ZIndex})
	end
end

function GradientDrawing.Circle(props)
	local center, radius = props.Center, props.Radius
	local startColor, endColor = props.StartColor, props.EndColor
	local startTrans, endTrans = props.StartTransparency or 0, props.EndTransparency or 0
	local filled = props.Filled
	local thickness = props.Thickness or 2
	local segments = props.Segments or DEFAULT_SEGMENTS
	local zindex = props.ZIndex or 0
	local fillQuality = props.FillQuality or 1

	if filled then
		local step = 1 / fillQuality
		local segmentCount = math.floor((radius * 2) / step)
		for i = 0, segmentCount do
			local t = i / segmentCount
			local y = (center.Y - radius) + (i * step)
			local dy = y - center.Y
			local chordWidth = math.sqrt(math.max(0, radius^2 - dy^2))
			local color = startColor:Lerp(endColor, t)
			local transparency = startTrans + (endTrans - startTrans) * t
			local line = Drawing.new("Line")
			line.Visible = true; line.From = Vector2.new(center.X - chordWidth, y); line.To = Vector2.new(center.X + chordWidth, y)
			line.Color = color; line.Thickness = step * 1.2; line.Transparency = transparency; line.ZIndex = zindex
		end
	else
		for i = 0, segments do
			local a1 = (i / segments) * 2 * math.pi
			local a2 = ((i + 1) / segments) * 2 * math.pi
			local p1 = center + Vector2.new(math.cos(a1) * radius, math.sin(a1) * radius)
			local p2 = center + Vector2.new(math.cos(a2) * radius, math.sin(a2) * radius)
			local t1 = (p1.Y - (center.Y - radius)) / (radius * 2)
			local t2 = (p2.Y - (center.Y - radius)) / (radius * 2)
			local color = startColor:Lerp(endColor, (t1 + t2) / 2)
			local trans = (startTrans + (endTrans - startTrans) * t1 + startTrans + (endTrans - startTrans) * t2) / 2
			local line = Drawing.new("Line")
			line.Visible = true; line.From = p1; line.To = p2
			line.Color = color; line.Thickness = thickness; line.Transparency = trans; line.ZIndex = zindex
		end
	end
end

function GradientDrawing.Triangle(props)
	local v = {props.PointA, props.PointB, props.PointC}
	local c = {props.ColorA, props.ColorB, props.ColorC}
	local t = {props.TransparencyA or 0, props.TransparencyB or 0, props.TransparencyC or 0}
	local filled = props.Filled
	local thickness = props.Thickness or 2
	local segments = props.Segments or DEFAULT_SEGMENTS
	local zindex = props.ZIndex or 0
	local fillQuality = props.FillQuality or 1

	if filled then
		if v[1].Y > v[2].Y then v[1], v[2], c[1], c[2], t[1], t[2] = v[2], v[1], c[2], c[1], t[2], t[1] end
		if v[1].Y > v[3].Y then v[1], v[3], c[1], c[3], t[1], t[3] = v[3], v[1], c[3], c[1], t[3], t[1] end
		if v[2].Y > v[3].Y then v[2], v[3], c[2], c[3], t[2], t[3] = v[3], v[2], c[3], c[2], t[3], t[2] end
		
		local v1, v2, v3, c1, c2, c3, t1, t2, t3 = v[1], v[2], v[3], c[1], c[2], c[3], t[1], t[2], t[3]
		local total_height = v3.Y - v1.Y
		if total_height < 1 then return end

		local d12 = v2.Y - v1.Y; local d13 = v3.Y - v1.Y; local d23 = v3.Y - v2.Y
		local step = 1 / fillQuality
		local segmentCount = math.floor(total_height / step)
		for i = 0, segmentCount do
			local y = v1.Y + (i * step)
			local is_second_half = i * step > d12 and d12 < total_height
			
			local pA, pB, cA, cB, tA, tB
			local alpha = d13 > 0 and (y - v1.Y) / d13 or 0
			pA = v1:Lerp(v3, alpha); cA = c1:Lerp(c3, alpha); tA = t1 + (t3 - t1) * alpha

			if not is_second_half then
				local beta = d12 > 0 and (y - v1.Y) / d12 or 0
				pB = v1:Lerp(v2, beta); cB = c1:Lerp(c2, beta); tB = t1 + (t2 - t1) * beta
			else
				local beta = d23 > 0 and (y - v2.Y) / d23 or 0
				pB = v2:Lerp(v3, beta); cB = c2:Lerp(c3, beta); tB = t2 + (t3 - t2) * beta
			end
			GradientDrawing.Line({From = pA, To = pB, StartColor = cA, EndColor = cB, StartTransparency = tA, EndTransparency = tB, Thickness = step * 1.2, Segments = 2, ZIndex = zindex})
		end
	else
		for i = 1, 3 do
			GradientDrawing.Line({From = v[i], To = v[i % 3 + 1], StartColor = c[i], EndColor = c[i % 3 + 1], StartTransparency = t[i], EndTransparency = t[i % 3 + 1], Thickness = thickness, Segments = segments, ZIndex = zindex})
		end
	end
end

function GradientDrawing.Quad(props)
	local v = {props.PointA, props.PointB, props.PointC, props.PointD}
	local c = {props.ColorA, props.ColorB, props.ColorC, props.ColorD}
	local t = {props.TransparencyA or 0, props.TransparencyB or 0, props.TransparencyC or 0, props.TransparencyD or 0}
	local filled = props.Filled
	local thickness = props.Thickness or 2
	local segments = props.Segments or DEFAULT_SEGMENTS
	local zindex = props.ZIndex or 0
	local fillQuality = props.FillQuality or 1
	
	if filled then
		GradientDrawing.Triangle({PointA = v[1], PointB = v[2], PointC = v[4], ColorA = c[1], ColorB = c[2], ColorC = c[4], TransparencyA=t[1], TransparencyB=t[2], TransparencyC=t[4], Filled = true, ZIndex = zindex, FillQuality = fillQuality})
		GradientDrawing.Triangle({PointA = v[2], PointB = v[3], PointC = v[4], ColorA = c[2], ColorB = c[3], ColorC = c[4], TransparencyA=t[2], TransparencyB=t[3], TransparencyC=t[4], Filled = true, ZIndex = zindex, FillQuality = fillQuality})
	else
		for i = 1, 4 do
			GradientDrawing.Line({From = v[i], To = v[i % 4 + 1], StartColor = c[i], EndColor = c[i % 4 + 1], StartTransparency = t[i], EndTransparency = t[i % 4 + 1], Thickness = thickness, Segments = segments, ZIndex = zindex})
		end
	end
end
