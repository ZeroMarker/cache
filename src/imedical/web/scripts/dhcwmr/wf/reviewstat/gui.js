var objScreen = new Object();
function InitviewScreen(){
    var obj = objScreen;
	
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.dfDateFrom = Common_DateFieldToDate("dfDateFrom","出院日期");
	obj.dfDateTo = Common_DateFieldToDate("dfDateTo","至");
	
	obj.btnReViewStat = new Ext.Button({
		id : 'btnReViewStat'
		,iconCls : 'icon-find'
		,width : 70
		,anchor : '100%'
		,text : '统计'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 70
		,anchor : '100%'
		,text : '导出Excel'
	});
	
	obj.gridReViewStatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridReViewStatStore = new Ext.data.Store({
		proxy: obj.gridReViewStatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'StatLocID'
		},[
			{name: 'StatLocID', mapping : 'StatLocID'}
			,{name: 'StatLocDesc', mapping : 'StatLocDesc'}
			,{name: 'DischCnt', mapping : 'DischCnt'}
			,{name: 'BackCnt', mapping : 'BackCnt'}
			,{name: 'UnReViewCnt', mapping : 'UnReViewCnt'}
			,{name: 'BackRatio', mapping : 'BackRatio'}
			,{name: 'UnReViewRatio', mapping : 'UnReViewRatio'}
		])
	});
	obj.gridReViewStat = new Ext.grid.GridPanel({
		id : 'gridReViewStat'
		,store : obj.gridReViewStatStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,height : 310
		,loadMask : true
		,tbar : [{id:'msggridReViewStat',text:'复核不通过统计结果',style:'font-weight:bold;font-size:14px;',xtype:'label'},
		'->','-',obj.btnReViewStat,'-',obj.btnExport,'-']
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '科室', width: 150, dataIndex: 'StatLocDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '出院人数', width: 100, dataIndex: 'DischCnt', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '回收人数', width: 100, dataIndex: 'BackCnt', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '复核不通过人数', width: 100, dataIndex: 'UnReViewCnt', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '回收率', width: 80, dataIndex: 'BackRatio', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '复核不通过率', width: 80, dataIndex: 'UnReViewRatio', sortable: false, menuDisabled:true, align: 'center'}
			//,{header: '', width: 0, dataIndex: '', sortable: false, menuDisabled:true, align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.gridReViewStatStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.ViewPort = new Ext.Viewport({
		id : 'ViewPort'
		,layout : 'border'
		,items:[
			{
				region: 'north',
				height: 35,
				layout : 'column',
				frame : true,
				labelWidth : 70,
				buttonAlign : 'center',
				items : [
					{
						width:220
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.cboHospital]
					},{
						width:170
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.cboMrType]
					},{
						width:200
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.dfDateFrom]
					},{
						width:150
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 30
						,items: [obj.dfDateTo]
					}
				]
			}
			,obj.gridReViewStat
		]
	});
	
	obj.gridReViewStatStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.ReviewQry';
		param.QueryName = 'QueryReViewStat';
		param.Arg1 = Common_GetValue("cboHospital");
		param.Arg2 = Common_GetValue("cboMrType");
		param.Arg3 = Common_GetValue("dfDateFrom");
		param.Arg4 = Common_GetValue("dfDateTo");
		param.ArgCnt = 4;
	});
	
	InitviewScreenEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}