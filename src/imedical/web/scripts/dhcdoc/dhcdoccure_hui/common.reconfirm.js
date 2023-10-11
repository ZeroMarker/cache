//复核 common.reconfirm.js
var ReConfirmFun=(function(){
	function UserOnKeyDown(argObj){
		var UserCodeElement=argObj.UserCodeElement;
		var UserPinElement=argObj.UserPinElement;
		var UserCode=$('#'+UserCodeElement).val();
		var LogUserCode=session['LOGON.USERCODE'];
		if(UserCode.toUpperCase()==LogUserCode.toUpperCase())
		{
			$.messager.alert("提示","复核用户不能与当前登录用户相同.","warning",function(){
				$('#'+UserCodeElement).val("").focus();
			});
			return false;
		}
		var Checkisuser=$.cm({
			ClassName:"DHCDoc.DHCDocCure.Common",
			MethodName:"CheckIsUser",
			userCode:UserCode,
			dataType:"text"
		},false)
		if(Checkisuser=="" || +Checkisuser<=0){
			$.messager.alert("提示","复核人用户无效或未激活,请确认!","warning",function(){
				$('#'+UserCodeElement).focus();
			});
			return false;
		}
		$('#'+UserPinElement).focus();
		return true;
	}
	function PasswordOnKeyDown(argObj)
	{
		var UserCodeElement=argObj.UserCodeElement;
		var UserPinElement=argObj.UserPinElement;
		var UserCode=$('#'+UserCodeElement).val();
		var UserPin=$('#'+UserPinElement).val();
		var LogUserCode=session['LOGON.USERCODE'];
		var LogCTLoc=_PageCureObj.LogCTLocID;
		if(UserCode.toUpperCase()==LogUserCode.toUpperCase())
		{
			$.messager.alert("提示","复核用户不能与当前登录用户相同.","warning",function(){
				$('#'+UserCodeElement).val("").focus();
				$('#'+UserPinElement).val("");
			});
			return false;
		}
		if(UserCode==""){
			$.messager.alert("提示","治疗执行需双签验证,复核人工号不可为空!","warning",function(){
				$('#'+UserCodeElement).focus();
			});
			return false
		}
		if(UserPin==""){
			$.messager.alert("提示","治疗执行需双签验证,复核人密码不可为空!","warning",function(){
				$('#'+UserPinElement).focus();
			});
			return false
		}
		var resStr=$.cm({
			ClassName:"DHCDoc.DHCDocCure.Common",
			MethodName:"ConfirmPassWord",
			userCode:UserCode,
			passWord:UserPin,
			userLoc:LogCTLoc,
			dataType:"text"
		},false)
		if(resStr.split("^")[0]!="0")
		{
			$.messager.alert("提示","治疗执行双签验证失败:"+resStr+" 请重试!","warning");
			return false;
		}
		return true;
	}
	
	return{
		"UserOnKeyDown":UserOnKeyDown,
		"PasswordOnKeyDown":PasswordOnKeyDown	
	}
})()