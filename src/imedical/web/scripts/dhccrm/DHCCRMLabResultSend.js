// JS:DHCCRMLabResultSend.js
// 描述: 化验单结果传送
// Creater：zl
// 日期:2010-04-07
Ext.onReady(function(){
    Ext.QuickTips.init(); //初始化所有Tips
    var LabResultStore = new Ext.data.Store({
    
        url: 'dhccrmlisresultsend1.csp?actiontype=LisResultList',
        
        reader: new Ext.data.JsonReader({
        
            totalProperty: 'results',
            root: 'rows'
        
        }, [{
            name: 'PatRegNo'
        }, {
            name: 'PatName'
        }, {
            name: 'ARCItemDesc'
        }, {
            name: 'MobileSend'
        }, {
            name: 'EmailSend'
        }])
    });
    
    
    
    var LabResultCm = new Ext.grid.ColumnModel([{
    
        header: '登记号',
        dataIndex: 'PatRegNo'
    
    }, {
    
        header: '姓名',
        dataIndex: 'PatName'
    
    }, {
    
        header: '医嘱',
        dataIndex: 'ARCItemDesc',
        width: 400
    
    }, {
    
        header: '短信发送',
        dataIndex: 'MobileSend'
    
    }, {
    
        header: '邮件发送',
        dataIndex: 'EmailSend'
    
    
    }]);
    var BottomBar = new Ext.PagingToolbar({
    
        pageSize: 8,
        displayInfo: true,
        store: LabResultStore,
        displayMsg: '当前显示{0} - {1},共计{2}',
        
        emptyMsg: "没有数据"
    
    })
    
    var LocStore = new Ext.data.Store({
    
        url: 'dhccrmlisresultsend1.csp?actiontype=CTLocList',
        
        reader: new Ext.data.JsonReader({
            totalProperty: "results",
            root: "rows",
            id: 'CTLocRowID'
        }, [{
            name: 'CTLocRowID'
        }, {
            name: 'CTLocName'
        }])
    
    });
    
    var FindMain = new Ext.form.FormPanel({
        title: '查询',
        frame: true,
        labelWidth: 80,
        region: 'center',
        items: [{
            layout: 'column',
            items: [{
                columnWidth: 0.3,
                layout: 'form',
                items: [{
                    xtype: 'datefield',
                    fieldLabel: '开始日期',
                    id: 'DateFrom',
                    name: 'DateFrom',
                    allowBlank: false,
                    width: 150
                }]
            }, {
                columnWidth: 0.7,
                layout: 'form',
                items: [{
                    xtype: 'datefield',
                    fieldLabel: '结束日期',
                    id: 'DateTo',
                    name: 'DateTo',
                    auchor: '90%',
                    allowBlank: true,
                    width: 150
                }]
            }]
        }, {
            layout: 'column',
            items: [{
                columnWidth: 0.3,
                layout: 'form',
                items: [{
                    xtype: 'combo',
                    fieldLabel: '科室',
                    id: 'CTLoc',
                    name: 'CTLoc',
                    width: 150,
                    minChars: 1,
                    store: LocStore,
                    mode: 'remote',
                    valueField: 'CTLocRowID',
                    displayField: 'CTLocName',
                    triggerAction: 'all',
                    typeAhead: true,
                    selectOnFocus: true,
					forceSelection: true
                
                }]
            }]
        }]
    
    });
    
    
    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: FindMain
    });
});
