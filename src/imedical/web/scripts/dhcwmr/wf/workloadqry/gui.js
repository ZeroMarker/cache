var objScreen = new Object();
function InitviewScreen(){
    var obj = objScreen;
	
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.dfDateFrom = Common_DateFieldToDate("dfDateFrom","操作日期");
	obj.dfDateTo = Common_DateFieldToDate("dfDateTo","至");
	obj.cboWFItem = Common_ComboToWFItem("cboWFItem","操作项目","cboMrType");
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 80
		,anchor : '100%'
		,text : '查询'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 80
		,anchor : '100%'
		,text : '导出Excel'
	});
	
	obj.WorkLoadGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.WorkLoadGridStore = new Ext.data.Store({
		proxy: obj.WorkLoadGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'IndexNo'
		},[
			{name: 'IndexNo', mapping : 'IndexNo'}
			,{name: 'UserID', mapping : 'UserID'}
			,{name: 'UserDesc', mapping : 'UserDesc'}
			,{name: 'Item1', mapping : 'Item1'}
			,{name: 'Item2', mapping : 'Item2'}
			,{name: 'Item3', mapping : 'Item3'}
			,{name: 'Item4', mapping : 'Item4'}
			,{name: 'Item5', mapping : 'Item5'}
			,{name: 'Item6', mapping : 'Item6'}
			,{name: 'Item7', mapping : 'Item7'}
			,{name: 'Item8', mapping : 'Item8'}
			,{name: 'Item9', mapping : 'Item9'}
			,{name: 'Item10', mapping : 'Item10'}
			,{name: 'Item11', mapping : 'Item11'}
			,{name: 'Item12', mapping : 'Item12'}
			,{name: 'Item13', mapping : 'Item13'}
			,{name: 'Item14', mapping : 'Item14'}
			,{name: 'Item15', mapping : 'Item15'}
			,{name: 'Item16', mapping : 'Item16'}
			,{name: 'Item17', mapping : 'Item17'}
			,{name: 'Item18', mapping : 'Item18'}
			,{name: 'Item19', mapping : 'Item19'}
			,{name: 'Item20', mapping : 'Item20'}
			,{name: 'Item21', mapping : 'Item21'}
			,{name: 'Item22', mapping : 'Item22'}
			,{name: 'Item23', mapping : 'Item23'}
			,{name: 'Item24', mapping : 'Item24'}
			,{name: 'Item25', mapping : 'Item25'}
		])
	});
	obj.WorkLoadGrid = new Ext.grid.GridPanel({
		id : 'WorkLoadGrid'
		,store : obj.WorkLoadGridStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,height : 310
		,loadMask : { msg : '正在查询,请稍后...'}
		,tbar : [
			{id:'msgWorkLoadGrid',text:'工作量统计查询结果',style:'font-weight:bold;font-size:14px;',xtype:'label'}
			,'->','-',obj.btnQuery,'-',obj.btnExport,'-'
		]
		,columns: [
			{header: '操作员', width: 70, dataIndex: 'UserDesc', sortable: false, menuDisabled:true, align : 'center'}
		]
		,viewConfig : {
			//forceFit : true
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
					},{
						width:200
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.cboWFItem]
					}
				]
			}
			,obj.WorkLoadGrid
		]
	});
	
	obj.WorkLoadGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.WorkloadSrv';
			param.QueryName = 'StatWorkload';
			param.Arg1 = Common_GetValue("cboHospital");
			param.Arg2 = Common_GetValue("cboMrType");
			param.Arg3 = Common_GetValue("dfDateFrom");
			param.Arg4 = Common_GetValue("dfDateTo");
			param.Arg5 = Common_GetValue("cboWFItem");
			param.ArgCnt = 5;
	});
	
	InitviewScreenEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}