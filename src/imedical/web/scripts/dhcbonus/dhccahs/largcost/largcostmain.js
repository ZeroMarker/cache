var largCostUrl = 'dhc.ca.largcostexe.csp';
var largCostProxy = new Ext.data.HttpProxy({ url: largCostUrl + '?action=list' });
var largCostDr = "";
var itemName = "";
var deptName = "";

var largCostDs = new Ext.data.Store({
    proxy: largCostProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
            'rowid',
			{ name: 'vouchDate', type: 'date', dateFormat: 'Y-m-d' },
			'vouchNum',
			'abstract',
			'deptDr',
			'deptName',
			'itemDr',
			'itemName',
			'fee',
			'calFlag',
			'cycles',
			'inPersonDr',
			'inPersonName',
			{ name: 'inDate', type: 'date', dateFormat: 'Y-m-d' }
		]),
    // turn on remote sorting
    remoteSort: true
});

largCostDs.setDefaultSort('Rowid', 'DESC');

var largCostCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
	    header: "凭证日期",
	    dataIndex: 'vouchDate',
	    width: 75,
	    renderer: formatDate,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '凭证号',
	    dataIndex: 'vouchNum',
	    width: 60,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '摘要',
	    dataIndex: 'abstract',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '部门',
	    dataIndex: 'deptName',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '业务项',
	    dataIndex: 'itemName',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '金额',
	    dataIndex: 'fee',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '分期数',
	    dataIndex: 'cycles',
	    width: 45,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '录入人',
	    dataIndex: 'inPersonName',
	    width: 60,
	    align: 'left',
	    sortable: true
	},
	{
	    header: "录入日期",
	    dataIndex: 'inDate',
	    width: 75,
	    renderer: formatDate,
	    align: 'left',
	    sortable: true
	},
		{
		    header: "计算标志",
		    dataIndex: 'calFlag',
		    width: 40,
		    align: 'left',
		    sortable: true,
		    renderer: function(v, p, record) {
		        p.css += ' x-grid3-check-col-td';
		        return '<div class="x-grid3-check-col' + (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
		    }
		}
]);

var addDataTypesButton = new Ext.Toolbar.Button({
    text: '添加',
    tooltip: '添加新的大额成本',
    iconCls: 'add',
    handler: function() { addFun(largCostDs, largCostMain, largCostPagingToolbar); }
});

var editDataTypesButton = new Ext.Toolbar.Button({
    text: '修改',
    tooltip: '修改选定的大额成本',
    iconCls: 'remove',
    handler: function() { editFun(largCostDs, largCostMain, largCostPagingToolbar); }
});

var delDataTypesButton = new Ext.Toolbar.Button({
    text: '删除',
    tooltip: '删除选定的大额成本',
    iconCls: 'remove',
    //disabled: true,
    handler: function() { delFun(largCostDs, largCostMain, largCostPagingToolbar); }
});

var excuteButton = new Ext.Toolbar.Button({
    text: '计算分期',
    tooltip: '计算分期',
    iconCls: 'add',
    handler: function() { LargEditFun(largCostDs, largCostMain, largCostPagingToolbar); }
});

var largCostSearchField = 'itemName';

var largCostFilterItem = new Ext.Toolbar.MenuButton({
    text: '过滤器',
    tooltip: '关键字所属类别',
    menu: { items: [
				new Ext.menu.CheckItem({ text: '凭证日期', value: 'vouchDate', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '凭证号', value: 'vouchNum', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '摘要', value: 'abstract', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '部门', value: 'deptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '项目', value: 'itemName', checked: true, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '金额', value: 'fee', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '分期数', value: 'cycles', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '录入人', value: 'inPersonDr', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '录入日期', value: 'inDate', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck })
		]
    }
});

function onDataTypesItemCheck(item, checked) {
    if (checked) {
        largCostSearchField = item.value;
        largCostFilterItem.setText(item.text + ':');
    }
};

var largCostSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
            largCostDs.proxy = new Ext.data.HttpProxy({ url: largCostUrl + '?action=list' });
            largCostDs.load({ params: { start: 0, limit: largCostPagingToolbar.pageSize} });
        }
    },
    onTrigger2Click: function() {
        if (this.getValue()) {
            largCostDs.proxy = new Ext.data.HttpProxy({
                url: largCostUrl + '?action=list&searchField=' + largCostSearchField + '&searchValue=' + this.getValue()
            });
            largCostDs.load({ params: { start: 0, limit: largCostPagingToolbar.pageSize} });
        }
    }
});

var largCostPagingToolbar = new Ext.PagingToolbar({//分页工具栏
    pageSize: 25,
    store: largCostDs,
    displayInfo: true,
    displayMsg: '当前显示{0} - {1}，共计{2}',
    emptyMsg: "没有数据",
    buttons: ['-', largCostFilterItem, '-', largCostSearchBox]
});

var largCostMain = new Ext.grid.GridPanel({//表格
    title: '大额成本',
    store: largCostDs,
    region: 'west',
    xtype: 'grid',
    width: 600,
    cm: largCostCm,
    split: true,
    collapsible: true,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
    loadMask: true,
    tbar: [addDataTypesButton, '-', editDataTypesButton, '-', delDataTypesButton, '-', excuteButton],
    bbar: largCostPagingToolbar
});

largCostDs.load({ params: { start: 0, limit: largCostPagingToolbar.pageSize} });



largCostMain.on('rowclick', function(grid, rowIndex, e) {
    var selectedRow = largCostDs.data.items[rowIndex];

    largCostDr = selectedRow.data["rowid"];
    itemName = selectedRow.data["itemName"];
    deptName = selectedRow.data["deptName"];
    largCostDetailGrid.setTitle(deptName + "-" + itemName + "-大额成本分期");
    largCostDetailDs.proxy = new Ext.data.HttpProxy({ url: largCostUrl + '?action=listDetial&largCostDr=' + largCostDr });
    largCostDetailDs.load({ params: { start: 0, limit: largCostDetailPagingToolbar.pageSize} });
});