function InitwinsSendMessage(paadm){
	var obj = new Object();
	obj.PatMessageListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.PatMessageListStore = new Ext.data.Store({
		proxy: obj.PatMessageListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'CreateUserName', mapping: 'CreateUserName'}
			,{name: 'CreateDate', mapping: 'CreateDate'}
			,{name: 'CreateTime', mapping: 'CreateTime'}
			,{name: 'Message', mapping: 'Message'}
		])
	});
	obj.PatMessageListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.PatMessageList = new Ext.grid.GridPanel({
		id : 'PatMessageList'
		,store : obj.PatMessageListStore
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '发送人', width: 80, dataIndex: 'CreateUserName', sortable: true}
			,{header: '发送日期', width: 80, dataIndex: 'CreateDate', sortable: true}
			,{header: '发送时间', width: 80, dataIndex: 'CreateTime', sortable: true}
			,{header: '内容', width: 300, dataIndex: 'Message', sortable: true}
		]});
	obj.LeftPanel = new Ext.Panel({
		id : 'LeftPanel'
		,buttonAlign : 'center'
		,columnWidth : .05
		,items:[
		]
	});
	obj.UserCBoxStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.UserCBoxStore = new Ext.data.Store({
		proxy: obj.UserCBoxStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'UserName', mapping: 'UserName'}
		])
	});
	obj.UserCBox = new Ext.form.ComboBox({
		id : 'UserCBox'
		,minChars : 1
		,displayField : 'UserName'
		,fieldLabel : '用户'
		,store : obj.UserCBoxStore
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'rowid'
		,selectOnFocus : true
		,forceSelection : true
		,typeAhead : true
		,mode : 'local'
});
	obj.CtlocCBoxStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.CtlocCBoxStore = new Ext.data.Store({
		proxy: obj.CtlocCBoxStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'desc', mapping: 'desc'}
		])
	});
	obj.CtlocCBox = new Ext.form.ComboBox({
		id : 'CtlocCBox'
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '科室'
		,store : obj.CtlocCBoxStore
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'rowid'
		,selectOnFocus : true
		,forceSelection : true
		,typeAhead : true
		,mode : 'local'
});
	obj.MessRecUserStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.MessRecUserStore = new Ext.data.Store({
		proxy: obj.MessRecUserStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'UserID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'UserID', mapping: 'UserID'}
			,{name: 'UserName', mapping: 'UserName'}
		])
	});
	obj.MessRecUserCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 0 });
	obj.MessRecUser = new Ext.grid.GridPanel({
		id : 'MessRecUser'
		,fieldLabel : '接收人'
		,store : obj.MessRecUserStore
		,height : 180
		,anchor : '95%'
		,columns: [
			{width: 0, dataIndex: 'UserID'}
			,{width: 130, dataIndex: 'UserName'}
		]});
	obj.LCenterPanel = new Ext.Panel({
		id : 'LCenterPanel'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.UserCBox
			,obj.CtlocCBox
			,obj.MessRecUser
		]
	});
	obj.Message = new Ext.form.TextArea({
		id : 'Message'
		,height : 232
		,fieldLabel : '内容'
		,anchor : '95%'
});
	obj.RCenterPanel = new Ext.Panel({
		id : 'RCenterPanel'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.Message
		]
	});
	obj.RightPanel = new Ext.Panel({
		id : 'RightPanel'
		,buttonAlign : 'center'
		,columnWidth : .05
		,items:[
		]
	});
	obj.BtnSave = new Ext.Button({
		id : 'BtnSave'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '发送'
});
	obj.BtnExit = new Ext.Button({
		id : 'BtnExit'
		,iconCls : 'icon-exit'
		,anchor : '95%'
		,text : '关闭'
});
	obj.BtnClear = new Ext.Button({
		id : 'BtnClear'
		,iconCls : 'icon-delete'
		,anchor : '95%'
		,text : '删除接收人列表'
});
	obj.EditMessFPanel = new Ext.form.FormPanel({
		id : 'EditMessFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,height : 300
		,region : 'south'
		,layout : 'column'
		,frame : true
		,items:[
			obj.LeftPanel
			,obj.LCenterPanel
			,obj.RCenterPanel
			,obj.RightPanel
		]
	,	buttons:[
			obj.BtnSave
			,obj.BtnClear
			,obj.BtnExit
		]
	});
	obj.winsSendMessage = new Ext.Window({
		id : 'winsSendMessage'
		,height : 500
		,buttonAlign : 'center'
		,width : 600
		,title : '发送消息'
		,layout : 'border'
		,items:[
			obj.PatMessageList
			,obj.EditMessFPanel
		]
	});
	obj.PatMessageListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.MessageSrv';
			param.QueryName = 'QueryPatMessage';
			param.Arg1 = paadm;
			param.ArgCnt = 1;
	});
	obj.PatMessageListStore.load({});
	obj.UserCBoxStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.MessageSrv';
			param.QueryName = 'QueryAllUser';
			param.ArgCnt = 0;
	});
	obj.UserCBoxStore.load({});
	obj.CtlocCBoxStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.MessageSrv';
			param.QueryName = 'QueryAllCtloc';
			param.ArgCnt = 0;
	});
	obj.CtlocCBoxStore.load({});
	obj.MessRecUserStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = '';
			param.QueryName = '';
			param.ArgCnt = 0;
	});
	InitwinsSendMessageEvent(obj,paadm);
	//事件处理代码
	obj.PatMessageList.on("rowclick", obj.PatMessageList_rowclick, obj);
	obj.UserCBox.on("select", obj.UserCBox_select, obj);
	obj.CtlocCBox.on("select", obj.CtlocCBox_select, obj);
	obj.BtnSave.on("click", obj.BtnSave_click, obj);
	obj.BtnExit.on("click", obj.BtnExit_click, obj);
	obj.BtnClear.on("click", obj.BtnClear_click, obj);
	obj.MessRecUser.on("rowcontextmenu", obj.MessRecUser_rowcontextmenu, obj);
  obj.LoadEvent(arguments);
  return obj;
}

