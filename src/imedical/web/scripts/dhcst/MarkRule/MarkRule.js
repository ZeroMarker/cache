// ����:���۹���
// ��д����:2012-06-5

var mzLoad = false;
var sdLoad = false;
var markRuleLoad = false;

var mrId = '';
//=========================���۹���=================================
var SDCommStore = new Ext.data.Store({
    proxy: '',
    reader: new Ext.data.JsonReader(
        {
            totalProperty: 'results',
            root: 'rows'
        },
        ['Description', 'RowId']
    )
});

SDCommStore.on('beforeload', function (ds, o) {
    ds.proxy = new Ext.data.HttpProxy({ url: 'dhcst.drugutil.csp?actiontype=StkDecimal', method: 'GET' });
});

var SDComm = new Ext.form.ComboBox({
    fieldLabel: $g('С������'),
    id: 'SDComm',
    name: 'SDComm',
    anchor: '90%',
    width: 120,
    store: SDCommStore,
    valueField: 'RowId',
    displayField: 'Description',
    allowBlank: false,
    triggerAction: 'all',
    emptyText: $g('С������...'),
    selectOnFocus: true,
    forceSelection: true,
    minChars: 1,
    pageSize: 10,
    listWidth: 250,
    valueNotFoundText: '',
    listeners: {
        specialKey: function (field, e) {
            if (e.getKey() == Ext.EventObject.ENTER) {
                MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 10);
            }
        }
    }
});
SDCommStore.load();

function rendererSD(value, p, r) {
    var combo = Ext.getCmp('SDCommList');
    var index = SDCommStoreList.find(combo.valueField, value);
    var record = SDCommStoreList.getAt(index);
    var recordv = combo.findRecord(combo.valueField, value);
    if (value == '' || !recordv) {
        return value;
    }
    var displayText = '';
    if (record == null) {
        displayText = value;
    } else {
        displayText = recordv.get(combo.displayField);
    }
    return displayText;
}

var SDCommStoreList = new Ext.data.Store({
    proxy: new Ext.data.HttpProxy({
        url: 'dhcst.drugutil.csp?actiontype=StkDecimal'
    }),
    reader: new Ext.data.JsonReader(
        {
            totalProperty: 'results',
            root: 'rows'
        },
        ['Description', 'RowId']
    ),
    listeners: {
        load: function () {
            sdLoad = true;
            retrieve();
        }
    }
});

SDCommStoreList.load();
var SDCommList = new Ext.form.ComboBox({
    fieldLabel: $g('С������'),
    id: 'SDCommList',
    name: 'SDCommList',
    anchor: '90%',
    width: 120,
    store: SDCommStoreList,
    valueField: 'RowId',
    displayField: 'Description',
    allowBlank: false,
    triggerAction: 'all',
    emptyText: $g('С������...'),
    selectOnFocus: true,
    forceSelection: true,
    minChars: 1,
    //pageSize : 100,
    listWidth: 250,
    valueNotFoundText: ''
});

var MTCommStore = new Ext.data.Store({
    proxy: '',
    reader: new Ext.data.JsonReader(
        {
            totalProperty: 'results',
            root: 'rows'
        },
        ['Description', 'RowId']
    )
});

MTCommStore.on('beforeload', function (ds, o) {
    ds.proxy = new Ext.data.HttpProxy({ url: 'dhcst.drugutil.csp?actiontype=MarkType', method: 'GET' });
});

var MTComm = new Ext.form.ComboBox({
    fieldLabel: $g('��������'),
    id: 'MTComm',
    name: 'MTComm',
    anchor: '90%',
    width: 120,
    store: MTCommStore,
    valueField: 'RowId',
    displayField: 'Description',
    allowBlank: false,
    triggerAction: 'all',
    emptyText: $g('��������...'),
    selectOnFocus: true,
    forceSelection: true,
    minChars: 1,
    pageSize: 10,
    listWidth: 250,
    valueNotFoundText: '',
    listeners: {
        specialKey: function (field, e) {
            if (e.getKey() == Ext.EventObject.ENTER) {
                MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 12);
            }
        }
    }
});

MTCommStore.load();

function rendererMT(value, p, r) {
    var combo = Ext.getCmp('MTCommList');
    var index = MTCommStoreList.find(combo.valueField, value);
    var record = MTCommStoreList.getAt(index);
    var recordv = combo.findRecord(combo.valueField, value);
    if (value == '' || !recordv) {
        return value;
    }
    var displayText = '';
    if (record == null) {
        displayText = value;
    } else {
        displayText = recordv.get(combo.displayField);
    }
    return displayText;
}

