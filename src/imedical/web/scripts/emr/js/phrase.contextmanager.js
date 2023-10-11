//初始化完安装、更新插件
window.onload=function(){
	if ("undefined"!=typeof globalphrases){
		globalphrases.notReturn = 1;
		globalphrases.clear();
		globalphrases.cmd('makelnk.vbs');
	}
};

var targetNode = document.getElementById("EpisodeID");
var strGuidMark = "";
var strBrowserType = "";
strBrowserType = myBrowser();
//Object.defineProperty(targetNode, 'value',{});
var osr = new MutationObserver(function(ms,ob){
	console.log(document.getElementById("EpisodeID").value);
	strBrowserType = myBrowser();
	if(strGuidMark =="")
	{
		strGuidMark = generateUUID();
	}
	// 在这里写业务逻辑
	sendContext(strGuidMark,strBrowserType);
});
osr.observe(targetNode,{ attributes: true, childList: false, subtree: false });



function generateUUID() 
{
	var d = new Date().getTime();
	var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c){
		var r = (d + Math.random()*16)%16 | 0;
		d = Math.floor(d/16);
		return (c=='x' ? r : (r&0x3|0x8)).toString(16);
	});
	return uuid;
};

function myBrowser() {

    var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
    var navigatorName = navigator.appName; //取得浏览器的userAgent字符串
    var isEdge = userAgent.indexOf("Edge") > -1; //判断是否IE的Edge浏览器
    var isIE = userAgent.indexOf("NET")> -1&&!isEdge;//判断是否IE浏览器
    var isFF = userAgent.indexOf("Firefox") > -1; //判断是否Firefox浏览器
    var isYWChrome = ((userAgent.indexOf("Chrome/49.0.2623.110") > -1)&&(userAgent.indexOf("Safari") > -1)); //判断医为Chrome浏览器
    var isChrome = ((userAgent.indexOf("Chrome") > -1)&&(userAgent.indexOf("Safari") > -1)); //判断Chrome浏览器

    if (isIE) {
        //var reIE = new RegExp("MSIE (\\d+\\.\\d+);");
        //reIE.test(userAgent);
        //var fIEVersion = parseFloat(RegExp["$1"]);
        return "IEFrame";        
    }
    else if (isEdge) {
        return "Edge";
    }
    else if (isYWChrome){
	    return "WindowsForms10.Window.8.app.0.13965fa_r9_ad1"
    }
    else if (isChrome) {   
    	return "Chrome_WidgetWin_0";
    }
    else
    {
	    return "";
    }
    
}

function sendContext(strGuidMark,strBrowserType)
{
	var PatientID = document.getElementById("PatientID").value
	var EpisodeID = document.getElementById("EpisodeID").value
	var UserCode = session["LOGON.USERCODE"]
	var UserName = session["LOGON.USERNAME"]
	jQuery.ajax({
		type: "POST",
		dataType: "text",
		url: "http://localhost:9888",
		async: true,
		data: {
			"PatientID":PatientID,
			"EpisodeID":EpisodeID,
			"GuidMark":strGuidMark,
			"UserCode":UserCode,
			"UserName":UserName,
			"BrowserType":strBrowserType
		},
		success: function(d){
			if (d == "") return;	
		},
		error: function(d)
		{
			return;
			//alert("error");
		}
	});	
}
