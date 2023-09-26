
var costDistSetsProxy = new Ext.data.HttpProxy({
    url: costDistSetsUrl + '?action=list'
});

//成本分摊套数据源
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
    header: '序号',
    dataIndex: 'order',
    width: 60,
    align: 'left',
    sortable: true
}, {
    header: '代码',
    dataIndex: 'code',
    width: 60,
    align: 'left',
    sortable: true
}, {
    header: '名称',
    dataIndex: 'name',
    width: 150,
    align: 'left',
    sortable: true
}, {
    header: '部门分层套',
    dataIndex: 'deptSetName',
    width: 150,
    align: 'left',
    sortable: true
}, {
    header: '分摊标志',
    dataIndex: 'distFlag',
    width: 80,
    align: 'left',
    sortable: true
}, {
    header: '备注',
    dataIndex: 'remark',
    width: 200,
    align: 'left',
    sortable: true
}, {
    header: "有效",
    dataIndex: 'active',
    width: 60,
    sortable: true,
    renderer: function(v, p, record){
        p.css += ' x-grid3-check-col-td';
        return '<div class="x-grid3-check-col' + (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
    }
}]);

var addDataTypesButton = new Ext.Toolbar.Button({
    text: '添加',
    tooltip: '添加成本分摊套',
    iconCls: 'add',
    handler: function(){
        addFun(costDistSetsDs, costDistSetsMain, costDistSetsPagingToolbar);
    }
});

var editDataTypesButton = new Ext.Toolbar.Button({
    text: '修改',
    tooltip: '修改成本分摊套',
    iconCls: 'remove',
    handler: function(){
        editFun(costDistSetsDs, costDistSetsMain, costDistSetsPagingToolbar);
    }
});

var costResultButton = new Ext.Toolbar.Button({
    text: '查看分摊结果',
    tooltip: '查看成本分摊结果',
    iconCls: 'remove',
    //disabled: true,
    handler: function(){
        costResultDataMain(costDistSetsDs, costDistSetsMain, costDistSetsPagingToolbar);
    }
});

var costDistMethodsButton = new Ext.Toolbar.Button({
    text: '设置分摊方法',
    tooltip: '设置分摊方法',
    iconCls: 'remove',
    //disabled: true,
    handler: function(){
        costDistMethods(costDistSetsDs, costDistSetsMain, costDistSetsPagingToolbar);
    }
});

var examinButton = new Ext.Toolbar.Button({
    text: '分摊检测',
    tooltip: '按选择的分摊套进行分摊检测!',
    iconCls: 'remove',
    //disabled: true,
    handler: function(){
        examinMain(costDistSetsDs, costDistSetsMain, costDistSetsPagingToolbar);
    }
});

var costDistButton = new Ext.Toolbar.Button({
    text: '成本分摊',
    tooltip: '按选择的分摊套分摊成本!',
    iconCls: 'remove',
    //disabled: true,
    handler: function(){
        costDistMain(costDistSetsDs, costDistSetsMain, costDistSetsPagingToolbar);
    }
});

var costDistSetsSearchField = 'name';

var costDistSetsFilterItem = new Ext.Toolbar.MenuButton({
    text: '过滤器',
    tooltip: '成本分摊套类别',
    menu: {
        items: [new Ext.menu.CheckItem({
            text: '序号',
            value: 'order',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '代码',
            value: 'code',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '名称',
            value: 'name',
            checked: true,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '成本分摊套',
            value: 'deptSetName',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '备注',
            value: 'remark',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '是否有效',
            value: 'active',
            checked: false,
            group: 'DataTypesFilter',
            checkHandler: onDataTypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '分摊标志',
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

var costDistSetsSearchBox = new Ext.form.TwinTriggerField({//查找按钮
    width: 180,
    trigger1Class: 'x-form-clear-trigger',
    trigger2Class: 'x-form-search-trigger',
    emptyText: '搜索...',
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

var costDistSetsPagingToolbar = new Ext.PagingToolbar({//成本分摊套
    pageSize: 25,
    store: costDistSetsDs,
    displayInfo: true,
    displayMsg: '当前显示{0} - {1}，共计{2}',
    emptyMsg: "没有数据",
    buttons: ['-', costDistSetsFilterItem, '-', costDistSetsSearchBox]
});

var costDistSetsMain = new Ext.grid.GridPanel({//表格
    title: '成本分摊套维护',
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
