var vouchDatasUrl = 'dhc.ca.incomedatareportexe.csp';
var vouchDatasProxy = new Ext.data.HttpProxy({ url: vouchDatasUrl + '?action=list' });
var monthDr = "";
var itemLevelSets = "";
var deptSetId = "";

var serveMonthsDs = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'code', 'name', 'desc', 'start', 'end', 'dataFinish'])
});
var serveMonsCombo = new Ext.ux.form.LovCombo({
    id: 'serveMonsCombo',
    fieldLabel: '�·�',
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
    emptyText: 'ѡ���·�...',
    editable: false,
    //allowBlank: false,
    anchor: '90%'
});
serveMonsCombo.on("select", function(cmb, rec, id) {

    monthDr = cmb.getValue();
});
var serveItemSetDs = new Ext.data.Store({
    //autoLoad: true,
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['id', 'name'])
});

serveItemSetDs.on('beforeload', function(ds, o) {
    ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.datalevelsetsexe.csp?action=listsub&id=roo', method: 'GET' });
});

var serveItemSetComb = new Ext.form.ComboBox({
    id: 'serveItemSetComb',
    fieldLabel: '���ݷֲ���',
    store: serveItemSetDs,
    valueField: 'id',
    displayField: 'name',
    typeAhead: true,
    pageSize: 10,
    minChars: 1,
    width: 100,
    listWidth: 250,
    triggerAction: 'all',
    emptyText: 'ѡ�����ݷֲ���...',
    allowBlank: false,
    selectOnFocus: true,
    forceSelection: true
});

var serveItemLayerDs = new Ext.data.Store({
    //autoLoad: true,
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['id', 'name'])
});

serveItemSetComb.on("select", function(cmb, rec, id) {
    itemLevelSets = cmb.getValue();
    serveItemLayerComb.setValue("");
    serveItemLayerComb.setRawValue("");
    serveItemLayerDs.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.datalevelsetsexe.csp?action=listsub&id=' + itemLevelSets, method: 'GET' });
    serveItemLayerDs.load({ params: { start: 0, limit: serveItemLayerComb.pageSize} });
});

var serveItemLayerComb = new Ext.form.ComboBox({
    id: 'serveItemLayerComb',
    fieldLabel: '��������',
    store: serveItemLayerDs,
    valueField: 'id',
    displayField: 'name',
    typeAhead: true,
    pageSize: 10,
    minChars: 1,
    width: 100,
    listWidth: 250,
    triggerAction: 'all',
    emptyText: 'ѡ����������...',
    allowBlank: false,
    selectOnFocus: true,
    forceSelection: true
});
//-----------------------------------

var serveDeptSetDs = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['id', 'code', 'name', 'desc', 'remark', 'leaf', 'end', 'active', 'parent', 'uiProvider', 'order', 'recCost', 'hospDr', 'hospName', 'locDr'])
});
var serveDeptSetComb = new Ext.form.ComboBox({
    id: 'serveDeptSetComb',
    fieldLabel: '���ŷֲ���',
    width: 100,
    listWidth: 260,
    allowBlank: false,
    store: serveDeptSetDs,
    valueField: 'id',
    displayField: 'desc',
    triggerAction: 'all',
    emptyText: '���ŷֲ���...',
    pageSize: 10,
    minChars: 1,
    selectOnFocus: true,
    forceSelection: true
});
serveDeptSetDs.on('beforeload', function(ds, o) {
    ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.costdistsetsexe.csp?action=listsub&id=roo&searchField=desc&active=Y&searchValue=' + Ext.getCmp('serveDeptSetComb').getRawValue(), method: 'GET' });

});

