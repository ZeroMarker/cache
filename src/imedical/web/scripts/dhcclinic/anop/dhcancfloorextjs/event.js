function InitViewScreenEvent(obj)
{
	var _DHCANCFloor=ExtTool.StaticServerObject('web.DHCANCFloor');
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
			  obj.floorno.setValue(rc.get("ANCF_Code"));
			  obj.floorname.setValue(rc.get("ANCF_Desc"));
			  obj.Rowid.setValue(rc.get("RowId"));
			  preRowID=SelectedRowID;
		  }
		  else
		  {
		    obj.floorno.setValue("");
		    obj.floorname.setValue("");
		    SelectedRowID = 0;
		    preRowID=0;
		    obj.retGridPanel.getSelectionModel().deselectRow(linenum);
		  }
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.floorno.getValue());
		if(obj.floorno.getValue()=="")
		{
			ExtTool.alert("提示","楼层代码不能为空!");	
			return;
		}
		if(obj.floorname.getValue()=="")
		{
			ExtTool.alert("提示","楼层名称不能为空!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var floorno=obj.floorno.getValue();
		var floorname=obj.floorname.getValue();

		var ret=_DHCANCFloor.InsertOperFloor(floorno,floorname);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","保存失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","保存成功!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.floorno.setValue("");
	  	  	obj.floorname.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
		//alert("gg")
	  	if(obj.floorno.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","楼层代码为空!",function(){obj.floorno.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.floorname.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","楼层名称为空!",function(){obj.floorname.focus(true,true);});
	  		return;
	  	};
	  	var Rowid=obj.Rowid.getValue();
        var floorno=obj.floorno.getValue();
        var floorname=obj.floorname.getValue();
		var ret = _DHCANCFloor.UpdateOperFloor(Rowid,floorno,floorname);
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.floorno.setValue("");
	  	  	obj.floorname.setValue("");
	  	  	obj.retGridPanelStore.load({}); 
		  	});
	     }
	 };
	
	obj.deletebutton_click = function()
	{
	  var ID=obj.Rowid.getValue();
	  //alert(ID);
	  if(ID=="")
	  {
	    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	    return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCANCFloor.DeleteOperFloor(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.floorno.setValue("");
	  	  	obj.floorname.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}

