// 名称:		供应商用户登录
// 编写日期:	2016-05-22
// 编写人:	王加宾

var VendorUserGridUrl = 'dhcstm.vendoruseraction.csp';

var VendorUser = new Ext.form.TextField({
	id : 'VendorUser',
	fieldLabel : '用户名',
	anchor: '90%'
});

var VendorPswd = new Ext.form.TextField({
	id : 'VendorPswd',
	fieldLabel : '密码',
	inputType : 'password',
	anchor: '90%',
	listeners : {
		specialkey : function(field, e){
			if(e.getKey() == e.ENTER){
				LogInButton.handler();
			}
		}
	}
});

var LogInButton = new Ext.Button({
	id : 'LogInButton',
	text : '登录',
	width : 50,
	anchor : '90%',
	handler : function(){
		LogIn();
	}
});

function LogIn(){
	var VendorUserId = Ext.getCmp('VendorUser').getValue();
	var VendorUserPswd = Ext.getCmp('VendorPswd').getValue();
	if(Ext.isEmpty(VendorUserId) || Ext.isEmpty(VendorUserPswd)){
		alert('用户名 或 密码 不可为空!');
		return false;
	}
	LogInPanel.getForm().submit({
		clientValidation: true,
		url: 'dhcstm.loginaction.csp?actiontype=login',
		success: function(form, action) {
	    	if(action.result.success=='true'){
		 		var url = 'dhcstm.vendoruserbarcode.csp'
				var win = window.open(encodeURI(url),'','top=0,left=0,width='+screen.availWidth+',height='+screen.availHeight+',toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,maximized=yes');
				win.opener = null;
				window.opener = null;
				window.open('', '_self');	//7.0以下注释
				window.close();
	    	}else{
	    		var info = action.result.info;
	    		alert(info);
	    	}
		}
	});
}

var LogInPanel = new Ext.form.FormPanel({
	labelAlign : 'right',
	frame : true,
	items : [VendorUser, VendorPswd],
	buttons : [LogInButton],
	buttonAlign : 'center'
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title : '医院供应商用户登录',
		height : 140,
		layout : 'fit',
		items : [LogInPanel],
		renderTo : 'mainPanel'
	});
});
