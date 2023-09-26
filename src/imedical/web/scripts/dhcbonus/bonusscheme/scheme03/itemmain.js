//rowid^BonusSchemeID^BonusItemTypeID^SchemeItemCode^SchemeItemName^DataSource^BonusFormula^BonusFormulaDesc^BonusType^CalculatePriority^IsValid^UpdateDate
var schemeValue = new Array(
	{header:'',dataIndex:'rowid'},								//0
	{header:'方案ID',dataIndex:'BonusSchemeID'}, 				//1
	{header:'项目类别ID',dataIndex:'BonusItemTypeID'},          //2
	{header:'项目编码',dataIndex:'SchemeItemCode'},             //3
	{header:'项目名称',dataIndex:'SchemeItemName'},             //4
	{header:'数据来源',dataIndex:'DataSource'},       			//5
	{header:'公式',dataIndex:'BonusFormula'},       			//6
	{header:'公式描述',dataIndex:'BonusFormulaDesc'},        	//7
	{header:'项目属性',dataIndex:'BonusType'},         			//8
	{header:'核算优先级',dataIndex:'CalculatePriority'},     	//9
	{header:'是否有效',dataIndex:'IsValid'},       				//10
	{header:'更新时间',dataIndex:'UpdateDate'}		        	//11
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
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"//,
});

var itemMain = new Ext.grid.GridPanel({
	title:'奖金方案项',
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