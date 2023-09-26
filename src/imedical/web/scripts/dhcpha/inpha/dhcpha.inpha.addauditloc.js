var unitsUrl = 'dhcpha.auditlocaction.csp';
var comwidth = 200;
var ruleformwd = 800;
var HospId = session['LOGON.HOSPID'];
Ext.onReady(function () {
    var logonloc = session['LOGON.CTLOCID'];

    Ext.QuickTips.init(); // ������Ϣ��ʾ

    Ext.Ajax.timeout = 900000;

    ///ҩ��
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
        emptyText: '��ѡ��ҩ��...',
        valueNotFoundText: '',
        queryParam: 'combotext',
        minChars: 0
    });

    ///����

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
        emptyText: '��ѡ�����...',
        valueNotFoundText: '',
        queryMode: 'remote',
        queryParam: 'combotext',
        minChars: 0
    });

    var AddButton = new Ext.Button({
        width: 65,
        id: 'AddBtn',
        text: '����',
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
        text: 'ɾ��',
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
        text: '��ѯ',
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
        text: '���',
        iconCls: 'page_refresh',
        listeners: {
            click: function () {
                ClearData();
            }
        }
    });

    var AuditLocgridcm = new Ext.grid.ColumnModel({
        columns: [
            { header: 'ҩ������', dataIndex: 'phalocdesc', width: 250 },
            { header: '������������', dataIndex: 'ordlocdesc', width: 250 },
            { header: 'ҩ��ID', dataIndex: 'phalocdr', width: 50, hidden: true },
            { header: '��������ID', dataIndex: 'ordlocdr', width: 50, hidden: true },
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
        title: 'ҽ������˿���ά��',
        region: 'center',
        width: ruleformwd,
        autoScroll: true, //�Զ����ɹ�����
        enableHdMenu: false,
        frame: true,
        height: 650,
        ds: AuditLocgridds,
        cm: AuditLocgridcm,
        enableColumnMove: false,
        stripeRows: true,

        tbar: ['ҩ��', PhaLocComBoc, '��������', OrdLocComBoc, '-', AddButton, '-', DelButton, '-', QueryButton, '-', ClearButton],

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

    //������������ҩƷͨ����
    function AddClick() {
        var phalocdr = Ext.getCmp('PhaLocCmb').getValue();
        var ordlocdr = Ext.getCmp('OrdLocCmb').getValue();
        if (phalocdr == '') {
            Ext.Msg.show({ title: '��ʾ', msg: '����ѡ��ҩ��!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
            return;
        }
        if (ordlocdr == '') {
            Ext.Msg.show({ title: '��ʾ', msg: '����ѡ�񿪵�����!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
            return;
        }

        ///���ݿ⽻��

        Ext.Ajax.request({
            url: unitsUrl + '?action=AddAuditLoc&PhaLocDr=' + phalocdr + '&OrdLocDr=' + ordlocdr,

            failure: function (result, request) {
                Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
            },
            success: function (result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                if (jsonData.retvalue == 0) {
                    Ext.Msg.show({ title: '��ʾ', msg: '��ӳɹ�!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                    ClearData();
                    QueryAuditLocDs();
                } else if (jsonData.retvalue == 100) {
                    Ext.Msg.alert('��ʾ', '��ѡҩ���Ϳ��������Ѿ�ά��,�����ظ����!����ֵ: ' + jsonData.retinfo);
                } else {
                    Ext.Msg.alert('��ʾ', '���ʧ��!����ֵ: ' + jsonData.retinfo);
                }
            },

            scope: this
        });
    }

    //ɾ�������ͨ����
    function DelClick() {
        var row = Ext.getCmp('AuditLoctbl').getSelectionModel().getSelections();

        if (row.length == 0) {
            Ext.Msg.show({ title: '��ʾ', msg: 'δѡ�м�¼!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
            return;
        }

        Ext.MessageBox.confirm('ע��', 'ȷ��Ҫɾ���� ? ', DelClickResult);
    }

    ///ɾ��ȷ�϶���
    function DelClickResult(btn) {
        if (btn == 'no') {
            return;
        }

        var row = Ext.getCmp('AuditLoctbl').getSelectionModel().getSelections();
        var palid = row[0].data.palid; //DHC_StPhAuditLoc �� ID

        ///���ݿ⽻��ɾ��

        Ext.Ajax.request({
            url: unitsUrl + '?action=AuditLocDel&palid=' + palid,

            waitMsg: 'ɾ����...',
            failure: function (result, request) {
                Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
            },
            success: function (result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                if (jsonData.retvalue == 0) {
                    Ext.Msg.show({ title: '��ʾ', msg: 'ɾ���ɹ�!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                    ClearData();
                    QueryAuditLocDs();
                } else {
                    Ext.Msg.alert('��ʾ', 'ɾ��ʧ��!����ֵ: ' + jsonData.retinfo);
                }
            },

            scope: this
        });

        ClearData();
    }

    ///��������
    function QueryAuditLocDs() {
        AuditLocgridds.removeAll();

        var phalocdr = Ext.getCmp('PhaLocCmb').getValue();
        var ordlocdr = Ext.getCmp('OrdLocCmb').getValue();

        AuditLocgridds.proxy = new Ext.data.HttpProxy({ url: unitsUrl + '?action=QueryAuditLocDetail&logonloc=' + logonloc + '&PhaLocDr=' + phalocdr + '&OrdLocDr=' + ordlocdr });

        AuditLocgridds.load({
            callback: function (r, options, success) {
                if (success == false) {
                    Ext.Msg.show({ title: 'ע��', msg: '��ѯʧ�� !', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
                }
            }
        });
    }

    ///�������
    function ClearData() {
        Ext.getCmp('PhaLocCmb').setValue('');
        Ext.getCmp('OrdLocCmb').setValue('');
    }
});
