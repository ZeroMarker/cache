function InitViewScreenEvent(obj)
{
	var _DHCICUCViewSuperCat=ExtTool.StaticServerObject('web.DHCICUCViewSuperCat');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		  
	    obj.icuCVSCCode.setValue(rc.get("tICUCVSCCode"));
	    obj.icuCVSCDesc.setValue(rc.get("tICUCVSCDesc"));
	    obj.Rowid.setValue(rc.get("tICUCVSCRowId"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.floorno.getValue());
		if(obj.icuCVSCCode.getValue()=="")
		{
			ExtTool.alert("提示","类代码不能为空!");	
			return;
		}
		if(obj.icuCVSCDesc.getValue()=="")
		{
			ExtTool.alert("提示","类名称不能为空!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var icuCVSCCode=obj.icuCVSCCode.getValue();
		var icuCVSCDesc=obj.icuCVSCDesc.getValue();
		
        var repflag=_DHCICUCViewSuperCat.RepOperSuperCat(icuCVSCCode);
        if(repflag=="Y")
        {
		ExtTool.alert("提示","类代码有重复，无法添加!");
		 return;
		}
        
		var ret=_DHCICUCViewSuperCat.InsertOperSuperCat(icuCVSCCode,icuCVSCDesc);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","保存失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","保存成功!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.icuCVSCCode.setValue("");
	  	  	obj.icuCVSCDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
	  	if(obj.Rowid.getValue()=="")
		{
			ExtTool.alert("提示","请先选中一行记录!");	
			return;
		}
	  	if(obj.icuCVSCCode.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","类代码不能为空!",function(){obj.icuCVSCCode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.icuCVSCDesc.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","类名称不能为空!",function(){obj.icuCVSCDesc.focus(true,true);});
	  		return;
	  	};
	  	var Rowid=obj.Rowid.getValue();
        var icuCVSCCode=obj.icuCVSCCode.getValue();
        var icuCVSCDesc=obj.icuCVSCDesc.getValue();
		var ret =_DHCICUCViewSuperCat.UpdateOperSuperCat(Rowid,icuCVSCCode,icuCVSCDesc);
		if(ret!='0')
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.icuCVSCCode.setValue("");
	  	  	obj.icuCVSCDesc.setValue("");
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
	  	var ret=_DHCICUCViewSuperCat.DeleteOperSuperCat(ID);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.icuCVSCCode.setValue("");
	  	  	obj.icuCVSCDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}