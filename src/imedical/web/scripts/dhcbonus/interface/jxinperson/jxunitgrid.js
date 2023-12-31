var jxUnitUrl = 'dhc.pa.jxinpersonexe.csp';
var jxUnitProxy = new Ext.data.HttpProxy({url:jxUnitUrl + '?action=jxunitlist'});

//业务类别数据源
var jxUnitDs = new Ext.data.Store({
	proxy: jxUnitProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'rowid',
		'code',
		'name',
		'shortcut',
		'py'
	]),
	remoteSort: true
});

jxUnitDs.setDefaultSort('rowid', 'asc');

var jxUnitCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '代码',
		dataIndex: 'code',
		width: 80,
		sortable: true
	},{
		header: '名称',
		dataIndex: 'name',
		width: 120,
		sortable: true
	},{
		header: "拼音码",
		dataIndex: 'py',
		width: 80,
		align: 'left',
		sortable: true
	}/*,{
		header: "快捷键",
		dataIndex: 'shortcut',
		width: 150,
		align: 'left',
		sortable: true
	}*/
]);

var searchField = 'name';

var filterItem = new Ext.Toolbar.MenuButton({
	text: '搜索',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: false,group:'jxUnitFilter',checkHandler: onItemCheck }),
		new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: true,group:'jxUnitFilter',checkHandler: onItemCheck }),
		//new Ext.menu.CheckItem({ text: '快捷键',value: 'name',checked: false,group:'jxUnitFilter',checkHandler: onItemCheck }),
		new Ext.menu.CheckItem({ text: '拼音',value: 'py',checked: false,group:'jxUnitFilter',checkHandler: onItemCheck })
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
			jxUnitDs.proxy = new Ext.data.HttpProxy({url:jxUnitUrl+'?action=jxunitlist&sort=rowid&dir=asc'});
			jxUnitDs.load({params:{start:0, limit:pagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			jxUnitDs.proxy = new Ext.data.HttpProxy({
			url: jxUnitUrl+'?action=jxunitlist&searchField='+searchField+'&searchValue='+this.getValue()+'&sort=rowid&dir=asc'});
			jxUnitDs.load({params:{start:0, limit:pagingToolbar.pageSize}});
		}
	}
});

var pagingToolbar = new Ext.PagingToolbar({//分页工具栏
	pageSize:25,
	store: jxUnitDs,
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

var JXUnitGrid = new Ext.grid.GridPanel({//表格
	title: '绩效单位记录',
	region: 'west',
	width: 400,
	minSize: 350,
	maxSize: 450,
	split: true,
	collapsible: true,
	containerScroll: true,
	xtype: 'grid',
	store: jxUnitDs,
	cm: jxUnitCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar: ['->',filterItem,searchBox],
	bbar: pagingToolbar
});

jxUnitDs.load({params:{start:0, limit:pagingToolbar.pageSize}});

var jxUnitRowId = "";
var jxUnitName = "";

JXUnitGrid.on('rowclick',function(grid,rowIndex,e){
	//单击绩效单元后刷内部人员记录
	var selectedRow = jxUnitDs.data.items[rowIndex];

	jxUnitRowId = selectedRow.data["rowid"];
	jxUnitName = selectedRow.data["name"];
	personGrid.setTitle(jxUnitName+"-所对应人员记录");
	personDs.proxy = new Ext.data.HttpProxy({url:personUrl+'?action=personlist&jxUnitDr='+jxUnitRowId+'&sort=rowid&dir=asc'});
	personDs.load({params:{start:0, limit:personPagingToolbar.pageSize}});
});

jxUnitDs.on("beforeload",function(ds){
	personDs.removeAll();
	jxUnitRowId = "";
	personGrid.setTitle("人员信息");
});
	