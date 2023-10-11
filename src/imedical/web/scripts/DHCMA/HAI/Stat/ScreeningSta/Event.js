//页面Event
function InitScreeningWinEvent(obj){	
	
	obj.LoadEvent = function(args){
		obj.LoadScreenSta();
		//查询
		$('#btnQuery').on('click', function(){
			obj.btnQuery_click();
		});
		//导出
		$('#btnExport').on('click', function(){
			obj.btnExport_click();
		});
	}
	
	obj.btnQuery_click = function() {	
		var DateFrom 	= $('#dtDateFrom').datebox('getValue');
		var DateTo		= $('#dtDateTo').datebox('getValue');
		var AdmStatus = $('#cboAdmStatus').combobox('getValue');
		if (Common_CompareDate(DateFrom,DateTo)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!", 'info');
			return;
		}
		var ret= $m ({
			ClassName:'DHCHAI.AMS.ScreenResultSrv',
			MethodName:'IsExitAssSta',
			aDateFrom:DateFrom,
			aDateTo:DateTo,
			aAdmStatus:AdmStatus
		},false);
		if (ret<1) {
			$("#ScreenSta").datagrid('loadData', { total: 0, rows: [] }); 
			if (Common_RadioValue("radShowType")=="E") {		
				obj.myChart.clear();
			}
			$.messager.alert("提示","当前疑似筛查结果数据尚未生成，请待数据生成后再查询!", 'info');
			return;
		}
		obj.LoadScreenSta();	
	}
	
	obj.btnExport_click = function() {	
		var Dimension = Common_RadioValue("radDimension");
		var rows=$("#ScreenSta").datagrid('getRows').length;			
		if (rows>0) {
			if (Dimension=="I") {   //指标维度
				$('#ScreenSta').datagrid('toExcel','疑似筛查分析-指标.xls');
			} else if (Dimension=="L") {
				$('#ScreenSta').datagrid('toExcel','疑似筛查分析-科室.xls');
			} else {
				$('#ScreenSta').datagrid('toExcel','疑似筛查分析-感染诊断.xls');
			}
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
	}
	
	$("#btnTips").popover({
		width:'1100px',
		height:'550px',
		content:'',
		trigger:'hover',
		type:'iframe',
		url:'../scripts/DHCMA/HAI/Stat/ScreeningSta/tips.html'
		
	});
	
	//窗体初始化
	obj.OpenDtl = function(aType,aRuleID){
		obj.Type = aType;
		if (aType==1) var title ='患者人数明细数据';
		if (aType==2) var title ='感染人数明细数据';
		if (aType==3) var title ='疑似人数明细数据';
		if (aType==4) var title ='确诊人数明细数据';
		if (aType==5) var title ='排除人数明细数据';
		if (aType==6) var title ='感染疑似人数明细数据';
		if (aType==7) var title ='感染非疑似人数明细数据';
		if (aType==8) var title ='疑似非感染人数明细数据';
		if (aType==9) var title ='非疑似感染人数明细数据';
		
		var HospIDs = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var AdmStatus = $('#cboAdmStatus').combobox('getValue');

		$('#RateDtl').show();
		obj.gridRateDtl.load({
		    ClassName:'DHCHAI.AMS.ScreenResultSrv',
			QueryName:'QrySuRuleRateDtl',
			aHospIDs:HospIDs,
			aDateFrom:DateFrom,
			aDateTo:DateTo,
			aAdmStatus:AdmStatus,
			aRuleID:aRuleID,
			aType:aType
	    });
	    
		$HUI.dialog('#RateDtl',{
			title:title,
			iconCls:'icon-w-paper',
			width: 1300,    
			height: 600, 
			modal: true,
			isTopZindex:true
		});
	}
	//窗体初始化
	obj.OpenDiagDtl = function(aType,aInfID){
		obj.Type = aType;
		if (aType==1) var title ='感染人数明细数据';
		if (aType==2) var title ='疑似人数明细数据';
		if (aType==3) var title ='确诊人数明细数据';
		if (aType==4) var title ='排除人数明细数据';
		if (aType==5) var title ='感染非疑似人数明细数据';
	
		var HospIDs = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var AdmStatus = $('#cboAdmStatus').combobox('getValue');

		$('#RateDtl').show();
		obj.gridRateDtl.load({
		    ClassName:'DHCHAI.AMS.ScreenResultSrv',
			QueryName:'QryDiagScreenDtl',
			aHospIDs:HospIDs,
			aDateFrom:DateFrom,
			aDateTo:DateTo,
			aAdmStatus:AdmStatus,
			aInfPosID:aInfID,
			aType:aType
	    });
	    
		$HUI.dialog('#RateDtl',{
			title:title,
			iconCls:'icon-w-paper',
			width: 1300,    
			height: 600, 
			modal: true,
			isTopZindex:true
		});
	}
	//窗体初始化
	obj.OpenLocDtl = function(aLocID,aType){
		obj.Type = aType;
		if (aType==1) var title ='患者人数明细数据';
		if (aType==2) var title ='感染人数明细数据';
		if (aType==3) var title ='疑似人数明细数据';
		if (aType==4) var title ='确诊人数明细数据';
		if (aType==5) var title ='排除人数明细数据';
		if (aType==6) var title ='未处置人数明细数据';
	
		var HospIDs = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var AdmStatus = $('#cboAdmStatus').combobox('getValue');

		$('#RateDtl').show();
		obj.gridRateDtl.load({
		    ClassName:'DHCHAI.AMS.ScreenResultSrv',
			QueryName:'QryLocScreenDtl',
			aHospIDs:HospIDs,
			aDateFrom:DateFrom,
			aDateTo:DateTo,
			aAdmStatus:AdmStatus,
			aLocID:aLocID,
			aType:aType
	    });
	    
		$HUI.dialog('#RateDtl',{
			title:title,
			iconCls:'icon-w-paper',
			width: 1300,    
			height: 600, 
			modal: true,
			isTopZindex:true
		});
	}
	
	
	//摘要信息
	obj.OpenView = function(aEpisodeID){
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
	
	//打开报告
    obj.btnDetail_Click =function(aReportID,aEpisodeID) {
		var strUrl="dhcma.hai.ir.inf.report.csp?1=1&Paadm=" + aEpisodeID + "&ReportID="+ aReportID + t;		
		websys_showModal({
			url:strUrl,
			title:'医院感染报告',
			iconCls:'icon-w-epr',  
			width:1320,
			height:'95%'
		});
	}
  
}
