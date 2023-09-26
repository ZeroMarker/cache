
function InitVarWindow(){
	var obj = new Object();
	obj.EpisodeID=ExtTool.GetParam(window,"EpisodeID");
	obj.PathWayID=ExtTool.GetParam(window,"PathWayID");
	obj.EpStepID=ExtTool.GetParam(window,"EpStepID");
	obj.ArcimIDs=ExtTool.GetParam(window,"ArcimIDs");
	obj.UserID=ExtTool.GetParam(window,"UserID");
	obj.ArcimsOutFormRstStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ArcimsOutFormRstStore = new Ext.data.Store({
		proxy: obj.ArcimsOutFormRstStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'OEItemID'
		}, 
		[
			{name: 'ArcimID', mapping: 'ArcimID'}
			,{name: 'ArcimDesc', mapping: 'ArcimDesc'}
		])
	});
	obj.ArcimsOutFormRst = new Ext.grid.GridPanel({
		id : 'ArcimsOutFormRst'
		,store : obj.ArcimsOutFormRstStore
		,region : 'center'
		,frame : true
		,buttonAlign : 'center'
		,viewConfig : {forceFit:true}
		//,title : '表单外医嘱'
		,region : 'center'
		,columns: [
			{header: '医嘱名称', width: 300, dataIndex: 'ArcimDesc', sortable: false}
		]
	});
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
		,anchor : '100%'
		,valueField : 'Rowid'
		,listeners:{
			 select:function(){obj.cboVarReasonStore.load({});}   //add by wangcs 2012-12-20 选择变异类型加载变异原因
			}
	});
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
		,anchor : '100%'
		,valueField : 'Rowid'
	});
	
	obj.txtaVarResume = new Ext.form.TextArea({
		id : 'txtaVarResume'
		,height : 40
		,width : 100
		,fieldLabel : '原因备注'
		,anchor : '100%'
	});
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-new'
		,text : '确定'
	});
	obj.btnClose = new Ext.Button({
		id : 'btnClose'
		,iconCls : 'icon-exit'
		,text : '退出'
	});
	obj.VarPanel = new Ext.Panel({
		id : 'VarPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'form'
		,frame : true
		,region : 'south'
		,height : 150
		,items:[
			obj.cboVarCateg
			,obj.cboVarReason
			,obj.txtaVarResume
		]
		,buttons:[
			obj.btnUpdate
			,obj.btnClose
		]
	});
	
	obj.VarWindow = new Ext.Viewport({
		id : 'VarWindow'
		,region : document.body
		,layout : 'border'
		,items:[
			obj.ArcimsOutFormRst
			,obj.VarPanel
		]
	});
	obj.ArcimsOutFormRstStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCCPW.MR.ClinPathWaysVariance';
				param.QueryName = 'QryArcimsOutForm';
				param.Arg1 = obj.ArcimIDs;
				param.ArgCnt = 1;
	});
	obj.ArcimsOutFormRstStore.load({});
	obj.cboVarCategStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.VarianceCategory';
			param.QueryName = 'QryVarCateg';
			param.Arg1 = "V";
			param.ArgCnt = 1;
	});
	obj.cboVarCategStore.load({});
	obj.cboVarReasonStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.VarianceReason';
			param.QueryName = 'QryVarReasonNew';
			param.Arg1 = obj.cboVarCateg.getValue();
			param.ArgCnt = 1;
	});
	//obj.cboVarReasonStore.load({});
	
	InitVarWindowEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}

