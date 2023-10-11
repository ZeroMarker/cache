//alert('门诊病历数字签名业务');
var keySign;

/// CA要用到的变量
var strServerRan = '';
var strServerSignedData = '';
var strServerCert = '';
var strKey = '';
var strUserSignedData = '';
var strUserCert = '';

$(function () {

    function KeySign() {

        var urlDigitalSignature = '../EMRservice.Ajax.caKeySign.cls';

        var loginDialog;
        if ($('#loginDialog').length === 0) {
            var dialogHtml = '<div id="loginDialog" class="hisui-dialog" title="数字签名" style="display:none;width:300px;height:180px">';
            dialogHtml += '<form id="loginForm" style="padding:10px 20px 10px 40px;">';
            dialogHtml += '<table>';
            dialogHtml += '<tr>';
            dialogHtml += '<td align="right">证书 </td>';
            dialogHtml += '<td><input id="keys" name="keys" class="hisui-combobox"</td>';
            dialogHtml += '</tr>';
            dialogHtml += '<tr>';
            dialogHtml += '<td align="right">密码 </td>';
            dialogHtml += '<td><input id="password" type="password" name="password" class="hisui-validatebox textbox validatebox-text"/></td>';
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
            $('#password').on('keypress', function(evt) { 
                if ('13' == event.keyCode) {
                    var key = $('#keys').combobox('getValue');
                    var pwd = $('#password').val();
                    if ('' == key || '' == pwd)
                        return false;
                    $('#checkSure').click();
                }
            });
            loginDialog = $('#loginDialog');
        }

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
                    //$.messager.alert('发生错误', '数字签名初始化错误！' + ret.Err, 'error');
                    alert('数字签名初始化错误！' + ret.Err);
                } else {
                    strServerRan = ret.ServerRan;
                    strServerSignedData = ret.ServerSignedData;
                    strServerCert = ret.ServerCert;
                    strKey = ret.Key;
                    result = true;
                }
            }, function (err) {
                //$.messager.alert('发生错误', 'CASessionDataInit！' + err.message || err, 'error');
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
                    //$.messager.alert('发生错误', ret.Err, 'error');
                    alert(ret.Err);
                } else {
                    loginInfo = ret;
                }
            }, function (err) {
                //$.messager.alert('发生错误', 'login' + err.message || err, 'error');
                alert('login' + err.message || err);
            });

            return loginInfo;
        }

        function showLoginDialog(onConfirm, onCancel) {
            $('#password').val('');
            loginDialog.show().dialog({
                isTopZindex: true,
                closable: false,
                modal: true,
                /*onClose: function(){
                    //移除存在的Dialog
                    $("body").remove("#loginDialog");
                    loginDialog.dialog('destroy');
                },*/
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
            document.getElementById('password').focus();
        }

        function getSignContent(usrInfo, insID, checkresult, signProperty) {
            var ret = '';
            var signlevel = signProperty.OriSignatureLevel;
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
                    Path: signProperty.Path || '',
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
                //$.messager.alert('提示', '用户唯一标示为空！', 'info');
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
                    //$.messager.alert('发生错误', ret.Err, 'error');
                    alert(ret.Err);
                } else {
                    signID = ret.SignID;
                }
            }, function (err) {
                //$.messager.alert('发生错误', 'sign' + err.message || err, 'error');
                alert('sign' + err.message || err);
            });

            return signID;
        }

        // 入口
        this.sign = function (operate, insID, signProperty, userID) {
            if (!getList_pnp()) {
                //$.messager.alert('提示', '未检测到证书！', 'info');
                alert('未检测到证书！');
                return;
            }

            if (!caSessionDataInit()) {
                return;
            }

            var doSign = function (loginInfo) {
                var checkSignCallBack = function (checkresult,arr) {
					var insID = arr.insID;
					var signProperty = arr.signProperty;
					var loginInfo = arr.loginInfo;
					
					//权限检查
					if (!checkresult.flag) {
		                return;
		            }
	                
	                // 获取原文(编辑器已经hash压缩)签名,服务器验证,通知编辑器保存SignID签名记录号
	                var fnSign = function () {
	                    try {
                            //如果是三级医师审核时，传入签名级别为医师级别
                            var signlevel = signProperty.OriSignatureLevel;
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
	                            //$.messager.alert('提示', '签名原文为空！', 'info');
	                            alert('签名原文为空！');
	                            return;
	                        }
	                        //CA接口
	                        var signValue = SignedData(contentHash, strKey) || '';
	                        if ('' === signValue) {
	                            //$.messager.alert('提示', '签名数据为空！', 'info');
	                            alert('签名数据为空！');
	                            return;
	                        }
	                        var signID = serverSign(signValue, contentHash) || '';
	                        if ('' === signID) {
	                            //$.messager.alert('提示', 'SignID为空！', 'info');
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
	                            showEditorMsg({msg:'数据签名成功!',type:'success'});
	                            var documentContext = emrEditor.getDocContext(saveRet.params.InstanceID);
	                            privilege.setRevsion(documentContext);
	                            privilege.setViewRevise(documentContext, function () {
	                                var txt = $('#btnRevisionVisible').find("span").eq(1).text();
	                                return txt === '隐藏痕迹';
	                            });
	                            return true;
	                        } else {
	                            return false;
	                        }
	                    } catch (ex) {
	                        //$.messager.alert('发生错误', ex.message || ex, 'error');
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
	                    //$.messager.alert('发生错误', '撤销最后一次签名失败！', 'error');
	                }
                }
                
                var arr = {
					insID: insID, 
					signProperty: signProperty,
					loginInfo:loginInfo
				}
				
				//权限检查
                var documentContext = emrEditor.getDocContext();
			    privilege.checkSign(loginInfo, signProperty, documentContext, checkSignCallBack, arr);
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
                type: 'GET',
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
                    //$.messager.alert('发生错误', ret.Err, 'error');
                    alert(ret.Err);
                } else {
                    result = ret.Message;
                }
            }, function (err) {
                //$.messager.alert('发生错误', 'verify' + err.message || err, 'error');
                alert('verify' + err.message || err);
            });
            return result;
        }

    }

    keySign = new KeySign();
});
