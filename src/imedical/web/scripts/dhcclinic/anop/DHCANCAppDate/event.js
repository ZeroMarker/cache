function InitViewScreenEvent(obj)
{
	var _DHCANCOrc=ExtTool.StaticServerObject('web.DHCANCOrc');
	var _DHCANOPCom=ExtTool.StaticServerObject('web.DHCANOPCom');
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
		  SelectedRowID=rc.get("appdate");
		  if(preRowID!=SelectedRowID)
		  {
			  obj.sdate.setValue(rc.get("appdate"));
			  preRowID=SelectedRowID;
		  }
		  else
		  {
			  obj.sdate.setValue("");
			  SelectedRowID = 0;
			  preRowID=0;
			  obj.retGridPanel.getSelectionModel().deselectRow(linenum);
		  }
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.sdate.getValue());
		//alert(obj.sdate.getRawValue());
		if(obj.sdate.getRawValue()=="")
		{
			ExtTool.alert("提示","日期不能为空!");	
			return;
		}
		var sdate=obj.sdate.getRawValue();

		var ret=_DHCANCOrc.InsertAncAppDate(sdate);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","保存失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","保存成功!",function(){
	  	  	obj.sdate.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};


	obj.deletebutton_click = function()
	{
	  var ID=obj.sdate.getRawValue();
	  if(ID=="")
	  {
	    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	    return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCANCOrc.DeleAncAppDate(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.sdate.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}

