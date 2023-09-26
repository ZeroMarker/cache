//页面Gui
function InitInfAntiQryWin(){
	var obj = new Object();
	
	obj.IsExper = 0;
	if (tDHCMedMenuOper['Admin']==1) {
		obj.IsExper = 1; //专家
	}
	
	//初始化高度
	var wh = $(window).height();
	$("#divLeft").height(wh-10);
    $("#divMain").height(wh-10);
	$("#divPanel").height(wh-220);
	
	//自适应高度
	$(window).resize(function(){
		var wh = $(window).height();
		$("#divLeft").height(wh-10);
		$("#divMain").height(wh-10);
		$("#divPanel").height(wh-220);
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
	
	$('body').mCustomScrollbar({
		theme: "dark-thick",
		scrollInertia : 100
	});
	
	InitInfAntiQryWinEvent(obj);
	return obj;
}