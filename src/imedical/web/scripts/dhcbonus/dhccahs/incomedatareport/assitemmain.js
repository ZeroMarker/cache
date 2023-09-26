var vouchDatasUrl = 'dhc.ca.incomedatareportexe.csp';
var vouchDatasProxy = new Ext.data.HttpProxy({ url: vouchDatasUrl + '?action=list' });
var monthDr = "";
var itemLevelSets = "";
var deptSetId = "";

var assItemMonthsDs = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'code', 'name', 'desc', 'start', 'end', 'dataFinish'])
});
var assItemMonsCombo = new Ext.ux.form.LovCombo({
    id: 'assItemMonsCombo',
    fieldLabel: '月份',
    hideOnSelect: false,
    store: new Ext.data.Store({
        autoLoad: true,
        proxy: new Ext.data.HttpProxy({ url: 'dhc.ca.accountmonthsexe.csp?action=list' }),
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: 'results',
            id: 'rowid'
        }, [
			'rowid',
			'name'
		])
    }, [
		'rowid', 'name'
    ]),
    valueField: 'rowid',
    displayField: 'name',
    typeAhead: false,
    triggerAction: 'all',
    pageSize: 10,
    listWidth: 250,
    allowBlank: false,
    emptyText: '选择月份...',
    editable: false,
    //allowBlank: false,
    anchor: '90%'
});
assItemMonsCombo.on("select", function(cmb, rec, id) {

    monthDr = cmb.getValue();
});
var assItemItemSetDs = new Ext.data.Store({
    //autoLoad: true,
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['id', 'name'])
});

assItemItemSetDs.on('beforeload', function(ds, o) {
    ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.datalevelsetsexe.csp?action=listsub&id=roo', method: 'GET' });
});

var assItemItemSetComb = new Ext.form.ComboBox({
    id: 'assItemItemSetComb',
    fieldLabel: '数据分层套',
    store: assItemItemSetDs,
    valueField: 'id',
    displayField: 'name',
    typeAhead: true,
    pageSize: 10,
    minChars: 1,
    width: 100,
    listWidth: 250,
    triggerAction: 'all',
    emptyText: '选择数据分层套...',
    allowBlank: false,
    selectOnFocus: true,
    forceSelection: true
});

var assItemItemLayerDs = new Ext.data.Store({
    //autoLoad: true,
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['id', 'name'])
});

assItemItemSetComb.on("select", function(cmb, rec, id) {
    itemLevelSets = cmb.getValue();
    assItemItemLayerComb.setValue("");
    assItemItemLayerComb.setRawValue("");
    assItemItemLayerDs.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.datalevelsetsexe.csp?action=listsub&id=' + itemLevelSets, method: 'GET' });
    assItemItemLayerDs.load({ params: { start: 0, limit: assItemItemLayerComb.pageSize} });
});

var assItemItemLayerComb = new Ext.form.ComboBox({
    id: 'assItemItemLayerComb',
    fieldLabel: '收入类型',
    store: assItemItemLayerDs,
    valueField: 'id',
    displayField: 'name',
    typeAhead: true,
    pageSize: 10,
    minChars: 1,
    width: 100,
    listWidth: 250,
    triggerAction: 'all',
    emptyText: '选择收入类型...',
    allowBlank: false,
    selectOnFocus: true,
    forceSelection: true
});
//-----------------------------------

var assItemDeptSetDs = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['id', 'code', 'name', 'desc', 'remark', 'leaf', 'end', 'active', 'parent', 'uiProvider', 'order', 'recCost', 'hospDr', 'hospName', 'locDr'])
});
var assItemDeptSetComb = new Ext.form.ComboBox({
    id: 'assItemDeptSetComb',
    fieldLabel: '部门分层套',
    width: 100,
    listWidth: 260,
    allowBlank: false,
    store: assItemDeptSetDs,
    valueField: 'id',
    displayField: 'desc',
    triggerAction: 'all',
    emptyText: '部门分层套...',
    pageSize: 10,
    minChars: 1,
    selectOnFocus: true,
    forceSelection: true
});
assItemDeptSetDs.on('beforeload', function(ds, o) {
    ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.costdistsetsexe.csp?action=listsub&id=roo&searchField=desc&active=Y&searchValue=' + Ext.getCmp('assItemDeptSetComb').getRawValue(), method: 'GET' });

});

assItemDeptSetComb.on("select", function(cmb, rec, id) {
    var selectedRow = assItemDeptSetDs.data.items[id];
    var order = selectedRow.data["order"];
    deptSetId = selectedRow.data["id"];
    assItemDeptLayerComb.setValue("");
    assItemDeptLayerComb.setRawValue("");
    assItemDeptLayerDs.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.costdistsetsexe.csp?action=listsub&id=' + deptSetId + '&searchField=desc&active=Y&searchValue=' + Ext.getCmp('assItemDeptLayerComb').getRawValue(), method: 'GET' });
    assItemDeptLayerDs.load({ params: { start: 0, limit: assItemDeptLayerComb.pageSize} });
});
var assItemDeptLayerDs = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['id', 'code', 'name', 'desc', 'remark', 'leaf', 'end', 'active', 'parent', 'uiProvider', 'order', 'recCost', 'hospDr', 'hospName', 'locDr'])
});
var assItemDeptLayerComb = new Ext.form.ComboBox({
    id: 'assItemDeptLayerComb',
    fieldLabel: '科室属性',
    width: 100,
    listWidth: 260,
    allowBlank: false,
    store: assItemDeptLayerDs,
    valueField: 'id',
    displayField: 'desc',
    triggerAction: 'all',
    emptyText: '科室属性...',
    pageSize: 10,
    minChars: 1,
    selectOnFocus: true,
    forceSelection: true
});

