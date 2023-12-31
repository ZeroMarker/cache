function dhcsys_getcacert(options, logonType, singleLogon, forceOpen) {
    var isHeaderMenuOpen = true;
    var SignUserCode = "";
    var notLoadCAJs = 0,
        loc = "",
        groupDesc = "";
    var callback = undefined;
    if ("object" == typeof options) {
        if ("undefined" !== typeof options.isHeaderMenuOpen) isHeaderMenuOpen = options.isHeaderMenuOpen;
        if ("undefined" !== typeof options.SignUserCode) SignUserCode = options.SignUserCode;
        if ("undefined" !== typeof options.notLoadCAJs) notLoadCAJs = options.notLoadCAJs
        if ("undefined" !== typeof options.loc) loc = options.loc
        if ("undefined" !== typeof options.groupDesc) groupDesc = options.groupDesc;
        callback = options.callback;
    }
    if ("function" == typeof options) {
        callback = options;
    }
    var win = websys_getMenuWin() || window;
    if (isHeaderMenuOpen) {
        if (win != self && win.dhcsys_getcacert) { //force to menu iframe
            // return win.dhcsys_getcacert(options, logonType, singleLogon, forceOpen);
        }
    }
    if ("undefined" === typeof singleLogon) singleLogon = 1;
    if ("undefined" === typeof logonType || "" == logonType) {
        logonType = "UKEY";
        if (win.LastCALogonType) logonType = win.LastCALogonType;
    }
    if ("undefined" === typeof forceOpen) forceOpen = 0;
    var obj = {},
        varCert = "",
        ContainerName = "",
        CTLoc = "",
        arr = [],
        rtn = {};
    var failRtn = {
        IsSucc: false,
        varCert: "",
        ContainerName: "",
        "IsCA": false
    };
    if (loc != "") {
        CTLoc = loc
    } else {
        if (session.ExtDeptID) {
            CTLoc = session.ExtDeptID;
        }
    }

    if (CTLoc == "") {
        rtn = {
            IsSucc: true,
            varCert: "",
            ContainerName: "",
            "IsCA": false
        };
        if (callback) callback(rtn);
        return rtn;
    }
    var userName = session.ExtUserCode;
    if ("0" == forceOpen) {
        var flag = IsCaLogon(CTLoc, userName, groupDesc);
        if (flag == 0) { //2019-03-27
            rtn = {
                IsSucc: true,
                varCert: "",
                ContainerName: "",
                "IsCA": false
            };
            if (callback) callback(rtn);
            return rtn;
        }
        ContainerName = dhcsys_getContainerNameAndPin();
        if (ContainerName.indexOf("^") > -1) {
            arr = ContainerName.split("^");
            ContainerName = arr[0];
            logonType = arr[2] || "UKEY";
        }
    }

    if (ContainerName) {
        var rtn = {
            "IsCA": true,
            IsSucc: true,
            ContainerName: ContainerName,
            UserName: arr[7] || "",
            UserID: arr[6] || "",
            CALogonType: arr[2] || "",
            CAUserCertCode: arr[3] || "",
            CACertNo: arr[4] || "",
            CAToken: arr[5] || "",
            ca_key: win.ca_key || ""
        };
        if (logonType == "PHONE" || logonType == "PINPHONE") {
            try {
                rtn.varCert = win.GetSignCert(ContainerName);
            } catch (ex) {};
            if (callback) callback(rtn);
            return rtn;
        }
        if (logonType == "UKEY") {
            // SessionContainerName=CurrentUKeyContainerName?
            if (notLoadCAJs == 1) {
                if (callback) callback(rtn);
                return rtn;
            }
            var userList = win.GetUserList(); //Name||key&&& Name||key
            var causerArr = userList.split("&&&");
            for (var i = 0; i < causerArr.length; i++) {
                if (causerArr[i].split("||").length > 1 && causerArr[i].split("||")[1] == ContainerName) {
                    try {
                        rtn.varCert = win.GetSignCert(ContainerName);
                    } catch (ex) {};
                    if (callback) callback(rtn);
                    return rtn;
                }
            }
        }
    }
    // not calogon show calogon dialog
    obj = dhcsys_calogonshow(CTLoc, userName, logonType, singleLogon);
    if (obj.IsSucc && obj.ContainerName) {
        //ie error-> not exec [destory script]
        //obj.varCert = obj.ca_key.GetSignCert(obj.ContainerName);
        try {
            obj.varCert = win.GetSignCert(obj.ContainerName);
        } catch (ex) {};
        obj.ca_key = win.ca_key || "";
        if (obj) callback(obj);
    }
    return obj;
}


