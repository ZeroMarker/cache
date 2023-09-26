function InitViewport(){
	var obj = new Object();
	
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.dfDateFrom 	= Common_DateFieldToDate("dfDateFrom","收费日期");
	obj.dfDateTo	= Common_DateFieldToDate("dfDateTo","至");
	
	obj.cboFeeItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboFeeItemStore = new Ext.data.Store({
		proxy: obj.cboFeeItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'FICode', mapping: 'FICode'}
			,{name: 'FIDesc', mapping: 'FIDesc'}
		])
	});
	obj.cboFeeItem = new Ext.form.ComboBox({
		id : 'cboFeeItem'
		,minChars : 1
		,store : obj.cboFeeItemStore
		,valueField : 'ID'
		,fieldLabel : '收费类型'
		,labelSeparator :''
		,displayField : 'FIDesc'
		,triggerAction : 'all'
		,width : 50
		,anchor : '99%'
	});
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 80
		,anchor : '100%'
		,text : '查找'
	});
	
	obj.FeeRecordListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.FeeRecordListStore = new Ext.data.Store({
		proxy: obj.FeeRecordListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'ID', mapping: 'ID'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'MrTypeID', mapping: 'MrTypeID'}
			,{name: 'MrTypeDesc', mapping: 'MrTypeDesc'}
			,{name: 'MrNo', mapping: 'MrNo'}
			,{name: 'FeeItemID', mapping: 'FeeItemID'}
			,{name: 'FeeItemCode', mapping: 'FeeItemCode'}
			,{name: 'FeeItemDesc', mapping: 'FeeItemDesc'}
			,{name: 'Status', mapping: 'Status'}
			,{name: 'StatusDesc', mapping: 'StatusDesc'}
			,{name: 'FeeDate', mapping: 'FeeDate'}
			,{name: 'FeeTime', mapping: 'FeeTime'}
			,{name: 'FeeUserDesc', mapping: 'FeeUserDesc'}
			,{name: 'FeeLocDesc', mapping: 'FeeLocDesc'}
			,{name: 'RetDate', mapping: 'RetDate'}
			,{name: 'RetTime', mapping: 'RetTime'}
			,{name: 'RetUserDesc', mapping: 'RetUserDesc'}
			,{name: 'RetLocDesc', mapping: 'RetLocDesc'}
			,{name: 'Money', mapping: 'Money'}
			,{name: 'InvNo', mapping: 'InvNo'}
		])
	});
	obj.FeeRecordList = new Ext.grid.GridPanel({
		id : 'FeeRecordList'
		,store : obj.FeeRecordListStore
		,columnLines:true
		,loadMask : true
		,region : 'center'
		,layout : 'fit'
		,tbar : [
			{id:'msgFeeRecordList',text:'病案收费明细查询',style:'font-weight:bold;font-size:14px;',xtype:'label'}
			,'->','-',obj.btnQuery]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '患者姓名', width: 60, dataIndex: 'PatName', align: 'center'}
			,{header: '病案号', width: 70, dataIndex: 'MrNo', align: 'center'}
			,{header: '收费项', width: 60, dataIndex: 'FeeItemDesc', align: 'center'}
			,{header: '收费日期', width: 70, dataIndex: 'FeeDate', align: 'center'}
			,{header: '收费时间', width: 70, dataIndex: 'FeeTime', align: 'center'}	
			,{header: '收费员', width: 60, dataIndex: 'FeeUserDesc', align: 'center'}
			,{header: '收费科室', width: 70, dataIndex: 'FeeLocDesc', align: 'center'}
			,{header: '金额', width: 70, dataIndex: 'Money', align: 'center'}
			,{header: '收费状态', width: 60, dataIndex: 'StatusDesc', align: 'center'}
			,{header: '发票号', width: 70, dataIndex: 'InvNo', align: 'center'}
			,{header: '退费日期', width: 70, dataIndex: 'RetDate', align: 'center'}
			,{header: '退费时间', width: 60, dataIndex: 'RetTime', align: 'center'}
			,{header: '退费人员', width: 70, dataIndex: 'RetUserDesc', align: 'center'}
			,{header: '退费科室', width: 70, dataIndex: 'RetLocDesc', align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.FeeRecordListStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,view:new Ext.grid.GridView({
			forceFit : true
		})
	});
	
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
				{
					region:'north'
					,layout:'column'
					,height: 35
					,frame: true
					,items:[
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
							width:170
							,layout : 'form'
							,labelAlign : 'right'
							,labelWidth : 70
							,items:[obj.cboFeeItem]
						}
					]
				}
				,obj.FeeRecordList
		]
	});
	
	obj.cboFeeItemStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.MFService.FeeItemSrv';
			param.QueryName = 'QryFeeItem';
			param.ArgCnt = 0;
	});
	obj.cboFeeItemStore.load();
	
	obj.FeeRecordListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.MFService.FeeRecordSrv';
		param.QueryName = 'QryFeeRecord';
		param.Arg1 = Common_GetValue("cboHospital");
		param.Arg2 = Common_GetValue("cboMrType");
		param.Arg3 = Common_GetValue("cboFeeItem");
		param.Arg4 = Common_GetValue("dfDateFrom");
		param.Arg5 = Common_GetValue("dfDateTo");
		param.ArgCnt = 5;
	});
	
	InitViewportEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}