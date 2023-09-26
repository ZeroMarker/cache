function InitViewport(SubjectID){
	var obj = new Object();
	obj.CurrICRowid="";
	obj.vGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.vGridPanelStore = new Ext.data.Store({
		proxy: obj.vGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
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
			//,{header: 'ID', width: 150, dataIndex: 'Rowid', sortable: true}
			,{header: '代码', width: 100, dataIndex: 'Code', sortable: true}
			,{header: '描述', width: 100, dataIndex: 'Desc', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.vGridPanelStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig : {
			forceFit : true
		}
	});
	obj.ICCode = new Ext.form.TextField({
		id : 'ICCode'
		,fieldLabel : '代码'
		,labelSeparator :''
		,anchor : '95%'
	});
	obj.ICDesc = new Ext.form.TextField({
		id : 'ICDesc'
		,fieldLabel : '描述'
		,labelSeparator :''
		,anchor : '95%'
	});
	
	obj.leftItemCatPanel = new Ext.Panel({
		id : 'leftItemCatPanel'
		,buttonAlign : 'center'
		,columnWidth : .25
		,height : 1
		,items:[]
	});
	obj.centerItemCatPanel = new Ext.Panel({
		id : 'centerItemCatPanel'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.ICCode
			,obj.ICDesc
		]
	});
	obj.rightItemCatPanel = new Ext.Panel({
		id : 'rightItemCatPanel'
		,buttonAlign : 'center'
		,columnWidth : .25
		,items:[]
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
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-update'
		,anchor : '95%'
		,text : '更新'
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,anchor : '95%'
		,text : '删除'
	});
	obj.ItemCatFPanel = new Ext.form.FormPanel({
		id : 'ItemCatFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 40
		,region : 'south'
		,frame : true
		//,title : '关联项目大类维护'
		,height : 100
		,items:[
			obj.ItemCatPanel
		]
		,buttons:[
			obj.btnSave
			,obj.btnDelete
		]
	});
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.vGridPanel
			,obj.ItemCatFPanel
		]
	});
	obj.vGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseLinkItemSrv';
			param.QueryName = 'QryItemCat';
			param.ArgCnt = 0;
	});
	obj.vGridPanelStore.load({params : {start:0,limit:20}});
	
	InitViewportEvent(obj);
	obj.LoadEvent();
	return obj;
}