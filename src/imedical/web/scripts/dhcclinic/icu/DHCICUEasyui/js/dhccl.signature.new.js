//
/**
 * 签名对话框
 * @param {*} opts 
 */
function SignView(opts) {
    this.options = $.extend({
        width: 242,
        height: 168
    }, opts);
    this.init();
}

SignView.prototype = {
    init: function() {
        var _this = this;
        this.dom = $('<div></div>').appendTo('body');
        this.form = $('<form></form>').appendTo(this.dom);

        var buttons = $('<div></div>');
        var btn_sign = $('<a href="#"></a>').linkbutton({
            text: '确定',
            iconCls: '',
            onClick: function() {
                _this.sign();
            }
        }).appendTo(buttons);
        var btn_cancel = $('<a href="#"></a>').linkbutton({
            text: '取消',
            iconCls: '',
            onClick: function() {
                _this.close();
            }
        }).appendTo(buttons);

        this.dom.dialog({
            title: '签名',
            modal: true,
            closed: true,
            buttons: buttons,
            width: this.options.width,
            height: this.options.height,
            onOpen: function() {
                _this.refresh();
            },
            onClose: function() {
                _this.clear();
            }
        });

        this.initForm();
    },
    initForm: function() {
        var _this = this;
        this.form.addClass('data-form');
        this.form.form({});

        var row = $('<div class="form-signrow"></div>').appendTo(this.form);
        var label = $('<div class="label">用户：</div>').appendTo(row);
        this.User = $('<input type="text" name="SignUser">').appendTo(row);
        this.User.combobox({
            width: 180,
            valueField: "certID",
            textField: "userName",
            onLoadSuccess: function(data) {
                if (data && data.length && data.length > 0) {
                    var firstSignCert = data[0];
                    $(this).combobox("select", firstSignCert.certID);
                } else {
                    $(this).combobox("setText", session.UserCode);
                }
            }
        });

        var row = $('<div class="form-signrow"></div>').appendTo(this.form);
        var label = $('<div class="label">密码：</div>').appendTo(row);
        this.Password = $('<input type="password" name="SignPwd" style="width:173px;">').appendTo(row);
        this.Password.validatebox({

        });

        this.Password.keyup(function(e) {
            if (event.KeyCode == 12) {
                _this.sign();
            }
        })
    },
    /**
     * 签名
     */
    sign: function() {
        var userCertID = this.User.combobox("getValue");
        var signCert = this.getSignCertByID(userCertID);
        if (signCert) {
            this.caSign();
        } else {
            this.commonSign();
        }
    },
    /**
     * 刷新服务器签名参数和已插入的UKey信息
     */
    refresh: function() {
        this.getSystemSignParams();
        this.loadSignUsers();
    },
    loadSignUsers: function() {
        var signCerts = this.getSignCerts();
        this.signCerts = signCerts;
        this.User.combobox('loadData', signCerts);
    },
    open: function() {
        this.dom.dialog('open');
    },
    close: function() {
        this.dom.dialog('close');
    },
    clear: function() {
        this.form.form('clear');
    },
    /**
     * 获取服务器签名参数
     */
    getSystemSignParams: function() {
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
    },
    /**
     * CA签名
     */
    caSign: function() {
        var _this = this;
        // 客户端证书登录
        var ret = xtxapp.SOF_Login(this.User.combobox("getValue"), this.Password.val());
        if (ret === true) {
            var signCert = this.getSignCertByID(this.User.combobox("getValue"));
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
                var signedData = xtxapp.SOF_SignData(this.certID, this.options.originalData);
                // 对原文加盖时间戳
                var tsRequest = tsscom.CreateTSRequest(this.options.originalData, 0);
                var signTS = tsscom.CreateTS(tsRequest);
                // 获取签名图片
                var signImage = picapp.ConvertPicFormat(picapp.GetPic(signCert.userID), 3);
                // 保存证书序列号、签名值和时间戳
                //this.options.saveCallBack(signedData,signTS,signCert.CertID,this.SignImage);
                //var signUser = this.getUserByCert(signCert.userID);
                var signUser = dhccl.runServerMethod(CLCLS.BLL.SecureUser, "GetSSUserIDByCertID", signCert.userID);
                if (!signUser || signUser.success === "E") {
                    $.messager.alert("提示", "根据证书ID未能获取用户ID，请联系系统管理员！", "warning");
                    return;
                }
                if (this.options.saveCallBack) {
                    this.options.saveCallBack({
                        RowId: "",
                        HashData: "",
                        SignCode: this.options.signCode,
                        SignTimeStamp: signTS,
                        SignData: signedData,
                        CertID: signCert.certID,
                        UserCertID: signCert.userID,
                        SignImage: "",
                        SignDate: "",
                        SignTime: "",
                        SignUser: signUser.result,
                        SignType: "C",
                        UpdateUser: session.UserID,
                        ClassName: ANCLS.Model.Signature
                    },function(data){
                        _this.afterSign(data);
                    });
                } else {
                    var ret = operDataManager.saveSignedDatas(null, {
                        RowId: "",
                        HashData: "",
                        SignCode: this.options.signCode,
                        SignTimeStamp: signTS,
                        SignData: signedData,
                        CertID: signCert.certID,
                        UserCertID: signCert.userID,
                        SignImageData: "",
                        SignDate: "",
                        SignTime: "",
                        SignUser: signUser.result,
                        SignType: "C",
                        UpdateUser: session.UserID
                    }, function(data) {
                        _this.afterSign(data);
                    });
                    if (!ret) {
                        $.messager.alert("未填写有效数据，请填写数据后再签名！");
                    }
                }
            }
        } else {
            var account = this.User.combobox("getText");
            var pwd = this.Password.val();
            var signUserID = this.validateUser(account, pwd);
            if (signUserID > 0) {
                $.messager.alert("提示", "已插入UKey，不能用工号密码签名，请选择对应的Key再进行签名", "error");
            } else {
                $.messager.alert("提示", "签名密码错误。", "error");
            }
        }
    },
    /**
     * 普通签名
     */
    commonSign: function() {
        var _this = this;
        var account = this.User.combobox("getText");
        var pwd = this.Password.val();
        var signUserID = this.validateUser(account, pwd);
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
                tsRequest = tsscom.CreateTSRequest(this.options.originalData, 0);
                signTS = tsscom.CreateTS(tsRequest);
            } catch (error) {
                $.messager.alert("提示", "未生成签名时间戳，请检测证书助手安装配置情况！", "warning");
                return;
            }

            if (this.options.saveCallBack) {
                this.options.saveCallBack({
                    RowId: "",
                    SignCode: this.options.signCode,
                    HashData: "",
                    SignTimeStamp: signTS,
                    SignUser: signUserID,
                    SignDate: "",
                    SignTime: "",
                    UserCertID: "",
                    SignImageData: userImage.result,
                    SignType: "C",
                    UpdateUser: session.UserID,
                    ClassName: ANCLS.Model.Signature
                },function(data){
                    _this.afterSign(data);
                });
            } else {
                var ret = operDataManager.saveSignedDatas(null, {
                    RowId: "",
                    SignCode: this.options.signCode,
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
                    _this.afterSign(data);
                });

                if (!ret) {
                    $.messager.alert("提示", "未填写有效数据，请填写数据后再签名！", "error");
                }
            }


        } else {
            $.messager.alert("提示", "签名密码错误。", "error");
        }
    },
    afterSign:function(data){
        //加载签名
        signCommon.loadSignature();
        this.close();

        //ftp上传文件
        if (this.options.printCallBack) {
            this.options.printCallBack();
        }
        if (this.options.afterSignCallBack) {
            this.options.afterSignCallBack();
        }

    },
    /**
     * 获取已插入的UKey信息
     */
    getSignCerts: function() {
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
    },
    /**
     * 通过ID获取UKey信息
     * @param {string} certID 
     */
    getSignCertByID: function(certID) {
        var ret = null;
        if (this.signCerts && this.signCerts.length && this.signCerts.length > 0) {
            for (var i = 0; i < this.signCerts.length; i++) {
                if (this.signCerts[i].certID === certID) {
                    ret = this.signCerts[i];
                }
            }
        }
        return ret;
    },
    /**
     * 通过UKey的ID在后台获取用户
     * @param {*} userCertID 
     */
    getUserByCert: function(userCertID) {
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
    },
    /**
     * 通过工号获取用户
     * @param {*} account 
     */
    getUserByAccount: function(account) {
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
    },
    /**
     * 验证用户名密码
     * @param {*} account 
     * @param {*} pwd 
     * @param {*} ret 
     */
    validateUser: function(account, pwd, ret) {
        // ret = dhccl.runServerMethod(CLCLS.BLL.Admission, "ValidateUser", account, pwd);
        ret = dhccl.runServerMethod(CLCLS.BLL.Admission, "ValidateUser", account, pwd,"Y");
        if (ret.success === false) {
            $.messager.alert("提示", ret.result, "warning");
        }
        return Number(ret.result);
    }
}

var signCommon = {
    /**
     * 加载签名数据到界面
     */
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
                //if (!_this.SignImage || _this.SignImage === "") continue;
                var signCode = signature.SignCode;
                if (!signCode || $("#" + signature.SignCode).length <= 0) continue;
                var selector = "#" + signature.SignCode;
                if ($(selector).attr("src") && $(selector).attr("src") != "") continue;
                var signImage = dhccl.runServerMethod(ANCLS.BLL.Signature, "GetSignImageBySSUserID", signature.SignUser);
                $(selector).attr("src", "data:image/png;base64," + signImage.result);
            }
        }
    }
}