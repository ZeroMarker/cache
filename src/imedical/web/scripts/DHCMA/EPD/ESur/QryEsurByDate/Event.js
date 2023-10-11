function InitESurReportWinEvent(obj){
	
	obj.LoadEvent = function(args){ 
	
		$('#gridESurReport').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		//查询
		$('#btnQuery').on('click', function(){
			obj.ESurReportQuery();
		});
		$('#btnImport').on('click', function(){
			obj.btnExport_click();
		});
    }
    obj.btnExport_click = function() {
		var rows = obj.gridESurReport.getRows().length;  
		if (rows>0) {
			$('#gridESurReport').datagrid('toExcel','流调表查询列表.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
	}
	
    // 打开流调报告
    obj.OpenEsurView = function (aRegTypeID, aReportID,aEpisodeID) {
        var url = '../csp/dhcma.epd.esurreport.csp?&RegTypeID=' + aRegTypeID + '&ReportID=' + aReportID + '&EpisodeID=' + aEpisodeID;
        websys_showModal({
            url: url,
            title: '流行病学调查报告',
            iconCls: 'icon-w-paper',
			closable:true,  
            width: '1320',
            height: '95%',
            onBeforeClose: function () {
                obj.ESurReportQuery();
            }
        });
    }
    obj.ESurReportQuery = function(){
	    
		var DateFrom 	= $('#DateFrom').datebox('getValue');
		var DateTo 		= $('#DateTo').datebox('getValue');
		var PatName 	= $('#PatName').val();
		var RepStatus 	= Common_CheckboxLabel("chkRepStatus");
	    if ((DateFrom == '')||(DateTo == '')) {
			$.messager.alert("提示","开始日期、结束日期不允许为空!",'info');
			return;
		}
		if (Common_CompareDate(DateFrom,DateTo)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!",'info');
			return;
		}
	    
		$("#gridESurReport").datagrid("loading");	
		$cm ({
			ClassName: "DHCMed.EPDService.ESurRepSrv",
            QueryName: "QryESurByDate",
            aDateFrom: DateFrom,
            aDateTo:DateTo,
            aPatName:PatName,
            aRepStatus:RepStatus,
			page:1,
			rows:99999
		},function(rs){
			$('#gridESurReport').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);							
		});
	}
}