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
			,{header: '����״̬', width: 60, dataIndex: 'StatusDesc', align: 'center'}
			,{header: '�շ�����', width: 70, dataIndex: 'FeeDate', align: 'center'}
			,{header: '�Ǽ�ʱ��', width: 70, dataIndex: 'FeeTime', align: 'center'}	
			,{header: '�շ���Ա', width: 60, dataIndex: 'FeeUserDesc', align: 'center'}
			,{header: '�շѿ���', width: 70, dataIndex: 'FeeLocDesc', align: 'center'}
			,{header: '�˷�����', width: 70, dataIndex: 'RetDate', align: 'center'}
			,{header: '�˷�ʱ��', width: 60, dataIndex: 'RetTime', align: 'center'}
			,{header: '�˷���Ա', width: 70, dataIndex: 'RetUserDesc', align: 'center'}
			,{header: '�˷ѿ���', width: 70, dataIndex: 'RetLocDesc', align: 'center'}
			,{header: '���', width: 70, dataIndex: 'Money', align: 'center'}
			,{header: '��Ʊ��', width: 70, dataIndex: 'InvNo', align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.FeeRecordListStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
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
		,title : '������ϸ'
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