function InitViewScreenEvent(obj)
{
	obj.intCurrRowIndex = -1;
	var _DHCBPCNurseGroup=ExtTool.StaticServerObject('web.DHCBPCNurseGroup');
	
	obj.LoadEvent = function(args)
	{
	};
	
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){ 
	    obj.RowId.setValue(rc.get("rowId"));
	    obj.bpcNGCode.setValue(rc.get("Code"));
	    obj.bpcNGDesc.setValue(rc.get("Desc"));
	    obj.bpcNGWardDr.setValue(rc.get("WardId"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.bpcNGCode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.bpcNGDesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		if(obj.bpcNGWardDr.getValue()=="")
		{
			ExtTool.alert("提示","病区不能为空!");	
			return;
		}		
		//var RowId = obj.RowId.getValue();
		var bpcNGCode=obj.bpcNGCode.getValue();           
		var bpcNGDesc=obj.bpcNGDesc.getValue();           
		var bpcNGWardDr=obj.bpcNGWardDr.getValue();  
		var bpcNGString=bpcNGCode+"^"+bpcNGDesc+"^"+bpcNGWardDr       
        //alert(bpcNGString)
		var ret=_DHCBPCNurseGroup.AddNurseGroup(bpcNGString);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
			obj.RowId.setValue("");
	  	  	obj.bpcNGCode.setValue("");
	  	  	obj.bpcNGDesc.setValue("");
	  	  	obj.bpcNGWardDr.setValue(""); 
	  	  	obj.retGridPanelStore.load({});  	
	  	  	});
		}
	};
	
	obj.updatebutton_click = function()
	{
		//alert(obj.RowId.getValue())
		if(obj.RowId.getValue()=="")
		{
			ExtTool.alert("提示","记录ID不能为空!");	
			return;
		}
		if(obj.bpcNGCode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.bpcNGDesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		if(obj.bpcNGWardDr.getValue()=="")
		{
			ExtTool.alert("提示","病区不能为空!");	
			return;
		}		
		var RowId = obj.RowId.getValue();
		var bpcNGCode=obj.bpcNGCode.getValue();           
		var bpcNGDesc=obj.bpcNGDesc.getValue();           
		var bpcNGWardDr=obj.bpcNGWardDr.getValue();  
		var bpcNGString=bpcNGCode+"^"+bpcNGDesc+"^"+bpcNGWardDr;       
        
	   
		var ret=_DHCBPCNurseGroup.UpdateNurseGroup(RowId,bpcNGString);
		//alert(ret)
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
			obj.RowId.setValue("");
	  	  	obj.bpcNGCode.setValue("");
	  	  	obj.bpcNGDesc.setValue("");
	  	  	obj.bpcNGWardDr.setValue(""); 	  
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
	  	var ret=_DHCBPCNurseGroup.DeleteNurseGroup(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
			obj.RowId.setValue("");
	  	  	obj.bpcNGCode.setValue("");
	  	  	obj.bpcNGDesc.setValue("");
	  	  	obj.bpcNGWardDr.setValue(""); 	  
	  	  	obj.retGridPanelStore.load({});  
		  	});

	  	}
	  );
	};
	
//	obj.findbutton_click = function(){
//		obj.retGridPanelStore.load({});
//			obj.RowId.setValue("");
//	  	  	obj.bpcEPCode.setValue("");
//	  	  	obj.bpcEPDesc.setValue("");
//	  	  	obj.bpcEPModelDr.setValue("");	 
//		obj.intCurrRowIndex = -1;
//	};
}