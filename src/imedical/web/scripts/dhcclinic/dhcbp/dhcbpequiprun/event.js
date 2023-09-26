function InitViewScreenEvent(obj)
{
	var _DHCBPEquipRun=ExtTool.StaticServerObject('web.DHCBPEquipRun');
	var userId=session['LOGON.USERID'];
	//var timeReg=/([0-1][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])/
	var timeReg=/^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/
	obj.LoadEvent = function(args)
	{
		/*obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCBPDetection';
			param.QueryName = 'FindBPDetection';
			param.Arg1 = obj.bpdDate.getRawValue();
			param.Arg2 = obj.bpdBPCEquip.getValue();
			param.ArgCnt = 2;
		});
		obj.retGridPanelStore.load({});  */
	};
	
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  if (rc){ 
	    obj.tRowId.setValue(rc.get("tRowId"));
	    obj.bpEquip.setValue(rc.get("tDBPCEquipDr"));
	    obj.startDate.setValue(rc.get("StartDate"));
	    obj.startTime.setValue(rc.get("StartTime"));
	    obj.endDate.setValue(rc.get("EndDate"));
	    obj.endTime.setValue(rc.get("EndTime"));
	    obj.bperNote.setValue(rc.get("Note"));
	  }
	};
	
	obj.addbutton_click = function()
	{
		if(obj.startDate.getValue()=="")
		{
			ExtTool.alert("提示","开始日期不能为空!");	
			return;
		}
		if(obj.bpEquip.getValue()=="")
		{
			ExtTool.alert("提示","设备选择不能为空!");	
			return;
		}
		var txtStartDate=obj.startDate.getRawValue() //获取开始日期
		var txtStartTime=obj.startTime.getValue() //获取开始时间
		
		var txtEndDate=obj.endDate.getRawValue() //获取结束日期
		var txtEndTime=obj.endTime.getValue() //获取结束时间
		
		//时间的输入格式和数字检测
		if(txtStartTime!=""&&txtEndTime!=""&&!(timeReg.exec(txtStartTime)&&timeReg.exec(txtEndTime))){ 
			Ext.Msg.alert("提示","输入时间有误,请重新输入正确“00:00:00(hh:mm:ss)”格式");
			return;
		}
		var txtECode=obj.bpEquip.getValue(); //获取设备id
		var txtNote=obj.bperNote.getValue();
		var bpEquipInfo=txtECode+"^"+txtStartDate+"^"+txtStartTime+"^"+txtEndDate+"^"+txtEndTime+"^"+txtNote+"^"+userId;
		//alert(bpEMaintainInfo)
		var ret=_DHCBPEquipRun.InsertBPEquipMaintain(bpEquipInfo);
		//alert(ret)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","添加失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","添加成功!");
	  	  	obj.retGridPanelStore.load();
	  	  	
		}
	};
	
	obj.updatebutton_click = function()
	{
		var rowid=obj.tRowId.getValue() //获得Rowid
		if(rowid==""){
			ExtTool.alert("提示","请选中一行要修改的数据!");	
			return;
		}
		
		if(obj.startDate.getValue()=="")
		{
			ExtTool.alert("提示","开始日期不能为空!");	
			return;
		}
		if(obj.bpEquip.getValue()=="")
		{
			ExtTool.alert("提示","设备选择不能为空!");	
			return;
		}

		var txtStartDate=obj.startDate.getRawValue() //获取开始日期
		var txtStartTime=obj.startTime.getValue() //获取开始时间
		
		var txtEndDate=obj.endDate.getRawValue() //获取结束日期
		var txtEndTime=obj.endTime.getValue() //获取结束时间
		
		//时间的输入格式和数字检测
		if(txtStartTime!=""&&txtEndTime!=""&&!(timeReg.exec(txtStartTime)&&timeReg.exec(txtEndTime))){ 
			Ext.Msg.alert("提示","输入时间有误,请重新输入正确“00:00:00(hh:mm:ss)”格式");
			return;
		}
		var txtECode=obj.bpEquip.getValue(); //获取设备id
		var txtPECode=obj.bpemPartEquip.getValue(); //获取设备部件id
		var txtEType=obj.bpemEType.getValue(); //获取设备类型
		var txtPEType=obj.bpemEPartType.getValue(); //获取设备部件类型
		var txtNote=obj.bperNote.getValue();
		var bpEMaintainInfo=rowid+"^"+txtECode+"^"+txtPECode+"^"+txtEType+"^"+txtPEType+"^"+txtStartDate+"^"+txtStartTime+"^"+txtEndDate+"^"+txtEndTime+"^"+txtNote+"^"+userId;
		//alert(bpEMaintainInfo)
		var ret=_DHCBPEquipMaintain.UpdateBPEquipMaintain(bpEMaintainInfo);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("提示","更新失败!");
		}
		else 
		{
			Ext.Msg.alert("提示","更新成功!");
			ClearData(obj);
	  	  	obj.retGridPanelStore.load();
		}

	};
	
	obj.deletebutton_click=function(){
		var RowId=obj.tRowId.getValue();
		if(RowId=="")
		{
			ExtTool.alert("提示","ID为空!请选择一行数据");
			return;
		}
		var ret=_DHCBPEquipMaintain.DeleteBPEquipMaintain(RowId);
		if(ret==0) 
		{
			ExtTool.alert("提示","删除成功");
			ClearData(obj);
			obj.retGridPanelStore.load();
		}
		else ExtTool.alert("提示","删除失败!");	
	};
	
	obj.selectbutton_click=function(){
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({});
	};
	function ClearData(obj){
	    obj.tRowId.setValue("");
	    obj.bpEquip.setValue("");
	    obj.bpemPartEquip.setValue("");
	    obj.startDate.setValue("");
	    obj.startTime.setValue("");
	    obj.endDate.setValue("");
	    obj.endTime.setValue("");
	    obj.bpemEType.setValue("");
	    obj.bpemEPartType.setValue("");
	    obj.bperNote.setValue("");
	};
	
	//判断时间格式
}