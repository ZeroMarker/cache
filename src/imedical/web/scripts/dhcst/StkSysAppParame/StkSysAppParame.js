// ����:�������ù���
// ��д����:2012-06-7
// Modify:zdm,2012-07-10,�޸Ľ��沼��
//=========================����ȫ�ֱ���=================================
var StkSysAppId = '';
var StkSysAppParameId = '';
var GroupId = session['LOGON.GROUPID'];
var Type = 'G';

//=========================����ȫ�ֱ���=================================
//=========================Ӧ��ϵͳ����=================================
var StkSysAppGrid = '';
//��������Դ
var StkSysAppGridUrl = 'dhcst.stksysappaction.csp';
var StkSysAppGridProxy = new Ext.data.HttpProxy({ url: StkSysAppGridUrl + '?actiontype=selectAll', method: 'GET' });
var StkSysAppGridDs = new Ext.data.Store({
    proxy: StkSysAppGridProxy,
    reader: new Ext.data.JsonReader(
        {
            root: 'rows'
        },
        [{ name: 'RowId' }, { name: 'Code' }, { name: 'Desc' }, { name: 'Type' }]
    ),
    remoteSort: false
});

//ģ��
var StkSysAppGridCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
    {
        header: '����',
        dataIndex: 'Code',
        width: 170,
        align: 'left',
        sortable: true
    },
    {
        header: '����',
        dataIndex: 'Desc',
        width: 120,
        align: 'left',
        sortable: true
    }
]);

//��ʼ��Ĭ��������
StkSysAppGridCm.defaultSortable = true;

//���
StkSysAppGrid = new Ext.grid.EditorGridPanel({
    store: StkSysAppGridDs,
    cm: StkSysAppGridCm,
    trackMouseOver: true,
    height: 665,
    stripeRows: true,
    sm: new Ext.grid.CellSelectionModel({}),
    loadMask: true,
    tbar: [
        {
            xtype: 'label',
            height: 30,
            text: '',
            align: 'center'
        }
    ]
});

StkSysAppGridDs.load();
//=========================Ӧ��ϵͳ����=================================

//=========================Ӧ��ϵͳ��������=============================
var StkSysAppParameGrid = '';
var StkDecimalDesc = '';

function addNewMXRow() {
    var mxRecord = Ext.data.Record.create([
        {
            name: 'RowId',
            type: 'int'
        },
        {
            name: 'Parref',
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
            name: 'Memo',
            type: 'string'
        }
    ]);

    var MXRecord = new mxRecord({
        RowId: '',
        Parref: '',
        Code: '',
        Desc: '',
        Memo: ''
    });

    StkSysAppParameGridDs.add(MXRecord);
    StkSysAppParameGrid.startEditing(StkSysAppParameGridDs.getCount() - 1, 2);
}

//��������Դ
var StkSysAppParameGridUrl = 'dhcst.stksysappparameaction.csp';
var StkSysAppParameGridProxy = new Ext.data.HttpProxy({ url: StkSysAppParameGridUrl, method: 'GET' });
var StkSysAppParameGridDs = new Ext.data.Store({
    proxy: StkSysAppParameGridProxy,
    reader: new Ext.data.JsonReader(
        {
            root: 'rows'
        },
        [{ name: 'RowId' }, { name: 'Parref' }, { name: 'Code' }, { name: 'Desc' }, { name: 'Memo' }, { name: 'DefaultVal' }]
    ),
    pruneModifiedRecords: true,
    remoteSort: true
});

