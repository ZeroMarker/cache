//为jquery扩展实用方法
/**
*@author: wanghc
*@date: 2014-10-29
*@param: data    object             {ClassName:'',MethodName:'',QueryName:'',dataType:"json"|"text"|..., args}
*@param: success function|boolean   successCallback|async
*
*e.g:  
* $cm({
*  ClassName:"websys.DHCMessageReceiveType",
*  MethodName:"Save",
*  Code:CodeJObj.val(),
*  Desc:DescJObj.val(),
*  Id:ReceiveIdJObj.val()
* },function(){alert("success");})
*or 
* var rtn = $cm({...},false)
* $.q({ClassName:"web.Test",QueryName:"Find"},function(rtn){console.log(rtn)})
*/
var EXPLOGONWIN = null;
function $cm(data,success,error){
	if(!!$ && !$.extend){$ = jQuery; }
	if ("undefined"==typeof $){return false};
	var result,dataType="json",type="POST";
	if (data["dataType"]){
		dataType = data["dataType"];
	}
	/*IE7-ArrayObject not method of indexOf*/
	if (data["type"]&&"POST^GET^PUT^DELETE".indexOf(data["type"].toUpperCase())>-1){
		type = data["type"];
	}
	/*if (data["type"]&&["POST","GET","PUT","DELETE"].indexOf(data["type"].toUpperCase())>-1){
		type = data["type"];
	}*/
	for(var p in data){
		if ($.isArray(data[p])){
			var plen = data[p].length;
			for(var j=0; j<plen; j++){
				data[p+'_'+j] = data[p][j];
			}
			data[p+'_T'] = "ARRAY";
			data[p+'_C'] = plen;		
			delete data[p];
		}
	}
	var request_headers=data._headers||{};
	delete data._headers;
	if (data.ResultSetType && data.ResultSetType.toUpperCase()=="EXCELPLUGIN"){
		var clientAllowExcel = true;
		if(!!window.ActiveXObject||"ActiveXObject"in window){
			try{
				var o = new ActiveXObject("MSScriptControl.ScriptControl");
			}catch(e){
				clientAllowExcel=false;
				alert("1. Plase Add IP TrustList, 2. Allow ActiveX"); /*请把本站加入信任站点，且允许ActiveX运行*/
				return ;
			}
		}
		dataType = "script" //,scriptCharset:"utf-8"
		if (success===false) data["notReturn"]=0; 
	}
	var ajaxRtn = $.ajax({
		url:"websys.Broker.cls",
		data:data,
		type:type,
		headers:$.extend({},request_headers),
		async:success===false?false:true,
		dataType:dataType,
		success:function(rtn){
			if ((typeof rtn=="string") && rtn.indexOf("window.open(\"dhc.logon.csp?RELOGON=1")>-1){
				if (EXPLOGONWIN!=null && "object"==typeof EXPLOGONWIN && "string"==typeof EXPLOGONWIN.page) {
				}else{
					//EXPLOGONWIN = top.window.open("dhc.logon.csp?RELOGON=1","RELOGON","toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes");
				}
			}else if ((typeof rtn=="string") && rtn.indexOf("<title>Login CACHE</title>")>-1){
				if (EXPLOGONWIN!=null && "object"==typeof EXPLOGONWIN && "string"==typeof EXPLOGONWIN.page) {
				}else{
					//EXPLOGONWIN = top.window.open("dhc.logon.csp?RELOGON=1","RELOGON","toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes");
				}
			}else{
				if (success && success.call) {
					if (rtn.success) rtn.success= parseInt(rtn.success)
					success.call(this,rtn);
				}
				if (success===false) result = rtn;
			}
		},
		error:function(data,textStatus){
			//textStatus还可能是"timeout", "error", "notmodified" 和 "parsererror"
			// readyStatus 0=>初始化 1=>载入 2=>载入完成 3=>解析 4=>完成
			// status      1xx：信息响应类，表示接收到请求并且继续处理,2xx：处理成功响应类，表示动作被成功接收、理解和接受,3xx：重定向响应类，为了完成指定的动作，必须接受进一步处理,4xx：客户端错误，客户请求包含语法错误或者是不能正确执行,5xx：服务端错误，服务器不能正确执行一个正确的请求
			
			if (textStatus=="error" && data.status==0){return "";} //chrome request abort geek
			if (textStatus=="abort"){return "";}
			if ("undefined"==typeof window.eval){return "";} 		//IE request abort geek
			var rtn = data.responseText;
			if ((typeof rtn=="string") && rtn.indexOf("window.open(\"dhc.logon.csp?RELOGON=1\",\"RELOGON\",\"toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=no\"")>-1){
				top.window.open("dhc.logon.csp?RELOGON=1","RELOGON","toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=no");
			}else if ((typeof rtn=="string") && rtn.indexOf("<title>Login CACHE</title>")>-1){
				top.window.open("dhc.logon.csp?RELOGON=1","RELOGON","toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=no");
			}else{
				if (typeof error=="function"){
					error.apply(this,arguments);
				}else{
					//console.log(data.responseText)
					alert('Request Data Error.\nErrorType: "'+textStatus+'"\nReturnValue: '+data.responseText); 
				}
			}
		}
	});
	if (success===false) return result;
	return ajaxRtn;
};
function $q(data,success,error){
	return $cm(data,success,error);
};
function $m(data,success,error){
	$.extend(data,{dataType:"text"});
	return $cm(data,success,error);
};
(function($){
	if(!!$ && !$.extend){$ = jQuery; }
	if ("undefined"==typeof $){return false};
	$.cm = $cm;
	$.ajaxRunServerMethod = function(data,success,error){
		$.extend(data,{dataType:"text"});
		return $.cm(data,success,error);
	};
	$.m=$.ajaxRunServerMethod;
	$.ajaxRunServerQuery = function(data,success,error){
		return $.cm(data,success,error);
	};
	$.q = $.ajaxRunServerQuery;
	$.formatByJson = function(template,data){
		if ("string" == typeof data ){
			data = $.parseJSON(data);
		}
		// template + data生成数据html
		return template.replace(/\{(.+?)\}/ig,function(m,i,d){
				return data[i];
		}) ;
	}
	if (!$.browser){
		$.browser = {} ;
		$.browser.mozilla = /firefox/.test(navigator.userAgent.toLowerCase());  
		$.browser.webkit = /webkit/.test(navigator.userAgent.toLowerCase());  
		$.browser.opera = /opera/.test(navigator.userAgent.toLowerCase());  
		$.browser.msie = /msie/.test(navigator.userAgent.toLowerCase());
	}
})(jQuery);
/**
* 新产品组使用
* 参数名sync 改成async  使实际调用表现和参数名意思一致
* datatype: 'json'|'text'|...   default:json
* async: true|false   defalut:true
*/
function runClassMethod(className,methodName,datas,successHandler,datatype,async){
	var opt;
	datas = datas||{};
	if(datas.IsQuery){
		opt = {ClassName:className,QueryName:methodName};
		$.extend(opt,datas);
		$cm(opt,successHandler);
	}else {
		if (arguments.length>4){
			opt = {ClassName:className,MethodName:methodName,dataType:datatype==''?'text':datatype};
		}else{
			opt = {ClassName:className,MethodName:methodName};
		}
		$.extend(opt,datas);
		if (typeof async=='undefined' || async){
			$cm(opt,successHandler);
		}else{
			return successHandler.call(this,$cm(opt,false));
		}
	}
}
function serverCall(className,methodName,datas){
	var ret="";
	runClassMethod(className,methodName,datas,function(retData){ret=retData},"",false);
	return ret;
}