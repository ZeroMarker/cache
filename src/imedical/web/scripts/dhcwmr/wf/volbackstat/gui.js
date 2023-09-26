var objScreen = new Object();
function InitviewScreen(){
    var obj = objScreen;
	
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.dfDateFrom = Common_DateFieldToDate("dfDateFrom","出院日期");
	obj.dfDateTo = Common_DateFieldToDate("dfDateTo","至");
	
	//科室组
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
		function(conn, response, Options){
		if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
			ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	);
	obj.cboLocGroupStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboLocGroupStore = new Ext.data.Store({
		proxy: obj.cboLocGroupStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'GroupID'
		},[
			{name: 'GroupID', mapping : 'GroupID'}
			,{name: 'GroupCode', mapping: 'GroupCode'}
			,{name: 'GroupDesc', mapping: 'GroupDesc'}
		])
	});
	obj.cboLocGroup = new Ext.form.ComboBox({
		id : 'cboLocGroup'
		,fieldLabel : '科室组'
		,store : obj.cboLocGroupStore
		,minChars : 1
		,valueField : 'GroupID'
		,displayField : 'GroupDesc'
		,editable : true
		,triggerAction : 'all'
		,width : 80
		,anchor : '100%'
	});
	
	//科室
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
		function(conn, response, Options){
		if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
			ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	);
	obj.cboLocStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboLocStore = new Ext.data.Store({
		proxy: obj.cboLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'LocID'
		},[
			{name: 'LocID', mapping : 'LocID'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
		])
	});
	obj.cboLoc = new Ext.form.ComboBox({
		id : 'cboLoc'
		,fieldLabel : '科室'
		,store : obj.cboLocStore
		,minChars : 1
		,valueField : 'LocID'
		,displayField : 'LocDesc'
		,editable : true
		,triggerAction : 'all'
		,width : 80
		,anchor : '100%'
	});
	
	obj.btnLateStat = new Ext.Button({
		id : 'btnLateStat'
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
	
	obj.gridVolLateStatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridVolLateStatStore = new Ext.data.Store({
		proxy: obj.gridVolLateStatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'StatLocID'
		},[
			{name: 'StatLocID', mapping : 'StatLocID'}
			,{name: 'StatLocDesc', mapping : 'StatLocDesc'}
			,{name: 'DischCnt', mapping : 'DischCnt'}
			,{name: 'Dis1DBackCnt', mapping : 'Dis1DBackCnt'}
			,{name: 'Dis2DBackCnt', mapping : 'Dis2DBackCnt'}
			,{name: 'Dis3DBackCnt', mapping : 'Dis3DBackCnt'}
			,{name: 'Dis7DBackCnt', mapping : 'Dis7DBackCnt'}
			,{name: 'Dis1DBackRatio', mapping : 'Dis1DBackRatio'}
			,{name: 'Dis2DBackRatio', mapping : 'Dis2DBackRatio'}
			,{name: 'Dis3DBackRatio', mapping : 'Dis3DBackRatio'}
			,{name: 'Dis7DBackRatio', mapping : 'Dis7DBackRatio'}
			,{name: 'DeathCnt', mapping : 'DeathCnt'}
			,{name: 'Dth6DBackCnt', mapping : 'Dth6DBackCnt'}
			,{name: 'Dth6DBackRatio', mapping : 'Dth6DBackRatio'}
		])
	});
	obj.gridVolLateStat = new Ext.grid.GridPanel({
		id : 'gridVolLateStat'
		,store : obj.gridVolLateStatStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,height : 310
		,loadMask : true
		,tbar : [{id:'msggridVolLateStat',text:'统计结果',style:'font-weight:bold;font-size:14px;',xtype:'label'},
		'->','-',obj.btnLateStat,'-',obj.btnExport,'-']
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '科室', width: 200, dataIndex: 'StatLocDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '出院人数', width: 80, dataIndex: 'DischCnt', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '1日回收人数', width: 80, dataIndex: 'Dis1DBackCnt', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '2日回收人数', width: 80, dataIndex: 'Dis2DBackCnt', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '3日回收人数', width: 80, dataIndex: 'Dis3DBackCnt', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '7日回收人数', width: 80, dataIndex: 'Dis7DBackCnt', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '1日回收率', width: 80, dataIndex: 'Dis1DBackRatio', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '2日回收率', width: 80, dataIndex: 'Dis2DBackRatio', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '3日回收率', width: 80, dataIndex: 'Dis3DBackRatio', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '7日回收率', width: 80, dataIndex: 'Dis7DBackRatio', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '死亡人数', width: 80, dataIndex: 'DeathCnt', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '6日回收人数', width: 80, dataIndex: 'Dth6DBackCnt', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '6日回收率', width: 80, dataIndex: 'Dth6DBackRatio', sortable: false, menuDisabled:true, align: 'center'}
			//,{header: '', width: 0, dataIndex: '', sortable: false, menuDisabled:true, align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.gridVolLateStatStore,
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
						width:170
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.dfDateFrom]
					},{
						width:130
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 30
						,items: [obj.dfDateTo]
					},{
						width:120
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 50
						,items: [obj.cboLocGroup]
					},{
						width:200
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.cboLoc]
					}
				]
			}
			,obj.gridVolLateStat
		]
	});
	
	obj.cboLocGroupStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.LocGroupSrv';
		param.QueryName = 'QryCboLocGroup';
		param.Arg1 = Common_GetValue('cboHospital');
		param.Arg2 = obj.cboLocGroup.getRawValue();
		param.ArgCnt = 2;
	});
	
	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.LocGroupSrv';
		param.QueryName = 'QryCboLocList';
		param.Arg1 = Common_GetValue('cboHospital');
		param.Arg2 = Common_GetValue('cboLocGroup');
		param.Arg3 = obj.cboLoc.getRawValue();
		param.ArgCnt = 3;
	});
	
	obj.gridVolLateStatStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.VolBackQry';
		param.QueryName = 'QryVolBackStat';
		param.Arg1 = Common_GetValue("cboHospital");
		param.Arg2 = Common_GetValue("cboMrType");
		param.Arg3 = Common_GetValue("dfDateFrom");
		param.Arg4 = Common_GetValue("dfDateTo");
		param.Arg5 = Common_GetValue("cboLocGroup");
		param.Arg6 = Common_GetValue("cboLoc");
		param.ArgCnt = 6;
	});
	InitviewScreenEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}