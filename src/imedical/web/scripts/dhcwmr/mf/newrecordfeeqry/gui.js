function InitViewport()
{
	var obj = new Object();
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","ҽԺ",SSHospCode);
	obj.cboMrType 	= Common_ComboToMrType("cboMrType","��������",MrClass,"cboHospital");
	obj.dfDateFrom 	= Common_DateFieldToDate("dfDateFrom","��ѯ����");
	obj.dfDateTo	= Common_DateFieldToDate("dfDateTo","��");
	obj.cboLendLoc 	= Common_ComboToLendLoc("cboLendLoc","����","E","","cboHospital");
	
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
    
	obj.GridNewRecordStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.GridNewRecordStore = new Ext.data.Store({
		proxy: obj.GridNewRecordStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'MainID'
		},[
			{name: 'MainID', mapping : 'MainID'}
			,{name: 'PapmiNo', mapping : 'PapmiNo'}
			,{name: 'MrNo', mapping : 'MrNo'}
			,{name: 'PatName', mapping : 'PatName'}
			,{name: 'BuildUser', mapping : 'BuildUser'}
			,{name: 'Price', mapping : 'Price'}
			,{name: 'BillNum', mapping : 'BillNum'}
			,{name: 'DateTime', mapping : 'DateTime'}
		])
	});

	obj.GridNewRecord = new Ext.grid.GridPanel({
		id : 'GridNewRecord'
		,store : obj.GridNewRecordStore
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,tbar : [
			{id:'msgNewRecordFeeList',text:'�������Ѳ�ѯ',style:'font-weight:bold;font-size:14px;',xtype:'label'}
			,'->','-',obj.btnQry,'-',obj.btnExport,'-',obj.btnPrint]
		
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '����Ա����', width: 70, dataIndex: 'BuildUser', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '������', width: 70, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '��������', width: 70, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�ǼǺ�', width: 90, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '���õ���', width: 90, dataIndex: 'Price', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '��������', width: 90, dataIndex: 'BillNum', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����ʱ��', width: 90, dataIndex: 'DateTime', sortable: false, menuDisabled:true, align: 'center'}
			
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.GridNewRecordStore,
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
						columnWidth:.2
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items:[obj.cboHospital]
					},{
						columnWidth:.15
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items:[obj.cboMrType]
					},{
						columnWidth:.17
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items:[obj.dfDateFrom]
					},{
						columnWidth:.13
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 30
						,items:[obj.dfDateTo]
					},{
						columnWidth:.2
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items:[obj.cboLendLoc]
					}
				]
			},obj.GridNewRecord
		]
	});
	
	obj.GridNewRecordStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.NewRecordQry';
		param.QueryName = 'QryNewRecord';
		param.Arg1 = Common_GetValue("cboHospital");
		param.Arg2 = Common_GetValue("cboMrType");
		param.Arg3 = Common_GetValue("dfDateFrom");
		param.Arg4 = Common_GetValue("dfDateTo");
		param.Arg5 = Common_GetValue("cboLendLoc");
		param.ArgCnt = 5;
	});
	
	InitEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}