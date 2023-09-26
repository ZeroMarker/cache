
function InitViewport()
{
	var obj = new Object();
	
	obj.cboDateType = Common_ComboToDateType1("cboDateType","日期类型","报告日期");
	obj.txtDateFrom = Common_DateFieldToDate("txtDateFrom","开始日期");
	obj.txtDateTo = Common_DateFieldToDate("txtDateTo","结束日期");
	obj.cboRepLoc = Common_ComboToLoc("cboRepLoc","科室","E","","I","^全院");
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

	//Add By LiYang 2014-04-28 导出民科系统接口
	obj.btnExportInterface = new Ext.Button({
		id : 'btnExportInterface'
		,iconCls : 'icon-export'
		,width : 70
		,text : '导出接口'
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
			,{name: 'IntubateTypeID', mapping : 'IntubateTypeID'}
			,{name: 'IntubateTypeDesc', mapping : 'IntubateTypeDesc'}
			,{name: 'IntubateDate', mapping : 'IntubateDate'}
			,{name: 'IntubateTime', mapping : 'IntubateTime'}
			,{name: 'IntubateDateTime', mapping : 'IntubateDateTime'}
			,{name: 'ExtubateDate', mapping : 'ExtubateDate'}
			,{name: 'ExtubateTime', mapping : 'ExtubateTime'}
			,{name: 'ExtubateDateTime', mapping : 'ExtubateDateTime'}
			,{name: 'IntubatePlaceID', mapping : 'IntubatePlaceID'}
			,{name: 'IntubatePlaceDesc', mapping : 'IntubatePlaceDesc'}
			,{name: 'IntubateUserTypeID', mapping : 'IntubateUserTypeID'}
			,{name: 'IntubateUserTypeDesc', mapping : 'IntubateUserTypeDesc'}
			,{name: 'IntubateUserID', mapping : 'IntubateUserID'}
			,{name: 'IntubateUserDesc', mapping : 'IntubateUserDesc'}
			,{name: 'InfDate', mapping : 'InfDate'}
			,{name: 'InfPathogeny', mapping : 'SInfPathogenys'}
			,{name: 'InfPathogenysDesc', mapping : 'InfPathogenysDesc'}
			,{name: 'PICCIntubatePosID', mapping : 'PICCIntubatePosID'}
			,{name: 'PICCIntubatePosDesc', mapping : 'PICCIntubatePosDesc'}
			,{name: 'PICCIntubateSizeID', mapping : 'PICCIntubateSizeID'}
			,{name: 'PICCIntubateSizeDesc', mapping : 'PICCIntubateSizeDesc'}
			,{name: 'PICCIntubateTypeID', mapping : 'PICCIntubateTypeID'}
			,{name: 'PICCIntubateTypeDesc', mapping : 'PICCIntubateTypeDesc'}
			,{name: 'PICCIntubateNumID', mapping : 'PICCIntubateNumID'}
			,{name: 'PICCIntubateNumDesc', mapping : 'PICCIntubateNumDesc'}
			,{name: 'PICCIntubateRegionID', mapping : 'PICCIntubateRegionID'}
			,{name: 'PICCIntubateRegionDesc', mapping : 'PICCIntubateRegionDesc'}
			,{name: 'PICCExtubateReasonID', mapping : 'PICCExtubateReasonID'}
			,{name: 'PICCExtubateReasonDesc', mapping : 'PICCExtubateReasonDesc'}
			,{name: 'UCUrineBagTypeID', mapping : 'UCUrineBagTypeID'}
			,{name: 'UCUrineBagTypeDesc', mapping : 'UCUrineBagTypeDesc'}
			,{name: 'VAPIntubateTypeID', mapping : 'VAPIntubateTypeID'}
			,{name: 'VAPIntubateTypeDesc', mapping : 'VAPIntubateTypeDesc'}
		]),
		sortInfo: {field: 'ReportLocDesc',direction: 'ASC'}
	});
	
	obj.gridInfReportCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });//Modified By LiYang 2013-04-28 增加选择框，以供导出接口
	
	obj.gridInfReport = new Ext.grid.GridPanel({
		id : 'gridInfReport'
		,store : obj.gridInfReportStore
		,region : 'center'
		,columnLines : true
		,loadMask : true
		,plugins : obj.gridInfReportCheckCol//Modified By LiYang 2013-04-28 增加选择框，以供导出接口
		,columns: [
			obj.gridInfReportCheckCol, //Modified By LiYang 2013-04-28 增加选择框，以供导出接口
			{header : '报告类型', width : 100, dataIndex : 'ReportTypeDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '报告<br>状态', width : 50, dataIndex : 'ReportStatusDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '登记号', width : 80, dataIndex : 'PapmiNo', sortable: false, menuDisabled:true, align:'center' }
			,{header : '病案号', width : 60, dataIndex : 'PatMrNo', sortable: false, menuDisabled:true, align:'center' }
			,{header : '病人<br>姓名', width : 60, dataIndex : 'PatName', sortable: false, menuDisabled:true, align:'center' }
			,{header : '性别', width : 50, dataIndex : 'PatSex', sortable: false, menuDisabled:true, align:'center' }
			,{header : '年龄', width : 50, dataIndex : 'PatAge', sortable: false, menuDisabled:true, align:'center' }
			,{header : '插管类型', width : 80, dataIndex : 'IntubateTypeDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '插管日期', width : 70, dataIndex : 'IntubateDate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '拔管日期', width : 70, dataIndex : 'ExtubateDate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '置管地点', width : 100, dataIndex : 'IntubatePlaceDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '插管操作者', width : 70, dataIndex : 'IntubateUserTypeDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '感染日期', width : 70, dataIndex : 'InfDate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '导管类型', width : 80, dataIndex : 'PICCIntubateTypeDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '导管腔数', width : 60, dataIndex : 'PICCIntubateNumDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '置管部位', width : 60, dataIndex : 'PICCIntubateRegionDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '尿管类型', width : 80, dataIndex : 'UCUrineBagTypeDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '气道类型', width : 60, dataIndex : 'VAPIntubateTypeDesc', sortable: false, menuDisabled:true, align:'center' }
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
				height : 100,
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
								width:160,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [
									obj.txtDateFrom
								]
							},{
								width:160,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
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
				,buttons : [obj.btnQuery,obj.btnExport
					,obj.btnExportInterface //Modified By LiYang 2014-04-28 导出民科接口
				]
			}
		]
	});
	
	obj.gridInfReportStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.InfReport';
		param.QueryName = 'QryICURepByDate';
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

