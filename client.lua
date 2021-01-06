local AttachementsTable = {};

addEvent("sync_attachements", true);
addEvent("sync_detachements", true);
addEvent("sync_newcomeattachements", true);

addEventHandler("sync_attachements", root, function(element, ped, bone, offX, offY, offZ, offrx, offry, offrz)
	if element and ped and bone and offX and offY and offZ and offrx and offry and offrz then
		table.insert(AttachementsTable, {element, ped, bone, offX, offY, offZ, offrx, offry, offrz});
	end
end);

addEventHandler("sync_detachements", root, function(position)
	if position then
		table.remove(AttachementsTable, position);
	end
end);

addEventHandler("onClientResourceStart", resourceRoot, function()
	triggerServerEvent("sync_newcomeplayer", localPlayer);
end);

addEventHandler("sync_newcomeattachements", resourceRoot, function(theTable)
	AttachementsTable = {};
	if theTable and type(theTable) == "table" then
		AttachementsTable = theTable;
	end
end);

local function d_attachElementToBone(element, ped, bone, offX, offY, offZ, offrx, offry, offrz)
	local boneMat = getElementBoneMatrix(ped, bone);
	local sroll, croll, spitch, cpitch, syaw, cyaw = math.sin(offrz), math.cos(offrz), math.sin(offry), math.cos(offry), math.sin(offrx), math.cos(offrx)
	local rotMat = {
		{sroll * spitch * syaw + croll * cyaw,
		sroll * cpitch,
		sroll * spitch * cyaw - croll * syaw},
		{croll * spitch * syaw - sroll * cyaw,
		croll * cpitch,
		croll * spitch * cyaw + sroll * syaw},
		{cpitch * syaw,
		-spitch,
		cpitch * cyaw}
	}
	local finalMatrix = {
		{boneMat[2][1] * rotMat[1][2] + boneMat[1][1] * rotMat[1][1] + rotMat[1][3] * boneMat[3][1],
		boneMat[3][2] * rotMat[1][3] + boneMat[1][2] * rotMat[1][1] + boneMat[2][2] * rotMat[1][2],-- right
		boneMat[2][3] * rotMat[1][2] + boneMat[3][3] * rotMat[1][3] + rotMat[1][1] * boneMat[1][3],
		0},
		{rotMat[2][3] * boneMat[3][1] + boneMat[2][1] * rotMat[2][2] + rotMat[2][1] * boneMat[1][1],
		boneMat[3][2] * rotMat[2][3] + boneMat[2][2] * rotMat[2][2] + boneMat[1][2] * rotMat[2][1],-- front 
		rotMat[2][1] * boneMat[1][3] + boneMat[3][3] * rotMat[2][3] + boneMat[2][3] * rotMat[2][2],
		0},
		{boneMat[2][1] * rotMat[3][2] + rotMat[3][3] * boneMat[3][1] + rotMat[3][1] * boneMat[1][1],
		boneMat[3][2] * rotMat[3][3] + boneMat[2][2] * rotMat[3][2] + rotMat[3][1] * boneMat[1][2],-- up
		rotMat[3][1] * boneMat[1][3] + boneMat[3][3] * rotMat[3][3] + boneMat[2][3] * rotMat[3][2],
		0},
		{offX * boneMat[1][1] + offY * boneMat[2][1] + offZ * boneMat[3][1] + boneMat[4][1],
		offX * boneMat[1][2] + offY * boneMat[2][2] + offZ * boneMat[3][2] + boneMat[4][2],-- pos
		offX * boneMat[1][3] + offY * boneMat[2][3] + offZ * boneMat[3][3] + boneMat[4][3],
		1}
	}
	setElementMatrix(element, finalMatrix);
end

addEventHandler("onClientPedsProcessed", root, function()
	for i = 1, #AttachementsTable do
		local v = AttachementsTable[i];
		if v then
			local elm = v[1];
			local ped = v[2];
			if isElementOnScreen(ped) then
				d_attachElementToBone(elm, ped, v[3], v[4], v[5], v[6], v[7], v[8], v[9]);
			else
				setElementPosition(elm, 0, 0, -1000);
			end
		end
	end
end);