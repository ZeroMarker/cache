//页面Gui
function InitCtlResultWin(){
	var obj = new Object();
    obj.ResultID="";
 
	//设置开始日期为当月1号
	var mydate = new Date($.form.GetCurrDate('-'));
	mydate.setDate(1);
	$.form.MonthRender('DateFrom',$.form.GetCurrDate('-').substr(0,7));
    $.form.MonthRender('DateTo',$.form.GetCurrDate('-').substr(0,7));
	$.form.iCheckRender();  //渲染复选框|单选钮
    
	//初始化高度
	var wh = $(window).height();
    $("#divLeft").height(wh-10);
    $("#divMain").height(wh);
	$("#divPanel").height(wh-65);
	//自适应高度
	$(window).resize(function(){
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