//ģ��
var StkSysAppParameGridCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
    {
        header: 'Id',
        dataIndex: 'RowId',
        width: 100,
        align: 'left',
        sortable: true,
        hidden: true
    },
    {
        header: '����',
        dataIndex: 'Code',
        width: 150,
        align: 'left',
        sortable: true,
        editor: new Ext.form.TextField({
            id: 'nameField',
            allowBlank: false,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        StkSysAppParameGrid.startEditing(StkSysAppParameGridDs.getCount() - 1, 3);
                    }
                }
            }
        })
    },
    {
        header: '����',
        dataIndex: 'Desc',
        width: 150,
        align: 'left',
        sortable: true,
        editor: new Ext.form.TextField({
            id: 'descField',
            allowBlank: true,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        StkSysAppParameGrid.startEditing(StkSysAppParameGridDs.getCount() - 1, 4);
                    }
                }
            }
        }),
        renderer: function (value, meta, record) {
            var title = '����';
            var tip = value;
            meta.attr = 'ext:qtitle="' + title + '"' + ' ext:qtip="' + tip + '"';
            return value;
        }
    },
    {
        header: '��ע',
        dataIndex: 'Memo',
        width: 350,
        align: 'left',
        sortable: true,
        editor: new Ext.form.TextField({
            id: 'memoField',
            allowBlank: true,
            listeners: {
                specialKey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        addNewMXRow();
                    }
                }
            }
        }),
        renderer: function (value, meta, record) {
            var title = '��ע';
            var tip = value;
            meta.attr = 'ext:qtitle="' + title + '"' + ' ext:qtip="' + tip + '"';
            return value;
        }
    },
    {
        header: 'Ĭ��ֵ',
        dataIndex: 'DefaultVal',
        width: 150,
        align: 'left',
        sortable: true,
        editor: new Ext.form.TextField({
            id: 'defaultValField',
            allowBlank: true,
            listeners: {
                specialKey: function (field, e) {
                }
            }
        })
    }
]);

//��ʼ��Ĭ��������
StkSysAppParameGridCm.defaultSortable = true;

var addStkSysAppParame = new Ext.Toolbar.Button({
    text: '�½�',
    tooltip: '�½�',
    iconCls: 'page_add',
    width: 70,
    height: 30,
    handler: function () {
        if (StkSysAppId != '') {
            addNewMXRow();
        } else {
            Msg.info('error', '��ѡ��Ӧ��ϵͳ!');
            return false;
        }
    }
});

var saveStkSysAppParame = new Ext.Toolbar.Button({
    text: '����',
    tooltip: '����',
    width: 70,
    height: 30,
    iconCls: 'page_save',
    handler: function () {
        //��ȡ���е��¼�¼
        var mr = StkSysAppParameGridDs.getModifiedRecords();
        var data = '';
        for (var i = 0; i < mr.length; i++) {
            var code = mr[i].data['Code'];
            var rowid = mr[i].data['RowId']; //StkSysAppParameGridDs.getAt(StkSysAppParameGridDs.find('Code',code)).get('RowId');
            var desc = mr[i].data['Desc'];
            var memo = mr[i].data['Memo'];
			var defaultVal = mr[i].data['DefaultVal'];
            if (code == '') {
                Msg.info('warning', '���Ʋ���Ϊ��!');
                return;
            }

            if (code != '' && StkSysAppId != '') {
                var dataRow = rowid + '^' + StkSysAppId + '^' + code + '^' + desc + '^' + memo + '^' + defaultVal;
                if (data == '') {
                    data = dataRow;
                } else {
                    data = data + xRowDelim() + dataRow;
                }
            }
        }

        if (data != '') {
            var mask = ShowLoadMask(Ext.getBody(), '���������Ժ�...');
            Ext.Ajax.request({
                url: StkSysAppParameGridUrl + '?actiontype=saveParame',
                params: { data: data },
                failure: function (result, request) {
                    mask.hide();
                    Msg.info('error', '������������!');
                },
                success: function (result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    mask.hide();
                    if (jsonData.success == 'true') {
                        data = '';
                        Msg.info('success', '����ɹ�!');
                        StkSysAppParameGridDs.load({ params: { StkSysAppId: StkSysAppId } });
                    } else {
                        if (jsonData.info == 'RepRec') {
                            data = '';
                            Msg.info('error', '��¼�ظ�!');
                        } else {
                            data = '';
                            Msg.info('error', '����ʧ��!');
                        }
                    }
                },
                scope: this
            });
        } else {
            Msg.info('error', 'û���޸Ļ����������!');
        }
    }
});

