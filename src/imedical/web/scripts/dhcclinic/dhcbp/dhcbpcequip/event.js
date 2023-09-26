function InitViewScreenEvent(obj)
{
	obj.intCurrRowIndex = -1;
	var _DHCBPCEquip=ExtTool.StaticServerObject('web.DHCBPCEquip');
	
	obj.LoadEvent = function(args)
	{
	};
	
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){ 
	    obj.RowId.setValue(rc.get("tBPCERowId"));
	    //alert(rc.get("tIcucioiId"))
	    obj.bpcECode.setValue(rc.get("tBPCECode"));
	    obj.bpcEDesc.setValue(rc.get("tBPCEDesc"));
	    obj.bpcENo.setValue(rc.get("tBPCENo"));
	    obj.bpcEFromDate.setValue(rc.get("tBPCEFromDate"));
	    obj.bpcEToDate.setValue(rc.get("tBPCEToDate"));
	    obj.bpcEStatus.setValue(rc.get("tBPCEStatus"));
	    obj.bpcENote.setValue(rc.get("tBPCENote"));
	    obj.bpcEModelDr.setValue(rc.get("tBPCEBPCEquipModelDr"));
	    obj.bpcESoftwareVersion.setValue(rc.get("tBPCESoftwareVersion"));
	    obj.bpcEPart.setValue(rc.get("tBPCEPart"));
	    obj.bpcEInstallDate.setValue(rc.get("tBPCEInstallDate"));
	    obj.bpcETotalWorkingHour.setValue(rc.get("tBPCETotalWorkingHour"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.bpcECode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.bpcEDesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		if(obj.bpcEModelDr.getValue()=="")
		{
			ExtTool.alert("提示","设备不能为空!");	
			return;
		}		
		//var RowId = obj.RowId.getValue();
		var bpcECode=obj.bpcECode.getValue();   
		var bpcEDesc=obj.bpcEDesc.getValue();          
		var bpcENo=obj.bpcENo.getValue();        
		var bpcEFromDate=obj.bpcEFromDate.getRawValue();     
		var bpcEToDate=obj.bpcEToDate.getRawValue();       
		var bpcEStatus=obj.bpcEStatus.getValue();   
		var bpcENote=obj.bpcENote.getValue();      
		var bpcEModelDr=obj.bpcEModelDr.getValue();  
		var bpcESoftwareVersion=obj.bpcESoftwareVersion.getValue();
		var bpcEPart=obj.bpcEPart.getValue();
		var bpcEInstallDate=obj.bpcEInstallDate.getRawValue();
		var bpcETotalWorkingHour=obj.bpcETotalWorkingHour.getValue();
		      

		var ret=_DHCBPCEquip.InsertEquip(bpcECode,bpcEDesc,bpcENo,bpcEFromDate,bpcEToDate,bpcEStatus,bpcENote,bpcEModelDr,bpcESoftwareVersion,bpcEPart,bpcEInstallDate,bpcETotalWorkingHour);
		//alert(ret)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
			obj.RowId.setValue("");
	  	  	obj.bpcECode.setValue("");
	  	  	obj.bpcEDesc.setValue("");
	  	  	obj.bpcENo.setValue("");
	  	  	obj.bpcEFromDate.setValue("");
	  	  	obj.bpcEToDate.setValue(""); 
	  	  	obj.bpcEStatus.setValue(""); 
	  	  	obj.bpcENote.setValue("");
	  	  	obj.bpcEModelDr.setValue("");	
	  	  	obj.bpcESoftwareVersion.setValue("");
	  	  	obj.bpcEPart.setValue("");
	  	  	obj.bpcEInstallDate.setValue("");
	  	  	obj.bpcETotalWorkingHour.setValue(""); 
	  	  	obj.retGridPanelStore.load({});  	
	  	  	});
		}
	};
	
	obj.updatebutton_click = function()
	{
		if(obj.RowId.getValue()=="")
		{
			ExtTool.alert("提示","记录ID不能为空!");	
			return;
		}
		if(obj.bpcECode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.bpcEDesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		if(obj.bpcEModelDr.getValue()=="")
		{
			ExtTool.alert("提示","设备不能为空!");	
			return;
		}		
        var RowId = obj.RowId.getValue();
		var bpcECode=obj.bpcECode.getValue();           
		var bpcEDesc=obj.bpcEDesc.getValue();           
		var bpcENo=obj.bpcENo.getValue();        
		var bpcEFromDate=obj.bpcEFromDate.getRawValue();     
		var bpcEToDate=obj.bpcEToDate.getRawValue();        
		var bpcEStatus=obj.bpcEStatus.getValue();   
		var bpcENote=obj.bpcENote.getValue();       
		var bpcEModelDr=obj.bpcEModelDr.getValue();        
		var bpcESoftwareVersion=obj.bpcESoftwareVersion.getValue();
		var bpcEPart=obj.bpcEPart.getValue();
		var bpcEInstallDate=obj.bpcEInstallDate.getRawValue();
		var bpcETotalWorkingHour=obj.bpcETotalWorkingHour.getValue();
		
		var ret=_DHCBPCEquip.UpdateEquip(RowId,bpcECode,bpcEDesc,bpcENo,bpcEFromDate,bpcEToDate,bpcEStatus,bpcENote,bpcEModelDr,bpcESoftwareVersion,bpcEPart,bpcEInstallDate,bpcETotalWorkingHour);
		//alert(ret)
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
			obj.RowId.setValue("");
	  	  	obj.bpcECode.setValue("");
	  	  	obj.bpcEDesc.setValue("");
	  	  	obj.bpcENo.setValue("");
	  	  	obj.bpcEFromDate.setValue("");
	  	  	obj.bpcEToDate.setValue(""); 
	  	  	obj.bpcEStatus.setValue(""); 
	  	  	obj.bpcENote.setValue("");
	  	  	obj.bpcEModelDr.setValue(""); 
	  	  	obj.bpcESoftwareVersion.setValue("");
	  	  	obj.bpcEPart.setValue("");
	  	  	obj.bpcEInstallDate.setValue("");
	  	  	obj.bpcETotalWorkingHour.setValue("");
	  	  	obj.retGridPanelStore.load({});  
		  	});
	     }
	 };
	 
	obj.deletebutton_click = function()
	{
	  var ID=obj.RowId.getValue();
	  //alert(ID);
	  if(ID=="")
	  {
	    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	    return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCBPCEquip.DeleteEquip(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
			obj.RowId.setValue("");
	  	  	obj.bpcECode.setValue("");
	  	  	obj.bpcEDesc.setValue("");
	  	  	obj.bpcENo.setValue("");
	  	  	obj.bpcEFromDate.setValue("");
	  	  	obj.bpcEToDate.setValue(""); 
	  	  	obj.bpcEStatus.setValue(""); 
	  	  	obj.bpcENote.setValue("");
	  	  	obj.bpcEModelDr.setValue(""); 
	  	  	obj.bpcESoftwareVersion.setValue("");
	  	  	obj.bpcEPart.setValue("");
	  	  	obj.bpcEInstallDate.setValue("");
	  	  	obj.bpcETotalWorkingHour.setValue("");  
	  	  	obj.retGridPanelStore.load({});  
		  	});

	  	}
	  );
	};
	
	obj.findbutton_click = function(){
		obj.retGridPanelStore.load({});
			obj.RowId.setValue("");
	  	  	obj.bpcECode.setValue("");
	  	  	obj.bpcEDesc.setValue("");
	  	  	obj.bpcENo.setValue("");
	  	  	obj.bpcEFromDate.setValue("");
	  	  	obj.bpcEToDate.setValue(""); 
	  	  	obj.bpcEStatus.setValue(""); 
	  	  	obj.bpcENote.setValue("");
	  	  	obj.bpcEModelDr.setValue(""); 
	  	  	obj.bpcESoftwareVersion.setValue("");
	  	  	obj.bpcEPart.setValue("");
	  	  	obj.bpcEInstallDate.setValue("");
	  	  	obj.bpcETotalWorkingHour.setValue("");  
		obj.intCurrRowIndex = -1;
	};
}