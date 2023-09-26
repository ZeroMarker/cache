function InitViewscreen(){
	var obj = new Object();
/*
	obj.DicCode = new Ext.form.TextField({
		id : 'DicCode'
		,fieldLabel : '字典代码'
		,anchor : '95%'
});
	obj.DicName = new Ext.form.TextField({
		id : 'DicName'
		,fieldLabel : '字典名称'
		,anchor : '95%'
});

	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,columnWidth :0.3
		,layout : 'form'
		,items:[			
		]
	});

	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,columnWidth :0.4
		,layout : 'form'
		,items:[
			obj.DicCode,
			obj.DicName
		]
	});
		obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,columnWidth :0.3
		,layout : 'form'
		,items:[
		]
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '查询'
});*/
	obj.btnNew = new Ext.Toolbar.Button({  //new Ext.Button({
		id : 'btnNew'
		,iconCls : 'icon-new'
	//	,anchor : '95%'
		,text : '新建'
});
	obj.btnEdit = new Ext.Toolbar.Button({ //new Ext.Button({
		id : 'btnEdit'
		,iconCls : 'icon-pencil'
		//,anchor : '95%'
		,text : '编辑'
});
/*
	obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,title : '字典维护'
		,layout : 'column'
		,labelWidth : 60
		,frame : true
		,height : 130
		,region : 'north'
		,items:[
			obj.Panel1,
			obj.Panel2,
			obj.Panel3
		]
		,buttons:[
			obj.btnQuery
			,obj.btnNew
			,obj.btnEdit
		]
	});*/
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
		[ //ID,DicCode,DicName,ClassName,QueryName,Fields,FormalSpec
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicName', mapping: 'DicName'}
			,{name: 'ClassName', mapping: 'ClassName'}
			,{name: 'QueryName', mapping: 'QueryName'}
			,{name: 'Fields', mapping: 'Fields'}
			,{name: 'FormalSpec', mapping: 'FormalSpec'}			
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
			,{header: '字典代码', width: 100, dataIndex: 'DicCode', sortable: true}
			,{header: '字典名称', width: 250, dataIndex: 'DicName', sortable: true}
			,{header: '类名称', width: 250, dataIndex: 'ClassName', sortable: true}
			,{header: 'Query名称', width: 250, dataIndex: 'QueryName', sortable: true}
			,{header: '字段列表', width: 100, dataIndex: 'Fields', sortable: true}
			,{header: '参数说明', width: 100, dataIndex: 'FormalSpec', sortable: true}
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
			param.ClassName = 'DHCMed.CR.BO.Dictionary';
			param.QueryName = 'QueryAllDic';
			param.Arg1 = '';   //obj.DicCode.getValue();
			param.Arg2 = '';  //obj.DicName.getValue();
			param.ArgCnt = 2;
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

	obj.txtDicID = new Ext.form.TextField({
		id : 'txtDicID'
		,hidden:true
});
	obj.txtDicCode = new Ext.form.TextField({
		id : 'txtDicCode'
		,fieldLabel : '字典代码'
		,anchor : '95%'
});
	obj.txtDicName = new Ext.form.TextField({
		id : 'txtDicName'
		,fieldLabel : '字典名称'
		,anchor : '95%'
});	
	obj.txtClassName = new Ext.form.TextField({
		id : 'txtClassName'
		,fieldLabel : '类名称'
		,anchor : '95%'
});
/*	obj.txtQueryName = new Ext.form.TextField({
		id : 'txtQueryName'
		,fieldLabel : 'Query名称'
		,anchor : '95%'
});*/
	obj.txtQueryNameStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.txtQueryNameStore = new Ext.data.Store({
		proxy: obj.txtQueryNameStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'Name', mapping: 'Name'}
		])
	});
	obj.txtQueryName = new Ext.form.ComboBox({
		id : 'txtQueryName'
		,store : obj.txtQueryNameStore
		,minChars : 1
		,displayField : 'Name'
		,fieldLabel : 'Query名称'
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'ID'
});
	obj.txtFields = new Ext.form.TextField({
		id : 'txtFields'
		,fieldLabel : '字段列表'
		,anchor : '95%'
});
	obj.txtFormalSpec = new Ext.form.TextField({
		id : 'txtFormalSpec'
		,fieldLabel : '参数说明'
		,anchor : '95%'
});
	obj.winfBtnGet = new Ext.Button({
			id : 'winfBtnGet'
			,iconCls : 'icon-find'
			,text : '获取字段及参数' //Query字段及参数
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
		,height : 280
		,items:[
		//	obj.Panel4
			obj.txtDicID
			,obj.txtDicCode
			,obj.txtDicName
			,obj.txtClassName
			,obj.txtQueryName
			,obj.txtFields
			,obj.txtFormalSpec
		]
		,buttons:[
			obj.winfBtnGet,
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
	
	obj.txtQueryNameStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CR.BO.Dictionary';
			param.QueryName = 'GetAllQuerys';
			param.Arg1 = obj.txtClassName.getValue();
			param.ArgCnt = 1;
	});
	obj.txtQueryNameStore.load();
	
	InitwinScreenEvent(obj);
	//事件处理代码
	obj.winfBtnSave.on("click", obj.winfBtnSave_click, obj);
	obj.winfPBtnCancle.on("click", obj.winfPBtnCancle_click, obj);
	obj.winfBtnGet.on("click", obj.winfBtnGet_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}