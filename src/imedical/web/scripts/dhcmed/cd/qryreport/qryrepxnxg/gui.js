
function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode,"CD");
	obj.txtFromDate = Common_DateFieldToDate("txtFromDate","报告日期");
	obj.txtToDate = Common_DateFieldToDate("txtToDate","至");
	obj.cboRepLoc = Common_ComboToLoc("cboRepLoc","报告科室","E","","","cboHospital");
	obj.cbgRepStatus=Common_CheckboxGroupToDic("cbgRepStatus","报告状态","CRReportStatus",3);
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width: 60
		,text : '查询'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width: 60
		,text : '导出'
	});
	obj.btnExpInf = new Ext.Button({
		id : 'btnExpInf'
		,iconCls : 'icon-export'
		,width: 60
		,hidden:true
		,text : '导出接口'
	});
	
	obj.gridRepInfoStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridRepInfoStore = new Ext.data.Store({
		proxy: obj.gridRepInfoStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ReportID'
		},
		[
			{name: 'ReportID', mapping : 'ReportID'}
			,{name: 'RepTypeCode', mapping : 'RepTypeCode'}
			,{name: 'RepTypeDesc', mapping: 'RepTypeDesc'}
			,{name: 'RepStatusDesc', mapping: 'RepStatusDesc'}
			,{name: 'ReportUser', mapping: 'ReportUser'}
			,{name: 'ReportDate', mapping: 'ReportDate'}
			,{name: 'CheckUser', mapping: 'CheckUser'}
			,{name: 'CheckDate', mapping: 'CheckDate'}
			,{name: 'RepLocDesc', mapping: 'RepLocDesc'}
			,{name: 'KPBH', mapping: 'KPBH'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'MrNo', mapping: 'MrNo'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'PatSex', mapping: 'PatSex'}
			,{name: 'PatAge', mapping: 'PatAge'}
			,{name: 'ZDMC', mapping: 'ZDMC'}
			,{name: 'ZDICD', mapping: 'ZDICD'}
			,{name: 'ZDFL', mapping: 'ZDFL'}
			,{name: 'SWRQ', mapping: 'SWRQ'}
			,{name: 'ZDYJs', mapping: 'ZDYJs'}
			,{name: 'QZRQ', mapping: 'QZRQ'}
			,{name: 'EpisodeID', mapping: 'EpisodeID'}
		])
	});
	obj.gridRepInfo = new Ext.grid.EditorGridPanel({
		id : 'gridRepInfo'
		,store : obj.gridRepInfoStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,tbar : [{id:'msggridRepInfo',text:'心脑血管卡、脑卒中卡信息查询列表',style:'font-weight:bold;font-size:14px;',xtype:'label'},
				'->',obj.btnQuery,obj.btnExport,obj.btnExpInf]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '卡片编号', width: 100, dataIndex: 'KPBH', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '登记号', width: 100, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '住院号', width: 100, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '患者姓名', width: 80, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '性别', width: 40, dataIndex: 'PatSex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 40, dataIndex: 'PatAge', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '诊断', width: 120, dataIndex: 'ZDMC', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '诊断ICD', width: 80, dataIndex: 'ZDICD', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '诊断分类', width: 100, dataIndex: 'ZDFL', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '诊断依据', width: 100, dataIndex: 'ZDYJs', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '确诊日期', width: 100, dataIndex: 'QZRQ', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '报告状态', width: 80, dataIndex: 'RepStatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '报告人', width: 80, dataIndex: 'ReportUser', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '报告科室', width: 120, dataIndex: 'RepLocDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '报告日期', width: 100, dataIndex: 'ReportDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '审核人', width: 80, dataIndex: 'CheckUser', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '审核日期', width: 120, dataIndex: 'CheckDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '死亡日期', width: 100, dataIndex: 'SWRQ', sortable: false, menuDisabled:true, align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridRepInfoStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig : {
			forceFit : false
		}
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
						region: 'north',
						height: 40,
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
										,items: [obj.cboHospital]
									},{
										width : 170
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtFromDate]
									},{
										width : 130
										,layout : 'form'
										,labelAlign : 'left'
										,labelWidth : 20
										,items: [obj.txtToDate]
									},{
										width : 200
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.cboRepLoc]
									},{
										width : 250
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.cbgRepStatus]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridRepInfo
						]
					}
				]
			}
		]
	});
	
	obj.gridRepInfoStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.CDService.QryService';
		param.QueryName = 'QryXNXGRepByDate';
		param.Arg1=Common_GetValue("txtFromDate");
		param.Arg2=Common_GetValue("txtToDate");
		param.Arg3=Common_GetValue("cboHospital");
		param.Arg4=Common_GetValue("cboRepLoc");
		param.Arg5=Common_GetValue("cbgRepStatus");
		param.ArgCnt = 5;
	});

	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

