
function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.txtRegNo = Common_TextField("txtRegNo","登记号");
	obj.txtUser = Common_ComboToSSUser("txtUser","主管医生");
	obj.chkIsActive = Common_Checkbox("chkIsActive","是否有效");
	obj.txtResume = Common_TextField("txtResume","备注");
	obj.cboLoc = Common_ComboToLoc("cboLoc","报告科室","");

	obj.txtAdmInfoStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.txtAdmInfoStore = new Ext.data.Store({
		proxy: obj.txtAdmInfoStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'ind'}
			,{name: 'paadm', mapping: 'paadm'}
			,{name: 'AdmInfo', mapping: 'AdmInfo'}
		])
	});
	obj.txtAdmInfo = new Ext.form.ComboBox({
		id : 'txtAdmInfo'
		,store : obj.txtAdmInfoStore
		,minChars : 0
		,displayField : 'AdmInfo'
		,fieldLabel : '就诊信息'
		,valueField : 'paadm'
		,triggerAction : 'all'
		,anchor : '95%'
	});

	obj.gridInfUncountStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridInfUncountStore = new Ext.data.Store({
		proxy: obj.gridInfUncountStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RepID'
		},
		[
			{name: 'RepID', mapping : 'RepID'}
			,{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'AdmitDate', mapping: 'AdmitDate'}
			,{name: 'DisDate', mapping: 'DisDate'}
			,{name: 'PatientName', mapping: 'PatientName'}
			,{name: 'ReportLoc', mapping: 'ReportLoc'}
			,{name: 'DescStr', mapping: 'DescStr'}
			,{name: 'ReportUser', mapping: 'ReportUser'}
			,{name: 'UserName', mapping: 'UserName'}
			,{name: 'ResumeText', mapping: 'ResumeText'}
			,{name: 'Active', mapping: 'Active'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'AdmInfo', mapping: 'AdmInfo'}
		])
	});
	obj.gridInfUncount = new Ext.grid.EditorGridPanel({
		id : 'gridInfUncount'
		,store : obj.gridInfUncountStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: '漏报科室', width: 80, dataIndex: 'DescStr', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '患者姓名', width: 150, dataIndex: 'PatientName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '入院日期', width: 100, dataIndex: 'AdmitDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '出院日期', width: 100, dataIndex: 'DisDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '主管医生', width: 50, dataIndex: 'UserName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '是否有效', width: 100, dataIndex: 'Active', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 200, dataIndex: 'ResumeText', sortable: false, menuDisabled:true, align: 'center'}

		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-edit'
		,width: 80
		,text : '更新'
	});
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'fit'
		,items:[
			{
				region: 'center',
				layout : 'border',
				frame : true,
				items : [
					{
						//update by likai for bug:3851
						region: 'south',
						height: 70,
						layout : 'form',
						frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										width : 200
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtRegNo]
									},{
										columnWidth:1
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										//,boxMinWidth : 150
										//,boxMaxWidth : 200
										,items: [obj.txtAdmInfo]
									},{
										width : 200
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.cboLoc]
									},{
										width : 200
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtUser]
									},{
										width : 90
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.chkIsActive]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										width : 90
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.chkIsActive]
									},{
										columnWidth:1
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtResume]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridInfUncount
						]
					}
				],
				bbar : [obj.btnUpdate]
			}
		]
	});
	
	obj.gridInfUncountStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.InfUncount';
		param.QueryName = 'QueryInfUncountInfo';
		param.ArgCnt = 0;
	});

	obj.txtAdmInfoStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.InfUncount';
		param.QueryName = 'QueryAdmInfoByPatNo';
		param.Arg1 = obj.txtRegNo.getValue();
		param.ArgCnt = 1;
	});	

	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

