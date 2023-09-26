function InitViewScreenEvent(obj)
{
	var _DHCBPCNurse=ExtTool.StaticServerObject('web.DHCBPCNurse');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		///alert(1);
	    obj.BPCNBPCNurseGroupDr.setValue(rc.get("tBPCNBPCNurseGroupDr"));
	    obj.BPCNNurseCTCPDr.setValue(rc.get("tBPCNNurseCTCPDr"));
	    obj.Rowid.setValue(rc.get("tBPCNRowId"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		///alert(obj.BPCBPMCode.getValue());
		if(obj.BPCNBPCNurseGroupDr.getValue()=="")
		{
			ExtTool.alert("提示","护士组不能为空!");	
			return;
		}
		if(obj.BPCNNurseCTCPDr.getValue()=="")
		{
			ExtTool.alert("提示","医护人员不能为空!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var BPCNBPCNurseGroupDr=obj.BPCNBPCNurseGroupDr.getValue();
		var BPCNNurseCTCPDr=obj.BPCNNurseCTCPDr.getValue();

		var ret=_DHCBPCNurse.AddDHCBPCNurse(BPCNBPCNurseGroupDr,BPCNNurseCTCPDr);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","保存失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","保存成功!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.BPCNBPCNurseGroupDr.setValue("");
	  	  	obj.BPCNNurseCTCPDr.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
		//alert("gg")
	  	if(obj.BPCNBPCNurseGroupDr.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","护士组不能为空!",function(){obj.BPCNBPCNurseGroupDr.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.BPCNNurseCTCPDr.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","医护人员不能为空!",function(){obj.BPCNNurseCTCPDr.focus(true,true);});
	  		return;
	  	};
	  	var Rowid=obj.Rowid.getValue();
        var BPCNBPCNurseGroupDr=obj.BPCNBPCNurseGroupDr.getValue();
        var BPCNNurseCTCPDr=obj.BPCNNurseCTCPDr.getValue();
		var ret =_DHCBPCNurse.UpdateDHCBPCNurse(Rowid,BPCNBPCNurseGroupDr,BPCNNurseCTCPDr);
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.BPCNBPCNurseGroupDr.setValue("");
	  	  	obj.BPCNNurseCTCPDr.setValue("");
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
	  	var ret=_DHCBPCNurse.DeleteDHCBPCNurse(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.BPCNBPCNurseGroupDr.setValue("");
	  	  	obj.BPCNNurseCTCPDr.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}

