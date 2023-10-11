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
		var server = serverPath;
		websysCDSS = new CDSS({
		    container: '#cdss-main-container',
		    server: server,
		    ak: ak,
		    sk: sk,
		    // 非必选参数 默认为false 控制是否内嵌，如果传入true之后 需要页面预留一块位置给CDSS使用
		    isEmbed: false,
		    // 非必选参数 默认为true 控制详情页弹窗，传入false代表不打开详情页弹窗同时详情url会通过详情页信息数据规范传递
		    detailPopup: false,
		    // 传入初始的默认emr数据
		    defaultEmr: {
		        "工作人员信息": {
		          "医院": top.session["LOGON.HOSPDESC"]||"医院名称" , // [必填]医院名称
		          "科室": top.session["LOGON.CTLOCDESC"]||"科室名称"  //// [必填]科室名称
		        }
		    },
		    // 注意：以下panelCss和floatCss参数仅在isEmbed为false时使用!
		    // 控制CDSS面板展开后的初始位置, 支持传入两个参数 top和right 值为 数字+px组成的字符串 如：'10px'。
		    // 以下为使用示例：
		    panelCss: {
		      top: '20px', // 代表展开后的CDSS面板距离页面顶部10px
		      right: '10px' // 代表展开后的CDSS面板距离页面右部10px
		    },
		    // 控制悬浮窗的初始位置。支持传入两个参数 top和right 值为 数字+px组成的字符串 如：'10px'。
		    // 以下为使用示例：
		    floatCss: {
		      top: '20px', // 代表悬浮窗的默认位置距离页面顶部10px
		      right: '10px' // 代表悬浮窗的默认位置距离页面右部10px
		    }
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
