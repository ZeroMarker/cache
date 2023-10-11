function HebcaHandClient() {
    this.clientCtrl = null;
}

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
function HebcaHandP11XObject(strP11xName)
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
        var HebcaHandMimeType = "application/hebca-np11x-plugin";

        if (!(navigator.mimeTypes && navigator.mimeTypes[HebcaHandMimeType] && navigator.mimeTypes[HebcaHandMimeType].enabledPlugin)) {
            throw Error("请检查是否安装河北CA数字证书多浏览器客户端或被浏览器禁用!\r\n安装或启用后重新打开浏览器再试！");
            return null;
        }
        if (null != GlobalHebcaHandP11XObj) {
            return GlobalHebcaHandP11XObj;
        }
        var plugin_embed = document.createElement("embed"); 
        plugin_embed.setAttribute("id", "npP11Xplugin");  
        plugin_embed.setAttribute("type", HebcaHandMimeType);  
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
    
    GlobalHebcaHandP11XObj = certMgr;
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
function HebcaHandP11XLastError()
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
            return GlobalHebcaHandP11XObj.GetLastErr();
        }
        else {
            /* 当发生类型异常时, 通常是由于调用了不支持的属性或者方法, 返回浏览器抛出的异常信息 */
            return err.message;
        }
    }
}


var GlobalHebcaEnrollCtrlObj = null;

/*******************************************************************************
     Function name : HebcaEnrollCtrlObject
       Description : 创建HebcaEnrollCtrl控件对象
             Input : strP11xName 证书管理对象名称, 目前固定为 "HebcaEnrollCtrl.HebcaEnroll"
            Return : 返回采集控件对象实例
           Caution : 调用接口注意事项
                     1. 该接口在一个页面内只允许调用一次
                     2. 页面内需要<body>标签
---------------------------------------------------------------------------------
 
********************************************************************************/
function HebcaEnrollCtrlObject(strEnrollCtrlName)
{
    var HebcaEnroll = null;
        
    if (window.ActiveXObject !== undefined)
    {
        // IE 浏览器创建插件
        try{
            HebcaEnroll = new ActiveXObject("HebcaEnrollCtrl.HebcaEnroll"); 
        }
        catch(e){
            throw Error("没有安装客河北CA采集控件或IE阻止其运行.");
        }
    }
    else // 非IE浏览器加载使用embed方式加载插件
    {
        var hebcaMimeType = "application/hebca-nphebcaenrollctrl-plugin";

        if (!(navigator.mimeTypes && navigator.mimeTypes[hebcaMimeType] && navigator.mimeTypes[hebcaMimeType].enabledPlugin))
        {
            throw Error("请检查是否安装河北CA采集控件多浏览器客户端或被浏览器禁用!\r\n安装或启用后重新打开浏览器再试！");
            return null;
        }
        
        if (null != GlobalHebcaEnrollCtrlObj)
        {
            return GlobalHebcaEnrollCtrlObj;
        }

        var plugin_embed = document.createElement("embed"); 
        plugin_embed.setAttribute("id", "npHebcaEnrollCtrlplugin");  
        plugin_embed.setAttribute("type", hebcaMimeType);  
        plugin_embed.setAttribute("width", 0);  
        plugin_embed.setAttribute("height", 0);  
        document.documentElement.appendChild(plugin_embed); 

        HebcaEnroll = document.getElementById("npHebcaEnrollCtrlplugin");
        
        try{
            //检测是否安装成功, 若被浏览器阻止, 会抛出异常.
            HebcaEnroll.CheckBlockedByBrowser();
        }
        catch(e)
        {
            throw Error("插件未安装或被浏览器阻止.");
            return null;
        }
        
        // 检测数字证书助手是否安装
        var bIsEnrollCtrlInstall = HebcaEnroll.CheckHebcaEnrollInstalled();
        if(false == bIsEnrollCtrlInstall)
        {
            throw Error("采集控件未安装");
            return null;
        }

    }
    
    GlobalHebcaEnrollCtrlObj = HebcaEnroll;
    return HebcaEnroll;
}

