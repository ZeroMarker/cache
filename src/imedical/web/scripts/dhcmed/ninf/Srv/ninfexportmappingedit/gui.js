function InitviewScreen(){
	var obj = new Object();
	
	
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.cboCategoryStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboCategoryStore = new Ext.data.Store({
		proxy: obj.cboCategoryStoreProxy,
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
			,{name: 'Type', mapping: 'Type'}
			,{name: 'Active', mapping: 'Active'}
			,{name: 'HispsDescs', mapping: 'HispsDescs'}
			,{name: 'DateFrom', mapping: 'DateFrom'}
			,{name: 'DateTo', mapping: 'DateTo'}
			,{name: 'HospDr', mapping: 'HospDr'}
		])
	});
	obj.cboCategory = new Ext.form.ComboBox({
		id : 'cboCategory'
		,store : obj.cboCategoryStore
		,minChars : 1
		,displayField : 'Description'
		,fieldLabel : '请选择对照类别'
		,valueField : 'Code'
		,editable : false
		,triggerAction : 'all'
});


	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.cboMinkeDicStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboMinkeDicStore = new Ext.data.Store({
		proxy: obj.cboMinkeDicStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'MappingCode'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboMinkeDic = new Ext.form.ComboBox({
		id : 'cboMinkeDic'
		,width : 100
		,store : obj.cboMinkeDicStore
		,minChars : 1
		,displayField : 'Desc'
		,fieldLabel : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'Code'
		,listWidth : 300
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,text : '删除'
	});
	
	var objTBar = new Ext.Toolbar({
    items: [
    		new Ext.form.Label({text : '请选择对照信息类别'}),
        obj.cboCategory,
        obj.btnDelete
    ]
 	});
	
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
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'Category', mapping: 'Category'}
			,{name: 'SrcObjectID', mapping: 'SrcObjectID'}
			,{name: 'SrcDescription', mapping: 'SrcDescription'}
			,{name: 'Target', mapping: 'Target'}
			,{name: 'TargetDesc', mapping: 'TargetDesc'}
			,{name: 'ResumeText', mapping: 'ResumeText'}
		])
	});
	obj.gridResultCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridResult = new Ext.grid.EditorGridPanel({
		id : 'gridResult'
		,store : obj.gridResultStore
		,buttonAlign : 'center'
		,region : 'center'
		, tbar : objTBar
		,columns: [
			new Ext.grid.RowNumberer()
			//,{header: '类别', width: 100, dataIndex: 'Category', sortable: true}
			,{header: '源数据', width: 150, dataIndex: 'SrcObjectID', sortable: true}
			,{header: '源数据描述', width: 150, dataIndex: 'SrcDescription', sortable: true}
			,{header: '对照', width: 200, dataIndex: 'Target', sortable: true, editor : obj.cboMinkeDic}
			,{header: '对照描述', width: 200, dataIndex: 'TargetDesc', sortable: true}
			,{header: '备注', width: 100, dataIndex: 'ResumeText', sortable: true, editor : new Ext.form.TextField({})}
		]});




	
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items:[
			obj.gridResult
		]
	});
	obj.gridResultStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINF.Rep.ExportDataMap';
			param.QueryName = 'QryByCategory';
			param.Arg1 = obj.cboCategory.getValue();
			param.ArgCnt = 1;
	});
	obj.cboCategoryStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.DictionarySrv';
			param.QueryName = 'QrySSDictionary';
			param.Arg1 = 'INFMinkeMappingType';
			param.ArgCnt = 1;
	});
	obj.cboMinkeDicStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINF.Dic.MinkeDictionary';
			param.QueryName = 'QryByCodeOrSpell';
			param.Arg1 = obj.MainCode;
			param.Arg2 = obj.cboMinkeDic.getRawValue();
			param.ArgCnt = 2;
	});		
	obj.cboCategoryStore.load({});
	InitviewScreenEvent(obj);
	//事件处理代码
  obj.LoadEvent(arguments);
  return obj;
}

