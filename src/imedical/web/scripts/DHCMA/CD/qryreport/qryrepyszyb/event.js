//页面Event
function InitViewportEvent(obj){	
    
	obj.LoadEvent = function(args){ 
		$('#gridRepInfo').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		//查询
		$('#btnQuery').on('click', function(){
			obj.btnQuery_click();
		});
		//导出
		$('#btnExport').on('click', function(){
			obj.btnExport_click();
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
				obj.gridRepInfoLoad();
			}	
		});
	}
    
	obj.btnQuery_click = function() {
		var FromDate = $('#txtFromDate').datebox('getValue')
		var ToDate = $('#txtToDate').datebox('getValue')
		if ((FromDate == '')||(ToDate == '')) {
			$.messager.alert("提示","开始日期、结束日期不允许为空!");
		}
		if (Common_CompareDate(FromDate,ToDate)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!");
		}
		obj.gridRepInfoLoad();
	}
	obj.btnExport_click = function() {
		var rows = obj.gridRepInfo.getRows().length;  
		if (rows>0) {
			$('#gridRepInfo').datagrid('toExcel','疑似职业病报告查询表.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
	}

	//打开链接
	obj.OpenReport = function(aReportID,aEpisodeID) {
		var strUrl= "./dhcma.cd.reportyszyb.csp?1=1&ReportID=" + aReportID + "&EpisodeID=" + aEpisodeID ;
	    websys_showModal({
			url:strUrl,
			title:'职业病报卡',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1320,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			dataRow:{ReportID:aReportID},  
			onBeforeClose:function(){
				obj.gridRepInfoLoad();  //刷新
			} 
		});
	}
	
	obj.gridRepInfo_click = function() {
		var rowData = obj.gridRepInfo.getSelected();
		var index = obj.gridRepInfo.getRowIndex(rowData);  //获取当前选中行的行号(从0开始)
		
		var ReportID = rowData["ReportID"];
		var EpisodeID = rowData["EpisodeID"];
        var strUrl= "./dhcma.cd.reportyszyb.csp?1=1&ReportID=" + ReportID + "&EpisodeID=" + EpisodeID ;

	    websys_showModal({
			url:strUrl,
			title:'职业病报卡',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1320,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			dataRow:{ReportID:ReportID},  
			onBeforeClose:function(){
				obj.gridRepInfoLoad();  //刷新
			} 
		});
	}
	
	obj.gridRepInfoLoad = function(){	
		$("#gridRepInfo").datagrid("loading");		
		$cm ({
			ClassName:"DHCMed.CDService.QryService",
			QueryName:"QryYSZYBRepByDate",		
			aFromDate: $('#txtFromDate').datebox('getValue'), 
			aToDate: $('#txtToDate').datebox('getValue'),
			aHospID:$('#cboHospital').combobox('getValue'),   			
			aRepLoc: $('#cboRepLoc').combobox('getValue'), 
			aRepStatus: Common_CheckboxValue('chkStatusList'),
	    	page:1,
			rows:999
		},function(rs){
			$('#gridRepInfo').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }
	
}