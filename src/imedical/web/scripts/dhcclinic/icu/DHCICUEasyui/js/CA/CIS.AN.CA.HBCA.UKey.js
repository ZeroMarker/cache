/**
 * 湖北CA签名证书程序
 */
const ca_key = (function () {

    const VenderCode = "HBCA";
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
            oid:"128659370.96.04"
        }
    }

    /** 获取配置信息 */
    const config = getConfig();

    function getUserCertList(){
        return [
            {userCertId:"8A1D45A5C4E189B7",userCertName:"测试用户01"},
            {userCertId:"A8B9D7A20C12A401",userCertName:"测试用户02"},
            {userCertId:"2D288A905F5546FE",userCertName:"测试用户03"}
        ]
    }

    function checkPWD(key, pwd){
        if(key == "8A1D45A5C4E189B7" && pwd == "123456"){
            return true;
        }else{
            return false;
        }
    }

    function hashData(inData){

    }

    function signData(hashData, key){

    }

    /**
     * 用户登录及签名
     * params: {
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
        var signPwd = $("<input id='signPwd' name='SignPwd' class='hisui-validatebox' type='password' style='width:180px;'>");
        pwdHolder.append(signPwd);
        container.append(pwdHolder);

        $(signUser).combobox({
            valueField: "userCertId",
            textField: "userCertName",
            data: getUserCertList(),
            onLoadSuccess: function(data) {
                if (data && data.length && data.length > 0) {
                    var firstSignCert = data[0];
                    $(this).combobox("select", firstSignCert.userCertId);
                } 
            }
        });

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
            width: 280,
            height: 180,
            modal: true,
            show: true,
            buttons: [
                {text: "签名", iconCls: 'icon-ok', handler: function(){
                    if(checkSign()){
                        $(container).dialog("close");
                    }
                }},
                {text: "退出", iconCls: 'icon-cancel', handler: function(){
                    $(container).dialog("close");
                }}
            ],
            onClose:function(){
                $(container).empty();
                $(container).remove();
            }
        });

        function checkSign(){
            var key = $(signUser).combobox("getValue");
            var pwd = $(signPwd).val();
            if(key == "") {
                $.messager.popover({msg: "签名证书不能为空",type: "error"});
                return false;
            }
            if(pwd == ""){
                $.messager.popover({msg: "密码不能为空",type: "error"});
                return false;
            }
            if(checkPWD(key, pwd)){
                params.callback(ca_key);
                return true;
            }else{
                $.messager.popover({msg: "签名失败，密码错误!",type: "error"});
                return false;
            }
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

