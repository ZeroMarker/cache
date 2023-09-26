// /����: �������Σ�ʵ��¼��ͽ�����ã�
// /����: �������Σ�ʵ��¼��ͽ�����ã�
// /��д�ߣ�yunhaibao
// /��д����: 2016-02-29
// /GridInput  ���ý����grid
// /CodeInput  ���ý���Ŀ����code��dataIndex
// /RowIndex ���ý��淽����������ڷ�����ý������
function AddItmQuery() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gInclbRowId = ""
    var RowId = "-1"
    var InciDesc = new Ext.form.TextField({
        fieldLabel: 'ҩƷ����',
        id: 'InciDesc',
        name: 'InciDesc',
        width: 225,
        emptyText: '����...',
        selectOnfocus: true,
        listeners: {
            specialkey: function(field, e) {
                var keyCode = e.getKey();
                if (keyCode == Ext.EventObject.ENTER) {
                    var stkgrp = Ext.getCmp("StkGrpType").getValue();
                    GetPhaOrderInfo3(field.getValue(), stkgrp);
                }
            }
        }
    });

    /**
     * ����ҩƷ���岢���ؽ��
     */
    function GetPhaOrderInfo3(item, stkgrp) {
        if (item != null && item.length > 0) {
            IncItmBatWindow(item, stkgrp, App_StkTypeCode, InstkLocRowid, "N", 0, "", "", returnInclbInfo);
        }
    }

    /**
     * ���ط���
     */
    function returnInclbInfo(record) {
        if (record == null || record == "") {
            return;
        }
        Ext.getCmp("InciDesc").setValue(record.get("InciDesc"));
        Ext.getCmp("InciExpBat").setValue(record.get("BatExp"));
        Ext.getCmp("InciPUomLabel").setText(record.get("PurUomDesc"));
        Ext.getCmp("InciBUomLabel").setText(record.get("BUomDesc"));
        gInclbRowId = record.get("Inclb");
        checkIfExistInstk();
    }
    var InciBUomQty = new Ext.form.NumberField({
        fieldLabel: '��������',
        id: 'InciBUomQty',
        name: 'InciBUomQty',
        width: 100
    })
    var InciPUomQty = new Ext.form.NumberField({
        fieldLabel: '�������',
        id: 'InciPUomQty',
        name: 'InciPUomQty',
        width: 100
    })
    var InciExpBat = new Ext.form.TextField({
        fieldLabel: '����Ч��',
        id: 'InciExpBat',
        name: 'InciExpBat',
        disabled:true,
        width: 225
    })
    var InciPUomLabel = new Ext.form.Label({
        text: '',
        id: 'InciPUomLabel',
        align: 'center'
    })
    var InciBUomLabel = new Ext.form.Label({
            text: '',
            id: 'InciBUomLabel',
            align: 'center'
        })
        // ������ť
    var addBT = new Ext.Toolbar.Button({
        text: '����',
        id: 'addBT',
        tooltip: '�����������ҩƷ�������̵㵥',
        iconCls: 'page_add',
        handler: function() {
            checkIfExistInstk(); //ext����ִ��handler,��ִ��listeners
            InsertNewInclbToInStk();
        }
    });
    //�ش����κ���֤�������Ƿ�������̵㵥��
    function checkIfExistInstk() {
        if (gRowid == "") {
            Msg.info('warning', '�̵㵥id������!')
        }
        /*if (gInclbRowId == "") {
            Msg.info('warning', '����id������!')
            return;
        }*/
        var existflag = tkMakeServerCall("web.DHCST.INStkTk", "CheckInclbExistInInStk", gRowid, gInclbRowId)
        if (existflag == "1") {
            Msg.info('warning', '�������Ѵ����ڵ�ǰ�̵㵥��!')
            clearAddItmQuery();
            return;
        }

    }
    //�����̵㵥
    function InsertNewInclbToInStk() {
	    var inciDesc = Ext.getCmp("InciDesc").getValue();
        var pqty = Ext.getCmp("InciPUomQty").getValue();
        var bqty = Ext.getCmp("InciBUomQty").getValue();
        if (gInclbRowId == "") {
            Msg.info('warning', 'ҩƷ����id������!')
            return;
        }
        if (pqty < 0) {
            Msg.info('warning', '�����������С����!');
            return;
        }
        if (bqty < 0) {
            Msg.info('warning', '������������С����!');
            return;
        }
        if ((bqty == "") && (pqty == "")) {
            Msg.info('warning', 'ʵ���������ܾ�Ϊ��ֵ!');
            return;
        }
        var PhaWin = Ext.getCmp('PhaWindow').getValue();
        var succ = tkMakeServerCall("web.DHCST.INStkTkItmWd", "InsertNewInclbToInStk", gRowid, PhaWin, gInclbRowId, pqty, bqty, session['LOGON.USERID'])
        if (succ == "0") {
            Msg.info('success', '�����ɹ�!')
            clearAddItmQuery();
        } else {
            Msg.info('failure', '����ʧ��!' + succ)
        }

    }

    //��շ���
    function clearAddItmQuery() {
        Ext.getCmp("InciDesc").setValue("");
        Ext.getCmp("InciExpBat").setValue("");
        Ext.getCmp("InciPUomQty").setValue("");
        Ext.getCmp("InciBUomQty").setValue("");
        Ext.getCmp("InciPUomLabel").setText("");
        Ext.getCmp("InciBUomLabel").setText("");
        gInclbRowId = "";

    }

    // ȡ����ť
    var cancelBT = new Ext.Toolbar.Button({
        text: '�ر�',
        tooltip: '����ر�',
        iconCls: 'page_close',
        handler: function() {
            window.close();
        }
    });

    var HisListTab = new Ext.form.FormPanel({
        labelwidth: 30,
        region: 'center',
        labelAlign: 'right',
        frame: true,
        autoScroll: true,
        bbar: [addBT, cancelBT],
        defaults: { style: 'padding:5px,0px,0px,0px', border: true },
        items: [{
            layout: 'column',
            xtype: 'fieldset',
            defaults: { border: false },
            items: [{
                columnWidth: 1,
                labelWidth: 60,
                xtype: 'fieldset',
                defaultType: 'textfield',
                border: false,
                items: [InciDesc, InciExpBat, { xtype: 'compositefield', items: [InciPUomQty, InciPUomLabel] }, { xtype: 'compositefield', items: [InciBUomQty, InciBUomLabel] }]
            }]
        }]
    });

    var window = new Ext.Window({
        title: '��������',
        width: 400,
        height: 225,
        layout: 'fit',
        items: [HisListTab]
    });
    window.show();
    InciDesc.focus(true, true);
    window.on('close', function(panel) {});
}