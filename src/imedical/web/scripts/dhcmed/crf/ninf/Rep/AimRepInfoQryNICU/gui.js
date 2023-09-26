
function InitViewport()
{
	var obj = new Object();
	
	obj.TransType = TransType;
	
	obj.cboDateType = Common_ComboToDateType("cboDateType","日期类型","NICU","填报日期" + CHR_1 + "报告日期");
	obj.txtDateFrom = Common_DateFieldToDate("txtDateFrom","开始日期");
	obj.txtDateTo = Common_DateFieldToDate("txtDateTo","结束日期");
	obj.cboLoc = Common_ComboToLoc("cboLoc","科室",obj.TransType);
	obj.chkIsCommit = Common_Checkbox("chkIsCommit","已提交");
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
	
	obj.GridColumnHeaderGroup = new Ext.ux.grid.ColumnHeaderGroup({
		rows: [[
			{header: '',align: 'center',colspan: 1}
			,{header: '基本信息',align: 'center',colspan: 6}
			,{header: '脐静脉',align: 'center',colspan: 5}
			,{header: 'PICC',align: 'center',colspan: 5}
			,{header: '气管插管',align: 'center',colspan: 5}
			,{header: '感染报告',align: 'center',colspan: 2}
		]]
	});
	
	obj.QueryGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.QueryGridPanelStore = new Ext.data.Store({
		proxy: obj.QueryGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total'
		}, 
		[
			{name: 'AimIndex', mapping: 'AimIndex'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'PatSex', mapping: 'PatSex'}
			,{name: 'PatMrNo', mapping: 'PatMrNo'}
			,{name: 'PatAge', mapping: 'PatAge'}
			,{name: 'AdmitDate', mapping: 'AdmitDate'}
			,{name: 'DischDate', mapping: 'DischDate'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
			,{name: 'BornWeight', mapping: 'BornWeight'}
			
			,{name: 'NUCIntubateDate', mapping: 'NUCIntubateDate'}
			,{name: 'NUCExtubateDate', mapping: 'NUCExtubateDate'}
			,{name: 'NUCIsInfection', mapping: 'NUCIsInfection'}
			,{name: 'NUCInfDate', mapping: 'NUCInfDate'}
			,{name: 'NUCInfPyDescs', mapping: 'NUCInfPyDescs'}
			
			,{name: 'NPICCIntubateDate', mapping: 'NPICCIntubateDate'}
			,{name: 'NPICCExtubateDate', mapping: 'NPICCExtubateDate'}
			,{name: 'NPICCIsInfection', mapping: 'NPICCIsInfection'}
			,{name: 'NPICCInfDate', mapping: 'NPICCInfDate'}
			,{name: 'NPICCInfPyDescs', mapping: 'NPICCInfPyDescs'}
			
			,{name: 'NVNTIntubateDate', mapping: 'NVNTIntubateDate'}
			,{name: 'NVNTExtubateDate', mapping: 'NVNTExtubateDate'}
			,{name: 'NVNTIsInfection', mapping: 'NVNTIsInfection'}
			,{name: 'NVNTInfDate', mapping: 'NVNTInfDate'}
			,{name: 'NVNTInfPyDescs', mapping: 'NVNTInfPyDescs'}
			
			,{name: 'NICUInfDate', mapping: 'NICUInfDate'}
			,{name: 'NIUCDiagnose', mapping: 'NIUCDiagnose'}
		])
	});
	obj.QueryGridPanel = new Ext.grid.GridPanel({
		id : 'QueryGridPanel'
		,store : obj.QueryGridPanelStore
		,region : 'center'
		,columnLines : true
		,loadMask : true
		,plugins: obj.GridColumnHeaderGroup
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '科室', width: 100, dataIndex: 'LocDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '姓名', width: 80, dataIndex: 'PatName', sortable: false, menuDisabled:true, align:'center' }
			,{header: '病案号', width: 80, dataIndex: 'PatMrNo', sortable: false, menuDisabled:true, align:'center' }
			,{header: '出生体重', width: 80, dataIndex: 'BornWeight', sortable: false, menuDisabled:true, align:'center' }
			,{header: '入院日期', width: 80, dataIndex: 'AdmitDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '出院日期', width: 80, dataIndex: 'DischDate', sortable: false, menuDisabled:true, align:'center' }
			
			,{header: '置管日期', width: 80, dataIndex: 'NUCIntubateDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '拔管日期', width: 80, dataIndex: 'NUCExtubateDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '是否<br>感染', width: 50, dataIndex: 'NUCIsInfection', sortable: false, menuDisabled:true, align:'center' }
			,{header: '感染日期', width: 80, dataIndex: 'NUCInfDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '病原体', width: 100, dataIndex: 'NUCInfPyDescs', sortable: false, menuDisabled:true, align:'center' }
			
			,{header: '置管日期', width: 80, dataIndex: 'NPICCIntubateDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '拔管日期', width: 80, dataIndex: 'NPICCExtubateDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '是否<br>感染', width: 50, dataIndex: 'NPICCIsInfection', sortable: false, menuDisabled:true, align:'center' }
			,{header: '感染日期', width: 80, dataIndex: 'NPICCInfDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '病原体', width: 100, dataIndex: 'NPICCInfPyDescs', sortable: false, menuDisabled:true, align:'center' }
			
			,{header: '置管日期', width: 80, dataIndex: 'NVNTIntubateDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '拔管日期', width: 80, dataIndex: 'NVNTExtubateDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '是否<br>感染', width: 50, dataIndex: 'NVNTIsInfection', sortable: false, menuDisabled:true, align:'center' }
			,{header: '感染日期', width: 80, dataIndex: 'NVNTInfDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '病原体', width: 100, dataIndex: 'NVNTInfPyDescs', sortable: false, menuDisabled:true, align:'center' }
			
			,{header: '感染日期', width: 80, dataIndex: 'NICUInfDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '感染诊断', width: 100, dataIndex: 'NIUCDiagnose', sortable: false, menuDisabled:true, align:'center' }
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
				title : 'NICU信息汇总表',
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
								labelWidth : 40,
								boxMinWidth : 100,
								boxMaxWidth : 300,
								items : [obj.cboLoc]
							},{
								width:100,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [obj.chkIsCommit]
							}
						]
					},
					{
						layout : 'column',
						items : [
							{
								columnWidth:.50
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
		param.ClassName = 'DHCMed.NINFService.Rep.AimReportNICU';
		param.QueryName = 'QryRepInfoByDateLoc';
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

