
function InitViewport()
{
	var obj = new Object();
	
	obj.cboDateType = Common_ComboToDateType("cboDateType","日期类型","NVNT","填报日期" + CHR_1 + "报告日期");
	obj.txtDateFrom = Common_DateFieldToDate("txtDateFrom","开始日期");
	obj.txtDateTo = Common_DateFieldToDate("txtDateTo","结束日期");
	obj.cboLoc = Common_ComboToLoc("cboLoc","填报科室","");
	obj.chkIsCommit = Common_Checkbox("chkIsCommit","未提交");
	obj.AdminPower  = AdminPower;
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
	
	obj.QueryGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.QueryGridPanelStore = new Ext.data.Store({
		proxy: obj.QueryGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ReportID'
		}, 
		[
			{name: 'EpisodeID', mapping: 'EpisodeID'}
			,{name: 'AdmitDate', mapping: 'AdmitDate'}
			,{name: 'DischDate', mapping: 'DischDate'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'PatSex', mapping: 'PatSex'}
			,{name: 'PatMrNo', mapping: 'PatMrNo'}
			,{name: 'PatAge', mapping: 'PatAge'}
			,{name: 'TransLocID', mapping: 'TransLocID'}
			,{name: 'TransLocDesc', mapping: 'TransLocDesc'}
			,{name: 'TransFromLocID', mapping: 'TransFromLocID'}
			,{name: 'TransFromLocDesc', mapping: 'TransFromLocDesc'}
			,{name: 'TransToLocID', mapping: 'TransToLocID'}
			,{name: 'TransToLocDesc', mapping: 'TransToLocDesc'}
			,{name: 'TransStartDate', mapping: 'TransStartDate'}
			,{name: 'TransStartTime', mapping: 'TransStartTime'}
			,{name: 'TransEndDate', mapping: 'TransEndDate'}
			,{name: 'TransEndTime', mapping: 'TransEndTime'}
			
			,{name: 'ReportID', mapping: 'ReportID'}
			,{name: 'IntubateDate', mapping: 'IntubateDate'}
			,{name: 'IntubateTime', mapping: 'IntubateTime'}
			,{name: 'IntubateDateTime', mapping: 'IntubateDateTime'}
			,{name: 'ExtubateDate', mapping: 'ExtubateDate'}
			,{name: 'ExtubateTime', mapping: 'ExtubateTime'}
			,{name: 'ExtubateDateTime', mapping: 'ExtubateDateTime'}
			,{name: 'IsInfection', mapping: 'IsInfection'}
			,{name: 'InfDate', mapping: 'InfDate'}
			,{name: 'InfPyIDs', mapping: 'InfPyIDs'}
			,{name: 'InfPyDescs', mapping: 'InfPyDescs'}
			,{name: 'InfPyValues', mapping: 'InfPyValues'}
			,{name: 'RepLocID', mapping: 'RepLocID'}
			,{name: 'RepLocDesc', mapping: 'RepLocDesc'}
			,{name: 'RepUserID', mapping: 'RepUserID'}
			,{name: 'RepUserDesc', mapping: 'RepUserDesc'}
			,{name: 'RepDate', mapping: 'RepDate'}
			,{name: 'RepTime', mapping: 'RepTime'}
			,{name: 'RepDateTime', mapping: 'RepDateTime'}
			,{name: 'RepStatusID', mapping: 'RepStatusID'}
			,{name: 'RepStatusDesc', mapping: 'RepStatusDesc'}
		])
	});
	obj.QueryGridPanel = new Ext.grid.GridPanel({
		id : 'QueryGridPanel'
		,store : obj.QueryGridPanelStore
		,region : 'center'
		,columnLines : true
		,loadMask : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '科室', width: 100, dataIndex: 'TransLocDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '姓名', width: 80, dataIndex: 'PatName', sortable: false, menuDisabled:true, align:'center' }
			,{header: '病案号', width: 80, dataIndex: 'PatMrNo', sortable: false, menuDisabled:true, align:'center' }
			,{header: '性别', width: 50, dataIndex: 'PatSex', sortable: false, menuDisabled:true, align:'center' }
			,{header: '年龄', width: 50, dataIndex: 'PatAge', sortable: false, menuDisabled:true, align:'center' }
			,{header: '报告<br>状态', width: 50, dataIndex: 'RepStatusDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '上机时间', width: 100, dataIndex: 'IntubateDateTime', sortable: false, menuDisabled:true, align:'center' }
			,{header: '脱机时间', width: 100, dataIndex: 'ExtubateDateTime', sortable: false, menuDisabled:true, align:'center' }
			,{header: '是否<br>感染', width: 50, dataIndex: 'IsInfection', sortable: false, menuDisabled:true, align:'center' }
			,{header: '感染日期', width: 80, dataIndex: 'InfDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '病原体', width: 100, dataIndex: 'InfPyDescs', sortable: false, menuDisabled:true, align:'center' }
			,{header: '填报时间', width: 100, dataIndex: 'RepDateTime', sortable: false, menuDisabled:true, align:'center' }
			,{header: '填报科室', width: 100, dataIndex: 'RepLocDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '填报人', width: 80, dataIndex: 'RepUserDesc', sortable: false, menuDisabled:true, align:'center' }
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
				if (record.data.RepStatusDesc=="提交") {
					return 'x-grid-record-font-green';
				} else if ((record.data.RepStatusDesc=="保存")&&(record.data.TransEndDate!='')) {
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
			obj.QueryGridPanel,
			{
				layout : 'form',
				region : "north",
				height : 90,
				frame : true,
				buttonAlign : 'center',
				title : 'NICU-气管插管信息查询',
				items : [
					{
						layout : 'column',
						items : [
							{
								width : 150,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [obj.cboDateType]
							},{
								width : 160,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [obj.txtDateFrom]
							},{
								width : 160,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [obj.txtDateTo]
							},{
								columnWidth:1,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 300,
								items : [obj.cboLoc]
							}
						]
					},
					{
						layout : 'column',
						items : [
							{
								columnWidth:.50
							},{
								width : 150,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [obj.chkIsCommit]
							},{
								width : 80,
								layout : 'form',
								items : [obj.btnQuery]
							},{
								width : 80,
								layout : 'form',
								items : [obj.btnExport]
							},{
								columnWidth:.50
							}
						]
					}
				]
			}
		]
	});
	
	obj.QueryGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.AimReportNVNT';
		param.QueryName = 'QryRepByDateLoc';
		param.Arg1 = Common_GetValue('cboDateType');
		param.Arg2 = Common_GetValue('txtDateFrom');
		param.Arg3 = Common_GetValue('txtDateTo');
		param.Arg4 = Common_GetValue('cboLoc');
		var isCommit = Common_GetValue('chkIsCommit');
		param.Arg5 = (isCommit ? "Y" : "N");
		param.ArgCnt = 5;
	});
	
	InitViewportEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}

