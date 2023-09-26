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
			ExtTool.alert("��ʾ","���벻��Ϊ��!");	
			return;
		}
		if(obj.bpcCDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","��������Ϊ��!");	
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
		     Ext.Msg.alert("��ʾ","���ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�!",function(){
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
			ExtTool.alert("��ʾ","ID����Ϊ��!");	
			return;
		}		
		if(obj.bpcCCode.getValue()=="")
		{
			ExtTool.alert("��ʾ","���벻��Ϊ��!");	
			return;
		}
		if(obj.bpcCDesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","��������Ϊ��!");	
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
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
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
	    Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼��");
	    return;
	  }
	  Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCBPCConsumable.DeleteConsumable(ID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
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