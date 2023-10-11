//加载页面
$(function () {
	InitWin();
});

//页面Gui
function InitWin(){
	var obj = new Object();
    
	 $.parser.onComplete = function(context){		 
     	// 页面元素加载完成
	 }
	InitWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


