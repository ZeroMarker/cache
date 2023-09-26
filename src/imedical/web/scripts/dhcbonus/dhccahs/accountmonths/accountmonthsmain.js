var AccountMonthsUrl = 'dhc.ca.accountmonthsexe.csp';
var AccountMonthsProxy = new Ext.data.HttpProxy({url: AccountMonthsUrl + '?action=list'});

function formatDate(value){
	//alert(value);
	return value?value.dateFormat('Y-m-d'):'';
};

var AccountMonthsDs = new Ext.data.Store({
	proxy: AccountMonthsProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid',
			'code',
			'name',
			'desc',
			{name:'start',type:'date',dateFormat:'Y-m-d'},
			{name:'end',type:'date',dateFormat:'Y-m-d'},
			'dataFinish',
			'treatFinish',
			'tieOff',
			'remark',
			////wyy
			{name:'acc',defaultValue:'<font color=blue>编辑区间</font>'},
			{name:'accadd',defaultValue:'<font color=blue>选择月份</font>'}
			////
		]),
    // turn on remote sorting
    remoteSort: true
});

AccountMonthsDs.setDefaultSort('rowid', 'DESC');

var AccountMonthsCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '代码',
			dataIndex: 'code',
			width: 60,
			align: 'left',
			sortable: true
		},
		{
			header: '名称',
			dataIndex: 'name',
			width: 200,
			align: 'left',
			sortable: true
		},
		{
			header: "开始日期",
			dataIndex: 'start',
			renderer:formatDate,
			align: 'left',
			width: 90,
			sortable: true
		},
		{
			header: "截止日期",
			dataIndex: 'end',
			renderer:formatDate,
			align: 'left',
			width: 90,
			sortable: true
		},
		{
			header: '收入标志',
			dataIndex: 'dataFinish',
			width: 60,
			sortable: true,
			renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td'; 
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
		},
		{
			header: '成本标志',
			dataIndex: 'treatFinish',
			width: 60,
			sortable: true,
			renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td'; 
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
		},
		{
			header: "参数标志",
			dataIndex: 'tieOff',
			width: 60,
			sortable: true,
			renderer : function(v, p, record){
				p.css += ' x-grid3-check-col-td'; 
				return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
		},
		{
			header: '备注',
			dataIndex: 'remark',
			width: 60,
			align: 'left',
			sortable: true
		},
		////wyy
		{
			header: '区间对照',
			dataIndex: 'acc',
			width: 60,
			align: 'left'
		}/*zjw 20160808,
		{
			header: '区间导入',
			hidden:true,
			dataIndex: 'accadd',
			width: 60,
			align: 'left'
		}*/
		////
	]);

var addAccountMonthsButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加新的核算月',        
		iconCls: 'add',
		handler: function(){addFun(AccountMonthsDs,AccountMonthsMain,AccountMonthsPagingToolbar);}
});

var editAccountMonthsButton  = new Ext.Toolbar.Button({
		text: '修改',        
		tooltip: '修改选定的核算月',
		iconCls: 'remove',
		handler: function(){editFun(AccountMonthsDs,AccountMonthsMain,AccountMonthsPagingToolbar);}
});

var delAccountMonthsButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除选定的核算月',
		iconCls: 'remove',
		disabled: true,
		handler: function(){delFun(AccountMonthsDs,AccountMonthsMain,AccountMonthsPagingToolbar);}
});

var AccountMonthsSearchField = 'Name';

var AccountMonthsFilterItem = new Ext.Toolbar.MenuButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: false,group: 'AccountMonthsFilter',checkHandler: onAccountMonthsItemCheck }),
				new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: true,group: 'AccountMonthsFilter',checkHandler: onAccountMonthsItemCheck }),
				//new Ext.menu.CheckItem({ text: '开始日期',value: 'start',checked: false,group: 'AccountMonthsFilter',checkHandler: onAccountMonthsItemCheck }),
				//new Ext.menu.CheckItem({ text: '结束日期',value: 'end',checked: false,group: 'AccountMonthsFilter',checkHandler: onAccountMonthsItemCheck }),
				new Ext.menu.CheckItem({ text: '备注',value: 'remark',checked: false,group: 'AccountMonthsFilter',checkHandler: onAccountMonthsItemCheck })
		]}
});

function onAccountMonthsItemCheck(item, checked)
{
		if(checked) {
				AccountMonthsSearchField = item.value;
				AccountMonthsFilterItem.setText(item.text + ':');
		}
};

var AccountMonthsSearchBox = new Ext.form.TwinTriggerField({//查找按钮
		width: 180,
		trigger1Class: 'x-form-clear-trigger',
		trigger2Class: 'x-form-search-trigger',
		emptyText:'搜索...',
		listeners: {
			specialkey: {fn:function(field, e) {
			var key = e.getKey();
			if(e.ENTER === key) {this.onTrigger2Click();}}}
		},
		grid: this,
		onTrigger1Click: function() {
			if(this.getValue()) {
				this.setValue('');    
				AccountMonthsDs.proxy = new Ext.data.HttpProxy({url: AccountMonthsUrl + '?action=list'});
				AccountMonthsDs.load({params:{start:0, limit:AccountMonthsPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				AccountMonthsDs.proxy = new Ext.data.HttpProxy({
				url: AccountMonthsUrl + '?action=list&searchField=' + AccountMonthsSearchField + '&searchValue=' + this.getValue()});
				AccountMonthsDs.load({params:{start:0, limit:AccountMonthsPagingToolbar.pageSize}});
	    	}
		}
});

var AccountMonthsPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: AccountMonthsDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',AccountMonthsFilterItem,'-',AccountMonthsSearchBox]
});

var AccountMonthsMain = new Ext.grid.GridPanel({//表格
		title: '核算月维护',
		store: AccountMonthsDs,
		cm: AccountMonthsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: [addAccountMonthsButton,'-',editAccountMonthsButton,'-'],
		bbar: AccountMonthsPagingToolbar
});

////wyy
AccountMonthsMain.on('cellclick',function(grid,rowIndex,columnIndex,e){
	if(columnIndex==9){
		accPeriodsEditor(grid);
	}else if(columnIndex==10){
		copyOtherMon(grid);
	}
});
////

AccountMonthsDs.load({params:{start:0, limit:AccountMonthsPagingToolbar.pageSize}});