function SignView(opts) {
    this.opts = opts;
    this.initView = function() {
        this.initSignForm();
        this.initSignPara();
        this.initFormElements();
    };
    this.open = function() {
        $(this.opts.container).show();
        $("#signDialog").dialog("open");
    };



    this.initSignForm = function() {
        var htmlArr = [];
        this.dialogWidth = 242;
        this.dialogHeight = 168;
        htmlArr.push("<div id=\"signDialog\" class=\"hisui-dialog\" data-options=\"title:'签名',modal:true,closed:true,buttons:'#signBtns',width:" + this.dialogWidth + ",height:" + this.dialogHeight + "\"");
        htmlArr.push("<form method='post' id='signForm' class='data-form'>");
        htmlArr.push("<div><div class='form-signrow'>");
        htmlArr.push("<div>用户：</div>");
        htmlArr.push("<div>");
        htmlArr.push("<select id='signUser' name='SignUser' class='hisui-combobox'></select>");
        htmlArr.push("</div></div></div>");
        htmlArr.push("<div><div class='form-signrow'>");
        htmlArr.push("<div>密码：</div>");
        htmlArr.push("<div>");
        htmlArr.push("<input id='signPwd' name='SignPwd' class='hisui-validatebox' type='password' style='width:173px;'>");
        htmlArr.push("</div></div></div>");
        htmlArr.push("</form></div>");
        htmlArr.push("<div id='signBtns'>");
        htmlArr.push("<a href='#' id='btnSign' class='hisui-linkbutton'>确定</a>");
        htmlArr.push("<a href='#' id='btnExit' class='hisui-linkbutton'>退出</a></div>");
        var container = $(this.opts.container);
        container.empty();
        // container.css({
        //     "width": (dialogWidth + "px"),
        //     "height": (dialogHeight + "px")
        // });
        container.append(htmlArr.join(splitchar.empty));
        var containerID = container.attr("id");
        $.parser.parse("#" + containerID);
        $("#signDialog").dialog({
            onClose:function(){
                $("#signDialog").parent().remove();
            }
        });

        var signView = this;
        $("#signPwd").keypress(function(e){
            if (e.keyCode == 13) {
                var signCert = signView.getSignCertByID($("#signUser").combobox("getValue"));
                if (signCert) {
                    signView.caSign();
                } else {
                    signView.commonSign();
                }

            }
        });
    };

    this.initSignPara = function() {
        // 获取服务器证书、随机数以及随机数签名
        // var svscom = new ActiveXObject("BJCA_SVS_ClientCOM.BJCASVSEngine");
        // var tsscom = new ActiveXObject("BJCA_TS_ClientCom.BJCATSEngine");
        // var xtxapp = new ActiveXObject("XTXAppCOM.XTXApp");
        //if(!$.browser.msie) return;
        try {
            var signCert = svscom.GetServerCertificate();
            var serverRandom = svscom.GenRandom(16);
            var serverSignRan = svscom.SignData(serverRandom);
            this.serverCert = {
                signCert: signCert,
                random: serverRandom,
                signRan: serverSignRan
            };
            this.CASign = true;
        } catch (error) {
            this.CASign = false;
        }

        // this.svscom = svscom;
        // this.tsscom = tsscom;
        // this.xtxapp = xtxapp;
    }

    this.initFormElements = function() {
        var signCerts = this.getSignCerts();
        this.signCerts = signCerts;
        var signView = this;
        $("#signUser").combobox({
            valueField: "certID",
            textField: "userName",
            data: signCerts,
            onLoadSuccess: function(data) {
                if (data && data.length && data.length > 0) {
                    var firstSignCert = data[0];
                    $(this).combobox("select", firstSignCert.certID);
                } else {
                    $(this).combobox("setText", session.UserCode);
                }
            }
        });

        $("#btnSign").linkbutton({
            onClick: function() {
                var signCert = signView.getSignCertByID($("#signUser").combobox("getValue"));
                if (signCert) {
                    signView.caSign();
                } else {
                    signView.commonSign();
                }

            }
        });

        $("#btnExit").linkbutton({
            onClick: function() {
                $("#signDialog").dialog("close");
                $("#signDialog").parent().remove();
            }
        });
    };

    this.caSign = function() {
        var signature = this;
        // 客户端证书登录
        var signCertID=$("#signUser").combobox("getValue");
        var ret = xtxapp.SOF_Login(signCertID, $("#signPwd").val());
        if (ret === true) {
            var signCert = signature.getSignCertByID(signCertID);
            if (signCert) {
                //服务端验证客户端证书的有效性
                var validateRet = svscom.ValidateCertificate(signCert.signCert);
                switch (validateRet) {
                    case 0:
                        break;
                    case -1:
                        alert("不是所信任的根");
                        return;
                    case -2:
                        alert("超过有效期，请更换证书");
                        return;
                    case -3:
                        alert("作废证书");
                        return;
                    case -4:
                        alert("证书已加入黑名单");
                        return;
                    case -5:
                        alert("证书未生效");
                        return;
                    default:
                        return;
                }
                // 对原文数据数字签名
                // var signedData = xtxapp.SOF_SignData(signCert.certID, signature.opts.originalData);
                // // 对原文加盖时间戳
                // var tsRequest = tsscom.CreateTSRequest(signature.opts.originalData, 0);
                // var signTS = tsscom.CreateTS(tsRequest);
                var signObject=signature.createSignObject(signCert.certID,signature.opts.originalData);
                // 获取签名图片
                // var signImage = picapp.ConvertPicFormat(picapp.GetPic(signCert.userID), 3);
                // 保存证书序列号、签名值和时间戳
                //this.opts.saveCallBack(signedData,signTS,signCert.CertID,this.SignImage);
                //var signUser = this.getUserByCert(signCert.userID);
                var signUser = dhccl.runServerMethod(CLCLS.BLL.SecureUser, "GetSSUserIDByCertID", signCert.userID);
                if (!signUser || signUser.success === "E") {
                    $.messager.alert("提示", "根据证书ID未能获取用户ID，请联系系统管理员！", "warning");
                    return;
                }
                if (this.opts.saveCallBack) {
                    this.opts.saveCallBack({
                        RowId: "",
                        HashData: "",
                        SignCode: signature.opts.signCode,
                        SignTimeStamp: signObject.signTS,
                        SignData: signObject.signedData,
                        CertID: signCert.certID,
                        UserCertID: signCert.userID,
                        SignImage: "",
                        SignDate: "",
                        SignTime: "",
                        SignUser: signUser.result,
                        SignType: "C",
                        UpdateUser: session.UserID,
                        ClassName:ANCLS.Model.Signature
                    });
                } else {
                    var ret = operDataManager.saveSignedDatas(null, {
                        RowId: "",
                        HashData: "",
                        SignCode: signature.opts.signCode,
                        SignTimeStamp: signObject.signTS,
                        SignData: signObject.signedData,
                        CertID: signCert.certID,
                        UserCertID: signCert.userID,
                        SignImageData: "",
                        SignDate: "",
                        SignTime: "",
                        SignUser: signUser.result,
                        SignType: "C",
                        UpdateUser: session.UserID
                    }, function(data) {
                        // 关闭签名对话框
                        $("#signDialog").dialog("close");
                        $("#signDialog").parent().remove();

                        // 显示签名图片
                        // if (data && signImage) {
                        //     $("#" + signature.opts.signCode).attr("src", "data:image/png;base64," + signImage);
                        // }
                        signCommon.loadSignatureCommon();

                        // 在服务器上生成PDF文档、并记录文档生成信息。
                        if (signature.opts.printCallBack) {
                            signature.opts.printCallBack();
                        }
                        if(signature.opts.afterSignCallBack){
                            signature.opts.afterSignCallBack();
                        }
                        
                    });
                    if(!ret){
                        $.messager.alert("未填写有效数据，请填写数据后再签名！");
                    }
                }



            }
        }else{
            // var account = $("#signUser").combobox("getText");
            // var pwd = $("#signPwd").val();
            // var signUserID = signature.validateUserNoMsg(account, pwd);
            // if (signUserID > 0) {
            //     $.messager.alert("提示","已插入UKey，不能用工号密码签名，请选择对应的Key再进行签名","error");
            // }
            // else{
            //     $.messager.alert("提示","签名密码错误。","error");
            // }
            var retryCount=signature.getPinRetryCount(signCertID);
            $.messager.alert("提示","签名密码错误,还有"+retryCount+"次重新机会，超过重试次数key将会被锁定。","error");
        }
    };

    this.commonSign = function() {
        var signature = this;
        var account = $("#signUser").combobox("getText");
        var pwd = $("#signPwd").val();
        var signUserID = signature.validateUser(account, pwd);
        if (signUserID > 0) {
            var userImage = dhccl.runServerMethod("DHCCL.BLL.SecureUser", "GetSignImageByAccount", account);
            if (!userImage || !userImage.result || userImage.result === "") {
                $.messager.alert("提示", "未获取到该用户的签名图片。", "warning");
                //return;
            }
            // 普通签名也需要时间戳
            var tsRequest = "",
                signTS = "";
            try {
                tsRequest = tsscom.CreateTSRequest(signature.opts.originalData, 0);
                signTS = tsscom.CreateTS(tsRequest);
            } catch (error) {
                $.messager.alert("提示", "未生成签名时间戳，请检测证书助手安装配置情况！", "warning");
                return;
            }

            if (signature.opts.saveCallBack) {
                signature.opts.saveCallBack({
                    RowId: "",
                    SignCode: signature.opts.signCode,
                    HashData: "",
                    SignTimeStamp: signTS,
                    SignUser: signUserID,
                    SignDate: "",
                    SignTime: "",
                    UserCertID: "",
                    SignImage: "",
                    SignType: "C",
                    UpdateUser: session.UserID,
                    ClassName:ANCLS.Model.Signature
                });
                if (userImage) {
                    $("#" + signature.opts.signCode).attr("src", "data:image/png;base64," + userImage.result);
                }
                $("#signDialog").dialog("close");
                $("#signDialog").parent().remove();
                if (signature.opts.printCallBack) {
                    signature.opts.printCallBack();
                }
                if(signature.opts.afterSignCallBack){
                    signature.opts.afterSignCallBack();
                }
            } else {
                var ret = operDataManager.saveSignedDatas(null, {
                    RowId: "",
                    SignCode: signature.opts.signCode,
                    HashData: "",
                    SignTimeStamp: signTS,
                    SignUser: signUserID,
                    SignDate: "",
                    SignTime: "",
                    UserCertID: "",
                    SignImageData: userImage.result,
                    SignType: "C",
                    UpdateUser: session.UserID
                }, function(data) {
                    if (data && data.signImage) {
                        $("#" + signature.opts.signCode).attr("src", "data:image/png;base64," + data.signImage);
                    }
                    $("#signDialog").dialog("close");
                    $("#signDialog").parent().remove();
                    if (signature.opts.printCallBack) {
                        signature.opts.printCallBack();
                    }
                    if(signature.opts.afterSignCallBack){
                        signature.opts.afterSignCallBack();
                    }

                });

                if(!ret){
                    $.messager.alert("提示","未填写有效数据，请填写数据后再签名！","error");
                }
            }
        }
    };

    this.getPinRetryCount=function(certID){
        var count=xtxapp.SOF_GetPinRetryCount(certID);
        return count;
    };

    this.createSignObject=function(certID,originalData){
        var signature=this;
        var result=null;
        try {
            // 对原文数据数字签名
            var signedData = xtxapp.SOF_SignData(certID, originalData);
            // 对原文加盖时间戳
            var tsRequest = tsscom.CreateTSRequest(originalData, 0);
            var signTS = tsscom.CreateTS(tsRequest);
            result={
                signedData:signedData,
                signTS:signTS
            };
        } catch (error) {
            
        }
        return result;
    },

    this.getSignCerts = function() {
        // if(!xtxapp || !xtxapp.SOF_GetUserList) return [];
        var signCerts = [];
        try {
            var userList = xtxapp.SOF_GetUserList();
            var userArray = userList.split("&&&");
            var oid = "1.2.156.112562.2.1.2.2";

            for (var i = 0; i < userArray.length; i++) {
                var singleUser = userArray[i];
                if (singleUser === splitchar.empty) continue;
                var singleUserArr = singleUser.split("||");
                if (singleUserArr.length < 2) continue;
                var userName = singleUserArr[0];
                var certID = singleUserArr[1];
                var signCert = xtxapp.SOF_ExportUserCert(certID);
                var userID = xtxapp.SOF_GetCertInfoByOid(signCert, oid);
                signCerts.push({
                    userName: userName,
                    certID: certID,
                    signCert: signCert,
                    userID: userID
                });
            }
        } catch (error) {

        }

        return signCerts;
    };

    this.getSignCertByID = function(certID) {
        var ret = null;
        if (this.signCerts && this.signCerts.length && this.signCerts.length > 0) {
            for (var i = 0; i < this.signCerts.length; i++) {
                if (this.signCerts[i].certID === certID) {
                    ret = this.signCerts[i];
                }
            }
        }
        return ret;
    };

    this.getUserByCert = function(userCertID) {
        var userData = null;
        var userDatas = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: CLCLS.BLL.ConfigQueries,
            QueryName: "FindUserByCert",
            Arg1: userCertID,
            ArgCnt: 1
        }, "json");
        if (userDatas && userDatas.length > 0) {
            userData = userDatas[0];
        }
        return userData;
    };

    this.getUserByAccount = function(account) {
        var userData = null;
        var userDatas = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: CLCLS.BLL.ConfigQueries,
            QueryName: "FindUserByAccount",
            Arg1: account,
            ArgCnt: 1
        });
        if (userDatas && userDatas.length > 0) {
            userData = userDatas[0];
        }
        return userData;
    };

    this.validateUser = function(account, pwd, ret) {
        // ret = dhccl.runServerMethod(CLCLS.BLL.Admission, "ValidateUser", account, pwd);
        ret = dhccl.runServerMethod(CLCLS.BLL.Admission, "ValidateUser", account, pwd,"Y");
        if (ret.success === false) {
            $.messager.alert("提示", ret.result, "warning");
        }
        return Number(ret.result);
    };

    this.validateUserNoMsg = function(account, pwd, ret) {
        // ret = dhccl.runServerMethod(CLCLS.BLL.Admission, "ValidateUser", account, pwd);
        ret = dhccl.runServerMethod(CLCLS.BLL.Admission, "ValidateUser", account, pwd,"Y");
        if (ret.success === false) {
            // $.messager.alert("提示", ret.result, "warning");
        }
        return Number(ret.result);
    };

}

