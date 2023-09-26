function InitViewport(){
	var obj = new Object();
	obj.RecListGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.RecListGridStore = new Ext.data.Store({
		proxy: obj.RecListGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'IsRead', mapping: 'IsRead'}
			,{name: 'CreateUserName', mapping: 'CreateUserName'}
			,{name: 'CreateDate', mapping: 'CreateDate'}
			,{name: 'CreateTime', mapping: 'CreateTime'}
			,{name: 'ReadDate', mapping: 'ReadDate'}
			,{name: 'ReadTime', mapping: 'ReadTime'}
			,{name: 'Message', mapping: 'Message'}
		])
	});
	obj.RecListGridCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.RecListGrid = new Ext.grid.GridPanel({
		id : 'RecListGrid'
		,store : obj.RecListGridStore
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			{header: '已读', width: 50, dataIndex: 'IsRead', sortable: true}
			,{header: '发送人', width: 100, dataIndex: 'CreateUserName', sortable: true}
			,{header: '发送日期', width: 80, dataIndex: 'CreateDate', sortable: true}
			,{header: '发送时间', width: 80, dataIndex: 'CreateTime', sortable: true}
			,{header: '阅读日期', width: 80, dataIndex: 'ReadDate', sortable: true}
			,{header: '阅读时间', width: 80, dataIndex: 'ReadTime', sortable: true}
			,{header: '内容', width: 400, dataIndex: 'Message', sortable: true}
		]});
	obj.LeftPanel = new Ext.Panel({
		id : 'LeftPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.IsRead = new Ext.form.Checkbox({
		id : 'IsRead'
		,fieldLabel : '已读'
		,anchor : '95%'
});
	obj.SendUserStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SendUserStore = new Ext.data.Store({
		proxy: obj.SendUserStoreProxy,
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
	obj.SendUser = new Ext.form.ComboBox({
		id : 'SendUser'
		,selectOnFocus : true
		,forceSelection : true
		,minChars : 1
		,displayField : 'UserName'
		,fieldLabel : '发送人'
		,store : obj.SendUserStore
		,typeAhead : true
		,triggerAction : 'all'
		,mode : 'local'
		,anchor : '95%'
		,valueField : 'rowid'
});
	obj.DateFrom = new Ext.form.DateField({
		id : 'DateFrom'
		,fieldLabel : '开始日期'
		,anchor : '95%'
		,format: 'Y-m-d'
});
	obj.DateTo = new Ext.form.DateField({
		id : 'DateTo'
		,fieldLabel : '结束日期'
		,anchor : '95%'
		,format: 'Y-m-d'
});
	obj.BtnFind = new Ext.Button({
		id : 'BtnFind'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '查询'
});
	obj.BtnRead = new Ext.Button({
		id : 'BtnRead'
		,anchor : '95%'
		,text : '阅读'
		,disabled : true
});
	obj.FindListPanel = new Ext.Panel({
		id : 'FindListPanel'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.IsRead
			,obj.SendUser
			,obj.DateFrom
			,obj.DateTo
		]
		,buttons:[
			obj.BtnFind
		]
	});
	obj.CenterPanel = new Ext.Panel({
		id : 'CenterPanel'
		,buttonAlign : 'center'
		,columnWidth : .2
		,items:[
		]
	});
	obj.MessContent = new Ext.form.TextArea({
		id : 'MessContent'
		,height : 100
		,fieldLabel : '邮件内容'
		,anchor : '95%'
});
   obj.pbar = new Ext.ProgressBar({
       text:'阅读...'
    });
	obj.ShowContentPanel = new Ext.Panel({
		id : 'ShowContentPanel'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.MessContent
		]
		,buttons:[
			obj.BtnRead
		]
	});
	obj.RightPanel = new Ext.Panel({
		id : 'RightPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.FindFPanel = new Ext.form.FormPanel({
		id : 'FindFPanel'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,labelWidth : 80
		,height : 160
		,region : 'north'
		,layout : 'column'
		,frame : true
		,items:[
			obj.LeftPanel
			,obj.FindListPanel
			,obj.CenterPanel
			,obj.ShowContentPanel
			,obj.RightPanel
		]
	});
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.RecListGrid
			,obj.FindFPanel
		]
	});
	obj.RecListGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.MessageSrv';
			param.QueryName = 'QueryRecMessage';
			param.Arg1 = session['LOGON.USERID'];
			param.Arg2 = obj.IsRead.getValue();
			param.Arg3 = obj.SendUser.getValue();
			param.Arg4 = obj.DateFrom.getValue();
			param.Arg5 = obj.DateTo.getValue();
			param.ArgCnt = 5;
	});
	obj.RecListGridStore.load({});
	obj.SendUserStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.MessageSrv';
			param.QueryName = 'QueryAllUser';
			param.ArgCnt = 0;
	});
	obj.SendUserStore.load({});
	InitViewportEvent(obj);
	//事件处理代码
	obj.RecListGrid.on("rowclick", obj.RecListGrid_rowclick, obj);
	obj.IsRead.on("check", obj.IsRead_check, obj);
	obj.SendUser.on("select", obj.SendUser_select, obj);
	obj.BtnFind.on("click", obj.BtnFind_click, obj);
	obj.BtnRead.on("click", obj.BtnRead_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}

