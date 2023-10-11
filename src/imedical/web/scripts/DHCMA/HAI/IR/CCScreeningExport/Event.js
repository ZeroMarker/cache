//页面Event
function InitCCScreenExportWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
		$('#btnExport').on('click', function(){
	     	obj.btnExport_click();
     	});
		obj.gridScreenExportLoad();
	}
	
	obj.gridScreenExportLoad = function() {
		$("#ScreenExport").datagrid("loading");
		$cm ({
			ClassName:'DHCHAI.IRS.CCScreeningSrv',
			QueryName:'QryScreenAllInfo',
			aTypeFlag: aTypeFlag,
	    	aDateFrom: aDateFrom,
	    	aDateTo: aDateTo,
	    	aHospIDs: aHospIDs,
	    	aViewFlag: aViewFlag,
	    	aGroupUser: aGroupUser,
	    	aPatInfo: aPatInfo,
	    	aShowType: aShowType,
			page:1,
			rows:9999
		},function(rs){
			$('#ScreenExport').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs).datagrid('loaded');
		});
	}
	
	//摘要信息
	obj.OpenView = function(aEpisodeID){
		var t=new Date();
		t=t.getTime();
		var strUrl = "./dhchai.ir.view.main.csp?PaadmID=" + aEpisodeID + "&PageType=WinOpen&t=" + t;
		/*
		websys_showModal({
			url:strUrl,
			title:'医院感染集成视图',
			iconCls:'icon-w-paper',  
			width:'95%',
			height:'95%'
		});
		*/
		//Open窗体
		var oWin = websys_createWindow(strUrl,'',"height=" + (window.screen.availHeight - 50) + ",width=" + (window.screen.availWidth - 50) + ",top=0,left=100,resizable=no");
	}
	
	//导出
	obj.btnExport_click  = function(){
		var rows = obj.gridScreenExport.getRows().length;
		if (rows>0) {
			$('#ScreenExport').datagrid('toExcel', '疑似病例筛查列表.xls');
		}else {
			$.messager.alert("提示", "无数据记录,不允许导出", 'info');
		}	
	}
}
