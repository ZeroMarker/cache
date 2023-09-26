function InitviewScreen(){
	var obj = new Object();

	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.gridResultStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.gridResultStore = new Ext.data.Store({
		proxy: obj.gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'RowID', mapping: 'RowID'}
			,{name: '代码', mapping: '代码'}
			,{name: '描述', mapping: '描述'}
			,{name: '医院', mapping: '医院'}
			,{name: '产品', mapping: '产品'}
			,{name: '备注', mapping: '备注'}
			,{name: '类别', mapping: '类别'}
		])
	});
	obj.gridResultCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridResult = new Ext.grid.GridPanel({
		id : 'gridResult'
		,store : obj.gridResultStore
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 100, dataIndex: '代码', sortable: true}
			,{header: '描述', width: 200, dataIndex: '描述', sortable: true}
			,{header: '类别', width: 200, dataIndex: '类别', sortable: true}
			,{header: '医院', width: 100, dataIndex: '医院', sortable: true}
			,{header: '产品', width: 150, dataIndex: '产品', sortable: true}
			,{header: '备注', width: 100, dataIndex: '备注', sortable: true}
		]});
	obj.txtCode = new Ext.form.TextField({
		id : 'txtCode'
		,width : 200
		,fieldLabel : '代码'
		,labelSeparator :''
});

	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.cboHospitalStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboHospitalStore = new Ext.data.Store({
		proxy: obj.cboHospitalStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'hosName', mapping: 'hosName'}
		])
	});
	obj.cboHospital = new Ext.form.ComboBox({
		id : 'cboHospital'
		,width : 200
		,store : obj.cboHospitalStore
		,minChars : 1
		,displayField : 'hosName'
		,fieldLabel : '医院'
		,labelSeparator :''
		,valueField : 'rowid'
		,triggerAction : 'all'
});

	obj.txtKind = new Ext.form.TextField({
		id : 'txtKind'
		,width : 200
		,fieldLabel : '类别'
		,labelSeparator :''
});

	obj.pnCol1 = new Ext.Panel({
		id : 'pnCol1'
		,buttonAlign : 'center'
		,columnWidth : 0.4
		,layout : 'form'
		,items:[
			obj.txtCode
			,obj.txtKind
			,obj.cboHospital
		]
	});
	obj.txtDesc = new Ext.form.TextField({
		id : 'txtDesc'
		,width : 200
		,fieldLabel : '描述'
		,labelSeparator :''
});



	obj.txtResume = new Ext.form.TextField({
		id : 'txtResume'
		,width : 200
		,fieldLabel : '备注'
		,labelSeparator :''
});

	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.cboProductStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboProductStore = new Ext.data.Store({
		proxy: obj.cboProductStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'ProName', mapping: 'ProName'}
		])
	});
	obj.cboProduct = new Ext.form.ComboBox({
		id : 'cboProduct'
		,width : 200
		,store : obj.cboProductStore
		,minChars : 1
		,displayField : 'ProName'
		,fieldLabel : '产品'
		,labelSeparator :''
		,valueField : 'ID'
		,triggerAction : 'all'
		,editable:false
});
	obj.pnCol2 = new Ext.Panel({
		id : 'pnCol2'
		,buttonAlign : 'center'
		,columnWidth : 0.4
		,layout : 'form'
		,items:[
			obj.txtDesc
			,obj.cboProduct
			,obj.txtResume
		]
	});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,text : '保存'
		,iconCls : 'icon-save'
	});
	obj.btnEditItems = new Ext.Button({
		id : 'btnEditItems'
		,text : '编辑项目'
		,iconCls : 'icon-edit'
	});
	obj.frmEdit = new Ext.form.FieldSet({
		id : 'frmEdit'
		,height : 180
		,buttonAlign : 'center'
		,region : 'south'
		,title : '报表配置信息'
		,layout : 'column'
		,items:[
			obj.pnCol1
			,obj.pnCol2
		]
	,	buttons:[
			obj.btnSave
			,obj.btnEditItems
		]
	});
	obj.frmScreen = new Ext.form.FormPanel({
		id : 'frmScreen'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,frame : true
		,layout : 'border'
		,items:[
			obj.gridResult
			,obj.frmEdit
		]
	});
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'fit'
		,items:[
			obj.frmScreen
		]
	});
	obj.gridResultStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SS.ReportConfig';
			param.QueryName = 'QryAll';
			param.ArgCnt = 0;
	});
	obj.gridResultStore.load({});
	obj.cboHospitalStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.Base.Hospital';
			param.QueryName = 'QueryHosInfo';
			param.ArgCnt = 0;
	});
	obj.cboProductStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SS.Products';
			param.QueryName = 'QueryAll';
			param.ArgCnt = 0;
	});
	InitviewScreenEvent(obj);
	//事件处理代码
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.btnEditItems.on("click", obj.btnEditItems_click, obj);
	obj.gridResult.on("rowclick", obj.gridResult_rowclick, obj);
  obj.LoadEvent(arguments);
  return obj;
}



