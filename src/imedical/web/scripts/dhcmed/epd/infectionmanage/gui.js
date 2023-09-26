function InitviewScreen(){
	var obj = new Object();

	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
		function(conn, response, Options){
		if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
			ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	);
	obj.gridInfectionStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.gridInfectionStore = new Ext.data.Store({
		proxy: obj.gridInfectionStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'RowID', mapping: 'RowID'}
			,{name: 'ICD', mapping: 'ICD'}
			,{name: 'MIFDisease', mapping: 'MIFDisease'}
			,{name: 'MIFKind', mapping: 'MIFKind'}
			,{name: 'MIFRank', mapping: 'MIFRank'}
			,{name: 'MIFAppendix', mapping: 'MIFAppendix'}
			,{name: 'MIFMulti', mapping: 'MIFMulti'}
			,{name: 'MIFDependence', mapping: 'MIFDependence'}
			,{name: 'MIFTimeLimit', mapping: 'MIFTimeLimit'}
			,{name: 'MIFResume', mapping: 'MIFResume'}
			,{name: 'MIFIsActive', mapping: 'MIFIsActive'}
		])
	});
	obj.gridInfectionCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridInfection = new Ext.grid.GridPanel({
		id : 'gridInfection'
		,store : obj.gridInfectionStore
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'ICD', width: 60, dataIndex: 'ICD', sortable: true}
			,{header: '疾病名称', width: 150, dataIndex: 'MIFDisease', sortable: true}
			,{header: '类别', width: 150, dataIndex: 'MIFKind', sortable: true}
			,{header: '等级', width: 100, dataIndex: 'MIFRank', sortable: true}
			,{header: '传染病附卡', width: 100, dataIndex: 'MIFAppendix', sortable: true}
			,{header: '多次<br>患病', width: 40, dataIndex: 'MIFMulti', sortable: true}
			,{header: '上报<br>时限', width: 40, dataIndex: 'MIFTimeLimit', sortable: false}
			,{header: '是否<br>有效', width: 40, dataIndex: 'MIFIsActive', sortable: true}
			,{header: '备注', width: 100, dataIndex: 'MIFResume', sortable: true}
		]
		,iconCls: 'icon-grid'
		,viewConfig : {
			forceFit : true
		}
	});
	obj.txtICD = new Ext.form.TextField({
		id : 'txtICD'
		,width : 100
		,fieldLabel : 'ICD'
		,anchor : '99%'
	});

	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.cboKindStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboKindStore = new Ext.data.Store({
		proxy: obj.cboKindStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Code'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
		])
	});
	obj.cboKind = new Ext.form.ComboBox({
		id : 'cboKind'
		,store : obj.cboKindStore
		,minChars : 1
		,displayField : 'Description'
		,fieldLabel : '传染病类别'
		,valueField : 'Code'
		,triggerAction : 'all'
		,anchor : '99%'
	});

	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.cboAppendixStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboAppendixStore = new Ext.data.Store({
		proxy: obj.cboAppendixStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'Description', mapping: 'Description'}
		])
	});
	obj.cboAppendix = new Ext.form.ComboBox({
		id : 'cboAppendix'
		,store : obj.cboAppendixStore
		,minChars : 1
		,displayField : 'Description'
		,fieldLabel : '附卡类型'
		,valueField : 'ID'
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.chkMulti = new Ext.form.Checkbox({
		id : 'chkMulti'
		,fieldLabel : '是否多次患病'
	});
	
	//该条数据是否有效 update by shp 20160130
	obj.chkWork = new Ext.form.Checkbox({
		id : 'chkWork'
		,fieldLabel : '是否有效'
	});
	
	obj.txtName = new Ext.form.TextField({
		id : 'txtName'
		,width : 160
		,fieldLabel : '传染病名称'
		,anchor : '99%'
	});
	obj.txtResume = new Ext.form.TextField({
		id : 'txtResume'
		,width : 160
		,height : 45
		,fieldLabel : '备注'
		,anchor : '99%'
	});

	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.cboLevelStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboLevelStore = new Ext.data.Store({
		proxy: obj.cboLevelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Code'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
		])
	});
	obj.cboLevel = new Ext.form.ComboBox({
		id : 'cboLevel'
		,store : obj.cboLevelStore
		,minChars : 1
		,displayField : 'Description'
		,fieldLabel : '传染病级别'
		,valueField : 'Code'
		,triggerAction : 'all'
		,anchor : '99%'
	});

	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.cboTimeLimitStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboTimeLimitStore = new Ext.data.Store({
		proxy: obj.cboTimeLimitStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Code'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
		])
	});
	obj.cboTimeLimit = new Ext.form.ComboBox({
		id : 'cboTimeLimit'
		,minChars : 1
		,displayField : 'Description'
		,fieldLabel : '上报时限'
		,store : obj.cboTimeLimitStore
		,triggerAction : 'all'
		,valueField : 'Code'
		,anchor : '99%'
		,editable: false
	});
	obj.chkDependent = new Ext.form.Checkbox({
		id : 'chkDependent'
		,fieldLabel : '是否需要客观诊断'
	});
	obj.txtMinAge = new Ext.form.NumberField({
		id : 'txtMinAge',
		fieldLabel : '最低上报年龄'			,
		width : 160
	});
	obj.txtMaxAge = new Ext.form.NumberField({
		id : 'txtMaxAge',
		fieldLabel : '最高上报年龄'	,
		width : 160
		
	});
	obj.pnCol1 = new Ext.Panel({
		id : 'pnCol1'
		,buttonAlign : 'center'
		,columnWidth : 0.33
		,layout : 'form'
		,items:[
			obj.txtICD
			,obj.cboLevel
			,obj.cboTimeLimit
			//,obj.txtMinAge
		]
	});
	//update by shp 20160130
	obj.pnChkCol1=new Ext.Panel({
		id : 'pnChkCol1'
		,buttonAlign : 'center'
		,columnWidth : 0.33
		,layout : 'form'
		,items:[
			obj.chkMulti
		]
	})
	
	obj.pnChkCol2=new Ext.Panel({
		id : 'pnChkCol2'
		,buttonAlign : 'center'
		,columnWidth : 0.33
		,layout : 'form'
		,items:[
			obj.chkWork
		]
	})
	
	obj.pnChkMultiWork = new Ext.Panel({
		id : 'pnChkMultiWork'
		//,buttonAlign : 'center'
		,columnWidth : 0.45
		,layout : 'column'
		,items:[
			obj.pnChkCol1
			,obj.pnChkCol2
		]
	});
	obj.pnCol2 = new Ext.Panel({
		id : 'pnCol2'
		,buttonAlign : 'center'
		,columnWidth : 0.33
		,layout : 'form'
		,items:[
			obj.txtName
			,obj.cboAppendix
			,obj.pnChkMultiWork
			//,obj.txtMaxAge
		]
	});
	obj.pnCol3 = new Ext.Panel({
		id : 'pnCol3'
		,buttonAlign : 'center'
		,columnWidth : 0.33
		,layout : 'form'
		,items:[
			obj.cboKind
			,obj.txtResume
			//,obj.chkDependent
		]
	});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	obj.btnAlias = new Ext.Button({
		id : 'btnAlias'
		,iconCls:'icon-export'
		,text : '别名'
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls:'icon-find'
		,text : '查询'
	});
	obj.pnInfection = new Ext.form.FormPanel({
		id : 'pnInfection'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 90
		,bodyBorder : 'padding:0 0 0 0'
		,region : 'south'
		,height : 140
		,frame : true
		,layout : 'column'
		,items:[
			obj.pnCol1
			,obj.pnCol2
			,obj.pnCol3
		]
		,buttons:[
			obj.btnQuery
			,obj.btnSave
			,obj.btnAlias
		]
	});
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items:[
			obj.gridInfection
			,obj.pnInfection
		]
	});
	/*
	obj.gridInfectionStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.EPDService.InfectionSrv';
			param.QueryName = 'QryInfection';
			param.Arg1 = '';
			param.ArgCnt = 1;
	});
	*/
	obj.gridInfectionStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.EPDService.InfectionSrv';
			param.QueryName = 'QryIFList';
			param.Arg1 = obj.txtICD.getValue();
			param.Arg2 = obj.txtName.getValue();
			param.Arg3 = obj.cboKind.getValue();
			param.Arg4 = obj.cboLevel.getValue();
			param.Arg5 = obj.cboAppendix.getValue();
			param.ArgCnt = 5;
	});
	obj.gridInfectionStore.load({});
	obj.cboKindStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.DictionarySrv';
			param.QueryName = 'QryDictionary';
			param.Arg1 = 'EpdemicType';
			param.ArgCnt = 1;
	});
	obj.cboAppendixStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.EPDService.AppendixCardSrv';
			param.QueryName = 'QryAppendixCard';
			param.ArgCnt = 0;
	});
	obj.cboLevelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.DictionarySrv';
			param.QueryName = 'QryDictionary';
			param.Arg1 = 'EpidemicRank';
			param.ArgCnt = 1;
	});
	obj.cboTimeLimitStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.DictionarySrv';
			param.QueryName = 'QryDictionary';
			param.Arg1 = 'EpidemicReportTimeLimit';
			param.ArgCnt = 1;
	});
	InitviewScreenEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}

