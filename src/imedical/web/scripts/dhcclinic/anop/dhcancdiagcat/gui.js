function InitViewport(){
	var obj = new Object();
	obj.DiagnosisCatCode = new Ext.form.TextField({
		id : 'DiagnosisCatCode'
		,fieldLabel : '系统分类代码'
		,anchor : '95%'
	});	
	obj.DiagnosisCat = new Ext.form.TextField({
		id : 'DiagnosisCat'
		,fieldLabel : '系统分类名称'
		,anchor : '95%'
	});	

	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,height : 120
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.DiagnosisCatCode
		]
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,height : 100
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.DiagnosisCat
		]
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[]
	});
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[]
	});
	obj.btnSch = new Ext.Button({
		id : 'btnSch'
		,text : '查询'
	});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-edit'
		,text : '保存'
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,itemCls : 'icon-delete'
		,text : '删除'
	});
	obj.FormPanel = new Ext.form.FormPanel({
		id : 'FormPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,title : '人体系统分类维护'
		,region : 'north'
		,layout : 'column'
		,frame : true
		,height : 100
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
		]
		,buttons:[
			obj.btnSch
			,obj.btnSave
			//,obj.btnEdit
			,obj.btnDelete
		]
	});
	obj.GridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.GridPanelStore = new Ext.data.Store({
		proxy: obj.GridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowId'
		}, 
		[
			{name: 'rowId', mapping: 'rowId'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'DiagCatDes', mapping: 'DiagCatDes'}
		])
	});
	obj.GridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.GridPanel = new Ext.grid.GridPanel({
		id : 'GridPanel'
		,store : obj.GridPanelStore
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '分类代码', width: 200, dataIndex: 'Code', sortable: true}
			,{header: '分类名称', width: 210, dataIndex: 'DiagCatDes', sortable: true}
			,{header: '分类ID', width: 150, dataIndex: 'rowId', sortable: true}
		]});
		
	obj.GridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCDiagCat';
		param.QueryName = 'LookUpDiagCat';
		param.Arg1=obj.DiagnosisCatCode.getValue();
		param.Arg2=obj.DiagnosisCat.getValue();
		param.ArgCnt =2;
	});
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.FormPanel
			,obj.GridPanel
		]
	});

	obj.GridPanelStore.load({});
	InitViewportEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	obj.GridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.btnSch.on("click", obj.btnSch_click, obj);
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.btnDelete.on("click", obj.btnDelete_click, obj);
	return obj;
}


