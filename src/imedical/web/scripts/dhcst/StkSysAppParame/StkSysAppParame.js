// 名称:参数设置管理
// 编写日期:2012-06-7
// Modify:zdm,2012-07-10,修改界面布局
//=========================定义全局变量=================================
var StkSysAppId = '';
var StkSysAppParameId = '';
var GroupId = session['LOGON.GROUPID'];
var Type = 'G';

//=========================定义全局变量=================================
//=========================应用系统设置=================================
var StkSysAppGrid = '';
//配置数据源
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

//模型
var StkSysAppGridCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
    {
        header: '代码',
        dataIndex: 'Code',
        width: 170,
        align: 'left',
        sortable: true
    },
    {
        header: '名称',
        dataIndex: 'Desc',
        width: 120,
        align: 'left',
        sortable: true
    }
]);

//初始化默认排序功能
StkSysAppGridCm.defaultSortable = true;

//表格
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
//=========================应用系统设置=================================

//=========================应用系统属性设置=============================
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

//配置数据源
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

//模型
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
        header: '名称',
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
        header: '描述',
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
            var title = '描述';
            var tip = value;
            meta.attr = 'ext:qtitle="' + title + '"' + ' ext:qtip="' + tip + '"';
            return value;
        }
    },
    {
        header: '备注',
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
            var title = '备注';
            var tip = value;
            meta.attr = 'ext:qtitle="' + title + '"' + ' ext:qtip="' + tip + '"';
            return value;
        }
    },
    {
        header: '默认值',
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

//初始化默认排序功能
StkSysAppParameGridCm.defaultSortable = true;

var addStkSysAppParame = new Ext.Toolbar.Button({
    text: '新建',
    tooltip: '新建',
    iconCls: 'page_add',
    width: 70,
    height: 30,
    handler: function () {
        if (StkSysAppId != '') {
            addNewMXRow();
        } else {
            Msg.info('error', '请选择应用系统!');
            return false;
        }
    }
});

var saveStkSysAppParame = new Ext.Toolbar.Button({
    text: '保存',
    tooltip: '保存',
    width: 70,
    height: 30,
    iconCls: 'page_save',
    handler: function () {
        //获取所有的新记录
        var mr = StkSysAppParameGridDs.getModifiedRecords();
        var data = '';
        for (var i = 0; i < mr.length; i++) {
            var code = mr[i].data['Code'];
            var rowid = mr[i].data['RowId']; //StkSysAppParameGridDs.getAt(StkSysAppParameGridDs.find('Code',code)).get('RowId');
            var desc = mr[i].data['Desc'];
            var memo = mr[i].data['Memo'];
			var defaultVal = mr[i].data['DefaultVal'];
            if (code == '') {
                Msg.info('warning', '名称不能为空!');
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
            var mask = ShowLoadMask(Ext.getBody(), '处理中请稍候...');
            Ext.Ajax.request({
                url: StkSysAppParameGridUrl + '?actiontype=saveParame',
                params: { data: data },
                failure: function (result, request) {
                    mask.hide();
                    Msg.info('error', '请检查网络连接!');
                },
                success: function (result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    mask.hide();
                    if (jsonData.success == 'true') {
                        data = '';
                        Msg.info('success', '保存成功!');
                        StkSysAppParameGridDs.load({ params: { StkSysAppId: StkSysAppId } });
                    } else {
                        if (jsonData.info == 'RepRec') {
                            data = '';
                            Msg.info('error', '记录重复!');
                        } else {
                            data = '';
                            Msg.info('error', '保存失败!');
                        }
                    }
                },
                scope: this
            });
        } else {
            Msg.info('error', '没有修改或添加新数据!');
        }
    }
});

var deleteStkSysAppParame = new Ext.Toolbar.Button({
    text: '删除',
    tooltip: '删除',
    width: 70,
    height: 30,
    iconCls: 'page_delete',
    handler: function () {
        var cell = StkSysAppParameGrid.getSelectionModel().getSelectedCell();
        if (cell == null) {
            Msg.info('error', '请选择数据!');
            return false;
        } else {
            var record = StkSysAppParameGrid.getStore().getAt(cell[0]);
            var RowId = record.get('RowId');
            if (RowId != '') {
                Ext.MessageBox.confirm('提示', '确定要删除选定的行?', function (btn) {
                    if (btn == 'yes') {
                        var mask = ShowLoadMask(Ext.getBody(), '处理中请稍候...');
                        Ext.Ajax.request({
                            url: StkSysAppParameGridUrl + '?actiontype=deleteParame&rowid=' + RowId,
                            waitMsg: '删除中...',
                            failure: function (result, request) {
                                mask.hide();
                                Msg.info('error', '请检查网络连接!');
                            },
                            success: function (result, request) {
                                var jsonData = Ext.util.JSON.decode(result.responseText);
                                mask.hide();
                                if (jsonData.success == 'true') {
                                    Msg.info('success', '删除成功!');
                                    StkSysAppParameGridDs.load({ params: { StkSysAppId: StkSysAppId } });
                                } else {
                                    Msg.info('error', '删除失败!');
                                }
                            },
                            scope: this
                        });
                    }
                });
            } else {
                Msg.info('error', '数据有错,没有RowId!');
            }
        }
    }
});

//表格
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
            e.cancel = true; //不能修改名称
        }
    }
});

