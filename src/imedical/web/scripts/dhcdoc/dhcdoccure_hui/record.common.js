 /**
 *record.common.js
 **/
function CheckSaveInfo(){
	if($("#DCRCurePOA").length>0){
		var CurePOAData=$HUI.combobox("#DCRCurePOA").getData();
		var CurePOAID="";
		if(CurePOAData.length>0){
			CurePOAID=$HUI.combobox("#DCRCurePOA").getValues();
			if (CurePOAID==""){
				$.messager.alert("��ʾ","��ѡ�����Ʋ�λ/Ѩλ","info");
				return false;
			}else{
				CurePOAID=CurePOAID.join(String.fromCharCode(1));
				//����CDSS�ӿ��ж�ִ�в�λѨλ�Ľ�����,Ԥ��
				//ToDo...	
			}
		}
	}
	if(ServerObj.CureLocReconfirm=="1"){
		var argObj={
			UserCodeElement:"ReConfirmUser",
			UserPinElement:"ReConfirmUserPin"	
		}
		var ret=ReConfirmFun.PasswordOnKeyDown(argObj);
		if(!ret){
			return false;
		}
	}
	return true;
}

//����˫ǩ��֤����
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