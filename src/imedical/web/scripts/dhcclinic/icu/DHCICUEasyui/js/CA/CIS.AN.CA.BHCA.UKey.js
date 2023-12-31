/**
 * 天津滨海CA签名证书程序
 */
const ca_key = (function () {
    const VenderCode = "BHCA";
    const SignType = "UKey";

    function getData(Action, Params) {
        var result = "";

        var paramData = ""
        if(Params){
            var toSaveDatas = [];
            toSaveDatas.push(Params)
            paramData = dhccl.formatObjects(toSaveDatas);
        }

        $.ajax({
            url: "../CIS.AN.CA.SignService.cls",
            type: "POST",
            dataType: "JSON",
            async: false,
            cache: false,
            data: {
                VenderCode: VenderCode,
                SignType: SignType,
                Action: Action,
                Params: paramData
            },
            success: function (ret) {
                result = ret;
            },
            error: function (err) {
                console.error(err||err.ErrorMsg);
            }
        });

        return result;
    }

    function getConfig(){
        return {
            url: "http://127.0.0.1:38877/tjca/gmt0020/",   //请求地址
            BHCA_CERT_SUBJECT_CN : 0x00000031,             //证书拥有者信息CN
            BHCA_CERT_SUBJECT_OU : 0x00000033,             //证书拥有者信息OU
            KSDKTYPE : 0,                                  //证书类型：0 - 用户选择（UKEY、PC软盾、手机盾），1 - UKEY，2 - PC软盾，3 - 手机盾                   
        }
    }

    /** 获取配置信息 */
    const config = getConfig();

    function getUserCertList(){
        
    }

    function checkPWD(key, pwd){
        
    }

    function hashData(inData){

    }

    /**
     * 
     * params: {
     *  toSignData: '',             //待签名数据
     *  callback: function(cartn){  //'签名回调方法'
     *     
     *  }
     * }
     */
	function showLoginForm(params){
		var logintype = 0;   //记录选择的登录类型
		signData(params.toSignData, logintype, params.callback);
	}
	
	
    function login(params){
        var logintype = 0;   //记录选择的登录类型
		var url = config.url;
        var cert = "";
        var cn = "";
        var ou = "";
        var uniqueID = "";
        var img = "";

        var data = JSON.stringify({
            "func_name": "BHCA_Login",
            "param0": config.KSDKTYPE
        });
        $.ajax({
            url: url,
            type: 'POST',
            data: data,
            dataType: 'json',
            async: true,
            cache:false,
            ifModified :true,
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert("服务端返回数据异常，HTTP状态码:" + XMLHttpRequest.status);
            },
            success: function (res) {
                var result = res.result;
                if (result == 0) {
                    var content = Base64.decode(res.content);
                    content = JSON.parse(content);
                    result = content.result;
                    if (result == 0) {
                        alert("认证登录成功");
                        cert = content.cert;
                        logintype = parseInt(content.login_type);
                        cn = getSignCertCN(cert);
                        ou = getSignCertOU(cert);
                        uniqueID = getUniqueID(logintype);
                        var stampRes = content.stamp;
                        if (stampRes == null) {
                            alert("获取签名图片为空");
                            return;
                        }
                        if (stampRes.Status == 0) {
                            var list = stampRes.Result;
                            if (list == null) return;
                            var stamp = list[0].img.toString();
                            img = "data:image/png;base64," + stamp;

                            signData(params.toSignData, logintype, params.callback);



                        } else alert("获取签名图片失败，错误码：" + stampRes.ErrorCode.toString());
                    } else alert("认证登录失败，错误码：" + result.toString());
                } else alert("认证登录失败，错误码：" + result.toString());
            }
        });
    }

    // 解析证书CN项
    function getSignCertCN(cert) {
		var url = config.url;
        var cn = "";
        var data = JSON.stringify({
            "func_name": "SOF_GetCertInfo",
            "param0": cert,
            "param1": config.BHCA_CERT_SUBJECT_CN
        });
        $.ajax({
            url: url,
            type: 'POST',
            data: data,
            dataType: 'json',
            async: false,
            cache: false,
            ifModified :true,
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert("服务端返回数据异常，HTTP状态码:" + XMLHttpRequest.status);
            },
            success: function (res) {
                if (res.result == 0) {
                    cn = res.content;
                    if (cn == "") alert("解析证书CN项为空");
                } else alert("解析证书CN项失败");
            }
        });

        return cn;
    }

    // 解析证书OU项
    function getSignCertOU(cert) {
		var url = config.url;
        var ou = "";
        var data = JSON.stringify({
            "func_name": "SOF_GetCertInfo",
            "param0": cert,
            "param1": config.BHCA_CERT_SUBJECT_OU
        });
        $.ajax({
            url: url,
            type: 'POST',
            data: data,
            dataType: 'json',
            async: false,
            cache:false,
            ifModified :true,
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert("服务端返回数据异常，HTTP状态码:" + XMLHttpRequest.status);
            },
            success: function (res) {
                if (res.result == 0) {
                    ou = res.content;
                    if (ou == "") alert("解析证书OU项为空");
                } else alert("解析证书OU项失败");
            }
        });

        return ou;
    }

    // 获取使用者唯一标识
    function getUniqueID(logintype) {
		var url = config.url;
        var uniqueID = "";	
        var data = JSON.stringify({
            "func_name": "BHCA_UniqueID",
            "param0": logintype
        });
        $.ajax({
            url: url,
            type: 'POST',
            data: data,
            dataType: 'json',
            async: false,
            cache:false,
            ifModified :true,
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert("服务端返回数据异常，HTTP状态码:" + XMLHttpRequest.status);
            },
            success: function (res) {
                var result = res.result;
                if (result == 0) {
                    var content = Base64.decode(res.content);
                    uniqueID = content;
                } else alert("获取使用者唯一标识失败，错误码：" + result.toString());
            }
        });
        return uniqueID;
    }

    // 签名（带时间戳、签章）
    function signData(originalData, logintype, callback) {
		var url = config.url;
        if (originalData == "") {
            alert("请先输入待签名原文");
            return;
        }
        var data = JSON.stringify({
            "func_name": "BHCA_SignData",
            "param0": logintype,
            "param1": Base64.encode(originalData)
        });
        $.ajax({
            url: url,
            type: 'POST',
            data: data,
            dataType: 'json',
            async: true,
            cache:false,
            ifModified :true,
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert("服务端返回数据异常，HTTP状态码:" + XMLHttpRequest.status);
            },
            success: function (res) {
                var result = res.result;
                if (result == 0) {
                    var content = Base64.decode(res.content);
                    content = JSON.parse(content);
                    result = content.result;
                    if (result == 0) {
                        var signCert = content.cert;
                        var signedData = content.sign;
                        var timeStamp = content.timestamp;
						var hashData = content.sign;
						var uniqueId = getUniqueID(2);
						if(!uniqueId) uniqueId = getUniqueID(1);
						if(!uniqueId) uniqueId = getUniqueID(3);
                        var img = ""
                        var stampRes = content.stamp;
                        if (stampRes == null) {
                            alert("获取签名图片为空");
                            return;
                        }
                        
                        if (stampRes.Status == 0) {
                            var list = stampRes.Result;
                            if (list == null) return;
                            var stamp = list[0].img.toString();
                            img = "data:image/png;base64," + stamp;
	
                            callback({
								userCertCode: uniqueId,
								certNo: signCert,
                                signedData: signedData,
                                timeStamp: timeStamp,
								hashData: hashData,
                                img: img
                            });

                        } else alert("获取签名图片失败，错误码：" + stampRes.ErrorCode.toString());
                    } else alert("签名失败，错误码：" + result.toString());
                } else alert("签名失败，错误码：" + result.toString());
            }
        });
    }

    return {
        /*返回当前插入的UsbKey中用户列表 */
        GetUserList: function () {
            return getUserCertList();
        },

        /*对传入的数据生成Hash值 */
        HashData: function (InData) {
            return hashData(InData);
        },

        /*对传入的数据进行签名 */
        SignedData: function (hashData, key) {

        },

        /*获取用户签名证书 */
        GetSignCert: function (key) {

        },

        /*获取证书的唯一编码，注：请选取证书的固定的项，例如包含身份证号的字符串，用户工号等 */
        GetUniqueID: function (cert, key) {

        },

        /*获取证书编号 */
        GetCertNo: function (key) {

        },

        /*证书密码校验（或称为UKey Pin码校验、登录） */
        Login: function (Form, key, pwd) {
            
        },

        /*签名证书界面 */
        LoginForm: function(params){
            return showLoginForm(params);
        },

        /*获取UKey中的信息，如果UsbKey或证书中中无相应的项目,请返回空值 */
        GetUsrSignatureInfo: function (key) {

        },

        /*获取证书持有人身份证号，可不提供 */
        GetIdentityID: function (key) {

        },

        /*获取证书持有人姓名，可不提供 */
        GetCertCNName: function (key) {

        },

        /*获取证书持有人签名图片，可不提供。注：如不提供，不实现图片签名 */
        GetKeyPic: function (key) {

        },

        /*判断证书登录状态，用于实现登录一次后，后续签名免密，可不提供 */
        IsLogin: function (key) {

        }
    }
})();