var deleteStkSysAppParame = new Ext.Toolbar.Button({
    text: 'ɾ��',
    tooltip: 'ɾ��',
    width: 70,
    height: 30,
    iconCls: 'page_delete',
    handler: function () {
        var cell = StkSysAppParameGrid.getSelectionModel().getSelectedCell();
        if (cell == null) {
            Msg.info('error', '��ѡ������!');
            return false;
        } else {
            var record = StkSysAppParameGrid.getStore().getAt(cell[0]);
            var RowId = record.get('RowId');
            if (RowId != '') {
                Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?', function (btn) {
                    if (btn == 'yes') {
                        var mask = ShowLoadMask(Ext.getBody(), '���������Ժ�...');
                        Ext.Ajax.request({
                            url: StkSysAppParameGridUrl + '?actiontype=deleteParame&rowid=' + RowId,
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
                                    StkSysAppParameGridDs.load({ params: { StkSysAppId: StkSysAppId } });
                                } else {
                                    Msg.info('error', 'ɾ��ʧ��!');
                                }
                            },
                            scope: this
                        });
                    }
                });
            } else {
                Msg.info('error', '�����д�,û��RowId!');
            }
        }
    }
});

//���
StkSysAppParameGrid = new Ext.grid.EditorGridPanel({
    store: StkSysAppParameGridDs,
    cm: StkSysAppParameGridCm,
    trackMouseOver: true,
    height: 690,
    stripeRows: true,
    sm: new Ext.grid.CellSelectionModel({}),
    loadMask: true,
    tbar: [addStkSysAppParame, '-', saveStkSysAppParame, '-', deleteStkSysAppParame],
    clicksToEdit: 1
});

StkSysAppParameGrid.on('beforeedit', function (e) {
    if (e.field == 'Code') {
        if ((e.record.get('RowId') != null) & (e.record.get('RowId') != '')) {
            e.cancel = true; //�����޸�����
        }
    }
});

//=========================Ӧ��ϵͳ��������=============================

//=========================Ӧ��ϵͳ����ֵ����===========================
var typeStore = new Ext.data.SimpleStore({
    fields: ['key', 'keyValue'],
    data: [
        ['G', '��ȫ��'],
        ['L', '����'],
        ['U', '��Ա'],
        ['D', 'ȫԺ']
    ]
});

var typeField = new Ext.form.ComboBox({
    id: 'typeField',
    width: 200,
    listWidth: 200,
    allowBlank: true,
    store: typeStore,
    value: '', // Ĭ��ֵ""
    valueField: 'key',
    displayField: 'keyValue',
    emptyText: '',
    triggerAction: 'all',
    emptyText: '',
    minChars: 1,
    pageSize: 10,
    mode: 'local',
    selectOnFocus: true,
    forceSelection: true,
    editable: true
});

var PointerStore = new Ext.data.Store({
    proxy: '',
    reader: new Ext.data.JsonReader(
        {
            totalProperty: 'results',
            root: 'rows'
        },
        ['Description', 'RowId']
    )
});

var PointerField = new Ext.form.ComboBox({
    fieldLabel: '����ֵ',
    id: 'PointerField',
    name: 'PointerField',
    anchor: '90%',
    width: 120,
    store: PointerStore,
    valueField: 'RowId',
    displayField: 'Description',
    allowBlank: true,
    triggerAction: 'all',
    emptyText: '����ֵ...',
    selectOnFocus: true,
    forceSelection: true,
    minChars: 1,
    pageSize: 999,
    listWidth: 250,
    valueNotFoundText: '',
    listeners: {
        specialKey: function (field, e) {
            if (e.getKey() == Ext.EventObject.ENTER) {
                StkSysAppParameValueGrid.startEditing(StkSysAppParameValueGridDs.getCount() - 1, 3);
            }
        }
    }
});

