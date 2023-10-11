//ҳ��Event
function InitviewScreenEvent(obj){
	obj.LoadEvent = function(args){ 
	    $('#HcvQuery').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
	    obj.HcvQueryLoad();
		//��ѯ
		$('#btnQuery').on('click', function(){
			obj.btnQuery_click();
		});
		//����
		$('#btnExport').on('click', function(){
			obj.btnExport_click();
		});
		//ȫ������
		$('#btnExportAll').on('click', function(){
			obj.btnExportAll_click();
		});
	}
	
	//��ѯ
	obj.btnQuery_click = function() {
		if (Common_CheckboxValue('chkStatus') == ''){
			$.messager.alert("��ʾ","��ѡ�񱨸�״̬��",'info');
			return;
		}
		var StaDate = $('#dtStaDate').datebox('getValue');
		var EndDate = $('#dtEndDate').datebox('getValue');
		if ((StaDate == '')||(EndDate == '')) {
			$.messager.alert("��ʾ","��ʼ���ڡ��������ڲ�����Ϊ��!");
			return;
		}
		if (Common_CompareDate(StaDate,EndDate)>0) {
			$.messager.alert("��ʾ","��ʼ���ڲ��ܴ��ڽ�������!");
			return;
		}
		obj.HcvQueryLoad();
	}
	
	//����
	obj.btnExport_click  = function(){
		var rows = obj.gridHcvQuery.getRows().length;  
		if (rows>0) {
			var length = obj.gridHcvQuery.getChecked().length;
			if (length>0) {
				$('#HcvQuery').datagrid('toExcel', {
				    filename: '���β������������.xls',
				    rows: obj.gridHcvQuery.getChecked(),
				    worksheet: 'Worksheet'
				});
			} else {
				$.messager.alert("��ʾ", "��ѡ���ѯ��¼,�ٽ��е���!",'info');
				return;
			} 
		}else {
			$.messager.alert("ȷ��", "�����ݼ�¼,��������", 'info');
			return;
		}	
	}
	
	//ȫ������
	obj.btnExportAll_click = function() {
		var rows = obj.gridHcvQuery.getRows().length;	
		if (rows>0) {
			$('#HcvQuery').datagrid('toExcel','���β������������.xls');
		}else {
			$.messager.alert("ȷ��", "�����ݼ�¼,��������", 'info');
			return;
		}
	}

	//������
	obj.OpenHCVReport = function(aReportID,aEpisodeID) {
		var strUrl = "./dhcma.epd.hcvreg.csp?1=1&EpisodeID="+aEpisodeID+"&ReportID=" + aReportID + "&LocFlag=" + LocFlag;
	    websys_showModal({
			url:strUrl,
			title:'���β������������',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1320,
			height:'95%',
			onBeforeClose:function(){
				//window.location.reload();  //ˢ�µ�ǰ����
				obj.HcvQueryLoad();
			} 
		});
	}

	obj.HcvQueryLoad = function(){
		$("#HcvQuery").datagrid("loading");	
		$cm ({
		    ClassName:"DHCMed.EPDService.HCVReportSrv",
			QueryName:"QryReportByDate",	
			aHospID: $('#cboHospital').combobox('getValue'),		 
			aDateType: $('#cboDateType').combobox('getValue'),
			aStaDate: $('#dtStaDate').datebox('getValue'), 
			aEndDate: $('#dtEndDate').datebox('getValue'), 
			aStatusList:Common_CheckboxValue('chkStatus'),   
			page:1,
			rows:200
		},function(rs){
			$('#HcvQuery').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
		
    }

}