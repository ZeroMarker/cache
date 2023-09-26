var unitsUrl = 'dhcpha.auditlocaction.csp';
var comwidth = 200;
var ruleformwd = 800;
var HospId = session['LOGON.HOSPID'];
Ext.onReady(function () {
    var logonloc = session['LOGON.CTLOCID'];

    Ext.QuickTips.init(); // 浮动信息提示

    Ext.Ajax.timeout = 900000;

    ///药房
    var ComBoPhaLocDs = new Ext.data.Store({
        autoLoad: true,
        proxy: new Ext.data.HttpProxy({
            url: unitsUrl + '?action=GetPhaLocDs&logonloc=' + logonloc,
            method: 'POST'
        }),
        reader: new Ext.data.JsonReader({ totalProperty: 'results', root: 'rows', id: 'phalocdr' }, ['phalocdesc', 'phalocdr'])
    });

    var PhaLocComBoc = new Ext.form.ComboBox({
        store: ComBoPhaLocDs,
        displayField: 'phalocdesc',
        queryMode: 'remote',
        width: comwidth,
        id: 'PhaLocCmb',
        emptyText: '',
        valueField: 'phalocdr',
        emptyText: '请选择药房...',
        valueNotFoundText: '',
        queryParam: 'combotext',
        minChars: 0
    });

    ///科室

    var ComBoOrdLocDs = new Ext.data.Store({
        autoLoad: true,
        proxy: new Ext.data.HttpProxy({
            url: unitsUrl + '?action=GetOrdLocDs&logonloc=' + logonloc,
            method: 'POST'
        }),
        reader: new Ext.data.JsonReader({ totalProperty: 'results', root: 'rows', id: 'ordlocdr' }, ['ordlocdesc', 'ordlocdr'])
    });

    var OrdLocComBoc = new Ext.form.ComboBox({
        store: ComBoOrdLocDs,
        displayField: 'ordlocdesc',
        width: comwidth,
        id: 'OrdLocCmb',
        emptyText: '',
        valueField: 'ordlocdr',
        emptyText: '请选择科室...',
        valueNotFoundText: '',
        queryMode: 'remote',
        queryParam: 'combotext',
        minChars: 0
    });

    var AddButton = new Ext.Button({
        width: 65,
        id: 'AddBtn',
        text: '增加',
        iconCls: 'page_add',
        listeners: {
            click: function () {
                AddClick();
            }
        }
    });

    var DelButton = new Ext.Button({
        width: 65,
        id: 'DelBtn',
        text: '删除',
        iconCls: 'page_delete',
        listeners: {
            click: function () {
                DelClick();
            }
        }
    });

    var QueryButton = new Ext.Button({
        width: 65,
        id: 'QueryBtn',
        text: '查询',
        iconCls: 'page_find',
        listeners: {
            click: function () {
                QueryAuditLocDs();
            }
        }
    });

    var ClearButton = new Ext.Button({
        width: 65,
        id: 'ClearBtn',
        text: '清空',
        iconCls: 'page_refresh',
        listeners: {
            click: function () {
                ClearData();
            }
        }
    });

    var AuditLocgridcm = new Ext.grid.ColumnModel({
        columns: [
            { header: '药房名称', dataIndex: 'phalocdesc', width: 250 },
            { header: '开单科室名称', dataIndex: 'ordlocdesc', width: 250 },
            { header: '药房ID', dataIndex: 'phalocdr', width: 50, hidden: true },
            { header: '开单科室ID', dataIndex: 'ordlocdr', width: 50, hidden: true },
            { header: 'palid', dataIndex: 'palid', width: 50, hidden: true }
        ]
    });

    var AuditLocgridds = new Ext.data.Store({
        autoLoad: true,
        proxy: new Ext.data.HttpProxy({
            url: unitsUrl + '?action=QueryAuditLocDetail&logonloc=' + logonloc,
            method: 'POST'
        }),
        reader: new Ext.data.JsonReader(
            {
                root: 'rows',
                totalProperty: 'results'
            },
            ['phalocdesc', 'ordlocdesc', 'phalocdr', 'ordlocdr', 'palid']
        ),

        remoteSort: true
    });

    var AuditLocgrid = new Ext.grid.GridPanel({
        id: 'AuditLoctbl',
        title: '医嘱需审核科室维护',
        region: 'center',
        width: ruleformwd,
        autoScroll: true, //自动生成滚动条
        enableHdMenu: false,
        frame: true,
        height: 650,
        ds: AuditLocgridds,
        cm: AuditLocgridcm,
        enableColumnMove: false,
        stripeRows: true,

        tbar: ['药房', PhaLocComBoc, '开单科室', OrdLocComBoc, '-', AddButton, '-', DelButton, '-', QueryButton, '-', ClearButton],

        trackMouseOver: 'true'
    });

    AuditLocgrid.on('rowclick', function (grid, rowIndex, e) {
        var selectedRow = AuditLocgridds.data.items[rowIndex];
        var Phalocdesc = selectedRow.data['phalocdesc'];
        var Phalocdr = selectedRow.data['phalocdr'];
        var Ordlocdesc = selectedRow.data['ordlocdesc'];
        var Ordlocdr = selectedRow.data['ordlocdr'];

        Ext.getCmp('PhaLocCmb').setValue(Phalocdr);
        Ext.getCmp('OrdLocCmb').setValue(Ordlocdr);
    });

	var HospPanel = InitHospCombo('PHA-COM-DrugAuditLoc',function(combo, record, index){
		HospId = this.value; 
		ComBoPhaLocDs.reload()
		ComBoOrdLocDs.reload()
        Ext.getCmp('PhaLocCmb').setValue('');
        Ext.getCmp('OrdLocCmb').setValue('');
		AuditLocgridds.reload();
	});

    var QueryForm = new Ext.Panel({
        region: 'center',
        frame: true,
        items: [AuditLocgrid]
    });

    var port = new Ext.Viewport({
        layout: 'border',
		items:[
			HospPanel,QueryForm
		]
    });

    //增加入库需审核药品通用名
    function AddClick() {
        var phalocdr = Ext.getCmp('PhaLocCmb').getValue();
        var ordlocdr = Ext.getCmp('OrdLocCmb').getValue();
        if (phalocdr == '') {
            Ext.Msg.show({ title: '提示', msg: '请先选择药房!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
            return;
        }
        if (ordlocdr == '') {
            Ext.Msg.show({ title: '提示', msg: '请先选择开单科室!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
            return;
        }

        ///数据库交互

        Ext.Ajax.request({
            url: unitsUrl + '?action=AddAuditLoc&PhaLocDr=' + phalocdr + '&OrdLocDr=' + ordlocdr,

            failure: function (result, request) {
                Ext.Msg.show({ title: '错误', msg: '请检查网络连接!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
            },
            success: function (result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                if (jsonData.retvalue == 0) {
                    Ext.Msg.show({ title: '提示', msg: '添加成功!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                    ClearData();
                    QueryAuditLocDs();
                } else if (jsonData.retvalue == 100) {
                    Ext.Msg.alert('提示', '所选药房和开单科室已经维护,不能重复添加!返回值: ' + jsonData.retinfo);
                } else {
                    Ext.Msg.alert('提示', '添加失败!返回值: ' + jsonData.retinfo);
                }
            },

            scope: this
        });
    }

    //删除需审核通用名
    function DelClick() {
        var row = Ext.getCmp('AuditLoctbl').getSelectionModel().getSelections();

        if (row.length == 0) {
            Ext.Msg.show({ title: '提示', msg: '未选中记录!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
            return;
        }

        Ext.MessageBox.confirm('注意', '确认要删除吗 ? ', DelClickResult);
    }

    ///删除确认动作
    function DelClickResult(btn) {
        if (btn == 'no') {
            return;
        }

        var row = Ext.getCmp('AuditLoctbl').getSelectionModel().getSelections();
        var palid = row[0].data.palid; //DHC_StPhAuditLoc 的 ID

        ///数据库交互删除

        Ext.Ajax.request({
            url: unitsUrl + '?action=AuditLocDel&palid=' + palid,

            waitMsg: '删除中...',
            failure: function (result, request) {
                Ext.Msg.show({ title: '错误', msg: '请检查网络连接!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
            },
            success: function (result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                if (jsonData.retvalue == 0) {
                    Ext.Msg.show({ title: '提示', msg: '删除成功!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                    ClearData();
                    QueryAuditLocDs();
                } else {
                    Ext.Msg.alert('提示', '删除失败!返回值: ' + jsonData.retinfo);
                }
            },

            scope: this
        });

        ClearData();
    }

    ///查找数据
    function QueryAuditLocDs() {
        AuditLocgridds.removeAll();

        var phalocdr = Ext.getCmp('PhaLocCmb').getValue();
        var ordlocdr = Ext.getCmp('OrdLocCmb').getValue();

        AuditLocgridds.proxy = new Ext.data.HttpProxy({ url: unitsUrl + '?action=QueryAuditLocDetail&logonloc=' + logonloc + '&PhaLocDr=' + phalocdr + '&OrdLocDr=' + ordlocdr });

        AuditLocgridds.load({
            callback: function (r, options, success) {
                if (success == false) {
                    Ext.Msg.show({ title: '注意', msg: '查询失败 !', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                }
            }
        });
    }

    ///清空数据
    function ClearData() {
        Ext.getCmp('PhaLocCmb').setValue('');
        Ext.getCmp('OrdLocCmb').setValue('');
    }
});
