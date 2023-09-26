function InitViewScreenEvent(obj)
{
	var _DHCBPCAnticoagulantMode=ExtTool.StaticServerObject('web.DHCBPCAnticoagulantMode');
	
	obj.LoadEvent = function(args)
	{
	};
	
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){ 
	    //alert(rc.get("tClcmId"))
	    obj.Rowid.setValue(rc.get("tBPCAMRowId"));
	    obj.bpcAMCode.setValue(rc.get("tBPCAMCode"));
	    obj.bpcAMDesc.setValue(rc.get("tBPCAMDesc"));
	    obj.IfSelectDrug.setValue(rc.get("ifSelectDrug"));
	    obj.Active.setValue(rc.get("ifActive"));
	    obj.SubType.setValue(rc.get("tBPCAMSubType"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.bpcAMCode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.bpcAMDesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		
		var bpcAMCode=obj.bpcAMCode.getValue();           
		var bpcAMDesc=obj.bpcAMDesc.getValue();           
		var ifSelectDrug=obj.IfSelectDrug.getValue();        
		var ifActive=obj.Active.getValue();  
		var bpcAMSubType=obj.SubType.getValue();      
		var ret=_DHCBPCAnticoagulantMode.InsertAntMode(bpcAMCode,bpcAMDesc,ifSelectDrug,ifActive,bpcAMSubType);
		//alert(ret)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
	  	  	//obj.Rowid.setValue("");
	  	  	obj.bpcAMCode.setValue("");
	  	  	obj.bpcAMDesc.setValue("");
			obj.IfSelectDrug.setValue("");    
			obj.Active.setValue("");
			obj.SubType.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};
	
	obj.updatebutton_click = function()
	{
		//alert("gg")
		if(obj.Rowid.getValue()=="")
		{
			ExtTool.alert("提示","记录Id为空!");	
			return;
		}
		if(obj.bpcAMCode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.bpcAMDesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		var Rowid=obj.Rowid.getValue(); 
		var bpcAMCode=obj.bpcAMCode.getValue();           
		var bpcAMDesc=obj.bpcAMDesc.getValue();           
		var ifSelectDrug=obj.IfSelectDrug.getValue();        
		var ifActive=obj.Active.getValue(); 
		var bpcAMSubType=obj.SubType.getValue();
		var ret=_DHCBPCAnticoagulantMode.UpdateAntMode(Rowid,bpcAMCode,bpcAMDesc,ifSelectDrug,ifActive,bpcAMSubType);
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	//obj.Rowid.setValue("");
		  	obj.bpcAMCode.setValue("");
	  	  	obj.bpcAMDesc.setValue("");
	  	  	obj.IfSelectDrug.setValue("");    
			obj.Active.setValue("");
			obj.SubType.setValue("");
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
	  	var ret=_DHCBPCAnticoagulantMode.DeleteAntMode(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	obj.Rowid.setValue("");
		  	obj.bpcAMCode.setValue("");
	  	  	obj.bpcAMDesc.setValue("");
	  	  	obj.IfSelectDrug.setValue("");    
			obj.Active.setValue("");
			obj.SubType.setValue("");
	  	  	obj.retGridPanelStore.load({}); 
		  	});

	  	}
	  );
	};
}