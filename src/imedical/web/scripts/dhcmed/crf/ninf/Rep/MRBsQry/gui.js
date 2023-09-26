
function InitViewport1(){
	var obj = new Object();
	
	obj.txtDateFrom = Common_DateFieldToDate("txtDateFrom","开始日期");
	obj.txtDateTo = Common_DateFieldToDate("txtDateTo","结束日期");
	//obj.cboLoc = Common_ComboToLoc("cboLoc","送检科室","","","");
	obj.checkMDR = Common_Checkbox("checkMDR","多耐");
	obj.cboMRBDic = Common_ComboToMRB("cboMRBDic","多耐分类");
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","医院",SSHospCode,"DTH");		//add by yanjf 20140417
    obj.cboLoc = Common_ComboToLoc("cboLoc","送检科室","E","","","cboSSHosp");	//add by yanjf 20140417
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 70
		,text : '查询'
	})
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 70
		,text : '导出'
	});
	
	obj.mnuMenu = new Ext.menu.Menu({
        items : [
			{
				id : 'mnuSendMsg',
				text : '<B>病例处置及消息反馈<B/>',
				icon : '../scripts/dhcmed/img/warn.png'
			},"-",{
				id : 'mnuBaseInfo',
				text : '<B>病人相关信息-摘要<B/>',
				iconCls : 'icon-woman'
			},"-",{
				id : 'mnuViewObservation',
				text : '<B>生命体征-体温单<B/>',
				iconCls : 'icon-man'
			},"-",{
				id : 'mnuExportAntiDrug',
				text : '<B>多重耐药菌登记表导出<B/>',
				iconCls : 'icon-man'
			},"-",{
				id : 'mnuPrintAntiDrug',
				text : '<B>多重耐药菌登记表打印<B/>',
				iconCls : 'icon-man'
			}
        ]
    })
	
	obj.gridLabResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridLabResultStore = new Ext.data.Store({
		proxy: obj.gridLabResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ResultID'
		},
		[
			{name: 'ResultID', mapping : 'ResultID'}
			,{name: 'Paadm', mapping : 'Paadm'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Birthday', mapping: 'Birthday'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'PersonalID', mapping: 'PersonalID'}
			,{name: 'AdmitDate', mapping: 'AdmitDate'}
			,{name: 'AdmitTime', mapping: 'AdmitTime'}
			,{name: 'DisDate', mapping: 'DisDate'}
			,{name: 'DisTime', mapping: 'DisTime'}
			,{name: 'AdmLoc', mapping: 'AdmLoc'}
			,{name: 'AdmWard', mapping: 'AdmWard'}
			,{name: 'AdmBed', mapping: 'AdmBed'}
			,{name: 'AdmDoc', mapping: 'AdmDoc'}
			,{name: 'AdmDays', mapping: 'AdmDays'}
			,{name: 'AdmType', mapping: 'AdmType'}
			,{name: 'ItemID', mapping: 'ItemID'}
			,{name: 'ItemDesc', mapping: 'ItemDesc'}
			,{name: 'Score', mapping: 'Score'}
			,{name: 'ItemGroup', mapping: 'ItemGroup'}
			,{name: 'ItemCatID', mapping: 'ItemCatID'}
			,{name: 'ItemCatDesc', mapping: 'ItemCatDesc'}
			,{name: 'Summary', mapping: 'Summary'}
			,{name: 'ActDate', mapping: 'ActDate'}
			,{name: 'ActTime', mapping: 'ActTime'}
			,{name: 'ActUser', mapping: 'ActUser'}
			,{name: 'OccurDate', mapping: 'OccurDate'}
			,{name: 'OccurTime', mapping: 'OccurTime'}
			,{name: 'DataValue', mapping: 'DataValue'}
			,{name: 'ObjectID', mapping: 'ObjectID'}
			,{name: 'TestSetRow', mapping: 'TestSetRow'}
			,{name: 'OEItemID', mapping: 'OEItemID'}
			,{name: 'SpecimenCode', mapping: 'SpecimenCode'}
			,{name: 'SpecimenDesc', mapping: 'SpecimenDesc'}
			,{name: 'SubmisDocCode', mapping: 'SubmisDocCode'}
			,{name: 'SubmisDocDesc', mapping: 'SubmisDocDesc'}
			,{name: 'ActLoc', mapping: 'ActLoc'}
			,{name: 'ActWard', mapping: 'ActWard'}
			,{name: 'MRBFlag', mapping: 'MRBFlag'}
		])
	});
	obj.gridLabResult = new Ext.grid.EditorGridPanel({
		id : 'gridLabResult'
		,store : obj.gridLabResultStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,contextMenu : obj.mnuMenu
		,region : 'center'
		,loadMask : true
		//,frame : true
		,columns: [
			{header: '登记号', width: 80, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '姓名', width: 60, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '性别', width: 40, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 40, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '报告日期', width: 80, dataIndex: 'ActDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '送检日期', width: 80, dataIndex: 'OccurDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '送检科室', width: 100, dataIndex: 'ActLoc', sortable: true, menuDisabled:true, align: 'left'}
			,{header: '送检医生', width: 60, dataIndex: 'SubmisDocDesc', sortable: true, menuDisabled:true, align: 'left'}
			,{header: '标本', width: 60, dataIndex: 'SpecimenDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '致病菌', width: 120, dataIndex: 'DataValue', sortable: true, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '多耐<br>标记', width: 40, dataIndex: 'MRBFlag', sortable: true, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var MRBFlag = rd.get("MRBFlag");
					if (MRBFlag == '1') {
						return "<IMG src='../scripts/dhcmed/img/update.png'>";
					} else {
						return "<IMG src='../scripts/dhcmed/img/cancel.png'>";
					}
				}
			}
			,{header: '细菌培养+药敏结果', width:400, dataIndex: 'Summary', sortable: true, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			//update by likai for bug:3932
			,{header: '检验报告ID', width:100, dataIndex: 'TestSetRow', sortable: false, menuDisabled:true, align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.gridLabResultStore,
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
					{
						region: 'north',
						height: 70,
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
									},{	//add by yanjf 20140417
										width : 210
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.cboSSHosp]
									},{
										columnWidth:.50
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,boxMinWidth : 200
										,boxMaxWidth : 270
										,items: [obj.cboLoc]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										width : 70
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.checkMDR]
									},{
										columnWidth:.50
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,boxMinWidth : 200
										,boxMaxWidth : 270
										,items: [obj.cboMRBDic]
									},{
										width : 20
									},{
										width : 75
										,layout : 'form'
										,items: [obj.btnQuery]
									},{
										width : 20
									},{
										width : 75
										,layout : 'form'
										,items: [obj.btnExport]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridLabResult
						]
					}
				]
			}
		]
	});
	
	obj.gridLabResultStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.BC.CtlResultSrv';
		param.QueryName = 'QryMRBResult';
		param.Arg1 = SubjectCode;
		param.Arg2 = Common_GetValue('txtDateFrom');
		param.Arg3 = Common_GetValue('txtDateTo');
		param.Arg4 = Common_GetValue('cboLoc');
		param.Arg5 = (Common_GetValue('checkMDR') ? 1 : 0);
		param.Arg6 = Common_GetText('cboMRBDic');
		param.ArgCnt = 6;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

