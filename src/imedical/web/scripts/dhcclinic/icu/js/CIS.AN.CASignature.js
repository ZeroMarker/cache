function CASignature(opts){
    this.options=$.extend({
        width:260,
        height:200
    },opts);
    this.CAClient={};
    this.CASession={};
    this.init();
}

CASignature.prototype={
    /**
     * 签名面板初始化
     */
    init:function(){
        
        this.dom=$("<div style='padding:10px 10px 0 10px;'></div>").appendTo("body");
        var auditFormArr=["<form id='caAuditForm' method='post'>",
                          "<div><div class='form-row'>",
                          "<div class='form-title-normal'>用户</div>",
                          "<div class='form-item-normal'><select id='SignUser' class='hisui-combobox'></select></div>",
                          "</div></div>",
                          "<div><div class='form-row'>",
                          "<div class='form-title-normal'>密码</div>",
                          "<div class='form-item-normal'><input type='password' id='SignPwd' class='textbox' style='width:173px;'></div>",
                          "</div></div></form>"];
        this.auditForm=$(auditFormArr.join("")).appendTo(this.dom);
        this.initDialog();
        this.initAuditForm();
    },

    /**
     * 初始化签名对话框
     */
    initDialog:function(){
        var _this=this;
        this.dom.dialog({
            title:this.options.title?this.options.title:"签名",
            width:this.options.width,
            height:this.options.height,
            closed:true,
            modal:true,
            iconCls:"icon-w-stamp",
            buttons:[{
                id:"btnSign",
                text:"签名",
                handler:function(){
                    //if(_this.CASign){
                    if(_this.isCASign()){
                        var certID=$("#SignUser").combobox("getValue");
                        var pin=$("#SignPwd").val();
                        var contentData=_this.options.contentData;
                        _this.sign(certID,pin,contentData,_this.options.CareProvType);
                    }else{
                        var account=$("#SignUser").combobox("getText");
                        var pin=$("#SignPwd").val();
                        _this.accountSign(account,pin,_this.options.CareProvType);
                    }
                    if(_this.options.afterSignCallBack){
                        _this.options.afterSignCallBack();
                    }
                },
                style:{"background":"#21BA45"}
            },{
                text:"退出",
                handler:function(){
                    _this.exit();
                }
            },{
                text:"删除",
                handler:function(){
                    _this.removeSign();
                }
            }],
            onOpen:function(){
                _this.reload();
                if(_this.options.openCallBack)
                    _this.options.openCallBack();
            },
            onClose:function(){
                if(_this.options.closeCallBack)
                    _this.options.closeCallBack();
                if(_this.dom){
                    _this.dom.remove();
                }
            }
        });

        $("#btnSign").css({"background":"#21BA45"});
    },

    /**
     * 初始化签名表单
     */
    initAuditForm:function(){
        var _this=this;
        var signUserList=_this.getSignUserList();
        $("#SignUser").combobox({
            valueField:"key",
            textField:"name",
            data:signUserList,
            onSelect:function(record){
                //_this.initCAClient(record.key);
            }
        });

        // 未获取到证书用户列表，那么支持账号和密码签名
        if(signUserList.length===0){
            $("#SignUser").combobox({
                hasDownArrow:false,
                panelHeight:0
            });
            $("#SignUser").combobox("setText",session.UserCode);    // 默认当前登录用户的账号
            //this.CASign=false;
        }else{
            //this.CASign=true;
            var firstUser=signUserList[0];
            $("#SignUser").combobox("setValue",firstUser.key);      // 默认选择第一个证书用户
        }
    },

    /**
     * 判断是否CA签名
     */
    isCASign:function(){
        try {
            var certID=$("#SignUser").combobox("getValue");
            var signCert=GetSignCert(certID);
            if(signCert){
                return true;
            }
        } catch (error) {
            
        }

        return false;
    },

    /**
     * 获取证书用户列表
     */
    getSignUserList:function(){
        var signUserList=[];
        try {
            var signUserInfo=SOF_GetUserList();
            if(signUserInfo){
                var signUserArr=signUserInfo.split("&&&");
                for (var i = 0; i < signUserArr.length; i++) {
                    var signUser = signUserArr[i];
                    if(!signUser) continue;
                    var curSignUserArr=signUser.split("||");
                    signUserList.push({
                        name:curSignUserArr[0],
                        key:curSignUserArr[1]
                    });
                }
                
            }
        } catch (error) {
            
        }
        
        return signUserList;
    },

    /**
     * CA证书签名
     * 1. 证书客户端登录验证。
     * 2. 证书服务器登录验证。
     * 3. 对签名数据哈希，得到签名原文。
     * 4. 对签名原文签名，得到签名密文。
     * 5. 保存签名值并添加签名日志。
     */
    sign:function(certID,pin,contentData,CareProvType){
        if(this.login(certID,pin) && this.serverLogin()){
            var hashData=HashData(contentData);
            var signedData=SignedData(hashData,this.CAClient.CertID);
            if(CareProvType=="undefined") CareProvType="";
            var saveRet=dhccl.runServerMethodNormal(ANCLS.CA.SignatureService,"Sign",session.RecordSheetID,this.CAClient.UserCertCode,
                this.options.signCode,hashData,signedData,CareProvType);
            if(saveRet.indexOf("S^")===0){
                this.close();
                this.afterSign();
            }else{
                $.messager.alert("提示","签名失败，原因："+saveRet,"error");
            }
        }
    },

    /**
     * 账号签名
     * 1. 验证账号和密码
     * 2. 保存签名值
     * @param {String} account - 账号
     * @param {String} pin - 密码
     */
    accountSign:function(account,pin,CareProvType){
        if(!account){
            $.messager.alert("提示","账号不能为空！","warning");
            return;
        }
        if(!pin){
            $.messager.alert("提示","密码不能为空！","warning");
            return;
        }
        if(CareProvType==undefined) CareProvType="";
        var saveRet=dhccl.runServerMethodNormal(ANCLS.CA.SignatureService,"AccountSign",session.RecordSheetID,this.options.signCode,account,pin,CareProvType);
        if(saveRet.indexOf("S^")===0){
            this.close();
            this.afterSign();
        }else{
            $.messager.alert("提示","签名失败，原因："+saveRet,"error");
        }
    },

    /**
     * 签名后执行的方法
     */
    afterSign:function(){
        var userFullName=dhccl.runServerMethodNormal(ANCLS.CA.SignatureService,"GetSignUserName",session.RecordSheetID,this.options.signCode);
        if($(this.options.signBox).hasClass("hisui-triggerbox")){
            $(this.options.signBox).triggerbox("setValue",userFullName);
        }
        if(this.options.imgBox){
            var signImage=dhccl.runServerMethodNormal(ANCLS.CA.SignatureService,"GetSignImage",session.RecordSheetID,this.options.signCode);
            if(signImage){
                $(this.options.imgBox).attr("src","data:image/png;base64,"+signImage);
            }
        }
    },

    /**
     * 删除签名
     */
    removeSign:function(){
        var _this=this;
        $.messager.confirm("提示","是否删除已有签名？",function(r){
            if(r){
                var saveRet=dhccl.runServerMethodNormal(ANCLS.CA.SignatureService,"RemoveSignature",session.RecordSheetID,_this.options.signCode);
                if(saveRet.indexOf("S^")===0){
                    _this.close();
                    _this.afterRemoveSign();
                    if(_this.options.afterSignCallBack){
                        _this.options.afterSignCallBack();
                    }
                }else{
                    $.messager.alert("提示","删除签名失败，原因："+saveRet,"error");
                }
            }
        });
       
    },

    /**
     * 删除签名后执行方法
     */
    afterRemoveSign:function(){
        if($(this.options.signBox).hasClass("hisui-triggerbox")){
            $(this.options.signBox).triggerbox("setValue","");
        }
        if(this.options.imgBox){
            $(this.options.imgBox).attr("src","");
        }
    },

    /**
     * 证书客户端登录验证
     * @param {String} certID - 证书ID
     * @param {String} pin - 证书登录密码
     */
    login:function(certID,pin){
        if(!certID){
            $.messager.alert("提示","获取证书用户信息失败。","error");
            return false;
        }
        if(!pin){
            $.messager.alert("提示","请输入证书密码。","warning");
            return false;
        }
        if (pin.length<6 || pin.length>16){
            $.messager.alert("提示","证书密码在6-16位之间。","warning");
            return false;
        }
        var ret=SOF_Login(certID, pin);
        if (!ret) {
            var retryCount = SOF_GetPinRetryCount(certID);
            if (retryCount > 0) {
                $.messager.alert("提示","校验证书密码失败!您还有" + retryCount + "次机会重试!","error");
                return false;
            } else if (retryCount == 0) {
                $.messager.alert("提示","您的证书密码已被锁死,请联系BJCA进行解锁!","error");
                return false;
            } else {
                $.messager.alert("提示","登录失败!","error");
                return false;
            }
        }

        // 导出客户端证书
        var userCert = SOF_ExportUserCert(certID, KEY_SIGNOREXCHANGE);
        if (userCert == null || userCert == "") {
            $.messager.alert("提示","导出用户证书失败!","error");
            return false;
        }

        // 检查证书有效期
        if (!CheckValid(userCert)) {
            return false;
        }

        this.initCASession();
        this.initCAClient(certID);
        // 验证服务端签名
        var ret = SOF_VerifySignedData(this.CASession.Cert, this.CASession.Random, this.CASession.SignedData)
        if (!ret) {
            $.messager.alert("提示","验证服务器端信息失败!","error");
            return false;
        }

        // 对随机数做签名
        var strClientSignedData = SOF_SignData(certID, this.CASession.Random);
        if (strClientSignedData == null || strClientSignedData == "") {
            $.messager.alert("提示","客户端签名失败!","error");
            return false;
        }
        
        return true;
    },

    /**
     * 初始化CA服务器会话上下文
     */
    initCASession:function(){
        var serverCAStr=dhccl.runServerMethodNormal(ANCLS.CA.SignatureService,"GetServerCert");
        var serverCA=JSON.parse(serverCAStr);
        this.CASession.Cert=serverCA.ServerCert;
        this.CASession.Random=serverCA.ServerRan;
        this.CASession.SignedData=serverCA.ServerSignedData;
    },

    /**
     * 初始化CA证书信息上下文
     * @param {String} key - 证书唯一标识
     */
    initCAClient:function(key){
        this.CAClient.CertID=key;       // 证书唯一标识
        this.CAClient.SignCert=GetSignCert(this.CAClient.CertID);        // 证书
        this.CAClient.UserCertCode=GetUniqueID(this.CAClient.SignCert);     // 证书用户唯一标识
        this.CAClient.CertNo=GetCertNo(this.CAClient.CertID);         // 证书编号
        this.CAClient.CertSN=GetCertSN(this.CAClient.CertID);         // 证书序列号
        this.CAClient.SignedRandom=SignedData(HashData(this.CASession.Random),this.CAClient.CertID);        // 服务器随机数签名值
    },

    /**
     * 证书服务器登录验证
     */
    serverLogin:function(){
        var randomHash=HashData(this.CASession.Random);     // 对服务器随机数进行哈希
        var loginRet=dhccl.runServerMethodNormal(ANCLS.CA.SignatureService,"Login",this.CAClient.UserCertCode,randomHash,
            this.CAClient.SignedRandom,this.CAClient.CertNo,this.CAClient.SignCert);
        if(loginRet.indexOf("E^")===0){
            $.messager.alert("提示",loginRet,"error");
            return false;
        }
        return true;
    },

    /**
     * 退出
     */
    exit:function(){
        this.close();
    },

    /**
     * 重新加载表格配置数据
     */
    reload:function(){
        
    },

    /**
     * 打开对话框
     */
    open:function(){
        this.dom.dialog("open");
    },

    /**
     * 关闭对话框
     */
    close:function(){
        this.dom.dialog("close");
        //this.dom.remove();
    }
}

