
function InitViewport()
{
	var obj = new Object();
	
	obj.cboDateType = Common_ComboToDateType1("cboDateType","日期类型","报告日期");
	obj.txtDateFrom = Common_DateFieldToDate("txtDateFrom","开始日期");
	obj.txtDateTo = Common_DateFieldToDate("txtDateTo","结束日期");
	obj.cboRepLoc = Common_ComboToLoc("cboRepLoc","报告科室","E","","I","^全院");
	obj.cboRepStatus = Common_ComboToDic("cboRepStatus","报告状态","NINFInfReportStatus","^全部");
	
	obj.AdminPower  = '0';
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	}
	
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
	
	//Add By LiYang 2013-01-08
	obj.btnExportInterface = new Ext.Button({
		id : 'btnExportInterface'
		,iconCls : 'icon-export'
		,width : 80
		,text : '导出接口'
	});
	
	obj.btnExportAllInterface = new Ext.Button({
		id : 'btnExportAllInterface'
		,iconCls : 'icon-export'
		,width : 80
		,text : '导出全部接口'
	});
	
	obj.gridInfReportStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridInfReportStore = new Ext.data.Store({
		proxy: obj.gridInfReportStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'RecordID'
		}, 
		[
			{name: 'RecordID', mapping : 'RecordID'}
			,{name: 'ReportID', mapping : 'ReportID'}
			,{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'ObjectID', mapping : 'ObjectID'}
			,{name: 'ReportTypeID', mapping : 'ReportTypeID'}
			,{name: 'ReportTypeDesc', mapping : 'ReportTypeDesc'}
			,{name: 'ReportLocID', mapping : 'ReportLocID'}
			,{name: 'ReportLocDesc', mapping : 'ReportLocDesc'}
			,{name: 'ReportUserID', mapping : 'ReportUserID'}
			,{name: 'ReportUserDesc', mapping : 'ReportUserDesc'}
			,{name: 'ReportDate', mapping : 'ReportDate'}
			,{name: 'ReportTime', mapping : 'ReportTime'}
			,{name: 'ReportStatusID', mapping : 'ReportStatusID'}
			,{name: 'ReportStatusCode', mapping : 'ReportStatusCode'}
			,{name: 'ReportStatusDesc', mapping : 'ReportStatusDesc'}
			,{name: 'AdmitDate', mapping : 'AdmitDate'}
			,{name: 'DischDate', mapping : 'DischDate'}
			,{name: 'AdmLoc', mapping : 'AdmLoc'}
			,{name: 'AdmWard', mapping : 'AdmWard'}
			,{name: 'AdmBed', mapping : 'AdmBed'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'PapmiNo', mapping : 'PapmiNo'}
			,{name: 'PatName', mapping : 'PatName'}
			,{name: 'PatSex', mapping : 'PatSex'}
			,{name: 'PatMrNo', mapping : 'PatMrNo'}
			,{name: 'PatAge', mapping : 'PatAge'}
			,{name: 'OperationID', mapping : 'OperationID'}
			,{name: 'OperationDesc', mapping : 'OperationDesc'}
			,{name: 'OperDocID', mapping : 'OperDocID'}
			,{name: 'OperDocDesc', mapping : 'OperDocDesc'}
			,{name: 'OperStartDate', mapping : 'OperStartDate'}
			,{name: 'OperStartTime', mapping : 'OperStartTime'}
			,{name: 'OperStartDateTime', mapping : 'OperStartDateTime'}
			,{name: 'OperEndDate', mapping : 'OperEndDate'}
			,{name: 'OperEndTime', mapping : 'OperEndTime'}
			,{name: 'OperEndDateTime', mapping : 'OperEndDateTime'}
			,{name: 'OperationTypeID', mapping : 'OperationTypeID'}
			,{name: 'OperationTypeDesc', mapping : 'OperationTypeDesc'}
			,{name: 'AnesthesiaID', mapping : 'AnesthesiaID'}
			,{name: 'AnesthesiaDesc', mapping : 'AnesthesiaDesc'}
			,{name: 'CuteTypeID', mapping : 'CuteTypeID'}
			,{name: 'CuteTypeDesc', mapping : 'CuteTypeDesc'}
			,{name: 'CuteHealingID', mapping : 'CuteHealingID'}
			,{name: 'CuteHealingDesc', mapping : 'CuteHealingDesc'}
			,{name: 'CuteInfFlagID', mapping : 'CuteInfFlagID'}
			,{name: 'CuteInfFlagDesc', mapping : 'CuteInfFlagDesc'}
			,{name: 'OperInfTypeID', mapping : 'OperInfTypeID'}
			,{name: 'OperInfTypeDesc', mapping : 'OperInfTypeDesc'}
			,{name: 'InHospInfFlagID', mapping : 'InHospInfFlagID'}
			,{name: 'InHospInfFlagDesc', mapping : 'InHospInfFlagDesc'}
			,{name: 'ASAScoreID', mapping : 'ASAScoreID'}
			,{name: 'ASAScoreDesc', mapping : 'ASAScoreDesc'}
			,{name: 'DataSource', mapping : 'DataSource'}
			,{name: 'PreoperWBC', mapping : 'PreoperWBC'}
			,{name: 'CuteNumberID', mapping : 'CuteNumberID'}
			,{name: 'CuteNumberDesc', mapping : 'CuteNumberDesc'}
			,{name: 'EndoscopeFlagID', mapping : 'EndoscopeFlagID'}
			,{name: 'EndoscopeFlagDesc', mapping : 'EndoscopeFlagDesc'}
			,{name: 'ImplantFlagID', mapping : 'ImplantFlagID'}
			,{name: 'ImplantFlagDesc', mapping : 'ImplantFlagDesc'}
			,{name: 'PreoperAntiFlagID', mapping : 'PreoperAntiFlagID'}
			,{name: 'PreoperAntiFlagDesc', mapping : 'PreoperAntiFlagDesc'}
			,{name: 'BloodLossFlagID', mapping : 'BloodLossFlagID'}
			,{name: 'BloodLossFlagDesc', mapping : 'BloodLossFlagDesc'}
			,{name: 'BloodLoss', mapping : 'BloodLoss'}
			,{name: 'BloodTransFlagID', mapping : 'BloodTransFlagID'}
			,{name: 'BloodTransFlagDesc', mapping : 'BloodTransFlagDesc'}
			,{name: 'BloodTrans', mapping : 'BloodTrans'}
			,{name: 'PostoperComps', mapping : 'PostoperComps'}
			,{name: 'PostoperCompsDesc', mapping : 'PostoperCompsDesc'}
			,{name: 'checked', mapping: 'checked'}
			,{name: 'EncryptLevel', mapping: 'EncryptLevel'}
			,{name: 'PatLevel', mapping: 'PatLevel'}
		]),
		sortInfo: {field: 'ReportLocDesc',direction: 'ASC'}
	});
	obj.gridInfReportCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridInfReport = new Ext.grid.GridPanel({
		id : 'gridInfReport'
		,store : obj.gridInfReportStore
		,plugins : obj.gridInfReportCheckCol
		,region : 'center'
		,columnLines : true
		,loadMask : true
		,columns: [
			obj.gridInfReportCheckCol
			,{header : '报告类型', width : 100, dataIndex : 'ReportTypeDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '报告<br>状态', width : 50, dataIndex : 'ReportStatusDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '登记号', width : 80, dataIndex : 'PapmiNo', sortable: false, menuDisabled:true, align:'center' }
			,{header : '病案号', width : 60, dataIndex : 'PatMrNo', sortable: false, menuDisabled:true, align:'center' }
			,{header : '病人<br>姓名', width : 60, dataIndex : 'PatName', sortable: false, menuDisabled:true, align:'center' }
			,{header : '性别', width : 50, dataIndex : 'PatSex', sortable: false, menuDisabled:true, align:'center' }
			,{header : '年龄', width : 50, dataIndex : 'PatAge', sortable: false, menuDisabled:true, align:'center' }
			,{header : '病人<br>密级', id : 'Secret1', width : 60, dataIndex : 'EncryptLevel', sortable: false, menuDisabled:true, align:'center' }
			,{header : '病人<br>级别', id : 'Secret2', width : 60, dataIndex : 'PatLevel', sortable: false, menuDisabled:true, align:'center' }
			,{header : '手术名称', width : 100, dataIndex : 'OperationDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '手术医生', width : 60, dataIndex : 'OperDocDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '开始时间', width : 100, dataIndex : 'OperStartDateTime', sortable: false, menuDisabled:true, align:'center' }
			,{header : '结束时间', width : 100, dataIndex : 'OperEndDateTime', sortable: false, menuDisabled:true, align:'center' }
			,{header : '手术类型', width : 60, dataIndex : 'OperationTypeDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '外周血(WBC)', width : 70, dataIndex : 'PreoperWBC', sortable: false, menuDisabled:true, align:'center' }
			,{header : '切口个数', width : 60, dataIndex : 'CuteNumberDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '切口类型', width : 60, dataIndex : 'CuteTypeDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : 'ASA(麻醉)评分', width : 80, dataIndex : 'ASAScoreDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '内窥镜', width : 60, dataIndex : 'EndoscopeFlagDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '植入物', width : 60, dataIndex : 'ImplantFlagDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '术前口服抗生素<br>肠道准备', width : 80, dataIndex : 'PreoperAntiFlagDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '愈合情况', width : 60, dataIndex : 'CuteHealingDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '麻醉方式', width : 60, dataIndex : 'AnesthesiaDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '切口感染', width : 60, dataIndex : 'CuteInfFlagDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '感染类型', width : 60, dataIndex : 'OperInfTypeDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '引起院感', width : 60, dataIndex : 'InHospInfFlagDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '失血', width : 60, dataIndex : 'BloodLossFlagDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '失血量', width : 60, dataIndex : 'BloodLoss', sortable: false, menuDisabled:true, align:'center' }
			,{header : '输血', width : 60, dataIndex : 'BloodTransFlagDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '输血量', width : 60, dataIndex : 'BloodTrans', sortable: false, menuDisabled:true, align:'center' }
			,{header : '术后并发症', width : 100, dataIndex : 'PostoperCompsDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '报告科室', width : 100, dataIndex : 'ReportLocDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '报告人', width : 60, dataIndex : 'ReportUserDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '报告日期', width : 80, dataIndex : 'ReportDate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '报告时间', width : 60, dataIndex : 'ReportTime', sortable: false, menuDisabled:true, align:'center' }
			,{header : '入院日期', width : 80, dataIndex : 'AdmitDate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '出院日期', width : 80, dataIndex : 'DischDate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '科室', width : 100, dataIndex : 'AdmLoc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '病区', width : 100, dataIndex : 'AdmWard', sortable: false, menuDisabled:true, align:'center' }
			,{header : '床号', width : 80, dataIndex : 'AdmBed', sortable: false, menuDisabled:true, align:'center' }
		]
		,viewConfig : {
			//forceFit : true
			enableRpwBody : true
			,showPreview : true
			,layout : function() {
				if (!this.mainBody) {
					return;
				}
				var g = this.grid;
				var c = g.getGridEl();
				var csize = c.getSize(true);
				var vw = csize.width;
				if (!g.hideHeaders && (vw < 20 || csize.height < 20)) {
					return;
				}
				if (g.autoHeight) {
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				} else {
					this.el.setSize(csize.width, csize.height);
					var hdHeight = this.mainHd.getHeight();
					var vh = csize.height - (hdHeight);
					this.scroller.setSize(vw, vh);
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				}
				if (this.forceFit) {
					if (this.lastViewWidth != vw) {
						this.fitColumns(false, false);
						this.lastViewWidth = vw;
					 }
				} else {
					this.autoExpand();
					this.syncHeaderScroll();
				}
				this.onLayout(vw, vh);
			}
			,getRowClass : function(record,rowIndex,rowParams,store){
				if ((record.data.ReportStatusCode='0')||(record.data.ReportStatusCode='1')) {
					return 'x-grid-record-font-red';
				} else {
					return '';
				}
			}
		}
    });
	
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.gridInfReport,
			{
				layout : 'form',
				region : "north",
				height : 110,
				buttonAlign : 'center',
				title : RepTypeDesc + ' 查询',
				items : [
					{
						layout : 'column',
						frame : true,
						items : [
							{
								width:150,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [
									obj.cboDateType
								]
							},{
								width:200,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 70,
								items : [
									obj.txtDateFrom
								]
							},{
								width:200,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 70,
								items : [
									obj.txtDateTo
								]
							},{
								width:150,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [
									obj.cboRepStatus
								]
							},{
								columnWidth:1,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 150,
								boxMaxWidth : 300,
								items : [
									obj.cboRepLoc
								]
							}
						]
					}
				]
				,buttons : [obj.btnQuery,obj.btnExport,obj.btnExportInterface,obj.btnExportAllInterface]
			}
		]
	});
	
	obj.gridInfReportStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.InfReport';
		param.QueryName = 'QryOprRepByDate';
		param.Arg1 = Common_GetValue('cboDateType');
		param.Arg2 = Common_GetValue('txtDateFrom');
		param.Arg3 = Common_GetValue('txtDateTo');
		param.Arg4 = Common_GetValue('cboRepLoc');
		param.Arg5 = Common_GetValue('cboRepStatus');
		param.Arg6 = RepTypeID;
		param.ArgCnt = 6;
	});
	
	InitViewportEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}

