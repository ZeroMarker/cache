function InitViewport1(){
	var obj = new Object();
	obj.Panel13 = new Ext.Panel({
		id : 'Panel13'
		,buttonAlign : 'center'
		,columnWidth : .3
		,items:[
		]
	});
	obj.SDCode = new Ext.form.TextField({
		id : 'SDCode'
		,fieldLabel : '代码'
		,anchor : '95%'
});
	obj.SDDesc = new Ext.form.TextField({
		id : 'SDDesc'
		,fieldLabel : '描述'
		,anchor : '95%'
});
	obj.SDInPut = new Ext.form.TextField({
		id : 'SDInPut'
		,fieldLabel : '入参说明'
		,anchor : '95%'
});
	obj.SDQueryName = new Ext.form.TextField({
		id : 'SDQueryName'
		,fieldLabel : 'Query名称'
		,anchor : '95%'
});
	obj.SDResume = new Ext.form.TextField({
		id : 'SDResume'
		,fieldLabel : '备注'
		,anchor : '95%'
});
	obj.SDRowid = new Ext.form.TextField({
		id : 'SDRowid'
		,hidden : true
});
	obj.Panel14 = new Ext.Panel({
		id : 'Panel14'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.SDCode
			,obj.SDDesc
			,obj.SDInPut
			,obj.SDQueryName
			,obj.SDResume
			,obj.SDRowid
		]
	});
	obj.Panel15 = new Ext.Panel({
		id : 'Panel15'
		,buttonAlign : 'center'
		,columnWidth : .3
		,items:[
		]
	});
	obj.sDicPanel = new Ext.Panel({
		id : 'sDicPanel'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
			obj.Panel13
			,obj.Panel14
			,obj.Panel15
		]
	});
	obj.BtnUpdate = new Ext.Button({
		id : 'BtnUpdate'
		,iconCls : 'icon-update'
		,anchor : '95%'
		,text : '更新'
});
	obj.BtnDelete = new Ext.Button({
		id : 'BtnDelete'
		,iconCls : 'icon-delete'
		,anchor : '95%'
		,text : '删除'
});
	obj.sDicFormPanel = new Ext.form.FormPanel({
		id : 'sDicFormPanel'
		,buttonAlign : 'center'
		,labelWidth : 80
		,height : 210
		,title : '监控展现维护'
		,region : 'south'
		,labelAlign : 'right'
		,frame : true
		,items:[
			obj.sDicPanel
		]
	,	buttons:[
			obj.BtnUpdate
			,obj.BtnDelete
		]
	});
	obj.sDicGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.sDicGridPanelStore = new Ext.data.Store({
		proxy: obj.sDicGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'SDCode', mapping: 'SDCode'}
			,{name: 'SDDesc', mapping: 'SDDesc'}
			,{name: 'SDInPut', mapping: 'SDInPut'}
			,{name: 'SDQueryName', mapping: 'SDQueryName'}
			,{name: 'SDResume', mapping: 'SDResume'}
		])
	});
	obj.sDicGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.sDicGridPanel = new Ext.grid.GridPanel({
		id : 'sDicGridPanel'
		,store : obj.sDicGridPanelStore
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 100, dataIndex: 'SDCode', sortable: true}
			,{header: '描述', width: 100, dataIndex: 'SDDesc', sortable: true}
			,{header: '入参说明', width: 200, dataIndex: 'SDInPut', sortable: true}
			,{header: 'Query名称', width: 200, dataIndex: 'SDQueryName', sortable: true}
			,{header: '备注', width: 200, dataIndex: 'SDResume', sortable: true}
		]});
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			obj.sDicFormPanel
			,obj.sDicGridPanel
		]
	});
	obj.sDicGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CC.ShowDic';
			param.QueryName = 'QueryAll';
			param.ArgCnt = 0;
	});
	obj.sDicGridPanelStore.load({});
	InitViewport1Event(obj);
	//事件处理代码
	obj.BtnUpdate.on("click", obj.BtnUpdate_click, obj);
	obj.BtnDelete.on("click", obj.BtnDelete_click, obj);
	obj.sDicGridPanel.on("rowclick", obj.sDicGridPanel_rowclick, obj);
  obj.LoadEvent(arguments);
  return obj;
}

