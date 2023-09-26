function InitViewScreenEvent(obj)
{
	var _DHCANCViewSuperCat=ExtTool.StaticServerObject('web.DHCANCViewSuperCat');
	obj.LoadEvent = function(args)
	{
		obj.Rowid.setValue("");
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
			  obj.viewsupcode.setValue(rc.get("TANCVSCCode"));
			  obj.viewsupname.setValue(rc.get("TANCVSCDesc"));
			  obj.Rowid.setValue(rc.get("RowId"));
			  preRowID=SelectedRowID;
		  }
		  else
		  {
			  obj.viewsupcode.setValue("");
			  obj.viewsupname.setValue("");
			  obj.Rowid.setValue("")
			  SelectedRowID = 0;
			  preRowID=0;
			  obj.retGridPanel.getSelectionModel().deselectRow(linenum);
		  }
	  }
	}; 
	
	obj.addbutton_click = function()
	{
		//alert(obj.floorno.getValue());
		if(obj.viewsupcode.getValue()=="")
		{
			ExtTool.alert("提示","类代码不能为空!");	
			return;
		}
		if(obj.viewsupname.getValue()=="")
		{
			ExtTool.alert("提示","类名称不能为空!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var viewsupcode=obj.viewsupcode.getValue();
		var viewsupname=obj.viewsupname.getValue();

		var ret=_DHCANCViewSuperCat.InsertOperSuperCat(viewsupcode,viewsupname);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","保存失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","保存成功!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.viewsupcode.setValue("");
	  	  	obj.viewsupname.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
		//alert("gg")
	  	if(obj.Rowid.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","系统号不能为空!",function(){obj.Rowid.focus(true,true);});
	  		return;
	  	} ;		
	  	if(obj.viewsupcode.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","类代码不能为空!",function(){obj.viewsupcode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.viewsupname.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","类名称不能为空!",function(){obj.viewsupname.focus(true,true);});
	  		return;
	  	};
	  	var Rowid=obj.Rowid.getValue();
        var viewsupcode=obj.viewsupcode.getValue();
        var viewsupname=obj.viewsupname.getValue();
		var ret = _DHCANCViewSuperCat.UpdateOperSuperCat(Rowid,viewsupcode,viewsupname);
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.viewsupcode.setValue("");
	  	  	obj.viewsupname.setValue("");
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
	  	var ret=_DHCANCViewSuperCat.DeleteOperSuperCat(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.viewsupcode.setValue("");
	  	  	obj.viewsupname.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}

