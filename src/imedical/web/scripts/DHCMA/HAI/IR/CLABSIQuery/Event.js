//页面Event
function InitScreeningWinEvent(obj){	
	
	obj.LoadEvent = function(args){
		//查询
		$('#btnQuery').on('click', function(){
			obj.reloadgridReport();
		});
		//导出
		$('#btnExport').on('click', function(){
			obj.btnExport_click();
		});
	}
	//重新加载表格数据
	obj.reloadgridReport = function(){
		var ErrorStr="";
		var HospIDs=$("#cboHospital").combobox('getValue');
	    var DateFrom=$("#DateFrom").datebox('getValue');
	    var DateTo=$("#DateTo").datebox('getValue');
	    if (!HospIDs) {
			ErrorStr += '请选择院区!<br/>';
		}
		if (DateFrom=="") {
			ErrorStr += '请选择开始日期!<br/>';
		}
		if (DateTo == "") {
			ErrorStr += '请选择结束日期!<br/>';
		}
		if (Common_CompareDate(DateFrom,DateTo)) {
			ErrorStr += '开始日期不能大于结束日期!<br/>';
		}
		if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}
		obj.gridReportLoad();
		$('#gridReport').datagrid('unselectAll');

	};
	obj.gridReportLoad = function(){
		$cm ({
		    ClassName:'DHCHAI.IRS.CCScreeningSrv',
		    QueryName:'QryCLABSIList',
		    aHospIDs:$("#cboHospital").combobox('getValue'),
	        aDateFrom:$("#DateFrom").datebox('getValue'),
	        aDateTo:$("#DateTo").datebox('getValue'),
	        aIsFinDel:Common_RadioValue("radDimension"),
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridReport').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);	
			$('#gridReport').datagrid('selectRow', obj.rowIndex );				
		});
    }
	
	obj.btnExport_click = function() {	
		var rows=$("#gridReport").datagrid('getRows').length;	
		if (rows>0) {
			$('#gridReport').datagrid('toExcel','CLABSI患者查询.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
	}
	//电子病历
	obj.btnEmrRecord_Click = function(EpisodeID)
	{		
		var rst = $m({
			ClassName:"DHCHAI.DPS.PAAdmSrv",
			MethodName:"GetPaAdmHISx",
			aEpisodeID:EpisodeID
		},false);
		if(rst=="")return;
		var EpisodeID = rst.split("^")[0];
		var PatientID = rst.split("^")[1];
		var strUrl = cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&DefaultOrderPriorType=ALL&2=2';
		if(obj.flg=="1"){
			websys_showModal({
				url:strUrl,
				title:$g("电子病历"),
				iconCls:'icon-w-epr',
				closable:true,
				width:'95%',
				height:'95%'
			});
		}
		else{
			var page= websys_createWindow(strUrl,"","width=95%,height=95%");
		}
	};
	//摘要信息
	obj.btnAbstractMsg_Click = function(aEpisodeID){
		var t=new Date();
		t=t.getTime();
		var strUrl = "./dhchai.ir.view.main.csp?PaadmID=" + aEpisodeID + "&PageType=WinOpen&t=" + t;
		websys_showModal({
			url:strUrl,
			title:'医院感染集成视图',
			iconCls:'icon-w-paper',  
			width:'95%',
			height:'95%'
		});
	}
	//单人疑似筛查
	obj.PatScreenShow = function(EpisodeID) {
		var t=new Date();
		t=t.getTime();
		var strUrl = "./dhcma.hai.ir.patscreening.csp?1=1&EpisodeDr=" + EpisodeID+'&1=1';
		websys_showModal({
			url:strUrl,
			title:'疑似病例筛查',
			iconCls:'icon-w-paper',  
	        originWindow:window,
			width:'95%',
			height:'95%',
			onBeforeClose:function(){}  //若无词句,IE下打开一份报告关闭后，摘要无法关闭
		});
	}
	
}