var MTCommStoreList = new Ext.data.Store({
    proxy: new Ext.data.HttpProxy({
        url: 'dhcst.drugutil.csp?actiontype=MarkType'
    }),
    reader: new Ext.data.JsonReader(
        {
            totalProperty: 'results',
            root: 'rows'
        },
        ['Description', 'RowId']
    ),
    listeners: {
        load: function () {
            mzLoad = true;
            retrieve();
        }
    }
});

MTCommStoreList.load();
var MTCommList = new Ext.form.ComboBox({
    fieldLabel: $g('��������'),
    id: 'MTCommList',
    name: 'MTCommList',
    anchor: '90%',
    width: 120,
    store: MTCommStoreList,
    valueField: 'RowId',
    displayField: 'Description',
    allowBlank: false,
    triggerAction: 'all',
    emptyText: $g('��������...'),
    selectOnFocus: true,
    forceSelection: true,
    minChars: 1,
    //pageSize : 10,
    listWidth: 250,
    valueNotFoundText: ''
});

var UFlag = new Ext.grid.CheckColumn({
    header: $g('�Ƿ�ʹ��'),
    dataIndex: 'UseFlag',
    width: 100,
    sortable: true,
    renderer: function (v, p, record) {
        p.css += ' x-grid3-check-col-td';
        return '<div class="x-grid3-check-col' + (v == 'Y' || v == true ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
    }
});
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
        },
        {
            name: 'MinRp',
            type: 'double'
        },
        {
            name: 'MaxRp',
            type: 'double'
        },
        {
            name: 'Margin',
            type: 'double'
        },
        {
            name: 'MPrice',
            type: 'double'
        },
        {
            name: 'MaxMargin',
            type: 'string'
        },
        {
            name: 'MaxMPrice',
            type: 'double'
        },
        {
            name: 'SdDr',
            type: 'int'
        },
        {
            name: 'SdDesc',
            type: 'string'
        },
        {
            name: 'MtDr',
            type: 'int'
        },
        {
            name: 'MtDesc',
            type: 'string'
        },
        {
            name: 'UseFlag',
            type: 'string'
        },
        {
            name: 'Remark',
            type: 'string'
        }
    ]);

    var NewRecord = new record({
        RowId: '',
        Code: '',
        Desc: '',
        MinRp: '',
        MaxRp: '',
        Margin: '',
        MPrice: '',
        MaxMargin: '',
        MaxMPrice: '',
        SdDr: '',
        SdDesc: '',
        MtDr: '',
        MtDesc: '',
        UseFlag: '',
        Remark: ''
    });

    MarkRuleGridDs.add(NewRecord);
    MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 1);
}

var MarkRuleGrid = '';
//��������Դ
var MarkRuleGridUrl = 'dhcst.markruleaction.csp';
var MarkRuleGridProxy = new Ext.data.HttpProxy({ url: MarkRuleGridUrl + '?actiontype=selectAll', method: 'GET' });
var MarkRuleGridDs = new Ext.data.Store({
    pruneModifiedRecords: true,
    proxy: MarkRuleGridProxy,
    reader: new Ext.data.JsonReader(
        {
            root: 'rows'
        },
        [
            { name: 'RowId' },
            { name: 'Code' },
            { name: 'Desc' },
            { name: 'MinRp' },
            { name: 'MaxRp' },
            { name: 'Margin' },
            { name: 'MPrice' },
            { name: 'MaxMargin' },
            { name: 'MaxMPrice' },
            { name: 'SdDr' },
            { name: 'SdDesc' },
            { name: 'MtDr' },
            { name: 'MtDesc' },
            { name: 'UseFlag' },
            { name: 'Remark' }
        ]
    ),
    pruneModifiedRecords: true,
    remoteSort: false,
    listeners: {
        load: function () {
            markRuleLoad = true;
        }
    }
});

