var inDistMethodsUrl = 'dhc.ca.indistmethodsexe.csp';
var inDistMethodsProxy = new Ext.data.HttpProxy({ url: inDistMethodsUrl + '?action=list' });

//数据项数据源
var inDistMethodsDs = new Ext.data.Store({
    proxy: inDistMethodsProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
            'rowid',
			'priority',
			'inFiltRuleDr',
			'inFiltRuleName',
			'inDistRuleDr',
			'inDistRuleName'
		]),
    // turn on remote sorting
    remoteSort: true
});

inDistMethodsDs.setDefaultSort('Rowid', 'DESC');

var inDistMethodsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
	    header: '优先顺序',
	    dataIndex: 'priority',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '过滤规则',
	    dataIndex: 'inFiltRuleName',
	    width: 200,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '分配规则',
	    dataIndex: 'inDistRuleName',
	    width: 200,
	    align: 'left',
	    sortable: true
	}
]);

var addDataTypesButton = new Ext.Toolbar.Button({
    text: '添加',
    tooltip: '添加新的收入分配方法',
    iconCls: 'add',
    handler: function() { addFun(inDistMethodsDs, inDistMethodsMain, inDistMethodsPagingToolbar); }
});

var editDataTypesButton = new Ext.Toolbar.Button({
    text: '修改',
    tooltip: '修改选定的收入分配方法',
    iconCls: 'remove',
    handler: function() { editFun(inDistMethodsDs, inDistMethodsMain, inDistMethodsPagingToolbar); }
});

var delDataTypesButton = new Ext.Toolbar.Button({
    text: '删除',
    tooltip: '删除选定的收入分配方法',
    iconCls: 'remove',
    //disabled: true,
    handler: function() { delFun(inDistMethodsDs, inDistMethodsMain, inDistMethodsPagingToolbar); }
});

var inDistMethodsSearchField = 'inFiltRuleName';

var inDistMethodsFilterItem = new Ext.Toolbar.MenuButton({
    text: '过滤器',
    tooltip: '关键字所属类别',
    menu: { items: [
				new Ext.menu.CheckItem({ text: '优先顺序', value: 'priority', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '过滤规则', value: 'inFiltRuleName', checked: true, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '分配规则', value: 'inDistRuleName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck })
		]
    }
});

function onDataTypesItemCheck(item, checked) {
    if (checked) {
        inDistMethodsSearchField = item.value;
        inDistMethodsFilterItem.setText(item.text + ':');
    }
};

var inDistMethodsSearchBox = new Ext.form.TwinTriggerField({//查找按钮
    width: 180,
    trigger1Class: 'x-form-clear-trigger',
    trigger2Class: 'x-form-search-trigger',
    emptyText: '搜索...',
    listeners: {
        specialkey: { fn: function(field, e) {
            var key = e.getKey();
            if (e.ENTER === key) { this.onTrigger2Click(); } 
        } 
        }
    },
    grid: this,
    onTrigger1Click: function() {
        if (this.getValue()) {
            this.setValue('');
            inDistMethodsDs.proxy = new Ext.data.HttpProxy({ url: inDistMethodsUrl + '?action=list' });
            inDistMethodsDs.load({ params: { start: 0, limit: inDistMethodsPagingToolbar.pageSize} });
        }
    },
    onTrigger2Click: function() {
        if (this.getValue()) {
            inDistMethodsDs.proxy = new Ext.data.HttpProxy({
                url: inDistMethodsUrl + '?action=list&searchField=' + inDistMethodsSearchField + '&searchValue=' + this.getValue()
            });
            inDistMethodsDs.load({ params: { start: 0, limit: inDistMethodsPagingToolbar.pageSize} });
        }
    }
});

var inDistMethodsPagingToolbar = new Ext.PagingToolbar({//分页工具栏
    pageSize: 25,
    store: inDistMethodsDs,
    displayInfo: true,
    displayMsg: '当前显示{0} - {1}，共计{2}',
    emptyMsg: "没有数据",
    buttons: ['-', inDistMethodsFilterItem, '-', inDistMethodsSearchBox]
});

var inDistMethodsMain = new Ext.grid.GridPanel({//表格
    title: '收入分配方法',
    store: inDistMethodsDs,
    cm: inDistMethodsCm,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
    loadMask: true,
    //tbar: [addDataTypesButton, '-', editDataTypesButton, '-', delDataTypesButton],
    bbar: inDistMethodsPagingToolbar
});

inDistMethodsDs.load({ params: { start: 0, limit: inDistMethodsPagingToolbar.pageSize} });