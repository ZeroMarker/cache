var vouchDatasUrl = 'dhc.ca.incomedatareportexe.csp';
var vouchDatasProxy = new Ext.data.HttpProxy({ url: vouchDatasUrl + '?action=list' });
var monthDr = "";
var itemLevelSets = "";
var deptSetId = "";

var serveItemMonthsDs = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'code', 'name', 'desc', 'start', 'end', 'dataFinish'])
});
var serveItemMonsCombo = new Ext.ux.form.LovCombo({
    id: 'serveItemMonsCombo',
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
serveItemMonsCombo.on("select", function(cmb, rec, id) {

    monthDr = cmb.getValue();
});
var serveItemItemSetDs = new Ext.data.Store({
    //autoLoad: true,
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['id', 'name'])
});

serveItemItemSetDs.on('beforeload', function(ds, o) {
    ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.datalevelsetsexe.csp?action=listsub&id=roo', method: 'GET' });
});

var serveItemItemSetComb = new Ext.form.ComboBox({
    id: 'serveItemItemSetComb',
    fieldLabel: '数据分层套',
    store: serveItemItemSetDs,
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

var serveItemItemLayerDs = new Ext.data.Store({
    //autoLoad: true,
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['id', 'name'])
});

serveItemItemSetComb.on("select", function(cmb, rec, id) {
    itemLevelSets = cmb.getValue();
    serveItemItemLayerComb.setValue("");
    serveItemItemLayerComb.setRawValue("");
    serveItemItemLayerDs.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.datalevelsetsexe.csp?action=listsub&id=' + itemLevelSets, method: 'GET' });
    serveItemItemLayerDs.load({ params: { start: 0, limit: serveItemItemLayerComb.pageSize} });
});

var serveItemItemLayerComb = new Ext.form.ComboBox({
    id: 'serveItemItemLayerComb',
    fieldLabel: '收入类型',
    store: serveItemItemLayerDs,
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

var serveItemDeptSetDs = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['id', 'code', 'name', 'desc', 'remark', 'leaf', 'end', 'active', 'parent', 'uiProvider', 'order', 'recCost', 'hospDr', 'hospName', 'locDr'])
});
var serveItemDeptSetComb = new Ext.form.ComboBox({
    id: 'serveItemDeptSetComb',
    fieldLabel: '部门分层套',
    width: 100,
    listWidth: 260,
    allowBlank: false,
    store: serveItemDeptSetDs,
    valueField: 'id',
    displayField: 'desc',
    triggerAction: 'all',
    emptyText: '部门分层套...',
    pageSize: 10,
    minChars: 1,
    selectOnFocus: true,
    forceSelection: true
});
serveItemDeptSetDs.on('beforeload', function(ds, o) {
    ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.costdistsetsexe.csp?action=listsub&id=roo&searchField=desc&active=Y&searchValue=' + Ext.getCmp('serveItemDeptSetComb').getRawValue(), method: 'GET' });

});

serveItemDeptSetComb.on("select", function(cmb, rec, id) {
    var selectedRow = serveItemDeptSetDs.data.items[id];
    var order = selectedRow.data["order"];
    deptSetId = selectedRow.data["id"];
    serveItemDeptLayerComb.setValue("");
    serveItemDeptLayerComb.setRawValue("");
    serveItemDeptLayerDs.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.costdistsetsexe.csp?action=listsub&id=' + deptSetId + '&searchField=desc&active=Y&searchValue=' + Ext.getCmp('serveItemDeptLayerComb').getRawValue(), method: 'GET' });
    serveItemDeptLayerDs.load({ params: { start: 0, limit: serveItemDeptLayerComb.pageSize} });
});
//var serveItemDeptLayerDs = new Ext.data.Store({
//    proxy: "",
//    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['id', 'code', 'name', 'desc', 'remark', 'leaf', 'end', 'active', 'parent', 'uiProvider', 'order', 'recCost', 'hospDr', 'hospName', 'locDr'])
//});
//var serveItemDeptLayerComb = new Ext.form.ComboBox({
//    id: 'serveItemDeptLayerComb',
//    fieldLabel: '科室属性',
//    width: 100,
//    listWidth: 260,
//    allowBlank: false,
//    store: serveItemDeptLayerDs,
//    valueField: 'id',
//    displayField: 'desc',
//    triggerAction: 'all',
//    emptyText: '科室属性...',
//    pageSize: 10,
//    minChars: 1,
//    selectOnFocus: true,
//    forceSelection: true
//});

var serveDeptSetDs = new Ext.data.SimpleStore({             
		fields:['name','id'],                                   
		data:[['0104-医疗技术类科室','6'],                      
					['0105-直接医疗科室','7']]                        
	});                                                       
                                                            
var serveDeptSetCombo = new Ext.form.ComboBox({             
    id: 'serveDeptSetCombo',                                
    fieldLabel: '科室属性',                                 
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
    emptyText: '选择部门...',                               
    allowBlank: false,                                      
    selectOnFocus: true,                                    
    forceSelection: true                                    
});           
var tmpvalue='';

serveDeptSetCombo.on("select", function(cmb, rec, id) {
    	//alert(cmb.getValue())
    	tmpvalue=cmb.getValue();
    });                                              

var serveItemExcelButton = new Ext.Toolbar.Button({
    text: '生成excel',
    tooltip: '生成excel',
    iconCls: 'add',
    handler: function() {
        if ((serveItemMonsCombo.getValue() == "") || (tmpvalue == "") || (serveItemComb.getValue() == "")) {
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
                    var tmpMonth = encodeURI(encodeURI(serveItemMonsCombo.getRawValue()));
                    //vouchDatasUrl+'?action=itemServe&monthDr='+serveItemMonsCombo.getValue()+'&deptLayer='+serveItemDeptLayerComb.getValue()+'&itemsDr='+serveItemComb.getValue(),
                    location.href = 'http://172.26.201.66:1969/dhccareport/IncomeItemServeReport?month=' + tmpMonth + '&deptLayer=' + serveDeptSetCombo.getValue() + '&itemsDr=' + serveItemComb.getValue() + '&userInfo=' + aaa + '&outType=xls'+ '&monthDr=' + serveItemMonsCombo.getValue();

                }
            });

        }
    }
});
//---------------------------------------------------------
serveItemItemLayerComb.on("select", function(cmb, rec, id) {
    serveItemComb.setValue("");
    serveItemComb.setRawValue("");
    serveItemDs.load({ params: { start: 0, limit: serveItemComb.pageSize, node: cmb.getValue()} });
})

