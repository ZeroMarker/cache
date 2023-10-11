
(function($) {
	var realServiceURl = webServiceURl;
	var authUserName = '';
	var authPwd = '';
	function xmlDealSpecial(str){
		var destStr = str;
		if (str.indexOf('&') != -1) {
			var arr = str.split('&')
			destStr = arr.join('&amp;')
		}
		if (destStr.indexOf('<') != -1) {
			var arr = destStr.split('<')
			destStr = arr.join('&lt;')
		}
		return destStr
	}
	mui.DHCRequestXMl = function(successBlock,failureBlock) {
		if (!isLoginPage && authUserName != "") { //不是登录页面
			successBlock();
			successBlock = null
			failureBlock = null
			return
		}
		if (ISMOBILE && !isShowVersion && isLoginPage && localStorage['ipConfigDict'] != undefined) { //正常打包登录界面
			var configDict = JSON.parse(localStorage['ipConfigDict']);
			var temp85 = configDict['his85']+''
			var tempURl = configDict['protocol'] + '//' + configDict['ipUrl'] + configDict['webUrl']; //his完整地址
			if (temp85 == '1') {
				webserviceConfigPath = configDict['protocol'] + '//' + configDict['ipUrl'] + '/imedical/web'+webserviceConfigTail
			}else{
				webserviceConfigPath = tempURl+webserviceConfigTail
			}
		}
		//console.log(webserviceConfigPath)
		var xhr = null;
		if (window.XMLHttpRequest) {
			xhr = new XMLHttpRequest();
		} else if (window.ActiveXObject) {
			xhr = new ActiveXObject("Microsoft.XMLHTTP");
		}
		xhr.onload = function(e) {
			var str = e.target.responseText;
			if (str.indexOf('WebServiceUserName') == -1) { //配置文件不存在
				failureBlock('配置文件不存在');
				successBlock = null
				failureBlock = null
				return
			}
			var testDOM = document.getElementById('testDOM');
			if (!testDOM) {
				testDOM = document.createElement('div')
				document.body.appendChild(testDOM)
				testDOM.id = 'testDOM'
				testDOM.style.display="none"
				
			}
			testDOM.innerHTML = str
			authUserName = testDOM.querySelector('WebServiceUserName').innerText
			var tempPwd = testDOM.querySelector('WebServicePassword').innerText
			authPwd = xmlDealSpecial(tempPwd)
			successBlock();
			testDOM = null
			successBlock = null
			failureBlock = null
		}
		xhr.onerror = function(e) {
			var errorStr = '服务器请求失败';
			failureBlock(errorStr);
			successBlock = null
			failureBlock = null
		}
		xhr.onabort = function(e) {
			var errorStr = '服务器请求中断';
			failureBlock(errorStr);
			successBlock = null
			failureBlock = null
		}
		xhr.ontimeout = function(e) {
			var errorStr = '服务器请求超时';
			failureBlock(errorStr);
			successBlock = null
			failureBlock = null
		}
		xhr.open("GET", webserviceConfigPath);
		xhr.setRequestHeader('Content-Type', 'application/json');
		// 发送HTTP请求
		xhr.send();
	}
	if (isShowVersion && isLoginPage && !ISMOBILE) { //Windows演示版登录界面
		// 登录界面刷新token
		localStorage.removeItem("token");
		initToken();
	}
	
	var namespace = 'http:' + '//www.mediway.com.cn'; //命名空间和服务端保持一致 否则报400
	 //soap协议使用http 无需适配 否则报500
	var actionUrl = 'http:/Nur.DWB.WebService.DWBService'; 
	var docsUrl = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-';
	var orgUrl = 'http://www.w3.org/2001/XMLSchema';
	var schemasUrl = 'http://schemas.xmlsoap.org/';
	$.DHCWebService = function(method, paramDict, successBlock, failureBlock) {
		if (authUserName == '' || authPwd == '') {
			failureBlock('webservice账密为空')
			successBlock = null
			failureBlock = null
			return
		}
		if (isShowVersion && isLoginPage) { //演示版登录界面
			var tmpToken = localStorage.getItem("token");
			if (tmpToken==undefined || tmpToken==""){
				callBackPage()
				mui.toast("没有授权码！！！");
				successBlock = null
				failureBlock = null
				return;
			}
		}
		var xhr = null;
		if (method == '' || method == null) {
			failureBlock('method为空');
			successBlock = null
			failureBlock = null
			return;
		}
		if (window.XMLHttpRequest) {
			xhr = new XMLHttpRequest();
		} else if (window.ActiveXObject) {
			xhr = new ActiveXObject("Microsoft.XMLHTTP");
		}
		/*判断是否支持请求*/
		if (xhr == null) {
			failureBlock('你的浏览器不支持XMLHttp');
			successBlock = null
			failureBlock = null
			return;
		}
		xhr.responseType = '';
		xhr.timeout = 20000; //15s超时时间	
		xhr.onreadystatechange = function() {
			if (xhr.readyState == 4) {
				if (xhr.status == 200) {
					var resultStr = xhr.responseText;
					if (resultStr == null || resultStr == '') {
						failureBlock('response is null');
						xhr = null;
						successBlock = null
						failureBlock = null
						return;
					}
					if (resultStr.indexOf('<' + method + 'Result>') != -1 && resultStr.indexOf('</' + method + 'Result>') != -1) {
						var dataXML = jQuery.parseXML(resultStr);
						var destEle = dataXML.getElementsByTagName(method + 'Result');
						var result = destEle[0].firstChild.nodeValue;
						var resultObj = eval('(' + result + ')');
						successBlock(resultObj);
						dataXML = null
						destEle = null
						result = null
						resultObj = null
					} else {
						failureBlock('数据格式不正确');
					}
					resultStr = null
					xhr = null;
				}else{
					
					var testDOM = document.getElementById('testDOM');
					if (!testDOM) {
						testDOM = document.createElement('div')
						document.body.appendChild(testDOM)
						testDOM.id = 'testDOM'
						testDOM.style.display="none"
						
					}
					testDOM.innerHTML = xhr.response;
					//console.log(method+" "+xhr.response)
					var titleStr = testDOM.innerHTML
					if (testDOM.querySelector('title')) {
						titleStr = testDOM.querySelector('title').innerText
					}
					failureBlock(titleStr);
					testDOM = null
					xhr = null;
				}
				successBlock = null
				failureBlock = null
			}
		}
		xhr.onerror = function() {
			if (failureBlock) {
				failureBlock('错误');
			}
			successBlock = null
			failureBlock = null
			xhr = null;
		}
		xhr.onabort = function() {
			if (failureBlock) {
				failureBlock('中断');
			}
			successBlock = null
			failureBlock = null
			xhr = null;
		}
		xhr.ontimeout = function() {
			if (failureBlock) {
				failureBlock('超时');
			}
			successBlock = null
			failureBlock = null
			xhr = null;
		}
		if (ISMOBILE && !isShowVersion && isLoginPage && localStorage['ipConfigDict'] != undefined) { //正常打包登录界面
			var configDict = JSON.parse(localStorage['ipConfigDict']);
			var temp85 = configDict['his85']+''
			var tempURl = configDict['protocol'] + '//' + configDict['ipUrl'] + configDict['webUrl']; //his完整地址
			realServiceURl = tempURl+ '/Nur.DWB.WebService.DWBService.cls';
		}
		xhr.open("POST", realServiceURl);
		/******************参数组合***********************/
		var paramStr = '<' + method + ' xmlns="' + namespace + '">';
		if (paramDict != null) {
			for (var keyStr in paramDict) {
				var valueStr = paramDict[keyStr];
				paramStr += '<' + keyStr + '>' + valueStr + '</' + keyStr + '>'
			}
		}
		paramStr += '</' + method + '>';

		/******************报文组合***********************/
		var headAction = '<wsa:Action>' + actionUrl + '.' + method + '</wsa:Action>';
		var headAddress = '<wsa:Address>' + schemasUrl + 'ws/2004/08/addressing/role/anonymous</wsa:Address>';
		var replyTo = '<wsa:ReplyTo>' + headAddress + '</wsa:ReplyTo>';
		var wsaTo = '<wsa:To>' + realServiceURl + '</wsa:To>'
		var username = '<wsse:Username>' + authUserName + '</wsse:Username>';
		var pwd = '<wsse:Password Type="' + docsUrl + 'username-token-profile-1.0#PasswordText">' + authPwd +
			'</wsse:Password>';
		var usernameToken = '<wsse:UsernameToken xmlns:wsu="' + docsUrl + 'wssecurity-utility-1.0.xsd">' +
			username + pwd + '</wsse:UsernameToken>';
		var security = '<wsse:Security soap:mustUnderstand="1">' + usernameToken + '</wsse:Security>';
		var soapHeader = '<soap:Header>' + headAction + replyTo + wsaTo + security + "</soap:Header>";
		var soapBody = '<soap:Body>' + paramStr + '</soap:Body>';
		var data = '<?xml version="1.0" encoding="utf-8"?>' +
			'<soap:Envelope xmlns:xsi="' + orgUrl + '-instance" ' +
			'xmlns:xsd="' + orgUrl + '" ' +
			'xmlns:soap="' + schemasUrl + 'soap/envelope/" ' +
			'xmlns:wsa="' + schemasUrl + 'ws/2004/08/addressing" ' +
			'xmlns:wsse="' + docsUrl + 'wssecurity-secext-1.0.xsd" ' +
			'xmlns:wsu="' + docsUrl + 'wssecurity-utility-1.0.xsd">' +
			soapHeader +
			soapBody +
			'</soap:Envelope>';
		xhr.setRequestHeader('Content-Type', "text/xml; charset=utf-8");
		xhr.setRequestHeader("SOAPAction", namespace + '/' + method);
		// 发送HTTP请求
		xhr.send(data);
		data = null
		return xhr
	}
	
	$.DHCRequestJson = function(jsonUrl,successBlock,failureBlock) {
		jsonUrl = jsonFilePath + jsonUrl
		var xhr = null;
		if (window.XMLHttpRequest) {
			xhr = new XMLHttpRequest();
		} else if (window.ActiveXObject) {
			xhr = new ActiveXObject("Microsoft.XMLHTTP");
		}
		xhr.onload = function(e) {
			var str = e.target.responseText;
			successBlock(str);
			successBlock = null
			failureBlock = null
			xhr=null
		}
		xhr.onerror = function(e) {
			var errorStr = '服务器请求失败';
			failureBlock(errorStr);
			successBlock = null
			failureBlock = null
			xhr=null
		}
		xhr.onabort = function(e) {
			var errorStr = '服务器请求中断';
			failureBlock(errorStr);
			successBlock = null
			failureBlock = null
			xhr=null
		}
		xhr.ontimeout = function(e) {
			var errorStr = '服务器请求超时';
			failureBlock(errorStr);
			successBlock = null
			failureBlock = null
			xhr=null
		}
	
		xhr.open("GET", jsonUrl);
		xhr.setRequestHeader('Content-Type', 'application/json');
		// 发送HTTP请求
		xhr.send();
	}
	
})(mui);

