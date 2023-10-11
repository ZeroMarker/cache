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
				$.messager.alert("提示","请选择治疗部位/穴位","info");
				return false;
			}else{
				CurePOAID=CurePOAID.join(String.fromCharCode(1));
				//调用CDSS接口判断执行部位穴位的禁忌性,预留
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

//治疗双签认证复核
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