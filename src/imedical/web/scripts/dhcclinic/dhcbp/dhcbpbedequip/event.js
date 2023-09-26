function InitViewScreenEvent(obj)
{
	//obj.intCurrRowIndex = -1;
	var _DHCBPBedEquip=ExtTool.StaticServerObject('web.DHCBPBedEquip');
	var selectBedDr=""
	var selectEquipDr=""
	obj.LoadEvent = function(args)
	{
	};
	var SelectedRowID = 0;
	var preRowID=0;	
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){ 
	  	SelectedRowID=rc.get("tBPBERowId")
	  	if(preRowID!=SelectedRowID){
		  	selectBedDr=rc.get("tBPBEBedDr");
		  	selectEquipDr=rc.get("tBPBEBPCEquipDr");
		    obj.RowId.setValue(rc.get("tBPBERowId"));
		    obj.bpbeBedDr.setValue(rc.get("tBPBEBedDr"));
		    obj.bpbeBPCEquipDr.setValue(rc.get("tBPBEBPCEquipDr"));
		    obj.bpbeTcpipAddress.setValue(rc.get("tBPBETcpipAddress"));
		    obj.bpbePort.setValue(rc.get("tBPBEPort"));
		    obj.bpbeCollectTypeDr.setValue(rc.get("tBPBECollectTypeDr"));
		    obj.bpbeDefaultInterval.setValue(rc.get("tBPBEDefaultInterval"));
		    obj.bpbeEditTcpipAddress.setValue(rc.get("tBPBEEditTcpipAddress"));
		    obj.bpbeIfConnected.setValue(rc.get("tBPBEIfConnectedB"));
		    obj.bpbeBedDr.disable();
		    preRowID=SelectedRowID;
		}else{
		  	selectBedDr="";
		  	selectEquipDr="";
		    obj.RowId.setValue("");
		    obj.bpbeBedDr.setValue("");
		    obj.bpbeBPCEquipDr.setValue("");
		    obj.bpbeTcpipAddress.setValue("");
		    obj.bpbePort.setValue("");
		    obj.bpbeCollectTypeDr.setValue("");
		    obj.bpbeDefaultInterval.setValue("");
		    obj.bpbeEditTcpipAddress.setValue("");
		    obj.bpbeIfConnected.setValue("");
		    obj.bpbeBedDr.enable();
		    SelectedRowID=0;
		    preRowID=0;
		};
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.bpbeBedDr.getValue()=="")
		{
			ExtTool.alert("��ʾ","��λ����Ϊ��!");	
			return;
		}
		var bpbeBedDr=obj.bpbeBedDr.getValue();           
		var bpbeBPCEquipDr=obj.bpbeBPCEquipDr.getValue();  
		
		if(selectBedDr!="" &&(bpbeBedDr!=selectBedDr||bpbeBPCEquipDr!=selectEquipDr))
		{
			ExtTool.alert("��ʾ","���Ƚ����ǰ��!");	
			return;
		}       
		var bpbeTcpipAddress=obj.bpbeTcpipAddress.getValue();       
		var bpbePort=obj.bpbePort.getValue();     
		var bpbeCollectTypeDr=obj.bpbeCollectTypeDr.getValue();         
		var bpbeDefaultInterval=obj.bpbeDefaultInterval.getValue();  
		var bpbeEditTcpipAddress=obj.bpbeEditTcpipAddress.getValue();       
		var bpbeIfConnected=obj.bpbeIfConnected.getValue();          

       //alert(bpbeBedDr+"/"+bpbeBPCEquipDr+"/"+bpbeTcpipAddress+"/"+bpbePort+"/"+bpbeCollectTypeDr+"/"+bpbeDefaultInterval+"/"+bpbeEditTcpipAddress+"/"+bpbeIfConnected)

		var ret=_DHCBPBedEquip.InsertBedEquip(bpbeBedDr,bpbeBPCEquipDr,bpbeTcpipAddress,bpbePort,bpbeCollectTypeDr,bpbeDefaultInterval,bpbeEditTcpipAddress,bpbeIfConnected);
		//alert(ret)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ",ret);
		}
		else 
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�!",function(){
			obj.RowId.setValue("");
	  	  	obj.bpbeBedDr.setValue("");
	  	  	obj.bpbeBPCEquipDr.setValue("");
	  	  	obj.bpbeTcpipAddress.setValue("");
	  	  	obj.bpbePort.setValue("");
	  	  	obj.bpbeCollectTypeDr.setValue(""); 
	  	  	obj.bpbeDefaultInterval.setValue("");
	  	  	obj.bpbeEditTcpipAddress.setValue(""); 
	  	  	obj.bpbeIfConnected.setValue("");
		  	obj.retGridPanelStore.load({});  	
	  	  	});
		}
		obj.bpbeBPCEquipDrstore.reload({});
	};
	
	obj.updatebutton_click = function()
	{
		if(obj.RowId.getValue()=="")
		{
			ExtTool.alert("��ʾ","ID����Ϊ��!");	
			return;
		}
		if(obj.bpbeBedDr.getValue()=="")
		{
			ExtTool.alert("��ʾ","��λ����Ϊ��!");	
			return;
		}
		
		var RowId = obj.RowId.getValue();
		var bpbeBedDr=obj.bpbeBedDr.getValue();           
		var bpbeBPCEquipDr=obj.bpbeBPCEquipDr.getValue();          
		var bpbeTcpipAddress=obj.bpbeTcpipAddress.getValue();       
		var bpbePort=obj.bpbePort.getValue();     
		var bpbeCollectTypeDr=obj.bpbeCollectTypeDr.getValue();         
		var bpbeDefaultInterval=obj.bpbeDefaultInterval.getValue();  
		var bpbeEditTcpipAddress=obj.bpbeEditTcpipAddress.getValue();       
		var bpbeIfConnected=obj.bpbeIfConnected.getValue();          
//alert(RowId+"/"+bpbeBedDr+"/"+bpbeBPCEquipDr+"/"+bpbeTcpipAddress+"/"+bpbePort+"/"+bpbeCollectTypeDr+"/"+bpbeDefaultInterval+"/"+bpbeEditTcpipAddress+"/"+bpbeIfConnected)
		var ret=_DHCBPBedEquip.UpdateBedEquip(RowId,bpbeBedDr,bpbeBPCEquipDr,bpbeTcpipAddress,bpbePort,bpbeCollectTypeDr,bpbeDefaultInterval,bpbeEditTcpipAddress,bpbeIfConnected);
		//alert(ret)
		if(ret!=0)
		{
		  Ext.Msg.alert("��ʾ",ret);	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
			obj.RowId.setValue("");
	  	  	obj.bpbeBedDr.setValue("");
	  	  	obj.bpbeBPCEquipDr.setValue("");
	  	  	obj.bpbeTcpipAddress.setValue("");
	  	  	obj.bpbePort.setValue("");
	  	  	obj.bpbeCollectTypeDr.setValue(""); 
	  	  	obj.bpbeDefaultInterval.setValue("");
	  	  	obj.bpbeEditTcpipAddress.setValue(""); 
	  	  	obj.bpbeIfConnected.setValue("");
	  	  	obj.retGridPanelStore.load({});  
	  	  	obj.bpbeBedDr.enable();
		  	});
	     }
	     obj.bpbeBPCEquipDrstore.reload({});
	 };
	 
	obj.deletebutton_click = function()
	{
	  var ID=obj.RowId.getValue();
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  var equipID=rc.get("tBPBEBPCEquipDr");
	  //alert(equipID)
	  //return
	  if(ID=="")
	  {
	    Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼��");
	    return;
	  }
	  Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCBPBedEquip.DeleteBedEquip(ID,equipID);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
		  	  obj.bpbeBPCEquipDrstore.reload({});
				obj.RowId.setValue("");
	  	  		obj.bpbeBedDr.setValue("");
	  	  		obj.bpbeBPCEquipDr.setValue("");
	  	  		obj.bpbeTcpipAddress.setValue("");
	  	  		obj.bpbePort.setValue("");
	  	  		obj.bpbeCollectTypeDr.setValue(""); 
	  	  		obj.bpbeDefaultInterval.setValue("");
	  	  		obj.bpbeEditTcpipAddress.setValue(""); 
	  	  		obj.bpbeIfConnected.setValue("");
	  	  		obj.retGridPanelStore.load({});  
	  	  		obj.bpbeBedDr.enable();
	  	  	
		  	});
	  	}
	  );
	};

}