function InitwinAlias(){
	var obj = new Object();
	obj.cboInfAliasTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboInfAliasTypeStore = new Ext.data.Store({
		proxy : obj.cboInfAliasTypeStoreProxy,
		reader : new Ext.data.JsonReader(
			{
				root : 'record',
				totalProperty : 'total',
				idProperty : 'Code'
			},[
				{ name : 'checked', mapping : 'checked' }
				,{ name : 'Code', mapping : 'Code' }
				,{ name : 'Description', mapping : 'Description' }
			]
		)
	});
	obj.cboInfAliasType = new Ext.form.ComboBox({
		id : 'cboInfAliasType'
		//,width : 120
		//,minChars : 1
		,displayField : 'Description'
		,store : obj.cboInfAliasTypeStore
		,triggerAction : 'all'
		,valueField : 'Code'
	});
	obj.cboInfAliasTypeStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.DictionarySrv';
		param.QueryName = 'QrySSDictionary';
		param.Arg1 = 'EpdInfAliasType';
		param.ArgCnt = 1;
	});
	
	obj.btnAddAlias = new Ext.Button({text : '添加', iconCls : 'icon-add'});
	obj.btnDeleteAlias = new Ext.Button({text : '删除', iconCls : 'icon-delete'});
	
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
		function(conn, response, Options){
		if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
			ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	);
	obj.gridAliasStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.gridAliasStore = new Ext.data.Store({
		proxy: obj.gridAliasStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'RowID', mapping: 'RowID'}
			,{name: 'Alias', mapping: 'Alias'}
			,{name: 'IsKeyWord', mapping: 'IsKeyWord'}
			,{name: 'IsKeyWordDesc', mapping: 'IsKeyWordDesc'}
		])
	});
	obj.gridAliasCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridAlias = new Ext.grid.EditorGridPanel({
		id : 'gridAlias'
		,store : obj.gridAliasStore
		,buttonAlign : 'center'
		,width : 306
		,height : 222
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,tbar : new Ext.Toolbar({
			items : [obj.btnAddAlias, obj.btnDeleteAlias]	
		})
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '别名', width: 120, dataIndex: 'Alias', sortable: true, editable: true, editor : new Ext.form.TextField({})}
			,{header: '类型', width: 60, dataIndex: 'IsKeyWordDesc', sortable: true, editable: true, editor : obj.cboInfAliasType }
		]
		,iconCls: 'icon-grid'
		,viewConfig : {
			forceFit : true
		}
	});
	obj.btnSaveAlias = new Ext.Button({
		id : 'btnSaveAlias'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	obj.btnCancelAlias = new Ext.Button({
		id : 'btnCancelAlias'
		,iconCls : 'icon-cancel'
		,text : '取消'
	});
	obj.winAlias = new Ext.Window({
		id : 'winAlias'
		,height : 400
		,buttonAlign : 'center'
		,width : 300
		,modal : true
		,title : '传染病字典维护--别名'
		,layout : 'fit'
		,items:[
			obj.gridAlias
		]
		,buttons:[
			obj.btnSaveAlias
			,obj.btnCancelAlias
		]
	});
	obj.gridAliasStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.EPDService.InfectionSrv';
			param.QueryName = 'QryAliasByRowID';
			param.Arg1 = obj.InfectionID;
			param.ArgCnt = 1;
	});
	
	InitwinAliasEvent(obj);
	//事件处理代码
	obj.btnSaveAlias.on("click", obj.btnSaveAlias_click, obj);
	obj.btnCancelAlias.on("click", obj.btnCancelAlias_click, obj);
	obj.gridAlias.on("afteredit", obj.gridAlias_afteredit, obj);
	obj.btnAddAlias.on("click", obj.btnAddAlias_click, obj);
	obj.btnDeleteAlias.on("click", obj.btnDeleteAlias_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}

