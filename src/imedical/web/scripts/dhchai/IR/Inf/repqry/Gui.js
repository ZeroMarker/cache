//页面Gui
function InitCtlResultWin(){
	var obj = new Object();
    obj.ResultID="";
 
	//设置开始日期为当月1号
	var currDate = $.form.GetCurrDate('-');
	var arrDate = currDate.split('-');
	var dateFrom = arrDate[0] + "-" + arrDate[1] + "-01"
    $.form.DateTimeRender('DateFrom',dateFrom);
    $.form.DateTimeRender('DateTo',$.form.GetCurrDate('-'));
	
	//初始化高度
	var wh = $(window).height();
	if (flag=='1'){$("#divLeft").hide();}
    $("#divLeft").height(wh-10);
    $("#divMain").height(wh);
	$("#divPanel").height(wh-65);
	//自适应高度
	$(window).resize(function(){
		$("#gridReport_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridReport tr td:first"));
		var wh = $(window).height();
		$("#divLeft").height(wh-10);
		$("#divMain").height(wh);
		$("#divPanel").height(wh-65);
	});
	
	$("#divLeft").mCustomScrollbar({
		//scrollButtons: { enable: true },
		//autoHideScrollbar: true,
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	$("#divMain").mCustomScrollbar({
		//scrollButtons: { enable: true },
		//autoHideScrollbar: true,
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
    $("#divPanel").mCustomScrollbar({
		//scrollButtons: { enable: true },
		//autoHideScrollbar: true,
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});

	
	
	InitCtlResultWinEvent(obj);
	return obj;
}