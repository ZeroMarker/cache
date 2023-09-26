
function InitViewport()
{
	var obj = new Object();
	
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","医院",SSHospCode,"DTH");		//add by yanjf 20140417
    obj.cboRepLoc = Common_ComboToLoc("cboRepLoc","报告科室","E","","","cboSSHosp");	//update by likai for bug:3837
	obj.cboDateType = Common_ComboToDateType1("cboDateType","日期类型","报告日期");
	obj.txtDateFrom = Common_DateFieldToDate("txtDateFrom","开始日期");
	obj.txtDateTo = Common_DateFieldToDate("txtDateTo","结束日期");
	//obj.cboRepLoc = Common_ComboToLoc("cboRepLoc","科室","E","","I","^全院");
	obj.cboRepStatus = Common_ComboToDic("cboRepStatus","报告状态","NINFInfReportStatus","^全部");
	
	obj.AdminPower  = '0';
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	} else {
		obj.AdminPower  = AdminPower;
	}
	
	obj.txtRegNo = new Ext.form.TextField({
		id : 'txtRegNo'
		,fieldLabel : '登记号'
		,anchor : '98%'
	});
	obj.txtMrNo = new Ext.form.TextField({
		id : 'txtMrNo'
		,fieldLabel : '病案号'
		,anchor : '98%'
	});
	obj.txtPatName = new Ext.form.TextField({
		id : 'txtPatName'
		,fieldLabel : '姓名'
		,anchor : '98%'
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 80
		,text : '查询'
	})
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 80
		,text : '导出'
	});
	
	//Add By LiYang 2013-01-08
	obj.btnExportInterface = new Ext.Button({
		id : 'btnExportInterface'
		,iconCls : 'icon-export'
		,width : 80
		,text : '导出接口'
	});
	
	obj.gridInfReportStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridInfReportStore = new Ext.data.Store({
		proxy: obj.gridInfReportStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'ReportID'
		}, 
		[
			{name: 'ReportID', mapping : 'ReportID'}
			,{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'TransID', mapping: 'TransID'}
			,{name: 'TransLocID', mapping: 'TransLocID'}
			,{name: 'TransLocDesc', mapping: 'TransLocDesc'}
			,{name: 'ReportTypeID', mapping: 'ReportTypeID'}
			,{name: 'ReportTypeDesc', mapping: 'ReportTypeDesc'}
			,{name: 'ReportLocID', mapping: 'ReportLocID'}
			,{name: 'ReportLocDesc', mapping: 'ReportLocDesc'}
			,{name: 'ReportUserID', mapping: 'ReportUserID'}
			,{name: 'ReportUserDesc', mapping: 'ReportUserDesc'}
			,{name: 'ReportDate', mapping: 'ReportDate'}
			,{name: 'ReportTime', mapping: 'ReportTime'}
			,{name: 'ReportStatusID', mapping: 'ReportStatusID'}
			,{name: 'ReportStatusDesc', mapping: 'ReportStatusDesc'}
			,{name: 'AdmitDate', mapping: 'AdmitDate'}
			,{name: 'DischDate', mapping: 'DischDate'}
			,{name: 'AdmLoc', mapping: 'AdmLoc'}
			,{name: 'AdmWard', mapping: 'AdmWard'}
			,{name: 'AdmBed', mapping: 'AdmBed'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'PatSex', mapping: 'PatSex'}
			,{name: 'PatMrNo', mapping: 'PatMrNo'}
			,{name: 'PatAge', mapping: 'PatAge'}
			,{name: 'InfPos', mapping: 'InfPos'}
			,{name: 'InfDiag', mapping: 'InfDiag'}
			,{name: 'InfDiagCatID', mapping: 'InfDiagCatID'}
			,{name: 'InfDiagCatDesc', mapping: 'InfDiagCatDesc'}
			,{name: 'Specimen', mapping: 'Specimen'}
			,{name: 'InfPath', mapping: 'InfPath'}
			,{name: 'EveRepID', mapping: 'EveRepID'}
			,{name: 'IsHaveHisRep', mapping: 'IsHaveHisRep'}
			,{name: 'checked', mapping: 'checked'}
		]),
		sortInfo: {field: 'ReportLocDesc',direction: 'ASC'}
	});
	
	obj.gridInfReportCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });//Modified By LiYang 2013-01-07 增加选择框，以供导出接口
	obj.gridInfReport = new Ext.grid.GridPanel({
		id : 'gridInfReport'
		,store : obj.gridInfReportStore
		,plugins : obj.gridInfReportCheckCol
		,region : 'center'
		,columnLines : true
		,loadMask : true
		,columns: [
			obj.gridInfReportCheckCol   //Modified By LiYang 2013-01-07 增加选择框，以供导出接口
			//,{header : '报告类型', width : 90, dataIndex : 'ReportTypeDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '登记号', width : 80, dataIndex : 'PapmiNo', sortable: false, menuDisabled:true, align:'center' }
			,{header : '病案号', width : 60, dataIndex : 'PatMrNo', sortable: false, menuDisabled:true, align:'center' }
			,{header : '病人<br>姓名', width : 60, dataIndex : 'PatName', sortable: false, menuDisabled:true, align:'center' }
			,{header : '性别', width : 50, dataIndex : 'PatSex', sortable: false, menuDisabled:true, align:'center' }
			,{header : '年龄', width : 50, dataIndex : 'PatAge', sortable: false, menuDisabled:true, align:'center' }
			,{header : '报告<br>状态', width : 50, dataIndex : 'ReportStatusDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '报告科室', width : 100, dataIndex : 'ReportLocDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '报告人', width : 60, dataIndex : 'ReportUserDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '报告日期', width : 80, dataIndex : 'ReportDate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '报告时间', width : 60, dataIndex : 'ReportTime', sortable: false, menuDisabled:true, align:'center' }
			,{header : '感染科室', width : 100, dataIndex : 'TransLocDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '感染部位', width : 60, dataIndex : 'InfPos', sortable: false, menuDisabled:true, align:'center' ,
				renderer: function(v, m, rd, r, c, s) //列表单元格内容自动换行
				{
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			} 
			,{header : '感染诊断', width : 60, dataIndex : 'InfDiag', sortable: false, menuDisabled:true, align:'center' , //modified By LiYang 2013-05-18 增加链接到【感染截止日期的录入界面】
				renderer: function(v, m, rd, r, c, s) 
				{
					//return "<a href='#' onclick='return window.ShowInfEndDateWindow(" + rd.get("ReportID") + ")'>" + v + "</a>";
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header : '诊断分类', width : 60, dataIndex : 'InfDiagCatDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '检验标本', width : 60, dataIndex : 'Specimen', sortable: false, menuDisabled:true, align:'center' }
			,{header : '感染<br>病原体', width : 60, dataIndex : 'InfPath', sortable: false, menuDisabled:true, align:'center' }
			,{
				header : '历次报告',
				width : 60,
				dataIndex : 'IsHaveHisRep',
				renderer : function(v, m, rd, r, c, s){
					if (v=='Y') {
						var EpisodeID = rd.get("EpisodeID");
						return '';
						//return " <a href='#' onclick='HistoryReportLookUpHeader(\"" + EpisodeID + "\",\"" + ReportTypeID + "\")');'>&nbsp;查看&nbsp; </a>";
					} else {
						return '';
					}
				}
			}
			,{
				header : '病历浏览',
				width : 70,
				renderer : function(v, m, rd, r, c, s){
					var EpisodeID = rd.get("EpisodeID");
					return " <a href='#' onclick='DisplayEPRView(\""+EpisodeID+"\",\"\");'>&nbsp;病历浏览&nbsp; </a>";
				}
			}
			,{
				header : '生命体征',
				width : 70,
				dataIndex : 'EpisodeID',
				renderer : function(v, m, rd, r, c, s){
					var EpisodeID = rd.get("EpisodeID");
					return " <a href='#' onclick='ViewObservation(\""+EpisodeID+"\",\"\");'>&nbsp;生命体征&nbsp; </a>";
				}
			}
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
				height : 90,
				frame : true,
				buttonAlign : 'center',
				title : RepTypeDesc + ' 查询',
				items : [
					{
						layout : 'column',
						items : [
							{	//add by yanjf 20140417
								width : 210
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.cboSSHosp]
							},{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.cboDateType
								]
							},{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.txtDateFrom
								]
							},{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.txtDateTo
								]
							},{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.cboRepStatus
								]
							},{
								width : 5
							},{
								columnWidth:.10,
								layout : 'form',
								boxMinWidth : 80,
								boxMaxWidth : 80,
								items : [
									obj.btnQuery
								]
							},{
								columnWidth:.10,
								layout : 'form',
								items : [
									obj.btnExport
								]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.cboRepLoc
								]
							},{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.txtRegNo
								]
							},{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.txtMrNo
								]
							},{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.txtPatName
								]
							},{
								width : 5
							},{
								columnWidth:.10,
								layout : 'form',
								items : [
									obj.btnExportInterface
								]
							},{
								columnWidth:.10
							}
						]
					}
				]
			}
		]
	});
	
	obj.gridInfReportStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.InfReport';
		param.QueryName = 'QryRepInfoByDateLoc';
		param.Arg1 = Common_GetValue('cboDateType');
		param.Arg2 = Common_GetValue('txtDateFrom');
		param.Arg3 = Common_GetValue('txtDateTo');
		param.Arg4 = Common_GetValue('cboRepLoc');
		param.Arg5 = Common_GetValue('cboRepStatus');
		param.Arg6 = RepTypeID;
		param.Arg7 = obj.txtRegNo.getValue();
		param.Arg8 = obj.txtMrNo.getValue();
		param.Arg9 = obj.txtPatName.getValue();
		param.Arg10 = Common_GetValue('cboSSHosp');		//医院  add by yanjf 20140417
		param.ArgCnt = 10;
	});
	
	InitViewportEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}

