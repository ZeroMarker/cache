
function InitViewScreenEvent(obj)
{ 
	var _DHCBPCBG=ExtTool.StaticServerObject('web.DHCBPCBedGroup');
	obj.LoadEvent = function(args)
	{
	};
	obj.btnSch_click = function()
	{
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load();
	};
	obj.btnAdd_click = function()
	{
		
		var BPCBGCode=obj.BPCBGCode.getValue();
		var BPCBGDesc=obj.BPCBGDesc.getValue();
		//var BPCBGWordDr=obj.BPCBGWordDr.getValue();
		var BPCBGWordDr=obj.ctlocdesc.getValue();
		var BPCBGIsolated=obj.BPCBGIsolated.getValue();
		var ret=_DHCBPCBG.InsertBPCBedGroup(BPCBGCode,BPCBGDesc,BPCBGWordDr,BPCBGIsolated);
		if(ret==0) 
		{
			ExtTool.alert("��ʾ","�����ɹ�");
			ClearBPCBGData(obj);
			obj.retGridPanelStore.load();
		}
		else ExtTool.alert("��ʾ","����ʧ��!");	
	};
	obj.btnUpd_click = function()
	{
		var BPCBGRowId=obj.BPCBGRowId.getValue();
		if(BPCBGRowId==""){
			ExtTool.alert("��ʾ","��ѡ��Ҫ���µļ�¼!");
			return;
		}
		var BPCBGCode=obj.BPCBGCode.getValue();
		var BPCBGDesc=obj.BPCBGDesc.getValue();
		//var BPCBGWordDr=obj.BPCBGWordDr.getValue();
		var BPCBGWordDr=obj.ctlocdesc.getValue();
		var BPCBGIsolated=obj.BPCBGIsolated.getValue();
		var stringbed=BPCBGRowId+"^"+BPCBGCode+"^"+BPCBGDesc+"^"+BPCBGWordDr+"^"+BPCBGIsolated
		//alert(stringbed)
		var ret=_DHCBPCBG.UpdateBPCBedGroup(BPCBGRowId,BPCBGCode,BPCBGDesc,BPCBGWordDr,BPCBGIsolated);
		if(ret==0) 
		{
			ExtTool.alert("��ʾ","���³ɹ�");
			ClearBPCBGData(obj);
			obj.retGridPanelStore.load();
		}
		else ExtTool.alert("��ʾ","����ʧ��!");	
	};
	obj.btnDel_click = function()
	{	
		var RowId=obj.BPCBGRowId.getValue();
		if(RowId=="")
		{
			ExtTool.alert("��ʾ","��ѡ��Ҫɾ���ļ�¼��");
			return;
		}
		var ret=_DHCBPCBG.DeleteBPCBedGroup(RowId);
		if(ret==0) 
		{
			ExtTool.alert("��ʾ","ɾ���ɹ�");
			ClearBPCBGData(obj);
			obj.retGridPanelStore.load();
		}
		else ExtTool.alert("��ʾ","ɾ��ʧ��!");	
	};
	
	obj.retGridPanel_rowclick=function() //������ȡ����
	{
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
	    {	
			obj.BPCBGRowId.setValue(selectObj.get("tRowId"))
			obj.BPCBGCode.setValue(selectObj.get("tBPCBGCode"));
			obj.BPCBGDesc.setValue(selectObj.get("tBPCBGDesc"));
			//obj.BPCBGWordDr.setValue(selectObj.get("tBPCBGWardDr"))
			obj.ctlocdesc.setValue(selectObj.get("tBPCBGWardDr"))
			obj.BPCBGIsolated.setValue(selectObj.get("tBPCBGIsolatedDr"));
		}
	};
function ClearBPCBGData(obj)
{
	obj.BPCBGRowId.setValue("");
	obj.BPCBGCode.setValue("");
	obj.BPCBGDesc.setValue("");
	//obj.BPCBGWordDr.setValue("");
	obj.ctlocdesc.setValue("");
	obj.BPCBGIsolated.setValue("");

}

}




