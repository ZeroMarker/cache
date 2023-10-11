//页面Event
function InitOmissionWinEvent(obj){
	obj.LoadEvent = function(args){ 
		$("#btnQuery").on('click',function(){
			obj.reloadgridAdm();
		});
		$("#btnExport").on('click',function(){
			obj.btnExport_click();
		});
	}
	//重新加载表格数据
	obj.reloadgridAdm = function(){
		var ErrorStr="";
	    var DateFrom=$("#DateFrom").datebox('getValue')
	    var DateTo=$("#DateTo").datebox('getValue')
		if (DateFrom=="") {
			ErrorStr += '请选择开始日期!<br/>';
		}
		if (DateTo == "") {
			ErrorStr += '请选择结束日期!<br/>';
		}
		if ((Common_CompareDate(DateFrom,DateTo))) {
			ErrorStr += '开始日期不能大于结束日期!<br/>';
		}if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}
		$("#gridAdm").datagrid("loading");
        var Ret = $cm({
			ClassName:"DHCHAI.IRS.InfOmissionSrv",
			QueryName:"QryInfMisRep",
			aHospIDs:$("#cboHospital").combobox('getValue'),
			aLocID: $("#cboLocation").combobox('getValue'),
			aDateFrom:$("#DateFrom").datebox('getValue'),
			aDateTo:$("#DateTo").datebox('getValue'),
			InHospFlag:$("#chkInHospFlag").checkbox('getValue')? '1':'0',
            page: 1,
            rows: 99999
        }, function (rs) {
            $('#gridAdm').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
		});
	};
	//摘要
	obj.btnAbstractMsg_Click = function(EpisodeID)
	{	
	    var strUrl = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen';
		
		var Page=DHCCPM_Open(strUrl);    
	};
	//导出
	obj.btnExport_click = function() {
		var rows=$("#gridAdm").datagrid('getRows').length;
		if (rows>0) {
			$('#gridAdm').datagrid('toExcel','漏报患者列表'+$("#DateFrom").datebox('getValue')+"至"+$("#DateTo").datebox('getValue')+'.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
}

