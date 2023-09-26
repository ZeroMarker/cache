//rowid^BonusSchemeID^BonusSchemeCode^BonusSchemeName^BonusUnitID^BonusUnitCode^BonusUnitName^BonusUnitTypeID^BonusUnitTypeName
var schemeUnitValue = new Array(
	{header:'',dataIndex:'rowid'},						//0
	{header:'',dataIndex:'BonusSchemeID'}, 				//1
	{header:'',dataIndex:'BonusSchemeCode'},    		//2
	{header:'',dataIndex:'BonusSchemeName'},    		//3
	{header:'',dataIndex:'BonusUnitID'},        		//4
	{header:'单元编码',dataIndex:'BonusUnitCode'},      //5
	{header:'单元名称',dataIndex:'BonusUnitName'},    	//6
	{header:'',dataIndex:'BonusUnitTypeID'},        	//7
	{header:'单元类别',dataIndex:'BonusUnitTypeName'}   //8
);

var schemeUnitUrl = 'dhc.bonus.scheme03exe.csp';
//var schemeUnitProxy = '';//new Ext.data.HttpProxy({url: schemeUnitUrl + '?action=schemeunitlist&scheme=1'});

var schemeUnitDs = new Ext.data.Store({
	proxy: '',
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	},[
		schemeUnitValue[0].dataIndex,
		schemeUnitValue[1].dataIndex,
		schemeUnitValue[2].dataIndex,
		schemeUnitValue[3].dataIndex,
		schemeUnitValue[4].dataIndex,
		schemeUnitValue[5].dataIndex,
		schemeUnitValue[6].dataIndex,
	    schemeUnitValue[7].dataIndex,
		schemeUnitValue[8].dataIndex
	]),
	remoteSort: true
});

schemeUnitDs.setDefaultSort('rowid', 'Desc');

var schemeUnitCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: schemeUnitValue[5].header,
		dataIndex: schemeUnitValue[5].dataIndex,
		width: 100,
		sortable: true
	},
	{
		header: schemeUnitValue[6].header,
		dataIndex:schemeUnitValue[6].dataIndex,
		width: 200,
		align: 'left',
		sortable: true
	},
	{
		header: schemeUnitValue[8].header,
		dataIndex: schemeUnitValue[8].dataIndex,
		width: 100,
		align: 'left',
		sortable: true
	}
]);

var schemeUnitPagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: schemeUnitDs,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"//,
});

var codeField = new Ext.form.TextField({
	id: 'codeField',
	name:'code',
	fieldLabel: '方案代码',
	allowBlank: false,
	emptyText: '必填',
	anchor: '100%'
});

var nameField = new Ext.form.TextField({
	id: 'nameField',
	name:'name',
	fieldLabel: '方案名称',
	allowBlank: false,
	emptyText: '必填',
	anchor: '100%'
});

var descField = new Ext.form.TextField({
	id: 'descField',
	name:'desc',
	fieldLabel: '方案描述',
	emptyText: '',
	anchor: '100%'
});

var schemeUnitMain = new Ext.grid.GridPanel({
	title:'方案核算单元',
	region:'west',
	width:450,
	store: schemeUnitDs,
	cm: schemeUnitCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	bbar: schemeUnitPagingToolbar
});

//schemeUnitDs.load({params:{start:0, limit:schemeUnitPagingToolbar.pageSize}});