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
        var container = $("<div></div>").appendTo("body");
    
        var userHolder = $("<div class='form-signrow'></div>");
        userHolder.append("<span style='margin-right:10px'>用户</span>");
        var signUser = $("<select id='signUser' name='SignUser' class='hisui-combobox'></select>");
        userHolder.append(signUser);
        container.append(userHolder);

        var pwdHolder = $("<div class='form-signrow'></div>");
        pwdHolder.append("<span style='margin-right:10px'>密码</span>");
        var signPwd = $("<input id='signPwd' name='SignPwd' class='hisui-validatebox' type='password' style='width:170px;'>");
        pwdHolder.append(signPwd);
        container.append(pwdHolder);

        $(signUser).combobox({
            valueField: "userCertId",
            textField: "userCertName"
        });

        $(signUser).combobox("setValue",params.userCode);
        $(signUser).combobox("setText",params.userName);
        //$(signUser).combobox("disable");

        $(signPwd).keypress(function(e){
            if (e.keyCode == 13) {
                if(checkSign()){
                    $(container).dialog("close");
                }
            }
        });

        $(container).dialog({
            iconCls:"icon-w-stamp",
            title: "签名",
            width: 260,
            height: 200,
            modal: true,
            show: true,
            buttons: [
                {text: "签名", iconCls: 'icon-ok', handler: function(){
                    checkSign();
                }},
                {text: "退出", iconCls: 'icon-cancel', handler: function(){
                    $(container).dialog("close");
                }}
            ],
            onOpen: function(){
                $("#signPwd").focus();
            },
            onClose:function(){
                $(container).empty();
                $(container).remove();
            }
        });

        function checkSign(){
            var account = $(signUser).combobox("getValue");
            var pin = $(signPwd).val();
            if(account == "") {
                $.messager.popover({msg: "用户名不能为空",type: "error"});
                return false;
            }
            if(pin == ""){
                $.messager.popover({msg: "密码不能为空",type: "error"});
                return false;
            }
            var saveRet = dhccl.runServerMethodNormal(ANCLS.CA.SignatureService, "AccountSign", params.recordSheetId, params.signCode, account, pin);
            if(saveRet.indexOf("S^")===0){
                params.callback({
                    account: account,
                    pin: pin,
                    userCertCode: account,
                    hashData: "",
                    signedData: "",
                    certNo: ""
                });
                $(container).dialog("close");
                $.messager.popover({msg: "签名成功！",type: "success"});
            }else{
                $.messager.alert("提示","签名失败，原因："+saveRet,"error");
            }

            return true;
        }
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

