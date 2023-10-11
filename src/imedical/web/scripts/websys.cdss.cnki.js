(function(){
	var currentScriptArg = (function(){
		var tmpscripts = document.getElementsByTagName('script'); 
		var currentScript = tmpscripts[tmpscripts.length - 1]; 
		return currentScript.getAttribute('src');
	})();
	function getParam(url){
		if (url.indexOf('?')>-1) {
			url = url.split('?')[1];
		}
		var arr = url.split('&');
		var obj = {};
		for(var i=0; i<arr.length; i++){
			obj[arr[i].split('=')[0]] = decodeURIComponent(arr[i].split('=')[1]);
		}
		return obj;	
	}
	var paramObj = getParam(currentScriptArg);
	var serverPath = paramObj['serverpath'];
	var serverParamObj = getParam( paramObj['serverpathparam']);
	var getWebsysCDSS = null;
	var websysCDSS = null;
	var curType = paramObj.type;
	//var loc = tkMakeServerCall("web.CTLoc","GetDescFromRowId",session["LOGON.CTLOCID"] );
	var hostServerUrl = paramObj.serverpath+"?"+paramObj.serverpathparam; //"http://cdssapi.znxxjs.com:8038/Entrance/Entrance.aspx?dr=1&key=&act=PMMD&type=0";
	var messenger = null;
	var _initWebsysCDSS = function(){
		if (document.getElementById("cdssCNKIDiv")) return websysCDSS;
		var html = '<div id="cdssCNKIDiv" style="height:600px;width:300px;Z-INDEX:9999;position:absolute;right:20px;bottom: 20px;">'
		+'<iframe id="cdssIframe" name="cdssIframe" src="'+hostServerUrl+'" width="100%" height="100%" scrolling="auto" marginwidth=0 marginheight=0 frameborder="no" framespacing=0>'
		+'</iframe></div>';
		$(html).appendTo('body');
		messenger = new Messenger('cdssIframe','cdssMessenger');
		var hisiframe = document.getElementById('cdssIframe');
		if (hisiframe) messenger.addTarget(hisiframe.contentWindow, 'CNKI_CDSS');
		websysCDSS = new Messenger('CNKI_CDSS', 'cdssMessenger');
		return websysCDSS;
	};
	getWebsysToCDSS = function(){
		//var objcase = { type: type, jsonData: json };
		//messenger.targets["CNKI_CDSS"].send(JSON.stringify(objcase));
		return messenger; // his  to cdss
	};
	getWebsysCDSS = function(){
		/*
		messenger.listen(function (msg) {
		 if (msg != undefined && msg != "" && msg != "undefined") 
		{              
		 msg = JSONparse(msg);
		 var type = msg.type;
		 var value = JSONstringify(msg.jsonData);
		   
		}
		*/
		// listen cdss messager
		//return new Messenger('CNKI_CDSS', 'cdssMessenger');
		return websysCDSS;
	}
	
	if("undefined"!=typeof paramObj.init && paramObj.init==1){
		_initWebsysCDSS();
	}
	window.initWebsysCDSSFunArray = window.initWebsysCDSSFunArray||{};
	window.initWebsysCDSSFunArray[curType] = _initWebsysCDSS;
	
	window.getWebsysCDSSFuncArray = window.getWebsysCDSSFuncArray||{};	
	window.getWebsysCDSSFuncArray[curType] = function(){
		return websysCDSS;
	};
	window.SwitchPatientFunArray = window.SwitchPatientFunArray ||{};
	window.SwitchPatientFunArray[curType] = function(visitId){
	}
	if ('undefined'==typeof window.initWebsysCDSS) {
		window.initWebsysCDSS = function(intype){
			if (typeof intype=="undefined"){
				return _initWebsysCDSS(); //(window.initWebsysCDSSFunArray['baidu']||_initWebsysCDSS)();
			}
			return window.initWebsysCDSSFunArray[intype]();
		};
		
		window.getWebsysCDSS = function(intype){
			if (typeof intype=="undefined"){
				return websysCDSS ; //window.getWebsysCDSSFuncArray['baidu']?window.getWebsysCDSSFuncArray['baidu']();
			}
			if (window.getWebsysCDSSFuncArray[intype]){
				return window.getWebsysCDSSFuncArray[intype]();
			}else{
				if (console) console.log("not find "+intype+"CDSS");
				return null;
			}
		};
		
		window.getWebsysCDSSConfig = function(){
			return [paramObj];
		}
		window.getWebsysToCDSS = getWebsysToCDSS;
	}else{
		var oldParamArr = window.getWebsysCDSSConfig();
		oldParamArr.push(paramObj);
		window.getWebsysCDSSConfig = function(){
			return oldParamArr;
		}
	}
	return {initWebsysCDSS:initWebsysCDSS,getWebsysCDSS:getWebsysCDSS,getWebsysCDSSConfig:getWebsysCDSSConfig};
})();
