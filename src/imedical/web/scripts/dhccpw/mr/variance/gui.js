 
function InitMainViewport(){
	var obj = new Object();
	obj.CurrClinPathWay = null;
	obj.CurrCPWVariance = null;
	obj.CurrLogon = Load_DHCLogon();
	obj.CurrPaPerson = Load_DHCPaPerson(PatientID);
	obj.CurrPAADM = Load_DHCPAADM(EpisodeID);
	
	//***************************************************************
	//SubPanel2 当前临床路径部分内容
	//***************************************************************
	obj.SubPanel2 = new Ext.Panel({
		id : 'SubPanel2'
		,buttonAlign : 'center'
		,layout : 'fit'
		,title : '当前临床路径'
		,region : 'west'
		,width : 300
		,frame : true
		,items:[
			//panelTree
		]
	});
	//***************************************************************
	//SubPanel5 变异记录列表部分内容
	//***************************************************************
	obj.SubPanel5StoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.SubPanel5Store = new Ext.data.Store({
		proxy: obj.SubPanel5StoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'VID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'VID', mapping: 'VID'}
			,{name: 'VEpisodeDR', mapping: 'VEpisodeDR'}
			,{name: 'VEpisodeDesc', mapping: 'VEpisodeDesc'}
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
	obj.SubPanel5CheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.SubPanel5 = new Ext.grid.GridPanel({
		id : 'SubPanel5'
		,store : obj.SubPanel5Store
		,region : 'center'
		,frame : true
		,buttonAlign : 'center'
		,viewConfig : {forceFit:true}
		,title : '变异记录列表'
		,columns: [
			{header: '阶段', width: 100, dataIndex: 'VEpisodeDesc', sortable: false}
			,{header: '确认医生', width: 60, dataIndex: 'VDoctorDesc', sortable: false}
			,{header: '变异类型', width: 100, dataIndex: 'VCategoryDesc', sortable: false}
			,{header: '变异原因', width: 100, dataIndex: 'VReasonDesc', sortable: false}
			,{header: '更新人', width: 60, dataIndex: 'VUserDesc', sortable: false}
			,{header: '更新日期', width: 80, dataIndex: 'VDate', sortable: true}
			,{header: '更新时间', width: 60, dataIndex: 'VTime', sortable: false}
			,{header: '备注', width: 300, dataIndex: 'VNote', sortable: false}
		]
	});
	obj.SubPanel5StoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCCPW.MR.ClinPathWaysVariance';
				param.QueryName = 'QryVarianceByCPW';
				if (obj.CurrClinPathWay){
					param.Arg1 = obj.CurrClinPathWay.Rowid;
				}else{
					param.Arg1 = "";
				}
				param.ArgCnt = 1;
	});
	//obj.SubPanel5Store.load({});
	//***************************************************************
	//SubPanel6 变异记录操作部分内容
	//***************************************************************
	obj.txtVarEp = new Ext.form.TextField({
		id : 'txtVarEp'
		,width : 100
		,fieldLabel : '阶段'
		,anchor : '98%'
		,readOnly : true
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
		,anchor : '98%'
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
		,anchor : '98%'
		,valueField : 'Rowid'
	});
	obj.cboVarReasonStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.VarianceReason';
			param.QueryName = 'QryVarReasonNew';
			param.Arg1 = obj.cboVarCateg.getValue();
			param.ArgCnt = 1;
	});
	obj.cboVarReasonStore.load({});
	obj.txtaVarResume = new Ext.form.TextArea({
		id : 'txtaVarResume'
		,height : 100
		,width : 100
		,fieldLabel : '备注'
		,anchor : '98%'
	});
	obj.cboAuditDoctorStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboAuditDoctorStore = new Ext.data.Store({
		proxy: obj.cboAuditDoctorStoreProxy,
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
	obj.cboAuditDoctor = new Ext.form.ComboBox({
		id : 'cboAuditDoctor'
		,width : 100
		,displayField : 'Desc'
		,minChars : 1
		,fieldLabel : '确认医生'
		,store : obj.cboAuditDoctorStore
		,editable : true
		,triggerAction : 'all'
		,anchor : '98%'
		,valueField : 'Rowid'
	});
	obj.cboAuditDoctorStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.CTCareProvSrv';
			param.QueryName = 'QryCareProvByName';
			param.Arg1 = obj.cboAuditDoctor.getRawValue();
			param.Arg2 = '';
			param.ArgCnt = 2;
	});
	//obj.cboAuditDoctorStore.load({});
	obj.txtAuditPassword = new Ext.form.Hidden({
		id : 'txtAuditPassword'
		,width : 'auto'
		,fieldLabel : '密码'
		,anchor : '98%'
		,inputType : 'password'
	});
	
	obj.btnUpdateCPWV = new Ext.Button({
		id : 'btnUpdateCPWV'
		,iconCls : 'icon-edit'
		,disabled : true
		,text : '更新'
	});
	obj.btnAuditCPWV = new Ext.Button({
		id : 'btnAuditCPWV'
		,iconCls : 'icon-pro'
		,disabled : true
		,text : '医生确认'
	});
	obj.SubFormPanel6 = new Ext.form.FormPanel({
		id : 'SubFormPanel6'
		,buttonAlign : 'center'
		,bodyStyle : 'padding:0 0 0 0'
		,labelAlign : 'right'
		,labelWidth : 70
		,items:[
			obj.txtVarEp
			,obj.cboVarCateg
			,obj.cboVarReason
			//,obj.cboAuditDoctor
			,obj.txtaVarResume
			//,obj.txtAuditPassword
		],buttons:[
			obj.btnUpdateCPWV
			//,obj.btnAuditCPWV
		]
	});
	obj.SubPanel6 = new Ext.Panel({
		id : 'SubPanel6'
		,buttonAlign : 'center'
		,frame : true
		,region : 'south'
		,layout : 'fit'
		,height : 280
		,items:[
			obj.SubFormPanel6
		]
	});
	//***************************************************************
	//MainPanel+MainViewPort 整个窗体内容
	//***************************************************************
	obj.TitleLabel = new Ext.form.Label({
		id : 'TitleLabel'
		,frame : true
		,text : ''
		,height : 30
	});
	obj.TitlePanel = new Ext.Panel({
		id : 'TitlePanel'
		,buttonAlign : 'center'
		,region : 'north'
		,frame : true
		,layout : 'fit'
		//,items:[
			//obj.TitleLabel
		//]
	})
	obj.MainPanel = new Ext.Panel({
		id : 'MainPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,frame : true
		,layout : 'border'
		,items:[
			obj.SubPanel5
			,obj.SubPanel6
		]
	});
	obj.MainViewport = new Ext.Viewport({
		id : 'MainViewport'
		,layout : 'border'
		,renderTo : document.body
		,items:[
			obj.TitlePanel
			,obj.SubPanel2
			,obj.MainPanel
		]
	});
	InitMainViewportEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}