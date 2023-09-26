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
			isTopZindex:true
		}
		$.extend(defOpt,option);
		if (document.getElementById("CommonWin")){
			winObj = $("#CommonWin");
		}else{
			winObj = $('<div id="CommonWin"></div>').appendTo("body");	
		}
		//$('#CommonWin').dialog(defOpt);
		$HUI.dialog('#CommonWin', defOpt)
}

function commonCloseWin(){
	$('#CommonWin').dialog('close');
}

function commonParentCloseWin(){
	window.parent.$('#CommonWin').dialog('close');
}