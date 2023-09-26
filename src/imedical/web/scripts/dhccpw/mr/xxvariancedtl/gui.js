
function InitVarianceViewport(){
	var obj = new Object();
	obj.DateFrom="";
	obj.DateTo="";
	obj.LocID="";
	obj.WardID="";
	obj.dfDateFrom = new Ext.form.DateField({
		id : 'dfDateFrom'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : '开始日期'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		,value : new Date()
	});
	obj.pConditionChild1 = new Ext.Panel({
		id : 'pConditionChild1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.dfDateFrom
		]
	});
	obj.dfDateTo = new Ext.form.DateField({
		id : 'dfDateTo'
		,width : 100
		,fieldLabel : '结束日期'
		,altFormats : 'Y-m-d|d/m/Y'
		,format : 'Y-m-d'
		,anchor : '99%'
		,value : new Date()
	});
	obj.pConditionChild2 = new Ext.Panel({
		id : 'pConditionChild2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.dfDateTo
		]
	});
	obj.cboLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboLocStore = new Ext.data.Store({
		proxy: obj.cboLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocCode', mapping: 'CTLocCode'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
	obj.cboLoc = new Ext.form.ComboBox({
		id : 'cboLoc'
		,width : 100
		,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'CTLocDesc'
		,fieldLabel : '科室'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'CTLocID'
	});
	obj.pConditionChild3 = new Ext.Panel({
		id : 'pConditionChild4'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.cboLoc
		]
	});
	obj.cboWardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboWardStore = new Ext.data.Store({
		proxy: obj.cboWardStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocCode', mapping: 'CTLocCode'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
	obj.cboWard = new Ext.form.ComboBox({
		id : 'cboWard'
		,width : 100
		,store : obj.cboWardStore
		,minChars : 1
		,displayField : 'CTLocDesc'
		,fieldLabel : '病区'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'CTLocID'
	});
	obj.pConditionChild4 = new Ext.Panel({
		id : 'pConditionChild5'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.cboWard
		]
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,width : 80
		,clearCls : 'icon-find'
		,text : '查询'
		,disabled : false
	});
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
	    ,text: '导出EXCEL'
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
			obj.pConditionChild1
			,obj.pConditionChild2
			//,obj.pConditionChild3
			//,obj.pConditionChild4
		]
		,buttons:[
			obj.btnQuery
			,obj.btnExport
		]
	});
	obj.ConditionPanel = new Ext.Panel({
		id : 'ConditionPanel'
		,height : 100
		,buttonAlign : 'center'
		,region : 'north'
		,layout : 'fit'
		,title : '病情变异明细'
		,items:[
			obj.ConditionSubPanel
		]
	});
	obj.ResultGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
			,timeout: 3000000
			,method:'POST'
		}));
	obj.ResultGridPanelStore = new Ext.data.Store({
		proxy: obj.ResultGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'IndVarDtl'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'IndVarDtl', mapping : 'IndVarDtl'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'PapmiNo', mapping : 'PapmiNo'}
			,{name: 'InMedicare', mapping : 'InMedicare'}
			,{name: 'PatName', mapping : 'PatName'}
			,{name: 'Sex', mapping : 'Sex'}
			,{name: 'Birthday', mapping : 'Birthday'}
			,{name: 'Age', mapping : 'Age'}
			,{name: 'PersonalID', mapping : 'PersonalID'}
			,{name: 'AdmitDate', mapping : 'AdmitDate'}
			,{name: 'AdmitTime', mapping : 'AdmitTime'}
			,{name: 'DisDate', mapping : 'DisDate'}
			,{name: 'DisTime', mapping : 'DisTime'}
			,{name: 'AdmLoc', mapping : 'AdmLoc'}
			,{name: 'AdmWard', mapping : 'AdmWard'}
			,{name: 'AdmRoom', mapping : 'AdmRoom'}
			,{name: 'AdmBed', mapping : 'AdmBed'}
			,{name: 'AdmDoc', mapping : 'AdmDoc'}
			,{name: 'AdmStatus', mapping : 'AdmStatus'}
			,{name: 'AdmDays', mapping : 'AdmDays'}
			,{name: 'CountCost', mapping : 'CountCost'}
			,{name: 'DrugRatio', mapping : 'DrugRatio'}
			,{name: 'CPWDesc', mapping : 'CPWDesc'}
			,{name: 'CPWStatus', mapping : 'CPWStatus'}
			,{name: 'CPWStepDesc', mapping : 'CPWStepDesc'}
			,{name: 'CPWVarType', mapping : 'CPWVarType'}
			,{name: 'CPWItemDesc', mapping : 'CPWItemDesc'}
			,{name: 'OEItemDesc', mapping : 'OEItemDesc'}
			,{name: 'OEItemDate', mapping : 'OEItemDate'}
			,{name: 'OEItemTime', mapping : 'OEItemTime'}
			,{name: 'CPWVarDesc', mapping : 'CPWVarDesc'}
		])
	});
	obj.ResultGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.ResultGridPanel = new Ext.grid.GridPanel({
		id : 'ResultGridPanel'
		,loadMask : true
		,store : obj.ResultGridPanelStore
		,region : 'center'
		,frame : true
		,buttonAlign : 'center'
		,columns: [
			//new Ext.grid.RowNumberer()
			{header: '序号', width: 80, dataIndex: 'IndVarDtl', sortable: true}
			,{header: '登记号', width: 80, dataIndex: 'PapmiNo', sortable: true}
			,{header: '病案号', width: 80, dataIndex: 'InMedicare', sortable: true}
			,{header: '姓名', width: 80, dataIndex: 'PatName', sortable: true}
			,{header: '性别', width: 50, dataIndex: 'Sex', sortable: true}
			,{header: '年龄', width: 50, dataIndex: 'Age', sortable: true}
			,{header: '路径名称', width: 120, dataIndex: 'CPWDesc', sortable: true}
			,{header: '路径<br>状态', width: 50, dataIndex: 'CPWStatus', sortable: true}
			,{header: '步骤名称', width: 80, dataIndex: 'CPWStepDesc', sortable: true}
			,{header: '变异类型', width: 100, dataIndex: 'CPWVarType', sortable: true}
			,{header: '路径项目', width: 100, dataIndex: 'CPWItemDesc', sortable: true}
			,{header: '医嘱名称', width: 150, dataIndex: 'OEItemDesc', sortable: true}
			,{header: '医嘱日期', width: 80, dataIndex: 'OEItemDate', sortable: true}
			,{header: '医嘱时间', width: 80, dataIndex: 'OEItemTime', sortable: true}
			,{header: '变异原因', width: 150, dataIndex: 'CPWVarDesc', sortable: true}
			,{header: '入院日期', width: 80, dataIndex: 'AdmitDate', sortable: true}
			,{header: '入院时间', width: 80, dataIndex: 'AdmitTime', sortable: true}
			,{header: '出院日期', width: 80, dataIndex: 'DisDate', sortable: true}
			,{header: '出院时间', width: 80, dataIndex: 'DisTime', sortable: true}
			,{header: '住院天数', width: 50, dataIndex: 'AdmDays', sortable: true}
			,{header: '住院费用', width: 80, dataIndex: 'CountCost', sortable: true}
			,{header: '药费比例', width: 80, dataIndex: 'DrugRatio', sortable: true}
			,{header: '出院状态', width: 60, dataIndex: 'AdmStatus', sortable: true}
			,{header: '科室', width: 100, dataIndex: 'AdmLoc', sortable: true}
			,{header: '病区', width: 100, dataIndex: 'AdmWard', sortable: true}
			,{header: '医生', width: 80, dataIndex: 'AdmDoc', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 1000,
			store : obj.ResultGridPanelStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
	});
	obj.VarianceViewport = new Ext.Viewport({
		id : 'VarianceViewport'
		,region : document.body
		,layout : 'border'
		,items:[
			obj.ConditionPanel
			,obj.ResultGridPanel
		]
	});
	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.SysBaseSrv';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = obj.cboLoc.getRawValue();
			param.Arg2 = 'E';
			param.Arg3 = '';
			param.ArgCnt = 3;
	});
	//obj.cboLocStore.load({});
	obj.cboWardStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.SysBaseSrv';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = obj.cboWard.getRawValue();
			param.Arg2 = 'W';
			param.Arg3 = '';
			param.ArgCnt = 3;
	});
	//obj.cboWardStore.load({});
	obj.ResultGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.ClinPathWaysVarianceDtl';
			param.QueryName = 'QryVarianceDtl';
			param.Arg1 = obj.dfDateFrom.getRawValue();
			param.Arg2 = obj.dfDateTo.getRawValue();
			param.Arg3 = "";
			param.ArgCnt = 3;
			
			obj.DateFrom=obj.dfDateFrom.getRawValue();
			obj.DateTo=obj.dfDateTo.getRawValue();
	});
	InitVarianceViewportEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}

