var unitsDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listdhcacccre', method:'GET'}),
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'rowid',
			'creCode',
			'creDesc',
			'creDataSource',
            'crePatType',
			'creDate',
			'creTime',
			'creActiveFlag',
            'creStartDate',
			'creEndDate',
			'crePrePrtFlag',
			'creIncluAbort',
            'creModeCode',
			'creBusiType',
			'creNote1',
			'creNote2',
			'creNote3'
		]),
    remoteSort: true
});

unitsDs.setDefaultSort('rowid', 'Desc');

var unitsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
    	header: 'ƾ֤����',
        dataIndex: 'creCode',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "ƾ֤����",
        dataIndex: 'creDesc',
        width: 80,
        align: 'left',
        sortable: true
    },
		{
    	header: 'ҵ������',
        dataIndex: 'creDataSource',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "���ݷ���",
        dataIndex: 'crePatType',
        width: 80,
        align: 'left',
        sortable: true
    },
		{
    	header: '����',
        dataIndex: 'creDate',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "ʱ��",
        dataIndex: 'creTime',
        width: 80,
        align: 'left',
        sortable: true
    },
		{
    	header: '��Ч��־',
        dataIndex: 'creActiveFlag',
        width: 80,
        align: 'left',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td'; 
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		},
        sortable: true
    },
	{
        header: "��ʼʹ������",
        dataIndex: 'creStartDate',
        width: 80,
        align: 'left',
        sortable: true
    },
		{
    	header: '����ʹ������',
        dataIndex: 'creEndDate',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "�ش�Ʊ�ݴ���",
        dataIndex: 'crePrePrtFlag',
        width: 80,
        align: 'left',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td'; 
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		},
        sortable: true
    },
	{
    	header: '�Ƿ��������',
        dataIndex: 'creIncluAbort',
        width: 80,
        align: 'left',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td'; 
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		},
        sortable: true
    }
	/*	,
	{
        header: "creModeCode",
        dataIndex: 'creModeCode',
        width: 80,
        align: 'left',
        sortable: true
    },
		{
    	header: 'creBusiType',
        dataIndex: 'creBusiType',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "creNote1",
        dataIndex: 'creNote1',
        width: 80,
        align: 'left',
        sortable: true
    },
		{
    	header: 'creNote2',
        dataIndex: 'creNote2',
        width: 80,
        align: 'left',
        sortable: true
    },
	{
        header: "creNote3",
        dataIndex: 'creNote3',
        width: 80,
        align: 'left',
        sortable: true
    }
	//{
    //    header: "�Զ�����ƾ֤",
    //    dataIndex: 'isAutoVouch',
    //    width: 80,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //}
	*/
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
		title: 'ƾ֤ģ������',
		store: unitsDs,
		cm: unitsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: [addUnitsButton,'-',editUnitsButton,'-',delUnitsButton],
		bbar: unitsPagingToolbar
	});

unitsDs.load();