function InitViewScreenEvent(obj)
{
	var _DHCANCInstrument=ExtTool.StaticServerObject('web.DHCANCInstrument');
	obj.LoadEvent = function(args)
	{
	};
	var SelectedRowID = 0;
	var preRowID=0;
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  var linenum=obj.retGridPanel.getSelectionModel().lastActive;
	  if (rc)
	  {
		  SelectedRowID=rc.get("RowId");
		  if(preRowID!=SelectedRowID)
		  {
			  obj.ancInstrCode.setValue(rc.get("ANCINSTR_Code"));
			  obj.ancInstrDesc.setValue(rc.get("ANCINSTR_Desc"));
			  obj.Rowid.setValue(rc.get("RowId"));
			  preRowID=SelectedRowID;
		  }
		  else
		  {
			  obj.ancInstrCode.setValue("");
			  obj.ancInstrDesc.setValue("");
			  SelectedRowID = 0;
			  preRowID=0;
			  obj.retGridPanel.getSelectionModel().deselectRow(linenum);
		  }
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.floorno.getValue());
		if(obj.ancInstrCode.getValue()=="")
		{
			ExtTool.alert("提示","器械代码不能为空!");	
			return;
		}
		if(obj.ancInstrDesc.getValue()=="")
		{
			ExtTool.alert("提示","器械名称不能为空!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var ancInstrCode=obj.ancInstrCode.getValue();
		var ancInstrDesc=obj.ancInstrDesc.getValue();

		var ret=_DHCANCInstrument.InsertOperInstrument(ancInstrCode,ancInstrDesc);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","保存失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","保存成功!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.ancInstrCode.setValue("");
	  	  	obj.ancInstrDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
	  	if(obj.ancInstrCode.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","器械代码不能为空!",function(){obj.ancInstrCode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.ancInstrDesc.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","器械名称不能为空!",function(){obj.ancInstrDesc.focus(true,true);});
	  		return;
	  	};
	  	var Rowid=obj.Rowid.getValue();
        var ancInstrCode=obj.ancInstrCode.getValue();
        var ancInstrDesc=obj.ancInstrDesc.getValue();
		var ret =_DHCANCInstrument.UpdateOperInstrument(Rowid,ancInstrCode,ancInstrDesc);
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.ancInstrCode.setValue("");
	  	  	obj.ancInstrDesc.setValue("");
	  	  	obj.retGridPanelStore.load({}); 
		  	});
	     }
	 };
	
	obj.deletebutton_click = function()
	{
	  var ID=obj.Rowid.getValue();
	  if(ID=="")
	  {
	    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	    return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCANCInstrument.DeleteOperInstrument(ID);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.ancInstrCode.setValue("");
	  	  	obj.ancInstrDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}