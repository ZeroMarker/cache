//将融合版日志控件的日期格式转换成标准格式
function dateFormat(date){
	var fmatdate = date;
	if (date == "" || date == undefined) return fmatdate;
	if (typeof(dtformat) != "undefined")
	{
		if (dtformat == "DMY")
		{
			var tmparr = date.split("/");
			fmatdate = tmparr[2]+"-"+tmparr[1]+"-"+tmparr[0];
		}
		else if (dtformat == "MDY")
		{
			var tmparr = date.split("/");
			fmatdate = tmparr[2]+"-"+tmparr[0]+"-"+tmparr[1];
		}
	}
	return fmatdate
}

﻿//日期转换
Date.prototype.format = function(format) 
{ 
	var o = { 
		"M+" : this.getMonth() + 1, 
		"d+" : this.getDate(), 
		"h+" : this.getHours(), 
		"m+" : this.getMinutes(), 
		"s+" : this.getSeconds(), 
		"q+" : Math.floor((this.getMonth() + 3) / 3), 
		"S" : this.getMilliseconds() 
	} 
	if (/(y+)/.test(format)) 
	{ 
		format = format.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length)); 
	} 
 
	for (var k in o) 
	{ 
		if (new RegExp("(" + k + ")").test(format)) 
		{ 
			format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length)); 
		} 
	} 
	return format; 
}
//获取客户端IP地址
function getIpAddress()
{
	try
	{
		var locator = new ActiveXObject ("WbemScripting.SWbemLocator");
		var service = locator.ConnectServer(".");
		var properties = service.ExecQuery("Select * from Win32_NetworkAdapterConfiguration Where IPEnabled =True");
		var e = new Enumerator (properties);
		{
		    var p = e.item();
		    var ip = p.IPAddress(0);
		    return ip
		}
	}
	catch(err)
	{
		return "";
	}
}

//获取客户端计算机名
function getComputerName()
{
	try
	{
		var wshNetwork = new ActiveXObject("WScript.Network");
		var ComputerName = wshNetwork.ComputerName;
		return ComputerName;
	}
	catch(err)
	{
		return "";
	}
}

///保存本地文件
function saveInfoToFile(folder, fileName,fileInfo) 
{    
	var filePath = folder + fileName;    
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var file = fso.OpenTextFile(filePath,8,true); 
	file.WriteLine(fileInfo);    
	file.Close();
}

///字符串传xml
function convertToXml(xmlString)
{ 
    var xmlDoc=null;
    //判断浏览器的类型
    //支持IE浏览器 
    if(!window.DOMParser && window.ActiveXObject){   //window.DOMParser 判断是否是非ie浏览器
        var xmlDomVersions = ['MSXML.2.DOMDocument.6.0','MSXML.2.DOMDocument.3.0','Microsoft.XMLDOM'];
        for(var i=0;i<xmlDomVersions.length;i++)
        {
            try
            {
                xmlDoc = new ActiveXObject(xmlDomVersions[i]);
                xmlDoc.async = false;
                xmlDoc.loadXML(xmlString); //loadXML方法载入xml字符串
                break;
            }catch(e){ }
        }
    }
    //支持Mozilla浏览器
    else if(window.DOMParser && document.implementation && document.implementation.createDocument)
    {
		try{
		    /* DOMParser 对象解析 XML 文本并返回一个 XML Document 对象。
		     * 要使用 DOMParser，使用不带参数的构造函数来实例化它，然后调用其 parseFromString() 方法
		     * parseFromString(text, contentType) 参数text:要解析的 XML 标记 参数contentType文本的内容类型
		     * 可能是 "text/xml" 、"application/xml" 或 "application/xhtml+xml" 中的一个。注意，不支持 "text/html"。
		     */
		    domParser = new  DOMParser();
		    xmlDoc = domParser.parseFromString(xmlString, 'text/xml');
		}catch(e){}
    }
    else
    {
        return null;
    }

    return xmlDoc;
}

//处理特殊字符
function stringTJson(s) {      
    var newstr = "";   
    for (var i=0; i<s.length; i++) {   
        c = s.charAt(i);        
        switch (c) {        
            case '<':        
                newstr+="&lt";        
                break;
            case '>':        
                newstr+="&gt";        
                break;
            case '\"':        
                newstr+="\\\"";        
                break;        
            case '\\':        
                newstr+="\\\\";        
                break;        
            case '/':        
                newstr+="\/";        
                break;        
            case '\b':        
                newstr+="\\b";        
                break;        
            case '\f':        
                newstr+="\\f";        
                break;        
            case '\n':        
                newstr+="\\n";        
                break;        
            case '\r':        
                newstr+="\\r";        
                break;        
            case '\t':        
                newstr+="\\t";        
                break;        
            default:        
                newstr+=c;        
        }   
   }   
   return newstr;        
} 

