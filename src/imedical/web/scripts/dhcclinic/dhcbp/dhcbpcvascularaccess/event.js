function InitViewScreenEvent(obj)
{
	var _DHCBPCVascularAccess=ExtTool.StaticServerObject('web.DHCBPCVascularAccess');
	obj.LoadEvent = function(args)
	{
	};
		
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){
		  
	    obj.bpcVACode.setValue(rc.get("tBPCVACode"));
	    obj.bpcVADesc.setValue(rc.get("tBPCVADesc"));
	    obj.Rowid.setValue(rc.get("tBPCVARowId"));
	    obj.ctlocdesc.setRawValue(rc.get("tBPCVADept"))
	    obj.ctlocdesc.setValue(rc.get("tBPCVADeptDr"))
	  }
	};
	
	obj.addbutton_click = function()
	{
		//alert(obj.floorno.getValue());
		if(obj.bpcVACode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.bpcVADesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		if(obj.ctlocdesc.getValue()=="")
		{
			ExtTool.alert("提示","科室不能为空!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var bpcVACode=obj.bpcVACode.getValue();
		var bpcVADesc=obj.bpcVADesc.getValue();
		var ctloc=obj.ctlocdesc.getValue();
		
		var ret=_DHCBPCVascularAccess.InsertVasAccess(bpcVACode,bpcVADesc,ctloc);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","保存失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","保存成功!",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.bpcVACode.setValue("");
	  	  	obj.bpcVADesc.setValue("");
	  	  	obj.ctlocdesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};

	obj.updatebutton_click = function()
	{
		//alert("gg")
	  	if(obj.bpcVACode.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","代码不能为空!",function(){obj.bpcVACode.focus(true,true);});
	  		return;
	  	} ;
	  	if(obj.bpcVADesc.getValue()=="")
	  	{
	  		Ext.Msg.alert("提示","描述不能为空!",function(){obj.bpcVADesc.focus(true,true);});
	  		return;
	  	};
	  	if(obj.ctlocdesc.getValue()=="")
		{
			ExtTool.alert("提示","科室不能为空!",function(){obj.ctlocdesc.focus(true,true);});	
			return;
		}
	  	var Rowid=obj.Rowid.getValue();
        var bpcVACode=obj.bpcVACode.getValue();
        var bpcVADesc=obj.bpcVADesc.getValue();
        var ctloc=obj.ctlocdesc.getValue();
		var ret =_DHCBPCVascularAccess.UpdateVasAccess(Rowid,bpcVACode,bpcVADesc,ctloc);
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.bpcVACode.setValue("");
	  	  	obj.bpcVADesc.setValue("");
	  	  	obj.ctlocdesc.setValue("");
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
	  	var ret=_DHCBPCVascularAccess.DeleteVasAccess(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.Rowid.setValue("");
	  	  	obj.bpcVACode.setValue("");
	  	  	obj.bpcVADesc.setValue("");
	  	  	obj.ctlocdesc.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});

	  	}
	  );
	};
	
}


