// dhcmed.main.disease.csp
function InitViewport1() {
	
	var obj = new Object();
	
	obj.clsProducts = ExtTool.StaticServerObject("DHCMed.SS.Products");
	
	obj.gridDiseaseStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
	obj.gridDiseaseStore = new Ext.data.GroupingStore({
		proxy : obj.gridDiseaseStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ID'
		},[
			{ name : 'ID', mapping : 'ID' }
			,{ name : 'IDCode', mapping : 'IDCode' }
			,{ name : 'IDDesc', mapping : 'IDDesc' }
			,{ name : 'ICD10', mapping : 'ICD10' }
			,{ name : 'CateID', mapping : 'CateID' }
			,{ name : 'CateDesc', mapping : 'CateDesc' }
			,{ name : 'ProID', mapping : 'ProID' }
			,{ name : 'ProName', mapping : 'ProName' }
			,{ name : 'IsActive', mapping : 'IsActive' }
			,{ name : 'IsActiveDesc', mapping : 'IsActiveDesc' }
			,{ name : 'Resume', mapping : 'Resume' }
		])
		//,sortInfo : { field : 'IDCode', direction : 'ASC' }
		//,groupField : 'ProName'
	});
	
	obj.gridDisease = new Ext.grid.GridPanel({
		id : 'gridDisease'
		,header : true
		,store : obj.gridDiseaseStore
		,columnLines : true
		,loadMask : true
		,region : 'center'
		,frame : true
		,columns : [
			new Ext.grid.RowNumberer()
			,{ header : '疾病代码', width : 120, dataIndex : 'IDCode', sortable : true }
			,{ header : '疾病描述', width : 200, dataIndex : 'IDDesc', sortable : true }
			,{ header : '疾病ICD', width : 120, dataIndex : 'ICD10', sortable : true }
			,{ header : '疾病分类', width : 160, dataIndex : 'CateDesc', sortable : true }
			,{ header : '产品', width : 160, dataIndex : 'ProName', sortable : true }
			//,{ header : '产品', width : 0, dataIndex : 'ProName', sortable : true, align : 'left', hidden : true, menuDisabled : true }
			,{ header : '是否有效', width : 100, dataIndex : 'IsActiveDesc', sortable : true }
			,{ header : '备注', width : 200, dataIndex : 'Resume', sortable : true }
		]
		//,view : new Ext.grid.GroupingView({
		//	forceFit : true
		//	,groupTextTpl : '按产品归类:{[values.rs[0].get("ProName")]}(共{[values.rs.length]}条记录)'
		//	,groupByText : '依本列分组'
		//})
	});
	
	obj.gridDiseaseStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.DiseaseSrv';
		param.QueryName = 'QryDisease';
		param.Arg1 = ProductCode;
		param.Arg2 = '';
		param.Arg3 = '';
		param.ArgCnt = 3;
	});
	
	obj.btnSaveDisease = new Ext.Button({
		id : 'btnSaveDisease'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	
	obj.btnSaveICD = new Ext.Button({
		id : 'btnSaveICD'
		,iconCls : 'icon-export'
		,text : 'ICD'
	});
	
	obj.btnSaveAlias = new Ext.Button({
		id : 'btnSaveAlias'
		,iconCls : 'icon-export'
		,text : '别名'
	});
	
	obj.txtDiseaseCode = new Ext.form.TextField({
		id : 'txtDiseaseCode'
		,width : 160
		,fieldLabel : '疾病代码'
		,labelSeparator :''
		,anchor : '99%'
	});
	
	obj.txtDiseaseDesc = new Ext.form.TextField({
		id : 'txtDiseaseDesc'
		,width : 160
		,fieldLabel : '疾病描述'
		,labelSeparator :''
		,anchor : '99%'
	});
	
	obj.txtDiseaseICD = new Ext.form.TextField({
		id : 'txtDiseaseICD'
		,width : 160
		,fieldLabel : '疾病ICD'
		,labelSeparator :''
		,anchor : '99%'
	});
	
	obj.txtDiseaseResume = new Ext.form.TextField({
		id : 'txtDiseaseResume'
		,width : 160
		,height : 70
		,fieldLabel : '备注'
		,labelSeparator :''
		,anchor : '99%'
	});
	
	obj.chkIsActive = new Ext.form.Checkbox({
		id : 'chkIsActive'
		,fieldLabel : '是否有效'
		,labelSeparator :''
		,checked : true
	});
	
	obj.cboProductStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
	obj.cboProductStore = new Ext.data.Store({
		proxy : obj.cboProductStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'rowid'
		},[
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'rowid', mapping : 'rowid' }
			,{ name : 'ProName', mapping : 'ProName' }
		])
	});
	
	obj.cboProduct = new Ext.form.ComboBox({
		id : 'cboProduct'
		,width : 200
		,valueField : 'rowid'
		,displayField : 'ProName'
		,minChars : 1
		,fieldLabel : '产品'
		,labelSeparator :''
		,store : obj.cboProductStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '100%'
		,listeners : {
			'select' : function() {
				obj.cboCateg.setValue('');
				obj.cboCategStore.load({});
			}
		}
	});
	
	obj.cboProductStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.ProductsSrv';
		param.QueryName = 'QueryProInfo';
		param.Arg1 = '';
		param.ArgCnt = 1;
	});
	
	obj.cboCategStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
	obj.cboCategStore = new Ext.data.Store({
		proxy : obj.cboCategStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'myid'
		},[
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'myid', mapping : 'myid' }
			,{ name : 'Description', mapping : 'Description' }
		])
	});
	
	obj.cboCateg = new Ext.form.ComboBox({
		id : 'cboCateg'
		,width : 200
		,valueField : 'myid'
		,displayField : 'Description'
		,minChars : 1
		,fieldLabel : '分类'
		,labelSeparator :''
		,store : obj.cboCategStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '100%'
	});
	
	obj.cboCategStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.DictionarySrv';
		param.QueryName = 'QryDictionary';
		var DisType = "";
		var objPro = obj.clsProducts.GetObjById(obj.cboProduct.getValue());
		if (objPro) { DisType = objPro.ProCode + 'DiseaseType'; }
		param.Arg1 = DisType;
		param.Arg2 = 1;
		param.ArgCnt = 2;
	});
	
	obj.pnCol1 = new Ext.Panel({
		id : 'pnCol1'
		,layout : 'form'
		,columnWidth : 0.33
		,items : [
			obj.txtDiseaseCode
			,obj.txtDiseaseDesc
			,obj.txtDiseaseICD
		]
	});
	
	obj.pnCol2 = new Ext.Panel({
		id : 'pnCol2'
		,layout : 'form'
		,columnWidth : 0.33
		,items : [
			obj.cboProduct
			,obj.cboCateg
			,obj.chkIsActive
		]
	});
	
	obj.pnCol3 = new Ext.Panel({
		id : 'pnCol3'
		,layout : 'form'
		,columnWidth : 0.33
		,items : [
			obj.txtDiseaseResume
		]
	});
	
	obj.pnDisease = new Ext.form.FormPanel({
		id : 'pnDisease'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 85
		,bodyBorder : 'padding : 0 0 0 0'
		,region : 'south'
		,height : 135
		,frame : true
		,layout : 'column'
		,items : [
			obj.pnCol1
			,obj.pnCol2
			,obj.pnCol3
		]
		,buttons : [
			obj.btnSaveDisease
			,obj.btnSaveICD
			,obj.btnSaveAlias
		]
	});
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			obj.gridDisease
			,obj.pnDisease
		]
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

