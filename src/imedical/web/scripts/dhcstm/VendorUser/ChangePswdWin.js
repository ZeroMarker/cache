/**
 * 修改供应商用户密码的弹窗
 */
function ChangePswd(){
	
	var ChangeOldPswd = new Ext.form.TextField({
		id : 'ChangeOldPswd',
		fieldLabel : '密码',
		inputType : 'password',
		anchor: '90%'
	});
	var ChangeNewPswd = new Ext.form.TextField({
		id : 'ChangeNewPswd',
		fieldLabel : '新密码',
		inputType : 'password',
		anchor: '90%'
	});
	var ChangeNewAgainPswd = new Ext.form.TextField({
		id : 'ChangeNewAgainPswd',
		fieldLabel : '新密码确认',
		inputType : 'password',
		anchor: '90%'
	});
	var ChangeConfirmBT = new Ext.Button({
		text : '确定',
		handler : function(){
			var OldPswd = Ext.getCmp('ChangeOldPswd').getValue();
			var NewPswd = Ext.getCmp('ChangeNewPswd').getValue();
			var NewAgainPswd = Ext.getCmp('ChangeNewAgainPswd').getValue();
			if(Ext.isEmpty(OldPswd)){
				Msg.info('warning', '请输入旧密码!');
			}else if(Ext.isEmpty(NewPswd)){
				Msg.info('warning', '请输入新密码!');
			}else if(Ext.isEmpty(NewAgainPswd)){
				Msg.info('warning', '请确认新密码!');
			}else if(NewPswd != NewAgainPswd){
				Msg.info('error', '新输入密码不一致!');
			}else{
				var result = tkMakeServerCall('web.DHCSTM.VendorUser', 'ChangePswd', OldPswd, NewPswd);
				if(result == ''){
					Msg.info('success', '修改成功!');
					ChangePswdWin.close();
				}else{
					Msg.info('error', '修改失败:' + result);
				}
			}
		}
	});
	var ChangePswdWin = new Ext.Window({
		title : '修改密码',
		width : 300,
		height : 200,
		modal : true,
		layout : 'form',
		bodyStyle : 'padding-top:20px;',
		labelAlign : 'right',
		items : [ChangeOldPswd, ChangeNewPswd, ChangeNewAgainPswd],
		buttons : [ChangeConfirmBT],
		buttonAlign : 'center'
	});
	ChangePswdWin.show();
}