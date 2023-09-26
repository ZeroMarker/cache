//页面Event
function InitviewScreenEvent(obj){	
    
	obj.LoadEvent = function(args){ 
	    $('#InvQuery').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	    obj.InvQueryLoad();
		//查询
		$('#btnQuery').on('click', function(){
			obj.btnQuery_click();
		});
		
		//全部导出
		$('#btnExport').on('click', function(){
			obj.btnExport_click();
		});
	}
    
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
		obj.InvQueryLoad();
	}
	
	obj.btnExport_click = function() {
		var rows = obj.gridInvQuery.getRows().length;	
		if (rows>0) {
			$('#InvQuery').datagrid('toExcel','新冠肺炎个案调查登记表.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
	}
	
	//打开链接
	obj.OpenNCPReport = function(aReportID,aEpisodeID) {
		var strUrl = "./dhcma.epd.ncp.investigation.csp?1=1&EpisodeID="+aEpisodeID+"&ReportID=" + aReportID + "&LocFlag=" + LocFlag;
	    websys_showModal({
			url:strUrl,
			title:'新冠肺炎个案调查',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1320,
			height:'95%',
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
	}
	obj.gridReport_rowdbclick = function(rowData) {
      
		var strUrl = "./dhcma.epd.ncp.investigation.csp?1=1"
		strUrl = strUrl + "&EpisodeID=" + rowData["EpisodeID"];
		strUrl = strUrl + "&ReportID=" + rowData["ReportID"];
		strUrl = strUrl + "&LocFlag=" + LocFlag;
		
		websys_showModal({
			url:strUrl,
			title:'新冠肺炎个案调查',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1320,
			height:'95%',
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
	}
	
	obj.InvQueryLoad = function(){
		$("#InvQuery").datagrid("loading");	
		$cm ({
		    ClassName:"DHCMed.EPDService.NCPInvestigationSrv",
			QueryName:"QryReportByDate",	
			aHospID: $('#cboHospital').combobox('getValue'),		 
			aDateType: $('#cboDateType').combobox('getValue'),
			aStaDate: $('#dtStaDate').datebox('getValue'), 
			aEndDate: $('#dtEndDate').datebox('getValue'), 
			aStatusList:Common_CheckboxValue('chkStatus'),   
			page:1,
			rows:200
		},function(rs){
			$('#InvQuery').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
		
    }
	
}