//---------------------------------------------------------
assItemItemLayerComb.on("select", function(cmb, rec, id) {
    assItemComb.setValue("");
    assItemComb.setRawValue("");
    assItemDs.load({ params: { start: 0, limit: assItemComb.pageSize, node: cmb.getValue()} });
})

var assItemDs = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['itemDr', 'itemDesc'])
});
var assItemComb = new Ext.form.ComboBox({
    id: 'assItemComb',
    fieldLabel: '项目',
    width: 100,
    listWidth: 260,
    allowBlank: true,
    store: assItemDs,
    valueField: 'itemDr',
    displayField: 'itemDesc',
    triggerAction: 'all',
    emptyText: '选择项目...',
    pageSize: 10,
    minChars: 1,
    selectOnFocus: true,
    forceSelection: true
});

assItemDs.on('beforeload', function(ds, o) {
    ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.incomedatareportexe.csp?action=items&searchValue=' + Ext.getCmp('assItemComb').getRawValue() + '&node=23' + assItemItemLayerComb.getValue(), method: 'GET' });
});


//-------------------------------------
var assItemCheckButton = new Ext.Toolbar.Button({
    text: '查看',
    tooltip: '查看',
    iconCls: 'add',
    handler: function() {
        if ((assItemMonsCombo.getValue() == "") ||  (assItemComb.getValue() == "")) {
            Ext.Msg.alert("提示", "请先选择各项参数");
        } else {
            var userCode = session['LOGON.USERCODE'];

            Ext.Ajax.request({
                url: 'dhc.ca.deptdetailreportexe.csp?action=getUser&userCode=' + userCode,
                waitMsg: '正在查询...',
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    var userInfo = jsonData.info;

                    var aaa = encodeURI(encodeURI(userInfo));
                    var tmpMonth = encodeURI(encodeURI(assItemMonsCombo.getRawValue()));
                    //alert(encodeURI(userInfo)+" "+encodeURI(encodeURI(userInfo)));
                    var center = Ext.getCmp('assItem_center_panel');
                    center.remove('first_assItem_center');
                    center.add(new Ext.Panel({

                        id: 'assItem_center',

                        bodyCfg: {
                            tag: 'applet',
                            archive: 'jasperreports-3.5.0-applet.jar,commons-logging-1.0.2.jar,commons-collections-2.1.jar',
                            code: 'EmbeddedViewerApplet.class',
                            codebase: 'http://172.26.201.66:1969/dhccareport/applets',
                            cn: [
								{ tag: 'param', name: 'type', value: 'application/x-java-applet;version=1.2.2' },
								{ tag: 'param', name: 'scriptable', value: 'false' },
								{ tag: 'param', name: 'REPORT_URL', value: '../IncomeItemAssReport?month=' + tmpMonth + '&userInfo=' + aaa + '&monthDr=' + assItemMonsCombo.getValue() + '&deptLayer=7' + '&itemsDr=' + assItemComb.getValue() }
							]
                        }

                    }));
                    center.getLayout().setActiveItem('assItem_center');
                    center.doLayout();
                }
            });
            //-------------------------------------------------------


        }
    }
});
//-------------------------------------
var assItemExcelButton = new Ext.Toolbar.Button({
    text: '生成excel',
    tooltip: '生成excel',
    iconCls: 'add',
    handler: function() {
        if ((assItemMonsCombo.getValue() == "") || (assItemComb.getValue() == "")) {
            Ext.Msg.alert("提示", "请先选择各项参数");
        } else {

            var userCode = session['LOGON.USERCODE'];

            Ext.Ajax.request({
                url: 'dhc.ca.deptdetailreportexe.csp?action=getUser&userCode=' + userCode,
                waitMsg: '正在查询...',
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    var userInfo = jsonData.info;
                    var aaa = encodeURI(encodeURI(userInfo));
                    var tmpMonth = encodeURI(encodeURI(assItemMonsCombo.getRawValue()));
                    //vouchDatasUrl+'?action=itemServe&monthDr='+serveItemMonsCombo.getValue()+'&deptLayer='+serveItemDeptLayerComb.getValue()+'&itemsDr='+serveItemComb.getValue(),
                    location.href = 'http://172.26.201.66:1969/dhccareport/IncomeItemAssReport?month=' + tmpMonth + '&userInfo=' + aaa + '&outType=xls' + '&monthDr=' + assItemMonsCombo.getValue() + '&deptLayer=7' + '&itemsDr=' + assItemComb.getValue();

                }
            });

        }
    }
});
var assItemDeptMain = new Ext.Panel({//表格
    id: 'assItemDeptMain',
    layout: 'border',
    height: 700,
    title: '项目开单统计',
    items: [{
        id: 'assItem_center_panel',
        region: 'center',
        layout: 'card',
        items: [
			{ id: 'first_assItem_center', html: '' }
		]
}],
        tbar: ['核算区间:', assItemMonsCombo, '-',  assItemComb, '-',  assItemCheckButton, '-', assItemExcelButton]
    });

 