//ģ��
var MarkRuleGridCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
    {
        header: $g('����'),
        dataIndex: 'Code',
        width: 80,
        align: 'left',
        sortable: true,
        editor: new Ext.form.TextField({
            id: 'codeFieldm',
            allowBlank: false,
            selectOnFocus: true,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 2);
                    }
                }
            }
        })
    },
    {
        header: $g('����'),
        dataIndex: 'Desc',
        width: 80,
        align: 'left',
        sortable: true,
        editor: new Ext.form.TextField({
            id: 'descFieldm',
            selectOnFocus: true,
            allowBlank: false,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 3);
                    }
                }
            }
        })
    },
    {
        header: $g('��������'),
        dataIndex: 'MinRp',
        width: 80,
        align: 'right',
        sortable: true,
        decimalPrecision: 4,
        editor: new Ext.form.NumberField({
            id: 'minRpFieldm',
            allowBlank: true,
            selectOnFocus: true,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 4);
                    }
                }
            }
        })
    },
    {
        header:$g( '��������'),
        dataIndex: 'MaxRp',
        width: 80,
        align: 'right',
        sortable: true,
        decimalPrecision: 4,
        editor: new Ext.form.NumberField({
            id: 'maxRpFieldm',
            allowBlank: true,
            selectOnFocus: true,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 5);
                    }
                }
            }
        })
    },
    {
        header: $g('�ӳ���'),
        dataIndex: 'Margin',
        width: 80,
        align: 'right',
        sortable: true,
        decimalPrecision: 4,
        editor: new Ext.form.NumberField({
            id: 'marginFieldm',
            allowBlank: true,
            selectOnFocus: true,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 6);
                    }
                }
            }
        })
    },
    {
        header: $g('�ӳɶ�'),
        dataIndex: 'MPrice',
        width: 80,
        align: 'right',
        sortable: true,
        editor: new Ext.form.NumberField({
            id: 'mPriceFieldm',
            allowBlank: true,
            selectOnFocus: true,
            decimalPrecision: 4,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 7);
                    }
                }
            }
        })
    },
    {
        header: $g('��߼ӳ���'),
        dataIndex: 'MaxMargin',
        width: 80,
        align: 'right',
        sortable: true,
        editor: new Ext.form.NumberField({
            id: 'maxMarginFieldm',
            allowBlank: true,
            selectOnFocus: true,
            decimalPrecision: 4,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 8);
                    }
                }
            }
        })
    },
    {
        header: $g('��߼ӳɶ�'),
        dataIndex: 'MaxMPrice',
        width: 80,
        align: 'right',
        sortable: true,
        editor: new Ext.form.NumberField({
            id: 'maxMPriceFieldm',
            allowBlank: true,
            selectOnFocus: true,
            decimalPrecision: 4,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        MarkRuleGrid.startEditing(MarkRuleGridDs.getCount() - 1, 9);
                    }
                }
            }
        })
    },
    {
        header:$g( 'С������'),
        //dataIndex:'SdDesc',
        dataIndex: 'SdDr',
        width: 80,
        align: 'left',
        sortable: true,
        renderer: rendererSD,
        editor: new Ext.grid.GridEditor(SDComm)
    },
    {
        header: $g('��������'),
        //dataIndex:'MtDesc',
        dataIndex: 'MtDr',
        width: 80,
        align: 'left',
        sortable: true,
        renderer: rendererMT,
        editor: new Ext.grid.GridEditor(MTComm)
    },
    UFlag,
    {
        header: $g('��ע'),
        dataIndex: 'Remark',
        width: 100,
        align: 'left',
        sortable: true,
        editor: new Ext.form.TextField({
            id: 'remarkFieldm',
            allowBlank: true,
            selectOnFocus: true,
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
MarkRuleGridCm.defaultSortable = true;

var addMarkRule = new Ext.Toolbar.Button({
    text: $g('�½�'),
    tooltip: $g('�½�'),
    iconCls: 'page_add',
    width: 70,
    height: 30,
    handler: function () {
        addNewRow();
    }
});

var saveMarkRule = new Ext.Toolbar.Button({
    text: $g('����'),
    tooltip: $g('����'),
    iconCls: 'page_save',
    width: 70,
    height: 30,
    handler: function () {
        //��ȡ���е��¼�¼
        var mr = MarkRuleGridDs.getModifiedRecords();
        var data = '';
        var rows = '';
        if (CheckDataBeforeSave() == true) {
            for (var i = 0; i < mr.length; i++) {
                var rowid = mr[i].data['RowId'].trim();
                var code = mr[i].data['Code'].trim();
                var desc = mr[i].data['Desc'].trim();
                var minRp = mr[i].data['MinRp'];
                var maxRp = mr[i].data['MaxRp'];

                var margin = mr[i].data['Margin'];
                var mPrice = mr[i].data['MPrice'];
                var maxMargin = mr[i].data['MaxMargin'];
                var maxMPrice = mr[i].data['MaxMPrice'];
                //var sd = mr[i].data["SdDesc"].trim();
                var sd = mr[i].data['SdDr'].trim();
                //var mt = mr[i].data["MtDesc"].trim();
                var mt = mr[i].data['MtDr'].trim();
                var rows = MarkRuleGridDs.indexOf(mr[i]) + 1;

                if (parseFloat(minRp) > parseFloat(maxRp)) {
                    Ext.Msg.alert($g('��ʾ��'), $g('��') + rows + $g('�й������޲���С�ڹ������ޣ�'));
                    break;
                }
                if (code == '' || desc == '') {
                    Ext.Msg.alert($g('��ʾ��'),$g( '��') + rows + $g('�д�������Ʋ���Ϊ�գ�'));
                    break;
                }
                if (sd == '' || mt == '') {
                    Ext.Msg.alert($g('��ʾ��'), $g('��') + rows + $g('��С������Ͷ������Ͳ���Ϊ�գ�'));
                    break;
                }

                if (parseFloat(margin) > parseFloat(maxMargin)) {
                    Msg.info('warning', $g('��') + rows + $g('�мӳ��ʲ��ܸ�����߼ӳ��ʣ���'));
                    break;
                }
                if (parseFloat(mPrice) > parseFloat(maxMPrice)) {
                    Msg.info('warning', $g('��') + rows + $g('�мӳɶ�ܸ�����߼ӳɶ'));
                    break;
                }
                var remark = mr[i].data['Remark'].trim();
                var useFlag = mr[i].data['UseFlag'];

                var dataRow =
                    rowid + '^' + code + '^' + desc + '^' + maxRp + '^' + minRp + '^' + margin + '^' + mt + '^' + remark + '^' + useFlag + '^' + maxMPrice + '^' + maxMargin + '^' + mPrice + '^' + sd;

                if (data == '') {
                    data = dataRow;
                } else {
                    data = data + xRowDelim() + dataRow;
                }
            }

            if (data != '') {
                var mask = ShowLoadMask(Ext.getBody(), $g('���������Ժ�...'));
                Ext.Ajax.request({
                    url: MarkRuleGridUrl + '?actiontype=save',
                    params: { data: data },
                    failure: function (result, request) {
                        mask.hide();
                        Msg.info('error', $g('������������!'));
                    },
                    success: function (result, request) {
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        mask.hide();
                        if (jsonData.success == 'true') {
                            Msg.info('success', $g('����ɹ�!'));
                            MarkRuleGridDs.reload();
                        } else {
                            Msg.info('error', $g('����ʧ��!'));
                        }
                    },
                    scope: this
                });
            }
        }
    }
});
/**
 * ������ⵥǰ���ݼ��
 */

function CheckDataBeforeSave() {
    // 1.�ж����ҩƷ�Ƿ�Ϊ��
    var rowCount = MarkRuleGridDs.getCount();
    // ��Ч����
    var count = 0;
    // 3.�ж��ظ�����ҩƷ
    for (var i = 0; i < rowCount - 1; i++) {
        for (var j = i + 1; j < rowCount; j++) {
            var RowId_i = MarkRuleGridDs.getAt(i).get('RowId');
            var RowId_j = MarkRuleGridDs.getAt(j).get('RowId');
            var Code_i = MarkRuleGridDs.getAt(i).get('Code');
            var Code_j = MarkRuleGridDs.getAt(j).get('Code');

            var Desc_i = MarkRuleGridDs.getAt(i).get('Desc');
            var Desc_j = MarkRuleGridDs.getAt(j).get('Desc');
            var icnt = i + 1;
            var jcnt = j + 1;
            if (Code_i == Code_j) {
                changeBgColor(i, 'yellow');
                changeBgColor(j, 'yellow');
                Msg.info('warning', Code_i + $g(',��') + icnt + ',' + jcnt + $g('�й�������ظ�������������!'));
                return false;
            }
            if (Desc_i == Desc_j) {
                changeBgColor(i, 'yellow');
                changeBgColor(j, 'yellow');
                Msg.info('warning', Desc_i + $g(',��') + icnt + ',' + jcnt + $g('�й��������ظ�������������!'));
                return false;
            }
        }
    }
    return true;
}
// �任����ɫ
function changeBgColor(row, color) {
    MarkRuleGrid.getView().getRow(row).style.backgroundColor = color;
}
function changeChildBgColor(row, color) {
    MarkRuleAddGrid.getView().getRow(row).style.backgroundColor = color;
}
var deleteMarkRule = new Ext.Toolbar.Button({
    text: $g('ɾ��'),
    tooltip: $g('ɾ��'),
    iconCls: 'page_delete',
    width: 70,
    height: 30,
    handler: function () {
        var cell = MarkRuleGrid.getSelectionModel().getSelectedCell();
        if (cell == null) {
            Msg.info('error', $g('��ѡ������!'));
            return false;
        } else {
            var record = MarkRuleGrid.getStore().getAt(cell[0]);
            var RowId = record.get('RowId');
            //alert(RowId);
            if (RowId != '') {
                Ext.MessageBox.confirm($g('��ʾ'), $g('ȷ��Ҫɾ��ѡ������?'), function (btn) {
                    if (btn == 'yes') {
                        var mask = ShowLoadMask(Ext.getBody(), $g('���������Ժ�...'));
                        Ext.Ajax.request({
                            url: MarkRuleGridUrl + '?actiontype=delete&rowid=' + RowId,
                            waitMsg: $g('ɾ����...'),
                            failure: function (result, request) {
                                mask.hide();
                                Msg.info('error', $g('������������!'));
                            },
                            success: function (result, request) {
                                var jsonData = Ext.util.JSON.decode(result.responseText);
                                mask.hide();
                                if (jsonData.success == 'true') {
                                    Msg.info('success', $g('ɾ���ɹ�!'));
                                    MarkRuleGridDs.load();
                                    MarkRuleAddGridDs.reload();
                                } else {
                                    Msg.info('error',$g( 'ɾ��ʧ��!'));
                                }
                            },
                            scope: this
                        });
                    }
                });
            } else {
                //Msg.info("error","�����д�!");
                var rowInd = cell[0];
                if (rowInd >= 0) MarkRuleGrid.getStore().removeAt(rowInd);
            }
        }
    }
});

//���
MarkRuleGrid = new Ext.grid.EditorGridPanel({
    id: 'MarkRuleGrid',
    store: MarkRuleGridDs,
    cm: MarkRuleGridCm,
    trackMouseOver: true,
    height: 350,
    stripeRows: true,
    plugins: UFlag,
    clicksToEdit: 0,
    region: 'north',
    sm: new Ext.grid.CellSelectionModel({}),
    loadMask: true,
    tbar: [addMarkRule, '-', saveMarkRule, '-', deleteMarkRule],
    bbar: [
        {
            xtype: 'label',
            text: $g("�ۼۼ�����������ά��[���۹�����ϸ],���ۼ�=����*(1+�ӳ���)+�ӳɶ�"),
            align: 'center'
        }
    ],
    clicksToEdit: 1,
    listeners: {
        beforeedit: function (e) {
            if (e.field == 'SdDr') {
                if (e.record.data['SdDr'] != '') SDComm.setValue(e.record.data['SdDr']);
            }
            if (e.field == 'MtDr') {
                if (e.record.data['MtDr'] != '') MTComm.setValue(e.record.data['MtDr']);
            }
        }
    }
});

//=========================���۹���=================================
MarkRuleGrid.on('rowclick', function (grid, rowIndex, columnIndex, e) {
    var selectedRow = MarkRuleGridDs.data.items[rowIndex];
    mrId = selectedRow.data['RowId'];
    MarkRuleAddGridDs.proxy = new Ext.data.HttpProxy({ url: MarkRuleGridUrl + '?actiontype=selectChild', method: 'GET' });
    MarkRuleAddGridDs.load({ params: { parref: mrId } });
});
var UseFlag = new Ext.grid.CheckColumn({
    header: $g('�Ƿ�ʹ��'),
    dataIndex: 'UseFlag',
    width: 100,
    sortable: true,
    renderer: function (v, p, record) {
        p.css += ' x-grid3-check-col-td';
        return '<div class="x-grid3-check-col' + (v == 'Y' || v == true ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
    }
});
function addRow() {
    var rec = Ext.data.Record.create([
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
        },
        {
            name: 'MinRp',
            type: 'double'
        },
        {
            name: 'MaxRp',
            type: 'double'
        },
        {
            name: 'Margin',
            type: 'double'
        },
        {
            name: 'UseFlag',
            type: 'string'
        },
        {
            name: 'Remark',
            type: 'string'
        }
    ]);
    var NewRec = new rec({
        RowId: '',
        Code: '',
        Desc: '',
        MinRp: '',
        MaxRp: '',
        Margin: '',
        UseFlag: '',
        Remark: ''
    });

    MarkRuleAddGridDs.add(NewRec);
    MarkRuleAddGrid.startEditing(MarkRuleAddGridDs.getCount() - 1, 1);
}

var MarkRuleAddGrid = '';
//��������Դ
var MarkRuleAddGridProxy = new Ext.data.HttpProxy({ url: MarkRuleGridUrl + '?actiontype=selectChild', method: 'GET' });
var MarkRuleAddGridDs = new Ext.data.Store({
    proxy: MarkRuleAddGridProxy,
    reader: new Ext.data.JsonReader(
        {
            root: 'rows'
        },
        [{ name: 'RowId' }, { name: 'Code' }, { name: 'Desc' }, { name: 'MinRp' }, { name: 'MaxRp' }, { name: 'Margin' }, { name: 'UseFlag' }, { name: 'Remark' }]
    ),
    pruneModifiedRecords: true,
    remoteSort: false
});

//ģ��
var MarkRuleAddGridCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
    {
        header: $g('����'),
        dataIndex: 'Code',
        width: 80,
        align: 'left',
        sortable: true,
        editor: new Ext.form.TextField({
            id: 'codeField',
            allowBlank: false,
            selectOnFocus: true,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        MarkRuleAddGrid.startEditing(MarkRuleAddGridDs.getCount() - 1, 2);
                    }
                }
            }
        })
    },
    {
        header: $g('����'),
        dataIndex: 'Desc',
        width: 80,
        align: 'left',
        sortable: true,
        editor: new Ext.form.TextField({
            id: 'descField',
            allowBlank: false,
            selectOnFocus: true,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        MarkRuleAddGrid.startEditing(MarkRuleAddGridDs.getCount() - 1, 3);
                    }
                }
            }
        })
    },
    {
        header: $g('����'),
        dataIndex: 'MinRp',
        width: 80,
        align: 'right',
        sortable: true,
        decimalPrecision: 4,
        editor: new Ext.form.NumberField({
            id: 'minRpField',
            allowBlank: false,
            selectOnFocus: true,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        MarkRuleAddGrid.startEditing(MarkRuleAddGridDs.getCount() - 1, 4);
                    }
                }
            }
        })
    },
    {
        header: $g('����'),
        dataIndex: 'MaxRp',
        width: 80,
        align: 'right',
        sortable: true,
        decimalPrecision: 4,
        editor: new Ext.form.NumberField({
            id: 'maxRpField',
            allowBlank: false,
            selectOnFocus: true,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        MarkRuleAddGrid.startEditing(MarkRuleAddGridDs.getCount() - 1, 5);
                    }
                }
            }
        })
    },
    {
        header: $g('�ӳ���'),
        dataIndex: 'Margin',
        width: 80,
        align: 'right',
        sortable: true,
        decimalPrecision: 4,
        editor: new Ext.form.NumberField({
            id: 'marginField',
            allowBlank: true,
            selectOnFocus: true,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        MarkRuleAddGrid.startEditing(MarkRuleAddGridDs.getCount() - 1, 6);
                    }
                }
            }
        })
    },
    {
        header: $g('��ע'),
        dataIndex: 'Remark',
        width: 80,
        align: 'left',
        sortable: true,
        editor: new Ext.form.TextField({
            id: 'remarkField',
            allowBlank: true,
            selectOnFocus: true,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        addRow();
                    }
                }
            }
        })
    },
    UseFlag
]);