//=========================应用系统属性设置=============================

//=========================应用系统属性值设置===========================
var typeStore = new Ext.data.SimpleStore({
    fields: ['key', 'keyValue'],
    data: [
        ['G', '安全组'],
        ['L', '科室'],
        ['U', '人员'],
        ['D', '全院']
    ]
});

var typeField = new Ext.form.ComboBox({
    id: 'typeField',
    width: 200,
    listWidth: 200,
    allowBlank: true,
    store: typeStore,
    value: '', // 默认值""
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
    fieldLabel: '类型值',
    id: 'PointerField',
    name: 'PointerField',
    anchor: '90%',
    width: 120,
    store: PointerStore,
    valueField: 'RowId',
    displayField: 'Description',
    allowBlank: true,
    triggerAction: 'all',
    emptyText: '类型值...',
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
    fieldLabel: '医院',
    id: 'Hosp',
    name: 'Hosp',
    anchor: '90%',
    width: 120,
    store: HospStore,
    valueField: 'RowId',
    displayField: 'Description',
    allowBlank: true,
    triggerAction: 'all',
    emptyText: '医院...',
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
            // 选择院区,清空类型值
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
    // 严格控制RpRule每次只能一条
    var cell = StkSysAppGrid.getSelectionModel().getSelectedCell();
    var selectdata = StkSysAppGrid.getStore().getAt(cell[0]);
    var selectcode = selectdata.get('Code');
    var Type = '';
    TypeName = '';
    Pointer = '';
    PointerName = '';
    if (selectcode == 'DHCSTCOMMON') {
        Type = 'D';
        TypeName = '全院';
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
                    Msg.info('warning', '已存在新建行,请保存后再新增');
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

//配置数据源
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

//模型
var StkSysAppParameValueGridCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
    {
        header: '医院',
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
        header: '类型',
        dataIndex: 'Type',
        width: 120,
        align: 'left',
        sortable: true,
        editor: new Ext.grid.GridEditor(typeField),
        renderer: Ext.util.Format.comboRenderer(typeField),
		menuDisabled:true
    },
    {
        header: '类型值',
        dataIndex: 'Pointer',
        width: 200,
        align: 'left',
        sortable: true,
        editor: new Ext.grid.GridEditor(PointerField),
        renderer: Ext.util.Format.comboRenderer2(PointerField, 'Pointer', 'PointerName'),
		menuDisabled:true
    },
    {
        header: '参数值',
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
        header: '参数值',
        dataIndex: 'ValueCipher',
        width: 150,
        align: 'left',
        sortable: true,
        renderer: function (value) {
            value = value || '';
            return value.replace(/./g, '●');
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
        header: '生效日期',
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
                            Msg.info('warning', '生效日期不能小于或等于当前日期!');
                            return;
                        }
                    }
                }
            }
        }),
		menuDisabled:true
    }
]);

//初始化默认排序功能
StkSysAppParameValueGridCm.defaultSortable = true;

var addStkSysAppParameValue = new Ext.Toolbar.Button({
    text: '新建',
    tooltip: '新建',
    iconCls: 'page_add',
    width: 70,
    height: 30,
    handler: function () {
	    var cell = StkSysAppParameGrid.getSelectionModel().getSelectedCell();
        if (cell == null || StkSysAppParameId === '') {
            Msg.info('warning', '请选择参数属性!');
            return false;
        } 
 		addRow();

    }
});

