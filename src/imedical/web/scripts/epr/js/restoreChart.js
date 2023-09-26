Ext.QuickTips.init();

var url = '../web.eprajax.restoreChart.cls?EpisodeID='+ episodeID;

function GetGridStore(){
    var store = new Ext.data.JsonStore({
        url: url,
        fields: [{
            name: 'ID'    
        }, {
            name: 'Title'
        }, {
            name: 'DumpedDate'
        }, {
            name: 'DumpedTime'
        }, {
            name: 'Status'
        }, {
            name: 'User'
        }
        ]
    });
    
    return store;
    
}

var gridTB1 = new Ext.Toolbar({
    border: false,
    items: [{
        id: 'btnRestore',
        name: 'btnRestore',
        text: '<font color="red">恢复</font>',
        cls: 'x-btn-text-icon',
        icon: '../scripts/epr/Pics/btnAddResultCol.gif',
        pressed: false,
        handler: function(){
		    commitRestore();
			parent.location.reload();
		}
    }   
    ]
});

function getGridPanel(){
    var store = GetGridStore();
    store.load();
    //console.log(store);
    var sm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true,
        listeners: {
            'rowselect': function(record, index, e){
                //选中对象触发的事件                
                ID = grid.getStore().getAt(index).data['ID'];
            }
        }
    });
    
    var cm = new Ext.grid.ColumnModel([sm, {
        header: '标题',
        dataIndex: 'Title',
        sortable: true,
        width: 100
    }, {
        header: '发生日期',
        dataIndex: 'DumpedDate',
        sortable: true,
        width: 100
    }, {
        header: '发生时间',
        dataIndex: 'DumpedTime',
        sortable: true,
        width: 100
    }, {
        header: '状态',
        dataIndex: 'Status',
        sortable: true,
        width: 100
    }, {
        header: '用户',
        dataIndex: 'User',
        sortable: true,
        width: 100
    }]);
    
    var grid = new Ext.grid.GridPanel({
        id: 'disRestoreGrid',
        layout: 'fit',
        store: store,
        cm: cm,
        sm: sm,
        forceFit: true,
        autoScroll: true,
        frame: true,
        tbar: gridTB1
    });
    	
    return grid;
}

var grid = getGridPanel();

var view = new Ext.Viewport({
    id: 'viewport',
    shim: false,
    animCollapse: false,
    constrainHeader: true,
    collapsible: true,
    margins: '0 0 0 0',
    layout: "border",
    border: false,
    items: [{
        border: false,
        region: 'center',
        layout: 'fit',
        split: true,
        collapsible: true,
        width: 480,
        items: grid
    }]
});

function commitRestore(){
    var grid = Ext.getCmp('disRestoreGrid');
    var selectedRows = grid.getSelectionModel().getSelections();
    if (selectedRows.length > 0) {
        for (var i = 0; i < selectedRows.length; i++) {
            var row = selectedRows[i];
            
            //ID
            var ID = row.get('ID');
            var EPRAction= row.get('EPRAction');
            //alert(EPRAction);
            if (ID == "") {
                Ext.MessageBox.alert('操作提示', '请选中一条记录再恢复');
                return;
            }
            if (EPRAction == "已恢复") {
                Ext.MessageBox.alert('操作提示', '病历已恢复，不需重复恢复');
                return;
            }
            //ajax
            Ext.Ajax.request({
                url: url,
                timeout: 5000,
                params: {
                    Action: "IsRestore",
                    EpisodeID:episodeID,
                    ID: ID
                },
                success: function(response, opts){
                    //debugger;
                    if (response.responseText == "1") {
                        var s = Ext.getCmp('disRestoreGrid').getStore();
                        s.proxy.conn.url = url;
                        s.load();
                        Ext.MessageBox.alert('操作提示', '病历恢复成功');
                        //ajaxAction();
                    }
                    else {
                        Ext.MessageBox.alert('操作提示', '病历恢复失败');
                    }
                },
                failure: function(response, opts){
                    Ext.MessageBox.alert("提示", response.responseText);
                }
            });
        }
    }
    
    
}