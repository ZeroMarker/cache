function InitViewScreenEvent(obj)
{
	var _DHCANCCollectType = ExtTool.StaticServerObject('web.DHCANCCollectType');
	var _DHCICUBedEquip = ExtTool.StaticServerObject('web.DHCICUBedEquip');
	
	obj.LoadEvent=function(args)
	{
		var min=_DHCICUBedEquip.GetConfirmedTime();
		obj.confirmedTime.setValue(min);
		
		Ext.getCmp("startOrStopButton").hide(); 
		
	}
	
	obj.retGridPanel_rowclick=function()
	{
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
		if(rc)
		{
			obj.ward.setValue(rc.get("TWardId"));
			obj.ward.setRawValue(rc.get("TWardDesc"));
			obj.Bed.setValue(rc.get("TBedRowid"));
			obj.Bed.setRawValue(rc.get("TBed"));
			obj.InterfaceProgram.setValue(rc.get("TInterfaceProgramID"));
			obj.InterfaceProgram.setRawValue(rc.get("TInterfaceProgram"));
			obj.TcpipAddress.setValue(rc.get("TTcpipAddress"));
			obj.DefaultInterval.setValue(rc.get("TDefaultInterval"));
			obj.EditTcpipAddress.setValue(rc.get("TEditTcpipAddress"));
			//obj.confirmedTime.setValue(rc.get("TWardId"));
			obj.Port.setValue(rc.get("TPort"));
			obj.Port.setRawValue(rc.get("TPort"));
			obj.EquipRowid.setValue(rc.get("TEquipRowid"));
			obj.Rowid.setValue(rc.get("TRowid"));
			
			var stat=rc.get("TStat");
			if(stat==""||stat==null||stat=="Y")
			{
				Ext.getCmp("startOrStopButton").show(); 
				obj.startOrStopButton.setText("ֹͣ");
			}
			else
			{
				Ext.getCmp("startOrStopButton").show(); 
				obj.startOrStopButton.setText("����");
			}
			//20160902+dyl
				obj.Code.setValue("");
				obj.ANCCTActive.setValue("");
				obj.ANCCTActive.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
				obj.retGridItemPanelStore.removeAll();
			obj.retGridItemPanelStore.load({})
		}
		else
		{
			
			Ext.getCmp("startOrStopButton").hide(); 
		}
	
	}
	Clear= function()
	{
		obj.ward.setValue("");
			obj.ward.setRawValue("");
			obj.Bed.setValue("");
			obj.Bed.setRawValue("");
			obj.InterfaceProgram.setValue("");
			obj.InterfaceProgram.setRawValue("");
			obj.TcpipAddress.setValue("");
			obj.DefaultInterval.setValue("");
			obj.EditTcpipAddress.setValue("");
			//obj.confirmedTime.setValue(rc.get("TWardId"));
			obj.Port.setValue("");
			obj.Port.setRawValue("");
			obj.EquipRowid.setValue("");
			obj.Rowid.setValue("");
			
			
			//20160902+dyl
				obj.Code.setValue("");
				obj.ANCCTActive.setValue("");
				obj.ANCCTActive.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
				obj.retGridItemPanelStore.removeAll();
			obj.retGridItemPanelStore.load({})
	}
	//���Ӱ�ť
	obj.addButton_click = function()
	{
		var BedRowid=obj.Bed.getValue();
		var EquipRowid=obj.EquipRowid.getValue();
		var TcpipAddress=obj.TcpipAddress.getValue();
		var Port=obj.Port.getValue();
		var InterfaceProgram=obj.InterfaceProgram.getValue();
		//20160902+dyl
		if(InterfaceProgram=="")
		{
			Ext.Msg.alert("��ʾ","�ɼ����벻��Ϊ��!");
		    return ;
		}
		var DefaultInterval=obj.DefaultInterval.getValue();
		var EditTcpipAddress=obj.EditTcpipAddress.getValue();
		
		if(BedRowid=="")
		{
			Ext.Msg.alert("��ʾ","��λ����Ϊ��!");
		    return ;
		}
		
		var ret=_DHCICUBedEquip.InsertBedEquip(BedRowid,EquipRowid,TcpipAddress,Port,InterfaceProgram,DefaultInterval,EditTcpipAddress);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","���ӳɹ�!",function(){
				obj.ward.setValue("");
				obj.ward.setRawValue("");
				obj.Bed.setValue("");
				obj.Bed.setRawValue("");
				obj.InterfaceProgram.setValue("");
				obj.InterfaceProgram.setRawValue("");
				obj.TcpipAddress.setValue("");
				obj.DefaultInterval.setValue("");
				obj.EditTcpipAddress.setValue("");
				obj.Port.setValue("");
				obj.Port.setRawValue("");
				obj.EquipRowid.setValue("");
				obj.Rowid.setValue("");
				//20160902+dyl
				obj.Code.setValue("");
				obj.ANCCTActive.setValue("");
				obj.ANCCTActive.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");

				obj.retGridPanel.getSelectionModel().clearSelections();//�������ѡ��
				
	  	  		obj.retGridPanelStore.load({});
	  	  		obj.retGridItemPanelStore.load({});  	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("��ʾ","����ʧ��:"+ret);
			return;
		}
	}
	//������ֹͣ��ť
	 obj.startOrStopButton_click=function()
	 {
		 var rc = obj.retGridPanel.getSelectionModel().getSelected();
		 if(rc)
		 {
			 var Rowid=rc.get("TRowid");
			 var icuaId=request("icuaId");
			 var stat=rc.get("TStat")
			 stat=stat.replace(" ","");
			 icuaId=icuaId.replace("#","");
			 
			 //alert(Rowid+":"+icuaId);
			 if(stat != "N")
			 {
				// �޸�״̬ΪN,��ֹͣ�豸����
				var ret=_DHCICUBedEquip.ModifyStat(Rowid, icuaId, "N"); 
				if(ret)
				{
					Ext.Msg.alert("��ʾ","ֹͣ�ɹ�");
				}
				else
				{
					Ext.Msg.alert("��ʾ","ֹͣʧ��:"+ret);
					return;
				}
			 }
			 else
			 {
				 // �޸�״̬Ϊ"Y",�������豸����
				var ret=_DHCICUBedEquip.ModifyStat(Rowid, icuaId, "Y"); 
				if(ret)
				{
					Ext.Msg.alert("��ʾ","�����ɹ�");
				}
				else
				{
					Ext.Msg.alert("��ʾ","����ʧ��:"+ret);
					return;
				}
			 }
			 
			 obj.ward.setValue("");
			 obj.ward.setRawValue("");
			 obj.Bed.setValue("");
			 obj.Bed.setRawValue("");
			 obj.InterfaceProgram.setValue("");
			 obj.InterfaceProgram.setRawValue("");
			 obj.TcpipAddress.setValue("");
			 obj.DefaultInterval.setValue("");
			 obj.EditTcpipAddress.setValue("");
			 obj.Port.setValue("");
			 obj.Port.setRawValue("");
			 obj.EquipRowid.setValue("");
			 obj.Rowid.setValue("");
			 
			 obj.startOrStopButton.setText("");
			 Ext.getCmp("startOrStopButton").hide(); //20160902+dyl
			 obj.retGridPanelStore.removeAll();
			 obj.retGridPanelStore.load({});
		 }
		 else
		 {
			Ext.Msg.alert("��ʾ","��ѡ��һ��");
			return; 
		 }
	 }
	
	function request(paras)
	{ 
	    var url = location.href; 
        var paraString = url.substring(url.indexOf("?")+1,url.length).split("&"); 
        var paraObj = {} 
        for (i=0; j=paraString[i]; i++)
        { 
        	paraObj[j.substring(0,j.indexOf("=")).toLowerCase()] = j.substring(j.indexOf("=")+1,j.length); 
        } 
        var returnValue = paraObj[paras.toLowerCase()]; 
        if(typeof(returnValue)=="undefined")
        { 
        	return ""; 
        }
        else
        { 
        	return returnValue; 
        } 
	}
	
	obj.updateButton_click=function()
	{
		var Rowid=obj.Rowid.getValue();
		if(Rowid=="")
		{
			Ext.Msg.alert("��ʾ","��ѡ��һ��");
			return;
		}
		var BedRowid = obj.Bed.getValue();
		var EquipRowid=obj.EquipRowid.getValue();
		
		var retflag=_DHCICUBedEquip.RepBedEquip(EquipRowid,Rowid);
		if(retflag=="Y")
		{
			//Ext.Msg.alert("��ʾ","�豸�����ظ�����");
			//return; 
		}
		var TcpipAddress=obj.TcpipAddress.getValue();
		var Port=obj.Port.getValue();
		var InterfaceProgram=obj.InterfaceProgram.getValue();
		var DefaultInterval=obj.DefaultInterval.getValue();
		var EditTcpipAddress=obj.EditTcpipAddress.getValue();
		
		var ret=_DHCICUBedEquip.UpdateBedEquip(Rowid,BedRowid,EquipRowid,TcpipAddress,Port,InterfaceProgram,DefaultInterval,EditTcpipAddress);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","�޸ĳɹ�!",function(){
				obj.ward.setValue("");
				obj.ward.setRawValue("");
				obj.Bed.setValue("");
				obj.Bed.setRawValue("");
				obj.InterfaceProgram.setValue("");
				obj.InterfaceProgram.setRawValue("");
				obj.TcpipAddress.setValue("");
				obj.DefaultInterval.setValue("");
				obj.EditTcpipAddress.setValue("");
				obj.Port.setValue("");
				obj.Port.setRawValue("");
				obj.EquipRowid.setValue("");
				obj.Rowid.setValue("");
				//20160902+dyl
				obj.Code.setValue("");
				obj.ANCCTActive.setValue("");
				obj.ANCCTActive.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");

				obj.retGridPanel.getSelectionModel().clearSelections();//�������ѡ��
				Ext.getCmp("startOrStopButton").hide(); 	//20160902+dyl
	  	  		obj.retGridPanelStore.removeAll();
	  	  		obj.retGridPanelStore.load({});
	  	  		obj.retGridItemPanelStore.removeAll();
	  	  		obj.retGridItemPanelStore.load({});  	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("��ʾ","�޸�ʧ��:"+ret);
			return;
		}
		
	}
	
	obj.findButton_click=function()
	{
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({});
		obj.retGridItemPanelStore.removeAll();
	  	//obj.retGridItemPanelStore.load({});		
	  	Clear();	//20160902+dyl

	}
	
	obj.deleteButton_click=function()
	{
		var Rowid=obj.Rowid.getValue("");
		if(Rowid=="")
		{
			Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼!");
			return;
		}
		
		Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  		if(btn=="no")
	  		{
		  		return;
	  		}
	  		var ret=_DHCICUBedEquip.DeleteBedEquip(Rowid);
	  		if(ret!="0")
	  		{
	  	  		Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  		}
	  		else
	  		{
		  		Ext.Msg.alert("��ʾ","ɾ���ɹ���");
	  	 	 	obj.ward.setValue("");
				obj.ward.setRawValue("");
				obj.Bed.setValue("");
				obj.Bed.setRawValue("");
				obj.InterfaceProgram.setValue("");
				obj.InterfaceProgram.setRawValue("");
				obj.TcpipAddress.setValue("");
				obj.DefaultInterval.setValue("");
				obj.EditTcpipAddress.setValue("");
				obj.Port.setValue("");
				obj.Port.setRawValue("");
				obj.EquipRowid.setValue("");
				obj.Rowid.setValue("");
				//20160902+dyl
				obj.Code.setValue("");
				obj.ANCCTActive.setValue("");
				obj.ANCCTActive.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");

				obj.retGridPanel.getSelectionModel().clearSelections();//�������ѡ��
				obj.retGridPanelStore.removeAll();
	  	  		obj.retGridPanelStore.load({});
	  	  		obj.retGridItemPanelStore.removeAll();
	  	  		obj.retGridItemPanelStore.load({});
	  		}
	    });	
	}
	
	obj.setButton_click=function()
	{
		var confirmedTime = obj.confirmedTime.getValue();
		var ret=_DHCICUBedEquip.SetConfirmedTime(confirmedTime);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","���óɹ�");
		}
		
	};
	
	obj.setDefaultButton_click=function()
	{
		var Bed=obj.Bed.getRawValue();
		var ward=obj.ward.getRawValue();
		var BedRowid=obj.Bed.getValue();
		var tipStr="ȷ����ΪĬ�ϣ�\n"+"������"+ward+"\n��λ��"+Bed;
		Ext.Msg.confirm("ѡ��",tipStr,function(btn){
	  		if(btn=="no")
	  		{
		  		return;
	  		}
	  		var ret=_DHCICUBedEquip.SetDefault(BedRowid);
	  		if(ret=="0")
	  		{
		  		Ext.Msg.alert("��ʾ","����Ĭ�ϳɹ���");
		  	}
	  	    
	  		
	    });	
	};
	
	//---------------------����Ϊ�໤��Ŀ�ӱ�
	obj.retGridItemPanel_rowclick=function()
	{
		var rc = obj.retGridItemPanel.getSelectionModel().getSelected();
		if(rc)
		{
			obj.Code.setValue(rc.get("tCode"));
			//obj.ANCCTActive.setValue(rc.get("tANCCTIActive"));
			//20160902+dyl
			obj.ANCCTActive.setValue(rc.get("tANCCTIActive")=="Y"?"1":"0");	
			obj.ANCCTActive.setRawValue(rc.get("tANCCTIActive")=="Y"?"��":"��");
			
			obj.ANCCTIChannelNo.setValue(rc.get("tANCCTIChannelNo"));
			obj.ANCCTIComOrd.setValue(rc.get("tANCCTIComOrdDr"));
			obj.ANCCTIComOrd.setRawValue(rc.get("tANCCTIComOrdDrDesc"));
			obj.ItemRowid.setValue(rc.get("trowid"));
		}
	}
	
	obj.addButtonItem_click=function()
	{
		var Code=obj.Code.getValue();
		var ANCCTIChannelNo=obj.ANCCTIChannelNo.getValue();
		var ANCCTActive=(obj.ANCCTActive.getValue()=="1"?"Y":"N");
		var ANCCTIParref=obj.InterfaceProgram.getValue();
		var ANCCTIComOrdDr=obj.ANCCTIComOrd.getValue();
		
		if(ANCCTIParref=="")
		{
			Ext.Msg.alert("��ʾ","���ڼ໤�豸��ѡ��һ��!");
			return;
		}
		
		var ret=_DHCANCCollectType.InsertDHCANCCollectTypeitem(Code, ANCCTIChannelNo, ANCCTActive, ANCCTIParref, ANCCTIComOrdDr);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","���ӳɹ�!",function(){
				obj.Code.setValue("");
				obj.ANCCTActive.setValue("");
				obj.ANCCTActive.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
				obj.retGridItemPanel.getSelectionModel().clearSelections();//�������ѡ��
				
				obj.retGridItemPanelStore.removeAll();
	  	  		obj.retGridItemPanelStore.load({});  	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("��ʾ","����ʧ��:"+ret);
			return;
		}
	}
	
	
	obj.deleteButtonItem_click=function()
	{
		var Rowid=obj.ItemRowid.getValue();
		if(Rowid=="")
		{
			Ext.Msg.alert("��ʾ","��ѡ��һ��");
			return;
		}
		
		Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  		if(btn=="no")
	  		{
		  		return;
	  		}
	  		var ret=_DHCANCCollectType.DeleteDHCANCCollectTypeitem(Rowid);
	  		if(ret!="0")
	  		{
	  	  		Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  		}
	  		else
	  		{
		  		Ext.Msg.alert("��ʾ","ɾ���ɹ���");
	  	 	 	obj.Code.setValue("");
				obj.ANCCTActive.setValue("");
				obj.ANCCTActive.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
				obj.retGridItemPanel.getSelectionModel().clearSelections();//�������ѡ��
				obj.retGridItemPanelStore.removeAll();
	  	  		obj.retGridItemPanelStore.load({});
	  		}
	    });	
	}
	obj.ward_select=function()
	 {
	  obj.BedStore.reload({});
	 }

	obj.updateButtonItem_click=function()
	{
		var Rowid=obj.ItemRowid.getValue();
		var Code=obj.Code.getValue();
		var ANCCTIChannelNo=obj.ANCCTIChannelNo.getValue();
		var ANCCTActive=(obj.ANCCTActive.getValue()=="1"?"Y":"N");
		var ANCCTIParref=obj.InterfaceProgram.getValue();
		var ANCCTIComOrdDr=obj.ANCCTIComOrd.getValue();
		if(ANCCTIParref=="")
		{
			Ext.Msg.alert("��ʾ","���ڼ໤�豸��ѡ��һ��!");
			return;
		}
		
		var ret=_DHCANCCollectType.UPDATEDHCANCCollectTypeitem(Rowid, Code, ANCCTIChannelNo, ANCCTActive, ANCCTIParref, ANCCTIComOrdDr);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","���³ɹ�!",function(){
				obj.Code.setValue("");
				obj.ANCCTActive.setValue("");
				obj.ANCCTActive.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
				obj.retGridItemPanel.getSelectionModel().clearSelections();//�������ѡ��
				obj.retGridItemPanelStore.removeAll();
	  	  		obj.retGridItemPanelStore.load({});  	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("��ʾ","����ʧ��:"+ret);
			return;
		}
	}
}