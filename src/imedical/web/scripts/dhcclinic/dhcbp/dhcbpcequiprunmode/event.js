function InitViewScreenEvent(obj)
{
	var _DHCBPCEquipRunMode=ExtTool.StaticServerObject('web.DHCBPCEquipRunMode');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		  
	    obj.bpcERMCode.setValue(rc.get("tBPCERMCode"));
	    obj.bpcERMDesc.setValue(rc.get("tBPCERMDesc"));
	    obj.Rowid.setValue(rc.get("tBPCERMRowId"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.floorno.getValue());
		if(obj.bpcERMCode.getValue()=="")
		{
			ExtTool.alert("提示","模式代码不能为空!");	
			return;
		}
		if(obj.bpcERMDesc.getValue()=="")
		{
			ExtTool.alert("提示","模式描述不能为空!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var bpcERMCode=obj.bpcERMCode.getValue();
		var bpcERMDesc=obj.bpcERMDesc.getValue();

		var ret=_DHCBPCEquipRunMode.InsertERunMode(bpcERMCode,bpcERMDesc);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","保存失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","保存成功!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.bpcERMCode.setValue("");
	  	  	obj.bpcERMDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
		//alert("gg")
	  	if(obj.bpcERMCode.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","模式代码不能为空!",function(){obj.bpcERMCode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.bpcERMDesc.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","模式描述不能为空!",function(){obj.bpcERMDesc.focus(true,true);});
	  		return;
	  	};
	  	var Rowid=obj.Rowid.getValue();
        var bpcERMCode=obj.bpcERMCode.getValue();
        var bpcERMDesc=obj.bpcERMDesc.getValue();
		var ret =_DHCBPCEquipRunMode.UpdateERunMode(Rowid,bpcERMCode,bpcERMDesc);
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.bpcERMCode.setValue("");
	  	  	obj.bpcERMDesc.setValue("");
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
	  	var ret=_DHCBPCEquipRunMode.DeleteERunMode(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.bpcERMCode.setValue("");
	  	  	obj.bpcERMDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}

