local Attachemenets = {};

local elm = isElement;
local m_rad = math.rad;
local tonr = tonumber;

addEvent("sync_newcomeplayer", true);

function attachElementToBone(element, ped, bone, offx, offy, offz, offrx, offry, offrz)
	if elm(element) and elm(ped) and tonr(bone) then
		local table = {element, ped, bone, tonr(offx) or 0, tonr(offy) or 0, tonr(offz) or 0, m_rad(offrx) or 0, m_rad(offry) or 0, m_rad(offrz) or 0};
		setElementCollisionsEnabled(element, false);
		Attachemenets[#Attachemenets + 1] = table;
		triggerClientEvent(root, "sync_attachements", resourceRoot, table);
	end
end

function detachElementFromBone(element)
	if elm(element) then
		for i = 1, #Attachemenets do
			local v = Attachemenets[i];
			if v[1] == element then
				table.remove(Attachemenets, i);
				triggerClientEvent(root, "sync_detachements", resourceRoot, i);
				break;
			end
		end
	end
end

addEventHandler("onElementDestroy", root, function()
	for i = 1, #Attachemenets do
		local v = Attachemenets[i];
		if v[1] == source or v[2] == source then
			table.remove(Attachemenets, i);
			triggerClientEvent(root, "sync_detachements", resourceRoot, i);
			break;
		end
	end
end);

addEventHandler("sync_newcomeplayer", root, function()
	if client then
		triggerClientEvent(client, "sync_newcomeattachements", resourceRoot, Attachemenets);
	end
end);