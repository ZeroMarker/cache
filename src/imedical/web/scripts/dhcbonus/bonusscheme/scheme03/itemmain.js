//rowid^BonusSchemeID^BonusItemTypeID^SchemeItemCode^SchemeItemName^DataSource^BonusFormula^BonusFormulaDesc^BonusType^CalculatePriority^IsValid^UpdateDate
var schemeValue = new Array(
	{header:'',dataIndex:'rowid'},								//0
	{header:'����ID',dataIndex:'BonusSchemeID'}, 				//1
	{header:'��Ŀ���ID',dataIndex:'BonusItemTypeID'},          //2
	{header:'��Ŀ����',dataIndex:'SchemeItemCode'},             //3
	{header:'��Ŀ����',dataIndex:'SchemeItemName'},             //4
	{header:'������Դ',dataIndex:'DataSource'},       			//5
	{header:'��ʽ',dataIndex:'BonusFormula'},       			//6
	{header:'��ʽ����',dataIndex:'BonusFormulaDesc'},        	//7
	{header:'��Ŀ����',dataIndex:'BonusType'},         			//8
	{header:'�������ȼ�',dataIndex:'CalculatePriority'},     	//9
	{header:'�Ƿ���Ч',dataIndex:'IsValid'},       				//10
	{header:'����ʱ��',dataIndex:'UpdateDate'}		        	//11
);

var itemUrl = 'dhc.bonus.scheme03exe.csp';
//var itemProxy = new Ext.data.HttpProxy({url: itemUrl + '?action=itemlist&scheme='+tmpSelectedScheme});

var itemDs = new Ext.data.Store({
	proxy: '',
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	},[
		schemeValue[0].dataIndex,
		schemeValue[1].dataIndex,
		schemeValue[2].dataIndex,
		schemeValue[3].dataIndex,
		schemeValue[4].dataIndex,
		schemeValue[5].dataIndex,
		schemeValue[6].dataIndex,
	    schemeValue[7].dataIndex,
		schemeValue[8].dataIndex,
		schemeValue[9].dataIndex,
		schemeValue[10].dataIndex,
		schemeValue[11].dataIndex
	]),
	remoteSort: true
});

itemDs.setDefaultSort('rowid', 'Desc');

var itemCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: schemeValue[3].header,
		dataIndex: schemeValue[3].dataIndex,
		width: 60,
		sortable: true
	},
	{
		header: schemeValue[4].header,
		dataIndex:schemeValue[4].dataIndex,
		width: 100,
		align: 'left',
		sortable: true
	},
	{
		header: schemeValue[8].header,
		dataIndex: schemeValue[8].dataIndex,
		width: 60,
		renderer:function(value,metadata,record,rowIndex,colIndex,store){
			return bonusTypeValue[value];
		},
		align: 'left',
		sortable: true
	},
	{
		header: schemeValue[5].header,
		dataIndex: schemeValue[5].dataIndex,
		width: 60,
		renderer:function(value,metadata,record,rowIndex,colIndex,store){
			return dataSourceValue[value];
		},
		align: 'left',
		sortable: true
	},
	{
		header: schemeValue[7].header,
		dataIndex: schemeValue[7].dataIndex,
		width: 100,
		align: 'left',
		sortable: true
	}
]);

var itemPagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: itemDs,
	displayInfo: true,
	displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg: "û������"//,
});

var itemMain = new Ext.grid.GridPanel({
	title:'���𷽰���',
	region:'center',
	store: itemDs,
	cm: itemCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	//tbar: [addButton,'-',editButton,'-',delButton],
	bbar: itemPagingToolbar
});


//itemDs.load({params:{start:0, limit:itemPagingToolbar.pageSize}});