for name, f in pairs(minable_tiles_core.targets) do
	local mining_drill = data.raw["mining-drill"][name]
	if mining_drill then
		local fake_prototype = minable_tiles_core.duplicate(mining_drill)
		f(fake_prototype)
	end
end