var serveItemDs = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['itemDr', 'itemDesc'])
});
var serveItemComb = new Ext.form.ComboBox({
    id: 'serveItemComb',
    fieldLabel: '项目',
    width: 100,
    listWidth: 260,
    allowBlank: true,
    store: serveItemDs,
    valueField: 'itemDr',
    displayField: 'itemDesc',
    triggerAction: 'all',
    emptyText: '选择项目...',
    pageSize: 10,
    minChars: 1,
    selectOnFocus: true,
    forceSelection: true
});

serveItemDs.on('beforeload', function(ds, o) {
    ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.incomedatareportexe.csp?action=items&searchValue=' + Ext.getCmp('serveItemComb').getRawValue() + '&node=23' , method: 'GET' });
});


//-------------------------------------
var serveItemCheckButton = new Ext.Toolbar.Button({
    text: '查看',
    tooltip: '查看',
    iconCls: 'add',
    handler: function() {
        if ((serveItemMonsCombo.getValue() == "") || (tmpvalue == "") || (serveItemComb.getValue() == "")) {
            Ext.Msg.alert("提示", "请先选择各项参数");
            //alert(serveDeptSetCombo.getValue()+"a"+serveItemComb.getValue() );
        } else {
            var userCode = session['LOGON.USERCODE'];

            Ext.Ajax.request({
                url: 'dhc.ca.deptdetailreportexe.csp?action=getUser&userCode=' + userCode,
                waitMsg: '正在查询...',
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    var userInfo = jsonData.info;

                    var aaa = encodeURI(encodeURI(userInfo));
                    var tmpMonth = encodeURI(encodeURI(serveItemMonsCombo.getRawValue()));
                    //alert(encodeURI(userInfo)+" "+encodeURI(encodeURI(userInfo)));
                    var center = Ext.getCmp('serveItem_center_panel');
                    center.remove('first_serveItem_center');
                    center.add(new Ext.Panel({

                        id: 'serveItem_center',

                        bodyCfg: {
                            tag: 'applet',
                            archive: 'jasperreports-3.5.0-applet.jar,commons-logging-1.0.2.jar,commons-collections-2.1.jar',
                            code: 'EmbeddedViewerApplet.class',
                            codebase: 'http://172.26.201.66:1969/dhccareport/applets',
                            cn: [
								{ tag: 'param', name: 'type', value: 'application/x-java-applet;version=1.2.2' },
								{ tag: 'param', name: 'scriptable', value: 'false' },
								{ tag: 'param', name: 'REPORT_URL', value: '../IncomeItemServeReport?month=' + tmpMonth + '&userInfo=' + aaa + '&monthDr=' + serveItemMonsCombo.getValue() + '&deptLayer=' + serveDeptSetCombo.getValue() + '&itemsDr=' + serveItemComb.getValue() }
							]
                        }

                    }));
                    center.getLayout().setActiveItem('serveItem_center');
                    center.doLayout();
                }
            });
            //-------------------------------------------------------


        }
    }
});
//-------------------------------------

var serveItemDeptMain = new Ext.Panel({//表格
    id: 'serveItemDeptMain',
    layout: 'border',
    height: 700,
    title: '项目接收统计',
    items: [{
        id: 'serveItem_center_panel',
        region: 'center',
        layout: 'card',
        items: [
			{ id: 'first_serveItem_center', html: '' }
		]
}],
        tbar: ['核算区间:', serveItemMonsCombo, '-',  serveItemComb, '-', serveDeptSetCombo, '-', serveItemCheckButton, '-', serveItemExcelButton]
    });

 