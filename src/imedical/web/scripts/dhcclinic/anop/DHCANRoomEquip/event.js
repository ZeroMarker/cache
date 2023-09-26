function InitViewScreenEvent(obj)
{
    var _DHCANRoomEquip=ExtTool.StaticServerObject('web.DHCANRoomEquip');
	var _DHCANCCollectType=ExtTool.StaticServerObject('web.DHCANCCollectType');
	obj.LoadEvent = function(args)
	{
		obj.TRowid.setValue("");
	};
	obj.retGridPanel_rowclick=function()
	{
	    var rc = obj.retGridPanel.getSelectionModel().getSelected();
		if (rc)
		{
			obj.TRowid.setValue(rc.get("TRowid"));
			obj.TRoom.setRawValue(rc.get("TRoom"));
			obj.TRoom.setValue(rc.get("TRoomRowid"));
			obj.TInterfaceProgram.setValue(rc.get("TInterfaceProgramRowid"));
			obj.TInterfaceProgram.setRawValue(rc.get("TInterfaceProgram"));
			obj.TTcpipAddress.setValue(rc.get("TTcpipAddress"));
			obj.TDefaultInterval.setValue(rc.get("TDefaultInterval"));
			obj.TUserIPAddress.setValue(rc.get("TUserIPAddress"));
			obj.TEquipRowid.setValue(rc.get("TEquipRowid"));
			obj.TPort.setRawValue(rc.get("TPort"));	
		}
		obj.tCode.setValue();
	    obj.tANCCTActive.setRawValue();
		obj.tANCCTIChannelNo.setValue();
        obj.tANCCTIComOrd.setRawValue();
	    obj.tANCCTIComOrd.setValue();
		obj.retGridPanelItemStore.load({});
	}
	
	obj.addbutton1_click=function()
	{
	    var RoomRowid = obj.TRoom.getValue(); 
		if(RoomRowid=="")
		{
			alert("��ѡ��������");
			return;
		}
		var EquipRowid = obj.TEquipRowid.getValue();
		var TcpipAddress = obj.TTcpipAddress.getValue();
		var Port = obj.TPort.getRawValue();
		var InterfaceProgram = obj.TInterfaceProgram.getValue();	//�ɼ�����
		if(InterfaceProgram=="")
		{
			alert("��ѡ��ɼ�����");
			return;
		}
		var DefaultInterval = obj.TDefaultInterval.getValue();
		var UserIPAdress = obj.TUserIPAddress.getValue();
		//alert(RoomRowid+","+EquipRowid+","+TcpipAddress+","+Port+","+InterfaceProgram+","+DefaultInterval+","+UserIPAdress);
		var ret=_DHCANRoomEquip.Insert(RoomRowid,EquipRowid,TcpipAddress,Port,InterfaceProgram,DefaultInterval,UserIPAdress);
		//alert(ret);
		if(ret==0)
	   {
	        Ext.Msg.alert("��ʾ","���ӳɹ�!",function(){
			obj.TRowid.setRawValue("");
			obj.TInterfaceProgram.setValue("");
			obj.TInterfaceProgram.setRawValue("");
			obj.TTcpipAddress.setValue("");
			obj.TRoom.setRawValue("");
			obj.TRoom.setValue("");
			obj.TDefaultInterval.setValue("");
			obj.TUserIPAddress.setValue("");
			obj.TPort.setRawValue("");
			obj.TEquipRowid.setValue("");
	  	  	obj.retGridPanelStore.load({});  	
	  	  	});
	   }
	   else
	   {
	        Ext.Msg.alert("��ʾ","����ʧ�ܣ�");
	   }
	}
	
	obj.updatebutton1_click=function()
	{
	    var TRowid = obj.TRowid.getValue();
	    if(TRowid=="")
	    {
		    alert("��ѡ��һ����¼");
		    return;
	    }
	    var RoomRowid = obj.TRoom.getValue(); 
		var EquipRowid = obj.TEquipRowid.getValue();
		var TcpipAddress = obj.TTcpipAddress.getValue();
		var Port = obj.TPort.getRawValue();
		var InterfaceProgram = obj.TInterfaceProgram.getValue();
		var DefaultInterval = obj.TDefaultInterval.getValue();
		var UserIPAdress = obj.TUserIPAddress.getValue();
		var ret=_DHCANRoomEquip.updateRoomEquip(TRowid,RoomRowid,EquipRowid,TcpipAddress,Port,InterfaceProgram,DefaultInterval,UserIPAdress);
		if(ret==0)
	   {
	        Ext.Msg.alert("��ʾ","�޸ĳɹ�!",function(){
			obj.TRowid.setRawValue("");
			obj.TInterfaceProgram.setValue("");
			obj.TInterfaceProgram.setRawValue("");
			obj.TTcpipAddress.setValue("");
			obj.TRoom.setRawValue("");
			obj.TRoom.setValue("");
			obj.TDefaultInterval.setValue("");
			obj.TUserIPAddress.setValue("");
			obj.TPort.setRawValue("");
			obj.TEquipRowid.setValue("");
	  	  	obj.retGridPanelStore.load({});  	
	  	  	});
	   }
	   else
	   {
	        Ext.Msg.alert("��ʾ","�޸�ʧ�ܣ�");
	   }
	}
	
	obj.deletebutton1_click=function()
	{
	    var TRowid = obj.TRowid.getValue();
	    if(TRowid=="")
	    {
		    alert("��ѡ��һ����¼");
		    return;
	    }
		if(TRowid=="")
		{
			Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼!");
			return;
		}
		
		Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  		if(btn=="no")return;
	  		var ret=_DHCANRoomEquip.DeleteRoomEquip(TRowid);
	  		if(ret!="0")
	  	  		Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  		else
	  	 	 Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
			    obj.TRowid.setRawValue("");
			    obj.TInterfaceProgram.setValue("");
			    obj.TInterfaceProgram.setRawValue("");
			    obj.TTcpipAddress.setValue("");
			    obj.TRoom.setRawValue("");
			    obj.TRoom.setValue("");
			    obj.TDefaultInterval.setValue("");
			    obj.TUserIPAddress.setValue("");
			    obj.TPort.setRawValue("");
			    obj.TEquipRowid.setValue("");
	  	  	    obj.retGridPanelStore.load({});  	
	  	  	});
		}); 
	}
	
	obj.findbutton_click=function()
	{
	    obj.retGridPanelStore.load({});
		obj.retGridPanelItemStore.load({});
	}
	
	obj.retGridPanelItem_rowclick=function()
	{
	    var rc = obj.retGridPanelItem.getSelectionModel().getSelected();
		if (rc)
        {
		    obj.tCode.setValue(rc.get("tCode"));
			obj.tANCCTActive.setRawValue(rc.get("tANCCTIActive"));
			obj.tANCCTIChannelNo.setValue(rc.get("tANCCTIChannelNo"));
			obj.tANCCTIComOrd.setRawValue(rc.get("tANCCTIComOrdDrDesc"));
			pbj.tANCCTIComOrd.setValue(rc.get("tANCCTIComOrdDr"));
            obj.RowId.setValue(rc.get("trowid"));			
        }		
  	}
	obj.addbutton_click=function()
	{
	    var code=obj.tCode.getValue();
		var ANCCTActive=(obj.tANCCTActive.getValue()=="1")?"Y":"N";
		var ANCCTIComOrdDr=obj.tANCCTIComOrd.getValue();
		//
		var ANCCTIComOrd=obj.tANCCTIComOrd.getRawValue();
		var checkFlag=_DHCANRoomEquip.CheckValidRecordData(ANCCTIComOrd,ANCCTIComOrdDr)
		 if(checkFlag==0)
	  {
		alert("��������˵���ѡ��໤��Ŀ")
		obj.tANCCTIComOrd.setValue("");
	   return;  
	  }
	//
		var ANCCTIParref=obj.TInterfaceProgram.getValue();
		var ANCCTIChannelNo=obj.tANCCTIChannelNo.getValue();
		if(ANCCTActive==''||code=='')
		{
		    Ext.Msg.alert("��ʾ","���룬����״̬������Ϊ��!");
		    return ;
		}
		var ret=_DHCANCCollectType.InsertDHCANCCollectTypeitem(code,ANCCTIChannelNo,ANCCTActive,ANCCTIParref,ANCCTIComOrdDr);
		//alert(ret)
		if(ret==0)
	   {
	        Ext.Msg.alert("��ʾ","���ӳɹ�!",function(){
			obj.tCode.setValue();
			obj.tANCCTActive.setRawValue();
			obj.tANCCTIChannelNo.setValue();
            obj.tANCCTIComOrd.setRawValue();
			obj.tANCCTIComOrd.setValue();	
            obj.retGridPanelItemStore.load({});			
	  	  	});
	   }
	   else
	   {
	        Ext.Msg.alert("��ʾ","����ʧ�ܣ�");
	   }
		
		//alert(ANCCTActive);	
	}
	obj.updatebutton_click=function()
	{
	    var rc = obj.retGridPanelItem.getSelectionModel().getSelected();
	    var rowid=rc.get("trowid");
		var code=obj.tCode.getValue();
		var ANCCTActive=(obj.tANCCTActive.getValue()=="1")?"Y":"N";
		var ANCCTIComOrdDr=obj.tANCCTIComOrd.getValue();
		//
		var ANCCTIComOrd=obj.tANCCTIComOrd.getRawValue();
		var checkFlag=_DHCANRoomEquip.CheckValidRecordData(ANCCTIComOrd,ANCCTIComOrdDr)
		 if(checkFlag==0)
	  {
		alert("��������˵���ѡ��໤��Ŀ")
		obj.tANCCTIComOrd.setValue("");
	   return;  
	  }
	  //
		var ANCCTIParref=obj.TInterfaceProgram.getValue();
		var ANCCTIChannelNo=obj.tANCCTIChannelNo.getValue();
		if(ANCCTActive==''||code=='')
		{
		    Ext.Msg.alert("��ʾ","���룬����״̬������Ϊ��!");
		    return ;
		}
		var ret=_DHCANCCollectType.UPDATEDHCANCCollectTypeitem(rowid,code,ANCCTIChannelNo,ANCCTActive,ANCCTIParref,ANCCTIComOrdDr);
		if(ret==0)
	   {
	        Ext.Msg.alert("��ʾ","�޸ĳɹ�!",function(){
			obj.tCode.setValue();
			obj.tANCCTActive.setRawValue();
			obj.tANCCTIChannelNo.setValue();
            obj.tANCCTIComOrd.setRawValue();
			obj.tANCCTIComOrd.setValue();	
            obj.retGridPanelItemStore.load({});			
	  	  	});
	   }
	   else
	   {
	        Ext.Msg.alert("��ʾ","�޸�ʧ�ܣ�");
	   }
		//alert(rowid);
	}
	obj.deletebutton_click=function()
	{
	    var rc=obj.retGridPanelItem.getSelectionModel().getSelected();
		var TRowid = rc.get("trowid");
		//alert(TRowid);
		if(TRowid=="")
		{
			Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼!");
			return;
		}
		
		Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  		if(btn=="no")return;
	  		var ret=_DHCANCCollectType.DeleteDHCANCCollectTypeitem(TRowid);
	  		if(ret!="0")
	  	  		Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  		else
			    Ext.Msg.alert("��ʾ","ɾ���ɹ�!",function(){
			    obj.tCode.setValue();
			    obj.tANCCTActive.setRawValue();
			    obj.tANCCTIChannelNo.setValue();
                obj.tANCCTIComOrd.setRawValue();
			    obj.tANCCTIComOrd.setValue();	
                obj.retGridPanelItemStore.load({});			
	  	  	  });
		});
		}
}