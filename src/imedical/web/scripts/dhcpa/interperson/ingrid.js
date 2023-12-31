var inUrl = '../csp/dhc.pa.interpersonexe.csp';
var inProxy = new Ext.data.HttpProxy({url:inUrl + '?action=inlist'});

//业务类别数据源
var inDs = new Ext.data.Store({
	proxy: inProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'userDr',
		'userCode',
		'userName'
	]),
	remoteSort: true
});

inDs.setDefaultSort('userDr', 'asc');

var inCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '内部人员代码',
		dataIndex: 'userCode',
		width: 80,
		sortable: true
	},{
		header: '内部人员名称',
		dataIndex: 'userName',
		width: 120,
		sortable: true
	}
]);

var searchField = 'userName';

var filterItem = new Ext.Toolbar.MenuButton({
	text: '搜索',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ text: '代码',value: 'userCode',checked: false,group:'inFilter',checkHandler: onItemCheck}),
		new Ext.menu.CheckItem({ text: '名称',value: 'userName',checked: false,group:'inFilter',checkHandler: onItemCheck})
	]}
});
function onItemCheck(item, checked)
{
	if(checked) {
		searchField = item.value;
		filterItem.setText(item.text + ':');
	}
};

var searchBox = new Ext.form.TwinTriggerField({//查找按钮
	width:180,
	trigger1Class: 'x-form-clear-trigger',
	trigger2Class: 'x-form-search-trigger',
	//emptyText:'搜索...',
	listeners: {
		specialkey: {fn:function(field, e) {
			var key = e.getKey();
		if(e.ENTER === key) {this.onTrigger2Click();}}}
	},
	grid: this,
	onTrigger1Click: function() {
		if(this.getValue()) {
			this.setValue('');
			inDs.proxy = new Ext.data.HttpProxy({url:inUrl+'?action=inlist&sort=rowid&dir=asc'});
			inDs.load({params:{start:0, limit:pagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			inDs.proxy = new Ext.data.HttpProxy({
			url: inUrl+'?action=inlist&searchField='+searchField+'&searchValue='+this.getValue()+'&sort=rowid&dir=asc'});
			inDs.load({params:{start:0, limit:pagingToolbar.pageSize}});
		}
	}
});

var pagingToolbar = new Ext.PagingToolbar({//分页工具栏
	pageSize:25,
	store: inDs,
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

var InGrid = new Ext.grid.GridPanel({//表格
	title: '内部人员记录',
	region: 'west',
	width: 400,
	minSize: 350,
	maxSize: 450,
	split: true,
	collapsible: true,
	containerScroll: true,
	xtype: 'grid',
	store: inDs,
	cm: inCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar:['->',filterItem,searchBox],
	bbar:pagingToolbar
});

inDs.load({params:{start:0, limit:pagingToolbar.pageSize}});

var inRowId = "";
var inName = "";

InGrid.on('rowclick',function(grid,rowIndex,e){
	//单击内部人员后刷新接口人员记录
	var selectedRow = inDs.data.items[rowIndex];

	inRowId = selectedRow.data["userDr"];
	inName = selectedRow.data["userName"];
	OutGrid.setTitle(inName+"-所对应接口人员信息");
	outDs.proxy = new Ext.data.HttpProxy({url:outUrl+'?action=outlist&inDr='+inRowId+'&sort=userDr&dir=asc'});
	outDs.load({params:{start:0, limit:outPagingToolbar.pageSize}});
});

inDs.on("beforeload",function(ds){
	outDs.removeAll();
	inRowId = "";
	OutGrid.setTitle("接口人员信息");
});

	