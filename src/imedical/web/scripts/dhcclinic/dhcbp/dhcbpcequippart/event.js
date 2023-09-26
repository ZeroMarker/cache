function InitViewScreenEvent(obj)
{
	obj.intCurrRowIndex = -1;
	var _DHCBPCEquipPart=ExtTool.StaticServerObject('web.DHCBPCEquipPart');
	
	obj.LoadEvent = function(args)
	{
	};
	
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){ 
	    obj.RowId.setValue(rc.get("tBPCEPRowId"));
	    obj.bpcEPCode.setValue(rc.get("tBPCEPCode"));
	    obj.bpcEPDesc.setValue(rc.get("tBPCEPDesc"));
	    obj.bpcEPModelDr.setValue(rc.get("tBPCEPBPCEquipModelDr"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.bpcEPCode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.bpcEPDesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		if(obj.bpcEPModelDr.getValue()=="")
		{
			ExtTool.alert("提示","设备型号不能为空!");	
			return;
		}		
		//var RowId = obj.RowId.getValue();
		var bpcEPCode=obj.bpcEPCode.getValue();           
		var bpcEPDesc=obj.bpcEPDesc.getValue();           
		var bpcEPModelDr=obj.bpcEPModelDr.getValue();         

		var ret=_DHCBPCEquipPart.InsertEPart(bpcEPModelDr,bpcEPCode,bpcEPDesc);
		//alert(ret)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
			obj.RowId.setValue("");
	  	  	obj.bpcEPCode.setValue("");
	  	  	obj.bpcEPDesc.setValue("");
	  	  	obj.bpcEPModelDr.setValue(""); 
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
		if(obj.bpcEPCode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.bpcEPDesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		if(obj.bpcEPModelDr.getValue()=="")
		{
			ExtTool.alert("提示","设备型号不能为空!");	
			return;
		}
		var RowId = obj.RowId.getValue();
		var bpcEPCode=obj.bpcEPCode.getValue();           
		var bpcEPDesc=obj.bpcEPDesc.getValue();           
		var bpcEPModelDr=obj.bpcEPModelDr.getValue();
	
		var ret=_DHCBPCEquipPart.UpdateEPart(RowId,bpcEPModelDr,bpcEPCode,bpcEPDesc);
		//alert(ret)
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
			obj.RowId.setValue("");
	  	  	obj.bpcEPCode.setValue("");
	  	  	obj.bpcEPDesc.setValue("");
	  	  	obj.bpcEPModelDr.setValue("");	  
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
	  	var ret=_DHCBPCEquipPart.DeleteEPart(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
			obj.RowId.setValue("");
	  	  	obj.bpcEPCode.setValue("");
	  	  	obj.bpcEPDesc.setValue("");
	  	  	obj.bpcEPModelDr.setValue("");		  
	  	  	obj.retGridPanelStore.load({});  
		  	});

	  	}
	  );
	};
	
	obj.findbutton_click = function(){
		obj.retGridPanelStore.load({});
			obj.RowId.setValue("");
	  	  	obj.bpcEPCode.setValue("");
	  	  	obj.bpcEPDesc.setValue("");
	  	  	obj.bpcEPModelDr.setValue("");	 
		obj.intCurrRowIndex = -1;
	};
}