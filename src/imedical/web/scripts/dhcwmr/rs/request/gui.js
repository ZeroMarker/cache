function InitviewScreen(){
    var obj = new Object();
	obj.Patient = new Object();
	obj.Volume = new Object();
	obj.MrType = ""
	
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.txtMrNo = Common_TextField("txtMrNo","病案号");
	obj.txtPapmiNo = Common_TextField("txtPapmiNo","登记号");
	obj.txtPatName = Common_TextField("txtPatName","姓名");
	obj.txtSex = Common_TextField("txtSex","性别");
	obj.txtAge = Common_TextField("txtAge","年龄");
	obj.txtIdentityCode = Common_TextField("txtIdentityCode","身份证号");
	
	obj.txtHName = Common_TextField("txtHName","男方姓名");
	obj.txtMarker = Common_TextField("txtMarker","状态标记");
	obj.txtFileNo = Common_TextField("txtFileNo","上架号");

	obj.cboReqType = Common_ComboToDic("cboReqType","申请类型","RepType");

	obj.RsStatusPanel = new Ext.Panel({
		region: 'center'
		,height : 40
		,layout : 'form'
		,html:'<div id="RsStatusDiv" style="text-align:center;width:100%;font-weight:bold;font-size:14px;"></div>'
	});
	
	obj.cboLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
	obj.cboLocStore = new Ext.data.Store({
		proxy: obj.cboLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'LocID'
		},[
			{name: 'LocID', mapping : 'LocID'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
		])
	});
	
	obj.cboLoc = new Ext.form.ComboBox({
		id : 'cboLoc'
		,fieldLabel : '申请科室'
		,store : obj.cboLocStore
		,minChars : 1
		,valueField : 'LocID'
		,displayField : 'LocDesc'
		,editable : false
		,disabled : true
		,triggerAction : 'all'
		,width : 80
		,anchor : '100%'
	});

	obj.cboUserStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
	obj.cboUserStore = new Ext.data.Store({
		proxy: obj.cboUserStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'UserID'
		},[
			{name: 'UserID', mapping : 'UserID'}
			,{name: 'UserDesc', mapping: 'UserDesc'}
		])
	});
	
	obj.cboUser = new Ext.form.ComboBox({
		id : 'cboUser'
		,fieldLabel : '申请人'
		,store : obj.cboUserStore
		,minChars : 1
		,valueField : 'UserID'
		,displayField : 'UserDesc'
		,editable : false
		,disabled : true
		,triggerAction : 'all'
		,width : 80
		,anchor : '100%'
	});

	obj.btnConsult = new Ext.Button({
		id : 'btnConsult'
		,iconCls : 'icon-new'
		,width : 80
		,anchor : '100%'
		,text : '提交申请'
	});

	obj.RepListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.RepListStore = new Ext.data.Store({
		proxy: obj.RepListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RquestID'
		},[
			{name: 'RquestID', mapping : 'RquestID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'EpisodeID', mapping: 'EpisodeID'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'VolumeID', mapping: 'VolumeID'}
			,{name: 'VolumeStatusDr', mapping: 'VolumeStatusDr'}
			,{name: 'VolumeStatus', mapping: 'VolumeStatus'}
			,{name: 'ReqLoc', mapping: 'ReqLoc'}
			,{name: 'ReqLocDesc', mapping: 'ReqLocDesc'}
			,{name: 'ReqUser', mapping: 'ReqUser'}
			,{name: 'ReqUserDesc', mapping: 'ReqUserDesc'}
			,{name: 'ReqStatus', mapping: 'ReqStatus'}
			,{name: 'ReqStatusDesc', mapping: 'ReqStatusDesc'}
			,{name: 'ReqDate', mapping: 'ReqDate'}
			,{name: 'ReqTime', mapping: 'ReqTime'}
			,{name: 'UpdateDate', mapping: 'UpdateDate'}
			,{name: 'UpdateTime', mapping: 'UpdateTime'}
			,{name: 'UpdateUser', mapping: 'UpdateUser'}
			,{name: 'UpdateUserDesc', mapping: 'UpdateUserDesc'}
			,{name: 'ReqTypeDesc', mapping: 'ReqTypeDesc'}
		])
	});

	obj.RepList = new Ext.grid.GridPanel({
		id : 'RepList'
		,store : obj.RepListStore
		,columnLines : true
		,region : 'center'
		,layout: 'fit'
		,buttonAlign:'center'
		,tbar:[{id:'msgRsRepList',text:'门诊病案申请记录',style:'font-weight:bold;font-size:14px;',xtype:'label'}]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '姓名', width: 80, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '登记号', width: 80, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '性别', width: 80, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 70, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '病历状态', width: 70, dataIndex: 'VolumeStatus', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '申请人', width: 70, dataIndex: 'ReqUserDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '申请科室', width: 70, dataIndex: 'ReqLocDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '申请类型', width: 70, dataIndex: 'ReqTypeDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '申请时间', width: 70, dataIndex: 'ReqTime', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '审核时间', width: 70, dataIndex: 'UpdateTime', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.Viewport = new Ext.Viewport({
		id: 'Viewport'
		,layout: 'border'
		,frame: true
		,items:[
			{
			region: 'north'
			,height: 120
			,frame: true
			,layout: 'border'
			,items:[
				{
					region: 'north'
					,height : 90
					,layout : 'column'
					,items: [
						{
							width: 200
							,layout : 'form'
							,labelAlign : 'right'
							,labelWidth : 70
							,items:[obj.cboHospital,obj.txtPatName,obj.txtHName]
						},{
							width: 200
							,layout : 'form'
							,labelAlign : 'right'
							,labelWidth : 70
							,items:[obj.cboMrType,obj.txtSex,obj.txtMarker]
						},{
							width: 200
							,layout : 'form'
							,labelAlign : 'right'
							,labelWidth : 70
							,items:[obj.txtMrNo,obj.txtAge,obj.txtFileNo]
						},{
							width: 220
							,layout : 'form'
							,labelAlign : 'right'
							,labelWidth : 70
							,items:[
								obj.txtPapmiNo,
								obj.txtIdentityCode	
							]
						}
					]
				},
				obj.RsStatusPanel
			]
			},
			obj.RepList
			,{
				region: 'south'
				,height: 80
				,frame: true
				,layout: 'column'
				,buttonAlign: 'center'
				,items:[
					{
						layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,columnWidth : .2
					},{
						layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,columnWidth : .2
						,items : [obj.cboLoc]
					},{
						layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,columnWidth : .2
						,items : [obj.cboUser]
					},{
						layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,columnWidth : .2
						,items : [obj.cboReqType]
					}
				]
				,buttons: [obj.btnConsult]
			}
		]
	});
	
	obj.RepListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.RsRquestSrv';
			param.QueryName = 'QryRsRquest';
			param.Arg1 = new Date();
			param.Arg2 = new Date();
			param.Arg3 = "";
			param.Arg4 = session['LOGON.CTLOCID'];
			param.Arg5 = session['LOGON.USERID'];
			param.ArgCnt = 5;
	});
	
	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.LocGroupSrv';
		param.QueryName = 'QryCboLocList';
		param.Arg1 = Common_GetValue('cboHospital');
		param.Arg2 = "-";
		param.Arg3 = obj.cboLoc.getRawValue();
		param.ArgCnt = 3;
	});

	InitviewScreenEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}