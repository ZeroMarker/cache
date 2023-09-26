function InitViewScreenEvent(obj)
{
	var _DHCANCIcon=ExtTool.StaticServerObject('web.DHCANCIcon');
	var SelectedRowID = 0;
	var preRowID=0;
	obj.retGridPanel_rowclick=function()
	{
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
	    var linenum=obj.retGridPanel.getSelectionModel().lastActive;
		if(rc)
		{
			SelectedRowID=rc.get("rowid0");
			if(preRowID!=SelectedRowID)
			{
				obj.RowId.setValue(rc.get("rowid0"));
				obj.ANICode.setValue(rc.get("ANICode"));
				obj.ANIWidth.setValue(rc.get("ANIWidth"));
				obj.ANIData.setValue(rc.get("ANIData"));
				obj.ANIDesc.setValue(rc.get("ANIDesc"));
				obj.ANIHeight.setValue(rc.get("ANIHeight"));
				obj.ANILineWidth.setValue(rc.get("ANILineWidth"));
				obj.ANIShape.setValue(rc.get("ANIShape"));
				obj.ANIPositionX.setValue(rc.get("ANIPositionX"));
				obj.ANICount.setValue(rc.get("ANICount"));
				obj.ANIPositionY.setValue(rc.get("ANIPositionY"));
				preRowID=SelectedRowID;
			}
			else
			{
				obj.RowId.setValue("");
				obj.ANICode.setValue("");
				obj.ANIWidth.setValue("");
				obj.ANIData.setValue("");
				obj.ANIDesc.setValue("");
				obj.ANIHeight.setValue("");
				obj.ANILineWidth.setValue("");
				obj.ANIShape.setValue("");
				obj.ANIPositionX.setValue("");
				obj.ANICount.setValue("");
				obj.ANIPositionY.setValue("");
				SelectedRowID = 0;
				preRowID=0;
				obj.retGridPanel.getSelectionModel().deselectRow(linenum);
			}
		}
	}
	
	obj.addButton_click=function()
	{
		var ANICode = obj.ANICode.getValue();
		var ANIDesc = obj.ANIDesc.getValue();
		var ANICount = obj.ANICount.getValue();
		var ANIWidth = obj.ANIWidth.getValue();
		var ANIHeight = obj.ANIHeight.getValue();
		var ANIPositionX = obj.ANIPositionX.getValue();
		var ANIPositionY = obj.ANIPositionY.getValue();
		var ANILineWidth = obj.ANILineWidth.getValue();
		var ANIShape = obj.ANIShape.getValue();
		var ANIData = obj.ANIData.getValue();
		
		if(ANICode=="")
		{
			Ext.Msg.alert("提示","图例代码不能为空!");
			return;
		}
		
		var str=ANICode+"^"+ANIDesc+"^"+ANICount+"^"+ANIWidth+"^"+ANIHeight+"^"+ANIPositionX+"^"+ANIPositionY+"^"+ANILineWidth+"^"+ANIShape+"^"+ANIData;
		var ret=_DHCANCIcon.InsertDHCANCIcon(str);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","添加成功!",function(){
				obj.ANICode.setValue("");
				obj.ANIDesc.setValue("");
				obj.ANICount.setValue("");
				obj.ANIWidth.setValue("");
				obj.ANIHeight.setValue("");
				obj.ANIPositionX.setValue("");
				obj.ANIPositionY.setValue("");
				obj.ANILineWidth.setValue("");
				obj.ANIShape.setValue("");
				obj.ANIData.setValue("");
				obj.RowId.setValue("");
				
	  	  		obj.retGridPanelStore.reload();	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("提示","添加失败!");
			return;
		}
		
	}
	
	obj.updateButton_click=function()
	{
		var ANICode = obj.ANICode.getValue();
		var ANIDesc = obj.ANIDesc.getValue();
		var ANICount = obj.ANICount.getValue();
		var ANIWidth = obj.ANIWidth.getValue();
		var ANIHeight = obj.ANIHeight.getValue();
		var ANIPositionX = obj.ANIPositionX.getValue();
		var ANIPositionY = obj.ANIPositionY.getValue();
		var ANILineWidth = obj.ANILineWidth.getValue();
		var ANIShape = obj.ANIShape.getValue();
		var ANIData = obj.ANIData.getValue();
		var RowId = obj.RowId.getValue();
		if(RowId=="")
		{
			Ext.Msg.alert("提示","请选择一条记录!");
			return;
		}
		var str=ANICode+"^"+ANIDesc+"^"+ANICount+"^"+ANIWidth+"^"+ANIHeight+"^"+ANIPositionX+"^"+ANIPositionY+"^"+ANILineWidth+"^"+ANIShape+"^"+ANIData+"^"+RowId;
		var ret=_DHCANCIcon.UpdateDHCANCIcon("","",str);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","更新成功!",function(){
				obj.ANICode.setValue("");
				obj.ANIDesc.setValue("");
				obj.ANICount.setValue("");
				obj.ANIWidth.setValue("");
				obj.ANIHeight.setValue("");
				obj.ANIPositionX.setValue("");
				obj.ANIPositionY.setValue("");
				obj.ANILineWidth.setValue("");
				obj.ANIShape.setValue("");
				obj.ANIData.setValue("");
				obj.RowId.setValue("");
				
	  	  		obj.retGridPanelStore.reload();	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("提示","更新失败!"+ret);
			return;
		}
	}
	
	obj.deleteButton_click=function()
	{
		var RowId = obj.RowId.getValue();
		if(RowId=="")
		{
			Ext.Msg.alert("提示","请选择要删除的一行!");
			return;
		}
		
		Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  		if(btn=="no")return;
	  		var ret=_DHCANCIcon.DeleteDHCANCIcon("","",RowId);
	  		//var ret=_DHCANCIcon.DeleteDHCANCIconNew(RowId);
	  		if(ret!="0")
	  	  		Ext.Msg.alert("提示","删除失败！"+ret);
	  		else
	  	 	 Ext.Msg.alert("提示","删除成功！",function(){
				obj.ANICode.setValue("");
				obj.ANIDesc.setValue("");
				obj.ANICount.setValue("");
				obj.ANIWidth.setValue("");
				obj.ANIHeight.setValue("");
				obj.ANIPositionX.setValue("");
				obj.ANIPositionY.setValue("");
				obj.ANILineWidth.setValue("");
				obj.ANIShape.setValue("");
				obj.ANIData.setValue("");
				obj.RowId.setValue("");
				
				obj.retGridPanelStore.reload();	
		  	});
	    });	
	}
	
	obj.findButton_click=function()
	{
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCIcon';
		param.QueryName = 'GetDHCANCIcon';
		param.Arg1 = obj.ANICode.getRawValue();
		param.Arg2 = obj.ANIDesc.getRawValue();
		param.ArgCnt = 2;
	});
	obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		});
		obj.ANICode.setValue("");
		obj.ANIDesc.setValue("");
		obj.ANICount.setValue("");
		obj.ANIWidth.setValue("");
		obj.ANIHeight.setValue("");
		obj.ANIPositionX.setValue("");
		obj.ANIPositionY.setValue("");
		obj.ANILineWidth.setValue("");
		obj.ANIShape.setValue("");
		obj.ANIData.setValue("");
		obj.RowId.setValue("");

	}
}