serveDeptSetComb.on("select", function(cmb, rec, id) {
    var selectedRow = serveDeptSetDs.data.items[id];
    var order = selectedRow.data["order"];
    deptSetId = selectedRow.data["id"];
    serveDeptLayerComb.setValue("");
    serveDeptLayerComb.setRawValue("");
    serveDeptLayerDs.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.costdistsetsexe.csp?action=listsub&id=' + deptSetId + '&searchField=desc&active=Y&searchValue=' + Ext.getCmp('serveDeptLayerComb').getRawValue(), method: 'GET' });
    serveDeptLayerDs.load({ params: { start: 0, limit: serveDeptLayerComb.pageSize} });
});
var serveDeptLayerDs = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['id', 'code', 'name', 'desc', 'remark', 'leaf', 'end', 'active', 'parent', 'uiProvider', 'order', 'recCost', 'hospDr', 'hospName', 'locDr'])
});
var serveDeptLayerComb = new Ext.form.ComboBox({
    id: 'serveDeptLayerComb',
    fieldLabel: '��������',
    width: 100,
    listWidth: 260,
    allowBlank: false,
    store: serveDeptLayerDs,
    valueField: 'id',
    displayField: 'desc',
    triggerAction: 'all',
    emptyText: '��������...',
    pageSize: 10,
    minChars: 1,
    selectOnFocus: true,
    forceSelection: true
});
serveDeptLayerComb.on("select", function(cmb, rec, id) {
    var selectedRow = serveDeptLayerDs.data.items[id];
    var order = selectedRow.data["order"];
    var setId = selectedRow.data["id"];
    serveDeptCombo.setValue("");
    serveDeptCombo.setRawValue("");
    //serveDeptComboDs.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.incomedatareportexe.csp?action=depts&searchValue=' + Ext.getCmp('serveDeptCombo').getRawValue() + '&order=' + setId + '&deptSetDr=' + deptSetId, method: 'GET' });
    serveDeptComboDs.load({ params: { start: 0, limit: deptCombo.pageSize} });
});
//---------------------------------------------------------

/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
var serveDeptSetDs = new Ext.data.SimpleStore({
		fields:['name','id'],
		data:[['0104-ҽ�Ƽ��������','6'],
					['0105-ֱ��ҽ�ƿ���','7']]
	});

var serveDeptSetCombo = new Ext.form.ComboBox({
    id: 'serveDeptSetCombo',
    fieldLabel: '��������',
    store: serveDeptSetDs,
    valueField: 'id',
    displayField: 'name',
    typeAhead: true,
    pageSize: 10,
    minChars: 1,
    mode:'local',
    width: 100,
    listWidth: 250,
    triggerAction: 'all',
    emptyText: 'ѡ����...',
    allowBlank: false,
    selectOnFocus: true,
    forceSelection: true
});

serveDeptSetCombo.on("select", function(cmb, rec, id) {
    serveDeptCombo.setValue("");
    serveDeptCombo.setRawValue("");
    serveDeptComboDs.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.incomedatareportexe.csp?action=depts&searchValue=' + Ext.getCmp('serveDeptCombo').getRawValue() + '&order=' + serveDeptSetCombo.getValue() + '&deptSetDr=' + 1 + '&searchValue=' + Ext.getCmp('serveDeptCombo').getRawValue(), method: 'GET' });
		serveDeptComboDs.load({ params: { start: 0, limit: 10} });
});

var serveDeptComboDs = new Ext.data.Store({
    autoLoad: true,
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['deptDr', 'deptDesc'])
});

var serveDeptCombo = new Ext.form.ComboBox({
    id: 'serveDeptCombo',
    fieldLabel: '����',
    store: serveDeptComboDs,
    valueField: 'deptDr',
    displayField: 'deptDesc',
    typeAhead: true,
    pageSize: 10,
    minChars: 1,
    width: 100,
    listWidth: 250,
    triggerAction: 'all',
    emptyText: 'ѡ����...',
    allowBlank: false,
    selectOnFocus: true,
    forceSelection: true
});
serveDeptComboDs.on('beforeload', function(ds, o) {
    var setId = serveDeptLayerComb.getValue();
    ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.incomedatareportexe.csp?action=depts&searchValue=' + Ext.getCmp('serveDeptCombo').getRawValue() + '&order=' + serveDeptSetCombo.getValue() + '&deptSetDr=' + 1 + '&searchValue=' + Ext.getCmp('serveDeptCombo').getRawValue(), method: 'GET' });
});

