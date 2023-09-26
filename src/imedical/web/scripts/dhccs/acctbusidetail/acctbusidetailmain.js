var unitsDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listacctbusidetail', method:'GET'}),
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
			'rowid',
			'acctSysBusiSectionDr',
			'acctSysBusiPhaseDr',
			'acctSysBusiTypeDr',
			'acctSysBusiTypeName',
			'acctYearDr',
			'acctYearName',
			'acctSubjDr',
			'acctSubjName',
			'summary',
			'caption',
			'direction',
			'isAutoCreate',
			'relayType',
			'isGroup',
			'moneyField',
			'whileSql',
			'isFund',
			'isPay'
		]),
    remoteSort: true
});

unitsDs.setDefaultSort('rowid', 'Desc');

var unitsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	//{
    //	header: 'Ƭ�α��',
    //    dataIndex: 'acctSysBusiSectionDr',
    //    width: 60,
    //    align: 'left',
    //    sortable: true
    //},
	//{
    //    header: '�׶α��',
    //    dataIndex: 'acctSysBusiPhaseDr',
    //    width: 60,
    //    align: 'left',
    //    sortable: true
    //},
		{
    	header: '�����',
        dataIndex: 'acctSysBusiTypeName',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '������',
        dataIndex: 'acctYearName',
        width: 60,
        align: 'right',
        sortable: true
    },
		{
    	header: '��Ŀ����',
        dataIndex: 'acctSubjName',
        width: 150,
        align: 'left',
        sortable: true
    },
	{
        header: 'ժҪ',
        dataIndex: 'summary',
        width: 100,
        align: 'left',
        sortable: true
    },
		{
    	header: '��Ŀ����',
        dataIndex: 'caption',
        width: 150,
        align: 'left',
        sortable: true
    },
	{
        header: '�������',
        dataIndex: 'direction',
        width: 60,
        align: 'left',
		renderer : function(v, p, record){
			//p.css += ' x-grid3-check-col-td'; 
			//return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			if(v=='0'){
				return '�跽';
			}else{
				return '����';
			}
		},
        sortable: true
    }//,
	//{
    //	header: '�Ƿ��Զ�',
    //    dataIndex: 'isAutoCreate',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //	header: '�Զ����',
    //    dataIndex: 'relayType',
    //    width: 60,
    //    align: 'left',
    //    sortable: true
    //},
	//{
    //    header: '�Ƿ����',
    //    dataIndex: 'isGroup',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //	header: '����ֶ�',
    //    dataIndex: 'moneyField',
    //    width: 60,
    //    align: 'left',
    //    sortable: true
    //},	
	//{
    //	header: '��Ŀɸѡ����',
    //    dataIndex: 'whileSql',
    //    width: 60,
    //    align: 'left',
    //    sortable: true
    //},		
	//{
    //	header: '�Ƿ����',
    //    dataIndex: 'isFund',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //    header: '�Ƿ񸶿�',
    //    dataIndex: 'isPay',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //}
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
		title: '302�Զ�����ƾ֤ģ��',
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