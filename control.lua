local unimportant_type = 0
local dirt_type = 1
local grass_type = 2
local sand_type = 3


--#region Global data
local resources_by_types
--#endregion


local memorized_tiles_mt = {
	__index = function(self, k)
		if resources_by_types[dirt_type] and k:find("dirt") then
			self[k] = dirt_type
			return dirt_type
		elseif resources_by_types[sand_type] and (k:find("sand") or k:find("desert")) then
			self[k] = sand_type
			return sand_type
		elseif resources_by_types[grass_type] and k:find("grass") then
			self[k] = grass_type
			return grass_type
		end
		self[k] = unimportant_type
		return unimportant_type
	end
}
---@type table<string, integer>
local memorized_tiles = {}
setmetatable(memorized_tiles, memorized_tiles_mt)


local resource_data = {
	type = "resource",
	name = "",
	position = {},
	snap_to_tile_center = false
}
local entity_data = {
	name = "electric-mining-drill-for_tiles",
	force = nil,
	direction = nil,
	player = nil,
	position = {},
	raise_built = true,
	create_build_effect_smoke = false
}
local tile_filter = {
	position = {},
	radius = 2,
	has_hidden_tile = false,
	collision_mask = "ground-tile"
}
local function on_new_entity_via_fake(event)
	local entity = event.created_entity or event.entity or event.destination
	if not (entity and entity.valid) then return end

	local surface = entity.surface
	local position = entity.position

	entity_data.force = entity.force
	entity_data.player = entity.last_user
	entity_data.position = position
	entity_data.direction = entity.direction
	entity.destroy()
	surface.create_entity(entity_data)

	tile_filter.position = position
	local entities = surface.find_tiles_filtered(tile_filter)
	local tile_data = {}
	local prev_name
	for i=1, #entities do
		local name = entities[i].name
		if prev_name ~= name then
			prev_name = name
			local tile_type = memorized_tiles[name]
			tile_data[tile_type] = true
		end
	end

	resource_data.position = position
	for tile_type in pairs(tile_data) do
		if tile_type > 0 then
			local resource_array = resources_by_types[tile_type]
			for i=1, #resource_array do
				resource_data.name = resource_array[i]
				local resource = surface.create_entity(resource_data)
				if not resource.prototype.infinite_resource then
					resource.amount = 4294967295
				end
			end
		end
	end
end

local function on_new_entity_via_original(event)
	local entity = event.entity or event.destination
	if not (entity and entity.valid) then return end

	local surface = entity.surface
	local position = entity.position

	tile_filter.position = position
	local entities = surface.find_tiles_filtered(tile_filter)
	local tile_data = {}
	local prev_name
	for i=1, #entities do
		local name = entities[i].name
		if prev_name ~= name then
			prev_name = name
			local tile_type = memorized_tiles[name]
			tile_data[tile_type] = true
		end
	end

	resource_data.position = position
	for tile_type in pairs(tile_data) do
		if tile_type > 0 then
			local resource_array = resources_by_types[tile_type]
			for i=1, #resource_array do
				resource_data.name = resource_array[i]
				local resource = surface.create_entity(resource_data)
				if not resource.prototype.infinite_resource then
					resource.amount = 4294967295
				end
			end
		end
	end
end

local filter_for_entities = {
	position = {},
	type = "resource"
}
local function on_removed_entity(event)
	local entity = event.entity
	if not (entity and entity.valid) then return end

	local surface = entity.surface
	filter_for_entities.position = entity.position
	local entities = surface.find_entities_filtered(filter_for_entities)
	for i=#entities, 1, -1 do
		entities[i].destroy()
	end
end


script.on_event(
	defines.events.on_built_entity,
	on_new_entity_via_fake,
	{{filter = "name", name = "electric-mining-drill-fake-for_tiles"}}
)
script.on_event(
	defines.events.script_raised_built,
	on_new_entity_via_fake,
	{{filter = "name", name = "electric-mining-drill-fake-for_tiles"}}
)
script.on_event(
	defines.events.on_robot_built_entity,
	on_new_entity_via_fake,
	{{filter = "name", name = "electric-mining-drill-fake-for_tiles"}}
)

script.on_event(
	defines.events.script_raised_revive,
	on_new_entity_via_original,
	{{filter = "name", name = "electric-mining-drill-for_tiles"}}
)
script.on_event(
	defines.events.on_entity_cloned,
	on_new_entity_via_original,
	{{filter = "name", name = "electric-mining-drill-for_tiles"}}
)