PointerField.on('beforequery', function (e) {
    this.store.removeAll();
    var rowIndex = StkSysAppParameValueGrid.getSelectionModel().getSelectedCell()[0];
    var record = StkSysAppParameValueGrid.store.getAt(rowIndex);
    var type = record.get('Type');
    var hospRowID = record.get('HospDr');
    this.store.setBaseParam('Type', type);
    this.store.setBaseParam('Group', GroupId);
    this.store.setBaseParam('filter', this.getRawValue());
    this.store.setBaseParam('HospRowId', hospRowID);
    this.store.proxy = new Ext.data.HttpProxy({ url: 'dhcst.orgutil.csp?actiontype=GetSSPPoint', method: 'POST' });
    this.store.load({ params: { start: 0, limit: 999 } });
});
HospStore.load();
var Hosp = new Ext.form.ComboBox({
    fieldLabel: 'ҽԺ',
    id: 'Hosp',
    name: 'Hosp',
    anchor: '90%',
    width: 120,
    store: HospStore,
    valueField: 'RowId',
    displayField: 'Description',
    allowBlank: true,
    triggerAction: 'all',
    emptyText: 'ҽԺ...',
    selectOnFocus: true,
    forceSelection: true,
    minChars: 1,
    pageSize: 999,
    listWidth: 250,
    valueNotFoundText: '',
    listeners: {
        specialKey: function (field, e) {
            if (e.getKey() == Ext.EventObject.ENTER) {
                addRow();
            }
        },
        select: function (combo) {
            // ѡ��Ժ��,�������ֵ
            var cell = StkSysAppParameValueGrid.getSelectionModel().getSelectedCell();
            var row = cell[0];
            var rowData = StkSysAppParameValueGrid.getStore().getAt(row);
			if (rowData.get("Type")!='D'){
				rowData.set('Pointer', '');
				typeField.load();
			}
            
        }
    }
});

typeField.on('select', function (combo) {
    Type = combo.getValue();
});

var StkSysAppParameValueGrid = '';

function addRow() {
    // �ϸ����RpRuleÿ��ֻ��һ��
    var cell = StkSysAppGrid.getSelectionModel().getSelectedCell();
    var selectdata = StkSysAppGrid.getStore().getAt(cell[0]);
    var selectcode = selectdata.get('Code');
    var Type = '';
    TypeName = '';
    Pointer = '';
    PointerName = '';
    if (selectcode == 'DHCSTCOMMON') {
        Type = 'D';
        TypeName = 'ȫԺ';
        Pointer = 'DHC';
        PointerName = 'DHC';
        var propCell = StkSysAppParameGrid.getSelectionModel().getSelectedCell();
        var propSelectData = StkSysAppParameGridDs.getAt(propCell[0]);
        var propCode = propSelectData.get('Code');
        if (propCode == 'RpRule') {
            var rowCount = StkSysAppParameValueGridDs.getCount();
            for (var rowI = 0; rowI < rowCount; rowI++) {
                var rowData = StkSysAppParameValueGridDs.data.items[rowI];
                if (rowData.get('RowId') == '') {
                    Msg.info('warning', '�Ѵ����½���,�뱣���������');
                    return;
                }
            }
        }
    }

    var rec = Ext.data.Record.create([
        {
            name: 'Parref',
            type: 'int'
        },
        {
            name: 'RowId',
            type: 'int'
        },
        {
            name: 'Type',
            type: 'string'
        },
        {
            name: 'TypeName',
            type: 'string'
        },
        {
            name: 'Pointer',
            type: 'string'
        },
        {
            name: 'PointerName',
            type: 'string'
        },
        {
            name: 'Value',
            type: 'string'
        },
        {
            name: 'ValueCipher',
            type: 'string'
        },
        {
            name: 'HospDr',
            type: 'string'
        },
        {
            name: 'HospName',
            type: 'string'
        },
        {
            name: 'StDate',
            type: 'date'
        }
    ]);

    var MXRec = new rec({
        ParRef: '',
        RowId: '',
        Type: Type,
        TypeName: TypeName,
        Pointer: Pointer,
        PointerName: PointerName,
        Value: '',
        HospDr: '',
        HospName: '',
        StDate: '',
        ValueCipher: ''
    });

    StkSysAppParameValueGridDs.add(MXRec);
    var starteditcol = 1;
    if (selectcode == 'DHCSTCOMMON') {
        starteditcol = 3;
    }
    StkSysAppParameValueGrid.startEditing(StkSysAppParameValueGridDs.getCount() - 1, starteditcol);
}

