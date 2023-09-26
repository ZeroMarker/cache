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
				obj.startOrStopButton.setText("停止");
			}
			else
			{
				Ext.getCmp("startOrStopButton").show(); 
				obj.startOrStopButton.setText("启动");
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
	//增加按钮
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
			Ext.Msg.alert("提示","采集代码不能为空!");
		    return ;
		}
		var DefaultInterval=obj.DefaultInterval.getValue();
		var EditTcpipAddress=obj.EditTcpipAddress.getValue();
		
		if(BedRowid=="")
		{
			Ext.Msg.alert("提示","床位不能为空!");
		    return ;
		}
		
		var ret=_DHCICUBedEquip.InsertBedEquip(BedRowid,EquipRowid,TcpipAddress,Port,InterfaceProgram,DefaultInterval,EditTcpipAddress);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","增加成功!",function(){
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

				obj.retGridPanel.getSelectionModel().clearSelections();//清除所有选择
				
	  	  		obj.retGridPanelStore.load({});
	  	  		obj.retGridItemPanelStore.load({});  	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("提示","增加失败:"+ret);
			return;
		}
	}
	//启动或停止按钮
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
				// 修改状态为N,并停止设备任务
				var ret=_DHCICUBedEquip.ModifyStat(Rowid, icuaId, "N"); 
				if(ret)
				{
					Ext.Msg.alert("提示","停止成功");
				}
				else
				{
					Ext.Msg.alert("提示","停止失败:"+ret);
					return;
				}
			 }
			 else
			 {
				 // 修改状态为"Y",并启动设备任务
				var ret=_DHCICUBedEquip.ModifyStat(Rowid, icuaId, "Y"); 
				if(ret)
				{
					Ext.Msg.alert("提示","启动成功");
				}
				else
				{
					Ext.Msg.alert("提示","启动失败:"+ret);
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
			Ext.Msg.alert("提示","请选中一行");
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
			Ext.Msg.alert("提示","请选中一行");
			return;
		}
		var BedRowid = obj.Bed.getValue();
		var EquipRowid=obj.EquipRowid.getValue();
		
		var retflag=_DHCICUBedEquip.RepBedEquip(EquipRowid,Rowid);
		if(retflag=="Y")
		{
			//Ext.Msg.alert("提示","设备不能重复操作");
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
			Ext.Msg.alert("提示","修改成功!",function(){
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

				obj.retGridPanel.getSelectionModel().clearSelections();//清除所有选择
				Ext.getCmp("startOrStopButton").hide(); 	//20160902+dyl
	  	  		obj.retGridPanelStore.removeAll();
	  	  		obj.retGridPanelStore.load({});
	  	  		obj.retGridItemPanelStore.removeAll();
	  	  		obj.retGridItemPanelStore.load({});  	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("提示","修改失败:"+ret);
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
			Ext.Msg.alert("提示","请选择一条要删除的记录!");
			return;
		}
		
		Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  		if(btn=="no")
	  		{
		  		return;
	  		}
	  		var ret=_DHCICUBedEquip.DeleteBedEquip(Rowid);
	  		if(ret!="0")
	  		{
	  	  		Ext.Msg.alert("提示","删除失败！");
	  		}
	  		else
	  		{
		  		Ext.Msg.alert("提示","删除成功！");
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

				obj.retGridPanel.getSelectionModel().clearSelections();//清除所有选择
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
			Ext.Msg.alert("提示","设置成功");
		}
		
	};
	
	obj.setDefaultButton_click=function()
	{
		var Bed=obj.Bed.getRawValue();
		var ward=obj.ward.getRawValue();
		var BedRowid=obj.Bed.getValue();
		var tipStr="确认设为默认？\n"+"病区："+ward+"\n床位："+Bed;
		Ext.Msg.confirm("选择",tipStr,function(btn){
	  		if(btn=="no")
	  		{
		  		return;
	  		}
	  		var ret=_DHCICUBedEquip.SetDefault(BedRowid);
	  		if(ret=="0")
	  		{
		  		Ext.Msg.alert("提示","设置默认成功！");
		  	}
	  	    
	  		
	    });	
	};
	
	//---------------------以下为监护项目子表
	obj.retGridItemPanel_rowclick=function()
	{
		var rc = obj.retGridItemPanel.getSelectionModel().getSelected();
		if(rc)
		{
			obj.Code.setValue(rc.get("tCode"));
			//obj.ANCCTActive.setValue(rc.get("tANCCTIActive"));
			//20160902+dyl
			obj.ANCCTActive.setValue(rc.get("tANCCTIActive")=="Y"?"1":"0");	
			obj.ANCCTActive.setRawValue(rc.get("tANCCTIActive")=="Y"?"是":"否");
			
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
			Ext.Msg.alert("提示","请在监护设备中选中一行!");
			return;
		}
		
		var ret=_DHCANCCollectType.InsertDHCANCCollectTypeitem(Code, ANCCTIChannelNo, ANCCTActive, ANCCTIParref, ANCCTIComOrdDr);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","增加成功!",function(){
				obj.Code.setValue("");
				obj.ANCCTActive.setValue("");
				obj.ANCCTActive.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
				obj.retGridItemPanel.getSelectionModel().clearSelections();//清除所有选择
				
				obj.retGridItemPanelStore.removeAll();
	  	  		obj.retGridItemPanelStore.load({});  	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("提示","增加失败:"+ret);
			return;
		}
	}
	
	
	obj.deleteButtonItem_click=function()
	{
		var Rowid=obj.ItemRowid.getValue();
		if(Rowid=="")
		{
			Ext.Msg.alert("提示","请选中一行");
			return;
		}
		
		Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  		if(btn=="no")
	  		{
		  		return;
	  		}
	  		var ret=_DHCANCCollectType.DeleteDHCANCCollectTypeitem(Rowid);
	  		if(ret!="0")
	  		{
	  	  		Ext.Msg.alert("提示","删除失败！");
	  		}
	  		else
	  		{
		  		Ext.Msg.alert("提示","删除成功！");
	  	 	 	obj.Code.setValue("");
				obj.ANCCTActive.setValue("");
				obj.ANCCTActive.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
				obj.retGridItemPanel.getSelectionModel().clearSelections();//清除所有选择
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
			Ext.Msg.alert("提示","请在监护设备中选中一行!");
			return;
		}
		
		var ret=_DHCANCCollectType.UPDATEDHCANCCollectTypeitem(Rowid, Code, ANCCTIChannelNo, ANCCTActive, ANCCTIParref, ANCCTIComOrdDr);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","更新成功!",function(){
				obj.Code.setValue("");
				obj.ANCCTActive.setValue("");
				obj.ANCCTActive.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
				obj.retGridItemPanel.getSelectionModel().clearSelections();//清除所有选择
				obj.retGridItemPanelStore.removeAll();
	  	  		obj.retGridItemPanelStore.load({});  	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("提示","更新失败:"+ret);
			return;
		}
	}
}