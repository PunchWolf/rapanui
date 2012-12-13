--[[
--
-- RapaNui
--
-- by Ymobe ltd  (http://ymobe.co.uk)
--
-- LICENSE:
--
-- RapaNui uses the Common Public Attribution License Version 1.0 (CPAL) http://www.opensource.org/licenses/cpal_1.0.
-- CPAL is an Open Source Initiative approved
-- license based on the Mozilla Public License, with the added requirement that you attribute
-- Moai (http://getmoai.com/) and RapaNui in the credits of your program.
]]

-- Author: niom
-- Date: 11/25/12

RNLayer = {
    LAYER_WITH_SAME_NAME_EXISTS = "layer with same name already exists",
    MAIN_LAYER = "mainlayer"
}

function RNLayer:new()
    local layers = {}
    setmetatable(layers,self)
    self.__index = self
    return layers
end

function RNLayer:createLayer(name,viewport)
	local layer = MOAILayer2D.new()
	local index = table.getn(self) + 1
	
	if self:get(name) then
		return nil, RNLayer.LAYER_WITH_SAME_NAME_EXISTS
	end

    self[index] = {} 
    self[index].layer = layer
    self[index].name = name
    layer:setViewport(viewport)
    MOAIRenderMgr.setRenderTable(self:createDrawOrder())
    return layer
end

function RNLayer:get(name)
    for i,container in pairs(self) do
        if container.name == name then
            return container.layer
        end
    end
end

function RNLayer:createLayerWithPartition(name,viewport)
    local layer = self:createLayer(name,viewport)
    local partition = MOAIPartition.new()
    layer:setPartition(partition)
    return layer,partition
end

function RNLayer:remove(layer)
	for i, container in pairs(self) do
		if container.layer == layer then
			self:clearContainer(container)
			table.remove(self, i)
		end
	end
end

function RNLayer:removeAll()
	while table.getn(self) > 0 do
		self:clearContainer(self[1])
		table.remove(self, 1)
	end
end

function RNLayer:clearContainer(container)
	container.layer:clear()
	container.layer = nil
	container.name = nil
end

function RNLayer:createDrawOrder()
    local drawOrder = {}
    for i, container in pairs(self) do
        drawOrder[i] = container.layer
    end
    return drawOrder
end

function RNLayer:getLayerContainer(layer)
    for i, container in pairs(self) do
        if container.layer == layer then
            return container,i
        end
    end    
end

function RNLayer:bringToFront(layer)
    local size = table.getn(self)
    local layersContainer, index = self:getLayerContainer(layer)

    table.remove(self,index)
    table.insert(self,size,layersContainer)
    MOAIRenderMgr.setRenderTable(self:createDrawOrder())
end

function RNLayer:sendToBack(layer)
    local layersContainer, index = self:getLayerContainer(layer)

    table.remove(self,index)
    table.insert(self,1,layersContainer)
    MOAIRenderMgr.setRenderTable(self:createDrawOrder())
end

function RNLayer:putOver(layerToMove,targetLayer)
    local layersContainer, index = self:getLayerContainer(layerToMove)
    table.remove(self,index)
    local targetLayer, targetIndex = self:getLayerContainer(targetLayer)
    table.insert(self,targetIndex + 1,layersContainer)
    MOAIRenderMgr.setRenderTable(self:createDrawOrder())
end

return RNLayer