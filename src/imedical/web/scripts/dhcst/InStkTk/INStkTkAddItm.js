// /名称: 新增批次（实盘录入就界面调用）
// /描述: 新增批次（实盘录入就界面调用）
// /编写者：yunhaibao
// /编写日期: 2016-02-29
// /GridInput  调用界面的grid
// /CodeInput  调用界面的库存项code的dataIndex
// /RowIndex 调用界面方法句柄，用于反射调用界面参数
function AddItmQuery() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gInclbRowId = ""
    var RowId = "-1"
    var InciDesc = new Ext.form.TextField({
        fieldLabel: '药品名称',
        id: 'InciDesc',
        name: 'InciDesc',
        width: 225,
        emptyText: '别名...',
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
     * 调用药品窗体并返回结果
     */
    function GetPhaOrderInfo3(item, stkgrp) {
        if (item != null && item.length > 0) {
            IncItmBatWindow(item, stkgrp, App_StkTypeCode, InstkLocRowid, "N", 0, "", "", returnInclbInfo);
        }
    }

    /**
     * 返回方法
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
        fieldLabel: '基本数量',
        id: 'InciBUomQty',
        name: 'InciBUomQty',
        width: 100
    })
    var InciPUomQty = new Ext.form.NumberField({
        fieldLabel: '入库数量',
        id: 'InciPUomQty',
        name: 'InciPUomQty',
        width: 100
    })
    var InciExpBat = new Ext.form.TextField({
        fieldLabel: '批号效期',
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
        // 新增按钮
    var addBT = new Ext.Toolbar.Button({
        text: '保存',
        id: 'addBT',
        tooltip: '点击将此批次药品新增到盘点单',
        iconCls: 'page_add',
        handler: function() {
            checkIfExistInstk(); //ext会先执行handler,再执行listeners
            InsertNewInclbToInStk();
        }
    });
    //回传批次后验证该批次是否存在于盘点单中
    function checkIfExistInstk() {
        if (gRowid == "") {
            Msg.info('warning', '盘点单id不存在!')
        }
        /*if (gInclbRowId == "") {
            Msg.info('warning', '批次id不存在!')
            return;
        }*/
        var existflag = tkMakeServerCall("web.DHCST.INStkTk", "CheckInclbExistInInStk", gRowid, gInclbRowId)
        if (existflag == "1") {
            Msg.info('warning', '该批次已存在于当前盘点单中!')
            clearAddItmQuery();
            return;
        }

    }
    //插入盘点单
    function InsertNewInclbToInStk() {
	    var inciDesc = Ext.getCmp("InciDesc").getValue();
        var pqty = Ext.getCmp("InciPUomQty").getValue();
        var bqty = Ext.getCmp("InciBUomQty").getValue();
        if (gInclbRowId == "") {
            Msg.info('warning', '药品批次id不存在!')
            return;
        }
        if (pqty < 0) {
            Msg.info('warning', '入库数量不能小于零!');
            return;
        }
        if (bqty < 0) {
            Msg.info('warning', '基本数量不能小于零!');
            return;
        }
        if ((bqty == "") && (pqty == "")) {
            Msg.info('warning', '实盘数量不能均为空值!');
            return;
        }
        var PhaWin = Ext.getCmp('PhaWindow').getValue();
        var succ = tkMakeServerCall("web.DHCST.INStkTkItmWd", "InsertNewInclbToInStk", gRowid, PhaWin, gInclbRowId, pqty, bqty, session['LOGON.USERID'])
        if (succ == "0") {
            Msg.info('success', '新增成功!')
            clearAddItmQuery();
        } else {
            Msg.info('failure', '新增失败!' + succ)
        }

    }

    //清空方法
    function clearAddItmQuery() {
        Ext.getCmp("InciDesc").setValue("");
        Ext.getCmp("InciExpBat").setValue("");
        Ext.getCmp("InciPUomQty").setValue("");
        Ext.getCmp("InciBUomQty").setValue("");
        Ext.getCmp("InciPUomLabel").setText("");
        Ext.getCmp("InciBUomLabel").setText("");
        gInclbRowId = "";

    }

    // 取消按钮
    var cancelBT = new Ext.Toolbar.Button({
        text: '关闭',
        tooltip: '点击关闭',
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
        title: '新增批次',
        width: 400,
        height: 225,
        layout: 'fit',
        items: [HisListTab]
    });
    window.show();
    InciDesc.focus(true, true);
    window.on('close', function(panel) {});
}