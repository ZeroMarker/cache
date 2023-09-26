var IsShowUserPos = "";
function setUsrType() {
	document.getElementById('trUsrType').style.display = '';

	var keyCombo = document.getElementById("cbxUsrType").options;
	keyCombo.length = 0;
	var items = userPost.split('^');
	keyCombo.options[keyCombo.length] = new Option("", "");
	for (var i = 0; i < items.length; i++) {
		var item = items[i];
		if ("" != item.split('||')[0]
				&& "" != item.split('||')[1].split('&&')[0]) {
			var key = item.split('||')[0];
			var value = item.split('||')[1];
			keyCombo.options[keyCombo.length] = new Option(key, value);
		}
	}

}

function GetList_pnp() {
	// debugger;
	var keyCombo = document.getElementById("cbxKey").options;
	keyCombo.length = 0;
	var lst = GetUserList();
	// alert(lst);
	var arrUsers = lst.split('&&&');
	for (var i = 0; i < arrUsers.length; i++) {
		var user = arrUsers[i];
		if (user != "") {
			var keyName = user.split('||')[0];
			var uniqueID = user.split('||')[1];
			var opt = new Option(keyName, uniqueID);
			keyCombo.options[keyCombo.length] = opt;
		}
	}
}
// 加载UsbKey
if (null != document.getElementById("UserSignedData"))
	GetList_pnp();
// 重置按钮
function resetInput() {
	document.getElementById("txtPassword").value = "";
}

function getObjById(id) {
	return document.getElementById(id).value
}

function SignDoc(key, params) {
	//debugger;
	var ret = false;
	try {
		params["UserSignedData"] = SignedData(strServerRan, key);
	} catch (err) {
		alert("产生签名数据失败！ " + err.message);
		return false;
	}
	ret = true;
	if (strServerRan != "" && params["UserSignedData"] == "")
		return false;
	params["ServerRan"] = strServerRan;
	var cert = GetSignCert(key);
	params["certificate"] = cert;
	params["certificateNo"] = GetCertNo(key);
	params["UsrCertCode"] = GetUniqueID(cert);
	if (document.getElementById("cbxUsrType").options.length > 0) {
		var items = getObjById("cbxUsrType").split('&&');
		params["userPos"] = items[0];
		if ("" != params["userPos"]) {
			params["OperAction"] = items[1];
			params["action"] = "check";
			params["userID"] = "";
		}
	}

	var contentHash = getContent(params);
	if ("" == contentHash) {
		return false;
	}
	params["contentHash"] = contentHash;
	params["signValue"] = SignedData(contentHash, key) // 对Hash进行签名

	params["UserSignedData"] = null;
	params["ServerRan"] = null;

	if ("check" == params["action"]) {
		ret = usrAudit(params);
	} else if ("updateMultiple" == params["action"])
		ret = usrAuditList(params);
	else if ("sign" == params["action"]) {
		ret = Signature(params);
	} else
		ret = true;

	return ret;
}

// 提交按钮
function caSign() {
	//debugger;
	var key = getObjById("cbxKey");
	var pwd = getObjById("txtPassword");
	if ("" == key || "" == pwd || !Login(document.caAuditForm, key, pwd))
		return;
		
	var params = parWindow.signArgs;
	if (params["EPRDocIDs"]){
		var EPRDocIDs = params["EPRDocIDs"].split('#');
		for (var i = 0; i < EPRDocIDs.length; i++) {
			params["EPRDocIDs"] = EPRDocIDs[i];	
			var ret = SignDoc(key, params);
			if (!ret) {
				if (!window.returnValue) { window.returnValue = false; }
				break;
			}
			window.returnValue = true;
		}
	}
	else{
		window.returnValue = SignDoc(key, params);
	}	
	SaveKeyInSession(key);
	//if (window.returnValue)
		window.close();	
}

function SaveKeyInSession(key) {
	//debugger;
	var ret = "";
	params = new Object();
	params["method"] = "SaveKeyInSession";
	params["Key"] = key;	
	jQuery.ajax({
				type : "POST",
				dataType : "text",
				url : "../web.eprajax.logs.DigitalSignatureService.cls",
				async : false,
				data : params,
				success : function(d) {
				},
				error : function(d) {
					debugger;
				}
			});
	params["method"] = null;
	return ret;
}

