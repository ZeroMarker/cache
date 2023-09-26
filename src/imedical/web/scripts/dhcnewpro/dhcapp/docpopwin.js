//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-03-20
// 描述:	   检查申请医生弹出界面窗体界面js
//===========================================================================================

//var PanelWidth = (typeof dialogWidth == "undefined")?($(window).width() - 40) :dialogWidth;
var PanelWidth = 1180;
var refresh = 0;

/// 页面初始化函数
function initPageDefault(){
	
	$('#tabs').tabs({
		onSelect:function(title,index){
		   /*
		   if (((title.indexOf("尸检申请单") != "-1")||(title.indexOf("外院会诊") != "-1"))&(refresh == 0)){
			  var curTab = $('#tabs').tabs('getSelected');
			  if (curTab && curTab.find('iframe').length > 0) {
			  	  curTab.find('iframe')[0].contentWindow.location.reload();
			  	  refresh = 1;
			  }
		   }
		   */
		   if ((title.indexOf("尸检") != "-1")||(title.indexOf("活体") != "-1")||(title.indexOf("外院会诊") != "-1")){
		   	  frames[index].resize();
		   }
		}
	});
}

/// 提交申请
function TakPisNo(){
	
	var WriteFlag = 0;
	/// 循环保存各个申请单
	for (var i=0; i<frames.length; i++){
		if (!frames[i].InsertDoc()) break;
		WriteFlag = WriteFlag + 1;
	}

	/// 填写申请数量和提交数量不一致时调用
    if (frames.length != WriteFlag) return;
    
	/// 提交申请
	runClassMethod("web.DHCAppPisMaster","InsertDoc",{"Pid":pid},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","提交申请失败，失败原因:"+jsonString);
		}else{
			window.returnValue = jsonString;
			window.close();
		}
	},'',false)
	
}

/// 关闭弹出窗口
function TakClsWin(){
	
	window.close();        /// 关闭弹出窗口
}

/// 窗体高度
function GetPanelWidth(){
	return PanelWidth;
}

/// 提示消息
function InvErrMsg(message){
	$.messager.alert("提示:", message);
	return;
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })