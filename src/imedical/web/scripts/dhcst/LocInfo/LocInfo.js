// ����:������չ��Ϣ
// ��д����:2012-05-23

//=========================������չ��Ϣ=============================

var allLocStore = new Ext.data.Store({
    proxy: new Ext.data.HttpProxy({
        url: DictUrl + 'orgutil.csp?actiontype=DeptLoc&start=0&limit=9999'
    }),
    reader: new Ext.data.JsonReader(
        {
            totalProperty: 'results',
            root: 'rows'
        },
        ['Description', 'RowId']
    )
});
allLocStore.load();

var conditionCodeField = new Ext.form.TextField({
    id: 'conditionCode',
    fieldLabel: '����',
    allowBlank: true,
    //width:180,
    listWidth: 180,
    emptyText: '����...',
    anchor: '90%',
    selectOnFocus: true
});

var conditionDescField = new Ext.form.TextField({
    id: 'conditionDesc',
    fieldLabel: '����',
    allowBlank: true,
    //width:150,
    listWidth: 150,
    emptyText: '����...',
    anchor: '90%',
    selectOnFocus: true
});

var LocInfoTypeStore = new Ext.data.SimpleStore({
    fields: ['key', 'keyValue'],
    data: [
        ['', 'ȫ��'],
        ['R', 'ҩ��'],
        ['I', 'סԺҩ��'],
        ['O', '����ҩ��'],
        ['A', '��е����'],
        ['G', '����ҩ��'],
        ['E', '����']
    ]
});

var LocInfoTypeField = new Ext.form.ComboBox({
    id: 'LocInfoType',
    fieldLabel: '�ⷿ���',
    anchor: '90%',
    //width:222,
    listWidth: 222,
    allowBlank: true,
    store: LocInfoTypeStore,
    value: '', // Ĭ��ֵ"ȫ����ѯ"
    valueField: 'key',
    displayField: 'keyValue',
    emptyText: '�������...',
    triggerAction: 'all',
    emptyText: '',
    minChars: 1,
    selectOnFocus: true,
    forceSelection: true,
    editable: true,
    mode: 'local'
});

var conditionLocGField = new Ext.ux.ComboBox({
    id: 'conditionLocG',
    fieldLabel: '������',
    anchor: '90%',
    //width:222,
    listWidth: 222,
    allowBlank: true,
    store: StkLocGrpStore,
    valueField: 'RowId',
    displayField: 'Description',
    emptyText: '������...',
    filterName: 'str'
});

var conditionItemGField = new Ext.ux.ComboBox({
    id: 'conditionItemG',
    anchor: '90%',
    fieldLabel: '��Ŀ��',
    //width:220,
    listWidth: 220,
    allowBlank: true,
    store: StkItemGrpStore,
    valueField: 'RowId',
    displayField: 'Description',
    emptyText: '��Ŀ��...',
    filterName: 'str'
});

var conditionMainLocField = new Ext.ux.LocComboBox({
    id: 'conditionMainLoc',
    anchor: '90%',
    fieldLabel: '֧�����',
    emptyText: '֧�����...',
    defaultLoc: ''
});

var activeField = new Ext.form.Checkbox({
    id: 'active',
    anchor: '90%',
    fieldLabel: '�����ʶ',
    allowBlank: false,
    checked: true
});

