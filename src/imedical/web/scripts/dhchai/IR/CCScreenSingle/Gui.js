///页面Gui
function InitSingleWin(){
	var obj = new Object();
	
	obj.EpisScrRstList = new Object();
	obj.EpisScrRstList.CCSList = new Array();
	obj.EpisScrRstList.INFList = new Array();
	
	//初始化高度
	var wh = $(window).height();
	$("#MainTable").height(wh-1);
	//自适应高度
	$(window).resize(function(){
		var wh = $(window).height();
		$("#MainTable").height(wh-1);
	});
	
	InitSingleWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
