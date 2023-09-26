function InitwinCpwVarEdit(){
	var obj = new Object();
	obj.cboCategoryStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboCategoryStore = new Ext.data.Store({
		proxy: obj.cboCategoryStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboCategory = new Ext.form.ComboBox({
		id : 'cboCategory'
		,width : 100
		,displayField : 'Desc'
		,minChars : 1
		,fieldLabel : '原因分类'
		,store : obj.cboCategoryStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'Rowid'
	});
	obj.cboCategoryStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.VarianceCategory';
			param.QueryName = 'QryVarCateg';
			param.Arg1 = "V";
			param.ArgCnt = 1;
	});
	obj.cboCategoryStore.load({});
	
	obj.cboReasonStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboReasonStore = new Ext.data.Store({
		proxy: obj.cboReasonStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboReason = new Ext.form.ComboBox({
		id : 'cboOutReason'
		,width : 100
		,displayField : 'Desc'
		,minChars : 1
		//Update By NiuCaicai 2011-07-20 FixBug:110 查询统计--临床路径监控--(双击患者)临床路径监控--医嘱监控--病情便已记录--“出径原因”含义不明确，改为“变异原因”
		,fieldLabel : '变异原因'
		,store : obj.cboReasonStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'Rowid'
	});
	obj.cboReasonStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.VarianceReason';
			param.QueryName = 'QryVarReasonNew';
			param.Arg1 = obj.cboCategory.getValue();
			param.ArgCnt = 1;
	});
	obj.txtNote = new Ext.form.TextArea({
		id : 'txtNote'
		,height : 100
		,width : 100
		,fieldLabel : '备注'
		,anchor : '95%'
	});
	obj.pnForm = new Ext.form.FormPanel({
		id : 'pnForm'
		,width : 300
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,labelWidth : 80
		,height : 188
		,layout : 'form'
		,frame : true
		,items:[
			obj.cboCategory
			,obj.cboReason
			,obj.txtNote
		]
	});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,text : '保存'
	});
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,text : '取消'
	});
	obj.winCpwVarEdit = new Ext.Window({
		id : 'winCpwVarEdit'
		,height : 240
		,buttonAlign : 'center'
		,width : 400
		,title : '病情变异记录'
		,layout : 'fit'
		,modal : true
		,items:[
			obj.pnForm
		]
		,buttons:[
			obj.btnSave
			,obj.btnCancel
		]
	});
	
	InitwinCpwVarEditEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}

