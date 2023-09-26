function InitViewportEvent(obj){
		obj.LoadEvent=function(args){
		$('#gridTili').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		//查询
		$('#btnQuery').on('click', function(){
			obj.btnQuery_click();
		});
		//导出
		$('#btnExport').on('click', function(){
			obj.btnExport_click();
		});
	}
	
	//查询
	obj.btnQuery_click = function(){
		var FromDate = $('#txtFromDate').datebox('getValue')
		var ToDate = $('#txtToDate').datebox('getValue')
		if ((FromDate == '')||(ToDate == '')) {
			$.messager.alert("提示","开始日期、结束日期不允许为空!");
		}
		if (Common_CompareDate(FromDate,ToDate)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!");
		}
		obj.gridLoad();
		
	}
	
	obj.btnExport_click = function() {
		var rows = obj.gridTili.getRows().length;  
		if (rows>0) {
			$('#gridTili').datagrid('toExcel','流感样例报告.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
	}
	
	//双击事件
	obj.gridTili_rowdblclick = function(rowData){
		var ReportID = rowData["ReportID"];
		var EpisodeID = rowData["EpisodeID"];
		var strUrl= "dhcma.epd.reportili.csp?1=1&ReportID="+ReportID+"&EpisodeID="+EpisodeID;
	    websys_showModal({
			url:strUrl,
			title:'流感样病例报卡',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1320,
			height:'90%',
			dataRow:{ReportID:ReportID},  
			onBeforeClose:function(){
				obj.gridLoad();  //刷新当前页
			} 
		});
	}

	//打开链接
	obj.OpenReport = function(ReportID,EpisodeID) {
	   var strUrl= "dhcma.epd.reportili.csp?1=1&ReportID="+ReportID+"&EpisodeID="+EpisodeID;
	    websys_showModal({
			url:strUrl,
			title:'流感样病例报卡',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1320,
			height:'90%',
			dataRow:{ReportID:ReportID},  
			onBeforeClose:function(){
				obj.gridLoad();  //刷新当前页
			} 
		});
	}

	obj.gridLoad = function(){	
		$("#gridTili").datagrid("loading");		
		$cm ({
			ClassName:"DHCMed.EPDService.QryReportILI",
			QueryName:"QryILIRepByDate",
			aFromDate:$("#txtFromDate").datebox('getValue'),
			aToDate:$("#txtToDate").datebox('getValue'),
			aRepLoc:$("#cboRepLoc").combobox('getValue'),
			aRepStatus: Common_CheckboxValue('chkRepStatus'),
			aHosp:$("#cboHospital").combobox('getValue'),
	    	page:1,
			rows:200
		},function(rs){
			$('#gridTili').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }
}