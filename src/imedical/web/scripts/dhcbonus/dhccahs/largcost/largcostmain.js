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
	    header: "ƾ֤����",
	    dataIndex: 'vouchDate',
	    width: 75,
	    renderer: formatDate,
	    align: 'left',
	    sortable: true
	},
	{
	    header: 'ƾ֤��',
	    dataIndex: 'vouchNum',
	    width: 60,
	    align: 'left',
	    sortable: true
	},
	{
	    header: 'ժҪ',
	    dataIndex: 'abstract',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '����',
	    dataIndex: 'deptName',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: 'ҵ����',
	    dataIndex: 'itemName',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '���',
	    dataIndex: 'fee',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '������',
	    dataIndex: 'cycles',
	    width: 45,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '¼����',
	    dataIndex: 'inPersonName',
	    width: 60,
	    align: 'left',
	    sortable: true
	},
	{
	    header: "¼������",
	    dataIndex: 'inDate',
	    width: 75,
	    renderer: formatDate,
	    align: 'left',
	    sortable: true
	},
		{
		    header: "�����־",
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
    text: '���',
    tooltip: '����µĴ��ɱ�',
    iconCls: 'add',
    handler: function() { addFun(largCostDs, largCostMain, largCostPagingToolbar); }
});

var editDataTypesButton = new Ext.Toolbar.Button({
    text: '�޸�',
    tooltip: '�޸�ѡ���Ĵ��ɱ�',
    iconCls: 'remove',
    handler: function() { editFun(largCostDs, largCostMain, largCostPagingToolbar); }
});

var delDataTypesButton = new Ext.Toolbar.Button({
    text: 'ɾ��',
    tooltip: 'ɾ��ѡ���Ĵ��ɱ�',
    iconCls: 'remove',
    //disabled: true,
    handler: function() { delFun(largCostDs, largCostMain, largCostPagingToolbar); }
});

var excuteButton = new Ext.Toolbar.Button({
    text: '�������',
    tooltip: '�������',
    iconCls: 'add',
    handler: function() { LargEditFun(largCostDs, largCostMain, largCostPagingToolbar); }
});

var largCostSearchField = 'itemName';

var largCostFilterItem = new Ext.Toolbar.MenuButton({
    text: '������',
    tooltip: '�ؼ����������',
    menu: { items: [
				new Ext.menu.CheckItem({ text: 'ƾ֤����', value: 'vouchDate', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: 'ƾ֤��', value: 'vouchNum', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: 'ժҪ', value: 'abstract', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '����', value: 'deptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��Ŀ', value: 'itemName', checked: true, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '���', value: 'fee', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '������', value: 'cycles', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '¼����', value: 'inPersonDr', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '¼������', value: 'inDate', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck })
		]
    }
});

function onDataTypesItemCheck(item, checked) {
    if (checked) {
        largCostSearchField = item.value;
        largCostFilterItem.setText(item.text + ':');
    }
};

var largCostSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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

var largCostPagingToolbar = new Ext.PagingToolbar({//��ҳ������
    pageSize: 25,
    store: largCostDs,
    displayInfo: true,
    displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
    emptyMsg: "û������",
    buttons: ['-', largCostFilterItem, '-', largCostSearchBox]
});

var largCostMain = new Ext.grid.GridPanel({//���
    title: '���ɱ�',
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
    largCostDetailGrid.setTitle(deptName + "-" + itemName + "-���ɱ�����");
    largCostDetailDs.proxy = new Ext.data.HttpProxy({ url: largCostUrl + '?action=listDetial&largCostDr=' + largCostDr });
    largCostDetailDs.load({ params: { start: 0, limit: largCostDetailPagingToolbar.pageSize} });
});