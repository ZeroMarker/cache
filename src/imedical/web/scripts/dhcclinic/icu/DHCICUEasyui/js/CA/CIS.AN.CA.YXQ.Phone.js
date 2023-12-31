/**
 * 医信签 移动电子签名接口
 */

const ca_key = (function () {

    const VenderCode = "YXQ";
    const SignType = "Phone";

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
        var result = getData("GetConfig", "");
        return result;
    }

    /** 获取配置信息 */
    const config = getConfig();
    console.dir(config);

    function getSignToken(){
        var data = getData("GetLoginQR",{token: "2D288A905F5546FE"});
        var token = data.resultContent;
        return token;
    }

    //console.dir(getSignToken());

    function auth(token, userId){
        return {
            authId: "346896",
            qrCode: "kkkkkkkkkk"
        }
    }

    function queryAuthResult(){
        var authInfo = auth("","");
        var authId = authInfo.authId;

        return {
            status : "toSign"
        };
    }

    function getDatetime() {
        var now = new Date();
        var year = now.getFullYear();
        var month = now.getMonth() + 1;
        var day = now.getDate();
        var hh = now.getHours();
        var mm = now.getMinutes();
        var ss = now.getSeconds();
        var clock = year + "-";
        if (month < 10) clock += "0";
        clock += month + "-";
        if (day < 10) clock += "0";
        clock += day + " ";
        if (hh < 10) clock += "0";
        clock += hh + ":";
        if (mm < 10) clock += '0';
        clock += mm + ":";
        if (ss < 10) clock += '0';
        clock += ss;
        return clock;
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
        var container = $("<div></div>").appendTo("body");
        container.append("<p style='margin:10px'>请使用手机扫码二维码</p>")
        var $canvas = $("<canvas width='200' height='200' style='border:1px solid;margin-left:10px'></canvas>");
        container.append($canvas);
        var signStatus = $("<p style='margin:10px;font-size=5px;color:grey;'>info</p>");
        container.append(signStatus);

        $(container).dialog({
            iconCls:"icon-w-stamp",
            title: "签名",
            width: 240,
            height: 330,
            modal: true,
            show: true,
            onClose:function(){
                $(container).empty();
                $(container).remove();
            }
        });

        var authInfo = auth("","");
        var qrCode = authInfo.qrCode;
        var img = new Image();
        img.src = jrQrcode.getQrBase64(qrCode);
        img.onload = function () {
            var mycanvas = $canvas[0];
			var ctx = mycanvas.getContext('2d')
            ctx.drawImage(img, 0, 0, 200, 200);

            var clock = setInterval(function(){
                var result = queryAuthResult();
                $(signStatus).html(getDatetime() + " " + result.status);
                if(result.status == "Success"){
                    params.callback({
                        userCertCode: "",
                        signCode: "", 
                        hashData: "",
                        signedData: "",
                        certNo: ""
                    });
                    $.messager.popover({msg: "签名成功!",type: "success"});
                }
            },1000)
        };
    }

    return {
        /*返回当前插入的UsbKey中用户列表 */
        GetUserList: function () {

        },

        /*对传入的数据生成Hash值 */
        HashData: function (InData) {

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