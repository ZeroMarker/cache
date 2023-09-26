//页面Gui
function InitReportWin(){
	var obj = new Object();
	obj.ReportID="";  //  报告ID 保存不关闭后直接提交，是生成两份报告
	//日期控件及初始化
	obj.ClickCnt = 0;
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //渲染下拉框
	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	
	$.form.DateTimeRender('startDate',$.form.GetCurrDate('-'));
	$.form.DateTimeRender('endDate',$.form.GetCurrDate('-'));
	$.form.SelectRender("#cboIntuType");
	
	$("#startDate").on('change',function(ev){
		var  sDt=$("#startDate").val();
		var  eDt=$("#endDate").val();		
		if(sDt==""||eDt=="")
		{
			return;
		}
		var d1 = new Date(sDt.replace(/\-/g, "\/"));  
		var d2 = new Date(eDt.replace(/\-/g, "\/"));
		if(sDt!=""&&eDt!=""&&d1>d2)  
		{  
			//layer.alert('开始日期不能大于结束日期！');
			layer.tips('开始日期不能大于结束日期！', '#startDate', {tips: [1,'#3595CC'],time: 3000});
			$("#startDate").val("");
			return;
		}
	});
	
	$("#endDate").on('change',function(ev){
		var  sDt=$("#startDate").val();
		var  eDt=$("#endDate").val();		
		if(sDt==""||eDt=="")
		{
			return;
		}
		var d1 = new Date(sDt.replace(/\-/g, "\/"));  
		var d2 = new Date(eDt.replace(/\-/g, "\/"));
		if(sDt!=""&&eDt!=""&&d1>d2)  
		{  
			//layer.alert('开始日期不能大于结束日期！');
			layer.tips('开始日期不能大于结束日期！', '#startDate', {tips: [1,'#3595CC'],time: 3000});
			$("#startDate").val("");
			return;
		}
	});
	
	$("#ulPaadmStatus").val("0");	
	//在科病人列表	
	//默认表格显示icu
	//条件初始化赋值
	$("#ulOeItem").val("0");
	$("#ulNOeItem").val("0");
	
	//自适应高度
	var wh = $(window).height();
    $("#divLeft").height(wh-10);
    $("#divMain").height(wh-1);
    $("#divPanel").height(wh-245);
	
	//自适应高度
	$(window).resize(function(){
		$("#gridLogs_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridLogs tr td:first"));
		$("#gridLogsN_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridLogsN tr td:first"));
		var wh = $(window).height();
		$("#divLeft").height(wh-10);
		$("#divMain").height(wh-1);
		$("#divPanel").height(wh-245);
	});
	
	$("#divLeft").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	$("#divMain").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	$("#divPanel").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	$("#LayerICURep").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("#LayerNICURep").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});

	
	InitReportWinEvent(obj);
	InitReportNWinEvent(obj);  //NICU调查表事件
	return obj;
}