var signCommon = {
    loadSignature: function() {
        var signatureList = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.BLL.Signature,
            QueryName: "FindSignature",
            Arg1: session.RecordSheetID,
            ArgCnt: 1
        }, "json", false);
        if (signatureList && signatureList.length > 0) {
            for (var i = signatureList.length - 1; i >= 0; i--) {
                var signature = signatureList[i];
                //if (!signature.SignImage || signature.SignImage === "") continue;
                var signCode = signature.SignCode;
                if (!signCode || $("#" + signature.SignCode).length <= 0) continue;
                var selector = "#" + signature.SignCode;
                if ($(selector).attr("src") && $(selector).attr("src") != "") continue;
                var signImage = dhccl.runServerMethod(ANCLS.BLL.Signature, "GetSignImageBySSUserID", signature.SignUser);
                if(signImage.success===false || signImage.result==='') continue;
                $(selector).attr("src", "data:image/png;base64," + signImage.result);
            }
        }
    },
    loadSignatureCommon: function() {
        var signatureList = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.BLL.Signature,
            QueryName: "FindSignature",
            Arg1: session.RecordSheetID,
            ArgCnt: 1
        }, "json", false);
        if (signatureList && signatureList.length > 0) {
            for (var i = 0; i < signatureList.length; i++) {
                var signature = signatureList[i];
                //if (!signature.SignImage || signature.SignImage === "") continue;
                var signCode = signature.SignCode;
                if (!signCode || $("#" + signature.SignCode).length <= 0) continue;
                var selector = "#" + signature.SignCode;
                // var originalSrc=$(selector).attr("src");
                // if ($(selector).attr("src") && $(selector).attr("src") != "") continue;
                var signImage = dhccl.runServerMethod(ANCLS.BLL.Signature, "GetSignImageBySSUserID", signature.SignUser);
                if(signImage.success===false || signImage.result==='') continue;
                $(selector).attr("src", "data:image/png;base64," + signImage.result);
            }
        }
    }
}