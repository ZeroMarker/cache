function InitViewport()
{
	var obj = new Object();
	obj.QueryDetailInput="";
	
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","ҽԺ",SSHospCode);
	obj.cboMrType 	= Common_ComboToMrType("cboMrType","��������",MrClass,"cboHospital");
	obj.dfDateFrom 	= Common_DateFieldToDate("dfDateFrom","��ѯ����");
	obj.dfDateTo	= Common_DateFieldToDate("dfDateTo","��");
	
	obj.btnQry = new Ext.Button({
		id : 'btnQry'
		,iconCls : 'icon-find'
		,width : 60
		,anchor : '100%'
		,text : '��ѯ'
	});
	
	obj.btnExportCollect = new Ext.Button({
		id : 'btnExportCollect'
		,iconCls : 'icon-export'
		,width : 60
		,anchor : '100%'
		,text : '��������'
	});
	
	obj.btnExportDetail = new Ext.Button({
		id : 'btnExportDetail'
		,iconCls : 'icon-export'
		,width : 60
		,anchor : '100%'
		,text : '������ϸ'
	});

	obj.CollectResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.CollectResultStore = new Ext.data.Store({
		proxy: obj.CollectResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},[
			{name: 'ID', mapping : 'ID'}
			,{name: 'LendLoc', mapping : 'LendLoc'}
			,{name: 'LendUser', mapping : 'LendUser'}
			,{name: 'LendLocDesc', mapping : 'LendLocDesc'}
			,{name: 'LendUserDesc', mapping : 'LendUserDesc'}
			,{name: 'LendSum', mapping : 'LendSum'}
		])
	});

	obj.CollectResult = new Ext.grid.GridPanel({
		id : 'CollectResult'
		,store : obj.CollectResultStore
		,columnLines : true
		,region : 'west'
		,width: 350
		,loadMask : true
		,tbar : [
			{id:'msgCollectResult',text:'���һ���',style:'font-weight:bold;font-size:14px;',xtype:'label'}
		]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '���Ŀ���', width: 120, dataIndex: 'LendLocDesc', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '����ҽ��', width: 70, dataIndex: 'LendUserDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����', width: 40, dataIndex: 'LendSum', sortable: false, menuDisabled:true, align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.CollectResultStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
		,viewConfig : {
			forceFit : true
		}
    });
    
	obj.DetailResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.DetailResultStore = new Ext.data.Store({
		proxy: obj.DetailResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},[
			{name: 'ID', mapping : 'ID'}
			,{name: 'PapmiNo', mapping : 'PapmiNo'}
			,{name: 'MrNo', mapping : 'MrNo'}
			,{name: 'PatName', mapping : 'PatName'}
			,{name: 'Sex', mapping : 'Sex'}
			,{name: 'Age', mapping : 'Age'}
			,{name: 'LendLoc', mapping : 'LendLoc'}
			,{name: 'LendUser', mapping : 'LendUser'}
			,{name: 'LendDate', mapping : 'LendDate'}
			,{name: 'UpdateUser', mapping : 'UpdateUser'}
			,{name: 'BackUser', mapping : 'BackUser'}
		])
	});

	obj.DetailResult = new Ext.grid.GridPanel({
		id : 'DetailResult'
		,store : obj.DetailResultStore
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,tbar : [
			{id:'msgDetailResult',text:'������ϸ',style:'font-weight:bold;font-size:14px;',xtype:'label'}
		]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '�ǼǺ�', width: 70, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '������', width: 70, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '����', width: 70, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�Ա�', width: 40, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����', width: 40, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '���Ŀ���', width: 120, dataIndex: 'LendLoc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����ҽ��', width: 70, dataIndex: 'LendUser', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '��������', width: 70, dataIndex: 'LendDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����Ա', width: 70, dataIndex: 'UpdateUser', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�黹��', width: 70, dataIndex: 'BackUser', sortable: false, menuDisabled:true, align: 'center'}
			
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.DetailResultStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		}),viewConfig : {
			forceFit : true
		}
    });
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			{
				region:'north'
				,layout:'column'
				,height: 40
				,frame: true
				,items:[
					{
						width:200
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items:[obj.cboHospital]
					},{
						width:170
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items:[obj.cboMrType]
					},{
						width:170
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items:[obj.dfDateFrom]
					},{
						width:130
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 20
						,items:[obj.dfDateTo]
					},{
						width:5
						,layout:'form'
						,height:1
					},{
						width:90
						,layout : 'form'
						,items:[obj.btnQry]
					},{
						width:5
						,layout:'form'
						,height:1
					},{
						width:90
						,layout : 'form'
						,items:[obj.btnExportCollect]
					},{
						width:5
						,layout:'form'
						,height:1
					},{
						width:90
						,layout : 'form'
						,items:[obj.btnExportDetail]
					}
				]
			}
			,obj.CollectResult
			,obj.DetailResult
		]
	});

	obj.CollectResultStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.LendQry';
		param.QueryName = 'QryNotBackCollect';
		param.Arg1 = Common_GetValue("cboHospital");
		param.Arg2 = Common_GetValue("cboMrType");
		param.Arg3 = Common_GetValue("dfDateFrom");
		param.Arg4 = Common_GetValue("dfDateTo");
		param.ArgCnt = 4;
	});

	obj.DetailResultStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.LendQry';
		param.QueryName = 'QryNotBackDetail';
		param.Arg1 = obj.QueryDetailInput;
		param.ArgCnt = 1;
	});
	
	InitEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}