//��������Դ
var StkSysAppParameValueGridUrl = 'dhcst.stksysappparameaction.csp';
var StkSysAppParameValueGridProxy = new Ext.data.HttpProxy({ url: StkSysAppParameValueGridUrl, method: 'GET' });
var StkSysAppParameValueGridDs = new Ext.data.Store({
    proxy: StkSysAppParameValueGridProxy,
    reader: new Ext.data.JsonReader({
        totalProperty: 'results',
        root: 'rows',
        fields: [
            { name: 'ParRef' },
            { name: 'RowId' },
            { name: 'Type' },
            { name: 'TypeName' },
            { name: 'Pointer' },
            { name: 'PointerName' },
            { name: 'Value' },
            { name: 'ValueCipher' },
            { name: 'HospDr' },
            { name: 'HospName' },
            { name: 'StDate', type: 'date', dateFormat: App_StkDateFormat }
        ]
    }),
    pruneModifiedRecords: true,
    remoteSort: false
});

//ģ��
var StkSysAppParameValueGridCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
    {
        header: 'ҽԺ',
        dataIndex: 'HospDr',
        width: 250,
        align: 'left',
        sortable: true,
        //editor:new Ext.grid.GridEditor(Hosp),
        //renderer:Ext.util.Format.comboRenderer(Hosp)
        renderer: Ext.util.Format.comboRenderer2(Hosp, 'HospDr', 'HospName'),
        editor: new Ext.grid.GridEditor(Hosp),
		menuDisabled:true
    },
    {
        header: '����',
        dataIndex: 'Type',
        width: 120,
        align: 'left',
        sortable: true,
        editor: new Ext.grid.GridEditor(typeField),
        renderer: Ext.util.Format.comboRenderer(typeField),
		menuDisabled:true
    },
    {
        header: '����ֵ',
        dataIndex: 'Pointer',
        width: 200,
        align: 'left',
        sortable: true,
        editor: new Ext.grid.GridEditor(PointerField),
        renderer: Ext.util.Format.comboRenderer2(PointerField, 'Pointer', 'PointerName'),
		menuDisabled:true
    },
    {
        header: '����ֵ',
        dataIndex: 'Value',
        width: 150,
        align: 'left',
        sortable: true,
        editor: new Ext.form.TextField({
            id: 'valueField',
            allowBlank: false,
            listeners: {
                specialKey: function (field, e) {
                    var keyCode = e.getKey();
                    if (keyCode == e.ENTER) {
                        StkSysAppParameValueGrid.startEditing(StkSysAppParameValueGridDs.getCount() - 1, 4);
                    }
                }
            }
        }),
		menuDisabled:true
    },
    {
        header: '����ֵ',
        dataIndex: 'ValueCipher',
        width: 150,
        align: 'left',
        sortable: true,
        renderer: function (value) {
            value = value || '';
            return value.replace(/./g, '��');
        },
        editor: new Ext.form.TextField({
            id: 'valueCipherField',
            allowBlank: false,
            inputType: 'password',
            listeners: {
                specialKey: function (field, e) {
                    var keyCode = e.getKey();
                    if (keyCode == e.ENTER) {
                        StkSysAppParameValueGrid.startEditing(StkSysAppParameValueGridDs.getCount() - 1, 4);
                    }
                }
            }
        }),
		menuDisabled:true
    },
    {
        header: '��Ч����',
        dataIndex: 'StDate',
        width: 100,
        align: 'center',
        sortable: true,
        hidden: true,
        renderer: Ext.util.Format.dateRenderer(App_StkDateFormat), //App_StkDateFormat
        editor: new Ext.ux.DateField({
            selectOnFocus: true,
            allowBlank: false,
            listeners: {
                specialkey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        var expDate = field.getValue();
                        var nowdate = new Date();

                        if (expDate.format('Y-m-d') <= nowdate.format('Y-m-d')) {
                            Msg.info('warning', '��Ч���ڲ���С�ڻ���ڵ�ǰ����!');
                            return;
                        }
                    }
                }
            }
        }),
		menuDisabled:true
    }
]);

