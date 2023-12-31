var locSetUrl = '../csp/dhc.pa.outkpiruleexe.csp';
var locSetProxy = new Ext.data.HttpProxy({url:locSetUrl + '?action=locsetlist'});

//业务类别数据源
var locSetDs = new Ext.data.Store({
	proxy: locSetProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid',
		'order',
		'code',
		'name',
		'shortcut',
		'desc',
		'active'
	]),
	remoteSort: true
});

locSetDs.setDefaultSort('rowid', 'asc');

var locSetCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '序号',
		dataIndex: 'order',
		width: 60,
		sortable: true
	},{
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

var locSetPagingToolbar = new Ext.PagingToolbar({//分页工具栏
	pageSize:25,
	store: locSetDs,
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

var LocSetGrid = new Ext.grid.GridPanel({//表格
	title: '接口套记录',
	region: 'west',
	width: 400,
	minSize: 350,
	maxSize: 450,
	split: true,
	collapsible: true,
	containerScroll: true,
	xtype: 'grid',
	store: locSetDs,
	cm: locSetCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	bbar: locSetPagingToolbar
});

locSetDs.load({params:{start:0, limit:locSetPagingToolbar.pageSize}});

var locSetRowId = "";
var locSetName = "";

LocSetGrid.on('rowclick',function(grid,rowIndex,e){
	//单击接口套后刷指标记录
	var selectedRow = locSetDs.data.items[rowIndex];

	locSetRowId = selectedRow.data["rowid"];
	locSetName = selectedRow.data["desc"];
	outKpiGrid.setTitle(locSetName+"-所对应指标记录");
	outKpiDs.proxy = new Ext.data.HttpProxy({url:outKpiUrl+'?action=kpilist&locSetDr='+locSetRowId+'&sort=rowid&dir=asc'});
	outKpiDs.load({params:{start:0, limit:outKpiPagingToolbar.pageSize}});
});

locSetDs.on("beforeload",function(ds){
	outKpiDs.removeAll();
	locSetRowId = "";
	outKpiGrid.setTitle("指标信息");
});
	