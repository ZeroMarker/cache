var innerDeptControlUrl = 'dhc.ca.innerdeptcontrolexe.csp';
var innerDeptControlProxy = new Ext.data.HttpProxy({ url: innerDeptControlUrl + '?action=list' });

function formatDate(value) {
    return value ? value.dateFormat('Y-m-d') : '';
};
var innerDeptControlDs = new Ext.data.Store({
    proxy: innerDeptControlProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
            'rowid',
			'oldDeptDr',
			'oldDeptName',
			'newDeptDr',
			'newDeptName'

		]),
    // turn on remote sorting
    remoteSort: true
});

innerDeptControlDs.setDefaultSort('rowid', 'desc');

var innerDeptControlCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
	    header: '原始部门',
	    dataIndex: 'oldDeptName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '转换成部门',
	    dataIndex: 'newDeptName',
	    width: 150,
	    align: 'left',
	    sortable: true
	}
]);


var addDataTypesButton = new Ext.Toolbar.Button({
    text: '添加',
    tooltip: '添加新的收入数据表',
    iconCls: 'add',
    handler: function() { addFun(innerDeptControlDs, innerDeptControlMain, innerDeptControlPagingToolbar); }
});


var delDataTypesButton = new Ext.Toolbar.Button({
    text: '删除',
    tooltip: '删除选定的收入数据表',
    iconCls: 'remove',
    //disabled: true,
    handler: function() { delFun(innerDeptControlDs, innerDeptControlMain, innerDeptControlPagingToolbar); }
});


var innerDeptControlSearchField = 'oldDeptName';

var innerDeptControlFilterItem = new Ext.Toolbar.MenuButton({
    text: '过滤器',
    tooltip: '关键字所属类别',
    menu: { items: [
				new Ext.menu.CheckItem({ text: '转换成部门', value: 'newDeptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '原始部门', value: 'oldDeptName', checked: true, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck })
		]
    }
});

function onDataTypesItemCheck(item, checked) {
    if (checked) {
        innerDeptControlSearchField = item.value;
        innerDeptControlFilterItem.setText(item.text + ':');
    }
};

var innerDeptControlSearchBox = new Ext.form.TwinTriggerField({
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
            innerDeptControlDs.proxy = new Ext.data.HttpProxy({ url: innerDeptControlUrl + '?action=list' });
            innerDeptControlDs.load({ params: { start: 0, limit: innerDeptControlPagingToolbar.pageSize, monthDr: monthDr} });
        }
    },
    onTrigger2Click: function() {
        if (this.getValue()) {
            innerDeptControlDs.proxy = new Ext.data.HttpProxy({
                url: innerDeptControlUrl + '?action=list&searchField=' + innerDeptControlSearchField + '&searchValue=' + this.getValue()
            });
            innerDeptControlDs.load({ params: { start: 0, limit: innerDeptControlPagingToolbar.pageSize, monthDr: monthDr} });
        }
    }
});

var innerDeptControlPagingToolbar = new Ext.PagingToolbar({//分页工具栏
    pageSize: 25,
    store: innerDeptControlDs,
    displayInfo: true,
    displayMsg: '当前显示{0} - {1}，共计{2}',
    emptyMsg: "没有数据",
    buttons: ['-', innerDeptControlFilterItem, '-', innerDeptControlSearchBox]
});

var innerDeptControlMain = new Ext.grid.GridPanel({//表格
    title: '内部部门转换表',
    store: innerDeptControlDs,
    cm: innerDeptControlCm,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
    loadMask: true,
    tbar: [addDataTypesButton, '-', delDataTypesButton],
    bbar: innerDeptControlPagingToolbar
});

innerDeptControlDs.load({ params: { start: 0, limit: innerDeptControlPagingToolbar.pageSize} });