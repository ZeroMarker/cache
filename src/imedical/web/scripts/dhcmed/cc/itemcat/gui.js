function InitViewport32(){
	var obj = new Object();
	obj.vGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.vGridPanelStore = new Ext.data.Store({
		proxy: obj.vGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'ICCode', mapping: 'ICCode'}
			,{name: 'ICDesc', mapping: 'ICDesc'}
			,{name: 'SubjectDr', mapping: 'SubjectDr'}
			,{name: 'title', mapping: 'title'}
		])
	});
	obj.vGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.vGridPanel = new Ext.grid.GridPanel({
		id : 'vGridPanel'
		,buttonAlign : 'center'
		,store : obj.vGridPanelStore
		,loadMask : true
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 150, dataIndex: 'ICCode', sortable: true}
			,{header: '描述', width: 300, dataIndex: 'ICDesc', sortable: true}
			,{header: '监控主题', width: 300, dataIndex: 'title', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.vGridPanelStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})

});
	obj.leftItemCatPanel = new Ext.Panel({
		id : 'leftItemCatPanel'
		,buttonAlign : 'center'
		,columnWidth : .3
		,items:[
		]
	});
	obj.ICCode = new Ext.form.TextField({
		id : 'ICCode'
		,fieldLabel : '代码'
		,anchor : '95%'
});
	obj.ICRowid = new Ext.form.TextField({
		id : 'ICRowid'
		,hidden : true
});
	obj.ICDesc = new Ext.form.TextField({
		id : 'ICDesc'
		,fieldLabel : '描述'
		,anchor : '95%'
});
	obj.SubjectDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SubjectDrStore = new Ext.data.Store({
		proxy: obj.SubjectDrStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			//{name: 'checked', mapping : 'checked'}
			{name: 'rowid', mapping: 'rowid'}
			,{name: 'Title', mapping: 'Title'}
		])
	});
	obj.SubjectDr = new Ext.form.ComboBox({
		id : 'SubjectDr'
		,store : obj.SubjectDrStore
		,minChars : 0
		,displayField : 'Title'
		,fieldLabel : '监控主题'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'rowid'
});
	obj.centerItemCatPanel = new Ext.Panel({
		id : 'centerItemCatPanel'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.ICCode
			,obj.ICDesc
			,obj.SubjectDr
			,obj.ICRowid
		]
	});
	obj.rightItemCatPanel = new Ext.Panel({
		id : 'rightItemCatPanel'
		,buttonAlign : 'center'
		,columnWidth : .3
		,items:[
		]
	});
	obj.ItemCatPanel = new Ext.Panel({
		id : 'ItemCatPanel'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
			obj.leftItemCatPanel
			,obj.centerItemCatPanel
			,obj.rightItemCatPanel
		]
	});
	obj.btnFind = new Ext.Button({
		id : 'btnFind'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '查询'
});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '更新'
});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,anchor : '95%'
		,text : '删除'
});
	obj.btnEdit = new Ext.Button({
		id : 'btnEdit'
		,iconCls : 'icon-edit'
		,anchor : '95%'
		,text : '子类'
});
	obj.ItemCatFPanel = new Ext.form.FormPanel({
		id : 'ItemCatFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'south'
		,frame : true
		,title : '监控项目大类维护'
		,height : 180
		,items:[
			obj.ItemCatPanel
		]
	,	buttons:[
			obj.btnFind
			,obj.btnSave
			,obj.btnDelete
			,obj.btnEdit
		]
	});
	obj.Viewport32 = new Ext.Viewport({
		id : 'Viewport32'
		,layout : 'border'
		,items:[
			obj.vGridPanel
			,obj.ItemCatFPanel
		]
	});
	obj.SubjectDrStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.SubjectSrv';
			param.QueryName = 'QuerySubjectDesc';
			param.ArgCnt = 0;
	});
	obj.SubjectDrStore.load({});
	obj.vGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.ItemCatSrv';
			param.QueryName = 'QueryItemCatInfo';
			param.Arg1 = obj.ICCode.getValue();
			param.ArgCnt = 1;
	});
	obj.vGridPanelStore.load({
	params : {
		start:0
		,limit:20
	}});

	InitViewport32Event(obj);
	//事件处理代码
	obj.vGridPanel.on("rowclick", obj.vGridPanel_rowclick, obj);
	obj.vGridPanel.on("rowdblclick", obj.vGridPanel_rowdblclick, obj);
	obj.btnFind.on("click", obj.btnFind_click, obj);
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.btnDelete.on("click", obj.btnDelete_click, obj);
	obj.btnEdit.on("click", obj.btnEdit_click, obj);
  obj.LoadEvent();
  return obj;
}
function InitwinEdit(){
	var obj = new Object();
	obj.wGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.wGridPanelStore = new Ext.data.Store({
		proxy: obj.wGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'ISCCode', mapping: 'ISCCode'}
			,{name: 'ISCDesc', mapping: 'ISCDesc'}
			,{name: 'ISCCatDr', mapping: 'ISCCatDr'}
			,{name: 'ICDesc', mapping: 'ICDesc'}
		])
	});
	obj.wGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.wGridPanel = new Ext.grid.GridPanel({
		id : 'wGridPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,store : obj.wGridPanelStore
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 150, dataIndex: 'ISCCode', sortable: true}
			,{header: '描述', width: 250, dataIndex: 'ISCDesc', sortable: true}
		]});
	obj.LeftWinPanel = new Ext.Panel({
		id : 'LeftWinPanel'
		,buttonAlign : 'center'
		,columnWidth : .05
		,items:[
		]
	});
	obj.ISCCode = new Ext.form.TextField({
		id : 'ISCCode'
		,fieldLabel : '代码'
		,anchor : '95%'
});
	obj.ISCRowid = new Ext.form.TextField({
		id : 'ISCRowid'
		,hidden : true
});
	obj.LeftCenterWinPanel = new Ext.Panel({
		id : 'LeftCenterWinPanel'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.ISCCode
			,obj.ISCRowid
		]
	});
	obj.ISCDesc = new Ext.form.TextField({
		id : 'ISCDesc'
		,fieldLabel : '描述'
		,anchor : '95%'
});
	obj.tICRowid = new Ext.form.TextField({
		id : 'tICRowid'
		,hidden : true
});
	obj.RightCenterWinPanel = new Ext.Panel({
		id : 'RightCenterWinPanel'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.ISCDesc
			,obj.tICRowid
		]
	});
	obj.RightWinPanel = new Ext.Panel({
		id : 'RightWinPanel'
		,buttonAlign : 'center'
		,columnWidth : .05
		,items:[
		]
	});
	obj.winPanel = new Ext.Panel({
		id : 'winPanel'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
			obj.LeftWinPanel
			,obj.LeftCenterWinPanel
			,obj.RightCenterWinPanel
			,obj.RightWinPanel
		]
	});
	obj.winBtnSave = new Ext.Button({
		id : 'winBtnSave'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '保存'
});
	obj.winBtnDelete = new Ext.Button({
		id : 'winBtnDelete'
		,iconCls : 'icon-delete'
		,anchor : '95%'
		,text : '删除'
});
	obj.winBtnExit = new Ext.Button({
		id : 'winBtnExit'
		,iconCls : 'icon-exit'
		,anchor : '95%'
		,text : '退出'
});
	obj.winFPanel = new Ext.form.FormPanel({
		id : 'winFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,height : 100
		,region : 'south'
		,frame : true
		,items:[
			obj.winPanel
		]
	,	buttons:[
			obj.winBtnSave
			,obj.winBtnDelete
			,obj.winBtnExit
		]
	});
	obj.winEdit = new Ext.Window({
		id : 'winEdit'
		,buttonAlign : 'center'
		,width : 442
		,title : '监控项目子类维护'
		,layout : 'border'
		,modal : true
		,height : 300
		,items:[
			obj.wGridPanel
			,obj.winFPanel
		]
	});
	obj.wGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.ItemCatSrv';
			param.QueryName = 'QueryItemSubCatInfo';
			param.Arg1 = obj.tICRowid.getValue();
			param.ArgCnt = 1;
	});
	obj.wGridPanelStore.load({});
	InitwinEditEvent(obj);
	//事件处理代码
	obj.wGridPanel.on("rowclick", obj.wGridPanel_rowclick, obj);
	obj.winBtnSave.on("click", obj.winBtnSave_click, obj);
	obj.winBtnDelete.on("click", obj.winBtnDelete_click, obj);
	obj.winBtnExit.on("click", obj.winBtnExit_click, obj);
  obj.LoadEvent();
  return obj;
}

