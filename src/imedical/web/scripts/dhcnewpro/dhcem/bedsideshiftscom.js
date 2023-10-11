/**
* 公共弹出界面
* @author zhouxin
*/
function commonShowWin(option){
		var url = tokenUrl(option.url); //2023-03-07
		var content = '<iframe src="'+url+'" scrolling="auto" width="100%" height="100%" frameborder="0" scrolling="no" style="display:block"></iframe>';
		var defOpt={
			iconCls:"icon-w-paper",
			width: 1300,
			height: 600,
			closed: false,
			content: content,
			modal: true
		}
		$.extend(defOpt,option);
		if (document.getElementById("CommonWin")){
			winObj = $("#CommonWin");
		}else{
			winObj = $('<div id="CommonWin"></div>').appendTo("body");	
		}
		$('#CommonWin').dialog(defOpt);
}

function commonCloseWin(){
	$('#CommonWin').dialog('close');
}

function commonParentCloseWin(){
	window.parent.$('#CommonWin').dialog('close');
}

///补0病人登记号
function GetWholePatNo(EmPatNo){

	///  判断登记号是否为空
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  登记号长度值
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('错误提示',"登记号输入错误！");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;
}

function isIE() { //ie?
 	if (!!window.ActiveXObject || "ActiveXObject" in window){
    	return true;
 	}else{
    	return false;
	}
}