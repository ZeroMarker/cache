
function InitViewScreenEvent(obj)
{ 
	var _DHCBPCRItem=ExtTool.StaticServerObject('web.DHCBPCRecordItem');
	obj.LoadEvent = function(args)
	{
	};
	
	obj.btnDel_click = function()
	{	
		var RowId=obj.BPCRIRowId.getValue();
		if(RowId=="")
		{
			ExtTool.alert("提示","请选择一条要删除的记录!");
			return;
		}
		var ret=_DHCBPCRItem.DeleteBPCReItem(RowId);
		if(ret==0) 
		{
			ExtTool.alert("提示","删除成功");
			ClearBPCRIData(obj);
			obj.BPCRIMainRecordItemDrStore.load();
			obj.retGridPanelStore.load();
		}
		else ExtTool.alert("提示","删除失败!");	
	};
	
	obj.btnUpd_click = function()
	{	
		var RowId=obj.BPCRIRowId.getValue();
		if(RowId=="")
		{
			ExtTool.alert("提示","请选择一条要更新的记录!");
			return;
		}
		var BPCRICode=obj.BPCRICode.getValue();
		var BPCRIDesc=obj.BPCRIDesc.getValue();
		if(BPCRICode=="")
		{
			ExtTool.alert("提示","代码不能为空!");
			return;
		}
		if(BPCRIDesc=="")
		{
			ExtTool.alert("提示","名称不能为空!");
			return;
		}
		var BPCRIBPCRecordCatDr=obj.BPCRIBPCRecordCatDr.getValue();
		var BPCRIType=obj.BPCRIType.getValue();
		var BPCRIArcimDr=obj.BPCRIArcimDr.getValue();
		var BPCRIUomDr=obj.BPCRIUomDr.getValue();
		var BPCRIOptions=obj.BPCRIOptions.getValue();
		var BPCRIDataType=obj.BPCRIDataType.getValue();
		var BPCRIMultiValueDesc=obj.BPCRIMultiValueDesc.getValue();
		var BPCRISortNo=obj.BPCRISortNo.getValue();
		var BPCRIMin=obj.BPCRIMin.getValue();
		var BPCRIMax=obj.BPCRIMax.getValue();
		var BPCRIImpossibleMin=obj.BPCRIImpossibleMin.getValue();
		var BPCRIImpossibleMax=obj.BPCRIImpossibleMax.getValue();
		var BPCRIMainRecordItemDr=obj.BPCRIMainRecordItemDr.getValue();
		var ret=_DHCBPCRItem.UpdateBPCReItem(RowId,BPCRICode,BPCRIDesc,BPCRIBPCRecordCatDr,BPCRIType,BPCRIArcimDr,BPCRIUomDr,BPCRIOptions,BPCRIDataType,BPCRIMultiValueDesc,BPCRISortNo,BPCRIMin,BPCRIMax,BPCRIImpossibleMin,BPCRIImpossibleMax,BPCRIMainRecordItemDr);
		if(ret==0) 
		{
			ExtTool.alert("提示","更新成功");
			ClearBPCRIData(obj);
			obj.BPCRIMainRecordItemDrStore.load();
			obj.retGridPanelStore.load();
		}
		else ExtTool.alert("提示","更新失败!");	
	};
	
	obj.btnAdd_click = function()
	{
		var BPCRICode=obj.BPCRICode.getValue();
		var BPCRIDesc=obj.BPCRIDesc.getValue();
		if(BPCRICode=="")
		{
			ExtTool.alert("提示","代码不能为空!");
			return;
		}
		if(BPCRIDesc=="")
		{
			ExtTool.alert("提示","名称不能为空!");
			return;
		}
		var count=obj.retGridPanelStore.getCount();//数据行数
		for (var i=0;i<count;i++)
		{		
			var record=obj.retGridPanelStore.getAt(i);
			var code=record.get('tBPCRICode');		
			if((code!="")&&(code==BPCRICode))
			{
			 	ExtTool.alert("提示","项目代码已存在!无法保存");
				return;
			}
		}
		var BPCRIBPCRecordCatDr=obj.BPCRIBPCRecordCatDr.getValue();
		var BPCRIType=obj.BPCRIType.getValue();
		var BPCRIArcimDr=obj.BPCRIArcimDr.getValue();
		var BPCRIUomDr=obj.BPCRIUomDr.getValue();
		var BPCRIOptions=obj.BPCRIOptions.getValue();
		var BPCRIDataType=obj.BPCRIDataType.getValue();
		var BPCRIMultiValueDesc=obj.BPCRIMultiValueDesc.getValue();
		var BPCRISortNo=obj.BPCRISortNo.getValue();
		var BPCRIMin=obj.BPCRIMin.getValue();
		var BPCRIMax=obj.BPCRIMax.getValue();
		var BPCRIImpossibleMin=obj.BPCRIImpossibleMin.getValue();
		var BPCRIImpossibleMax=obj.BPCRIImpossibleMax.getValue();
		var BPCRIMainRecordItemDr=obj.BPCRIMainRecordItemDr.getValue();
		var ret=_DHCBPCRItem.InsertBPCReItem(BPCRICode,BPCRIDesc,BPCRIBPCRecordCatDr,BPCRIType,BPCRIArcimDr,BPCRIUomDr,BPCRIOptions,BPCRIDataType,BPCRIMultiValueDesc,BPCRISortNo,BPCRIMin,BPCRIMax,BPCRIImpossibleMin,BPCRIImpossibleMax,BPCRIMainRecordItemDr);
		if(ret==0) 
		{
			ExtTool.alert("提示","新增成功");
			ClearBPCRIData(obj);
			obj.BPCRIMainRecordItemDrStore.load();
			obj.retGridPanelStore.load();
		}
		else ExtTool.alert("提示","新增失败");	
	};
	obj.retGridPanel_rowclick=function() //点击后获取数据
	{
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
	    {	
	    	
			obj.BPCRIRowId.setValue(selectObj.get("tRowId"))
			obj.BPCRICode.setValue(selectObj.get("tBPCRICode"));
			obj.BPCRIDesc.setValue(selectObj.get("tBPCRIDesc"));
			obj.BPCRIBPCRecordCatDr.setValue(selectObj.get("tBPCRIBPCRecordCatDr"))
			obj.BPCRIType.setValue(selectObj.get("tBPCRITypeDr"));
			obj.BPCRIArcimDr.setValue(selectObj.get("tBPCRIArcimDr"));
			obj.BPCRIUomDr.setValue(selectObj.get("tBPCRIUomDr"))
			obj.BPCRIOptions.setValue(selectObj.get("tBPCRIOptions"));
			obj.BPCRIDataType.setValue(selectObj.get("tBPCRIDataTypeDr"));
			obj.BPCRIMultiValueDesc.setValue(selectObj.get("tBPCRIMultiValueDesc"))
			obj.BPCRISortNo.setValue(selectObj.get("tBPCRISortNo"));
			obj.BPCRIMin.setValue(selectObj.get("tBPCRIMin"));
			obj.BPCRIMax.setValue(selectObj.get("tBPCRIMax"))
			obj.BPCRIImpossibleMin.setValue(selectObj.get("tBPCRIImpossibleMin"));
			obj.BPCRIImpossibleMax.setValue(selectObj.get("tBPCRIImpossibleMax"));
			obj.BPCRIMainRecordItemDr.setValue(selectObj.get("tBPCRIMainRecordItemDr"));
			
		}
	};
function ClearBPCRIData(obj)
{
	obj.BPCRIRowId.setValue("");
	obj.BPCRICode.setValue("");
	obj.BPCRIDesc.setValue("");
	obj.BPCRIBPCRecordCatDr.setValue("");
	obj.BPCRIType.setValue("");
	obj.BPCRIArcimDr.setValue("");
	obj.BPCRIUomDr.setValue("");
	obj.BPCRIOptions.setValue("");
	obj.BPCRIDataType.setValue("");
	obj.BPCRIMultiValueDesc.setValue("");
	obj.BPCRISortNo.setValue("");
	obj.BPCRIMin.setValue("");
	obj.BPCRIMax.setValue("");
	obj.BPCRIImpossibleMin.setValue("");
	obj.BPCRIImpossibleMax.setValue("");
	obj.BPCRIMainRecordItemDr.setValue("");

}

}