try {
    HebcaHandClient.prototype = {
        _GetClientCtrl: function() {
            if (this.clientCtrl) {
                return this.clientCtrl;
            } else {
                var certMgrObj;
                try {
                    //创建客户端插件, 兼容IE/非IE
                    certMgrObj = new HebcaHandP11XObject("HebcaP11X.CertMgr");
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
            return HebcaHandP11XLastError(this._GetClientCtrl(), err);
        },
        /*************** end: npP11X修改 ********************/
        GetDigest: function(text) {
            return (this._GetClientCtrl()).Util.HashText(text,1);
        },
        SignValue: function(source) {
            var dc;
            var d=null;
            var deviceName;
            var signValue="";
            var objCert=null;
            var certCount;
            dc = this._GetClientCtrl().GetDeviceCount();
            if(dc > 0){
                for(var i = 0; i < dc; i++){
                    d = this._GetClientCtrl().GetDevice(i);
                    deviceName = d.Name;
                    if(deviceName == "河北CA数字证书设备-ZTXA"){
                        certCount = d.GetSignCertCount();
                        for(var j = 0; j < certCount; j++){
                            objCert = d.GetSignCert(j);
                            if(!objCert.Logined)
                            {
                                objCert.Login("123456");
                            }
                            //d.Login("123456");
                            signValue = objCert.SignText(source,1);
                        }
                        break;
                    }
                    else
                    {
                        d =null;
                        deviceName="";
                    }
                }
                return signValue;
            }
            else
            {
                alert("当前未插入任何数字证书设备");
                return "";
            }
	    },
        //得到签名证书内容B64格式
        GetSignCertB64: function() {
            var dc;
	        var d=null;
	        var deviceName;
	        var CertB64="";
	        var objCert=null;
	        var certCount;
            dc = this._GetClientCtrl().GetDeviceCount();
            if(dc > 0){
                for(var i = 0; i < dc; i++){
                    d = this._GetClientCtrl().GetDevice(i);
                    deviceName = d.Name;
                    if(deviceName == "河北CA数字证书设备-ZTXA")
                    {
                        certCount = d.GetSignCertCount();
                        for(var j = 0; j < certCount; j++){
                            objCert = d.GetSignCert(j);
                            CertB64 = objCert.GetCertB64();
                        }
                        break;
                    }
                    else
                    {
                        d =null;
                        CertB64="";
                    }
                }
	        }
            return CertB64;
        }
    };

    var GlobalHebcaHandP11XObj = null;
    

    //声明工具类对象
    var HebcaHandClient;
    //实例化工具类对象，进行证书操作
    HebcaHandClient = new HebcaHandClient();

    var HebcaHandEnrol;
    // 创建患者签名插件
    HebcaHandEnrol = new HebcaEnrollCtrlObject("HebcaEnrollCtrl.HebcaEnroll");
} catch (e) {
    alert(e.message);
}

var handSignInterface = {
    checkStatus: function () {
        if ((!HebcaHandClient)||(!HebcaHandEnrol))
            return false;
        return true;
    },
    connectAndOpenDevice: function (type) {
        //1只采集指纹；2只采集手写签名；3采集手写签名和指纹
        try
        {
 			if (window.ActiveXObject !== undefined) {
                HebcaHandEnrol.initialize();
            } else {
                HebcaHandEnrol.Initialize();
            }
            HebcaHandEnrol.OpenDevice(type);
            HebcaHandEnrol.Enroll();
		}
        catch(err)
        {
            alert(err.description);
            return false;
		}
        return true;
    },
    getSignScript: function () {
        try 
        {
            var result = HebcaHandEnrol.GetSignImage();
            result = result.replace(/\r\n/g,"");
            return result;
        }catch(e){
            alert("获取笔迹图失败：" + e.description);
            return '';
        }
    },
    getSignFingerprint: function () {
        try 
        {
            var result = HebcaHandEnrol.GetFPImage();
            result = result.replace(/\r\n/g,"");
            return result;
        }catch(e){
            alert("获取指纹图失败：" + e.description);
            return '';
        }
    },
    getSignScriptAndFinger: function () {
        try 
        {
            var result = HebcaHandEnrol.GetMixedImage(25);
            result = result.replace(/\r\n/g,"");
            return result;
        }catch(e){
            alert("获取指纹图失败：" + e.description);
            return '';
        }
    },
    getSignPhoto: function () {
        return '';
    },
    getAlgorithm: function () {
        return '';
    },
    getBioFeature: function () {
        return '';
    },
    getEventCert: function () {
        try 
        {
            var result = HebcaHandClient.GetSignCertB64();
            return result;
        }catch(e){
            alert("获取签名值失败：" + e.description);
            return '';
        }
    },
    getSignValue: function (data) {
        try 
        {
            var result = HebcaHandClient.SignValue(data);
            return result;
        }catch(e){
            alert("获取签名值失败：" + e.description);
            return '';
        }
    },
    getHashValue: function (data) {
        return HebcaHandClient.GetDigest(data);
    },
    getTSValue: function () {
        return '';
    },
    getVersion: function () {
        return '';
    },
    getTime: function () {
	    var date = new Date();
	    var seperator1 = "-";
	    var seperator2 = ":";
	    var month = date.getMonth() + 1;
	    var strDate = date.getDate();
	    if (month >= 1 && month <= 9) {
	        month = "0" + month;
	    }
	    if (strDate >= 0 && strDate <= 9) {
	        strDate = "0" + strDate;
	    }
	    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
	            + " " + date.getHours() + seperator2 + date.getMinutes() + seperator2 + date.getSeconds();
	    return currentdate;
    },
    closeDevice:function() {
	    try 
        {
           HebcaHandEnrol.CloseDevice();
        }catch(e){
            alert("关闭设备异常：" + e.description);
        }
    }
};

var handSign = {
    sign: function (parEditor) {
        var isSigned = false;
        if (!handSignInterface && !handSignInterface.checkStatus()) {
            alert('请配置手写签名设备');
            return;
        }

        //1：只采集指纹； 2：只采集手写签名； 3：采集手写签名和指纹
        if (!handSignInterface.connectAndOpenDevice(3)) {
            return;
        }

        try {
            // 获取图片
            //var signScript = handSignInterface.getSignScript();
            //var signFingerprint = handSignInterface.getSignFingerprint();
            var signScript = handSignInterface.getSignScriptAndFinger();
            var signFingerprint = "";
            var signPhoto = handSignInterface.getSignPhoto();
            
            if ((signScript == "")&&(signFingerprint == ""))
                return;
        
            var signLevel = 'Patient';
            var signUserId = parEditor.userId || 'Patient';
            var userName = 'Patient';
            var actionType = parEditor.actionType || 'Append';
            var description = '患者';
            var img = signScript;
            var headerImage = signPhoto;
            var fingerImage = signFingerprint;
            var path = parEditor.path || '';
            // 获取编辑器hash
            var signInfo = parEditor.signDocument(parEditor.instanceId, 'Graph', signLevel, signUserId, userName, img, actionType, description, headerImage, fingerImage, path);
            
            if (signInfo.result == 'OK') {
                isSigned = true;
                // 签名
                //var signScriptHash = handSignInterface.getHashValue(signScript);
                //var signFingerprintHash = handSignInterface.getHashValue(signFingerprint);
                //var toSignValue = 'Digest-'+signInfo.Digest+'-SignScriptHash-'+signScriptHash+'-SignFingerprintHash-'+signFingerprintHash+'-Time-'+handSignInterface.getTime()+'-InstanceId-'+parEditor.instanceId;
                
                var signScriptHash = handSignInterface.getHashValue(signScript);
                var toSignValue = 'Digest-'+signInfo.Digest+'-SignScriptHash-'+signScriptHash+'-Time-'+handSignInterface.getTime()+'-InstanceId-'+parEditor.instanceId;
                
                var signValue = handSignInterface.getSignValue(toSignValue);
                if ('' == signValue){
	            	parEditor.unSignedDocument();   
	            	return; 
	            } 
                
                //关闭设备
                handSignInterface.closeDevice();
                
                // 向后台保存
                var argsData = {
                    Action: 'SaveSignInfo',
                    InsID: parEditor.instanceId,
                    Algorithm: handSignInterface.getAlgorithm(),
                    BioFeature: toSignValue,
                    EventCert: handSignInterface.getEventCert(),
                    SigValue: signValue,
                    TSValue: handSignInterface.getTSValue(),
                    Version: handSignInterface.getVersion(),
                    SignScript: img,
					HeaderImage: headerImage,
                    Fingerprint: fingerImage,
                    PlainText: signInfo.Digest,
                    SignData: ''
                };

                $.ajax({
                    type: 'POST',
                    dataType: 'text',
                    url: '../EMRservice.Ajax.anySign.cls',
                    async: false,
                    cache: false,
                    data: argsData,
                    success: function (ret) {
                        ret = $.parseJSON(ret);
                        if (ret.Err || false) {
                            throw {
                                message : 'SaveSignInfo 失败！' + ret.Err
                            };
                        } else {
                            if ('-1' == ret.Value) {
                                throw {
                                    message : 'SaveSignInfo 失败！'
                                };
                            } else {
                                var signId = ret.Value;
                                parEditor.saveSignedDocument(parEditor.instanceId, signUserId, signLevel, signId, signInfo.Digest, 'AnySign', signInfo.Path, actionType);
                            }
                        }
                    },
                    error: function (err) {
                        throw {
                            message : 'SaveSignInfo error:' + err
                        };                        
                    }
                });

            } else {
                throw {
                    message : '签名失败'
                };
            }
        } catch (err) {
            if (err.message === '用户取消签名,错误码：61') {
                return;
            }
            else if (isSigned) {
                parEditor.unSignedDocument();
            }
            alert(err.message);
        }
    }
};
