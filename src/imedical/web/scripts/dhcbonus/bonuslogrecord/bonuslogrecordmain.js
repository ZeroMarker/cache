
var BonusLogRecordTabUrl = '../csp/dhc.bonus.bonuslogrecordexe.csp';
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

//配件数据源

var BonusLogRecordTabProxy= new Ext.data.HttpProxy({url:BonusLogRecordTabUrl + '?action=list'});
var BonusLogRecordTabDs = new Ext.data.Store({
	proxy: BonusLogRecordTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'userId',
		'userName',
		'name',
		'date'
	]),
    // turn on remote sorting
    remoteSort: true
});

//设置默认排序字段和排序方向
BonusLogRecordTabDs.setDefaultSort('rowid', 'name');

//数据库数据模型
var BonusLogRecordTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
    	header: '操作用户',
        dataIndex: 'userName',
        width: 100,		  
        sortable: true,
		align: 'center'
    },{
    	header: ' 用户操作名称',
        dataIndex: 'name',
        width: 200,
        sortable: true,
		align: 'center'
    },{
    	header: '操作时间',
        dataIndex: 'date',
        width: 200,
        sortable: true,
		align: 'center'
    }
]);

//初始化默认排序功能
BonusLogRecordTabCm.defaultSortable = true;


//初始化搜索字段
var BonusLogRecordSearchField ='name';

//搜索过滤器
var BonusLogRecordFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '操作用户',
			value: 'userName',
			checked: false ,
			group: 'BonusLogRecordFilter',
			checkHandler: onBonusLogRecordItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '操作时间',
			value: 'date',
			checked: true,
			group: 'BonusLogRecordFilter',
			checkHandler: onBonusLogRecordItemCheck 
		})
	]}
});

//定义搜索响应函数
function onBonusLogRecordItemCheck (item, checked){
	if(checked) {
		BonusLogRecordSearchField = item.value;
		BonusLogRecordFilterItem.setText(item.text + ':');
	}
};

//查找按钮
var BonusLogRecordSearchBox = new Ext.form.TwinTriggerField({
	width: 180,
	trigger1Class: 'x-form-clear-trigger',
	trigger2Class: 'x-form-search-trigger',
	emptyText:'搜索...',
	listeners: {
		specialkey: {
			fn:function(field, e) {
				var key = e.getKey();
	      	  		if(e.ENTER === key) {
					this.onTrigger2Click();
				}
			}
		}
	},
	grid: this,
	onTrigger1Click: function() {
		if(this.getValue()) {
			this.setValue('');    
			BonusLogRecordTabDs.proxy = new Ext.data.HttpProxy({url:  BonusLogRecordTabUrl + '?action=list'});
			BonusLogRecordTabDs.load({params:{start:0, limit:BonusLogRecordTabPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
				BonusLogRecordTabDs.proxy = new Ext.data.HttpProxy({
				url: BonusLogRecordTabUrl + '?action=list&searchField=' + BonusLogRecordSearchField + '&searchValue=' + this.getValue()});
	        	BonusLogRecordTabDs.load({params:{start:0, limit:BonusLogRecordTabPagingToolbar.pageSize}});
	    	}
	}
});

//分页工具栏
var BonusLogRecordTabPagingToolbar = new Ext.PagingToolbar({
    store: BonusLogRecordTabDs,
	pageSize:30,
    displayInfo: true,
    displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg: "没有记录"
	//buttons: ['-',BonusLogRecordFilterItem/*,'-',BonusLogRecordSearchBox*/]
});


//表格
var BonusLogRecordTab = new Ext.grid.EditorGridPanel({
	title: '系统操作日志记录',
	store: BonusLogRecordTabDs,
	cm: BonusLogRecordTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	bbar:BonusLogRecordTabPagingToolbar
});
BonusLogRecordTabDs.load({params:{start:0, limit:BonusLogRecordTabPagingToolbar.pageSize}});
