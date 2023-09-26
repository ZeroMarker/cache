function InitViewScreenEvent(obj)
{
	var _DHCBPCVisitStatus=ExtTool.StaticServerObject('web.DHCBPCVisitStatus');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		  
	    obj.bpcVSCode.setValue(rc.get("tBPCVSCode"));
	    obj.bpcVSDesc.setValue(rc.get("tBPCVSDesc"));
	    obj.Rowid.setValue(rc.get("tBPCVSRowId"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.floorno.getValue());
		if(obj.bpcVSCode.getValue()=="")
		{
			ExtTool.alert("提示","模式代码不能为空!");	
			return;
		}
		if(obj.bpcVSDesc.getValue()=="")
		{
			ExtTool.alert("提示","模式描述不能为空!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var bpcVSCode=obj.bpcVSCode.getValue();
		var bpcVSDesc=obj.bpcVSDesc.getValue();

		var ret=_DHCBPCVisitStatus.InsertVStatus(bpcVSCode,bpcVSDesc);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","保存失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","保存成功!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.bpcVSCode.setValue("");
	  	  	obj.bpcVSDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
		//alert("gg")
	  	if(obj.bpcVSCode.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","模式代码不能为空!",function(){obj.bpcVSCode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.bpcVSDesc.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","模式描述不能为空!",function(){obj.bpcVSDesc.focus(true,true);});
	  		return;
	  	};
	  	var Rowid=obj.Rowid.getValue();
        var bpcVSCode=obj.bpcVSCode.getValue();
        var bpcVSDesc=obj.bpcVSDesc.getValue();
		var ret =_DHCBPCVisitStatus.UpdateVStatus(Rowid,bpcVSCode,bpcVSDesc);
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.bpcVSCode.setValue("");
	  	  	obj.bpcVSDesc.setValue("");
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
	  	var ret=_DHCBPCVisitStatus.DeleteVStatus(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.bpcVSCode.setValue("");
	  	  	obj.bpcVSDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}