//-------------------------------------
var serveCheckButton = new Ext.Toolbar.Button({
    text: '�鿴',
    tooltip: '�鿴',
    iconCls: 'add',
    handler: function() {
        if ((serveMonsCombo.getValue() == "") || (serveDeptCombo.getValue() == "") ) {
            Ext.Msg.alert("��ʾ", "����ѡ��������");
        } else {
            var userCode = session['LOGON.USERCODE'];

            Ext.Ajax.request({
                url: 'dhc.ca.deptdetailreportexe.csp?action=getUser&userCode=' + userCode,
                waitMsg: '���ڲ�ѯ...',
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    var userInfo = jsonData.info;

                    var aaa = encodeURI(encodeURI(userInfo));
                    var tmpMonth = encodeURI(encodeURI(serveMonsCombo.getRawValue()));
                    //alert(encodeURI(userInfo)+" "+encodeURI(encodeURI(userInfo)));
                    var center = Ext.getCmp('serve_center_panel');
                    center.remove('first_serve_center');
                    center.add(new Ext.Panel({

                        id: 'serve_center',

                        bodyCfg: {
                            tag: 'applet',
                            archive: 'jasperreports-3.5.0-applet.jar,commons-logging-1.0.2.jar,commons-collections-2.1.jar',
                            code: 'EmbeddedViewerApplet.class',
                            codebase: 'http://172.26.201.66:1969/dhccareport/applets',
                            cn: [
								{ tag: 'param', name: 'type', value: 'application/x-java-applet;version=1.2.2' },
								{ tag: 'param', name: 'scriptable', value: 'false' },
								{ tag: 'param', name: 'REPORT_URL', value: '../IncomeServeDeptReport?month=' + tmpMonth + '&userInfo=' + aaa + '&monthDr=' + serveMonsCombo.getValue() + '&itemLayer=23' +  '&deptDr=' + serveDeptCombo.getValue() }
							]
                        }

                    }));
                    center.getLayout().setActiveItem('serve_center');
                    center.doLayout();
                }
            });


        }
    }
});
//-------------------------------------
var serveDeptExcelButton = new Ext.Toolbar.Button({
    text: '����excel',
    tooltip: '����excel',
    iconCls: 'add',
    handler: function() {
        if ((serveMonsCombo.getValue() == "") || (serveDeptCombo.getValue() == "") ) {
            Ext.Msg.alert("��ʾ", "����ѡ��������");
        } else {
            var userCode = session['LOGON.USERCODE'];

            Ext.Ajax.request({
                url: 'dhc.ca.deptdetailreportexe.csp?action=getUser&userCode=' + userCode,
                waitMsg: '���ڲ�ѯ...',
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    var userInfo = jsonData.info;
                    var aaa = encodeURI(encodeURI(userInfo));
                    var tmpMonth = encodeURI(encodeURI(serveMonsCombo.getRawValue()));
                    //vouchDatasUrl+'?action=itemServe&monthDr='+serveItemMonsCombo.getValue()+'&deptLayer='+serveItemDeptLayerComb.getValue()+'&itemsDr='+serveItemComb.getValue(),
                    location.href = 'http://172.26.201.66:1969/dhccareport/IncomeServeDeptReport?month=' + tmpMonth + '&userInfo=' + aaa + '&outType=xls' + '&monthDr=' + serveMonsCombo.getValue() + '&itemLayer=23' +  '&deptDr=' + serveDeptCombo.getValue();

                }
            });

        }
    }
});
var serveDeptMain = new Ext.Panel({//���
    id: 'serveDeptMain',
    layout: 'border',
    height: 700,
    title: '���ҽ���ͳ��',
    items: [{
        id: 'serve_center_panel',
        region: 'center',
        layout: 'card',
        items: [
			{ id: 'first_serve_center', html: '' }
		]
}],
        tbar: ['��������:', serveMonsCombo, '-',serveDeptSetCombo,'-', serveDeptCombo, '-', serveCheckButton, '-', serveDeptExcelButton]
    });

 