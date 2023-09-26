function CU_InitCheckUser(objInput){
	var obj = new Object();
	obj.CU_Input = new Object();
	obj.CU_Input.OperType = objInput.OperType;
	obj.CU_Input.ToUserID = objInput.ToUserID;
	obj.CU_Input.MrInfo = objInput.MrInfo;
	obj.CU_Input.SealInfo = objInput.SealInfo;
	
	obj.CU_txtUserName = new Ext.form.TextField({
		id : "CU_txtUserName"
		,fieldLabel : "用户名"
		,emptyText : '用户名'
		,anchor : '90%'
	});
	obj.CU_txtPassword = new Ext.form.TextField({
		id : "CU_txtPassword"
		,fieldLabel : "密码"
		,emptyText : '密码'
		,inputType : 'password'
		,anchor : '90%'
	});
	
	obj.CU_btnSave = new Ext.Button({
		id : 'CU_btnSave'
		,iconCls : 'icon-update'
		,width: 60
		,text : '确定'
	});
	obj.CU_btnCancel = new Ext.Button({
		id : 'CU_btnCancel'
		,iconCls : 'icon-exit'
		,width: 60
		,text : '关闭'
	});
	
	obj.WinCheckUser = new Ext.Window({
		id : 'WinCheckUser'
		,autoScroll : true
		,width : 350
		,height : 130
		,modal : true
		,title : '用户验证'
		,closable : false
		,layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 80
		,buttonAlign : 'center'
		,frame : true
		,items : [
			{text:' ',style:'font-weight:bold;font-size:5px;height:5px;',xtype:'label'}
			,obj.CU_txtUserName
			,obj.CU_txtPassword
		]
		,buttons : [
			obj.CU_btnSave
			,obj.CU_btnCancel
		]
	});
	
	CU_InitCheckUserEvent(obj);
	obj.CU_LoadEvent(arguments);
	return obj;
}

