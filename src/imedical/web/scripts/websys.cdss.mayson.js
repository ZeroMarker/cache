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
	var ak = serverParamObj['ak'];
	var sk = serverParamObj['sk'];
	var getWebsysCDSS = null;
	var websysCDSS = null;
	var curType = paramObj.type;
	var _initWebsysCDSS = function(){
		websysCDSS = websysCDSS||{mayson:1};
		HM.maysonLoader({autherKey:ak},function (mayson){
			//设置接入住院版浮窗对接方案
			//门诊和住院的区别是 mayson.setDrMaysonConfig(mIndex, type); 
			// 这个方法 mIndex 参数值：m 表示对接住院 ，c 表示对接门诊
			var mIndex = "c";
			try{if (top.session["LOGON.GROUPDESC"].indexOf("住院")>-1){ mIndex = "m";}else{mIndex="c"}}catch(e){}
			mayson.setDrMaysonConfig(mIndex, 1);
			websysCDSS = mayson;
		});	
		return websysCDSS;
	};
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
			return window.getWebsysCDSSFuncArray[intype]();
		};
		
		window.getWebsysCDSSConfig = function(){
			return [paramObj];
		}
	}else{
		var oldParamArr = window.getWebsysCDSSConfig();
		oldParamArr.push(paramObj);
		window.getWebsysCDSSConfig = function(){
			return oldParamArr;
		}
	}
	return {initWebsysCDSS:initWebsysCDSS,getWebsysCDSS:getWebsysCDSS,getWebsysCDSSConfig:getWebsysCDSSConfig};
})();
