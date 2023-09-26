
examinMain = function(dataStore, grid, pagingTool){

    var rowObj = grid.getSelections();
    var len = rowObj.length;
    var repdr = "";
    var rowid = "";
    var repname = "";
    var monthDr = "";
    var active = "";
    if (len < 1) {
        Ext.Msg.show({
            title: 'ע��',
            msg: '��ѡ��ɱ���̯��!',
            buttons: Ext.Msg.OK,
            icon: Ext.MessageBox.WARNING
        });
        return;
    }
    else {
        active = rowObj[0].get("active");
        rowid = rowObj[0].get("rowid");
        repdr = rowObj[0].get("deptSetDr");
        repname = rowObj[0].get("deptSetName");
    }
    if (active != "Y") {
        Ext.Msg.show({
            title: 'ע��',
            msg: '����Ϊ��Ч���ݷ�̯!',
            buttons: Ext.Msg.OK,
            icon: Ext.MessageBox.WARNING
        });
        return;
    }
    
    var monthsDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({
            totalProperty: "results",
            root: 'rows'
        }, ['rowid', 'code', 'name', 'desc', 'start', 'end', 'dataFinish'])
    });
    var months = new Ext.form.ComboBox({
        id: 'months',
        fieldLabel: '��������',
        width: 100,
        listWidth: 260,
        allowBlank: false,
        store: monthsDs,
        //readOnly:true,
        valueField: 'rowid',
        displayField: 'name',
        triggerAction: 'all',
        emptyText: 'ѡ���������...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });
    monthsDs.on('beforeload', function(ds, o){
        ds.proxy = new Ext.data.HttpProxy({
            url: 'dhc.ca.vouchdatasexe.csp?action=months&searchValue=' + Ext.getCmp('months').getRawValue(),
            method: 'GET'
        });
    });
    months.on('select', function(combo, record, index){
        monthDr = combo.getValue();
    });
    var window = new Ext.Window({
        title: '��̯���',
        width: 300,
        height: 100,
        layout: 'fit',
        plain: true,
        modal: true,
        bodyStyle: 'padding:5px;',
        buttonAlign: 'center',
        items: [months],
        buttons: [{
            text: '�������',
            handler: function(){
                if (months.getValue() == "") {
                    Ext.Msg.show({
                        title: 'ע��',
                        msg: '��ѡ���������!',
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.WARNING
                    });
                    return;
                }
                //alert(rowid)
                Ext.Ajax.request({
                    url: costDistSetsUrl + '?action=examination&monthDr=' + monthDr + '&costSetsDr=' + rowid,
                    waitMsg: '������...',
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
                            Ext.Msg.show({
                                title: '�ɹ�!',
                                msg: '���ݼ��ɹ�!',
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.INFO
                            });
                        }
                        else {
                            var message = "";
                            message = jsonData.info;
                            var arrays = message.split(",");
                            if (arrays[0] != 2) {
                                Ext.Msg.show({
                                    title: '����',
                                    msg: arrays[1],
                                    buttons: Ext.Msg.OK,
                                    icon: Ext.MessageBox.ERROR
                                });
                            }else{
								examinIncomeFun(monthDr)
							}
                        }
                    },
                    scope: this
                });
                window.close();
            }
        }, {
            text: 'ȡ��',
            handler: function(){
                window.close();
            }
        }]
    });
    
    window.show();
};
