var vouchDatasUrl = 'dhc.ca.incomedatareportexe.csp';
var vouchDatasProxy = new Ext.data.HttpProxy({ url: vouchDatasUrl + '?action=list' });
var monthDr = "";
var itemLevelSets = "";
var deptSetId = "";

var monthsDs = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'code', 'name', 'desc', 'start', 'end', 'dataFinish'])
});
var monsCombo = new Ext.ux.form.LovCombo({
    id: 'monsCombo',
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
monsCombo.on("select", function(cmb, rec, id) {

    monthDr = cmb.getValue();
});
var itemSetDs = new Ext.data.Store({
    //autoLoad: true,
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['id', 'name'])
});

itemSetDs.on('beforeload', function(ds, o) {
    ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.datalevelsetsexe.csp?action=listsub&id=roo', method: 'GET' });
});

var itemSetComb = new Ext.form.ComboBox({
    id: 'itemSetComb',
    fieldLabel: '数据分层套',
    store: itemSetDs,
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

var itemLayerDs = new Ext.data.Store({
    //autoLoad: true,
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['id', 'name'])
});

itemSetComb.on("select", function(cmb, rec, id) {
    itemLevelSets = cmb.getValue();
    itemLayerComb.setValue("");
    itemLayerComb.setRawValue("");
    itemLayerDs.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.datalevelsetsexe.csp?action=listsub&id=' + itemLevelSets, method: 'GET' });
    itemLayerDs.load({ params: { start: 0, limit: itemLayerComb.pageSize} });
});

var itemLayerComb = new Ext.form.ComboBox({
    id: 'itemLayerComb',
    fieldLabel: '收入类型',
    store: itemLayerDs,
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

var deptSetDs = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['id', 'code', 'name', 'desc', 'remark', 'leaf', 'end', 'active', 'parent', 'uiProvider', 'order', 'recCost', 'hospDr', 'hospName', 'locDr'])
});
var deptSetComb = new Ext.form.ComboBox({
    id: 'deptSetComb',
    fieldLabel: '部门分层套',
    width: 100,
    listWidth: 260,
    allowBlank: false,
    store: deptSetDs,
    valueField: 'id',
    displayField: 'desc',
    triggerAction: 'all',
    emptyText: '部门分层套...',
    pageSize: 10,
    minChars: 1,
    selectOnFocus: true,
    forceSelection: true
});
deptSetDs.on('beforeload', function(ds, o) {
    ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.costdistsetsexe.csp?action=listsub&id=roo&searchField=desc&active=Y&searchValue=' + Ext.getCmp('deptSetComb').getRawValue(), method: 'GET' });

});

deptSetComb.on("select", function(cmb, rec, id) {
    var selectedRow = deptSetDs.data.items[id];
    var order = selectedRow.data["order"];
    deptSetId = selectedRow.data["id"];
    deptLayerComb.setValue("");
    deptLayerComb.setRawValue("");
    deptLayerDs.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.costdistsetsexe.csp?action=listsub&id=' + deptSetId + '&searchField=desc&active=Y&searchValue=' + Ext.getCmp('deptLayerComb').getRawValue(), method: 'GET' });
    deptLayerDs.load({ params: { start: 0, limit: deptLayerComb.pageSize} });
});
var deptLayerDs = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['id', 'code', 'name', 'desc', 'remark', 'leaf', 'end', 'active', 'parent', 'uiProvider', 'order', 'recCost', 'hospDr', 'hospName', 'locDr'])
});
var deptLayerComb = new Ext.form.ComboBox({
    id: 'deptLayerComb',
    fieldLabel: '科室属性',
    width: 100,
    listWidth: 260,
    allowBlank: false,
    store: deptLayerDs,
    valueField: 'id',
    displayField: 'desc',
    triggerAction: 'all',
    emptyText: '科室属性...',
    pageSize: 10,
    minChars: 1,
    selectOnFocus: true,
    forceSelection: true
});
deptLayerComb.on("select", function(cmb, rec, id) {
    var selectedRow = deptLayerDs.data.items[id];
    var order = selectedRow.data["order"];
    var setId = selectedRow.data["id"];
    deptCombo.setValue("");
    deptCombo.setRawValue("");
    //deptComboDs.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.incomedatareportexe.csp?action=depts&searchValue=' + Ext.getCmp('deptCombo').getRawValue() + '&order=' + setId + '&deptSetDr=' + deptSetId, method: 'GET' });
    deptComboDs.load({ params: { start: 0, limit: deptCombo.pageSize} });
});
//---------------------------------------------------------
var deptComboDs = new Ext.data.Store({
    //autoLoad: true,
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['deptDr', 'deptDesc'])
});

