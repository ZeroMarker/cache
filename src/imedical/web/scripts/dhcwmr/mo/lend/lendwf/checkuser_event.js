function CU_InitCheckUserEvent(obj){
	obj.CU_LoadEvent = function(){
		obj.CU_btnCancel.on("click",obj.CU_btnCancel_click,obj);
		obj.CU_btnSave.on("click",obj.CU_btnSave_click,obj);
	};
	
	obj.CU_btnSave_click = function(){
		var UserName = Common_GetValue('CU_txtUserName');
		var Passward = Common_GetValue('CU_txtPassword');
		if (UserName == ''){
			ExtTool.alert('��ʾ', '�û���Ϊ��!');
			Ext.getCmp("CU_txtUserName").focus(false, 100);
			return;
		}
		if (Passward == ''){
			ExtTool.alert('��ʾ', '����Ϊ��!');
			Ext.getCmp("CU_txtPassword").focus(false, 100);
			return;
		}
		
		var ret = ExtTool.RunServerMethod("DHCWMR.SSService.OperationSrv","VerifyUser",UserName,Passward);
		if (parseInt(ret) < 0){
			ExtTool.alert('��ʾ', '������֤����!');
			return;
		} else {
			var ToUserID = ret.split('/')[0];
			if (ToUserID == session['LOGON.USERID']) {
				ExtTool.alert('��ʾ','��֤�û����¼�û���ͬ!');
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