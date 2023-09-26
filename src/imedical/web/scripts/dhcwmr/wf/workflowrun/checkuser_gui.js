function CU_InitCheckUser(){
	var obj = new Object();
	
	obj.CU_txtUserName = new Ext.form.TextField({
		id : "CU_txtUserName"
		,fieldLabel : "用户名"
		,emptyText : '用户名'
		,anchor : '95%'
	});
	obj.CU_txtPassword = new Ext.form.TextField({
		id : "CU_txtPassword"
		,fieldLabel : "密码"
		,emptyText : '密码'
		,inputType : 'password'
		,anchor : '95%'
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
	
	obj.CU_WinCheckUser = new Ext.Window({
		id : 'CU_WinCheckUser'
		,height : 127
		,width : 240
		,modal : true
		,title : '用户验证'
		,closable : false
		,layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 55
		,buttonAlign : 'center'
		,resizable : false       //不可调整大小
		,draggable : false      //不可拖拽
		,frame : true
		,items:[
			{text:' ',style:'font-weight:bold;font-size:5px;height:5px;',xtype:'label'}
			,obj.CU_txtUserName
			,obj.CU_txtPassword
		]
		,bbar : ['&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',obj.CU_btnSave,obj.CU_btnCancel]
	});
	
	CU_InitCheckUserEvent(obj);
	obj.CU_LoadEvent(arguments);
	return obj;
}

