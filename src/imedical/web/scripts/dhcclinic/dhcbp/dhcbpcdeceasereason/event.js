function InitViewScreenEvent(obj)
{
	var _DHCBPCDeceaseReason=ExtTool.StaticServerObject('web.DHCBPCDeceaseReason');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		  
	    obj.BPCDRCode.setValue(rc.get("tBPCDRCode"));
	    obj.BPCDRDesc.setValue(rc.get("tBPCDRDesc"));
	    obj.Rowid.setValue(rc.get("tBPCDRRowId"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.floorno.getValue());
		if(obj.BPCDRCode.getValue()=="")
		{
			ExtTool.alert("提示","模式代码不能为空!");	
			return;
		}
		if(obj.BPCDRDesc.getValue()=="")
		{
			ExtTool.alert("提示","模式描述不能为空!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var BPCDRCode=obj.BPCDRCode.getValue();
		var BPCDRDesc=obj.BPCDRDesc.getValue();

		var ret=_DHCBPCDeceaseReason.AddDHCBPCDeceaseReason(BPCDRCode,BPCDRDesc);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","保存失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","保存成功!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.BPCDRCode.setValue("");
	  	  	obj.BPCDRDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
		//alert("gg")
		var Rowid=obj.Rowid.getValue();
		if(Rowid==""||Rowid==null)
		{
			Ext.Msg.alert("提示","请选择要更新的记录！");
	  		return;
		}
	  	if(obj.BPCDRCode.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","模式代码不能为空!",function(){obj.BPCDRCode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.BPCDRDesc.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","模式描述不能为空!",function(){obj.BPCDRDesc.focus(true,true);});
	  		return;
	  	};
	  	
        var BPCDRCode=obj.BPCDRCode.getValue();
        var BPCDRDesc=obj.BPCDRDesc.getValue();
		var ret =_DHCBPCDeceaseReason.UpdateDHCBPCDeceaseReason(Rowid,BPCDRCode,BPCDRDesc);
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.BPCDRCode.setValue("");
	  	  	obj.BPCDRDesc.setValue("");
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
	  	var ret=_DHCBPCDeceaseReason.DeleteDHCBPCDeceaseReason(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.BPCDRCode.setValue("");
	  	  	obj.BPCDRDesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}

