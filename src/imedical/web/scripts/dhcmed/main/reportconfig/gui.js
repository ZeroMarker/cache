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
			,{name: '����', mapping: '����'}
			,{name: '����', mapping: '����'}
			,{name: 'ҽԺ', mapping: 'ҽԺ'}
			,{name: '��Ʒ', mapping: '��Ʒ'}
			,{name: '��ע', mapping: '��ע'}
			,{name: '���', mapping: '���'}
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
			,{header: '����', width: 100, dataIndex: '����', sortable: true}
			,{header: '����', width: 200, dataIndex: '����', sortable: true}
			,{header: '���', width: 200, dataIndex: '���', sortable: true}
			,{header: 'ҽԺ', width: 100, dataIndex: 'ҽԺ', sortable: true}
			,{header: '��Ʒ', width: 150, dataIndex: '��Ʒ', sortable: true}
			,{header: '��ע', width: 100, dataIndex: '��ע', sortable: true}
		]});
	obj.txtCode = new Ext.form.TextField({
		id : 'txtCode'
		,width : 200
		,fieldLabel : '����'
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
		,fieldLabel : 'ҽԺ'
		,labelSeparator :''
		,valueField : 'rowid'
		,triggerAction : 'all'
});

	obj.txtKind = new Ext.form.TextField({
		id : 'txtKind'
		,width : 200
		,fieldLabel : '���'
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
		,fieldLabel : '����'
		,labelSeparator :''
});



	obj.txtResume = new Ext.form.TextField({
		id : 'txtResume'
		,width : 200
		,fieldLabel : '��ע'
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
		,fieldLabel : '��Ʒ'
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
		,text : '����'
		,iconCls : 'icon-save'
	});
	obj.btnEditItems = new Ext.Button({
		id : 'btnEditItems'
		,text : '�༭��Ŀ'
		,iconCls : 'icon-edit'
	});
	obj.frmEdit = new Ext.form.FieldSet({
		id : 'frmEdit'
		,height : 180
		,buttonAlign : 'center'
		,region : 'south'
		,title : '����������Ϣ'
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
	//�¼��������
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
			,{name: '����', mapping: '����'}
			,{name: 'ֵ1', mapping: 'ֵ1'}
			,{name: 'ֵ2', mapping: 'ֵ2'}
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
			,{header: '����', width: 100, dataIndex: '����', sortable: true, editor : new Ext.form.TextField()}
			,{header: 'ֵ1', width: 100, dataIndex: 'ֵ1', sortable: true, editor : new Ext.form.TextField()}
			,{header: 'ֵ2', width: 100, dataIndex: 'ֵ2', sortable: true, editor : new Ext.form.TextField()}
		]});
		
	obj.btnDtlAdd = new Ext.Button({
		id : 'btnDtlAdd'
		,text : '���'
		,iconCls : 'icon-add'
});		
		
	obj.btnDtlDelete = new Ext.Button({
		id : 'btnDtlDelete'
		,text : 'ɾ��'
		,iconCls : 'icon-delete'
});		
		
	obj.btnDtlSave = new Ext.Button({
		id : 'btnDtlSave'
		,text : '����'
		,iconCls : 'icon-save'
	});
	obj.btnDtlCancel = new Ext.Button({
		id : 'btnDtlCancel'
		,text : 'ȡ��'
		,iconCls : 'icon-undo'
});
	obj.winConfigEdit = new Ext.Window({
		id : 'winConfigEdit'
		,height : 429
		,buttonAlign : 'center'
		,width : 470
		,modal : true
		,title : '�༭����������Ŀ'
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
	//�¼��������
	obj.btnDtlSave.on("click", obj.btnDtlSave_click, obj);
	obj.btnDtlAdd.on("click", obj.btnDtlAdd_click, obj);
	obj.btnDtlDelete.on("click", obj.btnDtlDelete_click, obj);
	obj.btnDtlCancel.on("click", obj.btnDtlCancel_click, obj);
	obj.LoadEvent(arguments);
	return obj;
}

