
// create the Data Store
var inDataCardingds = new Ext.data.Store({
    id: 'inDataCardingds',
    proxy: new Ext.data.HttpProxy({
        url: busdingUrl + '?action=listrule'
    }),
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, ['rowid', 'priority', 'code', 'name', 'shortcut', 'remark','active']),  //zjw 20160120添加有效性active
    
    
    remoteSort: true
});
//inDataCardingds.on('beforeload', function(){if (inDataCardRuleLocPanel.getSelections().length>0) var parentselectedRow = inDataCardRuleLocPanel.getSelections()[0].id;else {parentselectedRow='0||0';}inDataCardingds.baseParams = {parent:parentselectedRow};});



var cm = new Ext.grid.ColumnModel([{
    header: '优先级',
    dataIndex: 'priority',
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
    width: 100,
    align: 'left',
    sortable: true
}, {
    header: '备注',
    dataIndex: 'remark',
    width: 120,
    align: 'left',
    sortable: true
},
    {
        header: "有效",		//zjw 20160120添加有效性active
        dataIndex: 'active',
        width: 50,
        sortable: true,
        renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    	}
    }
]);


// by default columns are sortable
cm.defaultSortable = true;

var menubar = [{
    text: '增加',
    id: 'loctypeadd',
    tooltip: '增加收入数据梳理',
    iconCls: 'add',
    disabled: !CARDINGFLAG,
    handler: function(){
        addLocsFun(inDataCardingds, inDataCardingPanel, inDataCardingPagingToolbar);
    }
}, '-', {
    text: '修改',
    tooltip: '修改收入数据梳理',
    iconCls: 'add',
    disabled: !CARDINGFLAG,
    handler: function(){
        editLocsFun(inDataCardingds, inDataCardingPanel, inDataCardingPagingToolbar);
    }
}, '-', {
    text: '删除',
    tooltip: '删除选定的收入数据梳理',
    iconCls: 'remove',
    disabled: true,
    id: 'locdel',
    handler: function(){
        var selectedRow = inDataCardingPanel.getSelections();
        if (selectedRow.length < 1) {
            Ext.MessageBox.show({
                title: '提示',
                msg: '请选择一个数据！',
                buttons: Ext.MessageBox.OK,
                icon: Ext.MessageBox.INFO
            });
            return false;
        }
        var tmpRowid = selectedRow[0].get("rowid");
        Ext.MessageBox.confirm('提示', '确定要删除选中的数据?', function(btn){
            if (btn == 'yes') {
                Ext.Ajax.request({
                    url: busdingUrl + '?action=delCarding&id=' + tmpRowid,
                    waitMsg: '删除中...',
                    failure: function(result, request){
                        Ext.Msg.show({
                            title: '错误',
                            msg: '请检查网络连接!',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    },
                    success: function(result, request){
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        if (jsonData.success == 'true') {
                            message = '删除成功!';
                            Ext.Msg.show({
                                title: '注意',
                                msg: message,
                                icon: Ext.MessageBox.INFO,
                                buttons: Ext.Msg.OK
                            });
                            inDataCardRuleDs.load({
                                params: {
                                    start: 0,
                                    limit: 0
                                }
                            });
                            inDataCardingds.load({
                                params: {
                                    start: 0,
                                    limit: inDataCardingPagingToolbar.pageSize
                                }
                            });
                            
                        }
                        else {
                            Ext.Msg.show({
                                title: '错误',
                                msg: jsonData.info,
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.ERROR
                            });
                            
                        }
                    },
                    scope: this
                });
                
            }
        });
    }
}];



inDataCardingRulessfieldname = 'name';
inDataCardingRulesfilteritem = new Ext.Toolbar.MenuButton({
    text: '过滤器',
    tooltip: '关键字所属类别',
    menu: {
        items: [new Ext.menu.CheckItem({
            text: '组名',
            value: 'code',
            checked: false,
            group: 'filter',
            checkHandler: inDataCardingRulesonItemCheck
        }), new Ext.menu.CheckItem({
            text: '是否有效',
            value: 'name',
            checked: true,
            group: 'filter',
            checkHandler: inDataCardingRulesonItemCheck
        })]
    }
});

// Update search button text with selected item
function inDataCardingRulesonItemCheck(item, checked){
    if (checked) {
        inDataCardingRulessfieldname = item.value;
        inDataCardingRulesfilteritem.setText(item.text + ':');
    }
}

////
searchbox = new Ext.form.TwinTriggerField({
    width: 120,
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
            inDataCardingds.proxy = new Ext.data.HttpProxy({
                url: '../scripts/ext2/tutorial/Right/inDataCardingRulesQuery.csp?action=list'
            }), inDataCardingds.load({
                params: {
                    start: 0,
                    limit: inDataCardingPagingToolbar.pageSize
                }
            });
        }
    },
    onTrigger2Click: function(){
        if (this.getValue()) {
            inDataCardingds.proxy = new Ext.data.HttpProxy({
                url: '../scripts/ext2/tutorial/Right/inDataCardingRulesQuery.csp?action=list&' + inDataCardingRulessfieldname + '=' + this.getValue()
            }), inDataCardingds.load({
                params: {
                    start: 0,
                    limit: inDataCardingPagingToolbar.pageSize
                }
            });
        }
    }
});

var inDataCardingPagingToolbar = new Ext.PagingToolbar({
    id: 'inDataCardingPagingToolbar',
    pageSize: 10,
    store: inDataCardingds,
    displayInfo: true,
    displayMsg: '当前显示{0} - {1}，共计{2}',
    emptyMsg: "没有数据"
});



var inDataCardingPanel = new Ext.grid.GridPanel({
    //title:'特殊数据分配参数',
    region: 'center',
    split: true,
    //collapsible: true,
    containerScroll: true,
    xtype: 'grid',
    store: inDataCardingds,
    cm: cm,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({
        singleSelect: false
    }),
    loadMask: true,
    viewConfig: {
        forceFit: true
    },
    tbar: menubar,
    bbar: inDataCardingPagingToolbar
});

inDataCardingPanel.on('rowclick', function(grid, rowIndex, e){
    //单击特殊数据单元后刷新特殊数据单元单元
    var selectedRow = inDataCardingds.data.items[rowIndex];
    inDataCardingId = selectedRow.data["rowid"];
    inDataCardingCode = selectedRow.data["code"];
    var findInDataCardingCm = ""
    if (inDataCardingCode == RULEONE) {
        findInDataCardingCm = oneCm;
    }
    else 
        if (inDataCardingCode == RULETWO) {
            findInDataCardingCm = twoCm;
        }
        else {
            findInDataCardingCm = threeCm;
        }
    
    inDataCardRuleGrid.reconfigure(inDataCardRuleDs, findInDataCardingCm);
    inDataCardRuleDs.load({
        params: {
            start: 0,
            limit: inDataCardRulePagingToolbar.pageSize,
            parRef: inDataCardingId
        }
    });
});
inDataCardingds.load({
    params: {
        start: 0,
        limit: inDataCardingPagingToolbar.pageSize
    }
});
