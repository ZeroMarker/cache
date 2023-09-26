function CU_InitCheckUserEvent(obj){
	obj.CU_LoadEvent = function(){
		obj.CU_btnCancel.on("click",obj.CU_btnCancel_click,obj);
		obj.CU_btnSave.on("click",obj.CU_btnSave_click,obj);
	};
	
	obj.CU_btnSave_click = function(){
		var UserName = Common_GetValue('CU_txtUserName');
		var Passward = Common_GetValue('CU_txtPassword');
		if (UserName == ''){
			ExtTool.alert('提示', '用户名为空!');
			Ext.getCmp("CU_txtUserName").focus(false, 100);
			return;
		}
		if (Passward == ''){
			ExtTool.alert('提示', '密码为空!');
			Ext.getCmp("CU_txtPassword").focus(false, 100);
			return;
		}
		
		var ret = ExtTool.RunServerMethod("DHCWMR.SSService.OperationSrv","VerifyUser",UserName,Passward);
		if (parseInt(ret) < 0){
			ExtTool.alert('提示', '密码验证错误!');
			return;
		} else {
			var ToUserID = ret.split('/')[0];
			if (ToUserID == session['LOGON.USERID']) {
				ExtTool.alert('提示','验证用户与登录用户相同!');
				return;
			}
		}
		obj.CU_Input.ToUserID = ToUserID;
		obj.WinCheckUser.close();
		objScreen.SaveData(obj.CU_Input);
	}
	
	obj.CU_btnCancel_click = function(){
		obj.WinCheckUser.close();
	}
}