//屏蔽退格键balckspace返回上一页
$(document).keydown(function(e){
     var target = e.target ;
     var tag = e.target.tagName.toUpperCase();
     if(e.keyCode == 8){
      if((tag == 'INPUT' && !$(target).attr("readonly"))||(tag == 'TEXTAREA' && !$(target).attr("readonly"))){
       if((target.type.toUpperCase() == "RADIO") || (target.type.toUpperCase() == "CHECKBOX")){
        return false ;
       }else{
        return true ; 
       }
      }else{
       return false ;
      }
     }
 });

var base64EncodeChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";   
var base64DecodeChars = new Array(   
　　-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
　　-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
　　-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63,   
　　52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1,   
　　-1,　0,　1,　2,　3,  4,　5,　6,　7,　8,　9, 10, 11, 12, 13, 14,   
　　15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1,   
　　-1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,   
　　41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1);   
function base64encode(str) {   
　　var out, i, len;   
　　var c1, c2, c3;   
　　len = str.length;   
　　i = 0;   
　　out = "";   
　　while(i < len) {   
 c1 = str.charCodeAt(i++) & 0xff;   
 if(i == len)   
 {   
　　 out += base64EncodeChars.charAt(c1 >> 2);   
　　 out += base64EncodeChars.charAt((c1 & 0x3) << 4);   
　　 out += "==";   
　　 break;   
 }   
 c2 = str.charCodeAt(i++);   
 if(i == len)   
 {   
　　 out += base64EncodeChars.charAt(c1 >> 2);   
　　 out += base64EncodeChars.charAt(((c1 & 0x3)<< 4) | ((c2 & 0xF0) >> 4));   
　　 out += base64EncodeChars.charAt((c2 & 0xF) << 2);   
　　 out += "=";   
　　 break;   
 }   
 c3 = str.charCodeAt(i++);   
 out += base64EncodeChars.charAt(c1 >> 2);   
 out += base64EncodeChars.charAt(((c1 & 0x3)<< 4) | ((c2 & 0xF0) >> 4));   
 out += base64EncodeChars.charAt(((c2 & 0xF) << 2) | ((c3 & 0xC0) >>6));   
 out += base64EncodeChars.charAt(c3 & 0x3F);   
　　}   
　　return out;   
}   
function base64decode(str) {   
　　var c1, c2, c3, c4;   
　　var i, len, out;   
　　len = str.length;   
　　i = 0;   
　　out = "";   
　　while(i < len) {   
 /* c1 */   
 do {   
　　 c1 = base64DecodeChars[str.charCodeAt(i++) & 0xff];   
 } while(i < len && c1 == -1);   
 if(c1 == -1)   
　　 break;   
 /* c2 */   
 do {   
　　 c2 = base64DecodeChars[str.charCodeAt(i++) & 0xff];   
 } while(i < len && c2 == -1);   
 if(c2 == -1)   
　　 break;   
 out += String.fromCharCode((c1 << 2) | ((c2 & 0x30) >> 4));   
 /* c3 */   
 do {   
　　 c3 = str.charCodeAt(i++) & 0xff;   
　　 if(c3 == 61)   
　return out;   
　　 c3 = base64DecodeChars[c3];   
 } while(i < len && c3 == -1);   
 if(c3 == -1)   
　　 break;   
 out += String.fromCharCode(((c2 & 0XF) << 4) | ((c3 & 0x3C) >> 2));   
 /* c4 */   
 do {   
　　 c4 = str.charCodeAt(i++) & 0xff;   
　　 if(c4 == 61)   
　return out;   
　　 c4 = base64DecodeChars[c4];   
 } while(i < len && c4 == -1);   
 if(c4 == -1)   
　　 break;   
 out += String.fromCharCode(((c3 & 0x03) << 6) | c4);   
　　}   
　　return out;   
}   
function utf16to8(str) {   
　　var out, i, len, c;   
　　out = "";   
　　len = str.length;   
　　for(i = 0; i < len; i++) {   
 c = str.charCodeAt(i);   
 if ((c >= 0x0001) && (c <= 0x007F)) {   
　　 out += str.charAt(i);   
 } else if (c > 0x07FF) {   
　　 out += String.fromCharCode(0xE0 | ((c >> 12) & 0x0F));   
　　 out += String.fromCharCode(0x80 | ((c >>　6) & 0x3F));   
　　 out += String.fromCharCode(0x80 | ((c >>　0) & 0x3F));   
 } else {   
　　 out += String.fromCharCode(0xC0 | ((c >>　6) & 0x1F));   
　　 out += String.fromCharCode(0x80 | ((c >>　0) & 0x3F));   
 }   
　　}   
　　return out;   
}   
function utf8to16(str) {   
　　var out, i, len, c;   
　　var char2, char3;   
　　out = "";   
　　len = str.length;   
　　i = 0;   
　　while(i < len) {   
 c = str.charCodeAt(i++);   
 switch(c >> 4)   
 {   
　 case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7:   
　　 // 0xxxxxxx   
　　 out += str.charAt(i-1);   
　　 break;   
　 case 12: case 13:   
　　 // 110x xxxx　 10xx xxxx   
　　 char2 = str.charCodeAt(i++);   
　　 out += String.fromCharCode(((c & 0x1F) << 6) | (char2 & 0x3F));   
　　 break;   
　 case 14:   
　　 // 1110 xxxx　10xx xxxx　10xx xxxx   
　　 char2 = str.charCodeAt(i++);   
　　 char3 = str.charCodeAt(i++);   
　　 out += String.fromCharCode(((c & 0x0F) << 12) |   
　　　　((char2 & 0x3F) << 6) |   
　　　　((char3 & 0x3F) << 0));   
　　 break;   
 }   
　　}   
　　return out;   
}