function InitWinICD(selectObj) {
	
	var obj = new Object();
	obj.selectObj = selectObj;
	
	obj.btnAddICD = new Ext.Button({
		id : 'btnAddICD'
		,iconCls : 'icon-add'
		,text : '添加'
	});
	
	obj.btnDeleteICD = new Ext.Button({
		id : 'btnDeleteICD'
		,iconCls : 'icon-delete'
		,text : '删除'
	});
	
	obj.btnUpdateICD = new Ext.Button({
		id : 'btnUpdateICD'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	
	obj.btnCancelICD = new Ext.Button({
		id : 'btnCancelICD'
		,iconCls : 'icon-undo'
		,text : '取消'
	});
	
	obj.gridICDStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
	obj.gridICDStore = new Ext.data.Store({
		proxy : obj.gridICDStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ID'
		},[
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'ID', mapping : 'ID' }
			,{ name : 'IDICD10', mapping : 'IDICD10' }
			,{ name : 'IDICDDesc', mapping : 'IDICDDesc' }
			,{ name : 'IDExWords', mapping : 'IDExWords' }
		])
	});
	
	obj.gridICDCheckCol = new Ext.grid.CheckColumn({ header : '', dataIndex : 'checked', width : 50 });
	
	obj.gridICD = new Ext.grid.EditorGridPanel({
		id : 'gridICD'
		,store : obj.gridICDStore
		,buttonAlign : 'center'
		,width : 406
		,height : 222
		,selModel : new Ext.grid.RowSelectionModel({ singleSelect : true })
		,tbar : new Ext.Toolbar({ items : [ obj.btnAddICD, obj.btnDeleteICD ] })
		,columns : [
			new Ext.grid.RowNumberer()
			,{ header : 'ICD10', width : 80, dataIndex : 'IDICD10', sortable : true, editable : true, editor : new Ext.form.TextField({}) }
			,{ header : '疾病名称', width : 120, dataIndex : 'IDICDDesc', sortable : true, editable : true, editor : new Ext.form.TextField({}) }
			,{ header : '排除关键字(多值#分隔)', width : 200, dataIndex : 'IDExWords', sortable : true, editable : true, editor : new Ext.form.TextField({}) }
		]
		,iconCls : 'icon-grid'
		,viewConfig : { forceFit : true }
	});
	
	obj.gridICDStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.DiseaseSrv';
		param.QueryName = 'QryDiseaseICD';
		param.Arg1 = obj.selDiseaseId;
		param.ArgCnt = 1;
	});
	
	obj.WinICD = new Ext.Window({
		id : 'WinICD'
		,width : 500
		,height : 300
		,buttonAlign : 'center'
		,title : '疾病字典维护——ICD'
		,layout : 'fit'
		,items : [ obj.gridICD ]
		,buttons : [ obj.btnUpdateICD, obj.btnCancelICD ]
	});
	
	InitWinICDEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

