//页面Gui
var objScreen = new Object();
function InitPublicHealthWin(){
	var obj = objScreen;
	var nowDate = new Date();
	obj.now=Common_GetDate(nowDate)
	nowDate.setMonth(nowDate.getMonth()-1);
	obj.lastMonth=Common_GetDate(nowDate)
	
	InitPublicHealthWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}