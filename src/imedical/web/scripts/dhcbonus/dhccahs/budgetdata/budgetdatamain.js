var budgetDataUrl = 'dhc.ca.budgetdataexe.csp';
var budgetDataProxy = new Ext.data.HttpProxy({ url: budgetDataUrl + '?action=list' });
var intervalDr = "";
function formatDate(value) {
    //alert(value);
    return value ? value.dateFormat('Y-m-d') : '';
};

//�ӿڲ���������Դ
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
	    header: '��������',
	    dataIndex: 'deptName',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: 'ҵ��������',
	    dataIndex: 'itemName',
	    width: 100,
	    align: 'left',
	    sortable: true
	},

	{
	    header: '����',
	    dataIndex: 'amount',
	    width: 70,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '����',
	    dataIndex: 'price',
	    width: 100,
	    align: 'right',
	    renderer: formatNum,
	    sortable: true
	},
	{
	    header: '���',
	    dataIndex: 'fee',
	    width: 100,
	    align: 'right',
	    renderer: formatNum,
	    sortable: true
	},
	{
	    header: '��ע',
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
    fieldLabel: '��������',
    width: 100,
    listWidth: 260,
    allowBlank: false,
    store: monthsDs,
    //readOnly:true,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText: 'ѡ���������...',
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
    text: '���',
    tooltip: '����µ�Ԥ������',
    iconCls: 'add',
    handler: function() { addFun(budgetDataDs, budgetDataMain, budgetDataPagingToolbar); }
});

var editDataTypesButton = new Ext.Toolbar.Button({
    text: '�޸�',
    tooltip: '�޸�ѡ����Ԥ������',
    iconCls: 'remove',
    handler: function() { editFun(budgetDataDs, budgetDataMain, budgetDataPagingToolbar); }
});

var delDataTypesButton = new Ext.Toolbar.Button({
    text: 'ɾ��',
    tooltip: 'ɾ��ѡ����Ԥ������',
    iconCls: 'remove',
    //disabled: true,
    handler: function() { delFun(budgetDataDs, budgetDataMain, budgetDataPagingToolbar); }
});

var totalButton = new Ext.Toolbar.Button({
    text: 'ͳ�ƻ���',
    tooltip: 'ͳ�ƻ���',
    iconCls: 'remove',
    handler: function() { CommFindFun(budgetDataDs, budgetDataMain, budgetDataPagingToolbar) }
});
var budgetDataSearchField = 'itemName';

var budgetDataFilterItem = new Ext.Toolbar.MenuButton({
    text: '������',
    tooltip: '�ؼ����������',
    menu: { items: [
				new Ext.menu.CheckItem({ text: '����', value: 'amount', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '����', value: 'price', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '���', value: 'fee', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��Ŀ����', value: 'itemName', checked: true, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��������', value: 'deptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck })
		
		]
    }
});

function onDataTypesItemCheck(item, checked) {
    if (checked) {
        budgetDataSearchField = item.value;
        budgetDataFilterItem.setText(item.text + ':');
    }
};

var budgetDataSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
    width: 180,
    trigger1Class: 'x-form-clear-trigger',
    trigger2Class: 'x-form-search-trigger',
    emptyText: '����...',
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

var budgetDataPagingToolbar = new Ext.PagingToolbar({//��ҳ������
    pageSize: 25,
    store: budgetDataDs,
    displayInfo: true,
    displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
    emptyMsg: "û������",
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

var budgetDataMain = new Ext.grid.GridPanel({//���
    title: '���ݱ�',
    store: budgetDataDs,
    cm: budgetDataCm,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
    loadMask: true,
    tbar: ['��������:', months, '-', addDataTypesButton, '-', delDataTypesButton, '-', totalButton],
    bbar: budgetDataPagingToolbar
});

//budgetDataDs.load({params:{start:0, limit:budgetDataPagingToolbar.pageSize}});