// 取病历信息，包括验证；成功：返回对病历的Hash；失败：返回空
function getContent(params) {
	// debugger;
	var ret = "";
	params["method"] = "GetContent";
	jQuery.ajax({
				type : "POST",
				dataType : "text",
				url : "../web.eprajax.logs.DigitalSignatureService.cls",
				async : false,
				data : params,
				success : function(d) {
					if ("0" == d.split('^')[0]) {
						alert(d.split('^')[1]);
					} else if ("" != d) {
						ret = HashData(d);
						if ("" == ret) {
							alert("生成病历摘要失败！" + d);
						}
					} else {
						alert("取病历内容失败！");
					}
				},
				error : function(d) {
					alert("error 取病历内容方法调用失败！");
				}
			});
	params["method"] = null;
	return ret;
}

// 签名
function Signature(params) {
	var ret = false;
	params["method"] = "sign";
	jQuery.ajax({
				type : "POST",
				dataType : "text",
				url : "../web.eprajax.logs.DigitalSignatureService.cls",
				async : false,
				data : params,
				success : function(d) {
					if ("0" == d.split('^')[0]) {
						parWindow.divState.innerHTML = d.split('^')[1];
						parWindow.getPower();
						ret = true;
					} else {
						alert("签名失败！" + d.split('^')[1]);
					}
				},
				error : function(d) {
					alert("签名服务错误！");
				}
			});
	params["method"] = null;

	return ret;
}

// 可重复模板审核 返回true/false
function usrAuditList(params) {
	var ret = false;
	jQuery.ajax({
				type : "POST",
				dataType : "text",
				url : "../web.eprajax.logs.updateMultiple.cls",
				async : false,
				data : params,
				success : function(d) {
					if ("LoginValidFail" == d)
						alert("用户名或密码错误!");
					else if ("CheckLevelFail" == d)
						alert("医师级别与进行的操作不一致!");
					else if ("success" == d.split('^')[0]) {
						parWindow.refresh();
						ret = true;
					} else if ("sessionTimedOut" == d)
						alert("登陆超时,会话已经中断,请重新登陆在进行操作!");
					else
						alert("操作失败!错误原因:" + d);
				},
				error : function(d) {
					alert("操作失败!");
				}
			});
	return ret;
}

// 可重复模板审核 返回true/false
function usrAudit(params) {
	var ret = false;
	jQuery.ajax({
				type : "POST",
				dataType : "text",
				url : "../web.eprajax.logs.check.cls",
				async : false,
				data : params,
				success : function(d) {
					if ("LoginValidFail" == d)
						alert("用户名或密码错误!");
					else if ("CheckLevelFail" == d)
						alert("医师级别与进行的操作不一致!");
					else if ("success" == d.split('^')[0]) {
						currState = d.split('^')[2];
						parWindow.divState.innerHTML = d.split('^')[1];
						parWindow.getPower();
						ret = true;
					} else if ("sessionTimedOut" == d)
						alert("登陆超时,会话已经中断,请重新登陆在进行操作!");
					else
						alert("操作失败!错误原因:" + d);
				},
				error : function(d) {
					alert("操作失败!");
				}
			});
	return ret;
}

function verifySign(params) {
	params["needLogin"] = "0";
	var contentHash = getContent(params);
	if ("" == contentHash) {
		return;
	}
	params["contentHash"] = contentHash;
	params["method"] = "VerifySign";
	jQuery.ajax({
				type : "POST",
				dataType : "text",
				url : "../web.eprajax.logs.DigitalSignatureService.cls",
				async : false,
				data : params,
				success : function(d) {
					if ("0" == d.split('^')[0])
						alert(d.split('^')[1]);
					else
						alert(d);
				},
				error : function(d) {
					alert("操作失败!");
				}
			});
}

// 回车确定
document.onkeydown = function() {
	if (13 == event.keyCode) {
		document.getElementById("submit").click();
		return false;
	} else if (27 == event.keyCode) {
		window.returnValue = false;
		window.close();
	}
}
