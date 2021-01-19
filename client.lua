local AttachementsTable = {};

local m_sin = math.sin;
local m_cos = math.cos;
local _getElementBoneMatrix = getElementBoneMatrix;
local _setElementMatrix = setElementMatrix;
local _isElementOnScreen = isElementOnScreen;
local _setElementPosition = setElementPosition;
local sroll, croll, spitch, cpitch, syaw, cyaw, boneMat, rotMat, finalMatrix = false, false, false, false, false, false, {}, {}, {};
local v7, v8, v9 = false, false, false;
local boneMatOne = false;
local boneMatTwo = false;
local boneMatTree = false;
local boneMatFor = false;
local boneMatOneOne = false;
local boneMatOneTwo = false;
local boneMatOneTree = false;
local boneMatTwoOne = false;
local boneMatTwoTwo = false;
local boneMatTwoTree = false;
local boneMatTreeOne = false;
local boneMatTreeTwo = false;
local boneMatTreeTree = false;
local boneMatForOne = false;
local boneMatForTwo = false;
local boneMatForTree = false;
local rotMatOne = false;
local rotMatTwo = false;
local rotMatTree = false;
local rotMatOneOne = false;
local rotMatOneTwo = false;
local rotMatOneTree = false;
local rotMatTwoOne = false;
local rotMatTwoTwo = false;
local rotMatTwoTree = false;
local rotMatTreeOne = false;
local rotMatTreeTwo = false;
local rotMatTreeTree = false;
local FOR = false;
local FIVE = false;
local SIX = false;

local notOnScrenElements = {};


addEvent("sync_attachements", true);
addEvent("sync_detachements", true);
addEvent("sync_newcomeattachements", true);

addEventHandler("sync_attachements", root, function(data)
	if data then
		AttachementsTable[#AttachementsTable + 1] = data;
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
		if v then
			local elm = v[1];
			local ped = v[2];
			if _isElementOnScreen(ped) then
				notOnScrenElements[elm] = false;
				boneMat = _getElementBoneMatrix(ped, v[3]);
				v7, v8, v9 = v[7], v[8], v[9];
				sroll, croll, spitch, cpitch, syaw, cyaw = m_sin(v9), m_cos(v9), m_sin(v8), m_cos(v8), m_sin(v7), m_cos(v7);
				rotMat = {
					{sroll * spitch * syaw + croll * cyaw, sroll * cpitch, sroll * spitch * cyaw - croll * syaw},
					{croll * spitch * syaw - sroll * cyaw, croll * cpitch, croll * spitch * cyaw + sroll * syaw},
					{cpitch * syaw, -spitch, cpitch * cyaw}
				};
				boneMatOne = boneMat[1];
				boneMatTwo = boneMat[2];
				boneMatTree = boneMat[3];
				boneMatFor = boneMat[4];
				boneMatOneOne = boneMatOne[1];
				boneMatOneTwo = boneMatOne[2];
				boneMatOneTree = boneMatOne[3];
				boneMatTwoOne = boneMatTwo[1];
				boneMatTwoTwo = boneMatTwo[2];
				boneMatTwoTree = boneMatTwo[3];
				boneMatTreeOne = boneMatTree[1];
				boneMatTreeTwo = boneMatTree[2];
				boneMatTreeTree = boneMatTree[3];
				boneMatForOne = boneMatFor[1];
				boneMatForTwo = boneMatFor[2];
				boneMatForTree = boneMatFor[3];
				rotMatOne = rotMat[1];
				rotMatTwo = rotMat[2];
				rotMatTree = rotMat[3];
				rotMatOneOne = rotMatOne[1];
				rotMatOneTwo = rotMatOne[2];
				rotMatOneTree = rotMatOne[3];
				rotMatTwoOne = rotMatTwo[1];
				rotMatTwoTwo = rotMatTwo[2];
				rotMatTwoTree = rotMatTwo[3];
				rotMatTreeOne = rotMatTree[1];
				rotMatTreeTwo = rotMatTree[2];
				rotMatTreeTree = rotMatTree[3];
				FOR = v[4];
				FIVE = v[5];
				SIX = v[6];
				finalMatrix = {
					{boneMatTwoOne * rotMatOneTwo + boneMatOneOne * rotMatOneOne + rotMatOneTree * boneMatTreeOne,
					boneMatTreeTwo * rotMatOneTree + boneMatOneTwo * rotMatOneOne + boneMatTwoTwo * rotMatOneTwo,
					boneMatTwoTree * rotMatOneTwo + boneMatTreeTree * rotMatOneTree + rotMatOneOne * boneMatOneTree, 0},
					{rotMatTwoTree * boneMatTreeOne + boneMatTwoOne * rotMatTwoTwo + rotMatTwoOne * boneMatOneOne,
					boneMatTreeTwo * rotMatTwoTree + boneMatTwoTwo * rotMatTwoTwo + boneMatOneTwo * rotMatTwoOne,
					rotMatTwoOne * boneMatOneTree + boneMatTreeTree * rotMatTwoTree + boneMatTwoTree * rotMatTwoTwo, 0},
					{boneMatTwoOne * rotMatTreeTwo + rotMatTreeTree * boneMatTreeOne + rotMatTreeOne * boneMatOneOne,
					boneMatTreeTwo * rotMatTreeTree + boneMatTwoTwo * rotMatTreeTwo + rotMatTreeOne * boneMatOneTwo,
					rotMatTreeOne * boneMatOneTree + boneMatTreeTree * rotMatTreeTree + boneMatTwoTree * rotMatTreeTwo, 0},
					{FOR * boneMatOneOne + FIVE * boneMatTwoOne + SIX * boneMatTreeOne + boneMatForOne,
					FOR * boneMatOneTwo + FIVE * boneMatTwoTwo + SIX * boneMatTreeTwo + boneMatForTwo,
					FOR * boneMatOneTree + FIVE * boneMatTwoTree + SIX * boneMatTreeTree + boneMatForTree, 1}
				};
				_setElementMatrix(elm, finalMatrix);
			else
				if not notOnScrenElements[elm] then
					_setElementPosition(elm, 0, 0, -10000);
					notOnScrenElements[elm] = true;
				end
			end
		end
	end
end);