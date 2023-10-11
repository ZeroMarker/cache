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
			obj.btnExportAll_click();
		});
	}
	
	//查询
	obj.btnQuery_click = function() {
		
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
	//全部导出
	obj.btnExportAll_click = function() {
		var rows = obj.gridHcvQuery.getRows().length;	
		if (rows>0) {
			$('#HcvQuery').datagrid('toExcel','丙肝转介单.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
	}

	//打开链接
	obj.OpenHCVRefReport = function(aReportID,aEpisodeID) {
		var strUrl = "./dhcma.epd.hcvreferral.csp?1=1&EpisodeID="+aEpisodeID+"&ReportID=" + aReportID +"&LocFlag=" + LocFlag;
	   	websys_showModal({
			url:strUrl,
			title:'丙肝转介单',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1320,
			height:480,
			onBeforeClose:function(){
				//window.location.reload();  //刷新当前界面
				obj.HcvQueryLoad();
			} 
		});
	}

	obj.HcvQueryLoad = function(){
		$("#HcvQuery").datagrid("loading");	
		$cm ({
		    ClassName:"DHCMed.EPDService.HCVReferralSrv",
			QueryName:"QryReportByDate",	
			aHospID: $('#cboHospital').combobox('getValue'),	
			aStaDate: $('#dtStaDate').datebox('getValue'), 
			aEndDate: $('#dtEndDate').datebox('getValue'), 
			aStatusList:Common_CheckboxLabel('chkStatus'),   
			page:1,
			rows:200
		},function(rs){
			$('#HcvQuery').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
		
    }

}