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
		    // �Ǳ�ѡ���� Ĭ��Ϊfalse �����Ƿ���Ƕ���������true֮�� ��Ҫҳ��Ԥ��һ��λ�ø�CDSSʹ��
		    isEmbed: false,
		    // �Ǳ�ѡ���� Ĭ��Ϊtrue ��������ҳ����������false����������ҳ����ͬʱ����url��ͨ������ҳ��Ϣ���ݹ淶����
		    detailPopup: false,
		    // �����ʼ��Ĭ��emr����
		    defaultEmr: {
		        "������Ա��Ϣ": {
		          "ҽԺ": top.session["LOGON.HOSPDESC"]||"ҽԺ����" , // [����]ҽԺ����
		          "����": top.session["LOGON.CTLOCDESC"]||"��������"  //// [����]��������
		        }
		    },
		    // ע�⣺����panelCss��floatCss��������isEmbedΪfalseʱʹ��!
		    // ����CDSS���չ����ĳ�ʼλ��, ֧�ִ����������� top��right ֵΪ ����+px��ɵ��ַ��� �磺'10px'��
		    // ����Ϊʹ��ʾ����
		    panelCss: {
		      top: '20px', // ����չ�����CDSS������ҳ�涥��10px
		      right: '10px' // ����չ�����CDSS������ҳ���Ҳ�10px
		    },
		    // �����������ĳ�ʼλ�á�֧�ִ����������� top��right ֵΪ ����+px��ɵ��ַ��� �磺'10px'��
		    // ����Ϊʹ��ʾ����
		    floatCss: {
		      top: '20px', // ������������Ĭ��λ�þ���ҳ�涥��10px
		      right: '10px' // ������������Ĭ��λ�þ���ҳ���Ҳ�10px
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