var saveStkSysAppParameValue = new Ext.Toolbar.Button({
    text: '保存',
    tooltip: '保存',
    width: 70,
    height: 30,
    iconCls: 'page_save',
    handler: function () {
        var cipherFlag = IfValueCipher();
        var propCell = StkSysAppParameGrid.getSelectionModel().getSelectedCell();
        var propSelectData = StkSysAppParameGridDs.getAt(propCell[0]);
        var propCode = propSelectData.get('Code');
        //获取所有的新记录
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
                Msg.info('warning', '参数值不能为空!');
                return;
            }
            //if (rowid==""){Msg.info("warning","类型不能为空!");return;};
            if (pointer == '') {
                Msg.info('warning', '类型值不能为空!');
                return;
            }
            if (hosp == '') {
                Msg.info('warning', '医院不能为空!');
                return;
            }
            if (propCode == 'RpRule') {
                if (['1', '2', '3'].indexOf(value) < 0) {
                    Msg.info('warning', '定价规则必须为1、2、3中的一种');
                    return;
                }
            }
            if (type == '') {
                Msg.info('warning', '类型不能为空!');
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
            var mask = ShowLoadMask(Ext.getBody(), '处理中请稍候...');
            Ext.Ajax.request({
                url: StkSysAppParameValueGridUrl + '?actiontype=saveParameValue',
                params: { data: data },
                failure: function (result, request) {
                    mask.hide();
                    Msg.info('error', '请检查网络连接!');
                },
                success: function (result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    mask.hide();
                    if (jsonData.success == 'true') {
                        data = '';
                        Msg.info('success', '保存成功!');
                        StkSysAppParameValueGridDs.load({ params: { StkSysAppParameId: StkSysAppParameId, groupId: GroupId } });
                    } else {
                        if (jsonData.info == 'RepRec') {
                            data = '';
                            Msg.info('error', '记录重复!');
                        } else {
                            data = '';
                            var saveRet = jsonData.info;
                            if (saveRet.indexOf('^') > 0) {
                                Msg.info('warning', saveRet.split('^')[1]);
                            } else {
                                Msg.info('error', '保存失败!' + saveRet);
                            }
                        }
                    }
                },
                scope: this
            });
        } else {
            Msg.info('error', '没有修改或添加新数据!');
        }
    }
});

var deleteStkSysAppParameValue = new Ext.Toolbar.Button({
    text: '删除',
    tooltip: '删除',
    width: 70,
    height: 30,
    iconCls: 'page_delete',
    handler: function () {
        var cell = StkSysAppParameValueGrid.getSelectionModel().getSelectedCell();
        if (cell == null) {
            Msg.info('error', '请选择数据!');
            return false;
        } else {
            var record = StkSysAppParameValueGrid.getStore().getAt(cell[0]);
            var RowId = record.get('RowId');
            if (RowId != '') {
                Ext.MessageBox.confirm('提示', '确定要删除选定的行?', function (btn) {
                    if (btn == 'yes') {
                        var mask = ShowLoadMask(Ext.getBody(), '处理中请稍候...');
                        Ext.Ajax.request({
                            url: StkSysAppParameValueGridUrl + '?actiontype=deleteParameValue&rowid=' + RowId,
                            waitMsg: '删除中...',
                            failure: function (result, request) {
                                mask.hide();
                                Msg.info('error', '请检查网络连接!');
                            },
                            success: function (result, request) {
                                var jsonData = Ext.util.JSON.decode(result.responseText);
                                mask.hide();
                                if (jsonData.success == 'true') {
                                    Msg.info('success', '删除成功!');
                                    StkSysAppParameValueGridDs.load({ params: { StkSysAppParameId: StkSysAppParameId, groupId: GroupId } });
                                } else {
                                    Msg.info('error', '删除失败!');
                                }
                            },
                            scope: this
                        });
                    }
                });
            } else {
                Msg.info('error', '数据有错,没有RowId!');
            }
        }
    }
});

//表格
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
        // 获取当前数据
        var rowId = e.record.get('RowId') || '';
        if (rowId != '' && propSelectdata.get('Code') == 'RpRule') {
            e.cancel = true;
        }
    }
});
//=========================应用系统属性值设置===========================

//=============应用系统设置与应用系统属性设置二级联动===================
StkSysAppGrid.on('rowclick', function (grid, rowIndex, e) {
    var selectedRow = StkSysAppGridDs.data.items[rowIndex];
    StkSysAppId = selectedRow.data['RowId'];
    StkSysAppParameGridDs.proxy = new Ext.data.HttpProxy({ url: StkSysAppParameGridUrl + '?actiontype=selectParame', method: 'GET' });
    StkSysAppParameGridDs.load({ params: { StkSysAppId: StkSysAppId } });
    StkSysAppParameValueGrid.getStore().removeAll();
});
//=============应用系统设置与应用系统属性设置二级联动===================

//=============系统属性设置与系统属性值设置二级联动=====================
StkSysAppParameGrid.on('rowclick', function (grid, rowIndex, e) {
    var selectedRow = StkSysAppParameGridDs.data.items[rowIndex];
    var colIndex = GetColIndex(StkSysAppParameValueGrid, 'StDate');
    if (selectedRow.data['Code'] == 'RpRule') {
        // 仅控制价格方式显示日期维护
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
    if (propDesc.indexOf('密码') >= 0) {
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
//===========模块主页面=================================================
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
                title: '应用程序',
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
//===========模块主页面=================================================
