function InitViewScreenEvent(obj)
{
	var _DHCICUCProperty=ExtTool.StaticServerObject('web.DHCICUCProperty');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		obj.tICUCPRowID.setValue(rc.get("tICUCPRowID"));
	    obj.viewsupcode.setValue(rc.get("tICUCPCode"));
	    obj.viewsupname.setValue(rc.get("tICUCPDesc"));
	    //20160928+dyl
	    obj.viewsupvalue.setValue(rc.get("tICUCPDefaultValue"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.floorno.getValue());
		if(obj.viewsupcode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.viewsupname.getValue()=="")
		{
			ExtTool.alert("提示","名称不能为空!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var viewsupcode=obj.viewsupcode.getValue();
		var viewsupname=obj.viewsupname.getValue();
		var viewsupvalue=obj.viewsupvalue.getValue();


		var ret=_DHCICUCProperty.InsertProperty(viewsupcode,viewsupname,viewsupvalue);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","保存失败!"+ret);
		}
		else 
		{
			Ext.Msg.alert("提示","保存成功!",function(){
	  	  	obj.viewsupcode.setValue("");
	  	  	obj.viewsupname.setValue("");
	  	  	obj.viewsupvalue.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
		//alert("gg")
	  	if(obj.tICUCPRowID.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","请选择一条记录!",function(){obj.Rowid.focus(true,true);});
	  		return;
	  	} ;		
	  	if(obj.viewsupcode.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","代码不能为空!",function(){obj.viewsupcode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.viewsupname.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","名称不能为空!",function(){obj.viewsupname.focus(true,true);});
	  		return;
	  	};
	  	var tICUCPRowID=obj.tICUCPRowID.getValue();
        var viewsupcode=obj.viewsupcode.getValue();
        var viewsupname=obj.viewsupname.getValue();
        var viewsupvalue=obj.viewsupvalue.getValue();
		var ret = _DHCICUCProperty.UpdateProperty(tICUCPRowID,viewsupcode,viewsupname,viewsupvalue);
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	obj.tICUCPRowID.setValue("");
	  	  	obj.viewsupcode.setValue("");
	  	  	obj.viewsupname.setValue("");
	  	  	obj.viewsupvalue.setValue("");
	  	  	obj.retGridPanelStore.load({}); 
		  	});
	     }
	 };
	
	obj.deletebutton_click = function()
	{
	  var ID=obj.tICUCPRowID.getValue();
	  //alert(ID);
	  if(ID=="")
	  {
	    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	    return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCICUCProperty.DeleteProperty(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.tICUCPRowID.setValue("");
	  	  	obj.viewsupcode.setValue("");
	  	  	obj.viewsupname.setValue("");
	  	  	obj.viewsupvalue.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}

