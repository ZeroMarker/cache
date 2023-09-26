function InitPathWayRstWindow(WinParent,PathWayID,UserID){
	var obj = new Object();
	obj.UserID = UserID;
	obj.PathWayID = PathWayID;
	obj.CurrRstID="";
	obj.WinParent = WinParent;
	if ((!obj.PathWayID)||(!obj.UserID)) return;
	
	obj.cboZZGSStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboZZGSStore = new Ext.data.Store({
		proxy: obj.cboZZGSStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DicID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'DicID', mapping: 'DicID'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
		])
	});
	obj.cboZZGS = new Ext.ux.form.LovCombo({
		id : 'cboZZGS'
		,width : 200
		,hideOnSelect:true
		,maxHeight:200
		,valueField : 'DicID'
		,displayField : 'DicDesc'
		,fieldLabel : '症状改善'
		,store : obj.cboZZGSStore
		,triggerAction:'all'
		,mode:'local'
		,anchor : '99%'
	});
	obj.cboZZGSStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseDictionary';
			param.QueryName = 'QryBySubCateg';
			param.Arg1 = "XZZGS";
			param.Arg2 = obj.PathWayID;
			param.ArgCnt = 2;
	});
	obj.cboZZGSStore.load({});
	
	obj.cboTZGSStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboTZGSStore = new Ext.data.Store({
		proxy: obj.cboTZGSStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DicID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'DicID', mapping: 'DicID'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
		])
	});
	obj.cboTZGS = new Ext.ux.form.LovCombo({
		id : 'cboTZGS'
		,width : 200
		,hideOnSelect:false
		,maxHeight:200
		,triggerAction:'all'
		,displayField : 'DicDesc'
		,valueField : 'DicID'
		,fieldLabel : '体征改善'
		,store : obj.cboTZGSStore
		,mode:'local'
		,anchor : '99%'
	});
	obj.cboTZGSStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseDictionary';
			param.QueryName = 'QryBySubCateg';
			param.Arg1 = "XTZGS";
			param.Arg2 = obj.PathWayID;
			param.ArgCnt = 2;
	});
	obj.cboTZGSStore.load({});
	
	obj.cboLHZBStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboLHZBStore = new Ext.data.Store({
		proxy: obj.cboLHZBStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DicID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'DicID', mapping: 'DicID'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
		])
	});
	/*
	obj.cboLHZB = new Ext.ux.form.LovCombo({
		id : 'cboLHZB'
		,width : 200
		,hideOnSelect:false
		,maxHeight:200
		,triggerAction:'all'
		,displayField : 'DicDesc'
		,valueField : 'DicID'
		,fieldLabel : '理化指标'
		,store : obj.cboLHZBStore
		,mode:'local'
		,editable : false
		,anchor : '99%'
	});
	*/
	obj.cboLHZB = new Ext.form.ComboBox({
		id : 'cboLHZB'
		,width : 100
		,valueField : 'DicID'
		,displayField : 'DicDesc'
		,minChars : 1
		,fieldLabel : '理化指标'
		,store : obj.cboLHZBStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.cboLHZBStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseDictionary';
			param.QueryName = 'QryBySubCateg';
			param.Arg1 = "XLHZB";
			param.Arg2 = obj.PathWayID;
			param.ArgCnt = 2;
	});
	obj.cboLHZBStore.load({});
	
	obj.cboZGQKStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboZGQKStore = new Ext.data.Store({
		proxy: obj.cboZGQKStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DicID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'DicID', mapping: 'DicID'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
		])
	});
	obj.cboZGQK = new Ext.form.ComboBox({
		id : 'cboZGQK'
		,width : 100
		,valueField : 'DicID'
		,displayField : 'DicDesc'
		,minChars : 1
		,fieldLabel : '实施路径疗效'
		,store : obj.cboZGQKStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.cboZGQKStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseDictionary';
			param.QueryName = 'QryBySubCateg';
			param.Arg1 = "YZGQK";
			param.Arg2 = "";
			param.ArgCnt = 2;
	});
	obj.cboZGQKStore.load({});
	
	obj.txtResume = new Ext.form.TextArea({
		id : 'txtResume'
		,height : 80
		,width : 100
		,fieldLabel : '症状改善描述'
		,anchor : '99%'
	});
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,text : '保存'
	});
	
	obj.ConditionPanel = new Ext.form.FormPanel({
		id : 'ConditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'form'
		,frame : true
		,items:[
			obj.cboZGQK
			,obj.cboZZGS
			,obj.cboTZGS
			,obj.cboLHZB
			,obj.txtResume
		]
		,buttons:[
			obj.btnUpdate
		]
	});
	obj.PathWayRstWindow = new Ext.Window({
		id : 'PathWayRstWindow'
		//,collapsed : true
		,buttonAlign : 'center'
		,maximized : false
		,resizable : false
		,title : '路径评估'
		,layout : 'fit'
		,width : 400
		,height : 275
		,modal: true
		,items:[
			obj.ConditionPanel
		]
	});
	InitPathWayRstWindowEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}