/**
 * 交接密码验证
 * 
 * Copyright (c) 2018-2019 liyi. All rights reserved.
 * 
 * CREATED BY liyi 2020-05-15
 * 
 * 注解说明
 * TABLE: 
 */

function InitCheckUser(){
	$('#CheckUserDialog').css('display','block');
	var SealInfoDialog = $HUI.dialog('#CheckUserDialog',{
		title: '交接用户验证',
		iconCls: 'icon-w-edit',
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		buttons:[{
			text:'保存',
				iconCls:'icon-w-save',
				handler:function(){
					user_Save();
				}
		},{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
				closeView_user();
			}	
		}]
	});
}

// 保存按钮
function user_Save(){
	var UserCode = $("#txtUserCode").val();
	var Passward = $("#txtPassword").val();
	if (UserCode == ''){
		$.messager.popover({msg: '工号为空！',type: 'alert',timeout: 1000});
		Common_Focus('txtUserCode');
		return;
	}
	if (Passward == ''){
		$.messager.popover({msg: '密码为空！',type: 'alert',timeout: 1000});
		Common_Focus('txtPassword');
		return;
	}
	$m({
		ClassName:"MA.IPMR.ImedicalSrv",
		MethodName:"VerifyUser",
		aUserCode:UserCode,
		aPassWord:Passward
	},function(txtData){
		if (parseInt(txtData) < 0){
			$.messager.popover({msg: '密码验证错误！',type: 'alert',timeout: 1000});
			return;
		} else {
			var ToUserID = txtData.split('/')[0];
			if (ToUserID == Logon.UserID) {
				$.messager.popover({msg: '验证用户与登录用户相同！',type: 'alert',timeout: 1000});
				return;
			}
			globalObj.m_ToUserID = ToUserID;
			closeView_user();
			SaveOpera(3);
		}
	});
}

function closeView_user(){
	$("#txtUserCode").val('');
	$("#txtPassword").val('');
	$('#CheckUserDialog').window("close");
}