/**
 * �޸Ĺ�Ӧ���û�����ĵ���
 */
function ChangePswd(){
	
	var ChangeOldPswd = new Ext.form.TextField({
		id : 'ChangeOldPswd',
		fieldLabel : '����',
		inputType : 'password',
		anchor: '90%'
	});
	var ChangeNewPswd = new Ext.form.TextField({
		id : 'ChangeNewPswd',
		fieldLabel : '������',
		inputType : 'password',
		anchor: '90%'
	});
	var ChangeNewAgainPswd = new Ext.form.TextField({
		id : 'ChangeNewAgainPswd',
		fieldLabel : '������ȷ��',
		inputType : 'password',
		anchor: '90%'
	});
	var ChangeConfirmBT = new Ext.Button({
		text : 'ȷ��',
		handler : function(){
			var OldPswd = Ext.getCmp('ChangeOldPswd').getValue();
			var NewPswd = Ext.getCmp('ChangeNewPswd').getValue();
			var NewAgainPswd = Ext.getCmp('ChangeNewAgainPswd').getValue();
			if(Ext.isEmpty(OldPswd)){
				Msg.info('warning', '�����������!');
			}else if(Ext.isEmpty(NewPswd)){
				Msg.info('warning', '������������!');
			}else if(Ext.isEmpty(NewAgainPswd)){
				Msg.info('warning', '��ȷ��������!');
			}else if(NewPswd != NewAgainPswd){
				Msg.info('error', '���������벻һ��!');
			}else{
				var result = tkMakeServerCall('web.DHCSTM.VendorUser', 'ChangePswd', OldPswd, NewPswd);
				if(result == ''){
					Msg.info('success', '�޸ĳɹ�!');
					ChangePswdWin.close();
				}else{
					Msg.info('error', '�޸�ʧ��:' + result);
				}
			}
		}
	});
	var ChangePswdWin = new Ext.Window({
		title : '�޸�����',
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