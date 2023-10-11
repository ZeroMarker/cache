//页面Event
function InitDMReportListEvent(obj){	
    
	obj.LoadEvent = function(args){ 
		$('#gridDeath').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		//查询
		$('#btnFind').on('click', function(){
			obj.btnFind_click();
		});
		//导出
		$('#btnExport').on('click', function(){
			obj.btnExport_click();
		});
		//导出明细
		$('#btnExportDtl').on('click', function(){
			obj.btnExportDtl_click();
		});
		
		$('#DTHLogDetail').dialog({
			title: '死亡报告历史操作记录',
			iconCls:'icon-w-paper',
			closed: true,
			modal: true,
			isTopZindex:false
		});
		
		//登记号回车查询事件
		$('#txtRegNo').keydown(function (e) {
			var e = e || window.event;
			if (e.keyCode == 13) {
				RegNo=$('#txtRegNo').val().replace(/(^\s*)|(\s*$)/g, "");
				if ($.trim(RegNo)=="") return;
				var Reglength=RegNo.length;
				for(var i=0;i<(10-Reglength);i++)
				{
					RegNo="0"+RegNo;
				}
				$('#txtRegNo').val(RegNo);
				obj.gridDeathReportLoad();
			}	
		});
	}
    
	obj.btnFind_click = function() {
		var startDate = $('#txtStartDate').datebox('getValue')
		var endDate = $('#txtEndDate').datebox('getValue')
		if ((startDate == '')||(endDate == '')) {
			$.messager.alert("提示","开始日期、结束日期不允许为空!");
		}
		if (Common_CompareDate(startDate,endDate)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!");
		}
		obj.gridDeathReportLoad();
	}
	
	obj.btnExport_click = function() {
		var rows = obj.gridDeathReport.getRows().length; 
		if (rows>0) {
			if (BrowserVer=="isLessIE11") {  //IE11以下版本使用原先导出方式
				var aSttDate   = $('#txtStartDate').datebox('getValue'); 
				var aEndDate   = $('#txtEndDate').datebox('getValue');
				var aRepLoc    = $('#cboRepLoc').combobox('getValue'); 
				var aHospital  = $('#cboSSHosp').combobox('getValue');   
				var aRepStatus = $('#cboRepStatus').combobox('getValue');
				var aPatName   = $('#txtPatName').val();
				var aMrNo      = $('#txtMrNo').val();	
				var aRegNo     = $('#txtRegNo').val();
				
				var Arg=aSttDate+"^"+aEndDate+"^"+aRepLoc+"^"+aHospital+"^"+aRepStatus+"^"+aPatName+"^"+aMrNo+"^"+aRegNo;
				ExportDataToExcel("","","死亡证明书查询列表",Arg);
			}else {
				//ExportToExcel();
				$('#gridDeath').datagrid('toExcel','死亡证明书查询列表.xls');
			}
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
	}
	obj.btnExportDtl_click = function() {
		var rows = obj.gridDeathReport.getRows().length;  
		if (rows>0) {
			if (BrowserVer=="isLessIE11") {  //IE11以下版本使用原先导出方式
				var aSttDate   = $('#txtStartDate').datebox('getValue'); 
				var aEndDate   = $('#txtEndDate').datebox('getValue');
				var aRepLoc    = $('#cboRepLoc').combobox('getValue'); 
				var aHospital  = $('#cboSSHosp').combobox('getValue');   
				var aRepStatus = $('#cboRepStatus').combobox('getValue');
				var aPatName   = $('#txtPatName').val();
				var aMrNo      = $('#txtMrNo').val();	
				var aRegNo     = $('#txtRegNo').val();
				
				var Arg=aSttDate+"^"+aEndDate+"^"+aRepLoc+"^"+aHospital+"^"+aRepStatus+"^"+aPatName+"^"+aMrNo+"^"+aRegNo;
				ExportDataToExcelNP("","","死亡证明书明细表",Arg);
			} else {
				ExportDtlToExcel();
			}
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
	}

	//打开链接
	obj.OpenDeathReport = function(aEpisodeID,aReportID) {
		var strUrl = "./dhcma.dth.report.csp?1=1&EpisodeID="+aEpisodeID+"&ReportID=" + aReportID ;
	    websys_showModal({
			url:strUrl,
			title:'居民死亡医学证明（推断）书',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			closable:false,
			width:1320,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			dataRow:{RowID:aReportID},
			onBeforeClose:function(){
				obj.gridDeathReportLoad();  //刷新
			} 
		});
	}
	obj.gridDeathReport_click = function(rowData) {
	
		var ReportID  = rowData["RowID"];
        var PatientID = rowData["PatientID"];
        var EpisodeID = rowData["EpisodeID"];
     
        var strUrl = "./dhcma.dth.report.csp?1=1&EpisodeID="+EpisodeID+"&ReportID=" + ReportID ;
	    websys_showModal({
			url:strUrl,
			title:'居民死亡医学证明（推断）书',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			closable:false,
			width:1320,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.gridDeathReportLoad();  //刷新
			} 
		});
	}
	
	obj.OpenPrintReason =function(aReportID) {		
	    var strUrl = "./dhcma.dth.printreason.csp?1=1&ReportID=" + aReportID ;					   
        websys_showModal({
			url:strUrl,
			title:'死亡证明书打印明细',
			iconCls:'icon-w-paper',  
	        originWindow:window,
			width:880,
			height:520
		});
    }
    
	obj.gridDeathReportLoad = function(){	
		$cm ({
			ClassName:"DHCMed.DTHService.ReportSrv",
			QueryName:"QryReportInfo",		
			aSttDate: $('#txtStartDate').datebox('getValue'), 
			aEndDate: $('#txtEndDate').datebox('getValue'), 
			aRepLoc: $('#cboRepLoc').combobox('getValue'), 
			aHospital:$('#cboSSHosp').combobox('getValue'),   
			aRepStatus: $('#cboRepStatus').combobox('getValue'),
			aPatName: $('#txtPatName').val(),
			aMrNo: $('#txtMrNo').val(),	
			aRegNo: $('#txtRegNo').val(),
	    	page:1,
			rows:999
		},function(rs){
			$('#gridDeath').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }
	obj.OpenEMR =function(aEpisodeID,aPatientID) {
		var strUrl = cspUrl+"&PatientID=" + aPatientID+"&EpisodeID="+aEpisodeID + "&2=2";
		//var strUrl = "./emr.record.browse.csp?PatientID=" + aPatientID+"&EpisodeID="+aEpisodeID + "&2=2";
	    websys_showModal({
			url:strUrl,
			title:'病历浏览',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:'98%',
			height:'98%'
		});
	}
	obj.OpenLog = function(aReportID) {
		$HUI.dialog('#DTHLogDetail').open();
		$cm ({
			ClassName:"DHCMed.DTHService.ReportSrv",
			QueryName:"QryDTHReportLog",
			aReportID:aReportID,
			aFromDate: "",
			aToDate: "",
			aHospital: "",
			aLoc: "",
			aStatusCode: ""
		},function(rs){
			$("#gridDTHLogInfo").datagrid("loaded");
			$('#gridDTHLogInfo').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
		});
	}
}