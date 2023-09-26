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
			ExtTool.alert("��ʾ","��ʼ���ڲ���Ϊ��!");	
			return;
		}
		if(obj.bpEquip.getValue()=="")
		{
			ExtTool.alert("��ʾ","�豸ѡ����Ϊ��!");	
			return;
		}
		var txtStartDate=obj.startDate.getRawValue() //��ȡ��ʼ����
		var txtStartTime=obj.startTime.getValue() //��ȡ��ʼʱ��
		
		var txtEndDate=obj.endDate.getRawValue() //��ȡ��������
		var txtEndTime=obj.endTime.getValue() //��ȡ����ʱ��
		
		//ʱ��������ʽ�����ּ��
		if(txtStartTime!=""&&txtEndTime!=""&&!(timeReg.exec(txtStartTime)&&timeReg.exec(txtEndTime))){ 
			Ext.Msg.alert("��ʾ","����ʱ������,������������ȷ��00:00:00(hh:mm:ss)����ʽ");
			return;
		}
		var txtECode=obj.bpEquip.getValue(); //��ȡ�豸id
		var txtNote=obj.bperNote.getValue();
		var bpEquipInfo=txtECode+"^"+txtStartDate+"^"+txtStartTime+"^"+txtEndDate+"^"+txtEndTime+"^"+txtNote+"^"+userId;
		//alert(bpEMaintainInfo)
		var ret=_DHCBPEquipRun.InsertBPEquipMaintain(bpEquipInfo);
		//alert(ret)
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","���ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�!");
	  	  	obj.retGridPanelStore.load();
	  	  	
		}
	};
	
	obj.updatebutton_click = function()
	{
		var rowid=obj.tRowId.getValue() //���Rowid
		if(rowid==""){
			ExtTool.alert("��ʾ","��ѡ��һ��Ҫ�޸ĵ�����!");	
			return;
		}
		
		if(obj.startDate.getValue()=="")
		{
			ExtTool.alert("��ʾ","��ʼ���ڲ���Ϊ��!");	
			return;
		}
		if(obj.bpEquip.getValue()=="")
		{
			ExtTool.alert("��ʾ","�豸ѡ����Ϊ��!");	
			return;
		}

		var txtStartDate=obj.startDate.getRawValue() //��ȡ��ʼ����
		var txtStartTime=obj.startTime.getValue() //��ȡ��ʼʱ��
		
		var txtEndDate=obj.endDate.getRawValue() //��ȡ��������
		var txtEndTime=obj.endTime.getValue() //��ȡ����ʱ��
		
		//ʱ��������ʽ�����ּ��
		if(txtStartTime!=""&&txtEndTime!=""&&!(timeReg.exec(txtStartTime)&&timeReg.exec(txtEndTime))){ 
			Ext.Msg.alert("��ʾ","����ʱ������,������������ȷ��00:00:00(hh:mm:ss)����ʽ");
			return;
		}
		var txtECode=obj.bpEquip.getValue(); //��ȡ�豸id
		var txtPECode=obj.bpemPartEquip.getValue(); //��ȡ�豸����id
		var txtEType=obj.bpemEType.getValue(); //��ȡ�豸����
		var txtPEType=obj.bpemEPartType.getValue(); //��ȡ�豸��������
		var txtNote=obj.bperNote.getValue();
		var bpEMaintainInfo=rowid+"^"+txtECode+"^"+txtPECode+"^"+txtEType+"^"+txtPEType+"^"+txtStartDate+"^"+txtStartTime+"^"+txtEndDate+"^"+txtEndTime+"^"+txtNote+"^"+userId;
		//alert(bpEMaintainInfo)
		var ret=_DHCBPEquipMaintain.UpdateBPEquipMaintain(bpEMaintainInfo);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","����ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","���³ɹ�!");
			ClearData(obj);
	  	  	obj.retGridPanelStore.load();
		}

	};
	
	obj.deletebutton_click=function(){
		var RowId=obj.tRowId.getValue();
		if(RowId=="")
		{
			ExtTool.alert("��ʾ","IDΪ��!��ѡ��һ������");
			return;
		}
		var ret=_DHCBPEquipMaintain.DeleteBPEquipMaintain(RowId);
		if(ret==0) 
		{
			ExtTool.alert("��ʾ","ɾ���ɹ�");
			ClearData(obj);
			obj.retGridPanelStore.load();
		}
		else ExtTool.alert("��ʾ","ɾ��ʧ��!");	
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
	
	//�ж�ʱ���ʽ
}