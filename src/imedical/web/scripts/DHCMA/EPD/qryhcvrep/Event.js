//页面Event
function InitviewScreenEvent(obj){
	obj.LoadEvent = function(args){ 
	    $('#HcvQuery').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	    obj.HcvQueryLoad();
		//查询
		$('#btnQuery').on('click', function(){
			obj.btnQuery_click();
		});
		//导出
		$('#btnExport').on('click', function(){
			obj.btnExport_click();
		});
		//全部导出
		$('#btnExportAll').on('click', function(){
			obj.btnExportAll_click();
		});
	}
	
	//查询
	obj.btnQuery_click = function() {
		if (Common_CheckboxValue('chkStatus') == ''){
			$.messager.alert("提示","请选择报告状态！",'info');
			return;
		}
		var StaDate = $('#dtStaDate').datebox('getValue');
		var EndDate = $('#dtEndDate').datebox('getValue');
		if ((StaDate == '')||(EndDate == '')) {
			$.messager.alert("提示","开始日期、结束日期不允许为空!");
			return;
		}
		if (Common_CompareDate(StaDate,EndDate)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!");
			return;
		}
		obj.HcvQueryLoad();
	}
	
	//导出
	obj.btnExport_click  = function(){
		var rows = obj.gridHcvQuery.getRows().length;  
		if (rows>0) {
			var length = obj.gridHcvQuery.getChecked().length;
			if (length>0) {
				$('#HcvQuery').datagrid('toExcel', {
				    filename: '丙肝病例个案调查表.xls',
				    rows: obj.gridHcvQuery.getChecked(),
				    worksheet: 'Worksheet'
				});
			} else {
				$.messager.alert("提示", "先选择查询记录,再进行导出!",'info');
				return;
			} 
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
	
	//全部导出
	obj.btnExportAll_click = function() {
		var rows = obj.gridHcvQuery.getRows().length;	
		if (rows>0) {
			$('#HcvQuery').datagrid('toExcel','丙肝病例个案调查表.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
	}

	//打开链接
	obj.OpenHCVReport = function(aReportID,aEpisodeID) {
		var strUrl = "./dhcma.epd.hcvreg.csp?1=1&EpisodeID="+aEpisodeID+"&ReportID=" + aReportID + "&LocFlag=" + LocFlag;
	    websys_showModal({
			url:strUrl,
			title:'丙肝病例个案调查表',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1320,
			height:'95%',
			onBeforeClose:function(){
				//window.location.reload();  //刷新当前界面
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