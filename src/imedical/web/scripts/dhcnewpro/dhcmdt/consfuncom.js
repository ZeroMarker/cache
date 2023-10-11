/**
* 公共弹出界面
* @author zhouxin
*/
function commonShowWin(option){
		
		var content = '<iframe src="'+option.url+'" scrolling="auto" width="100%" height="100%" frameborder="0" scrolling="no" style="display:block;"></iframe>';
		var defOpt={
			iconCls:"icon-w-paper",
			width: 1300,
			height: 600,
			closed: false,
			content: content,
			modal: true,
			isTopZindex:true,
			isParentOpen:false
		}
		$.extend(defOpt,option);
		var _thisWin=defOpt.isParentOpen?window.parent:window; //父界面打开还是子界面打开
		
		var domName=(option.domName?option.domName:"CommonWin");
		
		if (_thisWin.document.getElementById(domName)){
			winObj = _thisWin.$(domName);
		}else{
			winObj = _thisWin.$('<div id="'+domName+'"></div>').appendTo("body");	
		}
		_thisWin.$HUI.dialog('#'+domName, defOpt)
		return;
}

function commonCloseWin(){
	$('#CommonWin').dialog('close');
}

function commonCloseWinById(domName){
	$('#'+domName).dialog('close');
}

function commonParentCloseWin(){
	window.parent.$('#CommonWin').dialog('close');
}
function commonParentCloseWinById(domName){
	window.parent.$('#'+domName).dialog('close');
}