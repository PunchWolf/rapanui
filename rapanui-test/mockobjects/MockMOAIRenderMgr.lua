function createMockMOAIRenderMgr()

    local MockMOAIRenderMgr = {
        setRenderTableCalled = 0,
    }

    function MockMOAIRenderMgr.setRenderTable(layers)
        assert_not_nil(layers)
        MockMOAIRenderMgr.setRenderTableCalled = MockMOAIRenderMgr.setRenderTableCalled + 1
    end

    function MockMOAIRenderMgr:reset()
        self.setRenderTableCalled = 0
    end

    return MockMOAIRenderMgr
end