// 初始化
function initToken() {
	//删除
	// localStorage.removeItem("token");
	var tmpToken = localStorage.getItem("token");
	if (tmpToken==undefined){
		tmpToken=""
	}
	// 获取url中的token
	var token = getUrlParam('token');
	if (token == "" && tmpToken == "")
	{
		mui.toast("没有授权码！！！");
		return;
	}else{
		localStorage.setItem("token", token);
	}
}

// 获取URL 参数
function getUrlParam (name) {
	var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
	var r = window.location.search.substr(1).match(reg);
	if (r != null)
	{
		return unescape(r[2]);
	}
	return "";
}


// 安全校验
function checkToken(Block) {
	if (!isShowVersion) {
		return
	}
	var token = localStorage.getItem("token");
	if (token == "")
	{
		mui.toast("没有授权码！！！");
		callBackPage();
		if (Block) {
			Block('err')
			Block = null
		}
		return;
	}
	var paramStr = {token:token};
	mui.DHCWebService('CheckToken', paramStr, function(result) {
		if (result != "1")
		{
			// 弹出报错信息
			mui.toast("系统未授权或授权码过期，请联系管理员！");
			if (!ISMOBILE && !isLoginPage) {
				localStorage.removeItem("token");
				callBackPage();
			}
			if (Block) {
				Block('err')
			}
		}else{
			if (Block) {
				Block()
			}
		}
		Block = null
	}, function(errorStr) {
		alert(errorStr);
		if (Block) {
			Block('err')
		}
		Block = null
	});
}

function callBackPage(){
	// 判断当前页面是否是login页面
	var currentPage = window.location.href;
	if (currentPage.indexOf("login") > 0)
	{
		// 刷新当前界面
		window.location.reload();
	}else{
		// 跳转到登录页面
		window.location.href = "login/login.html";
	}	
	currentPage = null
}

/*
特殊字符	代替符号	特殊原因
&	&amp;   	每一个代表符号的开头字符
>	&gt;  	标记的结束字符
< 	&lt; 	标记的开始字符
" 	&quot;  	设定属性值
'   	&apos;   	设定属性值
*/