function tkMakeServerCall() {
    var result = null;
    if (arguments.length < 2) return result;
    var className = arguments[0];
    var methodName = arguments[1];
    var params = [];
    for (var i = 2; i < arguments.length; i++) {
        if (params.length > 0) params.push(splitchar.comma);
        params.push("\"" + arguments[i] + "\"");
    }
    $.ajax({
        url: ANCSP.MethodService,
        async: false,
        data: {
            ClassName: className,
            MethodName: methodName,
            Params: params.join("")
        },
        type: "post",
        success: function (data) {
            result = $.trim(data);
        }
    });
    return result;
}

/**
 * BJCA签名证书程序
 */
const ca_key = (function () {


    const VenderCode = "Mediway";
    const SignType = "Pin";

    function getData(Action, Params) {
        var result = "";

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
                Params: Params
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
            
        }
    }

    /** 获取配置信息 */
    const config = getConfig();

    function hashData(inData){

    }

    function signData(hashData, key){

    }

    /**
     * 
     * params: {
     *  userCode: '',               //用户代码
     *  toSignData: '',             //待签名数据
     *  callback: function(cartn){  //'签名回调方法'
     *     
     *  }
     * }
     */
    function showLoginForm(params){
        var signCode = params.signCode;
        var toSignData = params.toSignData;
        var EpisodeID = session.EpisodeID;

        var logonType = ""; //UKEY|PHONE|FACE|SOUND|"" 空时弹出配置签名方式，其它弹出固定方式
        var singleLogon = 0; //0-弹出多页签签名，1-单种签名方式
        var forceOpen = 1; //1-强制每次都弹出签名窗口
        dhcsys_getcacert({
            modelCode: "ANOPSign",
            loc: session.DeptID,
			isHeaderMenuOpen: false,
			SignUserCode: signCode,
			groupDesc: session.GroupDesc,
            callback: function (cartn) {
                // 签名窗口关闭后,会进入这里
                if (cartn.IsSucc) {
                    if (cartn.ContainerName) {
                        if ("object" == typeof cartn) {
                            var userCertCode = cartn.CAUserCertCode;
                            var certNo = cartn.CACertNo;
                            var hashData = cartn.ca_key.HashData(JSON.stringify(toSignData));
                            var signedData = cartn.ca_key.SignedData(hashData, cartn.ContainerName, EpisodeID);
                            //var signedData = cartn.ca_key.SignedData(hashData, cartn.ContainerName);
                            params.callback({
                                userCertCode: userCertCode,
                                signCode: signCode,
                                hashData: hashData,
                                signedData: signedData,
                                certNo: certNo
                            });
                            return true;
                        }
                    } else {
                        $.messager.alert("未开启CA,使用HIS系统签名!");
                        return false;
                    }
                } else {
                    alert("签名失败！");
                    return false;
                }
            }
        }, logonType, singleLogon, forceOpen);
    }

    return {
        /*返回当前插入的UsbKey中用户列表 */
        GetUserList: function () {
            if(!CheckCAIfInUsage()){
                alert("未开启CA签名");
                return;
            }
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

        },

        /*检查CA签名是否开启*/
        CheckCAIfInUsage: function(){
            var userId = session.ExtUserID;
            var locId = session.ExtDeptID;
            var groupId = session.ExtGroupID;

            var ret = dhccl.runServerMethodNormal("CA.DigitalSignatureService", "GetCAServiceStatus", locId, userId, groupId, "ANOPSign");
            if (ret == "0") {
                return false;
            } else {
                return true;
            }
        }
    }
})();

