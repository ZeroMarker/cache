var objScreenMRB = new Object();
function InitMRBReport(aEpisodeID, aResultID){
	var obj = new Object();
	objScreenMRB = obj;
	
	obj.EpisodeID = aEpisodeID;
	
	obj.MDRRepID = '';
	obj.DataSource = '';
	obj.MRBPathDate = '';
	obj.MRBSampleType = '';
	obj.MRBMRBPy = '';
	var MRBStr = ExtTool.RunServerMethod("DHCMed.NINFService.BC.CtlMRBSrv","GetMDRByCtlRst",aResultID);
	if (MRBStr){
		var arrMRB = MRBStr.split(CHR_1);
		if (arrMRB.length>4){
			obj.MDRRepID = arrMRB[4];
			obj.DataSource = arrMRB[3];
			obj.MRBPathDate = arrMRB[0];
			obj.MRBSampleType = arrMRB[1];
			obj.MRBMRBPy = arrMRB[2];
		}
	}
	
	//送检日期
	obj.txtPathDate = Common_DateFieldToDate("txtPathDate","送检日期");
	//标本类型
	obj.cboSampleType = Common_ComboToDic("cboSampleType","标本类型","NINFAimMDRSampleType");
	//细菌名称
	obj.cboMRBPy = Common_ComboToDic("cboMRBPy","细菌名称","NIFNAimMDRPathogeny");
	//目标科室
	obj.cboTransLoc = Common_ComboToTransLoc("cboTransLoc","目标科室",obj.EpisodeID,"W");
	
	//多重耐药登记列表
	obj.gridMDRListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridMDRListStore = new Ext.data.Store({
		proxy: obj.gridMDRListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ReportID'
		},
		[
			{name: 'RepID', mapping: 'RepID'}
			,{name: 'SubID', mapping: 'SubID'}
			,{name: 'ReportID', mapping: 'ReportID'}
			,{name: 'TransID', mapping: 'TransID'}
			,{name: 'TransLocID', mapping: 'TransLocID'}
			,{name: 'TransLocDesc', mapping: 'TransLocDesc'}
			,{name: 'PathDate', mapping: 'PathDate'}
			,{name: 'SampleTypeID', mapping: 'SampleTypeID'}
			,{name: 'SampleTypeDesc', mapping: 'SampleTypeDesc'}
			,{name: 'PathogenyID', mapping: 'PathogenyID'}
			,{name: 'PathogenyDesc', mapping: 'PathogenyDesc'}
			,{name: 'IsolateTypeID', mapping: 'IsolateTypeID'}
			,{name: 'IsolateTypeDesc', mapping: 'IsolateTypeDesc'}
			,{name: 'HandHygieneID', mapping: 'HandHygieneID'}
			,{name: 'HandHygieneDesc', mapping: 'HandHygieneDesc'}
			,{name: 'SecondaryCasesID', mapping: 'SecondaryCasesID'}
			,{name: 'SecondaryCasesDesc', mapping: 'SecondaryCasesDesc'}
			,{name: 'RepLocID', mapping: 'RepLocID'}
			,{name: 'RepLocDesc', mapping: 'RepLocDesc'}
			,{name: 'RepUserID', mapping: 'RepUserID'}
			,{name: 'RepUserDesc', mapping: 'RepUserDesc'}
			,{name: 'RepDate', mapping: 'RepDate'}
			,{name: 'RepTime', mapping: 'RepTime'}
			,{name: 'RepDateTime', mapping: 'RepDateTime'}
			,{name: 'RepStatusID', mapping: 'RepStatusID'}
			,{name: 'RepStatusDesc', mapping: 'RepStatusDesc'}
			,{name: 'NINFStationID', mapping: 'NINFStationID'}
			,{name: 'NINFStationDesc', mapping: 'NINFStationDesc'}
			,{name: 'NINFStationDesc', mapping: 'NINFStationDesc'}
			,{name: 'DataSource', mapping: 'DataSource'}
		])
	});
	obj.gridMDRList = new Ext.grid.EditorGridPanel({
		id : 'gridMDRList'
		,store : obj.gridMDRListStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,loadMask : true
		,columns: [
			{header: '报告<br>状态', width: 50, dataIndex: 'RepStatusDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '送检日期', width: 80, dataIndex: 'PathDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '标本类型', width: 80, dataIndex: 'SampleTypeDesc', sortable: false, menuDisabled:true, align:'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '细菌名称', width: 150, dataIndex: 'PathogenyDesc', sortable: false, menuDisabled:true, align:'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '感染<br>情况', width: 50, dataIndex: 'NINFStationDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '隔离方式', width: 80, dataIndex: 'IsolateTypeDesc', sortable: false, menuDisabled:true, align:'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '加强<br>手卫生', width: 50, dataIndex: 'HandHygieneDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '续发病历', width: 80, dataIndex: 'SecondaryCasesDesc', sortable: false, menuDisabled:true, align:'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '填报时间', width: 100, dataIndex: 'RepDateTime', sortable: false, menuDisabled:true, align:'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '填报科室', width: 100, dataIndex: 'RepLocDesc', sortable: false, menuDisabled:true, align:'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '填报人', width: 60, dataIndex: 'RepUserDesc', sortable: false, menuDisabled:true, align:'center' }
		]
		,viewConfig : {
			forceFit : true
			,getRowClass : function(record,rowIndex,rowParams,store){
				if (record.data.DataSource == objScreenMRB.DataSource) {
					return 'x-grid-record-font-red';
				} else {
					return '';
				}
			}
		}
    });
	
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-edit'
		,width: 80
		,text : '更新'
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-Delete'
		,width: 80
		,text : '删除'
	});
	
	obj.btnClose = new Ext.Button({
		id : 'btnClose'
		,iconCls : 'icon-Exit'
		,width: 80
		,text : '关闭'
	});
	
	obj.WinMRBReport = new Ext.Window({
		id : 'WinMRBReport'
		,width : 800
		,height : 450
		,closable : false
		,modal : true
		,maximized : false
		,title : '多耐病例登记'
		,layout : 'border'
		,items:[
			{
				region: 'south',
				height: 35,
				layout : 'form',
				frame : true,
				labelWidth : 70,
				items : [
					{
						layout : 'column',
						items : [
							{
								width:180
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.txtPathDate]
							},{
								width:180
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.cboSampleType]
							},{
								columnWidth:1
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,boxMaxWidth : 400
								,items: [obj.cboMRBPy]
							}
						]
					}
				]
			},{
				region: 'center',
				layout : 'fit',
				//frame : true,
				items : [
					obj.gridMDRList
				]
			}
		],
		bbar : [obj.btnUpdate,obj.btnDelete,'->',obj.btnClose]
	});
	
	obj.gridMDRListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.BC.CtlMRBSrv';
		param.QueryName = 'QryMDRReport';
		param.Arg1 = obj.EpisodeID;
		param.ArgCnt = 1;
	});
	
	InitMRBReportEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

