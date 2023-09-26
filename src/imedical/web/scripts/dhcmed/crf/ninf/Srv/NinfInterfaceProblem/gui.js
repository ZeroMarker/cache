function InitwinProblem(ReportIDList, Delimiter){
	var obj = new Object();


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
	



	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.gridProblemStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.gridProblemStore = new Ext.data.Store({
		proxy: obj.gridProblemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Index'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'MappingCode', mapping: 'MappingCode'}
			,{name: 'MappingName', mapping: 'MappingName'}
			,{name: 'SrcCode', mapping: 'SrcCode'}
			,{name: 'SrcDesc', mapping: 'SrcDesc'}
			,{name: 'Target', mapping: 'Target'}
			,{name: 'TargetDesc', mapping: 'TargetDesc'}
			,{name: 'ResumeText', mapping: 'ResumeText'}
			,{name: 'MainCode', mapping: 'MainCode'}
			,{name: 'Index', mapping : 'Index'}
		])
	});
	obj.gridProblemCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridProblem = new Ext.grid.EditorGridPanel({
		id : 'gridProblem'
		,store : obj.gridProblemStore
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '对照类别', width: 100, dataIndex: 'MappingName', sortable: true}
			,{header: '源数据', width: 100, dataIndex: 'SrcCode', sortable: true}
			,{header: '源数据描述', width: 100, dataIndex: 'SrcDesc', sortable: true}
			,{header: '目标数据代码', width: 100, dataIndex: 'Target', sortable: true, editor : obj.cboMinkeDic}
			,{header: '目标数据描述', width: 100, dataIndex: 'TargetDesc', sortable: true}
			,{header: '备注', width: 100, dataIndex: 'ResumeText', sortable: true, editable : true, editor : new Ext.form.TextField({})}
		]});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,tooltip : '保存对照信息后，以后系统会按照此选择来对照数据。'
		,iconCls : 'icon-save'
		,text : '保存对照信息'
});
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,tooltip : '取消所有操作，系统不会修改任何信息。'
		,iconCls : 'icon-cancel'
		,text : '取消操作'
});
	obj.btnSkip = new Ext.Button({
		id : 'btnSkip'
		,tooltip : '如果跳过此步骤，程序会继续执行，但生成的数据仍需要在民科医院感染系统中进行修改！'
		,iconCls : 'icon-delete'
		,text : '跳过此步骤'
});
	obj.winProblem = new Ext.Window({
		id : 'winProblem'
		,height : 400
		,buttonAlign : 'center'
		,width : 700
		,modal : true
		,title : '需要手工对照的问题'
		,layout : 'border'
		,items:[
			obj.gridProblem
		]
	,	buttons:[
			obj.btnSave
			,obj.btnCancel
			,obj.btnSkip
		]
	});
	obj.gridProblemStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINFService.Srv.ExportMinkeSrv';
			param.QueryName = 'QryValidateInfo';
			param.Arg1 = ReportIDList;
			param.Arg2 = Delimiter;
			param.ArgCnt = 2;
	});
	
	obj.cboMinkeDicStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINF.Dic.MinkeDictionary';
			param.QueryName = 'QryByCodeOrSpell';
			param.Arg1 = obj.MainCode;
			param.Arg2 = obj.cboMinkeDic.getRawValue();
			param.ArgCnt = 2;
	});	
	obj.gridProblemStore.load({});
	InitwinProblemEvent(obj);
	//事件处理代码
  obj.LoadEvent(arguments);
  return obj;
}

