local lazyAPI = lazyAPI -- for more info, see https://github.com/ZwerOxotnik/zk-lib


---@module "__minable_tiles__/lib"
local M = {}


-- TODO: improve
M.duplicate = function(prototype)
	local new_prototype = table.deepcopy(prototype)
	-- new_prototype.resource_searching_radius = 1
	-- new_prototype.radius_visualisation_picture = nil
	lazyAPI.add_prototype(new_prototype.type, new_prototype.name .. "-for_tiles", new_prototype)

	local new_fake_prototype = table.deepcopy(prototype)
	lazyAPI.make_fake_simple_entity_with_owner(new_fake_prototype)
	lazyAPI.add_prototype("simple-entity-with-owner", new_fake_prototype.name .. "-fake-for_tiles", new_fake_prototype)

	local new_item = table.deepcopy(data.raw.item[prototype.name])
	new_item.place_result = new_fake_prototype.name
	lazyAPI.add_prototype("item", new_fake_prototype.name, new_item)

	local recipes = lazyAPI.item.find_main_recipes(prototype.name) -- probably, it's too weird
	for i=1, #recipes do
		local new_recipe = table.deepcopy(recipes[i])
		--TODO: change icon
		_, new_recipe = lazyAPI.add_prototype("recipe", new_recipe.name .. "-fake-for_tiles", new_recipe)
		new_recipe:replace_result(prototype.name, new_item.name, "item")
		new_recipe:remove_all_ingredients():add_valid_item_ingredient(prototype.name)
		new_recipe:remove_if_no_ingredients()
	end

	return new_fake_prototype, new_prototype, new_item
end

return M
