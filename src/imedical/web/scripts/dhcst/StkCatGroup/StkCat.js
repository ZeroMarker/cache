///����: ������ά��
///����: ������ά��
///��д�ߣ�zhangxiao
///��д����: 2013.10.17
function addNewRow() {
    var record = Ext.data.Record.create([
        {
            name: 'RowId',
            type: 'int'
        },
        {
            name: 'Code',
            type: 'string'
        },
        {
            name: 'Desc',
            type: 'string'
        }
    ]);
    var NewRecord = new record({
        RowId: '',
        Code: '',
        Desc: ''
    });
    StkCatGriDs.add(NewRecord);
    StkCatGrid.startEditing(StkCatGriDs.getCount() - 1, 1);
}
var StkCatGrid = '';
//��������Դ
var StkCatGridUrl = 'dhcst.stkcataction.csp';
var StkCatGridProxy = new Ext.data.HttpProxy({ url: StkCatGridUrl + '?actiontype=query', method: 'POST' });
var StkCatGriDs = new Ext.data.Store({
    proxy: StkCatGridProxy,
    reader: new Ext.data.JsonReader(
        {
            root: 'rows',
            totalProperty: 'results',
            pagesize: 35
        },
        [{ name: 'RowId' }, { name: 'Code' }, { name: 'Desc' }]
    ),
    remoteSort: true,
    pruneModifiedRecords: true
});
//ģ��
var StkCatGridCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
    {
        header: '����',
        dataIndex: 'Code',
        width: 180,
        align: 'left',
        sortable: true,
        editor: new Ext.form.TextField({
            id: 'codeField',
            allowBlank: false,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        StkCatGrid.startEditing(StkCatGriDs.getCount() - 1, 2);
                    }
                }
            }
        })
    },
    {
        header: '����',
        dataIndex: 'Desc',
        width: 300,
        align: 'left',
        sortable: true,
        editor: new Ext.form.TextField({
            id: 'descField',
            allowBlank: false,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        addNewRow();
                    }
                }
            }
        })
    }
]);
//��ʼ��Ĭ��������
StkCatGridCm.defaultSortable = true;
var addStkCat = new Ext.Toolbar.Button({
    text: '�½�',
    tooltip: '�½�',
    iconCls: 'page_add',
    width: 70,
    height: 30,
    handler: function () {
        addNewRow();
    }
});
var saveStkCat = new Ext.Toolbar.Button({
    text: '����',
    tooltip: '����',
    iconCls: 'page_save',
    width: 70,
    height: 30,
    handler: function () {
        if (HospId == '') {
            Msg.info('warning', '����ѡ��ҽԺ!');
            return false;
        }
        //��ȡ���е��¼�¼
        var mr = StkCatGriDs.getModifiedRecords();
        var data = '';
        for (i = 0; i < mr.length; i++) {
            var code = mr[i].data['Code'].trim();
            var desc = mr[i].data['Desc'].trim();
            if (code != '' && desc != '') {
                var dataRow = mr[i].data['RowId'] + '^' + code + '^' + desc;
                if (data == '') {
                    data = dataRow;
                } else {
                    data = data + xRowDelim() + dataRow;
                }
            }
        }

        if (data == '') {
            Msg.info('error', 'û���޸Ļ�����������!');
            return false;
        } else {
            var mask = ShowLoadMask(Ext.getBody(), '���������Ժ�...');
            Ext.Ajax.request({
                url: StkCatGridUrl + '?actiontype=save',
                params: { data: data },
                failure: function (result, request) {
                    mask.hide();
                    Msg.info('error', '������������!');
                },
                success: function (result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    mask.hide();
                    if (jsonData.success == 'true') {
                        Msg.info('success', '����ɹ�!');
                        StkCatGriDs.load();
                    } else {
                        Msg.info('warning', jsonData.info);
                        StkCatGriDs.load();
                    }
                },
                scope: this
            });
        }
    }
});

var deleteStkCat = new Ext.Toolbar.Button({
    text: 'ɾ��',
    tooltip: 'ɾ��',
    iconCls: 'page_delete',
    width: 70,
    height: 30,
    handler: function () {
        if (HospId == '') {
            Msg.info('warning', '����ѡ��ҽԺ!');
            return false;
        }
        deleteDetail();
    }
});
//ɾ������
function deleteDetail() {
    var cell = StkCatGrid.getSelectionModel().getSelectedCell();
    if (cell == null) {
        Msg.info('error', '��ѡ������!');
        return false;
    } else {
        var record = StkCatGrid.getStore().getAt(cell[0]);
        var RowId = record.get('RowId');
        if (RowId != '') {
            Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?', function (btn) {
                if (btn == 'yes') {
                    var mask = ShowLoadMask(Ext.getBody(), '���������Ժ�...');
                    Ext.Ajax.request({
                        url: StkCatGridUrl + '?actiontype=delete&rowid=' + RowId,
                        waitMsg: 'ɾ����...',
                        failure: function (result, request) {
                            mask.hide();
                            Msg.info('error', '������������!');
                        },
                        success: function (result, request) {
                            var jsonData = Ext.util.JSON.decode(result.responseText);
                            mask.hide();
                            if (jsonData.success == 'true') {
                                Msg.info('success', 'ɾ���ɹ�!');
                                StkCatGriDs.load();
                            } else {
                                Msg.info('error', 'ɾ��ʧ��!');
                            }
                        },
                        scope: this
                    });
                }
            });
        } else {
            var rowInd = cell[0];
            if (rowInd >= 0) {
                StkCatGrid.getStore().removeAt(rowInd);
            }
        }
    }
}
//����
StkCatGrid = new Ext.grid.EditorGridPanel({
    store: StkCatGriDs,
    cm: StkCatGridCm,
    trackMouseOver: true,
    region: 'center',
    height: 690,
    stripeRows: true,
    sm: new Ext.grid.CellSelectionModel({}),
    loadMast: true,
    tbar: [addStkCat, '-', saveStkCat], //,'-',deleteStkCat],
    clicksToEdit: 1
});
StkCatGriDs.load();

var HospPanel = InitHospCombo('INC_StkCat',function(combo, record, index){
	HospId = this.value; 
	StkCatGriDs.reload();	
});
//===========ģ����ҳ��===============================================
Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

    var HisListTab = new Ext.form.FormPanel({
        labelwidth: 30,
        height: 30,
        labelAlign: 'right',
        title: '������ά��',
        region: 'center',
        frame: true,
        autoHeight: true
    });
    // 5.2.ҳ�沼��
    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: [
            HisListTab,
			HospPanel,
            {
                id: 'stkcat',
                region: 'center',
                title: '������',
                layout: 'fit', // specify layout manager for items
                items: StkCatGrid
            }
        ],
        renderTo: 'mainPanel'
    });
});

//===========ģ����ҳ��===============================================