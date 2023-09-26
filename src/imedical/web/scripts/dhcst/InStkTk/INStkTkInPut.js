// /名称: 实盘：录入方式三（根据帐盘数据按品种填充实盘数）
// /描述: 实盘：录入方式三（根据帐盘数据按品种填充实盘数）
// /编写者：zhangdongmei
// /编写日期: 2012.09.07
// /补充者：hulihua 2015-09-21 增加大小单位方式录入、列设置、Excel导入
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gUserId = session['LOGON.USERID'];
    var gLocId = session['LOGON.CTLOCID'];
    var gStrDetailParams = '';
    var StkLocId = '';
    var inciRowid = '';
    var impWindow = '';
    var url = DictUrl + 'instktkaction.csp';
    var LocManaGrp = new Ext.form.ComboBox({
        fieldLabel: '管理组',
        id: 'LocManaGrp',
        name: 'LocManaGrp',
        anchor: '90%',
        store: LocManGrpStore,
        valueField: 'RowId',
        displayField: 'Description',
        allowBlank: true,
        triggerAction: 'all',
        emptyText: '管理组...',
        selectOnFocus: true,
        forceSelection: true,
        minChars: 1,
        pageSize: 20,
        listWidth: 250,
        valueNotFoundText: '',
        listeners: {
            'beforequery': function(combox) {
                this.store.removeAll();
                if (StkLocId == "") { LocManGrpStore.setBaseParam('locId', InstkLocRowid); } else { LocManGrpStore.setBaseParam('locId', StkLocId); }
                LocManGrpStore.load({ params: { start: 0, limit: 20 } });
            }
        }
    });

    var StkGrpType = new Ext.ux.StkGrpComboBox({
        id: 'StkGrpType',
        name: 'StkGrpType',
        StkType: App_StkTypeCode, //标识类组类型
        UserId: gUserId,
        LocId: InstkLocRowid,
        anchor: '90%'
    });

    StkGrpType.on('change', function() {
        Ext.getCmp("DHCStkCatGroup").setValue("");
    });

    var DHCStkCatGroup = new Ext.ux.ComboBox({
        fieldLabel: '库存分类',
        id: 'DHCStkCatGroup',
        name: 'DHCStkCatGroup',
        store: StkCatStore,
        valueField: 'RowId',
        displayField: 'Description',
        params: { StkGrpId: 'StkGrpType' }
    });


    var StkBin = new Ext.ux.ComboBox({
        fieldLabel: '货位',
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
                this.store.removeAll();
                if (StkLocId == "") { LocStkBinStore.setBaseParam('LocId', InstkLocRowid); } else { LocStkBinStore.setBaseParam('LocId', StkLocId); }
                LocStkBinStore.setBaseParam('Desc', Ext.getCmp('StkBin').getRawValue());
                LocStkBinStore.load({ params: { start: 0, limit: 20 } });
            }
        }
    });

    var InstNo = new Ext.form.TextField({
        id: 'InstNo',
        name: 'InstNo',
        fieldLabel: '盘点单号',
        width: 140,
        anchor: '90%',
        disabled: true
    });

    var InputWin = new Ext.form.ComboBox({
        fieldLabel: '实盘窗口',
        id: 'InputWin',
        name: 'InputWin',
        anchor: '90%',
        store: INStkTkWindowStore,
        valueField: 'RowId',
        displayField: 'Description',
        disabled: true,
        allowBlank: true,
        triggerAction: 'all',
        emptyText: '实盘窗口...',
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
            Ext.getCmp("InputWin").setValue(gInputWin);
        }
    });

    // 查询按钮
    var SearchBT = new Ext.Toolbar.Button({
        text: '查询',
        tooltip: '点击查询',
        iconCls: 'page_find',
        width: 70,
        height: 30,
        handler: function() {
            QueryDetail();
        }
    });

    // 清空按钮
    var RefreshBT = new Ext.Toolbar.Button({
        text: '清屏',
        tooltip: '点击清屏',
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
        Ext.getCmp("LocManaGrp").setValue('');
        Select();
        InstDetailGrid.store.removeAll();
        InstDetailGrid.getView().refresh();
    }

    /**
     * 返回方法
     */
    function getImportFlag(Flag) {
        if (Flag == null || Flag == "") {
            return;
        }
        QueryDetail();
    }

    var ImpInstDataBT = new Ext.Toolbar.Button({
        text: 'Excel导入',
        tooltip: '读取Excel文件',
        iconCls: 'page_excel',
        width: 70,
        height: 30,
        handler: function() {
            var InputWin = Ext.getCmp('InputWin').getValue();
            if (InputWin == '' || InputWin == null) {
                Msg.info('warning', 'Excel导入的时候必须选择实盘窗口!');
                return;
            }
            if (impWindow) {
                impWindow.ShowOpen();
            } else {
                impWindow = new ActiveXObject("MSComDlg.CommonDialog");
                impWindow.Filter = "All Files (*.*)|*.*|xls Files(*.xls)|*.xls|xlsx Files(*.xlsx)|*.xlsx";
                impWindow.FilterIndex = 3;

                // 必须设置MaxFileSize. 否则出错
                impWindow.MaxFileSize = 32767;
                // 显示对话框
                impWindow.ShowOpen();
            }

            var fileName = impWindow.FileName;
            if (fileName == '') {
                Msg.info('warning', '请选择Excel文件!');
                return;
            }
            var InstNo = Ext.getCmp("InstNo").getValue();
            var pid = tkMakeServerCall("web.DHCST.InStkTkInput", "NewImpGlobal");
            previewInstData(fileName, InstNo, pid, getImportFlag, InputWin);
            QueryDetail();
        }
    })

    var HelpBT = new Ext.Toolbar.Button({
	    id: 'HelpBtn',
        text: '导入模板说明',
        width: 70,
        height: 30,
        iconCls: 'page_key',
        renderTo: Ext.get("tipdiv")

    });

    var SaveBT = new Ext.Toolbar.Button({
        text: '保存',
        tooltip: '点击保存',
        iconCls: 'page_save',
        width: 70,
        height: 30,
        handler: function() {
            save();
        }
    });

    var M_InciDesc = new Ext.form.TextField({
        fieldLabel: '药品名称',
        id: 'M_InciDesc',
        name: 'M_InciDesc',
        emptyText: '药品名称...',
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

    //保存实盘数据
    function save() {
        if (InstDetailGrid.activeEditor != null) {
            InstDetailGrid.activeEditor.completeEdit();
        }
        var rowCount = InstDetailStore.getCount();
        var ListDetail = '';
        var InputWin = Ext.getCmp("InputWin").getValue();
        for (var i = 0; i < rowCount; i++) {
            var rowData = InstDetailStore.getAt(i);
            //新增或修改过的数据
            if (rowData.dirty || rowData.data.newRecord) {
                var Parref = rowData.get('parref');
                var Rowid = rowData.get('rowid');
                var UserId = session['LOGON.USERID'];
                var CountQty = rowData.get('countQty');
                if (CountQty == "") {
                    CountQty = 0;
                }
                var IncId = rowData.get('inci');
                var PCountQty = rowData.get('pcountQty');
                if (PCountQty == "") {
                    PCountQty = 0;
                }
                var BCountQty = rowData.get('bcountQty'); //add by myq 20141027 实盘数小
                if (BCountQty == "") {
                    BCountQty = 0;
                }
                var incidesc = rowData.get('desc');
                 if (PCountQty < 0 || BCountQty < 0) {
	                    Msg.info('warning', incidesc+' 录入的实盘数量不能小于零!');
	                    return;
	                }
                
                var Detail = Rowid + '^' + Parref + '^' + IncId + '^' + PCountQty + '^' + UserId + '^' + InputWin + '^' + BCountQty;
                if (ListDetail == '') {
                    ListDetail = Detail;
                } else {
                    ListDetail = ListDetail + xRowDelim() + Detail;
                }
            }
        }
        if (ListDetail == '') {
            Msg.info('Warning', '没有需要保存的数据!');
            return;
        }
        var mask = ShowLoadMask(Ext.getBody(), "处理中请稍候...");
        Ext.Ajax.request({
            url: url,
            params: { actiontype: 'SaveInput', Params: ListDetail },
            method: 'post',
            waitMsg: '处理中...',
            success: function(response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    Msg.info('success', '保存成功!');
                    InstDetailStore.reload();
                    //QueryDetail();
                } else {
                    var ret = jsonData.info;
                    if (ret == '-1') {
                        Msg.info('warning', '没有需要保存的数据!');
                    } else if (ret == '-2') {
                        Msg.info('error', '保存失败!');
                    } else {
                        Msg.info('error', '部分数据保存失败:' + ret);
                    }
                }
            }
        });
    }

    //根据帐盘数据插入实盘列表
    function create(inst) {
        if (inst == null || inst == '') {
            Msg.info('warning', '请选择盘点单');
            return;
        }
        var UserId = session['LOGON.USERID'];
        var mask = ShowLoadMask(Ext.getBody(), "处理中请稍候...");
        Ext.Ajax.request({
            url: url,
            params: { actiontype: 'CreateStkTkInput', Inst: inst, UserId: UserId, InputWin: gInputWin },
            waitMsg: '处理中...',
            success: function(response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    QueryDetail(); //查找实盘列表
                } else {
                    var ret = jsonData.info;
                    Msg.info("error", "提取实盘列表失败：" + ret);
                }
            }
        });
    }

    //查找盘点单明细信息
    function QueryDetail() {

        //查询盘点单明细
        var StkGrpId = Ext.getCmp('StkGrpType').getValue();
        var StkCatId = Ext.getCmp('DHCStkCatGroup').getValue();
        var StkBinId = Ext.getCmp('StkBin').getValue();
        var ManaGrpId = Ext.getCmp('LocManaGrp').getValue();
        var InputWin = Ext.getCmp('InputWin').getValue();
        var size = StatuTabPagingToolbar.pageSize;

        gStrDetailParams = gRowid + '^' + ManaGrpId + '^' + StkGrpId + '^' + StkCatId + '^' + StkBinId + '^' + InputWin + '^' + inciRowid;
        InstDetailStore.setBaseParam('sort', 'stkbin');
        InstDetailStore.setBaseParam('dir', 'ASC');
        InstDetailStore.setBaseParam('Params', gStrDetailParams)
        InstDetailStore.load({
            params: { start: 0, limit: size },
            callback: function(r, options, success) {
                if (success == false) {
                    Msg.info("error", "查询有误,请查看日志!");
                }
            }
        });
        inciRowid = '';
    }
    //查询盘点单主表信息
    function Select() {
        if (gRowid == null || gRowid == "") {
            return;
        }

        Ext.Ajax.request({
            url: url,
            params: { actiontype: 'Select', Rowid: gRowid },
            method: 'post',
            success: function(response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                if (jsonData.success == 'true') {
                    var info = jsonData.info;
                    if (info != "") {
                        var detail = info.split("^");
                        var InstNo = detail[0];
                        StkLocId = detail[5]; //add wyx 增加盘点科室 2013-04-30						
                        var StkGrpId = detail[17];
                        var StkCatId = detail[18];
                        var StkCatDesc = detail[19];
                        Ext.getCmp("InstNo").setValue(InstNo);
                        Ext.getCmp("StkGrpType").setValue(StkGrpId);
                        addComboData(StkCatStore, StkCatId, StkCatDesc);
                        Ext.getCmp("DHCStkCatGroup").setValue(StkCatId);
                    }
                }
            }

        });
    }

    var nm = new Ext.grid.RowNumberer();
    var InstDetailGridCm = new Ext.grid.ColumnModel([nm, {
        header: "rowid",
        dataIndex: 'rowid',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: "parref",
        dataIndex: 'parref',
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
        header: '货位',
        dataIndex: 'stkbin',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: '代码',
        dataIndex: 'code',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: "名称",
        dataIndex: 'desc',
        width: 200,
        align: 'left',
        sortable: true
    }, {
        header: "规格",
        dataIndex: 'spec',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: "冻结数量",
        dataIndex: 'freQty',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: "单位",
        dataIndex: 'uomDesc',
        width: 60,
        align: 'left',
        sortable: true
    }, {
        header: '实盘数量(大)',
        dataIndex: 'pcountQty',
        width: 100,
        align: 'right',
        sortable: true,
        editor: new Ext.form.NumberField({
            selectOnFocus: true,
            allowNegative: false,
            listeners: {
                'specialkey': function(field, e) {
                    var keyCode = e.getKey();
                    var col = GetColIndex(InstDetailGrid, 'bcountQty');
                    var cell = InstDetailGrid.getSelectionModel().getSelectedCell();
                    var rowCount = InstDetailGrid.getStore().getCount();
                    if (keyCode == Ext.EventObject.ENTER) {
                        var qty = field.getValue();
                        if (qty < 0) {
                            Msg.info('warning', '实盘数量不能小于零!');
                            return;
                        }
                        var row = cell[0];
                        if (row < rowCount) {
                            InstDetailGrid.startEditing(row, col);
                        }
                    }
                    if (keyCode == Ext.EventObject.UP) {
                        var row = cell[0] - 1;
                        if (row >= 0) {
                            InstDetailGrid.getSelectionModel().select(row, col);
                            InstDetailGrid.startEditing(row, col);
                        }
                    }
                    if (keyCode == Ext.EventObject.DOWN) {
                        var row = cell[0];
                        if (row < rowCount) {
                            InstDetailGrid.getSelectionModel().select(row, col);
                            InstDetailGrid.startEditing(row, col);
                        }
                    }
                }
            }
        })
    }, {
        header: '入库单位',
        dataIndex: 'puomdesc',
        width: 60,
        align: 'left',
        sortable: true
    }, {
        header: '实盘数量(小)',
        dataIndex: 'bcountQty',
        width: 100,
        align: 'right',
        sortable: true,
        editor: new Ext.form.NumberField({
            selectOnFocus: true,
            allowNegative: false,
            listeners: {
                'specialkey': function(field, e) {
                    var keyCode = e.getKey();
                    var col = GetColIndex(InstDetailGrid, 'pcountQty');
                    var cell = InstDetailGrid.getSelectionModel().getSelectedCell();
                    var rowCount = InstDetailGrid.getStore().getCount();
                    if (keyCode == Ext.EventObject.ENTER) {
                        var qty = field.getValue();
                        if (qty < 0) {
                            Msg.info('warning', '实盘数量不能小于零!');
                            return;
                        }
                        var row = cell[0] + 1;
                        if (row < rowCount) {
                            InstDetailGrid.startEditing(row, col);
                        }
                    }
                    if (keyCode == Ext.EventObject.UP) {
                        var row = cell[0];
                        if (row >= 0) {
                            InstDetailGrid.getSelectionModel().select(row, col);
                            InstDetailGrid.startEditing(row, col);
                        }
                    }
                    if (keyCode == Ext.EventObject.DOWN) {
                        var row = cell[0] + 1;
                        if (row < rowCount) {
                            InstDetailGrid.getSelectionModel().select(row, col);
                            InstDetailGrid.startEditing(row, col);
                        }
                    }
                }
            }
        })
    }, {
        header: '基本单位',
        dataIndex: 'buomdesc',
        width: 60,
        align: 'left',
        sortable: true
    }, {
        header: '实盘总数量(基)',
        dataIndex: 'countQty',
        width: 110,
        align: 'right',
        sortable: true
    }, {
        header: '实盘日期',
        dataIndex: 'countDate',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: "实盘时间",
        dataIndex: 'countTime',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: '实盘人',
        dataIndex: 'userName',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: '转换系数',
        dataIndex: 'fac',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: 'true'
    }]);

    var GridColSetBT = new Ext.Toolbar.Button({
        text: '列设置',
        tooltip: '列设置',
        iconCls: 'page_gear',
        handler: function() {
            GridColSet(InstDetailGrid, "DHCSTINSTKTKINPUT");
        }
    });

    InstDetailGridCm.defaultSortable = true;

    // 数据集
    var InstDetailStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: url + "?actiontype=QueryInput",
            method: "POST"
        }),
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: "results",
            id: "rowid",
            fields: ["rowid", "parref", "inci", "code", "desc", "spec",
                "uom", "uomDesc", "freQty", "countQty", "pcountQty", "puomdesc",
                "bcountQty", "buomdesc", "countDate", "countTime", "userName", "stkbin", "fac"
            ]
        }),
        remoteSort: true,
        pruneModifiedRecords: true
    });

    var StatuTabPagingToolbar = new Ext.PagingToolbar({
        store: InstDetailStore,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: '当前记录 {0} -- {1} 条 共 {2} 条记录',
        emptyMsg: "No results to display",
        prevText: "上一页",
        nextText: "下一页",
        refreshText: "刷新",
        lastText: "最后页",
        firstText: "第一页",
        beforePageText: "当前页",
        afterPageText: "共{0}页",
        emptyMsg: "没有数据"
    });

    StatuTabPagingToolbar.addListener('beforechange', function(toolbar, params) {
        if (InstDetailGrid.activeEditor != null) {
            InstDetailGrid.activeEditor.completeEdit();
        }
        var records = InstDetailStore.getModifiedRecords();
        if (records.length > 0) {
            Ext.Msg.show({
                title: '提示',
                msg: '本页数据发生改变，是否需要保存？',
                buttons: Ext.Msg.YESNOCANCEL,
                fn: function(btn, text, opt) {
                    if (btn == 'yes') {
                        save();
                        toolbar.store.commitChanges();
                        changePagingToolBar(toolbar, params.start);
                    }
                    if (btn == 'no') {
                        toolbar.store.rejectChanges();
                        changePagingToolBar(toolbar, params.start);
                    }
                },
                animEl: 'elId',
                icon: Ext.MessageBox.QUESTION
            });
            return false;
        }
    });

    ///startRow:当前页中开始行的在所有记录中的顺序
    function changePagingToolBar(toolbar, startRow) {
        if (toolbar.cursor > startRow) {
            if (toolbar.cursor - startRow == toolbar.pageSize) {
                toolbar.movePrevious();
            } else {
                toolbar.moveFirst();
            }
        }
        if (toolbar.cursor < startRow) {
            if (toolbar.cursor - startRow == -toolbar.pageSize) {
                toolbar.moveNext();
            } else {
                toolbar.moveLast();
            }
        }
    }
    var InstDetailGrid = new Ext.grid.EditorGridPanel({
        id: 'InstDetailGrid',
        region: 'center',
        cm: InstDetailGridCm,
        store: InstDetailStore,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.CellSelectionModel(), //wyx modify 2013-11-18改为行模式	
        loadMask: true,
        bbar: StatuTabPagingToolbar,
        tbar: [M_InciDesc],
        clicksToEdit: 1,
        viewConfig: {
            getRowClass: function(record, rowIndex, rowParams, store) {
                var countqty = record.get("countQty");
                var freezeqty = record.get("freQty");
                var incidesc = record.get("desc");
                var diffQty = accAdd(countqty, -freezeqty)
                var colorflag = "";
                if (incidesc == "合计") { return; }
                if ((countqty == "") || (countqty == null)) {
                    return; //未填项不变色
                }
                if (Number(diffQty) > 0) { colorflag = "1"; } else if (Number(diffQty) < 0) { colorflag = "-1"; }
                switch (colorflag) {
                    case "1":
                        return 'classAquamarine';
                        break;
                    case "-1":
                        return 'classSalmon';
                        break;
                }
            }
        }

    });
    ///yunhaibao,20151123,行修改后计算行信息,后台计算
    InstDetailGrid.on('afteredit', function(e) {
        if ((e.field == "bcountQty") || (e.field == "pcountQty")) {
            var bqty = e.record.get("bcountQty")
            if (bqty == "") { bqty = 0 }
            var pqty = e.record.get("pcountQty")
            if (pqty == "") { pqty = 0 }
            var bpfac = e.record.get("fac")
            var newbqty = accMul(pqty, bpfac)
            var newqty = accAdd(newbqty, bqty)
            e.record.set("countQty", newqty);
        }
    })



    var form = new Ext.form.FormPanel({
        //labelwidth : 30,
        labelWidth: 60,
        width: 400,
        labelAlign: 'right',
        title: '实盘:录入方式三(按品种录入)',
        frame: true,
        tbar: [SearchBT, '-', RefreshBT, '-', SaveBT],
        items: [{
            xtype: 'fieldset',
            title: '查询条件',
            layout: 'column',
            style: DHCSTFormStyle.FrmPaddingV,
            items: [{
                columnWidth: 0.34,
                xtype: 'fieldset',
                defaults: { width: 180, border: false }, // Default config options for child items
                border: false,
                items: [LocManaGrp, StkBin]

            }, {
                columnWidth: 0.33,
                xtype: 'fieldset',
                defaults: { width: 140, border: false }, // Default config options for child items
                border: false,
                items: [StkGrpType, InstNo]

            }, {
                columnWidth: 0.33,
                xtype: 'fieldset',
                defaults: { width: 140, border: false }, // Default config options for child items
                border: false,
                items: [DHCStkCatGroup, InputWin]

            }]
        }]
    });

    // 5.2.页面布局
    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: [{
            region: 'north',
            height: DHCSTFormStyle.FrmHeight(2),
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
    //自动加载盘点单
    create(gRowid);
})