function InitWinAlias(selectObj) {
	
	var obj = new Object();
	obj.selectObj = selectObj;
	
	obj.btnAddAlias = new Ext.Button({
		id : 'btnAddAlias'
		,iconCls : 'icon-add'
		,text : '添加'
	});
	
	obj.btnDeleteAlias = new Ext.Button({
		id : 'btnDeleteAlias'
		,iconCls : 'icon-delete'
		,text : '删除'
	});
	
	obj.btnUpdateAlias = new Ext.Button({
		id : 'btnUpdateAlias'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	
	obj.btnCancelAlias = new Ext.Button({
		id : 'btnCancelAlias'
		,iconCls : 'icon-undo'
		,text : '取消'
	});
	
	obj.gridAliasStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
	obj.gridAliasStore = new Ext.data.Store({
		proxy : obj.gridAliasStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ID'
		},[
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'ID', mapping : 'ID' }
			,{ name : 'IDAlias', mapping : 'IDAlias' }
		])
	});
	
	obj.gridAliasCheckCol = new Ext.grid.CheckColumn({ header : '', dataIndex : 'checked', width : 50 });
	
	obj.gridAlias = new Ext.grid.EditorGridPanel({
		id : 'gridAlias'
		,store : obj.gridAliasStore
		,buttonAlign : 'center'
		,width : 306
		,height : 222
		,selModel : new Ext.grid.RowSelectionModel({ singleSelect : true })
		,tbar : new Ext.Toolbar({ items : [ obj.btnAddAlias, obj.btnDeleteAlias ] })
		,columns : [
			new Ext.grid.RowNumberer()
			,{ header : '别名', width : 150, dataIndex : 'IDAlias', sortable : true, editable : true, editor : new Ext.form.TextField({}) }
		]
		,iconCls : 'icon-grid'
		,viewConfig : { forceFit : true }
	});
	
	obj.gridAliasStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.DiseaseSrv';
		param.QueryName = 'QryDiseaseAlias';
		param.Arg1 = obj.selDiseaseId;
		param.ArgCnt = 1;
	});
	
	obj.WinAlias = new Ext.Window({
		id : 'WinAlias'
		,width : 400
		,height : 300
		,buttonAlign : 'center'
		,title : '疾病字典维护——别名'
		,layout : 'fit'
		,items : [ obj.gridAlias ]
		,buttons : [ obj.btnUpdateAlias, obj.btnCancelAlias ]
	});
	
	InitWinAliasEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}