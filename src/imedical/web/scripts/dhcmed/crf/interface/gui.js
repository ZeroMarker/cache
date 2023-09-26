function InitViewscreen(){
	var obj = new Object();


	obj.btnNew = new Ext.Toolbar.Button({
		id : 'btnNew'
		,iconCls : 'icon-new'
		,text : '新建'
});
	obj.btnEdit = new Ext.Toolbar.Button({
		id : 'btnEdit'
		,iconCls : 'icon-pencil'
		,text : '编辑'
});

	obj.gridListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gridListStore = new Ext.data.Store({
		proxy: obj.gridListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[ 
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'CategoryName', mapping: 'CategoryName'}
			,{name: 'InterfaceCode', mapping: 'InterfaceCode'}
			,{name: 'InterfaceName', mapping: 'InterfaceName'}
			,{name: 'Arguments', mapping: 'Arguments'}
			,{name: 'ClassMethod', mapping: 'ClassMethod'}
			,{name: 'ReturnType', mapping: 'ReturnType'}			
		])
	});
	obj.gridListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridList = new Ext.grid.GridPanel({
		id : 'gridList'
		,buttonAlign : 'center'
		,store : obj.gridListStore
		,loadMask : true
		,region : 'center'
		,viewConfig: {forceFit: true}
		,columns: [ 
			new Ext.grid.RowNumberer()
			,{header: '接口类别', width: 100, dataIndex: 'CategoryName', sortable: true}
			,{header: '接口代码', width: 100, dataIndex: 'InterfaceCode', sortable: true}
			,{header: '接口名称', width: 150, dataIndex: 'InterfaceName', sortable: true}
			,{header: '参数列表', width: 250, dataIndex: 'Arguments', sortable: true}
			,{header: '接口类方法', width: 200, dataIndex: 'ClassMethod', sortable: true}
			,{header: '返回对象类型', width: 200, dataIndex: 'ReturnType', sortable: true}
		]		
		,tbar:[obj.btnNew,obj.btnEdit]
});
	obj.Viewscreen = new Ext.Viewport({
		id : 'Viewscreen'
		,layout : 'border'
		,items:[
			//obj.fPanel,
			obj.gridList
		]
	});
	
	obj.gridListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CR.BO.InterService';
			param.QueryName = 'QueryAllInterfaces';
			param.ArgCnt = 0;
	});
	obj.gridListStore.load();

	InitViewscreenEvent(obj);
	//事件处理代码
	//obj.btnQuery.on("click", obj.btnQuery_click, obj);
	obj.btnNew.on("click", obj.btnNew_click, obj);
	obj.btnEdit.on("click", obj.btnEdit_click, obj);
	obj.gridList.on("rowdblclick", obj.gridList_rowdblclick, obj);
	//obj.gridList.on("rowclick", obj.gridList_rowclick, obj);
  obj.LoadEvent(arguments);
  return obj;
}


function InitwinScreen(){
	var obj = new Object();

	obj.txtInterfaceID = new Ext.form.TextField({
		id : 'txtInterfaceID'
		,hidden:true
	});
	obj.categoryStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.categoryStore = new Ext.data.Store({
		proxy: obj.categoryStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'myid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'myid', mapping: 'myid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
		])
	});		
	obj.txtCategory = new Ext.form.ComboBox({
				fieldLabel: '接口类别',
				name: 'txtCategory',
				//typeAhead: true,
				//minChars : 1,
				triggerAction: 'all',
				//mode: 'local',
				store: obj.categoryStore,
				valueField: 'Code',
				displayField: 'Description',
				anchor : '95%',
				//value:Business,
				allowBlank:false
		});
			obj.categoryStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.DictionarySrv';
			param.QueryName = 'QryDictionary';
			param.Arg1 = 'CRFInterfaceCate';
			param.ArgCnt = 1;
	});
	obj.categoryStore.load({});

	obj.txtInterfaceCode = new Ext.form.TextField({
		id : 'txtInterfaceCode'
		,fieldLabel : '接口代码'
		,anchor : '95%'
});
	obj.txtInterfaceName = new Ext.form.TextField({
		id : 'txtInterfaceName'
		,fieldLabel : '接口名称'
		,anchor : '95%'
});	
	obj.txtArguments = new Ext.form.TextField({
		id : 'txtArguments'
		,fieldLabel : '参数列表'
		,anchor : '95%'
});
	obj.txtClassName = new Ext.form.TextField({
		id : 'txtClassName'
		,fieldLabel : '接口类方法'
		,anchor : '95%'
});
	obj.txtReturnType = new Ext.form.TextField({
		id : 'txtReturnType'
		,fieldLabel : '返回对象类型'
		,anchor : '95%'
});

	obj.winfBtnSave = new Ext.Button({
		id : 'winfBtnSave'
		,iconCls : 'icon-save'
		,text : '保存'
});
	obj.winfPBtnCancle = new Ext.Button({
		id : 'winfPBtnCancle'
		,iconCls : 'icon-undo'
		,text : '取消'
});

	obj.winfPanel = new Ext.form.FormPanel({
		id : 'winfPanel'
		,buttonAlign : 'center'
		,labelWidth : 80
		,region : 'center'
		,layout : 'form'
		,frame : true
		,height : 280
		,items:[
		//	obj.Panel4
			obj.txtInterfaceID
			,obj.txtCategory
			,obj.txtInterfaceCode
			,obj.txtInterfaceName
			,obj.txtArguments
			,obj.txtClassName
			,obj.txtReturnType			
		]
		,buttons:[
			obj.winfBtnSave
			,obj.winfPBtnCancle
		]
	});
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 320
		,buttonAlign : 'center'
		,width : 400
		,modal : true
		,title : '编辑'
		,items:[
			obj.winfPanel
		]
	});
	InitwinScreenEvent(obj);
	//事件处理代码
	obj.winfBtnSave.on("click", obj.winfBtnSave_click, obj);
	obj.winfPBtnCancle.on("click", obj.winfPBtnCancle_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}