script.on_event(
	defines.events.on_entity_died,
	on_removed_entity,
	{{filter = "name", name = "electric-mining-drill-for_tiles"}}
)
script.on_event(
	defines.events.on_robot_mined_entity,
	on_removed_entity,
	{{filter = "name", name = "electric-mining-drill-for_tiles"}}
)
script.on_event(
	defines.events.on_player_mined_entity,
	on_removed_entity,
	{{filter = "name", name = "electric-mining-drill-for_tiles"}}
)
script.on_event(
	defines.events.script_raised_destroy,
	on_removed_entity,
	{{filter = "name", name = "electric-mining-drill-for_tiles"}}
)


local function remove_from_array(array, data)
	if array == nil then return end
	for i=#array, 1, -1 do
		if array[i] == data then
			table.remove(array, i)
		end
	end
end

local function add_to_array(array, data)
	for i=1, #array do
		if array[i] == data then
			return
		end
	end
	array[#array+1] = data
end

-- TODO: add notifications
local resource_filter = {{
	filter = "type",
	type = "resource"
}}
mod_settings = {
	["MT_stone_from_dirt"] = function(value)
		resources_by_types[dirt_type] = resources_by_types[dirt_type] or {}
		local resources = resources_by_types[dirt_type]
		if value then
			local prototypes = game.get_filtered_entity_prototypes(resource_filter) -- TODO: change
			if prototypes["stone"] then
				add_to_array(resources, "stone")
			end
			return
		end

		remove_from_array(resources, "stone")
		if #resources == 0 then
			resources_by_types[dirt_type] = nil
		end
	end,
	["MT_stone_from_grass"] = function(value)
		resources_by_types[grass_type] = resources_by_types[grass_type] or {}
		local resources = resources_by_types[grass_type]
		if value then
			local prototypes = game.get_filtered_entity_prototypes(resource_filter) -- TODO: change
			if prototypes["stone"] then
				add_to_array(resources, "stone")
			end
			return
		end

		remove_from_array(resources, "stone")
		if #resources == 0 then
			resources_by_types[grass_type] = nil
		end
	end,
	["MT_sand_from_sand"] = function(value)
		resources_by_types[sand_type] = resources_by_types[sand_type] or {}
		local resources = resources_by_types[sand_type]
		local prototypes = game.get_filtered_entity_prototypes(resource_filter)

		if value then
			for name in pairs(prototypes) do
				if name:find("sand") or name:find("desert") then
					add_to_array(resources, name)
				end
			end
			if #resources == 0 then
				resources_by_types[sand_type] = nil
			end
			return
		end

		for name in pairs(prototypes) do
			if name:find("sand") or name:find("desert") then
				remove_from_array(resources, name)
			end
		end
		if #resources == 0 then
			resources_by_types[sand_type] = nil
		end
	end,
	["MT_sand_from_dirt"] = function(value)
		resources_by_types[dirt_type] = resources_by_types[dirt_type] or {}
		local resources = resources_by_types[dirt_type]
		local prototypes = game.get_filtered_entity_prototypes(resource_filter)

		if value then
			for name in pairs(prototypes) do
				if name:find("dirt") then
					add_to_array(resources, name)
				end
			end
			if #resources == 0 then
				resources_by_types[dirt_type] = nil
			end
			return
		end

		for name in pairs(prototypes) do
			if name:find("dirt") then
				remove_from_array(resources, name)
			end
		end
		if #resources == 0 then
			resources_by_types[dirt_type] = nil
		end
	end
}
script.on_event(
	defines.events.on_runtime_mod_setting_changed,
	function(event)
		local setting_name = event.setting
		local f = mod_settings[setting_name]
		if f == nil then return end

		memorized_tiles = {}
		setmetatable(memorized_tiles, memorized_tiles_mt)
		f(settings.global[setting_name].value)
	end
)


local function link_data()
	resources_by_types = global.resources_by_types
end

local function update_global_data()
	global.resources_by_types = {}
	link_data()

	mod_settings["MT_stone_from_dirt"](settings.global["MT_stone_from_dirt"].value)
	mod_settings["MT_stone_from_grass"](settings.global["MT_stone_from_grass"].value)
	mod_settings["MT_sand_from_sand"](settings.global["MT_sand_from_sand"].value)
end

script.on_init(update_global_data)
script.on_configuration_changed(update_global_data)
script.on_load(link_data)


if script.active_mods["gvv"] then require("__gvv__.gvv")() end
