
// create the Data Store
var inDataCardingds = new Ext.data.Store({
    id: 'inDataCardingds',
    proxy: new Ext.data.HttpProxy({
        url: busdingUrl + '?action=listrule'
    }),
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, ['rowid', 'priority', 'code', 'name', 'shortcut', 'remark','active']),  //zjw 20160120�����Ч��active
    
    
    remoteSort: true
});
//inDataCardingds.on('beforeload', function(){if (inDataCardRuleLocPanel.getSelections().length>0) var parentselectedRow = inDataCardRuleLocPanel.getSelections()[0].id;else {parentselectedRow='0||0';}inDataCardingds.baseParams = {parent:parentselectedRow};});



var cm = new Ext.grid.ColumnModel([{
    header: '���ȼ�',
    dataIndex: 'priority',
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
    width: 100,
    align: 'left',
    sortable: true
}, {
    header: '��ע',
    dataIndex: 'remark',
    width: 120,
    align: 'left',
    sortable: true
},
    {
        header: "��Ч",		//zjw 20160120�����Ч��active
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
    text: '����',
    id: 'loctypeadd',
    tooltip: '����������������',
    iconCls: 'add',
    disabled: !CARDINGFLAG,
    handler: function(){
        addLocsFun(inDataCardingds, inDataCardingPanel, inDataCardingPagingToolbar);
    }
}, '-', {
    text: '�޸�',
    tooltip: '�޸�������������',
    iconCls: 'add',
    disabled: !CARDINGFLAG,
    handler: function(){
        editLocsFun(inDataCardingds, inDataCardingPanel, inDataCardingPagingToolbar);
    }
}, '-', {
    text: 'ɾ��',
    tooltip: 'ɾ��ѡ����������������',
    iconCls: 'remove',
    disabled: true,
    id: 'locdel',
    handler: function(){
        var selectedRow = inDataCardingPanel.getSelections();
        if (selectedRow.length < 1) {
            Ext.MessageBox.show({
                title: '��ʾ',
                msg: '��ѡ��һ�����ݣ�',
                buttons: Ext.MessageBox.OK,
                icon: Ext.MessageBox.INFO
            });
            return false;
        }
        var tmpRowid = selectedRow[0].get("rowid");
        Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ�е�����?', function(btn){
            if (btn == 'yes') {
                Ext.Ajax.request({
                    url: busdingUrl + '?action=delCarding&id=' + tmpRowid,
                    waitMsg: 'ɾ����...',
                    failure: function(result, request){
                        Ext.Msg.show({
                            title: '����',
                            msg: '������������!',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    },
                    success: function(result, request){
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        if (jsonData.success == 'true') {
                            message = 'ɾ���ɹ�!';
                            Ext.Msg.show({
                                title: 'ע��',
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
                                title: '����',
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
    text: '������',
    tooltip: '�ؼ����������',
    menu: {
        items: [new Ext.menu.CheckItem({
            text: '����',
            value: 'code',
            checked: false,
            group: 'filter',
            checkHandler: inDataCardingRulesonItemCheck
        }), new Ext.menu.CheckItem({
            text: '�Ƿ���Ч',
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
    displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
    emptyMsg: "û������"
});



var inDataCardingPanel = new Ext.grid.GridPanel({
    //title:'�������ݷ������',
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
    //�����������ݵ�Ԫ��ˢ���������ݵ�Ԫ��Ԫ
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