//��ʼ��Ĭ��������
StkSysAppParameValueGridCm.defaultSortable = true;

var addStkSysAppParameValue = new Ext.Toolbar.Button({
    text: '�½�',
    tooltip: '�½�',
    iconCls: 'page_add',
    width: 70,
    height: 30,
    handler: function () {
	    var cell = StkSysAppParameGrid.getSelectionModel().getSelectedCell();
        if (cell == null || StkSysAppParameId === '') {
            Msg.info('warning', '��ѡ���������!');
            return false;
        } 
 		addRow();

    }
});

var saveStkSysAppParameValue = new Ext.Toolbar.Button({
    text: '����',
    tooltip: '����',
    width: 70,
    height: 30,
    iconCls: 'page_save',
    handler: function () {
        var cipherFlag = IfValueCipher();
        var propCell = StkSysAppParameGrid.getSelectionModel().getSelectedCell();
        var propSelectData = StkSysAppParameGridDs.getAt(propCell[0]);
        var propCode = propSelectData.get('Code');
        //��ȡ���е��¼�¼
        if (StkSysAppParameValueGrid.activeEditor != null) {
            StkSysAppParameValueGrid.activeEditor.completeEdit();
        }
        var mr = StkSysAppParameValueGridDs.getModifiedRecords();
        var data = '';
        for (var i = 0; i < mr.length; i++) {
            var value = cipherFlag === false ? mr[i].data['Value'] : mr[i].data['ValueCipher'];
            var rowid = mr[i].get('RowId');
            var type = mr[i].data['Type'];
            var pointer = mr[i].data['Pointer'];
            var hosp = mr[i].data['HospDr'];
            var stDate = Ext.util.Format.date(mr[i].data['StDate'], App_StkDateFormat);
            if (value == '') {
                Msg.info('warning', '����ֵ����Ϊ��!');
                return;
            }
            //if (rowid==""){Msg.info("warning","���Ͳ���Ϊ��!");return;};
            if (pointer == '') {
                Msg.info('warning', '����ֵ����Ϊ��!');
                return;
            }
            if (hosp == '') {
                Msg.info('warning', 'ҽԺ����Ϊ��!');
                return;
            }
            if (propCode == 'RpRule') {
                if (['1', '2', '3'].indexOf(value) < 0) {
                    Msg.info('warning', '���۹������Ϊ1��2��3�е�һ��');
                    return;
                }
            }
            if (type == '') {
                Msg.info('warning', '���Ͳ���Ϊ��!');
                return;
            }

            if (StkSysAppParameId != '' && value != '' && pointer != '') {
                var dataRow = rowid + '^' + StkSysAppParameId + '^' + type + '^' + pointer + '^' + value + '^' + hosp + '^' + stDate;
                if (data == '') {
                    data = dataRow;
                } else {
                    data = data + xRowDelim() + dataRow;
                }
            }
        }

        if (data != '') {
            var mask = ShowLoadMask(Ext.getBody(), '���������Ժ�...');
            Ext.Ajax.request({
                url: StkSysAppParameValueGridUrl + '?actiontype=saveParameValue',
                params: { data: data },
                failure: function (result, request) {
                    mask.hide();
                    Msg.info('error', '������������!');
                },
                success: function (result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    mask.hide();
                    if (jsonData.success == 'true') {
                        data = '';
                        Msg.info('success', '����ɹ�!');
                        StkSysAppParameValueGridDs.load({ params: { StkSysAppParameId: StkSysAppParameId, groupId: GroupId } });
                    } else {
                        if (jsonData.info == 'RepRec') {
                            data = '';
                            Msg.info('error', '��¼�ظ�!');
                        } else {
                            data = '';
                            var saveRet = jsonData.info;
                            if (saveRet.indexOf('^') > 0) {
                                Msg.info('warning', saveRet.split('^')[1]);
                            } else {
                                Msg.info('error', '����ʧ��!' + saveRet);
                            }
                        }
                    }
                },
                scope: this
            });
        } else {
            Msg.info('error', 'û���޸Ļ����������!');
        }
    }
});

