
function InitMonitorViewportEvent(obj)
{
	obj.LoadEvent = function(args)
	{
		obj.btnQuery.on("click", obj.btnQuery_OnClick, obj);
		obj.btnExport.on("click", obj.btnExport_OnClick, obj);
		obj.btnBuild.on("click", obj.btnBuild_OnClick, obj);
	}
	obj.btnQuery_OnClick = function()
	{
		obj.ResultGridPanelStore.removeAll();
		if (obj.cboAnalysisType.getValue()=='')
		{
			//ExtTool.alert("��ʾ","��ѡ��ͳ������!");
			ExtTool.alert("��ʾ","��ѡ��ͳ�Ʒ�ʽ!");	//	Modified by zhaoyu 2012-11-16 ��ѯͳ��--�ٴ�·���±���-�����롾ͳ�Ʒ�ʽ��ֱ�ӵ������ѯ������ʾ"��ѡ��ͳ������" ȱ�ݱ��168
			return;
		}
		obj.ResultGridPanelStore.load({});
	}
	obj.btnExport_OnClick = function(){
		var strFileName="ҽ�ƻ����ٴ�·��������Ϣ�±���";
		var ctloc=obj.cboLoc.getRawValue();
		if (ctloc==""){
			strFileName=strFileName+"-ȫԺ";
		}
		else{
			strFileName=strFileName+"-"+ctloc;
		}
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.ResultGridPanel,strFileName);
	}
	//Add BY Niucaicai 2011-08-18 �Զ����������������� ��ť�¼�
	obj.btnBuild_OnClick = function()
	{
		var dfDateFrom = obj.dfDateFrom.getRawValue();
		var dfDateTo = obj.dfDateTo.getRawValue();
		if((dfDateFrom=="")||(dfDateTo==""))
		{
			ExtTool.alert("��ʾ","��ʼ���ڡ��������ڶ�����Ϊ��!!");
			return;
		}
		var objClinPathWayAnalysisBat = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWayAnalysisBat");
		var ret = objClinPathWayAnalysisBat.BatchAnalysisData(dfDateFrom,dfDateTo,0);
		if(ret<0)
		{
			ExtTool.alert("��ʾ","��ʼ����ʧ��!!");
			return;
		}
		if(ret>=0)
		{
			ExtTool.alert("��ʾ","��ʼ���ݳɹ����� "+ret+" ������!");
			return;
		}
	}
}
