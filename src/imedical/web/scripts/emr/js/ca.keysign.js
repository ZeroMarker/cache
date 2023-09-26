var urlDigitalSignature = '../EMRservice.Ajax.caKeySign.cls';

$(function () {
	//debugger;  test
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
		dialogHtml = dialogHtml + '<td><input id="password" type="password" name="password"></td>';
		dialogHtml = dialogHtml + '</tr>';
		dialogHtml = dialogHtml + '</table>';
		dialogHtml = dialogHtml + '</form>';
		dialogHtml = dialogHtml + '</div>';
		$('body').append(dialogHtml);
		$('#keys').combobox({
			valueField : 'id',
			textField : 'text',
			editable : false
		});
		
		$('#keySign').click(function() {
			keySign("", "");
		});
	}
});

//挂接插件\事件监听
function pluginAdd() {
	addEvent(plugin(), 'onFailure', function (command) {
		alert(command);
	});
	addEvent(plugin(), 'onExecute', function (command) {
		var commandJson = jQuery.parseJSON(command);
		if (commandJson.action == "eventGetMetaDataTree") {
			eventGetMetaDataTree(commandJson);
		} else if (commandJson.action == "eventElementChanged") {
			eventElementChanged(commandJson);
			alert("eventElementChanged");
		}
	});
}
//添加监听事件
function addEvent(obj, name, func) {
	if (window.addEventListener) {
		obj.addEventListener(name, func, false);
	} else {
		obj.attachEvent("on" + name, func);
	}
}
//查找插件
function plugin() {
	return $("#plugin")[0];
}

//执行execute
function cmdDoExecute(argJson) {
	plugin().execute(JSON.stringify(argJson));
};

function keySign(operate, InstanceID) {
	if (!CASessionDataInit()) {
		return;
	}
	if (!GetList_pnp()) {
		$.messager.alert('提示', '未检测到证书！');
		return;
	}

	if (strKey && '' != strKey) {
		loginInfo = ajaxLogin(strKey, operate);
		if ('' != loginInfo) {
			var signID = signContent(key, loginInfo, InstanceID);
			//通知编辑器保存
			$.messager.alert('提示', '登录成功1！');
			return;
		}
	}

	var loginDialog = $('#loginDialog').show().dialog({
			closable : false,
			modal : true,
			buttons : [{
					text : '确定',
					handler : function () {
						var key = $('#keys').combobox('getValue');
						var pwd = $("#password").val();
						var frm = document.getElementById('loginForm'); //$('#loginForm')
						if ("" == key || "" == pwd || !Login(frm, key, pwd))
							return;
						loginInfo = ajaxLogin(key, operate);
						if ('' != loginInfo) {
							SetKeyInSession(key);
							signContent(key, loginInfo, InstanceID);
							//通知编辑器保存
							$.messager.alert('提示', '登录成功2！');
						}
						$("#password").val('');
					}
				}, {
					text : '取消',
					handler : function () {
						loginDialog.dialog('close');
					}
				}
			]
		});

}

// 获取插入的证书列表
function GetList_pnp() {
	var lst = GetUserList();
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
//初始化CA相关信息，在登录框弹出前，错误返回false，正确返回true
function CASessionDataInit() {
	strServerRan = '';
	strServerSignedData = '';
	strServerCert = '';
	var result = false;
	$.ajax({
		type : 'POST',
		dataType : 'json',
		url : urlDigitalSignature,
		async : false,
		cache : false,
		data : {
			func : 'CASessionDataInit'
		},
		success : function (ret) {
			if (ret && ret.Err) {
				$.messager.alert('数字签名初始化错误！', ret.Err);
			} else {
				strServerRan = ret.ServerRan;
				strServerSignedData = ret.ServerSignedData;
				strServerCert = ret.ServerCert;
				strKey = ret.Key;
				result = true;
			}
		},
		error : function (ret) {}
	});
	return result;
}

//保存key的信息，下次可以不用输密码，无返回值
function SetKeyInSession(key) {
	$.ajax({
		type : 'POST',
		url : urlDigitalSignature,
		async : true,
		cache : false,
		data : {
			func : 'SetKeyInSession',
			Key : key
		}
	});
}

//登录，返回用户名，和签名图片
function ajaxLogin(key, operate) {
	var loginInfo = '';
	var cert = '';
	var UserSignedData = '';
	try {
		UserSignedData = document.getElementsByName('UserSignedData')[0].value;
		cert = document.getElementsByName('UserCert')[0].value;
	} catch (err) {}
	if ('' == cert) {
		cert = GetSignCert(key);
		UserSignedData = SignedData(strServerRan, key);
	}
	var UsrCertCode = GetUniqueID(cert);
	var certificateNo = GetCertNo(key);

	$.ajax({
		type : 'POST',
		dataType : 'json',
		url : urlDigitalSignature,
		async : false,
		cache : false,
		data : {
			func : 'login',
			UserSignedData : UserSignedData,
			ServerRan : strServerRan,
			certificate : cert,
			certificateNo : certificateNo,
			UsrCertCode : UsrCertCode,
			operate : operate
		},
		success : function (ret) {
			if (ret && ret.Err) {
				$.messager.alert('发生错误', ret.Err);
			} else {
				loginInfo = JSON.stringify(ret);
			}
		},
		error : function (ret) {}
	});

	return loginInfo;
}

function getContent(usrInfo, InstanceID) {
	//action: "SIGN_DOCUMENT", args: ｛"InstanceID":"0001","Type":"Graph", "actionType":" Attending ", "Authenticator":{"Id":"001", "Name":"张三", "Image":"。"},"params":{"…"}｝}
	//	{ action: "SIGN_DOCUMENT", args: ｛"InstanceID":"0001","Type":"Graph", "actionType":" Attending ", "Authenticator":{"Id":"001", "Name":"张三", "Image":"。"}}
	var info = JSON.parse(usrInfo);
	var Authenticator = {
		Id : info.Id,
		Name : info.Name,
		Image : info.Image
	};
	var args = {
		InstanceID : InstanceID,
		Type : info.type,
		Authenticator : Authenticator
	};
	var user = {
		action : "SIGN_DOCUMENT",
		args : args
	};
	var s = JSON.stringify(user);
	console.info(s);
}
// 获取原文(编辑器已经hash压缩)签名,服务器验证,通知编辑器保存SignID签名记录号
function signContent(key, usrInfo, InstanceID) {
	var SignID = '';

	var contentHash = getContent(usrInfo, InstanceID);
	try {}
	catch (err) {}
	if (!contentHash || '' == contentHash)
		return SignID;

	var signValue = SignedData(contentHash, key);
	var UsrCertCode = GetUniqueID(GetSignCert(key));
	$.ajax({
		type : 'POST',
		dataType : 'json',
		url : urlDigitalSignature,
		async : false,
		cache : false,
		data : {
			func : 'sign',
			UsrCertCode : UsrCertCode,
			signValue : signValue,
			contentHash : contentHash
		},
		success : function (ret) {
			if (ret && ret.Err) {
				$.messager.alert('发生错误', ret.Err);
			} else {
				SignID = ret.SignID;
			}

		},
		error : function (ret) {}
	});
	return SignID;
}
