var keySignParam = new Object();
keySignParam.urlDigitalSignature = '../EMRservice.Ajax.caKeySign.cls';
keySignParam.SignOperate = '';
keySignParam.SignInsID = '';
keySignParam.loginDialog = null;


$(function() {
    if ($('#loginDialog').length == 0) {
        var dialogHtml = '<div id="loginDialog" title="数字签名" style="display:none;width:300px;height:180px">';
        dialogHtml = dialogHtml + '<form id="loginForm" style="padding:10px 20px 10px 40px;">';
        dialogHtml = dialogHtml + '<table>';
        dialogHtml = dialogHtml + '<tr>';
        dialogHtml = dialogHtml + '<td align="right">证书: </td>';
        dialogHtml = dialogHtml + '<td><input id="keys" name="keys" class="easyui-combobox"</td>';
        dialogHtml = dialogHtml + '</tr>';
        dialogHtml = dialogHtml + '<tr>';
        dialogHtml = dialogHtml + '<td align="right">密码: </td>';
        dialogHtml = dialogHtml + '<td><input id="password" type="password" name="password" onkeypress="if(event.keyCode==13) {handleSign(); return false;}"/></td>';
        dialogHtml = dialogHtml + '</tr>';
        dialogHtml = dialogHtml + '</table>';
        dialogHtml = dialogHtml + '</form>';
        dialogHtml = dialogHtml + '</div>';
        $('body').append(dialogHtml);
        $('#keys').combobox({
            valueField: 'id',
            textField: 'text',
            editable: false
        });

        $('#keySign').click(function() {
            alert("keySign");
            //keySign("", "");
        });
    }
});

function handleSign() {

	operate = keySignParam.SignOperate;
	insID = keySignParam.SignInsID;
	
    var key = $('#keys').combobox('getValue');
    var pwd = $('#password').val();
    //var objForm = document.getElementById('loginForm'); //$('#loginForm')
    if ('' == key || "" == pwd)
        return false;
    var retMsg = opener.CheckPWD(key, pwd)
    if ('' != retMsg) {
        alert(retMsg);
        return false;
    }
    var ret = opener.CheckForm(key, strServerCert, strServerRan, strServerSignedData);
    if ('' != ret.errMsg) {
        alert(ret.errMsg);
        return false;
    } else {
        strUserCert = ret.UserCert
        strUserSignedData = ret.UserSignedData;
    }

    loginInfo = ajaxLogin(key, operate);
    if ('' != loginInfo) {
        SetKeyInSession(key);
        strKey = key;
        var msg = signContent(strKey, loginInfo, insID);
        if ('' == msg) {
            keySignParam.loginDialog.dialog('close');
            $("#password").val('');
            return true;
        }
        alert(msg);
    }

    return false;	
}

/// 入口
function keySign(operate, insID) {
	
	keySignParam.SignOperate = operate;	
	keySignParam.SignInsID = insID;
	
    //debugger;
    if (!GetList_pnp()) {
		alert('未检测到证书！');
		return;
    }	
	
    $('#password').val('');
    if (!CASessionDataInit()) {
        return false;
    }

    if (!GetList_pnp()) {
        alert('未检测到证书！');
        return false;
    }
    var loginInfo = ''; //先用session里面保存的信息登录
    if (strKey && '' != strKey) {
		if (opener.SOF_IsLogin(strKey)) {
			loginInfo = ajaxLogin(strKey, operate);
		}	
    }
    if ('' == loginInfo) {
        keySignParam.loginDialog = $('#loginDialog').show().dialog({
            closable: false,
            modal: true,
            buttons: [{
                text: '确定',
                handler: function() {
					return handleSign(operate);
                }
            }, {
                text: '取消',
                handler: function() {
                    keySignParam.loginDialog.dialog('close');
                    return false;
                }
            }]
        });
    } else {
        var msg = signContent(strKey, loginInfo, insID);
        if (msg != '') {
            alert(msg);
            return false;
        }

        return true;
    }
}