///Desc:导出word
function exportToWord(id) {
	 //Scripting.FileSystemObject (FSO 文本文件读写)被关闭了，
	 //开启FSO功能即可，在“运行”中执行regsvr32 scrrun.dll即可
	 try {
		 var oElement = document.getElementById(id);
		 var word = new ActiveXObject("Word.Application");
		 var doc = word.Documents.Add("", 0, 1); //不打开模版直接加入内容
		 var Range = doc.Range();

		 var sel = document.body.createTextRange();
		 sel.moveToElementText(oElement);
		 sel.select();
		 sel.execCommand("Copy");
		 Range.Paste();
		 word.Application.Visible = true;
	 }
	 catch (e) {

		 alert("无法启动Excel!\n\n" + e.message +
		 "\n\n如果您确信您的电脑中已经安装了Excel，" +
		 "那么请调整IE的安全级别。\n\n具体操作：\n\n" +
		 "工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用");
	 }
 }
///Desc:导出excel
function exportToExcel(id) {
	//Scripting.FileSystemObject (FSO 文本文件读写)被关闭了，
	//开启FSO功能即可，在“运行”中执行regsvr32 scrrun.dll即可
	try {
		var oElement = document.getElementById(id);
		var oRangeRef = document.body.createTextRange();
		oRangeRef.moveToElementText(oElement);
		oRangeRef.execCommand("Copy");

		var oXL = new ActiveXObject("Excel.Application")
		var oWB = oXL.Workbooks.Add;
		var oSheet = oWB.ActiveSheet;
		oSheet.Paste();
		oSheet.Cells.NumberFormatLocal = "@";
		oXL.Selection.ColumnWidth = 8;

		oXL.Visible = true;
		oSheet = null;
		oWB = null;
		appExcel = null;
	} catch (e) {
		alert("无法启动Excel!\n\n" + e.message +
		"\n\n如果您确信您的电脑中已经安装了Excel，" +
		"那么请调整IE的安全级别。\n\n具体操作：\n\n" +
		"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用")
		}	
}	

//表字段Scheme
function getColumnScheme(strXml,path,flag)
{
	var columns = new Array();
	if (flag == 1)
	{
		columns.push({field:'ck',checkbox:true})
	}
    var showparent = $(strXml).find(path).each(function(){
	    var code = $(this).find("code").text();
	    var desc = $(this).find("desc").text();
	    var sortable = $(this).find("sortable").text()=="Y"?true:false;
	    var hidden = $(this).find("hidden").text()=="Y"?true:false; 
	    var colwidth = $(this).find("width").text();
	        colwidth = (colwidth=="")?80:colwidth;     
	    columns.push({field:code,title:desc,width:colwidth,hidden:hidden,sortable:sortable});
    });
    return [columns];
}

