//页面Event
function InitSusAbQueryWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
	    obj.chkStatus();
	    $('#FBDSusQuery').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	    obj.FBDQueryLoad();
		//查询
		$('#btnQuery').on('click', function(){
			obj.btnQuery_click();
		});
		//选择导出
		$('#btnExportSel').on('click', function(){
			obj.btnExportSel_click();
		});
		//全部导出
		$('#btnExportAll').on('click', function(){
			obj.btnExportAll_click();
		});
	
		//疾病名称选择事件
		$HUI.combobox("#cboDiseaseDesc", {
			onSelect:function(){
				obj.FBDQueryLoad();
			}
		});
	}
    
	obj.btnQuery_click = function() {
		var repStatus = obj.GetStatus();
		if (repStatus == ''){
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
		obj.FBDQueryLoad();
	}
	obj.btnExportSel_click = function() {
		var rows = obj.gridFBDQuery.getRows().length;  
		if (rows>0) {
			var length = obj.gridFBDQuery.getChecked().length;
			if (length>0) {
				$('#FBDSusQuery').datagrid('toExcel', {
				    filename: '疑似食源性疾病报告查询表.xls',
				    rows: obj.gridFBDQuery.getChecked(),
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
	obj.btnExportAll_click = function() {
		var rows = obj.gridFBDQuery.getRows().length;  
		if (rows>0) {
			$('#FBDSusQuery').datagrid('toExcel','疑似食源性疾病报告查询表.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
	}
	
	//打开链接
	obj.OpenFBDSusReport = function(aReportID,aEpisodeID) {
		var strUrl = "./dhcma.fbd.susabrep.csp?1=1&EpisodeID=" + aEpisodeID+"&ReportID=" + aReportID+ "&LocFlag=" + LocFlag;
	    websys_showModal({
			url:strUrl,
			title:'疑似食源性疾病报告',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1320,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.FBDQueryLoad();  
			} 
		});
	}
	obj.gridReport_rowdbclick = function() {
		var rowData = obj.gridFBDQuery.getSelected();
		var index = obj.gridFBDQuery.getRowIndex(rowData);  //获取当前选中行的行号(从0开始)
		
		var strUrl = "./dhcma.fbd.susabrep.csp?1=1"
		strUrl = strUrl + "&PatientID=" + rowData["PatientID"];
		strUrl = strUrl + "&EpisodeID=" + rowData["EpisodeID"];
		strUrl = strUrl + "&ReportID=" + rowData["ID"];
		strUrl = strUrl + "&LocFlag=" + LocFlag;
		
		websys_showModal({
			url:strUrl,
			title:'疑似食源性疾病报告',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1320,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.FBDQueryLoad();  
			} 
		});
	}
	
	obj.FBDQueryLoad = function(){
		$("#FBDSusQuery").datagrid("loading");	
		$cm ({
		   ClassName:"DHCMed.FBDService.SusAbRepSrv",
			QueryName:"QryReportByDate",		
			aStaDate: $('#dtStaDate').datebox('getValue'), 
			aEndDate: $('#dtEndDate').datebox('getValue'), 
			aDateType: $('#cboDateType').combobox('getValue'), 
			aStatusList:obj.GetStatus(),   
			aRepLoc: $('#cboReportLoc').combobox('getValue'),
			aPatType: $('#cboPatType').combobox('getValue'),
			aDisCateID: $('#cboDiseaseCate').combobox('getValue'),	
			aDiseaseID: $('#cboDiseaseDesc').combobox('getValue'),
			aHospID: $('#cboHospital').combobox('getValue'),
	    	page:1,
			rows:999
		},function(rs){
			$('#FBDSusQuery').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }
	
}