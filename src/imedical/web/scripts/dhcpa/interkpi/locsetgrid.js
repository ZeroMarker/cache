var KPIUrl = '../csp/dhc.pa.interkpiexe.csp';
var KPIProxy = new Ext.data.HttpProxy({url:KPIUrl + '?action=kpilist'});

//业务类别数据源
var KPIDs = new Ext.data.Store({
	proxy: KPIProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid','name','code','desc'
	]),
	remoteSort: true
});

KPIDs.setDefaultSort('rowid', 'asc');

var KPICm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '代码',
		dataIndex: 'code',
		width: 80,
		sortable: true
	},{
		header: "名称",
		dataIndex: 'name',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header: "描述",
		dataIndex: 'desc',
		width: 150,
		align: 'left',
		sortable: true
	}
]);

var KPIPagingToolbar = new Ext.PagingToolbar({//分页工具栏
	pageSize:25,
	store: KPIDs,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据",
	doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['dir']="asc";
		B['sort']="rowid";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

var KPIGrid = new Ext.grid.GridPanel({//表格
	title: 'KPI指标记录',
	region: 'west',
	width: 400,
	minSize: 350,
	maxSize: 450,
	split: true,
	collapsible: true,
	containerScroll: true,
	xtype: 'grid',
	store: KPIDs,
	cm: KPICm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	bbar: KPIPagingToolbar
});

KPIDs.load({params:{start:0, limit:KPIPagingToolbar.pageSize}});

var KPIRowId = "";
var KPIName = "";

KPIGrid.on('rowclick',function(grid,rowIndex,e){
	//单击接口套后刷指标记录
	var selectedRow = KPIDs.data.items[rowIndex];

	KPIRowId = selectedRow.data["rowid"];
	KPIName = selectedRow.data["name"];
	outKpiGrid.setTitle(KPIName+"-所对应指标记录");
	outKpiDs.proxy = new Ext.data.HttpProxy({url:KPIUrl+'?action=kpilist&interkpi='+KPIRowId+'&sort=rowid&dir=asc'});
	outKpiDs.load({params:{start:0, limit:outKpiPagingToolbar.pageSize}});
});

KPIDs.on("beforeload",function(ds){
	outKpiDs.removeAll();
	KPIRowId = "";
	outKpiGrid.setTitle("指标信息");
});
	