//��ʼ��Ĭ��������
MarkRuleGridCm.defaultSortable = true;

var addMarkRuleAdd = new Ext.Toolbar.Button({
    text: $g('�½�'),
    tooltip: $g('�½�'),
    iconCls: 'page_add',
    width: 70,
    height: 30,
    handler: function () {
        var cell = MarkRuleGrid.getSelectionModel().getSelectedCell();
        if (cell == null) {
            Msg.info('warning',$g( '����ѡ���Ϸ����۹�������!'));
            return;
        }
        var record = MarkRuleGrid.getStore().getAt(cell[0]);
        var RowId = record.get('RowId') || '';
        if (RowId == '') {
            Msg.info('warning', $g('���ȱ����Ϸ����۹����ٽ����½���'));
            return;
        }
        addRow();
    }
});

var saveMarkRuleAdd = new Ext.Toolbar.Button({
    text: $g('����'),
    tooltip: $g('����'),
    iconCls: 'page_save',
    width: 70,
    height: 30,
    handler: function () {
        //��ȡ���е��¼�¼
        var mr = MarkRuleAddGridDs.getModifiedRecords();
        var data = '';
        var row = '';
        if (CheckChildDataBeforeSave() == true) {
            for (var i = 0; i < mr.length; i++) {
                var rowid = mr[i].data['RowId'].trim();
                var code = mr[i].data['Code'].trim();
                var desc = mr[i].data['Desc'].trim();
                var minRp = mr[i].data['MinRp'];
                var maxRp = mr[i].data['MaxRp'];
                var margin = mr[i].data['Margin'];
                var remark = mr[i].data['Remark'].trim();
                var useFlag = mr[i].data['UseFlag'];

                row = MarkRuleAddGridDs.indexOf(mr[i]) + 1;
                if (code == '') {
                    Msg.info('warning', $g('��') + row + $g('�д��벻��Ϊ�գ�'));
                    break;
                } else if (desc == '') {
                    Msg.info('warning', $g('��') + row + $g('�����Ʋ���Ϊ�գ�'));
                    break;
                } else if (parseFloat(minRp) > parseFloat(maxRp)) {
                    Msg.info('warning', $g('��') + row + $g('�����޲��ܸ������ޣ�'));
                    break;
                }
                if (minRp === '') {
                    Msg.info('warning', $g('��') + row + $g('�����޲���Ϊ��!'));
                    break;
                }
                if (maxRp === '') {
                    Msg.info('warning', $g('��') + row + $g('�����޲���Ϊ��!'));
                    break;
                }
                var dataRow = rowid + '^' + mrId + '^' + code + '^' + desc + '^' + maxRp + '^' + minRp + '^' + margin + '^' + remark + '^' + useFlag;
                if (data == '') {
                    data = dataRow;
                } else {
                    data = data + xRowDelim() + dataRow;
                }
            }
        }
        if (data != '') {
            var mask = ShowLoadMask(Ext.getBody(), $g('���������Ժ�...'));
            Ext.Ajax.request({
                url: MarkRuleGridUrl + '?actiontype=saveChild',
                params: { data: data },
                failure: function (result, request) {
                    mask.hide();
                    Msg.info('error', $g('������������!'));
                },
                success: function (result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    mask.hide();
                    if (jsonData.success == 'true') {
                        Msg.info('success', $g('����ɹ�!'));
                        MarkRuleAddGridDs.load({ params: { parref: mrId } });
                    } else {
                        Msg.info('error', $g('����ʧ��!'));
                    }
                },
                scope: this
            });
        }
    }
});
/**
 * ������ⵥǰ���ݼ��
 */