var deleteStkSysAppParameValue = new Ext.Toolbar.Button({
    text: 'ɾ��',
    tooltip: 'ɾ��',
    width: 70,
    height: 30,
    iconCls: 'page_delete',
    handler: function () {
        var cell = StkSysAppParameValueGrid.getSelectionModel().getSelectedCell();
        if (cell == null) {
            Msg.info('error', '��ѡ������!');
            return false;
        } else {
            var record = StkSysAppParameValueGrid.getStore().getAt(cell[0]);
            var RowId = record.get('RowId');
            if (RowId != '') {
                Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?', function (btn) {
                    if (btn == 'yes') {
                        var mask = ShowLoadMask(Ext.getBody(), '���������Ժ�...');
                        Ext.Ajax.request({
                            url: StkSysAppParameValueGridUrl + '?actiontype=deleteParameValue&rowid=' + RowId,
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
                                    StkSysAppParameValueGridDs.load({ params: { StkSysAppParameId: StkSysAppParameId, groupId: GroupId } });
                                } else {
                                    Msg.info('error', 'ɾ��ʧ��!');
                                }
                            },
                            scope: this
                        });
                    }
                });
            } else {
                Msg.info('error', '�����д�,û��RowId!');
            }
        }
    }
});

//���
StkSysAppParameValueGrid = new Ext.grid.EditorGridPanel({
    store: StkSysAppParameValueGridDs,
    cm: StkSysAppParameValueGridCm,
    trackMouseOver: true,
    height: 690,
    stripeRows: true,
    sm: new Ext.grid.CellSelectionModel({}),
    loadMask: true,
    tbar: [addStkSysAppParameValue, '-', saveStkSysAppParameValue, '-', deleteStkSysAppParameValue],
    clicksToEdit: 1
});
StkSysAppParameValueGrid.on('beforeedit', function (e) {
    var cell = StkSysAppGrid.getSelectionModel().getSelectedCell();
    var selectdata = StkSysAppGrid.getStore().getAt(cell[0]);
    var selectcode = selectdata.get('Code');
    if (selectcode == 'DHCSTCOMMON') {
        if (e.field == 'Type' || e.field == 'Pointer') {
            e.cancel = true;
        }
        var propCell = StkSysAppParameGrid.getSelectionModel().getSelectedCell();
        var propSelectdata = StkSysAppParameGrid.getStore().getAt(propCell[0]);
        // ��ȡ��ǰ����
        var rowId = e.record.get('RowId') || '';
        if (rowId != '' && propSelectdata.get('Code') == 'RpRule') {
            e.cancel = true;
        }
    }
});
//=========================Ӧ��ϵͳ����ֵ����===========================

