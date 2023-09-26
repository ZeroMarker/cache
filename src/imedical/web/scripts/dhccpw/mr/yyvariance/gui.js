var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_ER=String.fromCharCode(13)+String.fromCharCode(10);
var separete="&nbsp;";

function InitVarSubWindow(PathWayID,UserID){
	var obj = new Object();
	obj.EpisodeID="";
	obj.CPWID="";
	obj.CPWDesc="";
	obj.CurrVarID="";
	obj.CurrVarUserID="";
	obj.CurrVarDate="";
	obj.CurrVarTime="";
	obj.CurrVarDoctorID="";
	obj.UserID=UserID;
	obj.PathWayID=PathWayID;
	if (!obj.PathWayID) return;
	
	var objPathWayService = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinicalPathWays");
	var strPathWay=objPathWayService.GetStringById(obj.PathWayID,CHR_1);
	var lstPathWay=strPathWay.split(CHR_1);
	if (lstPathWay.length >= 2) {
		obj.EpisodeID=lstPathWay[1];
		obj.CPWID=lstPathWay[2];
	}
	if (!obj.CPWID) return;
	
	var objCPWService = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysSrv");
	var strCPW=objCPWService.GetById(obj.CPWID,CHR_1);
	var lstCPW=strCPW.split(CHR_1);
	if (lstCPW.length >= 2) {
		obj.CPWDesc=lstCPW[2];
	}
	if (!obj.CPWDesc) return;
	
	obj.gpVarianceRstStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gpVarianceRstStore = new Ext.data.Store({
		proxy: obj.gpVarianceRstStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'VID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'VID', mapping: 'VID'}
			,{name: 'VCPWID', mapping: 'VCPWID'}
			,{name: 'VCPWDesc', mapping: 'VCPWDesc'}
			,{name: 'VEpisodeDR', mapping: 'VEpisodeDR'}
			,{name: 'VEpisodeDesc', mapping: 'VEpisodeDesc'}
			,{name: 'VEpStepDR', mapping: 'VEpStepDR'}
			,{name: 'VEpStepDesc', mapping: 'VEpStepDesc'}
			,{name: 'VCategoryDR', mapping: 'VCategoryDR'}
			,{name: 'VCategoryDesc', mapping: 'VCategoryDesc'}
			,{name: 'VReasonDR', mapping: 'VReasonDR'}
			,{name: 'VReasonDesc', mapping: 'VReasonDesc'}
			,{name: 'VUserDR', mapping: 'VUserDR'}
			,{name: 'VUserDesc', mapping: 'VUserDesc'}
			,{name: 'VDate', mapping: 'VDate'}
			,{name: 'VTime', mapping: 'VTime'}
			,{name: 'VNote', mapping: 'VNote'}
			,{name: 'VDoctorDR', mapping: 'VDoctorDR'}
			,{name: 'VDoctorDesc', mapping: 'VDoctorDesc'}
		])
	});
	obj.gpVarianceRstCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gpVarianceRst = new Ext.grid.GridPanel({
		id : 'gpVarianceRst'
		,store : obj.gpVarianceRstStore
		,region : 'center'
		,frame : true
		,buttonAlign : 'center'
		,viewConfig : {forceFit:true}
		,columns: [
			{header: '阶段', width: 100, dataIndex: 'VEpisodeDesc', sortable: false}
			,{header: '步骤', width: 100, dataIndex: 'VEpStepDesc', sortable: false}
			,{header: '确认医生', width: 60, dataIndex: 'VDoctorDesc', sortable: false}
			,{header: '变异类型', width: 100, dataIndex: 'VCategoryDesc', sortable: false}
			,{header: '变异原因', width: 200, dataIndex: 'VReasonDesc', sortable: false}
			,{header: '更新人', width: 60, dataIndex: 'VUserDesc', sortable: false}
			,{header: '更新日期', width: 80, dataIndex: 'VDate', sortable: true}
			,{header: '更新时间', width: 60, dataIndex: 'VTime', sortable: false}
			,{header: '备注', width: 150, dataIndex: 'VNote', sortable: false}
		]
	});
	obj.gpVarianceRstStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCPW.MR.ClinPathWaysVariance';
		param.QueryName = 'QryVarianceByCPW';
		param.Arg1 = obj.PathWayID;
		param.ArgCnt = 1;
	});
	obj.gpVarianceRstStore.load({});
	
	obj.txtVarCPW = new Ext.form.TextField({
		id : 'txtVarCPW'
		,width : 100
		,fieldLabel : '临床路径'
		,anchor : '95%'
		,readOnly : true
	});
	obj.txtVarCPW.setValue(obj.CPWDesc);
	
	obj.cboVarEpStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboVarEpStore = new Ext.data.Store({
		proxy: obj.cboVarEpStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboVarEp = new Ext.form.ComboBox({
		id : 'cboVarEp'
		,width : 100
		,displayField : 'Desc'
		,minChars : 1
		,fieldLabel : '阶段'
		,store : obj.cboVarEpStore
		,editable : true
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'Rowid'
	});
	obj.cboVarEpStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.ClinPathWaysSrv';
			param.QueryName = 'QryPathWayEp';
			param.Arg1 = obj.CPWID;
			param.ArgCnt = 1;
	});
	obj.cboVarEpStore.load({});
	
	obj.cboVarEpStepStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboVarEpStepStore = new Ext.data.Store({
		proxy: obj.cboVarEpStepStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboVarEpStep = new Ext.form.ComboBox({
		id : 'cboVarEpStep'
		,width : 100
		,displayField : 'Desc'
		,minChars : 1
		,fieldLabel : '步骤'
		,store : obj.cboVarEpStepStore
		,editable : true
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'Rowid'
	});
	obj.cboVarEpStepStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.ClinPathWaysSrv';
			param.QueryName = 'QryPathWayEpStep';
			param.Arg1 = obj.cboVarEp.getValue();
			param.ArgCnt = 1;
	});
	//obj.cboVarEpStepStore.load({});
	
	obj.cboVarCategStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboVarCategStore = new Ext.data.Store({
		proxy: obj.cboVarCategStoreProxy,
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
	obj.cboVarCateg = new Ext.form.ComboBox({
		id : 'cboVarCateg'
		,width : 100
		,displayField : 'Desc'
		,minChars : 1
		,fieldLabel : '变异类型'
		,store : obj.cboVarCategStore
		,editable : true
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'Rowid'
	});
	obj.cboVarCategStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.VarianceCategory';
			param.QueryName = 'QryVarCateg';
			param.Arg1 = "V";
			param.ArgCnt = 1;
	});
	obj.cboVarCategStore.load({});
	obj.cboVarReasonStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboVarReasonStore = new Ext.data.Store({
		proxy: obj.cboVarReasonStoreProxy,
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
	obj.cboVarReason = new Ext.form.ComboBox({
		id : 'cboVarReason'
		,width : 100
		,displayField : 'Desc'
		,minChars : 1
		,fieldLabel : '变异原因'
		,store : obj.cboVarReasonStore
		,editable : true
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'Rowid'
	});
	obj.cboVarReasonStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.VarianceReason';
			param.QueryName = 'QryVarReasonNew';
			param.Arg1 = obj.cboVarCateg.getValue();
			param.ArgCnt = 1;
	});
	//obj.cboVarReasonStore.load({});
	
	obj.txtaVarResume = new Ext.form.TextArea({
		id : 'txtaVarResume'
		,height : 80
		,width : 100
		,fieldLabel : '备注'
		,anchor : '95%'
	});
	obj.btnUpdateCPWV = new Ext.Button({
		id : 'btnUpdateCPWV'
		,iconCls : 'icon-update'
		,text : '更新'
	});
	
	obj.pConditionChild1 = new Ext.Panel({
		id : 'pConditionChild1'
		,buttonAlign : 'center'
		,columnWidth : .45
		,layout : 'form'
		,items:[
			obj.cboVarEp
			,obj.cboVarEpStep
			,obj.cboVarCateg
			,obj.cboVarReason
		]
	});
	obj.pConditionChild2 = new Ext.Panel({
		id : 'pConditionChild2'
		,buttonAlign : 'center'
		,columnWidth : .45
		,layout : 'form'
		,items:[
			obj.txtVarCPW
			,obj.txtaVarResume
		]
	});
	obj.pConditionChild3 = new Ext.Panel({
		id : 'pConditionChild3'
		,buttonAlign : 'center'
		,columnWidth : .05
		,layout : 'form'
		,items:[
		]
	});
	obj.pConditionChild4 = new Ext.Panel({
		id : 'pConditionChild4'
		,buttonAlign : 'center'
		,columnWidth : .05
		,layout : 'form'
		,items:[
		]
	});
	obj.ConditionSubPanel = new Ext.form.FormPanel({
		id : 'ConditionSubPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 70
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'column'
		,frame : true
		,items:[
			obj.pConditionChild4
			,obj.pConditionChild1
			,obj.pConditionChild2
			,obj.pConditionChild3
		]
		,buttons:[
			obj.btnUpdateCPWV
		]
	});
	obj.ConditionPanel = new Ext.Panel({
		id : 'ConditionPanel'
		,height : 160
		,buttonAlign : 'center'
		,region : 'north'
		,layout : 'fit'
		,frame : true
		,items:[
			obj.ConditionSubPanel
		]
	});
	
	obj.VarSubWindow = new Ext.Window({
		id : 'VarSubWindow'
		,collapsed : true
		,buttonAlign : 'center'
		,maximized : false
		,resizable : false
		,title : '变异记录'
		,layout : 'border'
		,width : 900
		,height : 500
		,modal: true
		,items:[
			obj.gpVarianceRst
			,obj.ConditionPanel
		]
	});
	InitVarSubWindowEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}