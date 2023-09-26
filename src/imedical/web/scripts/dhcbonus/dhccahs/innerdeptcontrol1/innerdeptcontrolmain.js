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
	    header: 'ԭʼ����',
	    dataIndex: 'oldDeptName',
	    width: 150,
	    align: 'left',
	    sortable: true
	},
	{
	    header: 'ת���ɲ���',
	    dataIndex: 'newDeptName',
	    width: 150,
	    align: 'left',
	    sortable: true
	}
]);


var addDataTypesButton = new Ext.Toolbar.Button({
    text: '���',
    tooltip: '����µ��������ݱ�',
    iconCls: 'add',
    handler: function() { addFun(innerDeptControlDs, innerDeptControlMain, innerDeptControlPagingToolbar); }
});


var delDataTypesButton = new Ext.Toolbar.Button({
    text: 'ɾ��',
    tooltip: 'ɾ��ѡ�����������ݱ�',
    iconCls: 'remove',
    //disabled: true,
    handler: function() { delFun(innerDeptControlDs, innerDeptControlMain, innerDeptControlPagingToolbar); }
});


var innerDeptControlSearchField = 'oldDeptName';

var innerDeptControlFilterItem = new Ext.Toolbar.MenuButton({
    text: '������',
    tooltip: '�ؼ����������',
    menu: { items: [
				new Ext.menu.CheckItem({ text: 'ת���ɲ���', value: 'newDeptName', checked: false, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: 'ԭʼ����', value: 'oldDeptName', checked: true, group: 'DataTypesFilter', checkHandler: onDataTypesItemCheck })
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

var innerDeptControlPagingToolbar = new Ext.PagingToolbar({//��ҳ������
    pageSize: 25,
    store: innerDeptControlDs,
    displayInfo: true,
    displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
    emptyMsg: "û������",
    buttons: ['-', innerDeptControlFilterItem, '-', innerDeptControlSearchBox]
});

var innerDeptControlMain = new Ext.grid.GridPanel({//���
    title: '�ڲ�����ת����',
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