///页面Gui
function InitMessageWin(){
	var obj = new Object();
	
	//初始化高度
	var wh = $(window).height();
	$("#bodyMsg").height(wh-145);
	
	//自适应高度
	$(window).resize(function(){
		var wh = $(window).height();
		$("#bodyMsg").height(wh-145);
	});
	
	$('#bodyMsg').mCustomScrollbar({
		theme: "dark-thick",
		scrollInertia : 100,
		mouseWheelPixels: 80 //滚动速度
	});
	
	InitMessageWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
