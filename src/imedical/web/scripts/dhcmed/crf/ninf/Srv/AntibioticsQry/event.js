function InitMonitorViewportEvent(obj)
{	obj.LoadEvent = function(args)
	{
		obj.btnQuery.on("click", obj.btnQuery_click, obj);	
		obj.btnExport.on("click", obj.btnExport_click, obj);	
	}
	obj.btnQuery_click = function()
	{
		obj.ResultGridPanelStore.removeAll();
		var DateFrom = obj.dfDateFrom.getValue();
		var DateTo = obj.dfDateTo.getValue();
		var sDate = new Date(DateFrom);
		var eDate = new Date(DateTo);
		if (sDate.getTime()>eDate.getTime()){
			ExtTool.alert("��ʾ","��ʼ���ڲ��ܴ��ڽ������ڣ�");
		}else if(((eDate.getTime()-sDate.getTime())/1000/60/60/24)>30){
			ExtTool.alert("��ʾ","��ѯ�������ܳ���31�죡");
		}else if ((obj.cboLoc.getValue() == "")&&(obj.cboOrd.getValue() == "")){
			ExtTool.alert("��ʾ","��ѡ����һ�����");
		}else{
			obj.ResultGridPanelStore.load({});
		}
	}
	obj.btnExport_click = function(){
		if (obj.ResultGridPanel.getStore().getCount() > 0)
		{
			var strFileName="������ҽ����ѯ";
			var objExcelTool=Ext.dhcc.DataToExcelTool;
			objExcelTool.ExprotGrid(obj.ResultGridPanel,strFileName);
		} else {
			ExtTool.alert("��ʾ","��ѯ�б�����Ϊ��!");
		}
	}
	
	obj.cboLoc_OnExpand = function(){
		obj.cboLocStore.load({});
	}
	obj.cboOrd_OnExpand = function(){
		obj.cboOrdStore.load({});
	}
/*Viewport1��������ռλ��*/
}