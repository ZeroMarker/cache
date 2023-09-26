
function InitViewport1(){
	var obj = new Object();
	obj.RecRowID="";
	obj.AdminPower  = '0';
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	}
	
	obj.cboObsLoc = Common_ComboToLoc("cboObsLoc","科室","","","","");
	obj.txtObsDate = Common_DateFieldToDate("txtObsDate","日期");
	obj.cboObsUser = Common_ComboToSSUser("cboObsUser","观察员");
	obj.cbgStIdentity = Common_RadioGroupToDic("cbgStIdentity","专业","NINFHandHyStIdentity",2);
	obj.txtStName = Common_TextField("txtStName","工号/姓名");
	obj.cbgPoint = Common_RadioGroupToDic("cbgPoint","手卫生指针","NINFHandHyPoint",1);
	obj.cbgAction = Common_RadioGroupToDic("cbgAction","手卫生措施","NINFHandHyAction",2);
	obj.cbgActionRit = Common_RadioGroupToDic("cbgActionRit","洗手正确性","NINFHandHyActionRit",2);
	obj.txtResume = Common_TextArea("txtResume","备注",50);
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-save'
		,width : 60
		,height : 25
		,text : '保存'
	})
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-Delete'
		,width: 60
		,height : 25
		,text : '删除'
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 60
		,height : 25
		,text : '查询'
	})
	
	obj.gridHandHyReportStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridHandHyReportStore = new Ext.data.Store({
		proxy: obj.gridHandHyReportStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ReportID'
		},
		[
			{name: 'ReportID', mapping : 'ReportID'}
			,{name: 'ObsLocID', mapping : 'ObsLocID'}
			,{name: 'ObsLocDesc', mapping: 'ObsLocDesc'}
			,{name: 'ObsDate', mapping: 'ObsDate'}
			,{name: 'ObsTime', mapping: 'ObsTime'}
			,{name: 'ObsUserID', mapping: 'ObsUserID'}
			,{name: 'ObsUserDesc', mapping: 'ObsUserDesc'}
			,{name: 'StIdentityID', mapping: 'StIdentityID'}
			,{name: 'StIdentityDesc', mapping: 'StIdentityDesc'}
			,{name: 'StName', mapping: 'StName'}
			,{name: 'PointID', mapping: 'PointID'}
			,{name: 'PointDesc', mapping: 'PointDesc'}
			,{name: 'ActionID', mapping: 'ActionID'}
			,{name: 'ActionDesc', mapping: 'ActionDesc'}
			,{name: 'ActionRitID', mapping: 'ActionRitID'}
			,{name: 'ActionRitDesc', mapping: 'ActionRitDesc'}
			,{name: 'RepDate', mapping: 'RepDate'}
			,{name: 'RepTime', mapping: 'RepTime'}
			,{name: 'RepLocID', mapping: 'RepLocID'}
			,{name: 'RepLocDesc', mapping: 'RepLocDesc'}
			,{name: 'RepUserID', mapping: 'RepUserID'}
			,{name: 'RepUserDesc', mapping: 'RepUserDesc'}
			,{name: 'RepStatusID', mapping: 'RepStatusID'}
			,{name: 'RepStatusCode', mapping: 'RepStatusCode'}
			,{name: 'RepStatusDesc', mapping: 'RepStatusDesc'}
			,{name: 'RepResume', mapping: 'RepResume'}
		])
	});
	obj.gridHandHyReport = new Ext.grid.EditorGridPanel({
		id : 'gridHandHyReport'
		,store : obj.gridHandHyReportStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		//,frame : true
		,columns: [
			{header: '科室', width: 120, dataIndex: 'ObsLocDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '日期', width: 80, dataIndex: 'ObsDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '观察员', width: 80, dataIndex: 'ObsUserDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '专业', width: 60, dataIndex: 'StIdentityDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '姓名/工号', width: 80, dataIndex: 'StName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '手卫生指针', width: 100, dataIndex: 'PointDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '手卫生措施', width: 80, dataIndex: 'ActionDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '洗手<br>正确性', width: 60, dataIndex: 'ActionRitDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '报告状态', width: 80, dataIndex: 'RepStatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '填报日期', width: 80, dataIndex: 'RepDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '填报时间', width: 60, dataIndex: 'RepTime', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 200, dataIndex: 'RepResume', sortable: false, menuDisabled:true, align: 'left'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.gridHandHyReportStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
    });
	
	
	obj.Condition_ViewPort = {
		//title : '',
		//layout : 'fit',
		//frame : true,
		height : 680,
		anchor : '-20',
		items : [
			{
				width: 300
				,layout : 'form'
				,frame : true
				,labelAlign : 'right'
				,labelWidth : 80
				,items : [
					obj.cboObsLoc
					,obj.txtObsDate
					,obj.cboObsUser
					,obj.cbgStIdentity
					,obj.txtStName
					,obj.cbgPoint
					,obj.cbgAction
					,obj.cbgActionRit
					,obj.txtResume
					,{
						layout : 'form'
						,buttonAlign : 'center'
						,buttons : [obj.btnQuery,obj.btnUpdate,obj.btnDelete]
					}
				]
			}
		]
	}
	
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			{
				region: 'east'
				,width: 330
				,frame : true
				,autoScroll : true
				,items : [
					obj.Condition_ViewPort
				]
			},{
				region: 'center'
				,layout : 'fit'
				,frame : true
				,items : [
					obj.gridHandHyReport
				]
			}
		]
	});
	
	obj.gridHandHyReportStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.HandHyReport';
		param.QueryName = 'QryHandHyRep';
		param.Arg1 = Common_GetValue('txtObsDate');
		param.Arg2 = Common_GetValue('txtObsDate');
		param.Arg3 = Common_GetValue('cboObsLoc');
		param.Arg4 = '0|1|2|3|4';
		param.ArgCnt = 4;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

