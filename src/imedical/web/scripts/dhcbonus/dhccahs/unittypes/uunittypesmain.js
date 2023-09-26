var unittypesUrl = 'dhc.ca.unittypesexe.csp';
var unittypesProxy = new Ext.data.HttpProxy({
    url: unittypesUrl + '?action=list'
});

var unittypesDs = new Ext.data.Store({
    proxy: unittypesProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, ['rowId', 'code', 'name', 'shortcut', 'remark', 'flag', 'active']),
    // turn on remote sorting
    remoteSort: true
});

unittypesDs.setDefaultSort('rowId', 'DESC');

var unittypesCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
    header: '����',
    dataIndex: 'code',
    width: 60,
    align: 'left',
    sortable: true
}, {
    header: "����",
    dataIndex: 'name',
    width: 120,
    align: 'left',
    sortable: true
}, //{
//    header: "�����",
//    dataIndex: 'shortcut',
//    width: 200,
//    align: 'left',
//    sortable: true
//},
{
    header: "��ע",
    dataIndex: 'remark',
    width: 200,
    align: 'left',
    sortable: true
}, {
    header: "��־",
    dataIndex: 'flag',
    width: 60,
    sortable: true,
    renderer: function(v, p, record){
        p.css += ' x-grid3-check-col-td';
        return '<div class="x-grid3-check-col' + (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
    }
}, {
    header: "��Ч",
    dataIndex: 'active',
    width: 60,
    sortable: true,
    renderer: function(v, p, record){
        p.css += ' x-grid3-check-col-td';
        return '<div class="x-grid3-check-col' + (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
    }
}]);

var addUnittypesButton = new Ext.Toolbar.Button({
    text: '���',
    tooltip: '����µĵ�λ���',
    iconCls: 'add',
    handler: function(){
        addFun(unittypesDs, unittypesMain, unittypesPagingToolbar);
    }
});

var editUnittypesButton = new Ext.Toolbar.Button({
    text: '�޸�',
    tooltip: '�޸�ѡ���ĵ�λ���',
    iconCls: 'remove',
    handler: function(){
        editFun(unittypesDs, unittypesMain, unittypesPagingToolbar);
    }
});

var delUnittypesButton = new Ext.Toolbar.Button({
    text: 'ɾ��',
    tooltip: 'ɾ��ѡ���ĵ�λ���',
    iconCls: 'remove',
    disabled: true,
    handler: function(){
        delFun(unittypesDs, unittypesMain, unittypesPagingToolbar);
    }
});

var unittypesSearchField = 'name';

var unittypesFilterItem = new Ext.Toolbar.MenuButton({
    text: '������',
    tooltip: '�ؼ����������',
    menu: {
        items: [new Ext.menu.CheckItem({
            text: '����',
            value: 'code',
            checked: false,
            group: 'UnittypesFilter',
            checkHandler: onUnittypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '����',
            value: 'name',
            checked: true,
            group: 'UnittypesFilter',
            checkHandler: onUnittypesItemCheck
        }),        //new Ext.menu.CheckItem({ text: '�����',value: 'shortcut',checked: true,group: 'UnittypesFilter',checkHandler: onUnittypesItemCheck }),
        new Ext.menu.CheckItem({
            text: '��ע',
            value: 'remark',
            checked: false,
            group: 'UnittypesFilter',
            checkHandler: onUnittypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '��־',
            value: 'flag',
            checked: false,
            group: 'UnittypesFilter',
            checkHandler: onUnittypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '��Ч',
            value: 'active',
            checked: false,
            group: 'UnittypesFilter',
            checkHandler: onUnittypesItemCheck
        })]
    }
});

function onUnittypesItemCheck(item, checked){
    if (checked) {
        unittypesSearchField = item.value;
        unittypesFilterItem.setText(item.text + ':');
    }
};

var unittypesSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
    width: 180,
    trigger1Class: 'x-form-clear-trigger',
    trigger2Class: 'x-form-search-trigger',
    emptyText: '����...',
    listeners: {
        specialkey: {
            fn: function(field, e){
                var key = e.getKey();
                if (e.ENTER === key) {
                    this.onTrigger2Click();
                }
            }
        }
    },
    grid: this,
    onTrigger1Click: function(){
        if (this.getValue()) {
            this.setValue('');
            unittypesDs.proxy = new Ext.data.HttpProxy({
                url: unittypesUrl + '?action=list'
            });
            unittypesDs.load({
                params: {
                    start: 0,
                    limit: unittypesPagingToolbar.pageSize
                }
            });
        }
    },
    onTrigger2Click: function(){
        if (this.getValue()) {
            unittypesDs.proxy = new Ext.data.HttpProxy({
                url: unittypesUrl + '?action=list&searchField=' + unittypesSearchField + '&searchValue=' + this.getValue()
            });
            unittypesDs.load({
                params: {
                    start: 0,
                    limit: unittypesPagingToolbar.pageSize
                }
            });
        }
    }
});

var unittypesPagingToolbar = new Ext.PagingToolbar({//��ҳ������
    pageSize: 25,
    store: unittypesDs,
    displayInfo: true,
    displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
    emptyMsg: "û������",
    buttons: ['-', unittypesFilterItem, '-', unittypesSearchBox]
});

var unittypesMain = new Ext.grid.GridPanel({//���
    title: '��λ����',
    store: unittypesDs,
    cm: unittypesCm,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({
        singleSelect: true
    }),
    loadMask: true,
    bbar: unittypesPagingToolbar
});

unittypesDs.load({
    params: {
        start: 0,
        limit: unittypesPagingToolbar.pageSize
    }
});