function InitwinConfigEdit(HospitalID,ProductCode,Kind,Code,Parref){
	var obj = new Object();
	
	obj.Parref = Parref;

	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.gridConfigItemStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.gridConfigItemStore = new Ext.data.Store({
		proxy: obj.gridConfigItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'RowID', mapping: 'RowID'}
			,{name: '代码', mapping: '代码'}
			,{name: '值1', mapping: '值1'}
			,{name: '值2', mapping: '值2'}
			,{name: 'ParentID', mapping: 'ParentID'}
		])
	});
	obj.gridConfigItemCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridConfigItem = new Ext.grid.EditorGridPanel({
		id : 'gridConfigItem'
		,store : obj.gridConfigItemStore
		,buttonAlign : 'center'
		,columns: [
			{header: 'RowID', width: 100, dataIndex: 'RowID', sortable: true}
			,{header: '代码', width: 100, dataIndex: '代码', sortable: true, editor : new Ext.form.TextField()}
			,{header: '值1', width: 100, dataIndex: '值1', sortable: true, editor : new Ext.form.TextField()}
			,{header: '值2', width: 100, dataIndex: '值2', sortable: true, editor : new Ext.form.TextField()}
		]});
		
	obj.btnDtlAdd = new Ext.Button({
		id : 'btnDtlAdd'
		,text : '添加'
		,iconCls : 'icon-add'
});		
		
	obj.btnDtlDelete = new Ext.Button({
		id : 'btnDtlDelete'
		,text : '删除'
		,iconCls : 'icon-delete'
});		
		
	obj.btnDtlSave = new Ext.Button({
		id : 'btnDtlSave'
		,text : '保存'
		,iconCls : 'icon-save'
	});
	obj.btnDtlCancel = new Ext.Button({
		id : 'btnDtlCancel'
		,text : '取消'
		,iconCls : 'icon-undo'
});
	obj.winConfigEdit = new Ext.Window({
		id : 'winConfigEdit'
		,height : 429
		,buttonAlign : 'center'
		,width : 470
		,modal : true
		,title : '编辑报表配置项目'
		,layout : 'fit'
		,items:[
			obj.gridConfigItem
		]
	,	buttons:[
			obj.btnDtlAdd
			,obj.btnDtlDelete
			,obj.btnDtlSave
			,obj.btnDtlCancel
		]
	});
	obj.gridConfigItemStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SS.ReportConfig';
			param.QueryName = 'QryItems';
			param.Arg1 = HospitalID;
			param.Arg2 = ProductCode;
			param.Arg3 = Kind;
			param.Arg4 = Code;
			param.ArgCnt = 4;
	});
	obj.gridConfigItemStore.load({});
	InitwinConfigEditEvent(obj);
	//事件处理代码
	obj.btnDtlSave.on("click", obj.btnDtlSave_click, obj);
	obj.btnDtlAdd.on("click", obj.btnDtlAdd_click, obj);
	obj.btnDtlDelete.on("click", obj.btnDtlDelete_click, obj);
	obj.btnDtlCancel.on("click", obj.btnDtlCancel_click, obj);
	obj.LoadEvent(arguments);
	return obj;
}

