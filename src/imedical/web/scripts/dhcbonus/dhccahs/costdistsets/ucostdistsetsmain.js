
var costDistSetsProxy = new Ext.data.HttpProxy({
    url: costDistSetsUrl + '?action=list'
});

//�ɱ���̯������Դ
var costDistSetsDs = new Ext.data.Store({
    proxy: costDistSetsProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, ['rowid', 'order', 'code', 'name', 'shortcut', 'deptSetDr', 'deptSetName', 'remark', 'active', 'distFlag']),
    // turn on remote sorting
    remoteSort: true
});

costDistSetsDs.setDefaultSort('order', 'asc');

var costDistSetsCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
    header: '���',
    dataIndex: 'order',
    width: 60,
    align: 'left',
    sortable: true
}, {
    header: '����',
    dataIndex: 'code',
    width: 60,
    align: 'left',
    sortable: true
}, {
    header: '����',
    dataIndex: 'name',
    width: 150,
    align: 'left',
    sortable: true
}, {
    header: '���ŷֲ���',
    dataIndex: 'deptSetName',
    width: 150,
    align: 'left',
    sortable: true
}, {
    header: '��̯��־',
    dataIndex: 'distFlag',
    width: 80,
    align: 'left',
    sortable: true
}, {
    header: '��ע',
    dataIndex: 'remark',
    width: 200,
    align: 'left',
    sortable: true
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

var addDataTypesButton = new Ext.Toolbar.Button({
    text: '���',
    tooltip: '��ӳɱ���̯��',
    iconCls: 'add',
    handler: function(){
        addFun(costDistSetsDs, costDistSetsMain, costDistSetsPagingToolbar);
    }
});

var editDataTypesButton = new Ext.Toolbar.Button({
    text: '�޸�',
    tooltip: '�޸ĳɱ���̯��',
    iconCls: 'remove',
    handler: function(){
        editFun(costDistSetsDs, costDistSetsMain, costDistSetsPagingToolbar);
    }
});

var costResultButton = new Ext.Toolbar.Button({
    text: '�鿴��̯���',
    tooltip: '�鿴�ɱ���̯���',
    iconCls: 'remove',
    //disabled: true,
    handler: function(){
        costResultDataMain(costDistSetsDs, costDistSetsMain, costDistSetsPagingToolbar);
    }
});

var costDistMethodsButton = new Ext.Toolbar.Button({
    text: '���÷�̯����',
    tooltip: '���÷�̯����',
    iconCls: 'remove',
    //disabled: true,
    handler: function(){
        costDistMethods(costDistSetsDs, costDistSetsMain, costDistSetsPagingToolbar);
    }
});

var examinButton = new Ext.Toolbar.Button({
    text: '��̯���',
    tooltip: '��ѡ��ķ�̯�׽��з�̯���!',
    iconCls: 'remove',
    //disabled: true,
    handler: function(){
        examinMain(costDistSetsDs, costDistSetsMain, costDistSetsPagingToolbar);
    }
});

var costDistButton = new Ext.Toolbar.Button({
    text: '�ɱ���̯',
    tooltip: '��ѡ��ķ�̯�׷�̯�ɱ�!',
    iconCls: 'remove',
    //disabled: true,
    handler: function(){
        costDistMain(costDistSetsDs, costDistSetsMain, costDistSetsPagingToolbar);
    }
});

var costDistSetsSearchField = 'name';

var costDistSetsFilterItem = new Ext.Toolbar.MenuButton({
    text: '������',
    tooltip: '�ɱ���̯�����',
    menu: {
        items: [new Ext.menu.CheckItem({
            text: '���',
            value: 'order',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '����',
            value: 'code',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '����',
            value: 'name',
            checked: true,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '�ɱ���̯��',
            value: 'deptSetName',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '��ע',
            value: 'remark',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '�Ƿ���Ч',
            value: 'active',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '��̯��־',
            value: 'distFlag',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        })]
    }
});

function onDataTypesItemCheck(item, checked){
    if (checked) {
        costDistSetsSearchField = item.value;
        costDistSetsFilterItem.setText(item.text + ':');
    }
};

var costDistSetsSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
            costDistSetsDs.proxy = new Ext.data.HttpProxy({
                url: costDistSetsUrl + '?action=list'
            });
            costDistSetsDs.load({
                params: {
                    start: 0,
                    limit: costDistSetsPagingToolbar.pageSize
                }
            });
        }
    },
    onTrigger2Click: function(){
        if (this.getValue()) {
            costDistSetsDs.proxy = new Ext.data.HttpProxy({
                url: costDistSetsUrl + '?action=list&searchField=' + costDistSetsSearchField + '&searchValue=' + this.getValue()
            });
            costDistSetsDs.load({
                params: {
                    start: 0,
                    limit: costDistSetsPagingToolbar.pageSize
                }
            });
        }
    }
});

var costDistSetsPagingToolbar = new Ext.PagingToolbar({//�ɱ���̯��
    pageSize: 25,
    store: costDistSetsDs,
    displayInfo: true,
    displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
    emptyMsg: "û������",
    buttons: ['-', costDistSetsFilterItem, '-', costDistSetsSearchBox]
});

var costDistSetsMain = new Ext.grid.GridPanel({//���
    title: '�ɱ���̯��ά��',
    store: costDistSetsDs,
    cm: costDistSetsCm,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({
        singleSelect: true
    }),
    loadMask: true,
    tbar: [ costResultButton, '-', costDistMethodsButton],
    bbar: costDistSetsPagingToolbar
});
costDistSetsMain.on('rowclick', function(grid, rowIndex, e){
    var selectedRow = costDistSetsDs.data.items[rowIndex];
    distSetsDr = selectedRow.data["rowid"];
    distSetsName = selectedRow.data["name"];
    active = selectedRow.data["active"];
    layerDr = selectedRow.data["layerDr"];
    
});

costDistSetsDs.load({
    params: {
        start: 0,
        limit: costDistSetsPagingToolbar.pageSize
    }
});
