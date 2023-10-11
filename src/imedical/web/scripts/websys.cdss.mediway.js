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
	//var loc = tkMakeServerCall("web.CTLoc","GetDescFromRowId",session["LOGON.CTLOCID"] );
	var _initWebsysCDSS = function(){
		if (websysCDSS) return websysCDSS;
		if ('undefined'!=typeof DHCCDSSAPI){
			websysCDSS = new DHCCDSSAPI();
		}
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
		// var menuwin=websys_getMenuWin();
		// {"IDNO":"6840","PatientDR":"0000012750","VisitID":1,"VisitType":3,"Name":"测试103","UserID":"18881","UserName":"医生01","DeptCode":"ZYZY003","DeptName":"内分泌科","HospCode":"DHSZHYYZY","HospName":"东华标准版数字化医院[总院]","PageSource":3,"PatientInfo":{"Gender":1,"BirthDate":"1996-04-12","PregnancyStatus":0}}
		// menuwin.CopyDataToCDSS('INITIALIZE_PATIENT_INFORMATION',Data);
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