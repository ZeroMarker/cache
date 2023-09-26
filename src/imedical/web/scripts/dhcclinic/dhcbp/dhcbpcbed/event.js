
function InitViewScreenEvent(obj)
{ 
	var _DHCBPCB=ExtTool.StaticServerObject('web.DHCBPCBed');
	obj.LoadEvent = function(args)
	{
	};
	
	obj.btnAdd_click = function()
	{
		var BPCBCode=obj.BPCBCode.getValue();
		if(BPCBCode==""||BPCBCode==null)
		{
			ExtTool.alert("提示","床位代码不能为空！");
			obj.BPCBCode.focus();
			return;
		}
		var BPCBDesc=obj.BPCBDesc.getValue();
		if(BPCBDesc==""||BPCBDesc==null)
		{
			ExtTool.alert("提示","床位名称不能为空！");
			obj.BPCBDesc.focus();
			return;
		}
		var BPCBGroupDr=obj.BPCBGroupDr.getValue();
		if(BPCBGroupDr==""||BPCBGroupDr==null)
		{
			ExtTool.alert("提示","床位组不能为空！");
			obj.BPCBGroupDr.focus();
			return;
		}
		var BPCBStatus=obj.BPCBStatus.getValue();
		var BPCBType=obj.BPCBType.getValue();
		var ret=_DHCBPCB.InsertBPCBed(BPCBCode,BPCBDesc,BPCBGroupDr,BPCBStatus,BPCBType);
		if(ret==0) 
		{
			ExtTool.alert("提示","新增成功");
			ClearBPCBData(obj);
			obj.retGridPanelStore.load();
		}
		else ExtTool.alert("提示","新增失败!");	
	};
	obj.btnUpd_click = function()
	{
		var BPCBRowId=obj.BPCBRowId.getValue();
		if(BPCBRowId==""||BPCBRowId==null)
		{
			ExtTool.alert("提示","请选择要更新的记录！");
			return;
		}
		var BPCBCode=obj.BPCBCode.getValue();
		if(BPCBCode==""||BPCBCode==null)
		{
			ExtTool.alert("提示","床位代码不能为空！");
			obj.BPCBCode.focus();
			return;
		}
		var BPCBDesc=obj.BPCBDesc.getValue();
		if(BPCBDesc==""||BPCBDesc==null)
		{
			ExtTool.alert("提示","床位名称不能为空！");
			obj.BPCBDesc.focus();
			return;
		}
		var BPCBGroupDr=obj.BPCBGroupDr.getValue();
		if(BPCBGroupDr==""||BPCBGroupDr==null)
		{
			ExtTool.alert("提示","床位组不能为空！");
			obj.BPCBGroupDr.focus();
			return;
		}
		var BPCBStatus=obj.BPCBStatus.getValue();
		var BPCBType=obj.BPCBType.getValue();
		var ret=_DHCBPCB.UpdateBPCBed(BPCBRowId,BPCBCode,BPCBDesc,BPCBGroupDr,BPCBStatus,BPCBType);
		if(ret==0) 
		{
			ExtTool.alert("提示","更新成功");
			ClearBPCBData(obj);
			obj.retGridPanelStore.load();
		}
		else ExtTool.alert("提示","更新失败!");	
		
	};
	obj.btnDel_click = function()
	{	
		var RowId=obj.BPCBRowId.getValue();
		if(RowId=="")
		{
			ExtTool.alert("提示","请选择要删除的记录!");
			return;
		}
		var ret=_DHCBPCB.DeleteBPCBed(RowId);
		if(ret==0) 
		{
			ExtTool.alert("提示","删除成功");
			ClearBPCBData(obj);
			obj.retGridPanelStore.load();
		}
		else ExtTool.alert("提示","删除失败!");	
	};
	
	obj.retGridPanel_rowclick=function() //点击后获取数据
	{
		
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
	    {	
			obj.BPCBRowId.setValue(selectObj.get("tRowId"))
			obj.BPCBCode.setValue(selectObj.get("tBPCBCode"));
			obj.BPCBDesc.setValue(selectObj.get("tBPCBDesc"));
			obj.BPCBGroupDr.setValue(selectObj.get("tBPCBBPCBedGroupDr"))
			obj.BPCBStatus.setValue(selectObj.get("tBPCBStatus"));
			obj.BPCBType.setValue(selectObj.get("tBPCBType"));
		}
	};
	function ClearBPCBData(obj)
	{
		obj.BPCBRowId.setValue("");
		obj.BPCBCode.setValue("");
		obj.BPCBDesc.setValue("");
		obj.BPCBGroupDr.setValue("");
		obj.BPCBStatus.setValue("");
		obj.BPCBType.setValue("");

	}
}
