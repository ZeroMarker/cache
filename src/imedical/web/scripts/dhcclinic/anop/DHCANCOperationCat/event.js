function InitViewScreenEvent(obj)
{
	var _DHCANCOperationCat=ExtTool.StaticServerObject('web.DHCANCOperationCat');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		  
	    obj.OperationCatCode.setValue(rc.get("ANCOCCode"));
	    obj.OperationCatName.setValue(rc.get("ANCOCDesc"));
	    obj.Rowid.setValue(rc.get("RowId"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.OperationCatCode.getValue()=="")
		{
			ExtTool.alert("提示","类代码不能为空!");	
			return;
		}
		if(obj.OperationCatName.getValue()=="")
		{
			ExtTool.alert("提示","类名称不能为空!");	
			return;
		}
		var OperationCatCode=obj.OperationCatCode.getValue();
		var OperationCatName=obj.OperationCatName.getValue();

		var ret=_DHCANCOperationCat.InsertOperCat(OperationCatCode,OperationCatName);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","保存失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","保存成功!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.OperationCatCode.setValue("");
	  	  	obj.OperationCatName.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
	  	if(obj.Rowid.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","系统号不能为空!",function(){obj.Rowid.focus(true,true);});
	  		return;
	  	} ;		
	  	if(obj.OperationCatCode.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","类代码不能为空!",function(){obj.OperationCatCode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.OperationCatName.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","类名称不能为空!",function(){obj.OperationCatName.focus(true,true);});
	  		return;
	  	};
	  	var Rowid=obj.Rowid.getValue();
        var OperationCatCode=obj.OperationCatCode.getValue();
		var OperationCatName=obj.OperationCatName.getValue();
		var ret = _DHCANCOperationCat.UpdateOperCat(Rowid,OperationCatCode,OperationCatName);
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.OperationCatCode.setValue("");
	  	  	obj.OperationCatName.setValue("");
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
	  	var ret=_DHCANCOperationCat.DeleteOperCat(ID);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.OperationCatCode.setValue("");
	  	  	obj.OperationCatName.setValue("");
	  	  	obj.retGridPanelStore.load({});   	  	
	  	  	});

	  	}
	  );
	};
	
}

