
function InitViewport()
{
	var obj = new Object();
	
	obj.cboDateType = Common_ComboToDateType1("cboDateType","日期类型","报告日期");
	obj.txtDateFrom = Common_DateFieldToDate("txtDateFrom","开始日期");
	obj.txtDateTo = Common_DateFieldToDate("txtDateTo","结束日期");
	obj.cboRepLoc = Common_ComboToLoc("cboRepLoc","科室","E");
	
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
			{name: 'LocDescStr', mapping : 'LocDescStr'}
			,{name: 'RepNum', mapping : 'RepNum'}
			,{name: 'LocRepNum', mapping : 'LocRepNum'}
			,{name: 'InfRepNum', mapping : 'InfRepNum'}
			,{name: 'InfRepRate', mapping : 'InfRepRate'}
			,{name: 'DPNum1', mapping : 'DPNum1'}
			,{name: 'DPNum2', mapping : 'DPNum2'}
			,{name: 'DPNum3', mapping : 'DPNum3'}
			,{name: 'DPNum4', mapping : 'DPNum4'}
			,{name: 'DPNum5', mapping : 'DPNum5'}
			,{name: 'DPNum1Rate', mapping : 'DPNum1Rate'}
			,{name: 'DPNum2Rate', mapping : 'DPNum2Rate'}
			,{name: 'DPNum3Rate', mapping : 'DPNum3Rate'}
			,{name: 'DPNum4Rate', mapping : 'DPNum4Rate'}
			,{name: 'DPNum5Rate', mapping : 'DPNum5Rate'}
			,{name: 'DRNum1', mapping : 'DRNum1'}
			,{name: 'DRNum2', mapping : 'DRNum2'}
			,{name: 'DRNum3', mapping : 'DRNum3'}
			,{name: 'DRNum1Rate', mapping : 'DRNum1Rate'}
			,{name: 'DRNum2Rate', mapping : 'DRNum2Rate'}
			,{name: 'DRNum3Rate', mapping : 'DRNum3Rate'}
			,{name: 'OperNum1', mapping : 'OperNum1'}
			,{name: 'OperNum2', mapping : 'OperNum2'}
			,{name: 'OperNum3', mapping : 'OperNum3'}
			,{name: 'OperNum1Rate', mapping : 'OperNum1Rate'}
			,{name: 'OperNum2Rate', mapping : 'OperNum2Rate'}
			,{name: 'OperNum3Rate', mapping : 'OperNum3Rate'}
			,{name: 'MenNum', mapping : 'MenNum'}
			,{name: 'WoMenNum', mapping : 'WoMenNum'}
			,{name: 'MenNumRate', mapping : 'MenNumRate'}
			,{name: 'WoMenNumRate', mapping : 'WoMenNumRate'}
			,{name: 'Age1', mapping : 'Age1'}
			,{name: 'Age2', mapping : 'Age2'}
			,{name: 'Age3', mapping : 'Age3'}
			,{name: 'Age4', mapping : 'Age4'}
			,{name: 'Age5', mapping : 'Age5'}
			,{name: 'Age6', mapping : 'Age6'}
			,{name: 'Age1Rate', mapping : 'Age1Rate'}
			,{name: 'Age2Rate', mapping : 'Age2Rate'}
			,{name: 'Age3Rate', mapping : 'Age3Rate'}
			,{name: 'Age4Rate', mapping : 'Age4Rate'}
			,{name: 'Age5Rate', mapping : 'Age5Rate'}
			,{name: 'Age6Rate', mapping : 'Age6Rate'}
		])
	});
	obj.gridInfReport = new Ext.grid.GridPanel({
		id : 'gridInfReport'
		,store : obj.gridInfReportStore
		,region : 'center'
		,columnLines : true
		,loadMask : true
		,columns: [
			{header : '科室', width : 90, dataIndex : 'LocDescStr', sortable: false, menuDisabled:true, align:'center' }
			,{header : '报告数量', width : 80, dataIndex : 'RepNum', sortable: false, menuDisabled:true, align:'center' }
			,{header : '科室报告数', width : 80, dataIndex : 'LocRepNum', sortable: false, menuDisabled:true, align:'center' }
			,{header : '漏报数', width : 80, dataIndex : 'InfRepNum', sortable: false, menuDisabled:true, align:'center' }
			,{header : '漏报率', width : 80, dataIndex : 'InfRepRate', sortable: false, menuDisabled:true, align:'center' }			
			,{header : '治愈', width : 80, dataIndex : 'DPNum1', sortable: false, menuDisabled:true, align:'center' }
			,{header : '好转', width : 80, dataIndex : 'DPNum2', sortable: false, menuDisabled:true, align:'center' }
			,{header : '无变化', width : 80, dataIndex : 'DPNum3', sortable: false, menuDisabled:true, align:'center' }
			,{header : '恶化', width : 80, dataIndex : 'DPNum4', sortable: false, menuDisabled:true, align:'center' }
			,{header : '死亡', width : 80, dataIndex : 'DPNum5', sortable: false, menuDisabled:true, align:'center' }
			,{header : '治愈率', width : 80, dataIndex : 'DPNum1Rate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '好转率', width : 80, dataIndex : 'DPNum2Rate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '无变化率', width : 80, dataIndex : 'DPNum3Rate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '恶化率', width : 80, dataIndex : 'DPNum4Rate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '死亡率', width : 80, dataIndex : 'DPNum5Rate', sortable: false, menuDisabled:true, align:'center' }			
			,{header : '直接', width : 80, dataIndex : 'DRNum1', sortable: false, menuDisabled:true, align:'center' }
			,{header : '间接', width : 80, dataIndex : 'DRNum2', sortable: false, menuDisabled:true, align:'center' }
			,{header : '无关', width : 80, dataIndex : 'DRNum3', sortable: false, menuDisabled:true, align:'center' }
			,{header : '直接率', width : 80, dataIndex : 'DRNum1Rate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '间接率', width : 80, dataIndex : 'DRNum2Rate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '无关率', width : 80, dataIndex : 'DRNum3Rate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '表浅', width : 80, dataIndex : 'OperNum1', sortable: false, menuDisabled:true, align:'center' }
			,{header : '深部', width : 80, dataIndex : 'OperNum2', sortable: false, menuDisabled:true, align:'center' }
			,{header : '器官腔隙', width : 80, dataIndex : 'OperNum3', sortable: false, menuDisabled:true, align:'center' }			
			,{header : '表浅率', width : 80, dataIndex : 'OperNum1Rate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '深部率', width : 80, dataIndex : 'OperNum2Rate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '器官腔隙率', width : 80, dataIndex : 'OperNum3Rate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '男', width : 80, dataIndex : 'MenNum', sortable: false, menuDisabled:true, align:'center' }
			,{header : '女', width : 80, dataIndex : 'WoMenNum', sortable: false, menuDisabled:true, align:'center' }
			,{header : '男比例', width : 80, dataIndex : 'MenNumRate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '女比例', width : 80, dataIndex : 'WoMenNumRate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '0-6', width : 80, dataIndex : 'Age1', sortable: false, menuDisabled:true, align:'center' }
			,{header : '7-17', width : 80, dataIndex : 'Age2', sortable: false, menuDisabled:true, align:'center' }
			,{header : '18-40', width : 80, dataIndex : 'Age3', sortable: false, menuDisabled:true, align:'center' }
			,{header : '41-65', width : 80, dataIndex : 'Age4', sortable: false, menuDisabled:true, align:'center' }
			,{header : '66-89', width : 80, dataIndex : 'Age5', sortable: false, menuDisabled:true, align:'center' }
			,{header : '90以上', width : 80, dataIndex : 'Age6', sortable: false, menuDisabled:true, align:'center' }
			,{header : '0-6率', width : 80, dataIndex : 'Age1Rate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '7-17率', width : 80, dataIndex : 'Age2Rate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '18-40率', width : 80, dataIndex : 'Age3Rate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '41-65率', width : 80, dataIndex : 'Age4Rate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '66-89率', width : 80, dataIndex : 'Age5Rate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '90以上率', width : 80, dataIndex : 'Age6Rate', sortable: false, menuDisabled:true, align:'center' }
			
		]
    });
	
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.gridInfReport,
			{
				layout : 'form',
				region : "north",
				height : 70,
				frame : true,
				buttonAlign : 'center',
				title : '感染报告相关信息查询',
				items : [
					{
						layout : 'column',
						items : [
							{
								columnWidth:25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 200,
								items : [
									obj.cboDateType
								]
							},{
								columnWidth:25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 200,
								items : [
									obj.cboRepLoc
								]
							},{
								columnWidth:25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 200,
								items : [
									obj.txtDateFrom
								]
							},{
								columnWidth:25,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 200,
								items : [
									obj.txtDateTo
								]
							},{
								columnWidth:10,
								layout : 'form',
								boxMinWidth : 80,
								boxMaxWidth : 80,
								items : [obj.btnQuery]
							},{
								columnWidth:10,
								layout : 'form',
								boxMinWidth : 80,
								boxMaxWidth : 80,
								items : [obj.btnExport]
							}
						]
					}
				]
			}
		]
	});
	
	obj.gridInfReportStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.InfRepInfoQry';
		param.QueryName = 'QryRepInfoByDateLoc';
		param.Arg1 = Common_GetValue('cboDateType');
		param.Arg2 = Common_GetValue('txtDateFrom');
		param.Arg3 = Common_GetValue('txtDateTo');
		param.Arg4 = Common_GetValue('cboRepLoc');
		param.ArgCnt = 4;
	});
	
	InitViewportEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}

