function InitViewportEvent(obj) {
	obj.LoadEvent=function(args) {
		$('#gridTHIV').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.gridLoad();
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
		if (FromDate>Common_GetDate(new Date())){
			$.messager.alert("提示","开始日期不能大于当前日期!");
			return;
		}
		if (ToDate>Common_GetDate(new Date())){
			$.messager.alert("提示","结束日期不能大于当前日期!");
			return;
		}
		if ((FromDate == '')||(ToDate == '')) {
			$.messager.alert("提示","开始日期、结束日期不允许为空!");
			return;
		}
		if (Common_CompareDate(FromDate,ToDate)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!");
			return;
		}
		obj.gridLoad();
	}
	
	obj.btnExport_click = function() {
		var rows = obj.gridTHIV.getRows().length;  
		if (rows>0) {
			$('#gridTHIV').datagrid('toExcel','HIV个案随访表查询表.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
	}
	
	//双击事件
	obj.gridTHIV_rowdblclick = function(rowData){
		var ReportID = rowData["ReportID"];
		var EpisodeID = rowData["EpisodeID"];
		var PatientID = rowData["PatientID"];
		var strUrl= "dhcma.epd.hivfollow.csp?1=1&ReportID="+ReportID+"&EpisodeID="+EpisodeID+"&PatientID="+PatientID;
	    websys_showModal({
			url:strUrl,
			title:'HIV个案随访表',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1320,
			height:window.screen.availHeight-80,
			dataRow:{ReportID:ReportID},  
			onBeforeClose:function(){
				obj.gridLoad();
			} 
		});
	}
	
	//打开链接
	obj.OpenReport = function(aReportID,aEpisodeID,aPatientID) {
		var strUrl= "dhcma.epd.hivfollow.csp?1=1&ReportID="+aReportID+"&EpisodeID="+aEpisodeID+"&PatientID="+aPatientID;
	    websys_showModal({
			url:strUrl,
			title:'HIV个案随访表',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1320,
			height:window.screen.availHeight-80,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.gridLoad();
			} 
		});
	}
	
	obj.gridLoad = function(){	
		$("#gridTHIV").datagrid("loading");		
		$cm ({
			ClassName:"DHCMed.EPDService.CaseFollowSrv",
			QueryName:"QryHIVRepByDate",
			aFromDate:$("#txtFromDate").datebox('getValue'),
			aToDate:$("#txtToDate").datebox('getValue'),
			aFollowStatus: Common_CheckboxValue('chkRepStatus'),
			aHosp:$("#cboSSHosp").combobox('getValue'),
	    	page:1,
			rows:200
		},function(rs){
			$('#gridTHIV').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }

}