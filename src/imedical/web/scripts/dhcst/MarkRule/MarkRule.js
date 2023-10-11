// 名称:定价规则
// 编写日期:2012-06-5

var mzLoad = false;
var sdLoad = false;
var markRuleLoad = false;

var mrId = '';
//=========================定价规则=================================
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
    fieldLabel: $g('小数规则'),
    id: 'SDComm',
    name: 'SDComm',
    anchor: '90%',
    width: 120,
    store: SDCommStore,
    valueField: 'RowId',
    displayField: 'Description',
    allowBlank: false,
    triggerAction: 'all',
    emptyText: $g('小数规则...'),
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
    fieldLabel: $g('小数规则'),
    id: 'SDCommList',
    name: 'SDCommList',
    anchor: '90%',
    width: 120,
    store: SDCommStoreList,
    valueField: 'RowId',
    displayField: 'Description',
    allowBlank: false,
    triggerAction: 'all',
    emptyText: $g('小数规则...'),
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
    fieldLabel: $g('定价类型'),
    id: 'MTComm',
    name: 'MTComm',
    anchor: '90%',
    width: 120,
    store: MTCommStore,
    valueField: 'RowId',
    displayField: 'Description',
    allowBlank: false,
    triggerAction: 'all',
    emptyText: $g('定价类型...'),
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
    fieldLabel: $g('定价类型'),
    id: 'MTCommList',
    name: 'MTCommList',
    anchor: '90%',
    width: 120,
    store: MTCommStoreList,
    valueField: 'RowId',
    displayField: 'Description',
    allowBlank: false,
    triggerAction: 'all',
    emptyText: $g('定价类型...'),
    selectOnFocus: true,
    forceSelection: true,
    minChars: 1,
    //pageSize : 10,
    listWidth: 250,
    valueNotFoundText: ''
});

var UFlag = new Ext.grid.CheckColumn({
    header: $g('是否使用'),
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
//配置数据源
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

//模型
var MarkRuleGridCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
    {
        header: $g('代码'),
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
        header: $g('名称'),
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
        header: $g('规则下限'),
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
        header:$g( '规则上限'),
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
        header: $g('加成率'),
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
        header: $g('加成额'),
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
        header: $g('最高加成率'),
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
        header: $g('最高加成额'),
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
        header:$g( '小数规则'),
        //dataIndex:'SdDesc',
        dataIndex: 'SdDr',
        width: 80,
        align: 'left',
        sortable: true,
        renderer: rendererSD,
        editor: new Ext.grid.GridEditor(SDComm)
    },
    {
        header: $g('定价类型'),
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
        header: $g('备注'),
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

//初始化默认排序功能
MarkRuleGridCm.defaultSortable = true;

var addMarkRule = new Ext.Toolbar.Button({
    text: $g('新建'),
    tooltip: $g('新建'),
    iconCls: 'page_add',
    width: 70,
    height: 30,
    handler: function () {
        addNewRow();
    }
});

var saveMarkRule = new Ext.Toolbar.Button({
    text: $g('保存'),
    tooltip: $g('保存'),
    iconCls: 'page_save',
    width: 70,
    height: 30,
    handler: function () {
        //获取所有的新记录
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
                    Ext.Msg.alert($g('提示：'), $g('第') + rows + $g('行规则上限不能小于规则下限！'));
                    break;
                }
                if (code == '' || desc == '') {
                    Ext.Msg.alert($g('提示：'),$g( '第') + rows + $g('行代码和名称不能为空！'));
                    break;
                }
                if (sd == '' || mt == '') {
                    Ext.Msg.alert($g('提示：'), $g('第') + rows + $g('行小数规则和定价类型不能为空！'));
                    break;
                }

                if (parseFloat(margin) > parseFloat(maxMargin)) {
                    Msg.info('warning', $g('第') + rows + $g('行加成率不能高于最高加成率！！'));
                    break;
                }
                if (parseFloat(mPrice) > parseFloat(maxMPrice)) {
                    Msg.info('warning', $g('第') + rows + $g('行加成额不能高于最高加成额！'));
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
                var mask = ShowLoadMask(Ext.getBody(), $g('处理中请稍候...'));
                Ext.Ajax.request({
                    url: MarkRuleGridUrl + '?actiontype=save',
                    params: { data: data },
                    failure: function (result, request) {
                        mask.hide();
                        Msg.info('error', $g('请检查网络连接!'));
                    },
                    success: function (result, request) {
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        mask.hide();
                        if (jsonData.success == 'true') {
                            Msg.info('success', $g('保存成功!'));
                            MarkRuleGridDs.reload();
                        } else {
                            Msg.info('error', $g('保存失败!'));
                        }
                    },
                    scope: this
                });
            }
        }
    }
});
/**
 * 保存入库单前数据检查
 */

function CheckDataBeforeSave() {
    // 1.判断入库药品是否为空
    var rowCount = MarkRuleGridDs.getCount();
    // 有效行数
    var count = 0;
    // 3.判断重复输入药品
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
                Msg.info('warning', Code_i + $g(',第') + icnt + ',' + jcnt + $g('行规则代码重复，请重新输入!'));
                return false;
            }
            if (Desc_i == Desc_j) {
                changeBgColor(i, 'yellow');
                changeBgColor(j, 'yellow');
                Msg.info('warning', Desc_i + $g(',第') + icnt + ',' + jcnt + $g('行规则名称重复，请重新输入!'));
                return false;
            }
        }
    }
    return true;
}
// 变换行颜色
function changeBgColor(row, color) {
    MarkRuleGrid.getView().getRow(row).style.backgroundColor = color;
}
function changeChildBgColor(row, color) {
    MarkRuleAddGrid.getView().getRow(row).style.backgroundColor = color;
}
var deleteMarkRule = new Ext.Toolbar.Button({
    text: $g('删除'),
    tooltip: $g('删除'),
    iconCls: 'page_delete',
    width: 70,
    height: 30,
    handler: function () {
        var cell = MarkRuleGrid.getSelectionModel().getSelectedCell();
        if (cell == null) {
            Msg.info('error', $g('请选择数据!'));
            return false;
        } else {
            var record = MarkRuleGrid.getStore().getAt(cell[0]);
            var RowId = record.get('RowId');
            //alert(RowId);
            if (RowId != '') {
                Ext.MessageBox.confirm($g('提示'), $g('确定要删除选定的行?'), function (btn) {
                    if (btn == 'yes') {
                        var mask = ShowLoadMask(Ext.getBody(), $g('处理中请稍候...'));
                        Ext.Ajax.request({
                            url: MarkRuleGridUrl + '?actiontype=delete&rowid=' + RowId,
                            waitMsg: $g('删除中...'),
                            failure: function (result, request) {
                                mask.hide();
                                Msg.info('error', $g('请检查网络连接!'));
                            },
                            success: function (result, request) {
                                var jsonData = Ext.util.JSON.decode(result.responseText);
                                mask.hide();
                                if (jsonData.success == 'true') {
                                    Msg.info('success', $g('删除成功!'));
                                    MarkRuleGridDs.load();
                                    MarkRuleAddGridDs.reload();
                                } else {
                                    Msg.info('error',$g( '删除失败!'));
                                }
                            },
                            scope: this
                        });
                    }
                });
            } else {
                //Msg.info("error","数据有错!");
                var rowInd = cell[0];
                if (rowInd >= 0) MarkRuleGrid.getStore().removeAt(rowInd);
            }
        }
    }
});

