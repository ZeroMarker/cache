//页面Gui
function InitCCScreeningWin(){
	var obj = new Object();	
	//初始化高度
	var wh = $(window).height();
	$("#divLeft").height(wh-10);
    $("#MainTable").height(wh-1);
	$("#divPanel").height(wh-70);
	
	//自适应高度
	$(window).resize(function(){
		var wh = $(window).height();
		$("#divLeft").height(wh-10);
		$("#MainTable").height(wh-1);
		$("#divPanel").height(wh-70);	
	});
	
	$("#divLeft").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100,
		mouseWheelPixels: 80 //滚动速度
	});
	
	$("#divMain").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100,
		mouseWheelPixels: 80
	});
	
	$("#divPanel").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100,
		mouseWheelPixels: 80
	});
	
	$('body').mCustomScrollbar({
		theme: "dark-thick",
		scrollInertia : 100,
		mouseWheelPixels: 80
	});
	
	InitCCScreeningWinEvent(obj);
	return obj;
}