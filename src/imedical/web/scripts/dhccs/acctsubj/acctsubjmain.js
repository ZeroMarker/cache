var unitsDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listacctsubj', method:'GET'}),
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
			'rowid',
			'acctYearDr', 
			'acctYearName', 
			'acctSubjTypeDr', 
			'acctSubjTypeName', 
			'acctSubjCode', 
			'aCCTSubjName', 
			'aCCTSubjNameAll', 
			'superSubj', 
			'superSubjName',
			'subjLevel', 
			'isLast', 
			'direction', 
			'isCash', 
			'isNum', 
			'isFc', 
			'isCheck', 
			'checkType1', 
			'checkType2', 
			'checkType3', 
			'checkType4', 
			'checkType5', 
			'checkType6', 
			'checkType7', 
			'checkType8', 
			'define', 
			'spell', 
			'isStop', 
			'isCbcs', 
			'isZero', 
			'subjDefine', 
			'isBudge'
		]),
    remoteSort: true
});

unitsDs.setDefaultSort('rowid', 'Desc');

var unitsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
    	header: '������',
        dataIndex: 'acctYearName',
        width: 100,
        align: 'right',
        sortable: true
    },
	{
        header: '��Ŀ���',
        dataIndex: 'acctSubjTypeName',
        width: 100,
        align: 'left',
        sortable: true
    },
		{
    	header: '��Ŀ����',
        dataIndex: 'acctSubjCode',
        width: 100,
        align: 'right',
        sortable: true
    },
	{
        header: '��ƿ�Ŀ����',
        dataIndex: 'aCCTSubjName',
        width: 150,
        align: 'left',
        sortable: true
    },
		{
    	header: '��Ŀȫ��',
        dataIndex: 'aCCTSubjNameAll',
        width: 150,
        align: 'left',
        sortable: true
    },
	{
        header: '�ϼ�����',
        dataIndex: 'superSubjName',
        width: 100,
        align: 'left',
        sortable: true
    },
		{
    	header: '��Ŀ����',
        dataIndex: 'subjLevel',
        width: 100,
        align: 'right',
        sortable: true
    },
	//{
    //    header: 'ĩ��',
    //    dataIndex: 'isLast',
    //    width: 40,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//	{
    //	header: '����',
    //    dataIndex: 'direction',
    //    width: 40,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //    header: '�ֽ�',
    //    dataIndex: 'isCash',
    //    width: 40,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//	{
    //	header: '��������',
    //    dataIndex: 'isNum',
    //    width: 40,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //    header: '�������',
    //    dataIndex: 'isFc',
    //    width: 40,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//	{
    //	header: '����',
    //    dataIndex: 'isCheck',
    //    width: 40,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //    header: '�����',
    //    dataIndex: 'isZero',
    //    width: 40,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //    header: '����������1',
    //    dataIndex: 'checkType1',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
	//	{
    //	header: '����������2',
    //    dataIndex: 'checkType2',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
	//{
    //    header: '����������3',
    //    dataIndex: 'checkType3',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
	//	{
    //	header: '����������4',
    //    dataIndex: 'checkType4',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
	//{
    //    header: '����������5',
    //    dataIndex: 'checkType5',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
	//	{
    //    header: '����������6',
    //    dataIndex: 'checkType6',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
	//	{
    //	header: '����������7',
    //    dataIndex: 'checkType7',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
	//{
    //    header: '����������8',
    //    dataIndex: 'checkType8',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
	{
    	header: '�Զ�����',
        dataIndex: 'define',
        width: 100,
        align: 'right',
        sortable: true
    },
	{
        header: 'ƴ����',
        dataIndex: 'spell',
        width: 100,
        align: 'left',
        sortable: true
    }//,
	//{
    //	header: 'ͣ��',
    //    dataIndex: 'isStop',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //    header: '�ɱ����',
    //    dataIndex: 'isCbcs',
    //    width: 60,
    //    align: 'left',
	//	renderer : function(v, p, record){
	//		p.css += ' x-grid3-check-col-td'; 
	//		return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	//	},
    //    sortable: true
    //},
	//{
    //	header: '��Ŀ����',
    //    dataIndex: 'subjDefine',
    //    width: 100,
    //    align: 'left',
    //    sortable: true
    //},
	//{
    //	header: 'Ԥ�����',
    //    dataIndex: 'isBudge',
    //    width: 100,
    //    align: 'left',
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
		title: '101��ƿ�Ŀ�ֵ�',
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