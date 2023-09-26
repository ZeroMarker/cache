function InitwinViewport(){
	var obj = new Object();
	obj.MessageGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.MessageGridStore = new Ext.data.Store({
		proxy: obj.MessageGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'UserID', mapping: 'UserID'}
			,{name: 'UserName', mapping: 'UserName'}
			,{name: 'CreateDate', mapping: 'CreateDate'}
			,{name: 'CreateTime', mapping: 'CreateTime'}
			,{name: 'Message', mapping: 'Message'}
		])
	});
	obj.MessageGridCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.MessageGrid = new Ext.grid.GridPanel({
		id : 'MessageGrid'
		,store : obj.MessageGridStore
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '姓名', width: 100, dataIndex: 'UserName', sortable: true}
			,{header: '创建日期', width: 100, dataIndex: 'CreateDate', sortable: true}
			,{header: '创建时间', width: 100, dataIndex: 'CreateTime', sortable: true}
			,{header: '内容', width: 500, dataIndex: 'Message', sortable: true}
		]});
	obj.LeftPanel = new Ext.Panel({
		id : 'LeftPanel'
		,buttonAlign : 'center'
		,columnWidth : .01
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
			,{name: 'UserInitials', mapping: 'UserInitials'}
		])
	});
	obj.UserCBox = new Ext.form.ComboBox({
		id : 'UserCBox'
		,selectOnFocus : true
		,forceSelection : true
		,minChars : 1
		,displayField : 'UserName'
		,fieldLabel : '用户'
		,store : obj.UserCBoxStore
		,typeAhead : true
		,triggerAction : 'all'
		,anchor : '95%'
		,mode : 'local'
		,valueField : 'rowid'
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
			,{name: 'code', mapping: 'code'}
			,{name: 'desc', mapping: 'desc'}
		])
	});
	obj.CtlocCBox = new Ext.form.ComboBox({
		id : 'CtlocCBox'
		,selectOnFocus : true
		,forceSelection : true
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '科室'
		,store : obj.CtlocCBoxStore
		,typeAhead : true
		,mode : 'local'
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'rowid'
});
	obj.GroupCBoxStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.GroupCBoxStore = new Ext.data.Store({
		proxy: obj.GroupCBoxStoreProxy,
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
	obj.GroupCBox = new Ext.form.ComboBox({
		id : 'GroupCBox'
		,selectOnFocus : true
		,forceSelection : true
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '安全组'
		,store : obj.GroupCBoxStore
		,typeAhead : true
		,triggerAction : 'all'
		,mode : 'local'
		,anchor : '95%'
		,valueField : 'rowid'
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
		,height : 300
		,anchor : '95%'
		,columns: [
			{width: 0, dataIndex: 'UserID'}
			,{width: 243, dataIndex: 'UserName'}
		]});
	obj.MessageText = new Ext.form.TextArea({
		id : 'MessageText'
		,fieldLabel : '消息内容'
		,anchor : '95%'
		,height: 120
});
	obj.MessID = new Ext.form.TextField({
		id : 'MessID'
		,hidden : true
});
	obj.BtnSave = new Ext.Button({
		id : 'BtnSave'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '保存'
});
	obj.BtnClear = new Ext.Button({
		id : 'BtnClear'
		,iconCls : 'icon-delete'
		,anchor : '95%'
		,text : '清空'
});
	obj.CenterPanel = new Ext.Panel({
		id : 'CenterPanel'
		,buttonAlign : 'center'
		,columnWidth : .98
		,layout : 'form'
		,items:[
			obj.MessageText
			,obj.UserCBox
			,obj.CtlocCBox
			,obj.GroupCBox
			,obj.MessRecUser
			,obj.MessID
		]
	,	buttons:[
			obj.BtnSave
			,obj.BtnClear
		]
	});
	obj.RightPanel = new Ext.Panel({
		id : 'RightPanel'
		,buttonAlign : 'center'
		,columnWidth : .01
		,items:[
		]
	});
	obj.EditFPanel = new Ext.form.FormPanel({
		id : 'EditFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,width : 350
		,region : 'east'
		,layout : 'column'
		,frame : true
		,items:[
			obj.LeftPanel
			,obj.CenterPanel
			,obj.RightPanel
		]
	});
	obj.winViewport = new Ext.Viewport({
		id : 'winViewport'
		,layout : 'border'
		,items:[
			obj.MessageGrid
			,obj.EditFPanel
		]
	});
	obj.MessageGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.MessageSrv';
			param.QueryName = 'QueryMessageByID';
			param.Arg1 = session['LOGON.USERID'];
			param.Arg2 = '';
			param.ArgCnt = 2;
	});
	obj.MessageGridStore.load({});
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
	obj.GroupCBoxStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.MessageSrv';
			param.QueryName = 'QueryAllGroup';
			param.ArgCnt = 0;
	});
	obj.GroupCBoxStore.load({});
	obj.MessRecUserStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = '';
			param.QueryName = '';
			param.ArgCnt = 0;
	});
	InitwinViewportEvent(obj);
	//事件处理代码
	obj.MessageGrid.on("rowdblclick", obj.MessageGrid_rowdblclick, obj);
	obj.MessageGrid.on("rowclick", obj.MessageGrid_rowclick, obj);
	obj.UserCBox.on("select", obj.UserCBox_select, obj);
	obj.CtlocCBox.on("select", obj.CtlocCBox_select, obj);
	obj.GroupCBox.on("select", obj.GroupCBox_select, obj);
	obj.BtnSave.on("click", obj.BtnSave_click, obj);
	obj.BtnClear.on("click", obj.BtnClear_click, obj);
	obj.MessRecUser.on("rowcontextmenu", obj.MessRecUser_rowcontextmenu, obj);
  	obj.LoadEvent(arguments);
  	return obj;
}
function InitViewWin(MessageID){
	var obj = new Object();
	obj.RecUserGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.RecUserGridStore = new Ext.data.Store({
		proxy: obj.RecUserGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'UserName', mapping: 'UserName'}
			,{name: 'IsRead', mapping: 'IsRead'}
			,{name: 'ReadDate', mapping: 'ReadDate'}
			,{name: 'ReadTime', mapping: 'ReadTime'}
		])
	});
	obj.RecUserGridCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.RecUserGrid = new Ext.grid.GridPanel({
		id : 'RecUserGrid'
		,store : obj.RecUserGridStore
		,buttonAlign : 'center'
		,width : 337
		,height : 268
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '姓名', width: 100, dataIndex: 'UserName', sortable: true}
			,{header: '已读', width: 50, dataIndex: 'IsRead', sortable: true}
			,{header: '阅读日期', width: 80, dataIndex: 'ReadDate', sortable: true}
			,{header: '阅读时间', width: 80, dataIndex: 'ReadTime', sortable: true}
		]});
	obj.ViewWin = new Ext.Window({
		id : 'ViewWin'
		,height : 300
		,buttonAlign : 'center'
		,width : 370
		,modal : true
		,layout : 'fit'
		,items:[
			obj.RecUserGrid
		]
	});
	obj.RecUserGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.MessageSrv';
			param.QueryName = 'QueryAllUserByMegDr';
			param.Arg1 = MessageID;
			param.ArgCnt = 1;
	});
	obj.RecUserGridStore.load({});
	InitViewWinEvent(obj);
	//事件处理代码
 
  return obj;
}

