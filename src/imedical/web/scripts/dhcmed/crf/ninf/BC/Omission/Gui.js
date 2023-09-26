
function InitViewport1(){
	var obj = new Object();
	
	obj.txtDateFrom = Common_DateFieldToDate("txtDateFrom","开始日期");
	obj.txtDateTo = Common_DateFieldToDate("txtDateTo","结束日期");
	obj.cboTargetLoc = Common_ComboToLoc("cboTargetLoc","科室","E","cboTargetWard","I","");
	obj.cboTargetWard = Common_ComboToLoc("cboTargetWard","病区","W","cboTargetLoc","","");
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 70
		,text : '查询'
	});
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 70
		,text : '导出'
	});
	
	obj.gridCasesXStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridCasesXStore = new Ext.data.Store({
		proxy: obj.gridCasesXStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'HandleID'
		},
		[
			{name: 'HandleID', mapping : 'HandleID'}
			,{name: 'Paadm', mapping : 'Paadm'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'PersonalID', mapping: 'PersonalID'}
			,{name: 'AdmitDate', mapping: 'AdmitDate'}
			,{name: 'AdmitTime', mapping: 'AdmitTime'}
			,{name: 'DisDate', mapping: 'DisDate'}
			,{name: 'DisTime', mapping: 'DisTime'}
			,{name: 'AdmLoc', mapping: 'AdmLoc'}
			,{name: 'AdmWard', mapping: 'AdmWard'}
			,{name: 'AdmRoom', mapping: 'AdmRoom'}
			,{name: 'AdmBed', mapping: 'AdmBed'}
			,{name: 'AdmDoc', mapping: 'AdmDoc'}
			,{name: 'AdmDays', mapping: 'AdmDays'}
			,{name: 'AdmType', mapping: 'AdmType'}
			,{name: 'CurrStatus', mapping: 'CurrStatus'}
			,{name: 'Operation', mapping: 'Operation'}
			,{name: 'ActDate', mapping: 'ActDate'}
			,{name: 'ActTime', mapping: 'ActTime'}
			,{name: 'ActUser', mapping: 'ActUser'}
			,{name: 'TargetDept', mapping: 'TargetDept'}
			,{name: 'TargetWard', mapping: 'TargetWard'}
			,{name: 'Opinion', mapping: 'Opinion'}
		])
	});
	obj.gridCasesX = new Ext.grid.EditorGridPanel({
		id : 'gridCasesX'
		,store : obj.gridCasesXStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,contextMenu : obj.mnuMenu
		,region : 'center'
		,loadMask : true
		//,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '登记号', width: 80, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '姓名', width: 60, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '性别', width: 50, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 50, dataIndex: 'Age', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '目标科室', width: 120, dataIndex: 'TargetDept', sortable: true, menuDisabled:true, align: 'left'}
			,{header: '目标病区', width: 120, dataIndex: 'TargetWard', sortable: true, menuDisabled:true, align: 'left'}
			,{header: '当前状态', width: 60, dataIndex: 'CurrStatus', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '处置状态', width: 60, dataIndex: 'Operation', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '处置日期', width: 80, dataIndex: 'ActDate', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '处置时间', width: 60, dataIndex: 'ActTime', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '处置人', width: 60, dataIndex: 'ActUser', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '处置意见', width: 200, dataIndex: 'Opinion', sortable: true, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '入院日期', width: 80, dataIndex: 'AdmitDate', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '出院日期', width: 80, dataIndex: 'DisDate', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '科室', width: 120, dataIndex: 'AdmLoc', sortable: true, menuDisabled:true, align: 'left'}
			,{header: '病区', width: 120, dataIndex: 'AdmWard', sortable: true, menuDisabled:true, align: 'left'}
			,{header: '床位', width: 60, dataIndex: 'AdmBed', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '主管医生', width: 60, dataIndex: 'AdmDoc', sortable: true, menuDisabled:true, align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.gridCasesXStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
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
					obj.gridCasesX,
					{
						region: 'north',
						height: 35,
						layout : 'form',
						frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										width : 180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtDateFrom]
									},{
										width : 180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtDateTo]
									},{
										columnWidth:.50
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,boxMinWidth : 150
										,boxMaxWidth : 240
										,items: [obj.cboTargetLoc]
									},{
										columnWidth:.50
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,boxMinWidth : 150
										,boxMaxWidth : 240
										,items: [obj.cboTargetWard]
									},{
										width : 10
									},{
										width : 75
										,layout : 'form'
										,items: [obj.btnQuery]
									},{
										width : 10
									},{
										width : 75
										,layout : 'form'
										,items: [obj.btnExport]
									}
								]
							}
						]
					}
				]
			}
		]
	});
	
	obj.gridCasesXStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.BC.OmissionSrv';
		param.QueryName = 'QryInfQmission';
		param.Arg1 = SubjectCode;
		param.Arg2 = Common_GetValue('txtDateFrom');
		param.Arg3 = Common_GetValue('txtDateTo');
		param.Arg4 = Common_GetValue('cboTargetLoc');
		param.Arg5 = Common_GetValue('cboTargetWard');
		param.Arg6 = "";
		param.ArgCnt = 6;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

