var budgetDataUrl = 'dhc.ca.budgetdataexe.csp';
var budgetDataProxy = new Ext.data.HttpProxy({ url: budgetDataUrl + '?action=list' });
var intervalDr = "";
function formatDate(value) {
    //alert(value);
    return value ? value.dateFormat('Y-m-d') : '';
};

//接口部门套数据源
var budgetDataDs = new Ext.data.Store({
    proxy: budgetDataProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
            'rowid',
			'deptDr',
			'deptName',
			'itemDr',
			'itemName',
			'amount',
			'price',
			'fee',
			'remark',
			'type'
		]),
    // turn on remote sorting
    remoteSort: true
});

budgetDataDs.setDefaultSort('order', 'asc');

var budgetDataCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
	    header: '部门名称',
	    dataIndex: 'deptName',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '业务项名称',
	    dataIndex: 'itemName',
	    width: 100,
	    align: 'left',
	    sortable: true
	},

	{
	    header: '数量',
	    dataIndex: 'amount',
	    width: 70,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '单价',
	    dataIndex: 'price',
	    width: 100,
	    align: 'right',
	    renderer: formatNum,
	    sortable: true
	},
	{
	    header: '金额',
	    dataIndex: 'fee',
	    width: 100,
	    align: 'right',
	    renderer: formatNum,
	    sortable: true
	},
	{
	    header: '备注',
	    dataIndex: 'remark',
	    width: 150,
	    align: 'left',
	    sortable: true
	}
]);
var monthsDs = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'code', 'name', 'desc', 'start', 'end', 'dataFinish'])
});
var months = new Ext.form.ComboBox({
    id: 'months',
    fieldLabel: '核算区间',
    width: 100,
    listWidth: 260,
    allowBlank: false,
    store: monthsDs,
    //readOnly:true,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText: '选择核算区间...',
    pageSize: 10,
    minChars: 1,
    selectOnFocus: true,
    forceSelection: true
});
monthsDs.on('beforeload', function(ds, o) {
    ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.vouchdatasexe.csp?action=months&searchValue=' + Ext.getCmp('months').getRawValue(), method: 'GET' });
});
months.on("select", function(cmb, rec, id) {
    intervalDr = cmb.getValue();
    budgetDataDs.load({ params: { start: 0, limit: budgetDataPagingToolbar.pageSize, intervalDr: intervalDr} });
});
var addDataTypesButton = new Ext.Toolbar.Button({
    text: '添加',
    tooltip: '添加新的预算数据',
    iconCls: 'add',
    handler: function() { addFun(budgetDataDs, budgetDataMain, budgetDataPagingToolbar); }
});

var editDataTypesButton = new Ext.Toolbar.Button({
    text: '修改',
    tooltip: '修改选定的预算数据',
    iconCls: 'remove',
    handler: function() { editFun(budgetDataDs, budgetDataMain, budgetDataPagingToolbar); }
});

var delDataTypesButton = new Ext.Toolbar.Button({
    text: '删除',
    tooltip: '删除选定的预算数据',
    iconCls: 'remove',
    //disabled: true,
    handler: function() { delFun(budgetDataDs, budgetDataMain, budgetDataPagingToolbar); }
});

var totalButton = new Ext.Toolbar.Button({
    text: '统计汇总',
    tooltip: '统计汇总',
    iconCls: 'remove',
    handler: function() { CommFindFun(budgetDataDs, budgetDataMain, budgetDataPagingToolbar) }
});
var budgetDataSearchField = 'itemName';

var budgetDataFilterItem = new Ext.Toolbar.MenuButton({
    text: '过滤器',
    tooltip: '关键字所属类别',
    menu: { items: [
				new Ext.menu.CheckItem({ text: '数量', value: 'amount', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '单价', value: 'price', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '金额', value: 'fee', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '项目名称', value: 'itemName', checked: true, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '部门名称', value: 'deptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck })
		
		]
    }
});

function onDataTypesItemCheck(item, checked) {
    if (checked) {
        budgetDataSearchField = item.value;
        budgetDataFilterItem.setText(item.text + ':');
    }
};

var budgetDataSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
            budgetDataDs.proxy = new Ext.data.HttpProxy({ url: budgetDataUrl + '?action=list' });
            budgetDataDs.load({ params: { start: 0, limit: budgetDataPagingToolbar.pageSize, intervalDr: intervalDr} });
        }
    },
    onTrigger2Click: function() {
        if (this.getValue()) {
            budgetDataDs.proxy = new Ext.data.HttpProxy({
                url: budgetDataUrl + '?action=list&searchField=' + budgetDataSearchField + '&searchValue=' + this.getValue()
            });
            budgetDataDs.load({ params: { start: 0, limit: budgetDataPagingToolbar.pageSize, intervalDr: intervalDr} });
        }
    }
});

var budgetDataPagingToolbar = new Ext.PagingToolbar({//分页工具栏
    pageSize: 25,
    store: budgetDataDs,
    displayInfo: true,
    displayMsg: '当前显示{0} - {1}，共计{2}',
    emptyMsg: "没有数据",
    buttons: ['-', budgetDataFilterItem, '-', budgetDataSearchBox],
    doLoad: function(C) {
        var B = {},
		A = this.paramNames;
        B[A.start] = C;
        B[A.limit] = this.pageSize;
        B['intervalDr'] = intervalDr;
        if (this.fireEvent("beforechange", this, B) !== false) {
            this.store.load({ params: B });
        }
    }

});

var budgetDataMain = new Ext.grid.GridPanel({//表格
    title: '数据表',
    store: budgetDataDs,
    cm: budgetDataCm,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
    loadMask: true,
    tbar: ['核算周期:', months, '-', addDataTypesButton, '-', delDataTypesButton, '-', totalButton],
    bbar: budgetDataPagingToolbar
});

//budgetDataDs.load({params:{start:0, limit:budgetDataPagingToolbar.pageSize}});