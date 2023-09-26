var inDistMethodsUrl = 'dhc.ca.indistmethodsexe.csp';
var inDistMethodsProxy = new Ext.data.HttpProxy({ url: inDistMethodsUrl + '?action=list' });

//����������Դ
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
	    header: '����˳��',
	    dataIndex: 'priority',
	    width: 100,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '���˹���',
	    dataIndex: 'inFiltRuleName',
	    width: 200,
	    align: 'left',
	    sortable: true
	},
	{
	    header: '�������',
	    dataIndex: 'inDistRuleName',
	    width: 200,
	    align: 'left',
	    sortable: true
	}
]);

var addDataTypesButton = new Ext.Toolbar.Button({
    text: '���',
    tooltip: '����µ�������䷽��',
    iconCls: 'add',
    handler: function() { addFun(inDistMethodsDs, inDistMethodsMain, inDistMethodsPagingToolbar); }
});

var editDataTypesButton = new Ext.Toolbar.Button({
    text: '�޸�',
    tooltip: '�޸�ѡ����������䷽��',
    iconCls: 'remove',
    handler: function() { editFun(inDistMethodsDs, inDistMethodsMain, inDistMethodsPagingToolbar); }
});

var delDataTypesButton = new Ext.Toolbar.Button({
    text: 'ɾ��',
    tooltip: 'ɾ��ѡ����������䷽��',
    iconCls: 'remove',
    //disabled: true,
    handler: function() { delFun(inDistMethodsDs, inDistMethodsMain, inDistMethodsPagingToolbar); }
});

var inDistMethodsSearchField = 'inFiltRuleName';

var inDistMethodsFilterItem = new Ext.Toolbar.MenuButton({
    text: '������',
    tooltip: '�ؼ����������',
    menu: { items: [
				new Ext.menu.CheckItem({ text: '����˳��', value: 'priority', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '���˹���', value: 'inFiltRuleName', checked: true, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '�������', value: 'inDistRuleName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck })
		]
    }
});

function onDataTypesItemCheck(item, checked) {
    if (checked) {
        inDistMethodsSearchField = item.value;
        inDistMethodsFilterItem.setText(item.text + ':');
    }
};

var inDistMethodsSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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

var inDistMethodsPagingToolbar = new Ext.PagingToolbar({//��ҳ������
    pageSize: 25,
    store: inDistMethodsDs,
    displayInfo: true,
    displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
    emptyMsg: "û������",
    buttons: ['-', inDistMethodsFilterItem, '-', inDistMethodsSearchBox]
});

var inDistMethodsMain = new Ext.grid.GridPanel({//���
    title: '������䷽��',
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