function CheckChildDataBeforeSave() {
    // 1.�ж����ҩƷ�Ƿ�Ϊ��
    var rowCount = MarkRuleAddGridDs.getCount();
    // ��Ч����
    var count = 0;
    // 3.�ж��ظ�����ҩƷ
    for (var i = 0; i < rowCount - 1; i++) {
        for (var j = i + 1; j < rowCount; j++) {
            var RowId_i = MarkRuleAddGridDs.getAt(i).get('RowId');
            var RowId_j = MarkRuleAddGridDs.getAt(j).get('RowId');
            var Code_i = MarkRuleAddGridDs.getAt(i).get('Code');
            var Code_j = MarkRuleAddGridDs.getAt(j).get('Code');
            var Desc_i = MarkRuleAddGridDs.getAt(i).get('Desc');
            var Desc_j = MarkRuleAddGridDs.getAt(j).get('Desc');
            var icnt = i + 1;
            var jcnt = j + 1;
            if (Code_i == Code_j) {
                changeChildBgColor(i, 'yellow');
                changeChildBgColor(j, 'yellow');
                Msg.info('warning', Code_i + $g(',��') + icnt + ',' + jcnt + $g('�й�����ϸ�����ظ�������������!'));
                return false;
            }
            if (Desc_i == Desc_j) {
                changeChildBgColor(i, 'yellow');
                changeChildBgColor(j, 'yellow');
                Msg.info('warning', Desc_i + $g(',��') + icnt + ',' + jcnt + $g('�й�����ϸ�����ظ�������������!'));
                return false;
            }
        }
    }
    return true;
}
var deleteMarkRuleAdd = new Ext.Toolbar.Button({
    text: $g('ɾ��'),
    tooltip: $g('ɾ��'),
    iconCls: 'page_delete',
    width: 70,
    height: 30,
    handler: function () {
        var cell = MarkRuleAddGrid.getSelectionModel().getSelectedCell();
        if (cell == null) {
            Msg.info('error', $g('��ѡ������!'));
            return false;
        } else {
            var record = MarkRuleAddGrid.getStore().getAt(cell[0]);
            var RowId = record.get('RowId');
            if (RowId != '') {
                Ext.MessageBox.confirm($g('��ʾ'), $g('ȷ��Ҫɾ��ѡ������?'), function (btn) {
                    if (btn == 'yes') {
                        var mask = ShowLoadMask(Ext.getBody(), $g('���������Ժ�...'));
                        Ext.Ajax.request({
                            url: MarkRuleGridUrl + '?actiontype=deleteChild&rowid=' + RowId,
                            waitMsg: $g('ɾ����...'),
                            failure: function (result, request) {
                                mask.hide();
                                Msg.info('error', $g('������������!'));
                            },
                            success: function (result, request) {
                                var jsonData = Ext.util.JSON.decode(result.responseText);
                                mask.hide();
                                if (jsonData.success == 'true') {
                                    Msg.info('success', $g('ɾ���ɹ�!'));
                                    MarkRuleAddGridDs.load({ params: { parref: mrId } });
                                } else {
                                    Msg.info('error', $g('ɾ��ʧ��!'));
                                }
                            },
                            scope: this
                        });
                    }
                });
            } else {
                //Msg.info("error","�����д�!");
                var rowInd = cell[0];
                if (rowInd >= 0) MarkRuleAddGrid.getStore().removeAt(rowInd);
            }
        }
    }
});

