
// var logid = "";

/// 页面初始化函数
function initPageDefault(){
	
	/// 调用审查接口
	var pdss = new PDSS({"WinType":"OPENWIN"});
	var PdssObj = {};
	PdssObj.MsgID = logid;
	pdss.refresh(PdssObj, null, 1);
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })