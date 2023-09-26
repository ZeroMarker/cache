
function InitViewport()
{
	var obj = new Object();
	
	obj.TransType = TransType;
	
	obj.txtMonthFrom = Common_DateFieldToMonth("txtMonthFrom","开始时间");
	obj.txtMonthTo = Common_DateFieldToMonth("txtMonthTo","结束时间");
	
	var LogLocID = session['LOGON.CTLOCID'];
	obj.AdminPower  = '0';

	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.cboLoc = Common_ComboToLoc("cboLoc","科室",obj.TransType);
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}else
		{
			
		obj.cboLoc = Common_ComboToLoc("cboLoc","科室",obj.TransType,LogLocID);	
			
		}
	}else
		{
			
		obj.cboLoc = Common_ComboToLoc("cboLoc","科室",obj.TransType,LogLocID);	
			
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
		url : ExtToolSetting.RunQueryPageURL,
		timeout : 300000,
				method : 'POST'
	}));
	obj.QueryGridPanelStore = new Ext.data.Store({
		proxy: obj.QueryGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total'
		}, 
		[
			{name : 'AimIndex', mapping : 'AimIndex'}
			,{name : 'AimMonth', mapping : 'AimMonth'}
			,{name : 'AimLocDesc', mapping : 'AimLocDesc'}
			,{name : 'IPDays', mapping : 'IPDays'}
			,{name : 'IPNum', mapping : 'IPNum'}
			,{name : 'UCDays', mapping : 'UCDays'}
			,{name : 'UCRatio', mapping : 'UCRatio'}
			,{name : 'UCInfNum', mapping : 'UCInfNum'}
			,{name : 'UCInfRatio', mapping : 'UCInfRatio'}
			,{name : 'UCInfPats', mapping : 'UCInfPats'}
			,{name : 'PICCDays', mapping : 'PICCDays'}
			,{name : 'PICCRatio', mapping : 'PICCRatio'}
			,{name : 'PICCInfNum', mapping : 'PICCInfNum'}
			,{name : 'PICCInfRatio', mapping : 'PICCInfRatio'}
			,{name : 'PICCInfPats', mapping : 'PICCInfPats'}
			,{name : 'VAPDays', mapping : 'VAPDays'}
			,{name : 'VAPRatio', mapping : 'VAPRatio'}
			,{name : 'VAPInfNum', mapping : 'VAPInfNum'}
			,{name : 'VAPInfRatio', mapping : 'VAPInfRatio'}
			,{name : 'VAPInfPats', mapping : 'VAPInfPats'}
			,{name : 'OPRNum', mapping : 'OPRNum'}
			,{name : 'OPRInfNum', mapping : 'OPRInfNum'}
			,{name : 'OPRInfRatio', mapping : 'OPRInfRatio'}
			,{name : 'OPRInfPats', mapping : 'OPRInfPats'}
			,{name : 'InfNums', mapping : 'InfNums'}
			,{name : 'InfRatio', mapping : 'InfRatio'}
			,{name : 'xLocID', mapping : 'xLocID'}
			
			,{name : 'Score0', mapping : 'Score0'}
			,{name : 'Score1', mapping : 'Score1'}
			,{name : 'Score2', mapping : 'Score2'}
			,{name : 'Score3', mapping : 'Score3'}
			
			,{name : 'Inf0Rate', mapping : 'Inf0Rate'}
			,{name : 'Inf1Rate', mapping : 'Inf1Rate'}
			,{name : 'Inf2Rate', mapping : 'Inf2Rate'}
			,{name : 'Inf3Rate', mapping : 'Inf3Rate'}
		])
	});
	obj.QueryGridPanel = new Ext.grid.GridPanel({
		id : 'QueryGridPanel'
		,store : obj.QueryGridPanelStore
		,region : 'center'
		,columnLines : true
		,loadMask : true
		,columns: [
			{header : '科室', width : 150, dataIndex : 'AimLocDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header : 'id', width : 120, dataIndex : 'xLocID', sortable: false, menuDisabled:true, align:'center' }
			,{header : '年月', width : 120, dataIndex : 'AimMonth', sortable: false, menuDisabled:true, align:'center' }
			,{header : '午夜12点病人总数', width : 120, dataIndex : 'IPDays', sortable: false, menuDisabled:true, align:'center' }
			,{header : '住院人次', width : 70, dataIndex : 'IPNum', sortable: false, menuDisabled:true, align:'center' }
			,{header : '院感发生例数', width : 110, dataIndex : 'InfNums', sortable: false, menuDisabled:true, align:'center' }
			,{header : '院感发生率', width : 90, dataIndex : 'InfRatio', sortable: false, menuDisabled:true, align:'center' }
			
			,{header : '0分<br>手术例数', width : 60, dataIndex : 'Score0', sortable: false, menuDisabled:true, align:'center' }
			,{header : '0分<br>感染率', width : 50, dataIndex : 'Inf0Rate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '1分<br>手术例数', width : 60, dataIndex : 'Score1', sortable: false, menuDisabled:true, align:'center' }
			,{header : '1分<br>感染率', width : 50, dataIndex : 'Inf1Rate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '2分<br>手术例数', width : 60, dataIndex : 'Score2', sortable: false, menuDisabled:true, align:'center' }
			,{header : '2分<br>感染率', width : 50, dataIndex : 'Inf2Rate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '3分<br>手术例数', width : 60, dataIndex : 'Score3', sortable: false, menuDisabled:true, align:'center' }
			,{header : '3分<br>感染率', width : 50, dataIndex : 'Inf3Rate', sortable: false, menuDisabled:true, align:'center' }		
			
			
			,{header : '尿管日数', width : 70, dataIndex : 'UCDays', sortable: false, menuDisabled:true, align:'center' }
			,{header : '尿管<br>使用率', width : 70, dataIndex : 'UCRatio', sortable: false, menuDisabled:true, align:'center' }
			,{header : '尿管感染例数', width : 90, dataIndex : 'UCInfNum', sortable: false, menuDisabled:true, align:'center' }
			,{header : '尿管<br>感染率', width : 70, dataIndex : 'UCInfRatio', sortable: false, menuDisabled:true, align:'center' }
			,{header : '尿管感染患者<br>信息', width : 300, dataIndex : 'UCInfPats', sortable: false, menuDisabled:true, align:'center' }
			,{header : '导管日数', width : 70, dataIndex : 'PICCDays', sortable: false, menuDisabled:true, align:'center' }
			,{header : '导管<br>使用率', width : 70, dataIndex : 'PICCRatio', sortable: false, menuDisabled:true, align:'center' }
			,{header : '导管感染<br>例数', width : 70, dataIndex : 'PICCInfNum', sortable: false, menuDisabled:true, align:'center' }
			,{header : '导管<br>感染率', width : 70, dataIndex : 'PICCInfRatio', sortable: false, menuDisabled:true, align:'center' }
			,{header : '导管感染患者<br>信息', width : 300, dataIndex : 'PICCInfPats', sortable: false, menuDisabled:true, align:'center' }
			,{header : '呼吸机日数', width : 80, dataIndex : 'VAPDays', sortable: false, menuDisabled:true, align:'center' }
			,{header : '呼吸机<br>使用率', width : 60, dataIndex : 'VAPRatio', sortable: false, menuDisabled:true, align:'center' }
			,{header : '呼吸机<br>感染例数', width : 70, dataIndex : 'VAPInfNum', sortable: false, menuDisabled:true, align:'center' }
			,{header : '呼吸机<br>感染率', width : 80, dataIndex : 'VAPInfRatio', sortable: false, menuDisabled:true, align:'center' }
			,{header : '呼吸机感染患者<br>信息', width : 300, dataIndex : 'VAPInfPats', sortable: false, menuDisabled:true, align:'center' }
			,{header : '手术例数', width : 80, dataIndex : 'OPRNum', sortable: false, menuDisabled:true, align:'center' }
			,{header : '手术感染<br>例数', width : 70, dataIndex : 'OPRInfNum', sortable: false, menuDisabled:true, align:'center' }
			,{header : '手术<br>感染率', width : 60, dataIndex : 'OPRInfRatio', sortable: false, menuDisabled:true, align:'center' }
			,{header : '手术感染患者<br>信息', width : 200, dataIndex : 'OPRInfPats', sortable: false, menuDisabled:true, align:'center' }
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
				height : 60,
				frame : true,
				title : '院感监测统计表',
				buttonAlign : 'center',
				items : [
					{
						layout : 'column',
						items : [
							{
								width : 160,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [obj.txtMonthFrom]
							},{
								width : 160,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [obj.txtMonthTo]
							},{
								columnWidth:1,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 40,
								boxMinWidth : 100,
								boxMaxWidth : 300,
								items : [obj.cboLoc]
							},{
								width : 10
							},{
								width : 80,
								layout : 'form',
								items : [obj.btnQuery]
							},{
								width : 80,
								layout : 'form',
								items : [obj.btnExport]
							}
						]
					}
				]
			}
		]
	});
	
	obj.QueryGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.AimICUInfoSrv';
		param.QueryName = 'QryByMonthLoc';
		param.Arg1 = Common_GetValue('txtMonthFrom');
		param.Arg2 = Common_GetValue('txtMonthTo');
		param.Arg3 = Common_GetValue('cboLoc');
		param.Arg4 = obj.TransType;
		param.ArgCnt = 4;
	});
	
	InitViewportEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}

