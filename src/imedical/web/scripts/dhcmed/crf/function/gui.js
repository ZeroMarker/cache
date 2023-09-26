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
			,{name: 'Name', mapping: 'Name'}
			,{name: 'Caption', mapping: 'Caption'}
			,{name: 'Type', mapping: 'Type'}
		//	,{name: 'Data', mapping: 'Data'}
			,{name: 'Description', mapping: 'Description'}		
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
			,{header: '函数名', width: 100, dataIndex: 'Name', sortable: true}
			,{header: '函数描述', width: 150, dataIndex: 'Caption', sortable: true}
			,{header: '函数类型', width: 100, dataIndex: 'Type', sortable: true}
		//	,{header: '函数体', width: 350, dataIndex: 'Data', sortable: true}
			,{header: '函数说明', width: 350, dataIndex: 'Description', sortable: true}
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
			param.ClassName = 'DHCMed.CR.BO.FunctionService';
			param.QueryName = 'QueryAllFunctions';
			param.ArgCnt = 0;
	});
	obj.gridListStore.load();

	InitViewscreenEvent(obj);
	//事件处理代码
//	obj.btnQuery.on("click", obj.btnQuery_click, obj);
	obj.btnNew.on("click", obj.btnNew_click, obj);
	obj.btnEdit.on("click", obj.btnEdit_click, obj);
	obj.gridList.on("rowdblclick", obj.gridList_rowdblclick, obj);
	//obj.gridList.on("rowclick", obj.gridList_rowclick, obj);
  obj.LoadEvent(arguments);
  return obj;
}


function InitwinScreen(){
	var obj = new Object();

	obj.txtFunctionID = new Ext.form.TextField({
		id : 'txtFunctionID'
		,hidden:true
});
	obj.txtFunctionName = new Ext.form.TextField({
		id : 'txtFunctionName'
		,fieldLabel : '函数名'
		,anchor : '95%'
});	
	obj.txtCaption = new Ext.form.TextField({
		id : 'txtCaption'
		,fieldLabel : '函数描述'
		,anchor : '95%'
});
	obj.txtType = new Ext.form.TextField({
		id : 'txtType'
		,fieldLabel : '函数类型'		
		,anchor : '95%'
});
	obj.txtData = new Ext.form.TextArea({
		id : 'txtData'
		,fieldLabel : '函数体'
		,height:150
		,anchor : '95%'
});
obj.txtDescription= new Ext.form.TextArea({
		id : 'txtDescription'
		,fieldLabel : '函数说明'
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
		,labelWidth : 70
		,region : 'center'
		,layout : 'form'
		,frame : true
		,height : 420
		,items:[
		//	obj.Panel4
			obj.txtFunctionID,
			obj.txtFunctionName ,
			obj.txtCaption,
			obj.txtType ,
			obj.txtData,
			obj.txtDescription 		
		]
		,buttons:[
			obj.winfBtnSave
			,obj.winfPBtnCancle
		]
	});
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 450
		,buttonAlign : 'center'
		,width : 600
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