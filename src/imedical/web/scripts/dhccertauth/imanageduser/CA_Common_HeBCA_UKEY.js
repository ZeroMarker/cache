var ca_key = (function() {
    
	//常量定义
	var Const_Vender_Code = "HeBCA";
    var Const_Sign_Type = "UKEY";
	var Global_Last_Login_CertInfo = "";
    var Global_Last_Login_SealInfo = "";
    var Global_Last_Login_Token = "";
    var Global_Last_Error_Code = "";
    var Global_Last_Error_Msg = "";
	
    function HebcaClient() {
        this.clientCtrl = null;
    }

    HebcaClient.prototype = {
        _GetClientCtrl: function() {
            if (this.clientCtrl) {
                return this.clientCtrl;
            } else {
                var certMgrObj;
                try {
                    //创建客户端插件, 兼容IE/非IE
                    certMgrObj = new HebcaP11XObject("HebcaP11X.CertMgr");
                } catch(e) {
                    alert(e.message);
                }
                //设置Licence
                certMgrObj.Licence = 'amViY55oZWKcZmhlnXxhaGViY2GXGmNjYWhcYgsECgYDTykqNzEiIilJKiEyJVchIk0gACAGCDo2IyAgRC0HIQQBNi9RIilJKgYDCwQxFgMrJDAwIJUggOgu64BMSVYIW7qucuBpjkZu';
                this.clientCtrl = certMgrObj;
                return this.clientCtrl;
            }
        },
        /*************** begin: npP11X增加 *************************
            由于非IE控件的异常只是个字符串, 因此需提供函数区分并转义
        ***********************************************************/
        LastError: function(err) {
            return HebcaP11XLastError(this._GetClientCtrl(), err);
        },
        /*************** end: npP11X修改 ********************/
        //调取key进行数字签名
        UILogin: function() {
            var c = this._GetClientCtrl().GetCert(0);
            c.UILogin();
        },
        
        GetUKeyCnt: function() {
            return this._GetClientCtrl().GetDeviceCount();
        },
        GetSltUKey: function(keySN) {
            var dCnt = this._GetClientCtrl().GetDeviceCount();
            for (var i=0;i<dCnt;i++) {
                var tmpDev = this._GetClientCtrl().GetDevice(i);
                if (keySN == tmpDev.SN) { return tmpDev }
            }
            return 'error';
        },
        //获取多个UKey信息
        GetUKeyInfoSet: function() {
            
            var dCnt = this._GetClientCtrl().GetDeviceCount();
            var tmpDev = "";
            var keyName = "";
            var keySN = "";
            var user = "";
            var userList = "";
            for (var i=0;i<dCnt;i++) {
                tmpDev = (this._GetClientCtrl().GetDevice(i));
                keyName = tmpDev.SelectSignCert().GetSubjectItem('CN');
                keySN = tmpDev.SN;
                //格式 keyName1||keySN1&&&keyName2||keySN2...alert(this._GetClientCtrl().SelectDevice());
                user = keyName+"||"+keySN;
                if (i==0) {
                    userList = user; 
                } else {
                    userList = userList+"&&&"+user;
                }
            }
            return userList;
        },
        GetDigest: function(text) {
            //HASH_MD5 = 0,
            //HASH_SHA1 = 1,
            //HASH_SM3 = 2,
            //return this.GetSltUKey(keySN).
            return (this._GetClientCtrl()).Util.HashText(text,1);
        },
        //调取key进行数字签名
        Sign: function(keySN,source,signalg,signflag) {
            var d = this.GetSltUKey(keySN);
            if (d=='error') {
                alert('未找到对应证书');
                return '';
            }
            var c =d.SelectSignCert()
            if (signflag == 1) {
                //signalg枚举
                //MD5RSA = 0,
                //SHA1RSA = 1,
                //SM3SM2 = 2,
                //SHA1SM2 = 3,
                //DEFAULTALG = 4,
               return c.SignText(source, signalg);
            } else {
               return c.SignFile(source, signalg);
            }
        },
        //得到签名证书内容B64格式
        GetSignCertB64: function(keySN) {
            var d = this.GetSltUKey(keySN);
            if (d=='error') {
                alert('未找到对应证书');
                return false;
            }
            return d.SelectSignCert().GetCertB64();
        },
        //得到签名证书的序列号
        GetSerialNumber: function(keySN) {
            return this.GetSltUKey(keySN).SelectSignCert().GetSerialNumber();
        },
        //得到证书单位名称
        GetCN: function(keySN) {
            var d =this.GetSltUKey(keySN);
            if (d=='error') {
                alert('未找到对应证书');
                return false;
            }
            return d.SelectSignCert().GetSubjectItem('CN');
        },
        //得到证书唯一项
        GetG: function(cert) {
            var dCnt = this._GetClientCtrl().GetDeviceCount();
            for (var i=0;i<dCnt;i++) {
                var tmpDev = this._GetClientCtrl().GetDevice(i);
                if (cert==tmpDev.SelectSignCert().GetCertB64()) {
                    return tmpDev.SelectSignCert().GetCertExtensionByOid("1.2.156.112586.1.4");
                }
            }
        },
        //得到证书唯一项
        GetIdentityID: function(keySN) {
            return this.GetSltUKey(keySN).SelectSignCert().GetCertExtensionByOid("1.2.156.112586.1.4");
        },
        //得到有效期
        GetValidTime: function(keySN) {
            return (new Date(this.GetSltUKey(keySN).SelectSignCert().NotBefore).toLocaleString()) +'-'+ (new Date(this.GetSltUKey(keySN).SelectSignCert().NotAfter)).toLocaleString();
        },
        //得到有效期
        GetNotAfter: function(keySN) {
            return this.GetSltUKey(keySN).SelectSignCert().NotAfter;
        },
        //得到设备SN
        GetDeviceSN: function() {
            return this._GetClientCtrl().SelectDevice().SN;
        },
        //登录设备
        UKeyLogin: function(keySN,pwd) {
            try {
                var d =this.GetSltUKey(keySN);
                if(d=='error')
                {
                    alert('未找到对应证书');
                    return false;
                }
                if(d.Logined)
                {
                    d.Logout();
                }
                d.Login(pwd);
                var sealSN = sealCtrl.SelectSealByCert(GetSignCert(keySN))
            	var ret2 = sealCtrl.Login(sealSN, pwd);
                //this._GetClientCtrl().SelectDevice().Login(pwd);
                return true;
            } catch(e) {
                alert(e.message);
                return false;
            }
            //this._GetClientCtrl().SelectDevice().Login(pwd);
        },
        //退出设备
        UKeyLogout: function(keySN) {
            this.GetSltUKey(keySN).Logout();
            //this._GetClientCtrl().SelectDevice().Logout();
        }
    };

    var GlobalHebcaP11XObj = null;
    /*******************************************************************************
         Function name : HebcaP11XObject
           Description : 创建HebcaP11X控件对象
                 Input : strP11xName 证书管理对象名称, 目前固定为 "HebcaP11X.CertMgr"
                Return : 返回证书管理对象实例
               Caution : 调用接口注意事项
                         1. 该接口在一个页面内只允许调用一次
                         2. 页面内需要<body>标签
    ---------------------------------------------------------------------------------
    ********************************************************************************/
    function HebcaP11XObject(strP11xName)
    {
        var certMgr = null;
        
        if (window.ActiveXObject !== undefined) {
            // IE 浏览器创建插件
            try {
                certMgr = new ActiveXObject("HebcaP11X.CertMgr"); 
            }
            catch(e) {
                throw Error("没有安装客户端软件或IE阻止其运行.");
            }
        }// 非IE浏览器加载使用embed方式加载插件
        else {
            var hebcaMimeType = "application/hebca-np11x-plugin";

            if (!(navigator.mimeTypes && navigator.mimeTypes[hebcaMimeType] && navigator.mimeTypes[hebcaMimeType].enabledPlugin)) {
                throw Error("请检查是否安装河北CA数字证书多浏览器客户端或被浏览器禁用!\r\n安装或启用后重新打开浏览器再试！");
                return null;
            }
            if (null != GlobalHebcaP11XObj) {
                return GlobalHebcaP11XObj;
            }
            var plugin_embed = document.createElement("embed"); 
            plugin_embed.setAttribute("id", "npP11Xplugin");  
            plugin_embed.setAttribute("type", hebcaMimeType);  
            plugin_embed.setAttribute("width", 0);  
            plugin_embed.setAttribute("height", 0);  
            document.body.appendChild(plugin_embed); 

            certMgr = document.getElementById("npP11Xplugin");
            try {
                //检测是否安装成功, 若被浏览器阻止, 会抛出异常.
                certMgr.CheckBlockedByBrowser();
            }
            catch(e) {
                throw Error("插件未安装或被浏览器阻止.");
                return null;
            }
            
            // 检测数字证书助手是否安装
            var bIsP11 = certMgr.CheckP11XInstalled();
            if(false == bIsP11) {
                throw Error("数字证书助手未安装.");
                return null;
            }
        }
        
        GlobalHebcaP11XObj = certMgr;
        return certMgr;
    }
    /*******************************************************************************
         Function name : HebcaP11XLastError
           Description : 捕获P11X抛出的异常信息
                 Input : err        异常信息对象
                Return : 无
               Caution : 请使用该接口转换异常信息, 只能输入一个参数, 参数为Error对象
    ---------------------------------------------------------------------------------
     
    ********************************************************************************/
    function HebcaP11XLastError()
    {
        var err;
        if (1 == arguments.length) {
            err = arguments[0];
        }
        else if(2 == arguments.length) {
            err = arguments[1];
        }
        else { return "HebcaP11XLastError参数不正确"; }
        
        if (window.ActiveXObject !== undefined) {
            return err.message; // IE浏览器直接返回异常描述
        }
        else {
            if (("NP11X_EXCEPTION_MSG" == err.message)||("NP11X_EXCEPTION_MSG" == err)) {
                /* 返回插件P11X的错误信息 */
                return GlobalHebcaP11XObj.GetLastErr();
            }
            else {
                /* 当发生类型异常时, 通常是由于调用了不支持的属性或者方法, 返回浏览器抛出的异常信息 */
                return err.message;
            }
        }
    }

	var GlobalHebcaWebSealObject = null;
	function HebcaWebSealObject()
	{
		//	alert("test");
	    var webSealCtrl = null;

	    // 一个页面只创建一次
	    if (null != GlobalHebcaWebSealObject)
	    {
	        return GlobalHebcaWebSealObject;
	    }
	    
	    if (window.ActiveXObject !== undefined)
	    {
	        // IE 浏览器创建插件
	        try{
	            var plugin_embed = document.createElement("OBJECT"); 
	            plugin_embed.setAttribute("id", "npHebcaWebSealPlugin");  
	            plugin_embed.setAttribute("width", 0);  
	        	plugin_embed.setAttribute("height", 0); 
	            plugin_embed.setAttribute("classid", "CLSID:AD05FC92-22B4-47D3-9D3A-A8558CBFB912");
	            document.documentElement.appendChild(plugin_embed); 

	            webSealCtrl = document.getElementById("npHebcaWebSealPlugin");
	        }
	        catch(e){
	            throw Error("没有安装客户端软件或IE阻止其运行.");
	        }
	    }
	    else // 非IE浏览器加载使用embed方式加载插件
	    {
	        var hebcaMimeType = "application/hebca-npwebseal-plugin";

	        if (!(navigator.mimeTypes && navigator.mimeTypes[hebcaMimeType] && navigator.mimeTypes[hebcaMimeType].enabledPlugin))
	        {
	            throw Error("请检查是否安装河北CA电子签章多浏览器客户端或被浏览器禁用!\r\n安装或启用后重新打开浏览器再试！");
	            return null;
	        }
	        

	        var plugin_embed1 = document.createElement("embed"); 
	        plugin_embed1.setAttribute("id", "npHebcaWebSealPlugin");  
	        plugin_embed1.setAttribute("type", hebcaMimeType);  
	        plugin_embed1.setAttribute("width", 0);  
	        plugin_embed1.setAttribute("height", 0);  
	        //var sealNode=document.getElementById("seal");
	        document.documentElement.appendChild(plugin_embed1); 
			//sealNode.appendChild(plugin_embed1);
					
					
	        webSealCtrl = document.getElementById("npHebcaWebSealPlugin");
	        
	        try{
	            //检测是否安装成功, 若被浏览器阻止, 会抛出异常.
	            webSealCtrl.CheckBlockedByBrowser();
	        }
	        catch(e)
	        {
	            throw Error("插件未安装或被浏览器阻止.");
	            return null;
	        }
	        
	    }
	    
	    GlobalHebcaMailClientObj = webSealCtrl;
	    return webSealCtrl;
	}

    //声明工具类对象
    var hebcaClient;
    var sealCtrl;
    //实例化工具类对象，进行证书操作
    try {
        hebcaClient = new HebcaClient();
        sealCtrl = new HebcaWebSealObject();
    } catch(e) {
        alert(e.message);
    }

    ///获取用户列表
    function GetUserList()
    {
        var userList = hebcaClient.GetUKeyInfoSet();
        return userList;
    }

    function HashData(inData)
    {
        return hebcaClient.GetDigest(inData);
    }

    ///接口返回签名结果
    function SignedData(content,key)
    {
        return sealAction(content,key);
    }

    ///接口返回签名结果
    function SignedOrdData(content,key)
    {
        return sealAction(content,key);
    }

    function GetSignCert(key)
    {
        return hebcaClient.GetSignCertB64(key);
    }

    /// 证书标识符，用于区分证书,放置用户证书唯一标识
    function GetUniqueID(cert)
    {
        try {
            return hebcaClient.GetG(cert);
        }
        catch(e) { alert(hebcaClient.LastError(e)); }
    }

    function GetCertNo(key)
    {
        try {
            return hebcaClient.GetSerialNumber(key);
        }
        catch(e) { alert(hebcaClient.LastError(e)); }
    }

    function Login(form_,key,password_)
    {
        password_ = password_ || "";
        if (iKeyExist(key)&&(SOF_IsLogin(key))&&(password_ == "")) {
            return true;
        }
        
        /*var objForm = eval(form_);
        if (objForm == null) {
            alert("表单错误");
            return false;
        }*/
        if (key == null || key == "") {
            alert("获取用户信息失败");
            return false;
        }
        if (password_ == null || password_ == "") {
            alert("请输入证书密码");
            return false;
        }
        /*if (password_.length < 6 || password_.length > 16) {
            alert("密码长度应该在4-16位之间");
            return false;
        }*/
        try {
            var ret = hebcaClient.UKeyLogin(key,password_);
            //签章系统做登陆
            var sealSN = sealCtrl.SelectSealByCert(GetSignCert(key))
            sealCtrl.Login(sealSN, password_);
            if (ret) {
                return true
            } else {
                return false;
            }
        } catch(e) { 
            return false; 
        }
    }

    function Logout(key)
    {
        try {
            return hebcaClient.UKeyLogout(key);
        } catch(e) {
            alert(hebcaClient.LastError(e)); 
        }
    }

    ///获取身份证号
    function GetIdentityID(key)
    {
        try {
            var idNo = hebcaClient.GetIdentityID(key);
            return idNo.substr(idNo.length-18);
        } catch(e) { 
            alert(hebcaClient.LastError(e)); 
        }
    }

    function GetCertSN(key)
    {
        try {
            return hebcaClient.GetSerialNumber(key);
        } catch(e) {
            alert(hebcaClient.LastError(e)); 
        }
    }

    function GetKeySN(key)
    {
        try {
            return hebcaClient.GetDeviceSN(key);
        } catch(e) {
            alert(hebcaClient.LastError(e)); 
        }
    }

    //判读是否登录过
    function SOF_IsLogin(key)
    {
        try {
            var d = hebcaClient.GetSltUKey(key);
            if((typeof(d) == 'string')&&(d=='error'))
                {
                      alert('未找到对应证书');
                     return false;
                }
            if(d.Logined)
            {
                return true;
            }
        } catch(e) {
            return false;
        }
        return false;
    }

    function GetPicBase64Data(key)
    {	
    	/*
        var deviceCount = hebcaClient._GetClientCtrl().GetDeviceCount();
		if (deviceCount > 1){
			alert("获取签章时,电脑只允许插入一个key,请拔出多余key后再进行相应操作!");
			return "";
		}
        */
    
	    var imgB64 = "";
	    try{
			var sealSN = sealCtrl.SelectSealByCert(GetSignCert(key));
			var imgB64 = sealCtrl.GetSealInfo(sealSN,"pic.data");
		}catch(e){
			imgB64 = "";
		}
        return imgB64;
        
        //程序输入默认密码方式
        /*var imgB64 = "";
	    try{
		    var sealSN = sealCtrl.SelectSealByCert(GetSignCert(key));
	        var sealB64 = sealCtrl.GetSeal(sealSN);
	        sealCtrl.Login(sealSN,"123456");
	        var signresult = sealCtrl.SignAndSealWithoutTimeStampCert("test",sealSN,1,false,false);
	        imgB64 = sealCtrl.GetCurrentSealInfo("pic.data");
		}catch(e){
			imgB64 = "";
		}
        return imgB64;*/
        
        //虚拟签名方式获取签章 
	    /*var imgB64 = "";
	    try{
		    var sealSN = sealCtrl.SelectSealByCert(GetSignCert(key));
	        var sealB64 = sealCtrl.GetSeal(sealSN);
	        var signresult = sealCtrl.SignAndSealWithoutTimeStampCert("test",sealSN,1,false,false);
	        imgB64 = sealCtrl.GetCurrentSealInfo("pic.data");
		}catch(e){
			imgB64 = "";
		}
        return imgB64;*/
    }

    function GetKeyPic(key)
    {
         return GetPicBase64Data(key);
    }

    function GetCertCNName(key)
    {
        try {
            return hebcaClient.GetCN(key);
        } catch(e) {
            alert(hebcaClient.LastError(e)); 
        }
    }

    //在网页中进行盖章签名
    function sealAction(content, key) {
        if (content == "" || typeof(content) == "undefined" || content == null) {
            alert("业务数据字段不能为空！");
            return false;
        } else {
            try {
                var sealSN = sealCtrl.SelectSealByCert(GetSignCert(key));
                //最后一个参数设为true则前端生成时间戳，设为false在服务断直接生成
                var signresult = sealCtrl.SignAndSealWithoutTimeStampCert(content,sealSN,1,false,false);
                return signresult;
            } catch (e) {
                alert(e.message);
            }
        }
    }

    function getUsrSignatureInfo(key)
    {
        var usrSignatureInfo = new Array();
        var usrSignatureInfo = {};
        usrSignatureInfo["identityID"] = GetIdentityID(key);
        usrSignatureInfo["certificate"] = GetSignCert(key);
        usrSignatureInfo["certificateNo"] = GetCertNo(key);
        usrSignatureInfo["CertificateSN"] = GetCertSN(key);
        usrSignatureInfo["uKeyNo"] = key;
        usrSignatureInfo["signImage"] = GetPicBase64Data(key);
        var certB64 = GetSignCert(key);
        usrSignatureInfo["UsrCertCode"] = GetUniqueID(certB64);
        usrSignatureInfo["CertName"] = GetCertCNName(key);
        return usrSignatureInfo;
    }

	function SOF_IsLogin(key) {
	    try {
            var d = hebcaClient.GetSltUKey(key);
            if((typeof(d) == 'string')&&(d=='error'))
                {
                      alert('未找到对应证书');
                     return false;
                }
            if(d.Logined)
            {
                return true;
            }
        } catch(e) {
            return false;
        }
        return false;
	}

	function oGetLastError() {
		return SOF_GetLastErrorMsg();
	}
	
	function iGetLoginedInfo() {
		var result = iGetData("GetLoginedInfo");
  		return result;
	}
	
	function iKeyExist(key) {
		var strUserList = GetUserList();
	    var arrUsers = strUserList.split('&&&');
		for (var i = 0; i < arrUsers.length; i++) {
			var user = arrUsers[i];
			if (user != "") {
				if (key == user.split('||')[1]) return true;
			}
		}
		return false;
	}
	
	function oLoginForm(paraObj) {
		paraObj = paraObj||"";
		var forceLogin = paraObj.forceLogin||false;
		
		/*
		if ((!forceLogin)&&(Global_Last_Login_CertInfo != "")) {
			if (SOF_IsLogin(Global_Last_Login_CertInfo.certContainer)) {
				return Global_Last_Login_CertInfo;
			}
		}
		*/
		
		if ((!forceLogin)) {
			var loginedCert = iGetLoginedInfo();
			if ((loginedCert.retCode == 0)&&(loginedCert.certContainer != "")) {
				if (iKeyExist(loginedCert.certContainer)&&(SOF_IsLogin(loginedCert.certContainer))) {
					loginedCert.signCert = GetSignCert(loginedCert.certContainer);
					loginedCert.userCertCode = GetUniqueID(loginedCert.signCert);
					loginedCert.certNo = GetCertNo(loginedCert.certContainer);
					Global_Last_Login_CertInfo = loginedCert;
					return Global_Last_Login_CertInfo;
				}
			}	
		}
		
		var url = "../csp/dhc.certauth.login.ukey.csp?venderCode=" + Const_Vender_Code + "&signType=" + Const_Sign_Type;
		var para = {
			GetUserList: function() {
				return GetUserList();
			},
			CheckPWD: function(key, pin) {
				return CheckPWD(key, pin);
			},
			GetSignCert: function(key) {
				return GetSignCert(key);
			},
			GetCertNo: function(key) {
				return GetCertNo(key);
			},
			GetUniqueID: function(cert,key) {
				return GetUniqueID(cert);
			}
		};
		var rtnStr = window.showModalDialog(url,para,"dialogWidth:350px;dialogHeight:350px;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;fullscreen=no");
		
		if ((typeof(rtnStr) == "undefined")||(rtnStr == "")) {
			return {retCode:"-2",retMsg:"登录失败"};
		}
		
		var rtn = $.parseJSON(rtnStr);
		if ((rtn)&&(rtn.retCode == "0")&&(rtn.hisUserName != "")) {
			Global_Last_Login_CertInfo = rtn;
		}
		
		return rtn||{retCode:"-2",retMsg:"登录失败"};
	}
	
    //校验输入的密码 正确返回空
	function CheckPWD(strCertID, strPin) {        
        if (key == null || key == "") {
            return "获取用户信息失败";
        }
        if (password_ == null || password_ == "") {
            return "请输入证书密码";
        }
        try {
            var ret = hebcaClient.UKeyLogin(key,password_);
            //签章系统做登陆
            //var sealSN = sealCtrl.SelectSealByCert(GetSignCert(key))
            //var ret2 = sealCtrl.Login(sealSN, password_);
            if (ret) {
                return "";
            } else {
                return "登录失败!";
            }
        } catch(e) { 
            return "登录失败!"; 
        }       
	}
    
    function iGetData(Func,P1,P2,P3,P4,P5,P6,P7,P8,P9) {
    	
    	var result = "";
    	
    	var para = {
	  		CAFunc: Func,
	  		CAVenderCode:Const_Vender_Code,
	  		CASignType:Const_Sign_Type,
	  		P1:P1||"",
	  		P2:P2||"",
	  		P3:P3||"",
	  		P4:P4||"",
	  		P5:P5||"",
	  		P6:P6||"",
	  		P7:P7||"",
	  		P8:P8||"",
	  		P9:P9||""
  		};
  		
  		$.ajax({
    		url: "../CA.Ajax.DS.cls",
    		type: "POST",
    		dataType: "JSON",
    		async: false,
            global:false,
    		data: para,
    		success: function(ret) {
            	if (ret && ret.retCode == "0") {
                	result = ret;
            	} else {
	            	alert(ret.retMsg);
            	}
            },
        	error: function(err) {
            	alert(err.retMsg || err);
        	}
  		});
  		
  		return result;
    }
	
    return {
    	OCX: hebcaClient,
    	VenderCode:Const_Vender_Code,
    	SignType:Const_Sign_Type,
    	GetRealKey: function(key) {
	    	return key;
    	},
        CheckPWD: function(key, pwd) {
            return CheckPWD(key, pwd);
        },
        CheckForm: function(key, strServerCert, strServerRan, strServerSignedData) {
            return CheckForm(key, strServerCert, strServerRan, strServerSignedData);
        },
        Login: function(strFormName, strCertID, strPin) {
            return Login(strFormName, strCertID, strPin);
        },
        IsLogin: function(strKey) {
            if ('undefined' != SOF_IsLogin) {
                return SOF_IsLogin(strKey);
            }
            return false;
        },
        GetUserList: function() {
            return GetUserList();
        },
		getUserList2: function() {
            return GetUserList();
        },
        GetSignCert: function(key) {
            return GetSignCert(key);
        },
        GetUniqueID: function(cert, key) {
            return GetUniqueID(cert, key);
        },
        GetCertNo: function(key) {
            return GetCertNo(key);
        },
        SignedData: function(contentHash, key) {
            return SignedData(contentHash, key);
        },
        SignedOrdData: function(contentHash, key) {
            return SignedOrdData(contentHash, key);
        },
        getUsrSignatureInfo: function(key) {
            return getUsrSignatureInfo(key);
        },
        HashData:function(content){
	    	return HashData(content);
	    },
		LoginForm:function(paraObj) {
		    return oLoginForm(paraObj);
	    },
	  	GetPicBase64Data:function(key) {
	    	return GetPicBase64Data(key);
		},
		GetLastError:function() {
	    	return oGetLastError();
	    }
    }
})();

