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
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'Type', mapping: 'Type'}
			,{name: 'FromDate', mapping: 'FromDate'}
			,{name: 'ResumeText', mapping: 'ResumeText'}
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
			,{header: '����', width: 80, dataIndex: 'Code', sortable: true}
			,{header: '����', width: 120, dataIndex: 'Description', sortable: true}
			,{header: '��Ч', width: 60, dataIndex: 'IsActive', sortable: true}
			,{header: '���', width: 80, dataIndex: 'Type', sortable: true}
			,{header: '��Ч����', width: 80, dataIndex: 'FromDate', sortable: true}
			,{header: '��ע', width: 100, dataIndex: 'ResumeText', sortable: true}
		]
		,viewConfig : {
			forceFit : true
		}
	});
	obj.txtCode = new Ext.form.TextField({
		id : 'txtCode'
		,fieldLabel : '����'
		,anchor : '95%'
	});
	obj.chkIsActive = new Ext.form.Checkbox({
		id : 'chkIsActive'
		,fieldLabel : '��Ч'
		,anchor : '95%'
	});
	obj.dtActiveDate = new Ext.form.DateField({
		id : 'dtActiveDate'
		,value : new Date()
		,format : 'Y-m-d'
		,fieldLabel : '��Ч����'
		,anchor : '95%'
	});
	obj.txtDesc = new Ext.form.TextField({
		id : 'txtDesc'
		,fieldLabel : '����'
		,anchor : '95%'
	});
	obj.txtType = new Ext.form.TextField({
		id : 'txtType'
		,fieldLabel : '���'
		,anchor : '95%'
	});
	obj.txtResumeText = new Ext.form.TextField({
		id : 'txtResumeText'
		,fieldLabel : '��ע'
		,anchor : '95%'
	});
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '����'
	});
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items:[
			obj.gridResult
			,{	
				layout : 'form'
				,region : 'south'
				,buttonAlign : 'center'
				,height : 75
				,frame : true
				,items :[
					{
						layout : 'column'
						,items : [
							{
								width:150
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 40
								,items: [obj.txtCode]
							},{
								width:300
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 40
								,items: [obj.txtDesc]
							},{
								width:180
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 40
								,items: [obj.txtType]
							},{
								width:80
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 40
								,items: [obj.chkIsActive]
							},{
								width:180
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.dtActiveDate]
							},{
								width:180
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 40
								,items: [obj.txtResumeText]
							}
						]
					}
				]
				,buttons:[
					obj.btnSave
				]
			}
		]
	});
	obj.gridResultStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.EPDService.AppendixCardSrv';
			param.QueryName = 'QryAppendixCard';
			param.ArgCnt = 0;
	});
	obj.gridResultStore.load({});
	InitviewScreenEvent(obj);
	//�¼��������
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.gridResult.on("rowdblclick", obj.gridResult_rowdblclick, obj);
	obj.gridResult.on("rowclick", obj.gridResult_rowclick, obj);
  obj.LoadEvent(arguments);
  return obj;
}
function InitwinItems(){
	var obj = new Object();
	
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	var objProxy = new Ext.data.HttpProxy(objConn);
	objProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.DictionarySrv';
			param.QueryName = 'QrySSDictionary';
			param.Arg1 = "EPIDEMICAPPENDIXDATATYPE";
			param.ArgCnt = 1;
	});				
	var objStore = new Ext.data.Store({
		proxy: objProxy,
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
	obj.objComboDataType = new Ext.form.ComboBox({
		id : 'objComboDataType'
		//,width : 120
		//,minChars : 1
		,displayField : 'Description'
		,store : objStore
		,triggerAction : 'all'
		,valueField : 'Code'
		,editable: false
	});  		
	
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	var objProxy = new Ext.data.HttpProxy(objConn);
	objProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.DictionarySrv';
			param.QueryName = 'QrySSDictionary';
			param.Arg1 = "SYS";
			param.ArgCnt = 1;
	});				
	var objStore = new Ext.data.Store({
		proxy: objProxy,
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
	obj.objComboDicName = new Ext.form.ComboBox({
		id : 'objComboDicName'
		//,width : 120
		//,minChars : 1
		,displayField : 'Description'
		,store : objStore
		,triggerAction : 'all'
		,valueField : 'Code'
	});
	

	
	obj.btnAdd = new Ext.Button({
		id : 'btnAdd'
		,iconCls : 'icon-add'
		,text : '���'
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
			,{name: 'Name', mapping: 'Name'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'DataType', mapping: 'DataType'}
			,{name: 'DicName', mapping: 'DicName'}
			,{name: 'HiddenValueDataType', mapping: 'HiddenValueDataType'}
			,{name: 'HiddenValueDicName', mapping: 'HiddenValueDicName'}
			,{name: 'ValExp', mapping: 'ValExp'}
			,{name: 'IsNecess', mapping: 'IsNecess'}
		])
	});
	obj.gridResultCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridResult = new Ext.grid.EditorGridPanel({
		id : 'gridResult'
		,store : obj.gridResultStore
		,buttonAlign : 'center'
		,tbar : new Ext.Toolbar({
			items: [
				obj.btnAdd 
			]	
		})
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '��Ŀ����', width: 150, dataIndex: 'Name', sortable: false, editor : new Ext.form.TextField({}) }
			,{header: '�Ƿ�<br>��Ч', width: 30, dataIndex: 'IsActive', sortable: false, editor : new Ext.form.Checkbox({})}
			,{header: '����<br>����', width: 30, dataIndex: 'DataType', sortable: false, editor : obj.objComboDataType}
			,{header: '�����ֵ�', width: 100, dataIndex: 'DicName', sortable: false, editor : obj.objComboDicName}
			,{header: '�Ƿ�<br>������', width: 30, dataIndex: 'IsNecess', sortable: false, editor : new Ext.form.Checkbox({})}
			,{header: 'Ĭ��ֵ���ʽ', width: 150, dataIndex: 'ValExp', sortable: false, editor : new Ext.form.TextField({}) }
		]
		,viewConfig : {
			forceFit : true
		}
	});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '����'
	});
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-undo'
		,text : 'ȡ��'
	});
	
	obj.winItems = new Ext.Window({
		id : 'winItems'
		,height : 500
		,buttonAlign : 'center'
		,width : 800
		,modal : true
		,title : '��Ⱦ��������Ŀ'
		,layout : 'fit'
		,items:[
			obj.gridResult
		]
		,buttons:[
			obj.btnSave
			,obj.btnCancel
		]
	});
	
	InitwinItemsEvent(obj);
	//�¼��������
	//obj.gridResult.on("rowclick", obj.gridResult_rowclick, obj);
	obj.gridResult.on("afteredit", obj.gridResult_afteredit, obj);
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
	obj.btnAdd.on("click", obj.btnAdd_click, obj);
	obj.LoadEvent(arguments);
	return obj;
}