var deptCombo = new Ext.form.ComboBox({
    id: 'deptCombo',
    fieldLabel: '部门',
    store: deptComboDs,
    valueField: 'deptDr',
    displayField: 'deptDesc',
    typeAhead: true,
    pageSize: 10,
    minChars: 1,
    width: 100,
    listWidth: 250,
    triggerAction: 'all',
    emptyText: '选择部门...',
    allowBlank: false,
    selectOnFocus: true,
    forceSelection: true
});
deptComboDs.on('beforeload', function(ds, o) {
    var setId = deptLayerComb.getValue();
    ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.incomedatareportexe.csp?action=depts&order=' + 7 + '&deptSetDr=' + 1 + '&searchValue=' + Ext.getCmp('deptCombo').getRawValue(), method: 'GET' });
});


//-------------------------------------
var checkButton = new Ext.Toolbar.Button({
    text: '查看',
    tooltip: '查看',
    iconCls: 'add',
    handler: function() {
        if ((monsCombo.getValue() == "") || (deptCombo.getValue() == "") ) {
            Ext.Msg.alert("提示", "请先选择各项参数");
        } else {
            //-----------------------------------------------------------------------------------------------------
            var userCode = session['LOGON.USERCODE'];
            Ext.Ajax.request({
                url: 'dhc.ca.deptdetailreportexe.csp?action=getUser&userCode=' + userCode,
                waitMsg: '正在查询...',
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    var userInfo = jsonData.info;

                    var aaa = encodeURI(encodeURI(userInfo));
                    var tmpMonth = encodeURI(encodeURI(monsCombo.getRawValue()));
                    //alert(encodeURI(userInfo)+" "+encodeURI(encodeURI(userInfo)));
                    var center = Ext.getCmp('center_panel');
                    center.remove('first_center');
                    center.add(new Ext.Panel({

                        id: 'second_center',

                        bodyCfg: {
                            tag: 'applet',
                            archive: 'jasperreports-3.5.0-applet.jar,commons-logging-1.0.2.jar,commons-collections-2.1.jar',
                            code: 'EmbeddedViewerApplet.class',
                            codebase: 'http://172.26.201.66:1969/dhccareport/applets',
                            cn: [
								{ tag: 'param', name: 'type', value: 'application/x-java-applet;version=1.2.2' },
								{ tag: 'param', name: 'scriptable', value: 'false' },
								//{ tag: 'param', name: 'REPORT_URL', value: '../IncomeDetialReport?month=' + tmpMonth + '&userInfo=' + aaa + '&monthDr=' + monsCombo.getValue() + '&itemLayer=' + itemLayerComb.getValue() + '&deptDr=' + deptCombo.getValue() }
								{ tag: 'param', name: 'REPORT_URL', value: '../IncomeDetialReport?month=' + tmpMonth + '&userInfo=' + aaa + '&monthDr=' + monsCombo.getValue() + '&itemLayer=23'  + '&deptDr=' + deptCombo.getValue() }
							]
                        }

                    }));
                    center.getLayout().setActiveItem('second_center');
                    center.doLayout();
                }
            });


        }
    }
});
//-------------------------------------
var ExcelButton = new Ext.Toolbar.Button({
    text: '生成excel',
    tooltip: '生成excel',
    iconCls: 'add',
    handler: function() {
        if ((monsCombo.getValue() == "") || (deptCombo.getValue() == "") || (itemLayerComb.getValue() == "")) {
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
                    var tmpMonth = encodeURI(encodeURI(monsCombo.getRawValue()));
                    //vouchDatasUrl+'?action=itemServe&monthDr='+serveItemMonsCombo.getValue()+'&deptLayer='+serveItemDeptLayerComb.getValue()+'&itemsDr='+serveItemComb.getValue(),
                    location.href = 'http://172.26.201.66:1969/dhccareport/IncomeDetialReport?month=' + tmpMonth + '&userInfo=' + aaa + '&outType=xls' + '&monthDr=' + monsCombo.getValue() + '&itemLayer=23' + '&deptDr=' + deptCombo.getValue();

                }
            });

        }
    }
});
var vouchDatasMain = new Ext.Panel({//表格
    id: 'detailReport',
    layout: 'border',
    height: 700,
    title: '科室开单统计',
    items: [{
        id: 'center_panel',
        region: 'center',
        layout: 'card',
        items: [
			{ id: 'first_center', html: '' }
		]
}],
        tbar: ['核算区间:', monsCombo, '-',deptCombo, '-', checkButton, '-', ExcelButton]
    });

 