var ActiveF = new Ext.grid.CheckColumn({
    header: '�����ʶ',
    dataIndex: 'Active',
    //width:150,
    anchor: '90%',
    //checked:true,
    sortable: true,
    renderer: function (v, p, record) {
        p.css += ' x-grid3-check-col-td';
        return '<div class="x-grid3-check-col' + (v == 'Y' || v == true ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
    }
});

var LigG = new Ext.ux.ComboBox({
    fieldLabel: '��Ŀ��',
    id: 'LigG',
    name: 'LigG',
    anchor: '90%',
    width: 120,
    store: StkItemGrpStore,
    valueField: 'RowId',
    displayField: 'Description',
    emptyText: '��Ŀ��...'
});

var MainLocCb = new Ext.form.ComboBox({
    fieldLabel: '֧�����',
    id: 'MainLoc',
    name: 'MainLoc',
    anchor: '90%',
    width: 120,
    store: allLocStore,
    valueField: 'RowId',
    displayField: 'Description',
    //allowBlank : false,
    triggerAction: 'all',
    emptyText: '֧�����...',
    selectOnFocus: true,
    forceSelection: true,
    minChars: 1,
    pageSize: 9999,
    listWidth: 250,
    valueNotFoundText: '',
    listeners: {
        beforequery: function (e) {
            this.store.removeAll(); //load֮ǰremoveԭ��¼���������׳���
            var filter = this.getRawValue();
            this.store.setBaseParam('locDesc', filter);
            this.store.load({ params: { start: 0, limit: 9999 } });
        }
    }
});
//allLocStore.load();
function rendererMainLoc(value, p, r) {
    var combo = Ext.getCmp('MainLoc');
    var index = allLocStore.find(combo.valueField, value);
    var record = allLocStore.getAt(index);
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
function rendererLigG(value, p, r) {
    var combo = Ext.getCmp('LigGList');
    var index = LigGStoreList.find(combo.valueField, value);
    var record = LigGStoreList.getAt(index);
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

var LigGStoreList = new Ext.data.Store({
    proxy: new Ext.data.HttpProxy({
        url: 'dhcst.orgutil.csp?actiontype=StkItemGrp&start=0&limit=999'
    }),
    reader: new Ext.data.JsonReader(
        {
            totalProperty: 'results',
            root: 'rows'
        },
        ['Description', 'RowId']
    )
});

LigGStoreList.load();
var LigGList = new Ext.form.ComboBox({
    fieldLabel: '��Ŀ��',
    id: 'LigGList',
    name: 'LigGList',
    anchor: '90%',
    width: 120,
    store: LigGStoreList,
    valueField: 'RowId',
    displayField: 'Description',
    allowBlank: false,
    triggerAction: 'all',
    emptyText: '��Ŀ��...',
    selectOnFocus: true,
    forceSelection: true,
    minChars: 1,
    //pageSize : 10,
    listWidth: 250,
    valueNotFoundText: ''
});

///����
var DescIdcb = new Ext.form.ComboBox({
    fieldLabel: '����',
    id: 'DescId',
    name: 'DescId',
    anchor: '90%',
    width: 120,
    store: allLocStore,
    valueField: 'RowId',
    displayField: 'Description',
    //allowBlank : false,
    triggerAction: 'all',
    emptyText: '����...',
    selectOnFocus: true,
    forceSelection: true,
    minChars: 1,
    pageSize: 9999,
    listWidth: 250,
    valueNotFoundText: '',
    listeners: {
        select: function (combo) {
            var cell = LocInfoGrid.getSelectionModel().getSelectedCell();
            var record = LocInfoGrid.getStore().getAt(cell[0]);
            var value = combo.getValue(); //Ŀǰѡ��ĵ�λid
        },
        beforequery: function (e) {
            this.store.removeAll(); //load֮ǰremoveԭ��¼���������׳���
            var filter = this.getRawValue();
            this.store.setBaseParam('locDesc', filter);
            this.store.load({ params: { start: 0, limit: 9999 } });
        }
    }
});

var SlgG = new Ext.form.ComboBox({
    fieldLabel: '������',
    id: 'SlgG',
    name: 'SlgG',
    anchor: '90%',
    width: 120,
    store: StkLocGrpStore,
    valueField: 'RowId',
    displayField: 'Description',
    allowBlank: true,
    triggerAction: 'all',
    emptyText: '������...',
    selectOnFocus: true,
    forceSelection: true,
    minChars: 1,
    //pageSize : 10,
    listWidth: 250,
    valueNotFoundText: ''
});

function rendererSlgG(value, p, r) {
    var combo = Ext.getCmp('SlgGList');
    var index = SlgGStoreList.find(combo.valueField, value);
    var record = SlgGStoreList.getAt(index);
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

var SlgGStoreList = new Ext.data.Store({
    proxy: new Ext.data.HttpProxy({
        url: 'dhcst.orgutil.csp?actiontype=StkLocGrp&start=0&limit=999'
    }),
    reader: new Ext.data.JsonReader(
        {
            totalProperty: 'results',
            root: 'rows'
        },
        ['Description', 'RowId']
    )
});

SlgGStoreList.load();
var SlgGList = new Ext.form.ComboBox({
    fieldLabel: '������',
    id: 'SlgGList',
    name: 'SlgGList',
    anchor: '90%',
    width: 120,
    store: SlgGStoreList,
    valueField: 'RowId',
    displayField: 'Description',
    allowBlank: false,
    triggerAction: 'all',
    emptyText: '������...',
    selectOnFocus: true,
    forceSelection: true,
    minChars: 1,
    //pageSize : 10,
    listWidth: 250,
    valueNotFoundText: ''
});

var LocInfoGrid = '';
//��������Դ
var LocInfoGridUrl = 'dhcst.locinfoaction.csp';
var LocInfoGridProxy = new Ext.data.HttpProxy({ url: LocInfoGridUrl + '?actiontype=query', method: 'POST' });
var LocInfoGridDs = new Ext.data.Store({
    proxy: LocInfoGridProxy,
    reader: new Ext.data.JsonReader(
        {
            root: 'rows',
            totalProperty: 'results',
            pageSize: 35
        },
        [
            { name: 'Code' },
            { name: 'DescId' },
            { name: 'Desc' },
            { name: 'LigId' },
            { name: 'LigDesc' },
            { name: 'SlgId' },
            { name: 'SlgDesc' },
            { name: 'Type' },
            { name: 'MainLoc' },
            { name: 'MainLocDesc' },
            { name: 'Active' } //,type:'bool'
        ]
    ),
    remoteSort: false
});

//ģ��
var LocInfoGridCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
    {
        header: '����',
        dataIndex: 'Code',
        width: 150,
        align: 'left',
        sortable: true
    },
    {
        header: '����',
        dataIndex: 'DescId',
        width: 300,
        align: 'left',
        sortable: true,
        renderer: Ext.util.Format.comboRenderer2(DescIdcb, 'DescId', 'Desc'),
        editor: new Ext.grid.GridEditor(DescIdcb)
    },
    {
        header: '������',
        dataIndex: 'SlgId',
        width: 150,
        align: 'left',
        sortable: true,
        renderer: Ext.util.Format.comboRenderer2(SlgG, 'SlgId', 'SlgDesc'),
        editor: new Ext.grid.GridEditor(SlgG)
    },
    {
        header: '��Ŀ��',
        dataIndex: 'LigId',
        width: 150,
        align: 'left',
        sortable: true,
        renderer: Ext.util.Format.comboRenderer2(LigG, 'LigId', 'LigDesc'),
        editor: new Ext.grid.GridEditor(LigG)
    },
    {
        header: '�ⷿ���',
        dataIndex: 'Type',
        width: 150,
        align: 'left',
        sortable: true,
        renderer: function (v, p, record) {
            if (v == 'R') return 'ҩ��';
            if (v == 'I') return 'סԺҩ��';
            if (v == 'O') return '����ҩ��';
            if (v == 'A') return '��е����';
            if (v == 'G') return '����ҩ��';
            if (v == 'E') return '����';
        },
        editor: new Ext.form.ComboBox({
            id: 'LocInfoField',
            width: 200,
            listWidth: 200,
            allowBlank: true,
            store: LocInfoTypeStore,
            value: 'R', // Ĭ��ֵ"ҩ��"
            valueField: 'key',
            displayField: 'keyValue',
            emptyText: '',
            triggerAction: 'all',
            emptyText: '',
            minChars: 1,
            //pageSize:10,
            mode: 'local',
            selectOnFocus: true,
            forceSelection: true,
            editable: true
        })
    },
    {
        header: '֧�����',
        dataIndex: 'MainLoc',
        width: 150,
        align: 'left',
        sortable: true,
        renderer: Ext.util.Format.comboRenderer2(MainLocCb, 'MainLoc', 'MainLocDesc'),
        editor: new Ext.grid.GridEditor(MainLocCb)
    }
    //ActiveF
]);

//LocInfoGrid.on('beforeedit',function(e){
//if(e.field=="DescId"){
//	var store=Ext.getCmp('DescIdcb').getStore();
//	addComboData(store,e.record.get('DescId'),e.record.get('Desc'));
//}
//});
var AddDetailBT = new Ext.Button({
    text: '����һ��',
    tooltip: '',
    iconCls: 'page_add',
    handler: function () {
        addDetailRow();
    }
});
function addDetailRow() {
    // �ж��Ƿ��Ѿ��������
    var rowCount = LocInfoGrid.getStore().getCount();
    var invNo = '';
    var invDate = '';
    var retReason = '';
    if (rowCount > 0) {
        var rowData = LocInfoGridDs.data.items[rowCount - 1];
        var data = rowData.get('Code');
        if (data == null || data.length <= 0) {
            var col = GetColIndex(LocInfoGrid, 'DescId');
            LocInfoGrid.startEditing(LocInfoGridDs.getCount() - 1, col);
            return;
        }
    }
    var rec = Ext.data.Record.create([
        { name: 'Code', type: 'string' },
        { name: 'DescId', type: 'string' },
        { name: 'SlgId', type: 'string' },
        { name: 'LigId', type: 'string' },
        { name: 'Type', type: 'string' },
        { name: 'MainLoc', type: 'string' },
        { name: 'Active', type: 'bool' }
    ]);
    var NewRec = new rec({
        Code: '',
        DescId: '',
        SlgId: '',
        LigId: '',
        Type: '',
        MainLoc: '',
        Active: true
    });

    LocInfoGridDs.add(NewRec);
    var colIndex = GetColIndex(LocInfoGrid, 'DescId');
    LocInfoGrid.getSelectionModel().select(LocInfoGridDs.getCount() - 1, colIndex);
    LocInfoGrid.startEditing(LocInfoGridDs.getCount() - 1, colIndex);
}
//��ʼ��Ĭ��������
LocInfoGridCm.defaultSortable = true;

var clearLocInfo = new Ext.Toolbar.Button({
    text: '���',
    tooltip: '���',
    iconCls: 'page_clearscreen',
    width: 70,
    height: 30,
    handler: function () {
        Ext.getCmp('conditionCode').setValue('');
        Ext.getCmp('conditionDesc').setValue('');
        Ext.getCmp('LocInfoType').setValue('');
        //        Ext.getCmp('LocInfoType').setRawValue("");
        Ext.getCmp('conditionLocG').setValue('');
        Ext.getCmp('conditionLocG').setRawValue('');
        Ext.getCmp('conditionItemG').setValue('');
        Ext.getCmp('conditionItemG').setRawValue('');
        Ext.getCmp('conditionMainLoc').setValue('');
        Ext.getCmp('active').setValue(true);

        //var filterStr = (Ext.getCmp('conditionCode').getValue()==undefined?"":Ext.getCmp('conditionCode').getValue())+"^"+(Ext.getCmp('conditionDesc').getValue()==undefined?"":Ext.getCmp('conditionDesc').getValue())+"^"+Ext.getCmp('conditionLocG').getValue()+"^"+Ext.getCmp('conditionItemG').getValue()+"^"+Ext.getCmp('LocInfoType').getValue()+"^"+(Ext.getCmp('active').getValue()==true?'Y':'N');
        //LocInfoGridDs.load({params:{start:0,limit:LocInfoPagingToolbar.pageSize,sort:'Rowid',dir:'desc',filterStr:filterStr}});
        LocInfoGrid.getStore().removeAll();
        LocInfoGrid.store.load({ params: { start: 0, limit: 0 } });
        LocInfoGrid.getView().refresh();
    }
});

var findLocInfo = new Ext.Toolbar.Button({
    text: '��ѯ',
    tooltip: '��ѯ',
    iconCls: 'page_find',
    width: 70,
    height: 30,
    handler: function () {
        var code = Ext.getCmp('conditionCode').getValue();
        var desc = Ext.getCmp('conditionDesc').getValue();
        var LocG = Ext.getCmp('conditionLocG').getValue();
        var ItemG = Ext.getCmp('conditionItemG').getValue();
        var type = Ext.getCmp('LocInfoType').getValue();
        var mainLoc = Ext.getCmp('conditionMainLoc').getValue();
        var activeFlag = Ext.getCmp('active').getValue() == true ? 'Y' : 'N';
        var filterStr = code + '^' + desc + '^' + LocG + '^' + ItemG + '^' + type + '^' + activeFlag + '^' + mainLoc;
        LocInfoGridDs.setBaseParam('sort', 'Rowid');
        LocInfoGridDs.setBaseParam('dir', 'desc');
        LocInfoGridDs.setBaseParam('filterStr', filterStr);

        LocInfoGridDs.load({ params: { start: 0, limit: LocInfoPagingToolbar.pageSize } });
    }
});

var saveLocInfo = new Ext.Toolbar.Button({
    text: '����',
    tooltip: '����',
    iconCls: 'page_save',
    width: 70,
    height: 30,
    handler: function () {
        if (LocInfoGrid.activeEditor != null) {
            LocInfoGrid.activeEditor.completeEdit();
        }
        //��ȡ���е��¼�¼
        var mr = LocInfoGridDs.getModifiedRecords();
        var data = '';
        for (var i = 0; i < mr.length; i++) {
            var LlgId = mr[i].data['LigId'];
            var SlgId = mr[i].data['SlgId'];
            var DescId = mr[i].data['DescId'];
            var dataRow = DescId + '^' + LlgId + '^' + SlgId + '^' + mr[i].data['Type'] + '^' + mr[i].data['Active'] + '^' + mr[i].data['MainLoc'];
            if (DescId != '') {
                if (data == '') {
                    data = dataRow;
                } else {
                    data = data + xRowDelim() + dataRow;
                }
            }
        }
        if (data == '') {
            Msg.info('error', 'û���޸Ļ����������!');
            return false;
        } else {
            var filterStr =
                (Ext.getCmp('conditionCode').getValue() == undefined ? '' : Ext.getCmp('conditionCode').getValue()) +
                '^' +
                (Ext.getCmp('conditionDesc').getValue() == undefined ? '' : Ext.getCmp('conditionDesc').getValue()) +
                '^' +
                Ext.getCmp('conditionLocG').getValue() +
                '^' +
                Ext.getCmp('conditionItemG').getValue() +
                '^' +
                Ext.getCmp('LocInfoType').getValue() +
                '^' +
                (Ext.getCmp('active').getValue() == true ? 'Y' : 'N');
            var mask = ShowLoadMask(Ext.getBody(), '���������Ժ�...');
            Ext.Ajax.request({
                url: LocInfoGridUrl + '?actiontype=save',
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
                        LocInfoGridDs.commitChanges();
                        LocInfoGridDs.setBaseParam('sort', 'Rowid');
                        LocInfoGridDs.setBaseParam('dir', 'desc');
                        LocInfoGridDs.setBaseParam('filterStr', filterStr);

                        LocInfoGridDs.load({ params: { start: 0, limit: LocInfoPagingToolbar.pageSize } });
                    } else {
                        Msg.info('error', '����ʧ��!' + jsonData.info);
                    }
                },
                scope: this
            });
        }
    }
});

