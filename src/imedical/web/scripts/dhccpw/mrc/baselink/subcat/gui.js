function InitViewport(CategID){
	var obj = new Object();
	obj.CategID=CategID;
	obj.CurrISCRowid="";
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
	obj.ISCCode = new Ext.form.TextField({
		id : 'ISCCode'
		,fieldLabel : '代码'
		,labelSeparator :''
		,anchor : '95%'
	});
	obj.ISCDesc = new Ext.form.TextField({
		id : 'ISCDesc'
		,fieldLabel : '描述'
		,labelSeparator :''
		,anchor : '95%'
	});
	obj.leftItemSubCatPanel = new Ext.Panel({
		id : 'leftItemSubCatPanel'
		,buttonAlign : 'center'
		,columnWidth : .25
		,height : 1
		,items:[]
	});
	obj.centerItemSubCatPanel = new Ext.Panel({
		id : 'centerItemSubCatPanel'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.ISCCode
			,obj.ISCDesc
		]
	});
	obj.rightItemSubCatPanel = new Ext.Panel({
		id : 'rightItemSubCatPanel'
		,buttonAlign : 'center'
		,columnWidth : .25
		,items:[]
	});
	obj.ItemSubCatPanel = new Ext.Panel({
		id : 'ItemSubCatPanel'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
			obj.leftItemSubCatPanel
			,obj.centerItemSubCatPanel
			,obj.rightItemSubCatPanel
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
	obj.ItemSubCatFPanel = new Ext.form.FormPanel({
		id : 'ItemSubCatFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 40
		,region : 'south'
		,frame : true
		//,title : '关联项目子类维护'
		,height : 100
		,items:[
			obj.ItemSubCatPanel
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
			,obj.ItemSubCatFPanel
		]
	});
	obj.vGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseLinkItemSrv';
			param.QueryName = 'QryItemSubCat';
			param.Arg1 = obj.CategID;
			param.ArgCnt = 1;
	});
	obj.vGridPanelStore.load({params : {start:0,limit:20}});
	
	InitViewportEvent(obj);
	obj.LoadEvent();
	return obj;
}

