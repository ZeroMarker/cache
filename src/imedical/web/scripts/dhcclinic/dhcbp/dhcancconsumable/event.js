function InitViewScreenEvent(obj)
{
	var SelectedRowID = 0;
	var preRowID=0;	 
	var _DHCBPCConsumable=ExtTool.StaticServerObject('web.DHCBPCConsumable');
	
	obj.LoadEvent = function(args)
	{
	};
	
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  SelectedRowID=rc.get("tID");
	  if (rc){ 
	  	if(preRowID!=SelectedRowID){
		    obj.Rowid.setValue(rc.get("tID"));
		    obj.bpcCCode.setValue(rc.get("tBPCCCode"));
		    obj.bpcCDesc.setValue(rc.get("tBPCCDesc"));
		    obj.bpcCType.setValue(rc.get("tBPCCType"));
		    obj.bpcCMembraneArea.setValue(rc.get("tBPCCMembraneArea"));
		    obj.bpcCHighFluxed.setValue(rc.get("tBPCCHighFluxed"));
		    obj.bpcCArcimDr.setValue(rc.get("tBPCCArcimDr"));
		    if(rc.get("tBPCCArcimDr")!="") obj.bpcCArcimDr.setRawValue(rc.get("tBPCCArcimDr")+"||"+rc.get("tBPCCArcim"));
		    var bpcbpMIdList=rc.get("tBPCBPMRowId");
		    var bpcbpMIdListArray=bpcbpMIdList.split(",");
		    var bpcbpMDescList=rc.get("tBPCBPMDesc")
		    var bpcbpMDescListArray=bpcbpMDescList.split(",");
		    var setBPCBPMode="";
			for(var i=0;i<bpcbpMIdListArray.length;i++){
				if(setBPCBPMode==""){
					setBPCBPMode=bpcbpMIdListArray[i]+"!"+bpcbpMDescListArray[i];
				}else{
						setBPCBPMode=setBPCBPMode+","+bpcbpMIdListArray[i]+"!"+bpcbpMDescListArray[i];
				}
			}
		    obj.BPCBPMode.setDefaultValue(setBPCBPMode);
		 	preRowID=SelectedRowID;
		}else{
			obj.bpcCCode.setValue("");
	  	  	obj.bpcCDesc.setValue("");
	  	  	obj.bpcCType.setValue("");
	  	  	obj.bpcCMembraneArea.setValue("");
	  	  	obj.bpcCHighFluxed.setValue("");
	  	  	obj.bpcCArcimDr.setValue("");
	  	  	obj.BPCBPMode.setValue("");
			SelectedRowID = 0;
		    preRowID=0;
		};
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.bpcCCode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.bpcCDesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		
		var bpcCCode=obj.bpcCCode.getValue();           
		var bpcCDesc=obj.bpcCDesc.getValue();           
		var bpcCType=obj.bpcCType.getValue();        
		var bpcCMembraneArea=obj.bpcCMembraneArea.getRawValue();       
		var bpcCHighFluxed=obj.bpcCHighFluxed.getValue();  
		var bpcCArcimDr=obj.bpcCArcimDr.getValue();   
		var bpcMIdList=obj.BPCBPMode.getValue();
		var ret=_DHCBPCConsumable.InsertConsumable(bpcCCode,bpcCDesc,bpcCType,bpcCMembraneArea,bpcCHighFluxed,bpcCArcimDr,bpcMIdList);
		//alert(ret)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!",function(){
	  	  	//obj.Rowid.setValue("");
	  	  	obj.bpcCCode.setValue("");
	  	  	obj.bpcCDesc.setValue("");
	  	  	obj.bpcCType.setValue("");
	  	  	obj.bpcCMembraneArea.setValue("");
	  	  	obj.bpcCHighFluxed.setValue("");
	  	  	obj.bpcCArcimDr.setValue("");
	  	  	obj.BPCBPMode.setValue("");
	  	  	obj.retGridPanelStore.load({});  	  	
	  	  	});
		}
	};
	
	obj.updatebutton_click = function()
	{
		//alert("gg")
		if(obj.Rowid.getValue()=="")
		{
			ExtTool.alert("提示","ID不能为空!");	
			return;
		}		
		if(obj.bpcCCode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");	
			return;
		}
		if(obj.bpcCDesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");	
			return;
		}
		var Rowid=obj.Rowid.getValue();
		var bpcCCode=obj.bpcCCode.getValue();           
		var bpcCDesc=obj.bpcCDesc.getValue();           
		var bpcCType=obj.bpcCType.getValue();        
		var bpcCMembraneArea=obj.bpcCMembraneArea.getRawValue();       
		var bpcCHighFluxed=obj.bpcCHighFluxed.getValue();  
		var bpcCArcimDr=obj.bpcCArcimDr.getValue();   
		var bpcMIdList=obj.BPCBPMode.getValue();
	   
		var ret=_DHCBPCConsumable.UpdateConsumable(Rowid,bpcCCode,bpcCDesc,bpcCType,bpcCMembraneArea,bpcCHighFluxed,bpcCArcimDr,bpcMIdList);
		//alert(ret)
		if(ret<0)
		{
		  Ext.Msg.alert("提示","更新失败！");	
		}
		else
		{
		  Ext.Msg.alert("提示","更新成功！",function(){
	  	  	//obj.Rowid.setValue("");
	  	  	obj.bpcCCode.setValue("");
	  	  	obj.bpcCDesc.setValue("");
	  	  	obj.bpcCType.setValue("");
	  	  	obj.bpcCMembraneArea.setValue("");
	  	  	obj.bpcCHighFluxed.setValue("");
	  	  	obj.bpcCArcimDr.setValue("");
	  	  	obj.BPCBPMode.setValue("");
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
	  	var ret=_DHCBPCConsumable.DeleteConsumable(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("提示","删除失败！");
	  	else
	  	  Ext.Msg.alert("提示","删除成功！",function(){
	  	  	//obj.Rowid.setValue("");
	  	  	obj.bpcCCode.setValue("");
	  	  	obj.bpcCDesc.setValue("");
	  	  	obj.bpcCType.setValue("");
	  	  	obj.bpcCMembraneArea.setValue("");
	  	  	obj.bpcCHighFluxed.setValue("");
	  	  	obj.bpcCArcimDr.setValue("");
	  	  	obj.BPCBPMode.setValue("");
	  	  	obj.retGridPanelStore.load({}); 
		  	});

	  	}
	  );
	};
}