//=============Ӧ��ϵͳ������Ӧ��ϵͳ�������ö�������===================
StkSysAppGrid.on('rowclick', function (grid, rowIndex, e) {
    var selectedRow = StkSysAppGridDs.data.items[rowIndex];
    StkSysAppId = selectedRow.data['RowId'];
    StkSysAppParameGridDs.proxy = new Ext.data.HttpProxy({ url: StkSysAppParameGridUrl + '?actiontype=selectParame', method: 'GET' });
    StkSysAppParameGridDs.load({ params: { StkSysAppId: StkSysAppId } });
    StkSysAppParameValueGrid.getStore().removeAll();
});
//=============Ӧ��ϵͳ������Ӧ��ϵͳ�������ö�������===================

//=============ϵͳ����������ϵͳ����ֵ���ö�������=====================
StkSysAppParameGrid.on('rowclick', function (grid, rowIndex, e) {
    var selectedRow = StkSysAppParameGridDs.data.items[rowIndex];
    var colIndex = GetColIndex(StkSysAppParameValueGrid, 'StDate');
    if (selectedRow.data['Code'] == 'RpRule') {
        // �����Ƽ۸�ʽ��ʾ����ά��
        StkSysAppParameValueGrid.getColumnModel().setHidden(colIndex, false);
    } else {
        StkSysAppParameValueGrid.getColumnModel().setHidden(colIndex, true);
    }
    var valueIndex = GetColIndex(StkSysAppParameValueGrid, 'Value');
    var valueCipherIndex = GetColIndex(StkSysAppParameValueGrid, 'ValueCipher');
    if (IfValueCipher() === true) {
        StkSysAppParameValueGrid.getColumnModel().setHidden(valueIndex, true);
        StkSysAppParameValueGrid.getColumnModel().setHidden(valueCipherIndex, false);
    } else {
        StkSysAppParameValueGrid.getColumnModel().setHidden(valueIndex, false);
        StkSysAppParameValueGrid.getColumnModel().setHidden(valueCipherIndex, true);
    }
    StkSysAppParameId = selectedRow.data['RowId'];
    StkSysAppParameValueGridDs.proxy = new Ext.data.HttpProxy({ url: StkSysAppParameValueGridUrl + '?actiontype=selectParameValue', method: 'GET' });
    StkSysAppParameValueGridDs.load({ params: { StkSysAppParameId: StkSysAppParameId, groupId: GroupId } });
});

function IfValueCipher() {
    var propCell = StkSysAppParameGrid.getSelectionModel().getSelectedCell();
    var propSelectData = StkSysAppParameGridDs.getAt(propCell[0]);
    var propDesc = propSelectData.get('Desc');
    if (propDesc.indexOf('����') >= 0) {
        return true;
    }
    return false;
}

function GetSelectedAppCode(){
    var cell = StkSysAppGrid.getSelectionModel().getSelectedCell();
    var selectdata = StkSysAppGrid.getStore().getAt(cell[0]);
    var selectcode = selectdata.get('Code');
	return selectcode;
}
//===========ģ����ҳ��=================================================
Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: [
            // create instance immediately
            {
                region: 'west',
                collapsible: true,
                title: 'Ӧ�ó���',
                split: true,
                width: 350, // give east and west regions a width
                minSize: 200,
                maxSize: 400,
                margins: '0 5 0 0',
                layout: 'fit', // specify layout manager for items
                items: StkSysAppGrid
            },
            {
                region: 'center',
                title: '',
                layout: 'fit', // specify layout manager for items
                items: StkSysAppParameGrid
            },
            {
                region: 'south',
                split: true,
                height: 250,
                minSize: 100,
                maxSize: 250,
                //collapsible: true,
                title: '',
                layout: 'fit', // specify layout manager for items
                items: StkSysAppParameValueGrid
            }
        ],
        renderTo: 'mainPanel'
    });
});
//===========ģ����ҳ��=================================================
