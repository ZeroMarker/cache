
function InitViewport()
{
	var obj = new Object();
	
	obj.TransType = TransType;
	
	obj.txtMonth = Common_DateFieldToMonth("txtMonth","年月");
	obj.cboLoc = Common_ComboToLoc("cboLoc","报告科室",obj.TransType);
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
	
	var gridHeader=[
		{header: '',align: 'center',colspan: 1}
		,{header: '<=1000 gm',align: 'center',colspan: 4}
		,{header: '1001-1500 gm',align: 'center',colspan: 4}
		,{header: '1501-2500 gm',align: 'center',colspan: 4}
		,{header: '>2500 gm',align: 'center',colspan: 4}
		,{header: '',align: 'center',colspan: 1}
		,{header: '',align: 'center',colspan: 1}
	];
	obj.GridColumnHeaderGroup = new Ext.ux.grid.ColumnHeaderGroup({
		rows: [gridHeader]
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
			{name : 'ind', mapping : 'ind'}
			,{name : 'i', mapping : 'i'}
			,{name : 'BW1Num', mapping : 'BW1Num'}
			,{name : 'BW2Num', mapping : 'BW2Num'}
			,{name : 'BW3Num', mapping : 'BW3Num'}
			,{name : 'BW4Num', mapping : 'BW4Num'}
			,{name : 'BWU1', mapping : 'BWU1'}
			,{name : 'BWP1', mapping : 'BWP1'}
			,{name : 'BWV1', mapping : 'BWV1'}
			,{name : 'BWU2', mapping : 'BWU2'}
			,{name : 'BWP2', mapping : 'BWP2'}
			,{name : 'BWV2', mapping : 'BWV2'}
			,{name : 'BWU3', mapping : 'BWU3'}
			,{name : 'BWP3', mapping : 'BWP3'}
			,{name : 'BWV3', mapping : 'BWV3'}
			,{name : 'BWU4', mapping : 'BWU4'}
			,{name : 'BWP4', mapping : 'BWP4'}
			,{name : 'BWV4', mapping : 'BWV4'}
			,{name : 'TotalNum', mapping : 'TotalNum'}
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
			    {header : '监测日期', width : 150, dataIndex : 'i', align : 'center', sortable : true}
        		,{header : 'Pts', width : 50, dataIndex : 'BW1Num', align : 'center', sortable : true}
        		,{header : 'U/C', width : 50, dataIndex : 'BWU1', align : 'center', sortable : true}
        		,{header : 'PICC', width : 50, dataIndex : 'BWP1', align : 'center', sortable : true}
        		,{header : 'VNT', width : 50, dataIndex : 'BWV1', align : 'center', sortable : true}
        		
        		,{header : 'Pts', width : 50, dataIndex : 'BW2Num', align : 'center', sortable : true}
        		,{header : 'U/C', width : 50, dataIndex : 'BWU2', align : 'center', sortable : true}
        		,{header : 'PICC', width : 50, dataIndex : 'BWP2', align : 'center', sortable : true}
        		,{header : 'VNT', width : 50, dataIndex : 'BWV2', align : 'center', sortable : true}
        		
        		,{header : 'Pts', width : 50, dataIndex : 'BW3Num', align : 'center', sortable : true}
        		,{header : 'U/C', width : 50, dataIndex : 'BWU3', align : 'center', sortable : true}
        		,{header : 'PICC', width : 50, dataIndex : 'BWP3', align : 'center', sortable : true}
        		,{header : 'VNT', width : 50, dataIndex : 'BWV3', align : 'center', sortable : true}
        		
        		,{header : 'Pts', width : 50, dataIndex : 'BW4Num', align : 'center', sortable : true}
        		,{header : 'U/C', width : 50, dataIndex : 'BWU4', align : 'center', sortable : true}
        		,{header : 'PICC', width : 50, dataIndex : 'BWP4', align : 'center', sortable : true}
        		,{header : 'VNT', width : 50, dataIndex : 'BWV4', align : 'center', sortable : true}
       
       			,{header : '汇总', width : 50, dataIndex : 'TotalNum', align : 'center', sortable : true}
				,{header : '', width : 30, dataIndex : '', align : 'center', sortable : true}
		]
		,viewConfig : {
			forceFit : true
			/*
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
			}*/
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
				buttonAlign : 'center',
				title : 'NICU信息月报表',
				items : [
					{
						layout : 'column',
						items : [
							{
								width : 160,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 40,
								items : [obj.txtMonth]
							},{
								columnWidth:1,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 40,
								boxMinWidth : 100,
								boxMaxWidth : 300,
								items : [obj.cboLoc]
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
		param.ClassName = 'DHCMed.NINFService.Rep.AimNICUInfoSrv';
		param.QueryName = 'QryByMonthLoc';
		param.Arg1 = Common_GetValue('txtMonth');
		param.Arg2 = Common_GetValue('cboLoc');
		param.Arg3 = obj.TransType;
		param.ArgCnt = 3;
	});
	
	InitViewportEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}

