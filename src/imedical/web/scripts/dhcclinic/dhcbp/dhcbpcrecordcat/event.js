
function InitViewScreenEvent(obj)
{ 
	var _DHCBPCRC=ExtTool.StaticServerObject('web.DHCBPCRecordCat');
	obj.LoadEvent = function(args)
	{
	};
	obj.btnSch_click = function()
	{
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load();
	};
	obj.btnAdd_click = function()
	{
		
		var BPCRCCode=obj.BPCRCCode.getValue();
		var BPCRCDesc=obj.BPCRCDesc.getValue();
		if (BPCRCCode==""){ExtTool.alert("提示","代码不能为空!");return;}
		var ret=_DHCBPCRC.InsertBPCRecordCat(BPCRCCode,BPCRCDesc);
		if(ret==0) 
		{
			ExtTool.alert("提示","新增成功");
			ClearBPCRCData(obj);
		  obj.retGridPanelStore.load();
		}
		else ExtTool.alert("提示","新增失败!");	

	};
	obj.btnUpd_click = function()
	{
		var BPCRCRowId=obj.BPCRCRowId.getValue();
		var BPCRCCode=obj.BPCRCCode.getValue();
		var BPCRCDesc=obj.BPCRCDesc.getValue();
		if(BPCRCRowId==""){
			ExtTool.alert("提示","请选择一条要更新的记录");
			return;
		}
		var ret=_DHCBPCRC.UpdateBPCRecordCat(BPCRCRowId,BPCRCCode,BPCRCDesc);
		if(ret==0) 
		{
			ExtTool.alert("提示","更新成功");
			ClearBPCRCData(obj);
		  obj.retGridPanelStore.load();
		}
		else ExtTool.alert("提示","更新失败!");	

	};
	obj.btnDel_click = function()
	{	
		var RowId=obj.BPCRCRowId.getValue();
		if(RowId=="")
		{
			ExtTool.alert("提示","请选择一条要删除的记录!");
			return;
		}
		var ret=_DHCBPCRC.DeleteBPCRecordCat(RowId);
		if(ret==0) 
		{
			ExtTool.alert("提示","删除成功");
			ClearBPCRCData(obj);
			obj.retGridPanelStore.load();
		}
		else ExtTool.alert("提示","删除失败!");	
	};
	
	obj.retGridPanel_rowclick=function() //点击后获取数据
	{
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
	    {	
			obj.BPCRCRowId.setValue(selectObj.get("tRowId"))
			obj.BPCRCCode.setValue(selectObj.get("tBPCRCCode"));
			obj.BPCRCDesc.setValue(selectObj.get("tBPCRCDesc"));
		}
	};
function ClearBPCRCData(obj)
{
	obj.BPCRCRowId.setValue("");
	obj.BPCRCCode.setValue("");
	obj.BPCRCDesc.setValue("");


}

}
