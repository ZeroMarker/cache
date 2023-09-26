function InitViewport1(){
	var obj = new Object();
	
	obj.txtMenuCode = new Ext.form.TextField({
		id : 'txtMenuCode'
		,fieldLabel : '菜单代码'
		,anchor : '95%'
	});
	obj.txtMenuName = new Ext.form.TextField({
		id : 'txtMenuName'
		,fieldLabel : '菜单名称'
		,anchor : '95%'
	});
	obj.txtMenuCaptionStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.txtMenuCaptionStore = new Ext.data.Store({
		proxy: obj.txtMenuCaptionStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'MenuCode', mapping: 'MenuCode'}
			,{name: 'MenuCaption', mapping: 'MenuCaption'}
		])
	});
	obj.txtMenuCaption = new Ext.form.ComboBox({
		id : 'txtMenuCaption'
		,store : obj.txtMenuCaptionStore
		//,minChars : 0
		,displayField : 'MenuCaption'
		,fieldLabel : '父菜单'
		,valueField : 'rowid'
		,triggerAction : 'all'
		,anchor : '95%'
});
	obj.txtProNameStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.txtProNameStore = new Ext.data.Store({
		proxy: obj.txtProNameStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'ProName', mapping: 'ProName'}
		])
	});
	obj.txtProName = new Ext.form.ComboBox({
		id : 'txtProName'
		,store : obj.txtProNameStore
		,minChars : 1
		,displayField : 'ProName'
		,fieldLabel : '所属产品'
		,valueField : 'rowid'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.gListRowid = new Ext.form.TextField({
		id : 'gListRowid'
		,hidden : true
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '查询'
	});
	obj.btnNew = new Ext.Button({
		id : 'btnNew'
		,iconCls : 'icon-new'
		,anchor : '95%'
		,text : '新建'
	});
	obj.btnEdit = new Ext.Button({
		id : 'btnEdit'
		,iconCls : 'icon-pencil'
		,anchor : '95%'
		,text : '编辑'
});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,anchor : '95%'
		,text : '删除'
	});
	
	obj.gridListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gridListStore = new Ext.data.Store({
		proxy: obj.gridListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'MenuCode', mapping: 'MenuCode'}
			,{name: 'MenuCaption', mapping: 'MenuCaption'}
			,{name: 'Product', mapping: 'Product'}
			,{name: 'ParentMenu', mapping: 'ParentMenu'}
			,{name: 'LinkUrl', mapping: 'LinkUrl'}
			,{name: 'Expression', mapping: 'Expression'}
			,{name: 'ProductDr', mapping: 'ProductDr'}
			,{name: 'ShowIndex', mapping: 'ShowIndex'}
			,{name: 'IconClass', mapping: 'IconClass'}
			,{name: 'ParentMenuDr', mapping: 'ParentMenuDr'}
		])
	});
	obj.gridListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridList = new Ext.grid.GridPanel({
		id : 'gridList'
		,buttonAlign : 'center'
		,store : obj.gridListStore
		,loadMask : true
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 100, dataIndex: 'MenuCode', sortable: true}
			,{header: '名称', width: 250, dataIndex: 'MenuCaption', sortable: true}
			,{header: '所属产品', width: 250, dataIndex: 'Product', sortable: true}
			,{header: '父菜单', width: 250, dataIndex: 'ParentMenu', sortable: true}
			,{header: '显示顺序', width: 100, dataIndex: 'ShowIndex', sortable: true}
			,{header: '图标', width: 100, dataIndex: 'IconClass', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 15,
			store : obj.gridListStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})

	});
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			{	
				layout : 'form'
				,region : 'north'
				,buttonAlign : 'center'
				,height : 75
				,frame : true
				,items :[
					{
						layout : 'column'
						,items : [
							{
								columnWidth:.25
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.txtMenuCode]
							},{
								columnWidth:.25
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.txtMenuName]
							},{
								columnWidth:.25
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.txtProName]
							},{
								columnWidth:.25
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.txtMenuCaption]
							},{
								columnWidth:0
								,layout : 'form'
								,labelAlign : 'right'
								,items: [obj.gListRowid]
							}
						]
					}
				]
				,buttons:[
					obj.btnQuery
					,obj.btnNew
					,obj.btnEdit
					,obj.btnDelete
				]
			}
			,obj.gridList
		]
	});

	obj.txtProNameStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.ProductsSrv';
			param.QueryName = 'QueryProInfo';
			param.Arg1 = obj.txtProName.getRawValue();
			param.ArgCnt = 1;
	});
	obj.txtProNameStore.load({});
	
	obj.txtMenuCaptionStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.MenusSrv';
			param.QueryName = 'FindMenuInfoFromCaption';
			param.Arg1 = obj.txtProName.getValue();
			param.Arg2 = obj.txtMenuCaption.getRawValue();
			param.ArgCnt = 2;
	});
	
	obj.gridListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.MenusSrv';
			param.QueryName = 'FindMenuInfo';
			param.Arg1 = obj.txtMenuCode.getValue();
			param.Arg2 = obj.txtMenuCaption.getValue();
			param.Arg3 = obj.txtProName.getValue();
			param.Arg4 = obj.txtMenuName.getValue();
			param.ArgCnt = 4;
	});
	obj.gridListStore.load({
	params : {
		start:0
		,limit:15
	}});

	InitViewport1Event(obj);
	//事件处理代码
	obj.btnQuery.on("click", obj.btnQuery_click, obj);
	obj.btnNew.on("click", obj.btnNew_click, obj);
	obj.btnEdit.on("click", obj.btnEdit_click, obj);
	obj.btnDelete.on("click", obj.btnDelete_click, obj);
	obj.txtMenuCaption.on("expand",obj.txtMenuCaption_click,obj);
	obj.gridList.on("rowdblclick", obj.gridList_rowdblclick, obj);
	obj.gridList.on("rowclick", obj.gridList_rowclick, obj);
  obj.LoadEvent(arguments);
  return obj;
}
function InitwinScreen(){
	var obj = new Object();
	obj.winfPMenuCode = new Ext.form.TextField({
		id : 'winfPMenuCode'
		,allowBlank : false
		,fieldLabel : '菜单代码'
		,anchor : '100%'
	});
	obj.winfPLinkUrl = new Ext.form.TextField({
		id : 'winfPLinkUrl'
		,fieldLabel : '目标地址'
		,anchor : '100%'
	});
	obj.winfPIconClass = new Ext.form.TextField({
		id : 'winfPIconClass'
		,fieldLabel : '图标'
		,anchor : '100%'
	});
	obj.winfPProductDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.winfPProductDrStore = new Ext.data.Store({
		proxy: obj.winfPProductDrStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'ProName', mapping: 'ProName'}
		])
	});
	obj.winfPProductDr = new Ext.form.ComboBox({
		id : 'winfPProductDr'
		,store : obj.winfPProductDrStore
		,minChars : 1
		,displayField : 'ProName'
		,fieldLabel : '所属产品'
		,editable : true
		,triggerAction : 'all'
		,anchor : '100%'
		,valueField : 'rowid'
	});
	obj.MenuID = new Ext.form.TextField({
		id : 'MenuID'
		,hidden : true
	});
	obj.winTPanel2 = new Ext.Panel({
		id : 'winTPanel2'
		,buttonAlign : 'center'
		,columnWidth : .45
		,layout : 'form'
		,items:[
			obj.winfPMenuCode
			,obj.winfPLinkUrl
			,obj.winfPIconClass
			,obj.winfPProductDr
			,obj.MenuID
		]
	});
	obj.winfPMenuCaption = new Ext.form.TextField({
		id : 'winfPMenuCaption'
		,fieldLabel : '菜单名称'
		,anchor : '100%'
});
	obj.winfPExpression = new Ext.form.TextField({
		id : 'winfPExpression'
		,fieldLabel : '表达式'
		,anchor : '100%'
});
	obj.winfPShowIndex = new Ext.form.TextField({
		id : 'winfPShowIndex'
		,fieldLabel : '显示顺序'
		,anchor : '100%'
});
	obj.winfPParentMenuDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.winfPParentMenuDrStore = new Ext.data.Store({
		proxy: obj.winfPParentMenuDrStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'MenuCode', mapping: 'MenuCode'}
			,{name: 'MenuCaption', mapping: 'MenuCaption'}
		])
	});
	obj.winfPParentMenuDr = new Ext.form.ComboBox({
		id : 'winfPParentMenuDr'
		,store : obj.winfPParentMenuDrStore
		,minChars : 0
		,displayField : 'MenuCaption'
		,fieldLabel : '父菜单'
		,editable : true
		,triggerAction : 'all'
		,anchor : '100%'
		,valueField : 'rowid'
});
	obj.winTPanel3 = new Ext.Panel({
		id : 'winTPanel3'
		,buttonAlign : 'center'
		,columnWidth : .45
		,layout : 'form'
		,items:[
			obj.winfPMenuCaption
			,obj.winfPExpression
			,obj.winfPShowIndex
			,obj.winfPParentMenuDr
		]
	});
	obj.winfPSave = new Ext.Button({
		id : 'winfPSave'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '保存'
});
	obj.winfPCancel = new Ext.Button({
		id : 'winfPCancel'
		,iconCls : 'icon-cancel'
		,anchor : '95%'
		,text : '关闭'
});
	obj.winFPanelTop = new Ext.form.FormPanel({
		id : 'winFPanelTop'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 180
		,region : 'north'
		,layout : 'column'
		,frame : true
		,items:[
			obj.winTPanel2
			,obj.winTPanel3
		]
	,	buttons:[
			obj.winfPSave
			,obj.winfPCancel
		]
	});
	obj.winfGPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.winfGPanelStore = new Ext.data.Store({
		proxy: obj.winfGPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'OperaCode', mapping: 'OperaCode'}
			,{name: 'OperaName', mapping: 'OperaName'}
			,{name: 'LinkUrl', mapping: 'LinkUrl'}
		])
	});
	obj.winfGPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.winfGPanel = new Ext.grid.GridPanel({
		id : 'winfGPanel'
		,store : obj.winfGPanelStore
		,region : 'center'
		,title : '菜单操作'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '操作代码', width: 280, dataIndex: 'OperaCode', sortable: true}
			,{header: '操作名称', width: 279, dataIndex: 'OperaName', sortable: true}
		]});
	obj.cMenuOperID = new Ext.form.TextField({
		id : 'cMenuOperID'
		,hidden : true
	});
	obj.Panel31 = new Ext.Panel({
		id : 'Panel31'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
			obj.cMenuOperID
		]
	});
	obj.winfPPPOpeCode = new Ext.form.TextField({
		id : 'winfPPPOpeCode'
		,fieldLabel : '操作代码'
		,anchor : '95%'
	});
	obj.Panel32 = new Ext.Panel({
		id : 'Panel32'
		,buttonAlign : 'center'
		,columnWidth : .45
		,layout : 'form'
		,items:[
			obj.winfPPPOpeCode
		]
	});
	obj.winfPPPOpeName = new Ext.form.TextField({
		id : 'winfPPPOpeName'
		,fieldLabel : '操作名称'
		,anchor : '95%'
});
	obj.Panel33 = new Ext.Panel({
		id : 'Panel33'
		,buttonAlign : 'center'
		,columnWidth : .45
		,layout : 'form'
		,items:[
			obj.winfPPPOpeName
		]
	});
	obj.Panel34 = new Ext.Panel({
		id : 'Panel34'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.winfPPPUpdate = new Ext.Button({
		id : 'winfPPPUpdate'
		,iconCls : 'icon-save'
		,text : '保存'
		,anchor : '95%'
});
	obj.winfPPPDelete = new Ext.Button({
		id : 'winfPPPDelete'
		,iconCls : 'icon-delete'
		,text : '删除'
		,anchor : '95%'
});
	obj.FormPanel30 = new Ext.form.FormPanel({
		id : 'FormPanel30'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 100
		,region : 'south'
		,layout : 'column'
		,frame : true
		,items:[
			obj.Panel31
			,obj.Panel32
			,obj.Panel33
			,obj.Panel34
		]
	,	buttons:[
			obj.winfPPPUpdate
			,obj.winfPPPDelete
		]
	});
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 500
		,buttonAlign : 'center'
		,width : 680
		,modal : true
		,title : '菜单-编辑'
		,layout : 'border'
		,items:[
			obj.winFPanelTop
			,obj.winfGPanel
			,obj.FormPanel30
		]
	});
	obj.winfPProductDrStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.ProductsSrv';
			param.QueryName = 'QueryProInfo';
			param.Arg1 = '';
			param.ArgCnt = 1;
	});
	obj.winfPProductDrStore.load({
	params : {
		start:0
		,limit:20
	}});

	obj.winfPParentMenuDrStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.MenusSrv';
			param.QueryName = 'FindMenuInfoFromCaption';
			param.Arg1 = obj.winfPProductDr.getValue();
			param.ArgCnt = 1;
	});

	obj.winfGPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.MenusSrv';
			param.QueryName = 'FindMenuOperation';
			param.Arg1 = obj.MenuID.getValue();
			param.Arg2 = '';
			param.ArgCnt = 2;
	});
	obj.winfGPanelStore.load({});
	InitwinScreenEvent(obj);
	//事件处理代码
	obj.winfPSave.on("click", obj.winfPSave_click, obj);
	obj.winfPCancel.on("click", obj.winfPCancel_click, obj);
	obj.winfGPanel.on("rowclick", obj.winfGPanel_rowclick, obj);
	obj.winfPPPUpdate.on("click", obj.winfPPPUpdate_click, obj);
	obj.winfPPPDelete.on("click", obj.winfPPPDelete_click, obj);
	obj.winfPParentMenuDr.on("expand",obj.winfPParentMenuDr_click,obj);
  obj.LoadEvent(arguments);
  return obj;
}