//表格
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
            text: $g("售价计算规则：如果不维护[定价规则明细],则售价=进价*(1+加成率)+加成额"),
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

//=========================定价规则=================================
MarkRuleGrid.on('rowclick', function (grid, rowIndex, columnIndex, e) {
    var selectedRow = MarkRuleGridDs.data.items[rowIndex];
    mrId = selectedRow.data['RowId'];
    MarkRuleAddGridDs.proxy = new Ext.data.HttpProxy({ url: MarkRuleGridUrl + '?actiontype=selectChild', method: 'GET' });
    MarkRuleAddGridDs.load({ params: { parref: mrId } });
});
var UseFlag = new Ext.grid.CheckColumn({
    header: $g('是否使用'),
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
//配置数据源
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

//模型
var MarkRuleAddGridCm = new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),
    {
        header: $g('代码'),
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
        header: $g('名称'),
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
        header: $g('下限'),
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
        header: $g('上限'),
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
        header: $g('加成率'),
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
        header: $g('备注'),
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

//初始化默认排序功能
MarkRuleGridCm.defaultSortable = true;

var addMarkRuleAdd = new Ext.Toolbar.Button({
    text: $g('新建'),
    tooltip: $g('新建'),
    iconCls: 'page_add',
    width: 70,
    height: 30,
    handler: function () {
        var cell = MarkRuleGrid.getSelectionModel().getSelectedCell();
        if (cell == null) {
            Msg.info('warning',$g( '请先选中上方定价规则数据!'));
            return;
        }
        var record = MarkRuleGrid.getStore().getAt(cell[0]);
        var RowId = record.get('RowId') || '';
        if (RowId == '') {
            Msg.info('warning', $g('请先保存上方定价规则，再进行新建！'));
            return;
        }
        addRow();
    }
});

var saveMarkRuleAdd = new Ext.Toolbar.Button({
    text: $g('保存'),
    tooltip: $g('保存'),
    iconCls: 'page_save',
    width: 70,
    height: 30,
    handler: function () {
        //获取所有的新记录
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
                    Msg.info('warning', $g('第') + row + $g('行代码不能为空！'));
                    break;
                } else if (desc == '') {
                    Msg.info('warning', $g('第') + row + $g('行名称不能为空！'));
                    break;
                } else if (parseFloat(minRp) > parseFloat(maxRp)) {
                    Msg.info('warning', $g('第') + row + $g('行下限不能高于上限！'));
                    break;
                }
                if (minRp === '') {
                    Msg.info('warning', $g('第') + row + $g('行下限不能为空!'));
                    break;
                }
                if (maxRp === '') {
                    Msg.info('warning', $g('第') + row + $g('行上限不能为空!'));
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
            var mask = ShowLoadMask(Ext.getBody(), $g('处理中请稍候...'));
            Ext.Ajax.request({
                url: MarkRuleGridUrl + '?actiontype=saveChild',
                params: { data: data },
                failure: function (result, request) {
                    mask.hide();
                    Msg.info('error', $g('请检查网络连接!'));
                },
                success: function (result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    mask.hide();
                    if (jsonData.success == 'true') {
                        Msg.info('success', $g('保存成功!'));
                        MarkRuleAddGridDs.load({ params: { parref: mrId } });
                    } else {
                        Msg.info('error', $g('保存失败!'));
                    }
                },
                scope: this
            });
        }
    }
});
/**
 * 保存入库单前数据检查
 */

function CheckChildDataBeforeSave() {
    // 1.判断入库药品是否为空
    var rowCount = MarkRuleAddGridDs.getCount();
    // 有效行数
    var count = 0;
    // 3.判断重复输入药品
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
                Msg.info('warning', Code_i + $g(',第') + icnt + ',' + jcnt + $g('行规则明细代码重复，请重新输入!'));
                return false;
            }
            if (Desc_i == Desc_j) {
                changeChildBgColor(i, 'yellow');
                changeChildBgColor(j, 'yellow');
                Msg.info('warning', Desc_i + $g(',第') + icnt + ',' + jcnt + $g('行规则明细名称重复，请重新输入!'));
                return false;
            }
        }
    }
    return true;
}
var deleteMarkRuleAdd = new Ext.Toolbar.Button({
    text: $g('删除'),
    tooltip: $g('删除'),
    iconCls: 'page_delete',
    width: 70,
    height: 30,
    handler: function () {
        var cell = MarkRuleAddGrid.getSelectionModel().getSelectedCell();
        if (cell == null) {
            Msg.info('error', $g('请选择数据!'));
            return false;
        } else {
            var record = MarkRuleAddGrid.getStore().getAt(cell[0]);
            var RowId = record.get('RowId');
            if (RowId != '') {
                Ext.MessageBox.confirm($g('提示'), $g('确定要删除选定的行?'), function (btn) {
                    if (btn == 'yes') {
                        var mask = ShowLoadMask(Ext.getBody(), $g('处理中请稍候...'));
                        Ext.Ajax.request({
                            url: MarkRuleGridUrl + '?actiontype=deleteChild&rowid=' + RowId,
                            waitMsg: $g('删除中...'),
                            failure: function (result, request) {
                                mask.hide();
                                Msg.info('error', $g('请检查网络连接!'));
                            },
                            success: function (result, request) {
                                var jsonData = Ext.util.JSON.decode(result.responseText);
                                mask.hide();
                                if (jsonData.success == 'true') {
                                    Msg.info('success', $g('删除成功!'));
                                    MarkRuleAddGridDs.load({ params: { parref: mrId } });
                                } else {
                                    Msg.info('error', $g('删除失败!'));
                                }
                            },
                            scope: this
                        });
                    }
                });
            } else {
                //Msg.info("error","数据有错!");
                var rowInd = cell[0];
                if (rowInd >= 0) MarkRuleAddGrid.getStore().removeAt(rowInd);
            }
        }
    }
});

//表格
MarkRuleAddGrid = new Ext.grid.EditorGridPanel({
	title:$g("定价规则明细"),
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
            text: $g('若维护了[定价规则明细],则使用阶梯加成规则：售价=阶梯1部分金额*(1+阶梯1加成率)+阶梯2部分金额*(1+阶梯2加成率)+阶梯3部分金额*(1+阶梯3加成率)+...'),
            align: 'center'
        }
    ],
    clicksToEdit: 1
});
//===========模块主页面=================================================
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
        title: $g('定价规则'),
        activeTab: 0,
        items: [MarkRuleGrid, MarkRuleAddGrid]
    });
    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: [HospPanel, MarkRulePanel],
        renderTo: 'mainPanel'
    });
});
//===========模块主页面=================================================