var formPanel = new Ext.form.FormPanel({
    labelWidth: 60,
    labelAlign: 'right',
    frame: true,
    autoHeight: true,
    tbar: [findLocInfo, '-', saveLocInfo, '-', clearLocInfo],
    items: [
        {
            xtype: 'fieldset',
            title: '��ѯ����',
            layout: 'column',
            style: DHCSTFormStyle.FrmPaddingV,
            items: [
                {
                    columnWidth: 0.33,
                    xtype: 'fieldset',
                    border: false,
                    items: [conditionCodeField, conditionLocGField, conditionMainLocField]
                },
                {
                    columnWidth: 0.33,
                    xtype: 'fieldset',
                    border: false,
                    items: [conditionDescField, conditionItemGField]
                },
                {
                    columnWidth: 0.33,
                    xtype: 'fieldset',
                    border: false,
                    items: [LocInfoTypeField]
                }
            ]
        }
    ]
});

//��ҳ������
var LocInfoPagingToolbar = new Ext.PagingToolbar({
    store: LocInfoGridDs,
    pageSize: PageSize,
    displayInfo: true,
    displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg: 'û�м�¼'
});

//���
LocInfoGrid = new Ext.grid.EditorGridPanel({
    store: LocInfoGridDs,
    cm: LocInfoGridCm,
    trackMouseOver: true,
    region: 'center',
    height: 690,
    stripeRows: true,
    //sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
    sm: new Ext.grid.CellSelectionModel(),
    plugins: ActiveF,
    loadMask: true,
    bbar: LocInfoPagingToolbar,
    clicksToEdit: 1,
	tbar: [AddDetailBT]
});

