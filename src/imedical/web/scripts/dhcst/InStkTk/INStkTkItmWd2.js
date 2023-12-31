// /名称: 实盘：录入方式二（按库存批次录入方式）
// /描述: 实盘：录入方式二（按库存批次录入方式）
// /编写者：zhangdongmei
// /编写日期: 2012.09.05
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gStrDetailParams = '';
    var url = DictUrl + 'instktkaction.csp';
    var inciRowid = "";
    var LocManaGrp = new Ext.form.ComboBox({
        fieldLabel: $g('管理组'),
        id: 'LocManaGrp',
        name: 'LocManaGrp',
        anchor: '90%',
        width: 140,
        store: LocManGrpStore,
        valueField: 'RowId',
        displayField: 'Description',
        allowBlank: true,
        triggerAction: 'all',
        emptyText: $g('管理组...'),
        selectOnFocus: true,
        forceSelection: true,
        minChars: 1,
        pageSize: 20,
        listWidth: 250,
        valueNotFoundText: '',
        listeners: {
            'beforequery': function(combox) {
                LocManGrpStore.removeAll();
                LocManGrpStore.setBaseParam('locId', InstkLocRowid);
                LocManGrpStore.load({ params: { start: 0, limit: 20 } });
            }
        }
    });

    var PhaWindow = new Ext.form.ComboBox({
        fieldLabel: $g('实盘窗口'),
        id: 'PhaWindow',
        name: 'PhaWindow',
        anchor: '90%',
        store: INStkTkWindowStore,
        valueField: 'RowId',
        displayField: 'Description',
        emptyText: $g('实盘窗口...'),
        disabled: true,
        listeners: {
            'beforequery': function(e) {
                this.store.removeAll();
                this.store.setBaseParam('LocId', InstkLocRowid);
                this.store.load({ params: { start: 0, limit: 99 } });
            }
        }
    });
    INStkTkWindowStore.load({
        params: { start: 0, limit: 99, 'LocId': InstkLocRowid },
        callback: function() {
            Ext.getCmp("PhaWindow").setValue(gInstwWin);
        }
    });

    var StkGrpType = new Ext.ux.StkGrpComboBox({
        id: 'StkGrpType',
        name: 'StkGrpType',
        StkType: App_StkTypeCode, //标识类组类型
        anchor: '90%',
        width: 140
    });

    StkGrpType.on('change', function() {
        Ext.getCmp("DHCStkCatGroup").setValue("");
    });

    var DHCStkCatGroup = new Ext.ux.ComboBox({
        fieldLabel: $g('库存分类'),
        id: 'DHCStkCatGroup',
        name: 'DHCStkCatGroup',
        store: StkCatStore,
        valueField: 'RowId',
        displayField: 'Description',
        params: { StkGrpId: 'StkGrpType' }
    });

    var StkBin = new Ext.form.ComboBox({
        fieldLabel: $g('货位'),
        id: 'StkBin',
        name: 'StkBin',
        anchor: '90%',
        width: 140,
        store: LocStkBinStore,
        valueField: 'RowId',
        displayField: 'Description',
        allowBlank: true,
        triggerAction: 'all',
        selectOnFocus: true,
        forceSelection: true,
        minChars: 1,
        pageSize: 20,
        listWidth: 250,
        valueNotFoundText: '',
        enableKeyEvents: true,
        listeners: {
            'beforequery': function(e) {
                LocStkBinStore.removeAll();
                LocStkBinStore.setBaseParam('LocId', InstkLocRowid);
                LocStkBinStore.setBaseParam('Desc', this.getRawValue());
                LocStkBinStore.load({ params: { start: 0, limit: 20 } });
            }
        }
    });
    var label = new Ext.form.TextField({
        fieldLabel: $g('条码'),
        id: 'label',
        name: 'label',
        anchor: '90%'
    });
    var InstNo = new Ext.form.TextField({
        id: 'InstNo',
        name: 'InstNo',
        fieldLabel: $g('盘点单号'),
        anchor: '90%',
        width: 140,
        disabled: true
    });

    // 录入按钮
    var AddBT = new Ext.Toolbar.Button({
        text: $g('录入'),
        tooltip: $g('点击录入'),
        iconCls: 'page_add',
        width: 70,
        height: 30,
        handler: function() {
            AddNewRow();
        }
    });

    function AddNewRow() {
        var rowCount = InstDetailGrid.getStore().getCount();
        var col = GetColIndex(InstDetailGrid, 'desc');
        if (rowCount > 0) {
            var rowData = InstDetailStore.data.items[rowCount - 1];
            var data = rowData.get("inci");
            if (data == null || data.length <= 0) {
                InstDetailGrid.startEditing(InstDetailStore.getCount() - 1, col);
                return;
            }
        }
        var record = Ext.data.Record.create([
            { name: 'instw', type: 'string' },
            { name: 'insti', type: 'string' },
            { name: 'inclb', type: 'string' },
            { name: 'inci', type: 'string' },
            { name: 'code', type: 'string' },
            { name: 'desc', type: 'string' },
            { name: 'spec', type: 'string' },
            { name: 'manf', type: 'string' },
            { name: 'batexpid', type: 'string' },
            { name: 'uom', type: 'string' },
            { name: 'countQty', type: 'string' },
            { name: 'countDate', type: 'string' },
            { name: 'countTime', type: 'string' },
            { name: 'userName', type: 'string' }
        ]);

        var newRecord = new record({
            instw: '',
            insti: '',
            inclb: '',
            inci: '',
            code: '',
            desc: '',
            spec: '',
            manf: '',
            batexpid: '',
            uom: '',
            countQty: '',
            countDate: '',
            countTime: '',
            userName: ''
        });

        InstDetailGrid.getStore().add(newRecord);
        var row = InstDetailGrid.getStore().getCount() - 1;
        InstDetailGrid.getSelectionModel().select(row, col);
        InstDetailGrid.startEditing(row, col);
    }

    // 查询按钮
    var SearchBT = new Ext.Toolbar.Button({
        text: $g('查询'),
        tooltip: $g('点击查询'),
        iconCls: 'page_find',
        width: 70,
        height: 30,
        handler: function() {
            QueryDetail();
        }
    });

    // 清空按钮
    var RefreshBT = new Ext.Toolbar.Button({
        text: $g('清屏'),
        tooltip: $g('点击清屏'),
        iconCls: 'page_clearscreen',
        width: 70,
        height: 30,
        handler: function() {
            clearData();
        }
    });

    /**
     * 清空方法
     */
    function clearData() {
        inciRowid = "";
        Ext.getCmp("DHCStkCatGroup").setValue('');
        Ext.getCmp("StkBin").setValue('');
        Ext.getCmp("StkGrpType").setValue('');
        Ext.getCmp("PhaWindow").setValue('');
        Ext.getCmp("LocManaGrp").setValue('');
        Ext.getCmp("M_InciDesc").setValue('');
        inciRowid = '';
        Select();
        InstDetailGrid.store.removeAll();
        InstDetailGrid.getView().refresh();
    }
    var M_InciDesc = new Ext.form.TextField({
        fieldLabel: $g('药品名称'),
        id: 'M_InciDesc',
        name: 'M_InciDesc',
        emptyText:$g( '药品名称...'),
        width: 300,
        listeners: {
            specialkey: function(field, e) {
                if (e.getKey() == Ext.EventObject.ENTER) {
                    if (document.getElementById('bodyLookupComponetId').innerHTML != "") {
                        if (document.getElementById('bodyLookupComponetId').style.display != "none") {
                            InciDescLookupGrid.doSearch()
                            e.stopEvent();
                            e.preventDefault();
                            e.stopPropagation();
                            return false;
                        }
                    }
                    var stktype = Ext.getCmp("StkGrpType").getValue();
                    GetPhaOrderLookUp(field.getValue(), stktype, App_StkTypeCode, "", "N", "0", "", getDrugListF);
                }
            }
        }
    })

    function getDrugListF(record) {
        if (record == null || record == "") {
            return;
        }
        var inciDr = record.get("InciDr");
        var InciCode = record.get("InciCode");
        var InciDesc = record.get("InciDesc");
        Ext.getCmp("M_InciDesc").setValue(InciDesc);
        inciRowid = inciDr;
        QueryDetail();
        M_InciDesc.focus(true, true);
    }

    var SaveBT = new Ext.Toolbar.Button({
        text: $g('保存'),
        tooltip: $g('点击保存'),
        iconCls: 'page_save',
        width: 70,
        height: 30,
        handler: function() {
            save();
        }
    });

    //保存实盘数据
    function save() {
        if (InstDetailGrid.activeEditor != null) {
            InstDetailGrid.activeEditor.completeEdit();
        }
        var rowCount = InstDetailStore.getCount();
        var ListDetail = '';
        for (var i = 0; i < rowCount; i++) {
            var rowData = InstDetailStore.getAt(i);
            //新增或修改过的数据
            if (rowData.dirty || rowData.data.newRecord) {
                //add wyx 2014-02-25 选择了批号效期就不使用默认的批号效期
                if (rowData.get('batexpid') !== "") { rowData.set("insti", rowData.get('batexpid')) }
                var Parref = rowData.get('insti');
                var Rowid = rowData.get('instw');
                var UserId = session['LOGON.USERID'];
                var inciDesc = rowData.get("desc");
                var CountQty = rowData.get('countQty');
                
                 if (CountQty < 0 ) {
	                    Msg.info('warning', inciDesc+$g(' 录入的实盘数量不能小于零!'));
	                    return;
	                }
                if (CountQty == '') {
                    CountQty = 0;
                }
                var CountUomId = rowData.get('uom');
                var StkBin = '';
                var PhaWin = Ext.getCmp('PhaWindow').getValue();
                if (Parref == null || Parref == "") {
                    continue;
                }
                var Detail = Parref + '^' + Rowid + '^' + UserId + '^' + CountQty + '^' + CountUomId + '^' + StkBin + '^' + PhaWin + '^^';
                if (ListDetail == '') {
                    ListDetail = Detail;
                } else {
                    ListDetail = ListDetail + xRowDelim() + Detail;
                }
            }
        }
        if (ListDetail == '') {
            Msg.info('Warning',$g( '没有需要保存的数据!'));
            return;
        }
        var mask = ShowLoadMask(Ext.getBody(), $g("处理中请稍候..."));
        Ext.Ajax.request({
            url: url,
            params: { actiontype: 'SaveTkItmWdByWay2', Params: ListDetail },
            method: 'post',
            waitMsg: $g('处理中...'),
            success: function(response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    Msg.info('success', $g('保存成功!'));
                    InstDetailStore.reload();
                    //QueryDetail();
                } else {
                    var ret = jsonData.info;
                    if (ret == '-1') {
                        Msg.info('warning', $g('没有需要保存的数据!'));
                    } else if (ret == '-2') {
                        Msg.info('error', $g('保存失败!'));
                    } else {
                        Msg.info('error', $g('部分数据保存失败:') + ret);
                    }
                }
            }
        });
    }

    //查找盘点单及明细信息
    function QueryDetail() {
        var StkGrpId = Ext.getCmp('StkGrpType').getValue();
        var StkCatId = Ext.getCmp('DHCStkCatGroup').getValue();
        var StkBinId = Ext.getCmp('StkBin').getValue();
        var PhaWinId = Ext.getCmp('PhaWindow').getValue();
        var ManaGrpId = Ext.getCmp('LocManaGrp').getValue();
        var size = StatuTabPagingToolbar.pageSize;
        gStrDetailParams = gRowid + '^' + ManaGrpId + '^' + StkGrpId + '^' + StkCatId + '^' + StkBinId + '^' + PhaWinId + '^' + inciRowid;
        InstDetailStore.removeAll();
        //InstDetailStore.load({params:{actiontype:'INStkTkItmWd',start:0,limit:size,sort:'desc',dir:'ASC',Params:gStrDetailParams}});
        InstDetailStore.setBaseParam('sort', 'stkbin');
        InstDetailStore.setBaseParam('dir', 'ASC');
        InstDetailStore.setBaseParam('Params', gStrDetailParams);
        InstDetailStore.setBaseParam('start', 0);
        InstDetailStore.setBaseParam('limit', size);
        InstDetailStore.setBaseParam('actiontype', 'INStkTkItmWd');
        InstDetailStore.load();
        inciRowid = ''
    }

    //查询盘点单主表信息
    function Select() {
        if (gRowid == null || gRowid == "") {
            return;
        }
        var mask = ShowLoadMask(Ext.getBody(), $g("处理中请稍候..."));
        Ext.Ajax.request({
            url: url,
            params: { actiontype: 'Select', Rowid: gRowid },
            method: 'post',
            success: function(response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    var info = jsonData.info;
                    if (info != "") {
                        var detail = info.split("^");
                        var InstNo = detail[0];
                        var StkGrpId = detail[17];
                        var StkCatId = detail[18];
                        var StkCatDesc = detail[19];
                        InstkLocRowid = detail[5];
                        Ext.getCmp("InstNo").setValue(InstNo);
                        Ext.getCmp("StkGrpType").setValue(StkGrpId);
                        addComboData(StkCatStore, StkCatId, StkCatDesc);
                        Ext.getCmp("DHCStkCatGroup").setValue(StkCatId);
                        QueryDetail();
                    }
                }
            }
        });
    }

    /**
     * 调用药品窗体并返回结果
     */
    function GetPhaOrderInfo(item, stkgrp) {
        if (item != null && item.length > 0) {
            GetPhaOrderWindow(item, stkgrp, App_StkTypeCode, "", "", "0", "",
                getDrugList);
        }
    }

    var BatExpStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: url
        }),
        reader: new Ext.data.JsonReader({
            totalProperty: "results",
            root: 'rows'
        }, ['RowId', 'Description'])

    });

    // 单位
    var CTUom = new Ext.form.ComboBox({
        fieldLabel: $g('单位'),
        id: 'CTUom',
        name: 'CTUom',
        anchor: '90%',
        width: 120,
        store: CTUomStore,
        valueField: 'RowId',
        displayField: 'Description',
        allowBlank: false,
        triggerAction: 'all',
        emptyText: $g('单位...'),
        selectOnFocus: true,
        forceSelection: true,
        minChars: 1,
        pageSize: 10,
        listWidth: 250,
        valueNotFoundText: '',
        listeners: {
            'beforequery': function(combox) {
                CTUomStore.removeAll();
                var cell = InstDetailGrid.getSelectionModel().getSelectedCell();
                var record = InstDetailGrid.getStore().getAt(cell[0]);
                var inciDr = record.get("inci");
                CTUomStore.setBaseParam('actiontype', 'INCIUom');
                CTUomStore.setBaseParam('ItmRowid', inciDr);
                CTUomStore.load();
            }
        }
    });

    //批次效期
    var BatExp = new Ext.form.ComboBox({
        fieldLabel: $g('批次效期'),
        id: 'BatExp',
        name: 'BatExp',
        anchor: '90%',
        width: 120,
        store: BatExpStore,
        valueField: 'RowId',
        displayField: 'Description',
        allowBlank: false,
        triggerAction: 'all',
        emptyText: $g('批次效期...'),
        selectOnFocus: true,
        forceSelection: true,
        minChars: 1,
        pageSize: 10,
        listWidth: 250,
        valueNotFoundText: '',
        listeners: {
            'beforequery': function(combobox) {
                this.store.removeAll();
                var cell = InstDetailGrid.getSelectionModel().getSelectedCell();
                var record = InstDetailGrid.getStore().getAt(cell[0]);
                var inciDr = record.get("inci");
                BatExpStore.load({ params: { actiontype: 'GetItmFreezeBatch', Inst: gRowid, Inci: inciDr } });
            }
        }
    });

    /**
     * 返回方法
     */
    function getDrugList(record) {
        if (record == null || record == "") {
            return;
        }
        var inciDr = record.get("InciDr");
        var inciCode = record.get("InciCode");
        var inciDesc = record.get("InciDesc");
        var spec = record.get("Spec");
        var puom = record.get("PuomDr");
        var puomDesc = record.get("PuomDesc");
        BatExpStore.load({
            params: { actiontype: 'GetItmFreezeBatch', Inst: gRowid, Inci: inciDr },
            callback: function(r, opts) {
                var count = r.length;
                //录入的药不在本盘点单
                if (count < 1) {
                    Msg.info("warning", $g("该药品不在本盘点单范围，不能录入!"))
                    return;
                }
                var cell = InstDetailGrid.getSelectionModel().getSelectedCell();
                // 选中行
                var row = cell[0];
                var rowData = InstDetailGrid.getStore().getAt(row);
                rowData.set("code", inciCode);
                rowData.set("desc", inciDesc);
                rowData.set("inci", inciDr);
                var DefaultBat = BatExpStore.getAt(0);
                if (DefaultBat) {
                    rowData.set("insti", DefaultBat.get("RowId"));

                }
                addComboData(CTUomStore, puom, puomDesc);
                rowData.set("uom", puom);
                rowData.set("spec", spec);
                //光标跳到批号
                var col = GetColIndex(InstDetailGrid, "countQty")
                InstDetailGrid.startEditing(row, col);
            }
        });
    }

    var nm = new Ext.grid.RowNumberer();
    var InstDetailGridCm = new Ext.grid.ColumnModel([nm, {
        header: "rowid",
        dataIndex: 'instw',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: "insti",
        dataIndex: 'insti',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: "inclb",
        dataIndex: 'inclb',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: "inci",
        dataIndex: 'inci',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: $g('代码'),
        dataIndex: 'code',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g("名称"),
        dataIndex: 'desc',
        width: 250,
        align: 'left',
        sortable: true,
        editor: new Ext.form.TextField({
            selectOnFocus: true,
            allowBlank: false,
            listeners: {
                specialkey: function(field, e) {
                    var keyCode = e.getKey();

                    if (keyCode == Ext.EventObject.ENTER) {
                        var stkGrp = Ext.getCmp("StkGrpType").getValue();

                        GetPhaOrderInfo(field.getValue(), stkGrp);
                    }
                }
            }
        })
    }, {
        header: $g("规格"),
        dataIndex: 'spec',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g('批次~效期'),
        dataIndex: 'batexpid',
        width: 200,
        align: 'left',
        sortable: true,
        editor: BatExp,
        //renderer:Ext.util.Format.comboRenderer(BatExp),
        //modify wyx 2014-02-25查询后批号效期为空的问题
        renderer: Ext.util.Format.comboRenderer2(BatExp, "batexpid", "batexp"),
        listeners: {
            'specialkey': function(field, e) {
                if (e.getKey() == Ext.EventObject.ENTER) {
                    var cell = InstDetailGrid.getSelectionModel().getSelectedCell();
                    var col = GetColIndex(InstDetailGrid, "countQty")
                    InstDetailGrid.startEditing(cell[0], col);
                }
            }
        }
    }, {
        header: $g("单位"),
        dataIndex: 'uom',
        width: 60,
        align: 'left',
        sortable: true,
        editor: CTUom,
        renderer: Ext.util.Format.comboRenderer2(CTUom, 'uom', 'uomDesc')

    }, {
        header: $g('实盘数量'),
        dataIndex: 'countQty',
        width: 80,
        align: 'right',
        sortable: true,
        editor: new Ext.form.NumberField({
            selectOnFocus: true,
            //allowBlank : false,
            allowNegative: false,
            listeners: {
                'specialkey': function(field, e) {
                    var keyCode = e.getKey();
                    var col = GetColIndex(InstDetailGrid, 'countQty');
                    var cell = InstDetailGrid.getSelectionModel().getSelectedCell();
                    var rowCount = InstDetailGrid.getStore().getCount();
                    if (keyCode == Ext.EventObject.ENTER) {
                        var qty = field.getValue();
                        if (qty < 0) {
                            Msg.info('warning', $g('实盘数量不能小于零!'));
                            return;
                        }
                        AddNewRow();
                    }
                    if (keyCode == Ext.EventObject.UP) {
                        var row = cell[0] - 1;
                        if (row >= 0) {
                            InstDetailGrid.startEditing(row, col);
                        }
                    }
                    if (keyCode == Ext.EventObject.DOWN) {
                        var row = cell[0] + 1;
                        if (row < rowCount) {
                            InstDetailGrid.startEditing(row, col);
                        }
                    }
                }
            }
        })
    }, {
        header: $g("生产企业"),
        dataIndex: 'manf',
        width: 150,
        align: 'left',
        sortable: true
    }, {
        header: $g('实盘日期'),
        dataIndex: 'countDate',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g("实盘时间"),
        dataIndex: 'countTime',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g('实盘人'),
        dataIndex: 'userName',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g('货位'),
        dataIndex: 'stkbin',
        width: 100,
        align: 'left',
        sortable: true
    }]);
    InstDetailGridCm.defaultSortable = true;

    // 数据集
    var InstDetailStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: url,
            method: "POST"
        }),
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: "results",
            id: "instw",
            fields: ["instw", "insti", "inclb", "inci", "code", "desc", "spec", "manf", "batexpid", "batexp", "batNo", "expDate",
                "freQty", "uom", "uomDesc", "buom", "buomDesc", "rp", "sp", "countQty",
                "countDate", "countTime", "userName", "stkbin"
            ]
        }),
        remoteSort: true,
        pruneModifiedRecords: true
    });

    var StatuTabPagingToolbar = new Ext.PagingToolbar({
        store: InstDetailStore,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: $g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
        emptyMsg: "No results to display",
        prevText: $g("上一页"),
        nextText: $g("下一页"),
        refreshText: $g("刷新"),
        lastText:$g( "最后页"),
        firstText: $g("第一页"),
        beforePageText: $g("当前页"),
        afterPageText: $g("共{0}页"),
        emptyMsg: $g("没有数据")
    });

    StatuTabPagingToolbar.addListener('beforechange', function(toolbar, params) {
        if (InstDetailGrid.activeEditor != null) {
            InstDetailGrid.activeEditor.completeEdit();
        }
        var records = InstDetailStore.getModifiedRecords();
        if (records.length > 0) {
            Msg.info("warning",$g( "本页数据发生变化，请先保存！"));
            return false;
        }
    });

    var InstDetailGrid = new Ext.grid.EditorGridPanel({
        id: 'InstDetailGrid',
        region: 'center',
        cm: InstDetailGridCm,
        store: InstDetailStore,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.CellSelectionModel(),
        loadMask: true,
        bbar: StatuTabPagingToolbar,
        clicksToEdit: 1,
        tbar: [M_InciDesc]
    });

    var form = new Ext.form.FormPanel({
        labelwidth: 30,
        width: 400,
        labelAlign: 'right',
        frame: true,
        autoScroll: true,
        bodyStyle: 'padding:10px 0px 0px 0px;',
        style: 'padding:0 0 0 0;',
        tbar: [SearchBT, '-', RefreshBT, '-', AddBT, '-', SaveBT],
        items: [{
            xtype: 'fieldset',
            layout: 'column',
            bodyStyle: 'padding:0 0 0 0;',
            style: 'padding:5px 0 5 0;',
            items: [{
                columnWidth: 0.33,
                xtype: 'fieldset',
                labelWidth: 60,
                defaults: { width: 180, border: false },
                autoHeight: true,
                boderStyle: 'padding:0 0 0 0;',
                style: 'padding:0 0 0 0;',
                border: false,
                items: [LocManaGrp, StkBin]

            }, {
                columnWidth: 0.33,
                xtype: 'fieldset',
                labelWidth: 60,
                defaults: { width: 140, border: false },
                defaultType: 'textfield',
                autoHeight: true,
                border: false,
                style: 'padding:0 0 0 0;',
                items: [StkGrpType, DHCStkCatGroup]

            }, {
                columnWidth: 0.33,
                xtype: 'fieldset',
                labelWidth: 60,
                defaults: { width: 140, border: false },
                defaultType: 'textfield',
                autoHeight: true,
                border: false,
                style: 'padding:0 0 0 0;',
                items: [PhaWindow, InstNo]

            }]
        }, {
            xtype: 'fieldset',
            title: $g('扫描条码录入'),
            layout: 'column',
            bodyStyle: 'padding:0 0 0 0;',
            style: 'padding:5px 0 5 0;',
            items: [{
                columnWidth: 0.33,
                xtype: 'fieldset',
                labelWidth: 60,
                defaults: { width: 180, border: false },
                autoHeight: true,
                boderStyle: 'padding:0 0 0 0;',
                style: 'padding:0 0 0 0;',
                border: false,
                items: [label]
            }]
        }]
    });

    // 5.2.页面布局
    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: [{
            region: 'north',
            height: 220,
            title: $g('实盘:录入方式二(按库存批次)'),
            layout: 'fit',
            items: [form]
        }, {
            region: 'center',
            layout: 'fit',
            items: [InstDetailGrid]
        }],
        renderTo: 'mainPanel'
    });

    Select();
})