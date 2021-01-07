local AttachementsTable = {};

local m_sin = math.sin;
local m_cos = math.cos;
local _getElementBoneMatrix = getElementBoneMatrix;
local _setElementMatrix = setElementMatrix;
local _isElementOnScreen = isElementOnScreen;
local _setElementPosition = setElementPosition;

local boneMat, sroll, croll, spitch, cpitch, syaw, cyaw, rotMat, finalMatrix = false, false, false, false, false, false, false, false, false;


addEvent("sync_attachements", true);
addEvent("sync_detachements", true);
addEvent("sync_newcomeattachements", true);

addEventHandler("sync_attachements", root, function(element, ped, bone, offX, offY, offZ, offrx, offry, offrz)
	if element and ped and bone and offX and offY and offZ and offrx and offry and offrz then
		AttachementsTable[#AttachementsTable + 1] = {element, ped, bone, offX, offY, offZ, offrx, offry, offrz};
	end
end);

addEventHandler("sync_detachements", root, function(position)
	if tonumber(position) then
		table.remove(AttachementsTable, position);
	end
end);

addEventHandler("onClientResourceStart", resourceRoot, function()
	triggerServerEvent("sync_newcomeplayer", localPlayer);
end);

addEventHandler("sync_newcomeattachements", resourceRoot, function(theTable)
	AttachementsTable = {};
	if type(theTable) == "table" then
		AttachementsTable = theTable;
	end
end);

addEventHandler("onClientPedsProcessed", root, function()
	for i = 1, #AttachementsTable do
		local v = AttachementsTable[i];
		local elm = v[1];
		local ped = v[2];
		if _isElementOnScreen(ped) then
			boneMat = _getElementBoneMatrix(ped, v[3]);
			sroll, croll, spitch, cpitch, syaw, cyaw = m_sin(v[9]), m_cos(v[9]), m_sin(v[8]), m_cos(v[8]), m_sin(v[7]), m_cos(v[7]);
			rotMat = {
				{sroll * spitch * syaw + croll * cyaw, sroll * cpitch, sroll * spitch * cyaw - croll * syaw},
				{croll * spitch * syaw - sroll * cyaw, croll * cpitch, croll * spitch * cyaw + sroll * syaw},
				{cpitch * syaw, -spitch, cpitch * cyaw}
			};
			finalMatrix = {
				{boneMat[2][1] * rotMat[1][2] + boneMat[1][1] * rotMat[1][1] + rotMat[1][3] * boneMat[3][1],
				boneMat[3][2] * rotMat[1][3] + boneMat[1][2] * rotMat[1][1] + boneMat[2][2] * rotMat[1][2],
				boneMat[2][3] * rotMat[1][2] + boneMat[3][3] * rotMat[1][3] + rotMat[1][1] * boneMat[1][3], 0},
				{rotMat[2][3] * boneMat[3][1] + boneMat[2][1] * rotMat[2][2] + rotMat[2][1] * boneMat[1][1],
				boneMat[3][2] * rotMat[2][3] + boneMat[2][2] * rotMat[2][2] + boneMat[1][2] * rotMat[2][1],
				rotMat[2][1] * boneMat[1][3] + boneMat[3][3] * rotMat[2][3] + boneMat[2][3] * rotMat[2][2], 0},
				{boneMat[2][1] * rotMat[3][2] + rotMat[3][3] * boneMat[3][1] + rotMat[3][1] * boneMat[1][1],
				boneMat[3][2] * rotMat[3][3] + boneMat[2][2] * rotMat[3][2] + rotMat[3][1] * boneMat[1][2],
				rotMat[3][1] * boneMat[1][3] + boneMat[3][3] * rotMat[3][3] + boneMat[2][3] * rotMat[3][2], 0},
				{v[4] * boneMat[1][1] + v[5] * boneMat[2][1] + v[6] * boneMat[3][1] + boneMat[4][1],
				v[4] * boneMat[1][2] + v[5] * boneMat[2][2] + v[6] * boneMat[3][2] + boneMat[4][2],
				v[4] * boneMat[1][3] + v[5] * boneMat[2][3] + v[6] * boneMat[3][3] + boneMat[4][3], 1}
			};
			_setElementMatrix(elm, finalMatrix);
		else
			_setElementPosition(elm, 0, 0, -1000);
		end
	end
end);