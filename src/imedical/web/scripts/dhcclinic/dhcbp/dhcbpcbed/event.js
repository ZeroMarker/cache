
function InitViewScreenEvent(obj)
{ 
	var _DHCBPCB=ExtTool.StaticServerObject('web.DHCBPCBed');
	obj.LoadEvent = function(args)
	{
	};
	
	obj.btnAdd_click = function()
	{
		var BPCBCode=obj.BPCBCode.getValue();
		if(BPCBCode==""||BPCBCode==null)
		{
			ExtTool.alert("��ʾ","��λ���벻��Ϊ�գ�");
			obj.BPCBCode.focus();
			return;
		}
		var BPCBDesc=obj.BPCBDesc.getValue();
		if(BPCBDesc==""||BPCBDesc==null)
		{
			ExtTool.alert("��ʾ","��λ���Ʋ���Ϊ�գ�");
			obj.BPCBDesc.focus();
			return;
		}
		var BPCBGroupDr=obj.BPCBGroupDr.getValue();
		if(BPCBGroupDr==""||BPCBGroupDr==null)
		{
			ExtTool.alert("��ʾ","��λ�鲻��Ϊ�գ�");
			obj.BPCBGroupDr.focus();
			return;
		}
		var BPCBStatus=obj.BPCBStatus.getValue();
		var BPCBType=obj.BPCBType.getValue();
		var ret=_DHCBPCB.InsertBPCBed(BPCBCode,BPCBDesc,BPCBGroupDr,BPCBStatus,BPCBType);
		if(ret==0) 
		{
			ExtTool.alert("��ʾ","�����ɹ�");
			ClearBPCBData(obj);
			obj.retGridPanelStore.load();
		}
		else ExtTool.alert("��ʾ","����ʧ��!");	
	};
	obj.btnUpd_click = function()
	{
		var BPCBRowId=obj.BPCBRowId.getValue();
		if(BPCBRowId==""||BPCBRowId==null)
		{
			ExtTool.alert("��ʾ","��ѡ��Ҫ���µļ�¼��");
			return;
		}
		var BPCBCode=obj.BPCBCode.getValue();
		if(BPCBCode==""||BPCBCode==null)
		{
			ExtTool.alert("��ʾ","��λ���벻��Ϊ�գ�");
			obj.BPCBCode.focus();
			return;
		}
		var BPCBDesc=obj.BPCBDesc.getValue();
		if(BPCBDesc==""||BPCBDesc==null)
		{
			ExtTool.alert("��ʾ","��λ���Ʋ���Ϊ�գ�");
			obj.BPCBDesc.focus();
			return;
		}
		var BPCBGroupDr=obj.BPCBGroupDr.getValue();
		if(BPCBGroupDr==""||BPCBGroupDr==null)
		{
			ExtTool.alert("��ʾ","��λ�鲻��Ϊ�գ�");
			obj.BPCBGroupDr.focus();
			return;
		}
		var BPCBStatus=obj.BPCBStatus.getValue();
		var BPCBType=obj.BPCBType.getValue();
		var ret=_DHCBPCB.UpdateBPCBed(BPCBRowId,BPCBCode,BPCBDesc,BPCBGroupDr,BPCBStatus,BPCBType);
		if(ret==0) 
		{
			ExtTool.alert("��ʾ","���³ɹ�");
			ClearBPCBData(obj);
			obj.retGridPanelStore.load();
		}
		else ExtTool.alert("��ʾ","����ʧ��!");	
		
	};
	obj.btnDel_click = function()
	{	
		var RowId=obj.BPCBRowId.getValue();
		if(RowId=="")
		{
			ExtTool.alert("��ʾ","��ѡ��Ҫɾ���ļ�¼!");
			return;
		}
		var ret=_DHCBPCB.DeleteBPCBed(RowId);
		if(ret==0) 
		{
			ExtTool.alert("��ʾ","ɾ���ɹ�");
			ClearBPCBData(obj);
			obj.retGridPanelStore.load();
		}
		else ExtTool.alert("��ʾ","ɾ��ʧ��!");	
	};
	
	obj.retGridPanel_rowclick=function() //������ȡ����
	{
		
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
	    {	
			obj.BPCBRowId.setValue(selectObj.get("tRowId"))
			obj.BPCBCode.setValue(selectObj.get("tBPCBCode"));
			obj.BPCBDesc.setValue(selectObj.get("tBPCBDesc"));
			obj.BPCBGroupDr.setValue(selectObj.get("tBPCBBPCBedGroupDr"))
			obj.BPCBStatus.setValue(selectObj.get("tBPCBStatus"));
			obj.BPCBType.setValue(selectObj.get("tBPCBType"));
		}
	};
	function ClearBPCBData(obj)
	{
		obj.BPCBRowId.setValue("");
		obj.BPCBCode.setValue("");
		obj.BPCBDesc.setValue("");
		obj.BPCBGroupDr.setValue("");
		obj.BPCBStatus.setValue("");
		obj.BPCBType.setValue("");

	}
}
