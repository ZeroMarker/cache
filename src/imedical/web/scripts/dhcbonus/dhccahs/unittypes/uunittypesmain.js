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
    header: '代码',
    dataIndex: 'code',
    width: 60,
    align: 'left',
    sortable: true
}, {
    header: "名称",
    dataIndex: 'name',
    width: 120,
    align: 'left',
    sortable: true
}, //{
//    header: "快捷码",
//    dataIndex: 'shortcut',
//    width: 200,
//    align: 'left',
//    sortable: true
//},
{
    header: "备注",
    dataIndex: 'remark',
    width: 200,
    align: 'left',
    sortable: true
}, {
    header: "标志",
    dataIndex: 'flag',
    width: 60,
    sortable: true,
    renderer: function(v, p, record){
        p.css += ' x-grid3-check-col-td';
        return '<div class="x-grid3-check-col' + (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
    }
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

var addUnittypesButton = new Ext.Toolbar.Button({
    text: '添加',
    tooltip: '添加新的单位类别',
    iconCls: 'add',
    handler: function(){
        addFun(unittypesDs, unittypesMain, unittypesPagingToolbar);
    }
});

var editUnittypesButton = new Ext.Toolbar.Button({
    text: '修改',
    tooltip: '修改选定的单位类别',
    iconCls: 'remove',
    handler: function(){
        editFun(unittypesDs, unittypesMain, unittypesPagingToolbar);
    }
});

var delUnittypesButton = new Ext.Toolbar.Button({
    text: '删除',
    tooltip: '删除选定的单位类别',
    iconCls: 'remove',
    disabled: true,
    handler: function(){
        delFun(unittypesDs, unittypesMain, unittypesPagingToolbar);
    }
});

var unittypesSearchField = 'name';

var unittypesFilterItem = new Ext.Toolbar.MenuButton({
    text: '过滤器',
    tooltip: '关键字所属类别',
    menu: {
        items: [new Ext.menu.CheckItem({
            text: '代码',
            value: 'code',
            checked: false,
            group: 'UnittypesFilter',
            checkHandler: onUnittypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '名称',
            value: 'name',
            checked: true,
            group: 'UnittypesFilter',
            checkHandler: onUnittypesItemCheck
        }),        //new Ext.menu.CheckItem({ text: '快捷码',value: 'shortcut',checked: true,group: 'UnittypesFilter',checkHandler: onUnittypesItemCheck }),
        new Ext.menu.CheckItem({
            text: '备注',
            value: 'remark',
            checked: false,
            group: 'UnittypesFilter',
            checkHandler: onUnittypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '标志',
            value: 'flag',
            checked: false,
            group: 'UnittypesFilter',
            checkHandler: onUnittypesItemCheck
        }), new Ext.menu.CheckItem({
            text: '有效',
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

var unittypesSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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

var unittypesPagingToolbar = new Ext.PagingToolbar({//分页工具栏
    pageSize: 25,
    store: unittypesDs,
    displayInfo: true,
    displayMsg: '当前显示{0} - {1}，共计{2}',
    emptyMsg: "没有数据",
    buttons: ['-', unittypesFilterItem, '-', unittypesSearchBox]
});

var unittypesMain = new Ext.grid.GridPanel({//表格
    title: '单位类别表',
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