//���
MarkRuleAddGrid = new Ext.grid.EditorGridPanel({
	title:$g("���۹�����ϸ"),
    store: MarkRuleAddGridDs,
    cm: MarkRuleAddGridCm,
    trackMouseOver: true,
    height: 350,
    stripeRows: true,
    plugins: UseFlag,
    region: 'center',
    clicksToEdit: 0,
    sm: new Ext.grid.CellSelectionModel({}),
    loadMask: true,
    tbar: [addMarkRuleAdd, '-', saveMarkRuleAdd, '-', deleteMarkRuleAdd],
    bbar: [
        {
            xtype: 'label',
            text: $g('��ά����[���۹�����ϸ],��ʹ�ý��ݼӳɹ����ۼ�=����1���ֽ��*(1+����1�ӳ���)+����2���ֽ��*(1+����2�ӳ���)+����3���ֽ��*(1+����3�ӳ���)+...'),
            align: 'center'
        }
    ],
    clicksToEdit: 1
});
//===========ģ����ҳ��=================================================
function retrieve() {
    while (mzLoad && sdLoad && markRuleLoad == false) {
        MarkRuleGridDs.load();
        break;
    }
}
var HospPanel = InitHospCombo('DHC_MarkRule', function (combo, record, index) {
    HospId = this.value;
    SDCommStore.reload();
    SDCommStoreList.reload();
    MTCommStore.reload();
    MTCommStoreList.reload();

	MarkRuleAddGrid.store.removeAll();
	MarkRuleAddGrid.getView().refresh();
	mzLoad = false;
	sdLoad = false;
	markRuleLoad = false;
	retrieve()
//	MarkRuleGridDs.reload();
	
});
Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

    var MarkRulePanel = new Ext.Panel({
        id: 'MarkRulePanel',
        layout: 'border',
        region: 'center',
        title: $g('���۹���'),
        activeTab: 0,
        items: [MarkRuleGrid, MarkRuleAddGrid]
    });
    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: [HospPanel, MarkRulePanel],
        renderTo: 'mainPanel'
    });
});
//===========ģ����ҳ��=================================================
