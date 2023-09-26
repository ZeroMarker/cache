function InitViewport()
{
	var obj = new Object();
	
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","ҽԺ",SSHospCode);
	obj.cboMrType 	= Common_ComboToMrType("cboMrType","��������",MrClass,"cboHospital");
	obj.dfDateFrom 	= Common_DateFieldToDate("dfDateFrom","��ѯ����");
	obj.dfDateTo	= Common_DateFieldToDate("dfDateTo","��");
	obj.cboLendLoc 	= Common_ComboToLendLoc("cboLendLoc","����","E","","cboHospital");
	obj.isBack = Common_Checkbox("isBack","�Ƿ�黹");
	
	obj.btnQry = new Ext.Button({
		id : 'btnQry'
		,iconCls : 'icon-find'
		,width : 60
		,anchor : '100%'
		,text : '��ѯ'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 60
		,anchor : '100%'
		,text : '����'
	});
	
	obj.btnPrint = new Ext.Button({
		id : 'btnPrint'
		,iconCls : 'icon-print'
		,width : 60
		,anchor : '100%'
		,text : '��ӡ'
	});
	
	obj.gridLocLendStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridLocLendStore = new Ext.data.Store({
		proxy: obj.gridLocLendStoreProxy,
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

	obj.gridLocLend = new Ext.grid.GridPanel({
		id : 'gridLocLend'
		,store : obj.gridLocLendStore
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,tbar : [{id:'msggridLocLend',text:'��ѯ���',style:'font-weight:bold;font-size:14px;',xtype:'label'},'->','-',obj.btnQry,'-',obj.btnExport,'-',obj.btnPrint,'-']
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
			store : obj.gridLocLendStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
		,viewConfig : {
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
						columnWidth:.16
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items:[obj.cboHospital]
					},{
						columnWidth:.17
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items:[obj.cboMrType]
					},{
						columnWidth:.17
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items:[obj.dfDateFrom]
					},{
						columnWidth:.12
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 20
						,items:[obj.dfDateTo]
					},{
						columnWidth:.17
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items:[obj.cboLendLoc]
					},{
						columnWidth:.08
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items:[obj.isBack]
					}
				]
			},obj.gridLocLend
		]
	});
	
	obj.gridLocLendStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.LendQry';
		param.QueryName = 'QryLocLend';
		param.Arg1 = Common_GetValue("cboHospital")
		param.Arg2 = Common_GetValue("cboMrType")
		param.Arg3 = Common_GetValue("dfDateFrom")
		param.Arg4 = Common_GetValue("dfDateTo")
		param.Arg5 = Common_GetValue("cboLendLoc")
		param.Arg6 = (Common_GetValue("isBack")?1:0)
		param.ArgCnt = 6;
	});
	
	InitEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}