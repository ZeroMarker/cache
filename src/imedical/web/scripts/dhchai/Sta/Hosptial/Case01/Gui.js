//页面Gui
function InitCtlResultWin(){
	var obj = new Object();
    obj.ResultID="";
	
	var datevalue=$.form.MonthRender('DateFrom',$.form.GetCurrDate('-').substr(0,7));
	
	//初始化高度
	var wh = $(window).height();
    $("#divMain").height(wh);
	//自适应高度
	$(window).resize(function(){
		var wh = $(window).height();
		$("#divMain").height(wh);
	});

	$("#divMain").mCustomScrollbar({
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
	obj.loadEvent()
	return obj;
}