function InitViewScreenEvent(obj)
{
	//obj.intCurrRowIndex = -1;
	var _DHCBPCEquipModel=ExtTool.StaticServerObject('web.DHCBPCEquipModel');
	
	obj.LoadEvent = function(args)
	{
	};
	
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){ 
	    obj.RowId.setValue(rc.get("tID"));
	    obj.bpcEMCode.setValue(rc.get("tBPCEMCode"));
	    obj.bpcEMDesc.setValue(rc.get("tBPCEMDesc"));
	    obj.bpcEMAbbreviation.setValue(rc.get("tBPCEMAbbreviation"));
	    obj.bpcEMManufacturer.setValue(rc.get("tBPCEMManufacturerDr"));
	    obj.bpcEMAgent.setValue(rc.get("tBPCEMAgent"));
	    obj.bpcEMType.setValue(rc.get("tBPCEMType"));
	    obj.bpcEMNote.setValue(rc.get("tBPCEMNote"));
	    obj.bpcEMCanFilter.setValue(rc.get("tBPCEMCanFilterB"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.bpcEMCode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.bpcEMDesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		//var RowId = obj.RowId.getValue();
		var bpcEMCode=obj.bpcEMCode.getValue();           
		var bpcEMDesc=obj.bpcEMDesc.getValue();          
		var bpcEMAbbreviation=obj.bpcEMAbbreviation.getValue();       
		var bpcEMManufacturer=obj.bpcEMManufacturer.getValue();     
		var bpcEMAgent=obj.bpcEMAgent.getValue();         
		var bpcEMType=obj.bpcEMType.getValue();  
		var bpcEMNote=obj.bpcEMNote.getValue();       
		var bpcEMCanFilter=obj.bpcEMCanFilter.getValue();          

       
		var ret=_DHCBPCEquipModel.InsertEModel(bpcEMCode,bpcEMDesc,bpcEMAbbreviation,bpcEMManufacturer,bpcEMAgent,bpcEMType,bpcEMNote,bpcEMCanFilter);
		//alert(ret)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
			obj.RowId.setValue("");
	  	  	obj.bpcEMCode.setValue("");
	  	  	obj.bpcEMDesc.setValue("");
	  	  	obj.bpcEMAbbreviation.setValue("");
	  	  	obj.bpcEMManufacturer.setValue("");
	  	  	obj.bpcEMAgent.setValue(""); 
	  	  	obj.bpcEMType.setValue(""); 
	  	  	obj.bpcEMNote.setValue("");
	  	  	obj.bpcEMCanFilter.setValue("");	 
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
		if(obj.bpcEMCode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.bpcEMDesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
	
        var RowId = obj.RowId.getValue();
		var bpcEMCode=obj.bpcEMCode.getValue();           
		var bpcEMDesc=obj.bpcEMDesc.getValue();          
		var bpcEMAbbreviation=obj.bpcEMAbbreviation.getValue();       
		var bpcEMManufacturer=obj.bpcEMManufacturer.getValue();  
		//alert(bpcEMManufacturer)   
		var bpcEMAgent=obj.bpcEMAgent.getValue();         
		var bpcEMType=obj.bpcEMType.getValue();  
		var bpcEMNote=obj.bpcEMNote.getValue();       
		var bpcEMCanFilter=obj.bpcEMCanFilter.getValue();  

        
		var ret=_DHCBPCEquipModel.UpdateEModel(RowId,bpcEMCode,bpcEMDesc,bpcEMAbbreviation,bpcEMManufacturer,bpcEMAgent,bpcEMType,bpcEMNote,bpcEMCanFilter);
		//alert(ret)
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
			obj.RowId.setValue("");
	  	  	obj.bpcEMCode.setValue("");
	  	  	obj.bpcEMDesc.setValue("");
	  	  	obj.bpcEMAbbreviation.setValue("");
	  	  	obj.bpcEMManufacturer.setValue("");
	  	  	obj.bpcEMAgent.setValue(""); 
	  	  	obj.bpcEMType.setValue(""); 
	  	  	obj.bpcEMNote.setValue("");
	  	  	obj.bpcEMCanFilter.setValue("");  
	  	  	obj.retGridPanelStore.load({});  
		  	});
	     }
	 };
	 
	obj.deletebutton_click = function()
	{
	  var ID=obj.RowId.getValue();
	  if(ID=="")
	  {
	    Ext.Msg.alert("提示","请选择一条要删除的记录！");
	    return;
	  }
	  Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCBPCEquipModel.DeleteEModel(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
			obj.RowId.setValue("");
	  	  	obj.bpcEMCode.setValue("");
	  	  	obj.bpcEMDesc.setValue("");
	  	  	obj.bpcEMAbbreviation.setValue("");
	  	  	obj.bpcEMManufacturer.setValue("");
	  	  	obj.bpcEMAgent.setValue(""); 
	  	  	obj.bpcEMType.setValue(""); 
	  	  	obj.bpcEMNote.setValue("");
	  	  	obj.bpcEMCanFilter.setValue("");  
	  	  	obj.retGridPanelStore.load({});  
		  	});

	  	}
	  );
	};

}