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
	//var ak = serverParamObj['ak'];
	//var sk = serverParamObj['sk'];
	var getWebsysCDSS = null;
	var websysCDSS = null;
	var curType = paramObj.type;
	var _initWebsysCDSS = function(){
		if (websysCDSS) return websysCDSS;
		var cdssType = "doctor";
		if (top.session["LOGON.CTCPTINType"]){
			cdssType = top.session["LOGON.CTCPTINType"].toLowerCase()
		}
		var user_info = { 
			user_id: session['LOGON.USERCODE']||top.session['LOGON.USERCODE'],
			user_name: session['LOGON.USERNAME']||top.session['LOGON.USERNAME'],
			user_role: cdssType,
			dept_code: top.session["LOGON.CTLOCCODE"]||"¿ÆÊÒCODE",
			dept_name: top.session["LOGON.CTLOCDESC"]||"¿ÆÊÒÃû³Æ"
		};
		var startOptions = {
			user_info: user_info,
			source_app: 'dh_his',
			server_url: serverPath
			cdss_url: serverPath,   // http://192.168.150.32:25235',
		};
		if (serverParamObj["open_client"]=="true"){
			startOptions.open_client = true;
			startOptions.cdss_exe_path = "C:\\CDSS\\Synyi.CDS.exe";
		}else{
			startOptions.open_client = false;
			startOptions.cdss_exe_path = "";
		}
		cdssSDK.StartCdss(startOptions).then(function (data) {
			console.log(data);
		});
		websysCDSS = cdssSDK;
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
		var data = {
			visit_info:{source_app:'emr', source_visit_id:visitId},
			user_info:{
				user_id:session['LOGON.USERCODE'],
				user_name:session['LOGON.USERNAME'],
				user_role:session["LOGON.CTCPTINType"],
				dept_code:session["LOGON.CTLOCCODE"],
				dept_name:session["LOGON.CTLOCDESC"]
			}
		};
		websysCDSS.SwitchPatient(data);
	}
	if ('undefined'==typeof window.initWebsysCDSS) {
		
		window.initWebsysCDSS = function(intype){
			if (typeof intype=="undefined"){
				return _initWebsysCDSS();
			}
			return window.initWebsysCDSSFunArray[intype]();
		};
		
		window.getWebsysCDSS = function(intype){
			if (typeof intype=="undefined"){
				return websysCDSS ;
			}
			return window.getWebsysCDSSFuncArray[intype]();
		};
		
		window.getWebsysCDSSConfig = function(){
			return [paramObj];
		}
		window.logoutWebsysCDSS=function(){
		   if(websysCDSS && websysCDSS.CloseCdss) websysCDSS.CloseCdss();
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
