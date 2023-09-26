
function InitViewScreenEvent(obj)
{ 
	var _DHCBPCRC=ExtTool.StaticServerObject('web.DHCBPCRecordCat');
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
		
		var BPCRCCode=obj.BPCRCCode.getValue();
		var BPCRCDesc=obj.BPCRCDesc.getValue();
		if (BPCRCCode==""){ExtTool.alert("��ʾ","���벻��Ϊ��!");return;}
		var ret=_DHCBPCRC.InsertBPCRecordCat(BPCRCCode,BPCRCDesc);
		if(ret==0) 
		{
			ExtTool.alert("��ʾ","�����ɹ�");
			ClearBPCRCData(obj);
		  obj.retGridPanelStore.load();
		}
		else ExtTool.alert("��ʾ","����ʧ��!");	

	};
	obj.btnUpd_click = function()
	{
		var BPCRCRowId=obj.BPCRCRowId.getValue();
		var BPCRCCode=obj.BPCRCCode.getValue();
		var BPCRCDesc=obj.BPCRCDesc.getValue();
		if(BPCRCRowId==""){
			ExtTool.alert("��ʾ","��ѡ��һ��Ҫ���µļ�¼");
			return;
		}
		var ret=_DHCBPCRC.UpdateBPCRecordCat(BPCRCRowId,BPCRCCode,BPCRCDesc);
		if(ret==0) 
		{
			ExtTool.alert("��ʾ","���³ɹ�");
			ClearBPCRCData(obj);
		  obj.retGridPanelStore.load();
		}
		else ExtTool.alert("��ʾ","����ʧ��!");	

	};
	obj.btnDel_click = function()
	{	
		var RowId=obj.BPCRCRowId.getValue();
		if(RowId=="")
		{
			ExtTool.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼!");
			return;
		}
		var ret=_DHCBPCRC.DeleteBPCRecordCat(RowId);
		if(ret==0) 
		{
			ExtTool.alert("��ʾ","ɾ���ɹ�");
			ClearBPCRCData(obj);
			obj.retGridPanelStore.load();
		}
		else ExtTool.alert("��ʾ","ɾ��ʧ��!");	
	};
	
	obj.retGridPanel_rowclick=function() //������ȡ����
	{
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
	    {	
			obj.BPCRCRowId.setValue(selectObj.get("tRowId"))
			obj.BPCRCCode.setValue(selectObj.get("tBPCRCCode"));
			obj.BPCRCDesc.setValue(selectObj.get("tBPCRCDesc"));
		}
	};
function ClearBPCRCData(obj)
{
	obj.BPCRCRowId.setValue("");
	obj.BPCRCCode.setValue("");
	obj.BPCRCDesc.setValue("");


}

}