/**
 * 签名工具类
 */
var SignTool={
    /**
     * 初始化签名控件
     * 加载签名信息赋值给签名控件
     */
    loadSignature:function(){
        this.initSignature();
        var signatureList = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.CA.SignatureService,
            QueryName: "FindSignature",
            Arg1: session.RecordSheetID,
            ArgCnt: 1
        }, "json", false);
        if (signatureList && signatureList.length > 0) {
            for (var i = 0; i < signatureList.length; i++) {
                var signature = signatureList[i];
                var signCode = signature.SignCode;
                if (!signCode || $("#" + signature.SignCode).length <= 0) continue;
                var selector = "#" + signature.SignCode;
                if($(selector).hasClass("hisui-triggerbox")){
                    $(selector).triggerbox("setValue",signature.FullName);
                }else{
                    var signImage = dhccl.runServerMethodNormal(ANCLS.CA.SignatureService, "GetSignImage", session.RecordSheetID,signCode);
                    if(!signImage)
                    {
                        $(selector).attr("src", "data:image/png;base64," + signImage);
                    }
                }
                    
            }
        }

        return signatureList;
    },

    /**
     * 初始化页面的签名控件
     */
    initSignature:function(){
        $(".signature").triggerbox({
            handler:function(){
                var signCode=$(this).attr("id");
                var title="";
                var opts=$(this).triggerbox("options");
                if(opts){
                    title=opts.prompt;
                }
                var CareProvType=opts.CareProvType;
                var originalData = JSON.stringify(operDataManager.getOperDatas());
                var CASign=new CASignature({
                    title:title || "",
                    contentData:originalData,
                    signCode:signCode,
                    signBox:"#"+signCode,
                    imgBox:"",
                    CareProvType:CareProvType,
                    //afterSignCallBack:afterSignCallBack
                });
                CASign.open();
            }
        });

        $(".signature").each(function(index,item){
            var textbox=$(item).triggerbox("textbox");
            textbox.attr("disabled","disabled");
        });
    },
    getSignature:function(signList,signCodeArr){
        let result={};
        if(signList && signList.length>0 && signCodeArr && signCodeArr.length>0){
            for (let i = 0; i < signList.length; i++) {
                const sign = signList[i];
                if(signCodeArr.indexOf(sign.SignCode)>=0){
                    result[sign.SignCode]=sign;
                }
            }
        }

        return result;
    }
}
