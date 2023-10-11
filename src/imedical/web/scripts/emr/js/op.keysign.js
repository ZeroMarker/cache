//alert('门诊病历数字签名业务');
var keySign;
    
/// CA要用到的变量
var strServerRan = '';
var strServerSignedData = '';
var strServerCert = '';
var strKey = '';
var strUserSignedData = '';
var strUserCert = '';

// 获取插入的证书列表
function getList_pnp() {
    var lst = GetUserList(); //CA接口
    var arrUsers = lst.split('&&&');
    if ('' == lst || 0 == arrUsers.length)
        return false;
    var data = '';
    for (var i = 0; i < arrUsers.length; i++) {
        var user = arrUsers[i];
        if (user != "") {
            var keyName = user.split('||')[0];
            var uniqueID = user.split('||')[1];
            if (data == '') {
                data = "{\"id\":\"" + uniqueID + "\",\"text\":\"" + keyName + "\",\"selected\":true}";
            } else {
                data = data + ",{\"id\":\"" + uniqueID + "\",\"text\":\"" + keyName + "\"}";
            }
        }
    }

    data = "[" + data + "]";
    $('#keys').combobox('loadData', JSON.parse(data));
    return true;
}

$(function () {

    function KeySign() {

        var urlDigitalSignature = '../EMRservice.Ajax.caKeySign.cls';

        var loginDialog;
        if ($('#loginDialog').length === 0) {
            var dialogHtml = '<div id="loginDialog" title="数字签名" style="display:none;width:300px;height:180px">';
            dialogHtml += '<form id="loginForm" style="padding:20px 20px 10px 40px;">';
            dialogHtml += '<table>';
            dialogHtml += '<tr>';
            dialogHtml += '<td align="right">证书:</td>';
            dialogHtml += '<td><input id="keys" name="keys" class="easyui-combobox" style="width:160px"/></td>';
            dialogHtml += '</tr>';
            dialogHtml += '<tr>';
            dialogHtml += '<td align="right">密码:</td>';
            dialogHtml += '<td><input id="password" type="password" name="password" style="width:160px;margin-top:6px"/></td>';
            dialogHtml += '</tr>';
            dialogHtml += '</table>';
            dialogHtml += '</form>';
            dialogHtml += '</div>';
            $('body').append(dialogHtml);
            $('#keys').combobox({
                valueField: 'id',
                textField: 'text',
                editable: false
            });
            loginDialog = $('#loginDialog');
            $('#password').on('keypress', function(evt) { 
                if ('13' == event.keyCode) {
                    var key = $('#keys').combobox('getValue');
                    var pwd = $('#password').val();
                    if ('' == key || '' == pwd)
                        return false;
                    $('#checkSure').click();
                }
            });
        }

        //初始化CA相关信息，在登录框弹出前，错误返回false，正确返回true
        function caSessionDataInit() {
            var result = false;

            strServerRan = '';
            strServerSignedData = '';
            strServerCert = '';

            caKeySignGET({
                func: 'CASessionDataInit'
            }, false, function (ret) {
                if (ret && ret.Err) {
                    alert('数字签名初始化错误！' + ret.Err);
                } else {
                    strServerRan = ret.ServerRan;
                    strServerSignedData = ret.ServerSignedData;
                    strServerCert = ret.ServerCert;
                    strKey = ret.Key;
                    result = true;
                }
            }, function (err) {
                alert('CASessionDataInit！' + err.message || err);
            });
            return result;
        }

        //保存key的信息，下次可以不用输密码，无返回值
        function setKeyInSession(key) {
            caKeySignGET({
                func: 'SetKeyInSession',
                Key: key
            }, true);
        }

        //登录，返回用户名，和签名图片
        function serverLogin(key, operate, userID) {
            if ('' === key) return;
            //if (SOF_IsLogin)
            if (typeof(SOF_IsLogin) != 'undefined') {
                var isLogin  = SOF_IsLogin(key);
                if (!isLogin)
                {
                    return;
                }
            }
            var loginInfo = '';
            var cert = '';
            var UserSignedData = '';
            try {
                if ('' == strUserCert) {
                    cert = GetSignCert(key);
                    UserSignedData = SignedData(strServerRan, key);
                } else {
                    UserSignedData = strUserSignedData; // document.getElementsByName('UserSignedData')[0].value;
                    cert = strUserCert; // document.getElementsByName('UserCert')[0].value;
                }

            } catch (err) {}

            var UsrCertCode = GetUniqueID(cert,key);
            var certificateNo = GetCertNo(key);

            var loginInfo;
            caKeySignPOST({
                func: 'login',
                UserSignedData: UserSignedData,
                ServerRan: strServerRan,
                certificate: cert,
                certificateNo: certificateNo,
                userID: userID,
                UsrCertCode: UsrCertCode,
                operate: operate
            }, function (ret) {
                if (ret && ret.Err) {
                    alert(ret.Err);
                } else {
                    loginInfo = ret;
                }
            }, function (err) {
                alert(err.message || err);
            });

            return loginInfo;
        }

        function showLoginDialog(onConfirm, onCancel) {
            $('#password').val('');
            loginDialog.show().dialog({
                closable: false,
                modal: true,
                buttons: [{
	                id: 'checkSure',
                        text: '确定',
                        handler: function () {
                            var key = $('#keys').combobox('getValue');
                            var pwd = $('#password').val();
                            var loginForm = document.getElementById('loginForm');
                            if ('' == key || '' == pwd || !Login(loginForm, key, pwd))
                                return false;
                            setKeyInSession(key);
                            if ('function' === typeof onConfirm) {
                                onConfirm(key);
                            }
                            loginDialog.dialog('close');
                            return true;
                        }
                    }, {
                        text: '取消',
                        handler: function () {
                            if ('function' === typeof onCancel) {
                                onCancel();
                            }
                            loginDialog.dialog('close');
                            return false;
                        }
                    }
                ]
            });
        }

        function getSignContent(usrInfo, insID, checkresult, signProperty) {
            var ret = '';
                                   
            //如果是三级医师审核时，传入签名级别为医师级别
            var signlevel = signProperty.SignatureLevel;
            if (signProperty.OriSignatureLevel === 'Check') {
                signlevel = usrInfo.Level;
            }
            
            var signInfo = iEmrPlugin.SIGN_DOCUMENT({
                    InstanceID: insID,
                    Type: usrInfo.Type,
                    SignatureLevel: signlevel,
                    actionType: checkresult.ationtype,
                    Id: usrInfo.UserID,
                    Name: usrInfo.Name,
                    Image: usrInfo.Image,
                    Description: usrInfo.LevelDesc,
                    isSync: true
                });
            if (signInfo && signInfo.result == 'OK') {
                return signInfo;
            }
            return ret;
        }

        /// 提交服务器，验签名，返回signID
        function serverSign(signValue, contentHash) {
            var result;
            var UsrCertCode = GetUniqueID(GetSignCert(strKey),strKey) || '';
            if ('' === UsrCertCode) {
                alert('用户唯一标示为空！');
                return;
            }

            var signID;
            caKeySignPOST({
                func: 'sign',
                UsrCertCode: UsrCertCode,
                signValue: signValue,
                contentHash: contentHash
            }, function (ret) {
                if (ret && ret.Err) {
                    alert(ret.Err);
                } else {
                    signID = ret.SignID;
                }
            }, function (err) {
                alert(err.message || err);
            });

            return signID;
        }

        // 入口
        this.sign = function (operate, insID, signProperty, userID) {
            if (!getList_pnp()) {
                alert('未检测到证书！');
                return;
            }

            if (!caSessionDataInit()) {
                return;
            }

            var doSign = function (loginInfo) {
                //权限检查
                var checkresult = privilege.checkSign(loginInfo, signProperty);
                if (!checkresult.flag) {
                    return;
                }
                // 获取原文(编辑器已经hash压缩)签名,服务器验证,通知编辑器保存SignID签名记录号
                var fnSign = function () {
                    try {
                        //如果是三级医师审核时，传入签名级别为医师级别
                        var signlevel = signProperty.SignatureLevel;
                        if (signProperty.OriSignatureLevel === 'Check') {
                            signlevel = loginInfo.Level;
                        }
                        
                        if ('' === signlevel) {
                            alert('用户签名级别为空，请检查系统配置！');
                            return;
                        }
                        
                        //文档签名
                        var signInfo = getSignContent(loginInfo, insID, checkresult, signProperty);
                        var contentHash = signInfo.Digest || '';
                        if ('' === contentHash) {
                            alert('签名原文为空！');
                            return;
                        }
                        //CA接口
                        var signValue = SignedData(contentHash, strKey) || '';
                        if ('' === signValue) {
                            alert('签名数据为空！');
                            return;
                        }
                        var signID = serverSign(signValue, contentHash) || '';
                        if ('' === signID) {
                            alert('SignID为空！');
                            return;
                        }

                        var saveRet = iEmrPlugin.SAVE_SIGNED_DOCUMENT({
                                SignUserID: loginInfo.UserID,
                                SignID: signID,
                                SignLevel: signlevel,
                                Digest: contentHash,
                                Type: 'CA',
                                Path: signInfo.Path,
                                ActionType: checkresult.ationtype,
                                InstanceID: insID,
                                isSync: true
                            });
                        if (saveRet && 'OK' === saveRet.params.result) {
                            showEditorMsg('数据签名成功!');
                            var documentContext = emrEditor.getDocContext(saveRet.params.InstanceID);
                            privilege.setRevsion(documentContext);
                            privilege.setViewRevise(documentContext, function() {
                                var txt = $('#btnRevisionVisible').text();
                                return txt === '隐藏痕迹';
                            });
                            return true;
                        } else {
                            return false;
                        }
                    } catch (ex) {
                        alert(ex.message || ex);
                        return false;
                    }

                }

                var retSign = fnSign() || false;
                if (!retSign) {
                    var ret = iEmrPlugin.UNSIGN_DOCUMENT({
                            isSync: true
                        });
                    if ('ERROR' === ret.result)
                        alert('撤销最后一次签名失败！');
                }
            }

            var loginInfo = serverLogin(strKey, operate, userID) || '';
            if ('' !== loginInfo) {
                doSign(loginInfo);
            } else {

                showLoginDialog(function (key) {
                    // LoginOnce 返回loginInfo对象
                    var loginInfo = serverLogin(key, operate, userID) || '';
                    if ('' === loginInfo) {
                        return;
                    }
                    strKey = key;
                    doSign(loginInfo);
                });
            }
        }

        function caKeySignGET(argData, isAsync, onSuccess, onError) {
            $.ajax({
                type: 'POST',
                dataType: 'json',
                url: urlDigitalSignature,
                async: isAsync || false,
                cache: false,
                timeout: 5000,
                data: argData,
                success: function (ret) {
                    if (onSuccess)
                        onSuccess(ret);
                },
                error: function (err) {
                    if (onError)
                        onError(err);
                }
            });
        }

        function caKeySignPOST(argData, onSuccess, onError) {
            $.ajax({
                type: 'POST',
                dataType: 'json',
                url: urlDigitalSignature,
                async: false,
                cache: false,
                data: argData,
                success: function (ret) {
                    if (onSuccess)
                        onSuccess(ret);
                },
                error: function (err) {
                    if (onError)
                        onError(err);
                }
            });
        }

        this.verifySignature = function (signID, contentHash) {
            var result;
            caKeySignGET({
                func: 'verify',
                signID: signID,
                contentHash: contentHash
            }, false, function (ret) {
                if (ret && ret.Err) {
                    alert(ret.Err);
                } else {
                    result = ret.Message;
                }
            }, function (err) {
                alert(err.message || err);
            });
            return result;
        }

    }

    keySign = new KeySign();
});
