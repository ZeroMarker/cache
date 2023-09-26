function InitViewport(){
	var obj = new Object();
	
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","ҽԺ",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","��������",MrClass,"cboHospital");
	obj.dfDateFrom 	= Common_DateFieldToDate("dfDateFrom","�շ�����");
	obj.dfDateTo	= Common_DateFieldToDate("dfDateTo","��");
	
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
		,fieldLabel : '�շ�����'
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
		,text : '����'
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
			{id:'msgFeeRecordList',text:'�����շ���ϸ��ѯ',style:'font-weight:bold;font-size:14px;',xtype:'label'}
			,'->','-',obj.btnQuery]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '��������', width: 60, dataIndex: 'PatName', align: 'center'}
			,{header: '������', width: 70, dataIndex: 'MrNo', align: 'center'}
			,{header: '�շ���', width: 60, dataIndex: 'FeeItemDesc', align: 'center'}
			,{header: '�շ�����', width: 70, dataIndex: 'FeeDate', align: 'center'}
			,{header: '�շ�ʱ��', width: 70, dataIndex: 'FeeTime', align: 'center'}	
			,{header: '�շ�Ա', width: 60, dataIndex: 'FeeUserDesc', align: 'center'}
			,{header: '�շѿ���', width: 70, dataIndex: 'FeeLocDesc', align: 'center'}
			,{header: '���', width: 70, dataIndex: 'Money', align: 'center'}
			,{header: '�շ�״̬', width: 60, dataIndex: 'StatusDesc', align: 'center'}
			,{header: '��Ʊ��', width: 70, dataIndex: 'InvNo', align: 'center'}
			,{header: '�˷�����', width: 70, dataIndex: 'RetDate', align: 'center'}
			,{header: '�˷�ʱ��', width: 60, dataIndex: 'RetTime', align: 'center'}
			,{header: '�˷���Ա', width: 70, dataIndex: 'RetUserDesc', align: 'center'}
			,{header: '�˷ѿ���', width: 70, dataIndex: 'RetLocDesc', align: 'center'}
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