var HospPanel = InitHospCombo('DHCST_CtLoc',function(combo, record, index){
	HospId = this.value; 
	Ext.getCmp('conditionCode').setValue('');
	Ext.getCmp('conditionDesc').setValue('');
	Ext.getCmp('LocInfoType').setValue('');
	Ext.getCmp('conditionLocG').setValue('');
	Ext.getCmp('conditionLocG').setRawValue('');
	Ext.getCmp('conditionItemG').setValue('');
	Ext.getCmp('conditionItemG').setRawValue('');
	Ext.getCmp('conditionMainLoc').setValue('');
	Ext.getCmp('active').setValue(true);
	allLocStore.reload();
	StkLocGrpStore.reload();
	StkItemGrpStore.reload();
	conditionMainLocField.store.reload();
	findLocInfo.handler();
});
//=========================������չ��Ϣ=============================

//===========ģ����ҳ��=============================================
Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

    var panel = new Ext.Panel({
        title: '������չ��Ϣ',
        activeTab: 0,
        region: 'north',
        items: [formPanel]
    });

    var mainPanel = new Ext.Viewport({
        layout: 'border',
		items:[
			{
				region:'north',
				height:'500px',
				items:[HospPanel,panel]
//				items:[panel]
			},LocInfoGrid
		],
        renderTo: 'mainPanel'
    });
});
//===========ģ����ҳ��=============================================
