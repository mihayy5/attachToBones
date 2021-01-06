local Attachemenets = {};

addEvent("sync_newcomeplayer", true);

function attachElementToBone(element, ped, bone, offX, offY, offZ, offrx, offry, offrz)
	if isElement(element) and isElement(ped) and tonumber(bone) then
		local offX = tonumber(offX) or 0;
		local offY = tonumber(offY) or 0;
		local offZ = tonumber(offZ) or 0;
		local offrx = math.rad(offrx) or 0;
		local offry = math.rad(offry) or 0;
		local offrz = math.rad(offrz) or 0;
		table.insert(Attachemenets, {element, ped, bone, offX, offY, offZ, offrx, offry, offrz});
		triggerClientEvent(root, "sync_attachements", resourceRoot, element, ped, bone, offX, offY, offZ, offrx, offry, offrz);
	end
end

function detachElementFromBone(element)
	if isElement(element) then
		for i,v in ipairs(Attachemenets) do
			if v[1] == element then
				table.remove(Attachemenets, i);
				triggerClientEvent(root, "sync_detachements", resourceRoot, i);
			end
		end
	end
end

addEventHandler("onElementDestroy", root, function()
	for i,v in ipairs(Attachemenets) do
		if v[1] == source or v[2] == source then
			table.remove(Attachemenets, i);
			triggerClientEvent(root, "sync_detachements", resourceRoot, i);
		end
	end
end);

addEventHandler("sync_newcomeplayer", root, function()
	if client then
		triggerClientEvent(client, "sync_newcomeattachements", resourceRoot, Attachemenets);
	end
end);