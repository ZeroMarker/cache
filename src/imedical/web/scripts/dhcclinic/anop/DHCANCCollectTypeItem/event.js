function InitViewScreenEvent(obj)
{
    var _DHCICUBedEquip=ExtTool.StaticServerObject('web.DHCICUBedEquip');
	var _DHCANCCollectType=ExtTool.StaticServerObject('web.DHCANCCollectType');
	obj.LoadEvent = function(args)
	{

	};
	obj.retGridPanel_rowclick=function()
    {
	    var rc = obj.retGridPanel.getSelectionModel().getSelected();
		if (rc)
		{
			obj.TRowid.setValue(rc.get("TRowid"));
			obj.TWardDesc.setRawValue(rc.get("TWardDesc"));
			obj.TWardDesc.setValue(rc.get("TWardId"));
			obj.TInterfaceProgram.setValue(rc.get("TInterfaceProgramID"));
			obj.TInterfaceProgram.setRawValue(rc.get("TInterfaceProgram"));
			obj.TTcpipAddress.setValue(rc.get("TTcpipAddress"));
			//obj.TBed.setRawValue(rc.get("TBed"));
			//obj.TBed.setValue(rc.get("TBedRowid"));
			obj.TBed.setValue(rc.get("TBedRowid"));
			obj.TBed.setRawValue(rc.get("TBed"));
			
			obj.TDefaultInterval.setValue(rc.get("TDefaultInterval"));
			obj.TEditTcpipAddress.setValue(rc.get("TEditTcpipAddress"));
			obj.TPort.setRawValue(rc.get("TPort"));
			obj.TEquipRowid.setValue(rc.get("TEquipRowid"));
			
			obj.tANCCTIComOrdStore.load({});
		}
		  var Tstat = rc.get("TStat");
		  //var equipId=rc.get("TRowid");
	      //alert(Tstat);
		if(Tstat=="N")
		{
		    obj.switchbutton.setText('��ʼ');
				
		}
		else
		{
		   obj.switchbutton.setText('ֹͣ');
		}
		obj.retGridPanelItemStore.load({});
	}
	function request(paras){ 
		
        var url = location.href; 
        var paraString = url.substring(url.indexOf("?")+1,url.length).split("&"); 
        var paraObj = {} 
        for (i=0; j=paraString[i]; i++){ 
        paraObj[j.substring(0,j.indexOf("=")).toLowerCase()] = j.substring(j.indexOf("=")+1,j.length); 
        } 
        var returnValue = paraObj[paras.toLowerCase()]; 
        if(typeof(returnValue)=="undefined"){ 
        return ""; 
        }else{ 
        return returnValue; 
        } 
}
	obj.switchbutton_click=function()
			{    
			    var rc = obj.retGridPanel.getSelectionModel().getSelected();
			    var Tstat = rc.get("TStat");
				var icuaId=request("icuaId");
		        var equipId=rc.get("TRowid");
			    //alert(equipId);
				//alert(icuaId);
				if(Tstat=="N")
				{
			        var ret = _DHCICUBedEquip.ModifyStat(equipId,icuaId,"Y");
				    //alert(ret);
				    if(ret)
				    {
				       Ext.Msg.alert("��ʾ","�����ɹ�!",function(){
			           obj.TWardDesc.setRawValue("");
			           obj.TInterfaceProgram.setValue("");
			           obj.TInterfaceProgram.setRawValue("");
			           obj.TTcpipAddress.setValue("");
			           obj.TBed.setRawValue("");
			           obj.TBed.setValue("");
			           obj.TDefaultInterval.setValue("");
			           obj.TEditTcpipAddress.setValue("");
			           obj.TPort.setRawValue("");
			           obj.TEquipRowid.setValue("");
	  	  	           obj.retGridPanelStore.load({});  	
	  	  	          });
				    }
				    else
				    {
				       Ext.Msg.alert("����ʧ��");
				    }
					//obj.retGridPanelStore.load({});
				}
				else
				{
				    var ret = _DHCICUBedEquip.ModifyStat(equipId,icuaId,"N");
					if(ret)
				    {
				       Ext.Msg.alert("��ʾ","ֹͣ�ɹ�!",function(){
			           obj.TWardDesc.setRawValue("");
			           obj.TInterfaceProgram.setValue("");
			           obj.TInterfaceProgram.setRawValue("");
			           obj.TTcpipAddress.setValue("");
			           obj.TBed.setRawValue("");
			           obj.TBed.setValue("");
			           obj.TDefaultInterval.setValue("");
			           obj.TEditTcpipAddress.setValue("");
			           obj.TPort.setRawValue("");
			           obj.TEquipRowid.setValue("");
	  	  	           obj.retGridPanelStore.load({});  	
	  	  	          });
				    }
				    else
				    {
				       Ext.Msg.alert("ֹͣʧ��");
				    }
					//obj.retGridPanelStore.load({});
				}
			}
			
    obj.addbutton1_click=function()
	{
	   //alert(obj.TWardDesc.getValue());
	   var BedRowid=obj.TBed.getValue();
	   alert(BedRowid);
	   var EquipRowid=obj.TEquipRowid.getValue();
	   var TcpipAddress=obj.TTcpipAddress.getValue();
	   var Port=obj.TPort.getRawValue();
	   var InterfaceProgram=obj.TInterfaceProgram.getValue();
	   var DefaultInterval=obj.TDefaultInterval.getValue();
	   var EditTcpipAddress=obj.TEditTcpipAddress.getValue();
	   alert(BedRowid+"^"+EquipRowid+"^"+TcpipAddress+"^"+Port+"^"+InterfaceProgram+"^"+DefaultInterval+"^"+EditTcpipAddress);
	   //return;
	   var ret=_DHCICUBedEquip.InsertBedEquip(BedRowid,EquipRowid,TcpipAddress,Port,InterfaceProgram,DefaultInterval,EditTcpipAddress);
	   if(ret==0)
	   {
	        Ext.Msg.alert("��ʾ","���ӳɹ�!",function(){
			obj.TWardDesc.setRawValue("");
			obj.TInterfaceProgram.setValue("");
			obj.TInterfaceProgram.setRawValue("");
			obj.TTcpipAddress.setValue("");
			obj.TBed.setRawValue("");
			obj.TBed.setValue("");
			obj.TDefaultInterval.setValue("");
			obj.TEditTcpipAddress.setValue("");
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
	        var TRowid=obj.TRowid.getValue();
		    var BedRowid=obj.TBed.getValue(); 
	        var EquipRowid=obj.TEquipRowid.getValue();
	        var TcpipAddress=obj.TTcpipAddress.getValue();
	        var Port=obj.TPort.getRawValue();
	        var InterfaceProgram=obj.TInterfaceProgram.getValue();
	        var DefaultInterval=obj.TDefaultInterval.getValue();
	        var EditTcpipAddress=obj.TEditTcpipAddress.getValue();
	    	//alert(TRowid+"@"+BedRowid+"^"+EquipRowid+"^"+TcpipAddress+"^"+Port+"^"+InterfaceProgram+"^"+DefaultInterval+"^"+EditTcpipAddress);
			var ret=_DHCICUBedEquip.UpdateBedEquip(TRowid,BedRowid,EquipRowid,TcpipAddress,Port,InterfaceProgram,DefaultInterval,EditTcpipAddress);
			//alert(ret);
			if(ret==0)
	        {
	            Ext.Msg.alert("��ʾ","�޸ĳɹ�!",function(){
			    obj.TWardDesc.setRawValue("");
			    obj.TInterfaceProgram.setValue("");
			    obj.TInterfaceProgram.setRawValue("");
			    obj.TTcpipAddress.setValue("");
			    obj.TBed.setRawValue("");
			    obj.TBed.setValue("");
			    obj.TDefaultInterval.setValue("");
			    obj.TEditTcpipAddress.setValue("");
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
	    var rc=obj.retGridPanel.getSelectionModel().getSelected();
		var TRowid = rc.get("TRowid");
		alert(TRowid);
		if(TRowid=="")
		{
			Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼!");
			return;
		}
		
		Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  		if(btn=="no")return;
	  		var ret=_DHCICUBedEquip.DeleteBedEquip(TRowid);
	  		if(ret!="0")
	  	  		Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  		else
	  	 	 Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
			    obj.TWardDesc.setRawValue("");
			    obj.TInterfaceProgram.setValue("");
			    obj.TInterfaceProgram.setRawValue("");
			    obj.TTcpipAddress.setValue("");
			    obj.TBed.setRawValue("");
			    obj.TBed.setValue("");
			    obj.TDefaultInterval.setValue("");
			    obj.TEditTcpipAddress.setValue("");
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
	obj.setbutton_click=function()
	{
	    var confirmedTime=obj.confirmedTime.getValue();
		var ret=_DHCICUBedEquip.SetConfirmedTime(confirmedTime);
		if(ret=="0")
		{
		    Ext.Msg.alert("��ʾ","���óɹ���");
		}
		else
		{
		    Ext.Msg.alert("��ʾ","����ʧ�ܣ�");
		}
	}
	obj.defaultsetbutton_click=function()
	{
	    var rc=obj.retGridPanel.getSelectionModel().getSelected();
		var ward=obj.TWardDesc.getRawValue();
		var bed=obj.TBed.getRawValue();
	    var BedRowid=rc.get("TBedRowid");
		var tipStr="ȷ����ΪĬ�ϣ�\n"+"������"+ward+"\n��λ��"+bed;
		if(!confirm(tipStr))return;
		//alert(BedRowid);
		var ret=_DHCICUBedEquip.SetDefault(BedRowid);
		if(ret=="0")
		{
		    Ext.Msg.alert("��ʾ","���óɹ���");
		}
		else
		{
		    Ext.Msg.alert("��ʾ","����ʧ�ܣ�");
		}
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
			obj.tANCCTIComOrd.setValue(rc.get("tANCCTIComOrdDr"));
            obj.RowId.setValue(rc.get("trowid"));			
        }		
  	}
	obj.addbutton_click=function()
	{
	    var code=obj.tCode.getValue();
		var ANCCTActive=(obj.tANCCTActive.getValue()=="1")?"Y":"N";
		var ANCCTIComOrdDr=obj.tANCCTIComOrd.getValue();
		var ANCCTIParref=obj.TInterfaceProgram.getValue();
		var ANCCTIChannelNo=obj.tANCCTIChannelNo.getValue();
		if(ANCCTActive==''||code=='')
		{
		    Ext.Msg.alert("��ʾ","���룬����״̬������Ϊ��!");
		    return ;
		}
		var ret=_DHCANCCollectType.InsertDHCANCCollectTypeitem(code,ANCCTIChannelNo,ANCCTActive,ANCCTIParref,ANCCTIComOrdDr);
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