//引用Scheme
function getRefScheme(strXml,path)
{
	var refScheme = new Array();
    var showparent = $(strXml).find(path).each(function(){
	    var code = $(this).find("code").text();
	    var desc = $(this).find("desc").text();
	    var separate = $(this).find("separate").text(); 
	    if (separate == "enter")
	    {
		    separate = "\n";
		}
		else if (separate == "blackspace")
		{
			separate = " "
		}
		var check = $(this).find("check").text()=="N"?false:true; 
	    refScheme.push({code:code,desc:desc,separate:separate,check:check});
    });
    return refScheme;
}			

///日期比较
function compareDateTime(startDate, endDate) 
{   
    var startDateTemp = startDate.split(" ");   
    var endDateTemp = endDate.split(" ");   

    var arrStartDate = startDateTemp[0].split("-");   
    var arrEndDate = endDateTemp[0].split("-");   

    var arrStartTime = startDateTemp[1].split(":");
    if (arrStartTime.length <3)
    {
	    var len = 3- arrStartTime.length;
	    for (i=0;i<len;i++)
	    {
		    arrStartTime.push(0);
		}
	}  
    var arrEndTime = endDateTemp[1].split(":"); 
    if (arrEndTime.length <3)
    {
	    var len = 3- arrEndTime.length;
	    for (i=0;i<len;i++)
	    {
		    arrEndTime.push(0);
		}
	}  

	var allStartDate = new Date(arrStartDate[0], arrStartDate[1], arrStartDate[2], arrStartTime[0], arrStartTime[1], arrStartTime[2]);   
	var allEndDate = new Date(arrEndDate[0], arrEndDate[1], arrEndDate[2], arrEndTime[0], arrEndTime[1], arrEndTime[2]);   

	if (allStartDate.getTime() > allEndDate.getTime()) 
	{   
        return false;   
	} 
	else
	{   
		return true;   
    }   
}

//点击控件事件
function my_click(obj, myid)
{
	if (document.getElementById(myid).value == document.getElementById(myid).defaultValue)
	{
		document.getElementById(myid).value = '';
		obj.style.color='#000';
	}
}
//离开控件事件
function my_blur(obj, myid)
{
	if (document.getElementById(myid).value == '')
	{
		document.getElementById(myid).value = document.getElementById(myid).defaultValue;
		obj.style.color='#999'
	}
}

/// 创建HISUI-Dialog弹窗
function createModalDialog(dialogId, dialogTitle, width, height, iframeId, iframeContent,callback,arr,iconCls){
    if ($("#modalIframe").length<1)
	{
        $("body").append('<iframe id="modalIframe" style="position: absolute; z-index: 1999; width: 100%; height: 100%; top: 0;left:0;scrolling:no;" frameborder="0"></iframe>');
    }
	else
	{
        $("#modalIframe").css("display","block");
    }
    $("body").append("<div id='"+dialogId+"'</div>");
	if (isNaN(width)) width = 800;
	if (isNaN(height)) height = 500;  
    //document.getElementById("editorFrame").style.visibility="hidden"; //隐藏插件
    var returnValue = "";
    if(iconCls == undefined) iconCls = 'icon-w-card';
    $HUI.dialog('#'+dialogId,{ 
        title: dialogTitle,
        width: width,
        height: height,
        cache: false,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        isTopZindex: true,
        content: iframeContent,
        iconCls:iconCls,
        onBeforeClose:function(){
            var tempFrame = $('#'+iframeId)[0].contentWindow;
            if (tempFrame && tempFrame.returnValue)
			{
				returnValue = tempFrame.returnValue;
			    if ((returnValue != "") &&(typeof(callback) === "function"))
				{
                    callback(returnValue,arr);
                }
			}
        },
        onClose:function(){
            $("#modalIframe").hide();
            //document.getElementById("editorFrame").style.visibility="visible";//显示
			$("#"+dialogId).dialog('destroy');
        }
    });
}
//关闭dialog,子页面调用
function closeDialog(dialogId)
{
	$HUI.dialog('#'+dialogId).close();
}

//国际化改造获取翻译
function emrTrans(value)
{
	if (typeof $g == "function") 
	{
		value = $g(value)
	}
	return value;
}

