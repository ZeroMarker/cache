//���� common.reconfirm.js
var ReConfirmFun=(function(){
	function UserOnKeyDown(argObj){
		var UserCodeElement=argObj.UserCodeElement;
		var UserPinElement=argObj.UserPinElement;
		var UserCode=$('#'+UserCodeElement).val();
		var LogUserCode=session['LOGON.USERCODE'];
		if(UserCode.toUpperCase()==LogUserCode.toUpperCase())
		{
			$.messager.alert("��ʾ","�����û������뵱ǰ��¼�û���ͬ.","warning",function(){
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
			$.messager.alert("��ʾ","�������û���Ч��δ����,��ȷ��!","warning",function(){
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
			$.messager.alert("��ʾ","�����û������뵱ǰ��¼�û���ͬ.","warning",function(){
				$('#'+UserCodeElement).val("").focus();
				$('#'+UserPinElement).val("");
			});
			return false;
		}
		if(UserCode==""){
			$.messager.alert("��ʾ","����ִ����˫ǩ��֤,�����˹��Ų���Ϊ��!","warning",function(){
				$('#'+UserCodeElement).focus();
			});
			return false
		}
		if(UserPin==""){
			$.messager.alert("��ʾ","����ִ����˫ǩ��֤,���������벻��Ϊ��!","warning",function(){
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
			$.messager.alert("��ʾ","����ִ��˫ǩ��֤ʧ��:"+resStr+" ������!","warning");
			return false;
		}
		return true;
	}
	
	return{
		"UserOnKeyDown":UserOnKeyDown,
		"PasswordOnKeyDown":PasswordOnKeyDown	
	}
})()