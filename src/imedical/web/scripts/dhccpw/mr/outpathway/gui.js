function InitOutPathWayWindow(WinParent,PathWayID,UserID){
	var obj = new Object();
	obj.UserID = UserID;
	obj.PathWayID = PathWayID;
	obj.WinParent = WinParent;
	if ((!obj.PathWayID)||(!obj.UserID)) return;
	/*
	var objPathWayService = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinicalPathWays");
	var strPathWay=objPathWayService.GetStringById(obj.PathWayID,String.fromCharCode(1));
	var lstPathWay=strPathWay.split(String.fromCharCode(1));
	if (lstPathWay.length >= 2) {
		obj.EpisodeID=lstPathWay[1];
		obj.CPWID=lstPathWay[2];
	}
	if (!obj.CPWID) return;
	
	var objCPWService = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysSrv");
	var strCPW=objCPWService.GetById(obj.CPWID,String.fromCharCode(1));
	var lstCPW=strCPW.split(String.fromCharCode(1));
	if (lstCPW.length >= 2) {
		obj.CPWDesc=lstCPW[2];
	}
	if (!obj.CPWDesc) return;
	*/
	obj.cboOutReasonCategStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboOutReasonCategStore = new Ext.data.Store({
		proxy: obj.cboOutReasonCategStoreProxy,
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
	obj.cboOutReasonCateg = new Ext.form.ComboBox({
		id : 'cboOutReasonCateg'
		,width : 100
		,displayField : 'Desc'
		,minChars : 1
		,fieldLabel : '原因分类'
		,store : obj.cboOutReasonCategStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'Rowid'
	});
	obj.cboOutReasonCategStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.VarianceCategory';
			param.QueryName = 'QryVarCateg';
			param.Arg1 = "O";
			param.ArgCnt = 1;
	});
	obj.cboOutReasonCategStore.load({});
	
	obj.cboOutReasonStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboOutReasonStore = new Ext.data.Store({
		proxy: obj.cboOutReasonStoreProxy,
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
	obj.cboOutReason = new Ext.form.ComboBox({
		id : 'cboOutReason'
		,width : 100
		,displayField : 'Desc'
		,minChars : 1
		,fieldLabel : '出径原因'
		,mode : 'local'           //add by wuqk 2011-07-22
		,store : obj.cboOutReasonStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'Rowid'
	});
	obj.cboOutReasonStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.VarianceReason';
			param.QueryName = 'QryVarReason';
			param.Arg1 = obj.cboOutReasonCateg.getValue();
			param.ArgCnt = 1;
	});
	//obj.cboOutReasonStore.load({});
	
	obj.txtOutReasonResume = new Ext.form.TextArea({
		id : 'txtOutReasonResume'
		,height : 150
		,width : 100
		,fieldLabel : '备注'
		,anchor : '95%'
	});
	obj.btnOutPathWay = new Ext.Button({
		id : 'btnOutPathWay'
		,iconCls : 'icon-cancel'
		,text : '出径'
	});
	obj.btnCloseForm = new Ext.Button({
		id : 'btnCloseForm'
		,iconCls : 'icon-exit'
		,text : '退出'
	});
	
	obj.ConditionPanel = new Ext.form.FormPanel({
		id : 'ConditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 70
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'form'
		,frame : true
		,region : 'center'
		,items:[
			obj.cboOutReasonCateg
			,obj.cboOutReason
			,obj.txtOutReasonResume
		]
		,buttons:[
			obj.btnOutPathWay
			,obj.btnCloseForm
		]
	});
	
	obj.OutPathWayWindow = new Ext.Window({
		id : 'OutPathWayWindow'
		,collapsed : true
		,buttonAlign : 'center'
		,maximized : false
		,resizable : false
		,title : '出径确认'
		,layout : 'border'
		,width : 400
		,height : 300
		,modal: true
		,items:[
			obj.ConditionPanel
		]
	});
	InitOutPathWayWindowEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}