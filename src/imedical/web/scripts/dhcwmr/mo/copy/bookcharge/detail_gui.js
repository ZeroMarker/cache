function InitDetailViewport()
{
	var obj = new Object();
	obj.CopyRecordID = arguments[0];
	
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
			,{name: 'MrNo', mapping: 'MrNo'}
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
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '费用状态', width: 60, dataIndex: 'StatusDesc', align: 'center'}
			,{header: '收费日期', width: 70, dataIndex: 'FeeDate', align: 'center'}
			,{header: '登记时间', width: 70, dataIndex: 'FeeTime', align: 'center'}	
			,{header: '收费人员', width: 60, dataIndex: 'FeeUserDesc', align: 'center'}
			,{header: '收费科室', width: 70, dataIndex: 'FeeLocDesc', align: 'center'}
			,{header: '退费日期', width: 70, dataIndex: 'RetDate', align: 'center'}
			,{header: '退费时间', width: 60, dataIndex: 'RetTime', align: 'center'}
			,{header: '退费人员', width: 70, dataIndex: 'RetUserDesc', align: 'center'}
			,{header: '退费科室', width: 70, dataIndex: 'RetLocDesc', align: 'center'}
			,{header: '金额', width: 70, dataIndex: 'Money', align: 'center'}
			,{header: '发票号', width: 70, dataIndex: 'InvNo', align: 'center'}
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
	
	obj.DetailViewport = new Ext.Window({
		id: 'DetailViewport'
		,height : 550
		,width : 700
		,modal : true
		,title : '操作明细'
		,closable : true
		,layout : 'border'
		,items:[obj.FeeRecordList]
	});
	
	obj.FeeRecordListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.MFService.FeeRecordSrv';
		param.QueryName = 'QryFeeByCopyID';
		param.Arg1 = obj.CopyRecordID;
		param.ArgCnt = 1;
	});
	
	InitDetailViewportEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}