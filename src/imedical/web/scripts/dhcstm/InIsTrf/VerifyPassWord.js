//出库单密码确认
//2015-06-09
function VerifyPassWord(VerifyStr, Fn){
	var VerifyStrArr = VerifyStr.split('^');
	var VerifyLocId = VerifyStrArr[0];
	var VerifyUserId = VerifyStrArr[1];
	var VerifyUserCode = VerifyStrArr[2];
	var gVerifyUserId = '';		//确认人id

	var VerifyUser = new Ext.form.TextField({
		fieldLabel : '用户',
		id : 'VerifyUser',
		anchor : '90%',
		msgTarget : 'side',
		validator : function(value){
			if(value == ""){
				return false;
			}
			gVerifyUserId = tkMakeServerCall("web.DHCSTM.Common.UtilCommon","GetDeptUserId",VerifyLocId,value);
			return Ext.isEmpty(gVerifyUserId)? false : true;
		},
		listeners : {
			specialKey : function(field, e){
				if(e.getKey() == Ext.EventObject.ENTER){
					Ext.getCmp('VerifyPassWord').focus(true);
				}
			}
		}
	});
	
	if(!Ext.isEmpty(VerifyUserId) && !Ext.isEmpty(VerifyUserCode)){
		VerifyUser.setValue(VerifyUserCode);
		gVerifyUserId = VerifyUserId;
	}
	
	var VerifyPassWord = new Ext.form.TextField({
		id : 'VerifyPassWord',
		fieldLabel : '签名密码',
		inputType : 'password',
		enableKeyEvents : true,
		anchor : '90%',
		listeners : {
			keyup : function(field, e){
				if(gVerifyUserId == ""){
					Msg.info('warning', '用户名称有误!')
					return false;
				}
				var PassWord = field.getValue();
				var IsOK = tkMakeServerCall("web.DHCSTM.Common.UtilCommon","CheckPassword",gVerifyUserId,PassWord);
				if(IsOK == '1'){
					VerifyYes.setDisabled(false);
					Ext.getCmp('VerifyUser').setDisabled(true);
				}else{
					VerifyYes.setDisabled(true);
					Ext.getCmp('VerifyUser').setDisabled(false);
				}
			},
			specialKey : function(field, e){
				if(e.getKey() == Ext.EventObject.ENTER){
					if(!Ext.getCmp('VerifyYes').disabled){
						VerifyYes.handler();
					}
				}
			}
		}
	});
	
	var VerifyYes = new Ext.Button({
		id:'VerifyYes',
		text:'确认',
		height : 30,
		width : 70,
		iconCls:'page_gear',
		disabled : true,
		handler:function(){
			if(gVerifyUserId == ''){
				Msg.info('error', '签名信息有误!');
				return false;
			}
			Fn(gVerifyUserId);
			VerifyPassWordWin.close();
		}
	});
	
	var VerifyNo = new Ext.Button({
		id:'VerifyNo',
		text:'关闭',
		height : 30,
		width : 70,
		iconCls:'page_close',
		handler:function(){
			VerifyPassWordWin.close();
		}
	});
	
	var VerifyClear = new Ext.Toolbar.Button({
		id : "VerifyClear",
		text : '清空',
		height : 30,
		width : 70,
		iconCls:'page_clearscreen',
		handler : function() {
			gVerifyUserId = '';
			Ext.getCmp("VerifyUser").setValue("");
			Ext.getCmp("VerifyUser").setDisabled(false);
			Ext.getCmp("VerifyPassWord").setValue("");
		}
	});
	
	var VerifyPanel = new Ext.form.FormPanel({
		id:'VerifyPanel',
		region:'center',
		layout:'form',
		labelWidth:60,
		frame:true,
		labelAlign:'right',
		bodyStyle:'padding:10px;',
		items:[VerifyUser, VerifyPassWord]
	});
	
	var VerifyPassWordWin = new Ext.Window({
		title : '密码确认',
		width : 350,
		height : 180,
		modal : true,
		layout : 'border',
		bodyStyle : 'padding:10px;',
		items : [VerifyPanel],
		buttons : [VerifyYes, VerifyClear, VerifyNo],
		buttonAlign : 'center'
	});
	
	VerifyPassWordWin.show();
}