// 获取插入的证书列表
function GetList_pnp() {
    var lst = opener.GetUserList();
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

var strServerRan = '';
var strServerSignedData = '';
var strServerCert = '';
var strKey = '';
var strUserSignedData = '';
var strUserCert = '';

//初始化CA相关信息，在登录框弹出前，错误返回false，正确返回true
function CASessionDataInit() {
    strServerRan = '';
    strServerSignedData = '';
    strServerCert = '';
    var result = false;
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: keySignParam.urlDigitalSignature,
        async: false,
        cache: false,
        data: {
            func: 'CASessionDataInit'
        },
        success: function(ret) {
            if (ret && ret.Err) {
                alert('数字签名初始化错误！' + ret.Err);
            } else {
                strServerRan = ret.ServerRan;
                strServerSignedData = ret.ServerSignedData;
                strServerCert = ret.ServerCert;
                strKey = ret.Key;
                result = true;
            }
        },
        error: function(ret) {
			debugger;
		}

    });
    return result;
}

//保存key的信息，下次可以不用输密码，无返回值
function SetKeyInSession(key) {
    $.ajax({
        type: 'POST',
        url: keySignParam.urlDigitalSignature,
        async: true,
        cache: false,
        data: {
            func: 'SetKeyInSession',
            Key: key
        }
    });
}

//登录，返回用户名，和签名图片
function ajaxLogin(key, operate) {

    var loginInfo = '';
    var cert = '';
    var UserSignedData = '';
    try {
        if ('' == cert) {
            cert = opener.GetSignCert(key);
            UserSignedData = opener.SignedData(strServerRan, key);
        } else {
            UserSignedData = strUserSignedData; // document.getElementsByName('UserSignedData')[0].value;
            cert = strUserCert; // document.getElementsByName('UserCert')[0].value;
        }

    } catch (err) {}

    var UsrCertCode = opener.GetUniqueID(cert);
    var certificateNo = opener.GetCertNo(key);

    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: keySignParam.urlDigitalSignature,
        async: false,
        cache: false,
        data: {
            func: 'login',
            UserSignedData: UserSignedData,
            ServerRan: strServerRan,
            certificate: cert,
            certificateNo: certificateNo,
            UsrCertCode: UsrCertCode,
            operate: operate
        },
        success: function(ret) {
            if (ret && ret.Err) {
                alert(ret.Err);
            } else {
                loginInfo = JSON.stringify(ret);
            }
        },
        error: function(ret) {}
    });

    return loginInfo;
}

function getSignContent(usrInfo, insID) {
        var ret = "";
        var info = JSON.parse(usrInfo);
        //debugger;
        var signInfo = signDocument(insID, info.Type, info.Level, info.Id, info.Name, info.Image);
        if (signInfo && signInfo.result == 'OK') {
            ret = signInfo.Digest;
        }
        return ret;
    }
    // 获取原文(编辑器已经hash压缩)签名,服务器验证,通知编辑器保存SignID签名记录号
function signContent(key, usrInfo, insID) {
    var result = ''; //返回错误信息
    var UsrCertCode = opener.GetUniqueID(opener.GetSignCert(key));
    if (!UsrCertCode || '' == UsrCertCode)
        return '用户唯一标示为空！';
    //debugger;
    var contentHash = getSignContent(usrInfo, insID);
    if (!contentHash || '' == contentHash)
        return '签名原文为空！';

    var signValue = opener.SignedData(contentHash, key);
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: keySignParam.urlDigitalSignature,
        async: false,
        cache: false,
        data: {
            func: 'sign',
            UsrCertCode: UsrCertCode,
            signValue: signValue,
            contentHash: contentHash
        },
        success: function(ret) {

            if (ret && ret.Err) {
                result = ret.Err;
            } else {
                var info = JSON.parse(usrInfo);
                var saveRet = saveSignedDocumentSync(insID, ret.SignID, contentHash, info.Level, info.Id);

                if (saveRet && 'OK' == saveRet.params.result) {

					showEditorMsg('数据签名成功!');
                    doRefreshTmpPanel(saveRet.params.InstanceID);
                } else {


                    var ret = unSignedDocumentSync();
                    if ('ERROR' == ret.result) result = '撤销最后一次签名失败！';            
                }
            }

        },
        error: function(ret) {
            result = ret;
        }
    });
    return result;
}

function VerifySignature(signID, contentHash) {
    var result = '';
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: keySignParam.urlDigitalSignature,
        async: false,
        cache: false,
        data: {
            func: 'verify',
            signID: signID,
            contentHash: contentHash
        },
        success: function(ret) {
            if (ret && ret.Err) {
                alert(ret.Err);
            } else {
                result = ret.Message;
            }

        },
        error: function(ret) {}
    });
    return result;
}
