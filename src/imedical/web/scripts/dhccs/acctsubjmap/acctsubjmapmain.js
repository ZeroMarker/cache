var unitsDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listacctsubjmap', method:'GET'}),
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
			'rowid',
			'acctModDr', 
			'acctModName', 
			'acctSubjDr', 
			'acctSubjName', 
			//'typeCode', 
			'locDr', 
			'locName', 
			'docType'
		]),
    remoteSort: true
});

unitsDs.setDefaultSort('rowid', 'Desc');

var unitsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
    	header: '��ϵͳ����',
        dataIndex: 'acctModName',
        width: 200,
        align: 'left',
        sortable: true
    },
	{
        header: '��Ŀ����',
        dataIndex: 'acctSubjName',
        width: 200,
        align: 'left',
        sortable: true
    },
		{
    	header: '������',
        dataIndex: 'docType',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '����',
        dataIndex: 'locName',
        width: 200,
        align: 'left',
        sortable: true
    }//,
	//
    //	header: '����',
    //   dataIndex: 'typeCode',
    //   width: 100,
    //   align: 'left',
    //   sortable: true
    //
]);

var addUnitsButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip:'����µ�λ��Ϣ',        
		iconCls:'add',
		handler: function(){
			addFun(unitsDs,unitsMain,unitsPagingToolbar);
		}
	});

var editUnitsButton  = new Ext.Toolbar.Button({
		text:'�޸�',        
		tooltip:'�޸�ѡ���ĵ�λ��Ϣ',
		iconCls:'remove',        
		handler: function(){
			editFun(unitsDs,unitsMain,unitsPagingToolbar);
		}
	});

var delUnitsButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ���ĵ�λ',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			delFun(unitsDs,unitsMain,unitsPagingToolbar);
		}
	});

var unitsPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: unitsDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"
	});

var unitsMain = new Ext.grid.GridPanel({//���
		title: '301����Ŀ��Ӧ����',
		store: unitsDs,
		cm: unitsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: [addUnitsButton,'-',editUnitsButton,'-',delUnitsButton]//,
		//bbar: unitsPagingToolbar
	});

unitsDs.load();