///1.登录相关
///登录验证
function Login(strFormName, key, pin) {
	return ca_key.Login(strFormName, key, pin);
}
///是否登陆过
function IsLogin(key) {
	return ca_key.IsLogin(key);
}
function SOF_IsLogin(key) {
	return ca_key.IsLogin(key);
}

///2.证书列表
///获取证书列表
function GetUserList() {
	return ca_key.GetUserList();
}
function GetList_pnp() {
	return ca_key.GetUserList();
}
function getUserList2() {
	return ca_key.GetUserList();
}
function getUserList_pnp() {
	return ca_key.GetUserList();
}

///3.证书信息
///获取containerName
function GetRealKey(key) {
	return ca_key.GetRealKey(key);
}
///获取证书base64编码
function GetSignCert(key) {
	return ca_key.GetSignCert(key);
}
///获取CA用户唯一标识
function GetUniqueID(cert,key) {
	return ca_key.GetUniqueID(cert,key);
}
///获取证书唯一标识
function GetCertNo(key) {
	return ca_key.GetCertNo(key);
}
///获取证书信息集合
function getUsrSignatureInfo(key) {
	return ca_key.getUsrSignatureInfo(key);
}

///4.签名相关
///对待签数据做Hash
function HashData(content){
	return ca_key.HashData(content) 
}
///对待签数据的Hash值做签名
function SignedData(contentHash, key) {
	return ca_key.SignedData(contentHash, key)
}
function SignedOrdData(contentHash, key) {
	return ca_key.SignedOrdData(contentHash, key)
}

///5.其他
function CheckPWD(key, pwd) {
    return ca_key.CheckPWD(key, pwd);
}
function CheckForm(key, strServerCert, strServerRan, strServerSignedData) {
    return ca_key.CheckForm(key, strServerCert, strServerRan, strServerSignedData);
}
function LoginForm(paraObj) {
	return ca_key.LoginForm(paraObj);
}
function GetLastError() {
    return ca_key.GetLastError();
}