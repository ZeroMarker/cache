var unitsDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listacctyear', method:'GET'}),
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'rowid',
			'compCode',
			'copyCode',
			'acctYear',
			'beginDate',
			'endDate',
			'periodNum',
			'accFlag',
			'budgFlag',
			'perfFlag',
			'costFlag',
			'cashDate'
		]),
    remoteSort: true
});

unitsDs.setDefaultSort('rowid', 'Desc');

var unitsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
    	header: '��λ����',
        dataIndex: 'compCode',
        width: 100,
        align: 'right',
        sortable: true
    },
	{
        header: "���ױ���",
        dataIndex: 'copyCode',
        width: 100,
        align: 'right',
        sortable: true
    },
    {
        header: "������",
        dataIndex: 'acctYear',
        width: 100,
        align: 'right',
        sortable: true
    },
    {
        header: "��ʼ����",
        dataIndex: 'beginDate',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
        header: "��������",
        dataIndex: 'endDate',
        width: 100,
        align: 'left',
        sortable: true
    },
    {
        header: "�ڼ���Ŀ",
        dataIndex: 'periodNum',
        width: 100,
        align: 'right',
        sortable: true
    },
	{
        header: "�������",
        dataIndex: 'accFlag',
        width: 60,
        align: 'left',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td'; 
			return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		},
        sortable: true
    },
    	 	{
        header: "Ԥ�����",
        dataIndex: 'budgFlag',
        width: 60,
        align: 'left',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td'; 
			return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		},
        sortable: true
    },
    {
        header: "��Ч����",
        dataIndex: 'perfFlag',
        width: 60,
        align: 'left',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td'; 
			return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		},
        sortable: true
    },
    {
        header: "�ɱ�����",
        dataIndex: 'costFlag',
        width: 60,
        align: 'left',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td'; 
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		},
        sortable: true
    },
    {
        header: "�ֽ����н�������",
        dataIndex: 'cashDate',
        width: 100,
        align: 'left',
        sortable: true
    }
]);

var addUnitsButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip:'����µ�λ��Ϣ',        
		iconCls:'add',
		handler: function(){
			addFun(unitsDs,unitsMain);
		}
	});

var editUnitsButton  = new Ext.Toolbar.Button({
		text:'�޸�',        
		tooltip:'�޸�ѡ���ĵ�λ��Ϣ',
		iconCls:'remove',        
		handler: function(){
			editFun(unitsDs,unitsMain);
		}
	});

var delUnitsButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ���ĵ�λ',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			delFun(unitsDs,unitsMain);
		}
	});

//var unitsPagingToolbar = new Ext.PagingToolbar({//��ҳ������
//		pageSize: 25,
//		store: unitsDs,
//		displayInfo: true,
//		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
//		emptyMsg: "û������"
//	});

var unitsMain = new Ext.grid.GridPanel({//���
		title: '101�����ȱ�',
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