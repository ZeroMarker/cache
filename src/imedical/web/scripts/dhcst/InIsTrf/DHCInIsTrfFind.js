/**
 * 库存转移制单-查询界面
 */
function StockTransferSearch(dataStore, Fn) {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    //取参数配置
    if (gParam == null || gParam.length < 1) {
        GetParam();
    }
    // 转移单号
    var InItNo2 = new Ext.form.TextField({
        fieldLabel: '转移单号',
        id: 'InItNo2',
        name: 'InItNo2',
        anchor: '90%',
        width: 120
    });

    // 请求部门
    var RequestPhaLoc2 = new Ext.ux.LocComboBox({
        fieldLabel: '请求部门',
        id: 'RequestPhaLoc2',
        name: 'RequestPhaLoc2',
        anchor: '90%',
        width: 120,
        emptyText: '请求部门...',
        defaultLoc: {}
    });

    // 起始日期
    var StartDate2 = new Ext.ux.DateField({
        fieldLabel: '起始日期',
        id: 'StartDate2',
        name: 'StartDate2',
        anchor: '90%',
        width: 120,
        value: DefaultStDate()
    });

    // 结束日期
    var EndDate2 = new Ext.ux.DateField({
        fieldLabel: '结束日期',
        id: 'EndDate2',
        name: 'EndDate3',
        anchor: '90%',
        width: 120,
        value: DefaultEdDate()
    });

    // 请求单号
    var InRqNo2 = new Ext.form.TextField({
        fieldLabel: '请求单号',
        id: 'InRqNo2',
        name: 'InRqNo2',
        anchor: '90%',
        width: 120
    });

    var StatusStore = new Ext.data.SimpleStore({
        fields: ['RowId', 'Description'],
        data: [
            ['10', '未完成'],
            ['11', '已完成'],
            ['20', '出库审核不通过'],
            ['30', '拒绝接收']
        ]
    });

    var Status = new Ext.form.ComboBox({
        fieldLabel: '单据状态',
        id: 'Status',
        name: 'Status',
        anchor: '90%',
        width: 120,
        store: StatusStore,
        triggerAction: 'all',
        mode: 'local',
        valueField: 'RowId',
        displayField: 'Description',
        allowBlank: true,
        triggerAction: 'all',
        selectOnFocus: true,
        forceSelection: true,
        minChars: 1,
        editable: true,
        valueNotFoundText: ''
    });
    Ext.getCmp("Status").setValue(10);

    // 查询按钮
    var searchBT = new Ext.Toolbar.Button({
        text: '查询',
        tooltip: '点击查询转移信息',
        iconCls: 'page_find',
        height: 30,
        width: 70,
        handler: function() {
            searchDurgData();
        }
    });

    function searchDurgData() {
        var SupplyPhaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
        if (SupplyPhaLoc == null || SupplyPhaLoc.length <= 0) {
            Msg.info("warning", "供给部门不能为空,请关闭窗体选择供给部门！");
            return;
        }
        var StartDate = Ext.getCmp("StartDate2").getValue();
        if ((StartDate != "") && (StartDate != null)) {
            StartDate = StartDate.format(App_StkDateFormat);
        }
        if ((StartDate == "") || (StartDate == null)) {
            Msg.info("error", "请选择起始日期!");
            return;
        }
        var EndDate = Ext.getCmp("EndDate2").getValue();
        if ((EndDate != "") && (EndDate != null)) {
            EndDate = EndDate.format(App_StkDateFormat);
        }
        if ((EndDate == "") || (EndDate == null)) {
            Msg.info("error", "请选择截止日期!");
            return;
        }
        var RequestPhaLoc = Ext.getCmp("RequestPhaLoc2").getValue();
        var InRqNo = Ext.getCmp("InRqNo2").getValue();
        var InItNo = Ext.getCmp("InItNo2").getValue();
        var Status = Ext.getCmp("Status").getValue();
        if (Status == null || Status == "") {
            Status = '10,11,20';
        }
        var ListParam = StartDate + '^' + EndDate + '^' + SupplyPhaLoc + '^' + RequestPhaLoc + '^^' + Status + '^' + InItNo + '^' + InRqNo;
        var Page = GridPagingToolbar.pageSize;
        ItMasterInfoStore.setBaseParam('ParamStr', ListParam);
        ItMasterInfoStore.removeAll();
        ItDetailInfoGrid.store.removeAll();
        ItMasterInfoStore.load({
            params: { start: 0, limit: Page },
            callback: function(r, options, success) {
                if (success == false) {
                    Msg.info("error", "查询错误，请查看日志!");
                } else {
                    if (r.length > 0) {
                        ItMasterInfoGrid.getSelectionModel().selectFirstRow();
                        ItMasterInfoGrid.getSelectionModel().fireEvent('rowselect', this, 0);
                        ItMasterInfoGrid.getView().focusRow(0);
                    }
                }
            }
        });
    }

    // 选取按钮
    var returnBT = new Ext.Toolbar.Button({
        text: '选取',
        tooltip: '点击选取',
        iconCls: 'page_goto',
        height: 30,
        width: 70,
        handler: function() {
            returnData();
        }
    });

    function returnData() {
        var selectRows = ItMasterInfoGrid.getSelectionModel().getSelections();
        if (selectRows.length == 0) {
            Msg.info("warning", "请选择要返回的转移单信息！");
            Fn("");
        } else {
            var InitRowId = selectRows[0].get("init");
            Fn(InitRowId);
        }
        window.close();
    }

    // 清空按钮
    var clearBT = new Ext.Toolbar.Button({
        text: '清屏',
        tooltip: '点击清屏',
        iconCls: 'page_clearscreen',
        height: 30,
        width: 70,
        handler: function() {
            clearData();
        }
    });

    function clearData() {
        Ext.getCmp("RequestPhaLoc2").setValue("");
        //Ext.getCmp("SupplyPhaLoc2").setValue("");
        Ext.getCmp("StartDate2").setValue(DefaultStDate());
        Ext.getCmp("EndDate2").setValue(DefaultEdDate());
        Ext.getCmp("InItNo2").setValue("");
        Ext.getCmp("InRqNo2").setValue("");
        Ext.getCmp("Status").setValue("10");
        ItMasterInfoGrid.store.removeAll();
        ItDetailInfoGrid.store.removeAll();
    }

    // 3关闭按钮
    var closeBT = new Ext.Toolbar.Button({
        text: '关闭',
        tooltip: '关闭界面',
        iconCls: 'page_close',
        height: 30,
        width: 70,
        handler: function() {
            window.close();
        }
    });
    // 删除按钮
    var deleteBT = new Ext.Toolbar.Button({
        id: "deleteBT",
        text: '删除',
        tooltip: '点击删除',
        width: 70,
        height: 30,
        iconCls: 'page_delete',
        handler: function() {
            Ext.MessageBox.show({
                title: '提示',
                msg: '是否确定删除整张转移单?',
                buttons: Ext.MessageBox.YESNO,
                fn: DeleteHandler,
                icon: Ext.MessageBox.QUESTION
            });
        }
    });

    function DeleteHandler(btn) {
        if (btn == "yes") {
            var selectRows = ItMasterInfoGrid.getSelectionModel().getSelections();
            if (selectRows.length == 0) {
                Msg.info("warning", "请先选择需要删除的转移单!");
                return;
            }
            var initId = selectRows[0].get("init");
            var completeFlag = selectRows[0].get("comp");
            if (completeFlag == "Y") {
                Msg.info("warning", "转移单已完成不能删除!");
                return;
            }
            var url = DictUrl +
                "dhcinistrfaction.csp?actiontype=Delete&Rowid=" +
                initId;
            Ext.Ajax.request({
                url: url,
                method: 'POST',
                waitMsg: '删除处理中...',
                success: function(result, request) {
                    var jsonData = Ext.util.JSON
                        .decode(result.responseText);
                    if (jsonData.success == 'true') {
                        // 删除单据
                        Msg.info("success", "转移单删除成功!");
                        searchDurgData();
                    } else {
                        Msg.info("error", "转移单删除失败:" + jsonData.info);
                    }
                },
                scope: this
            });
        }
    }
    // 访问路径
    var MasterInfoUrl = DictUrl + 'dhcinistrfaction.csp?actiontype=Query';

    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
        url: MasterInfoUrl,
        method: "POST"
    });

    // 指定列参数
    var fields = ["init", "initNo", "reqNo", "toLocDesc", "frLocDesc", "dd", "tt", "comp", "userName", "status", "StatusCode"];

    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "init",
        fields: fields
    });

    // 数据集
    var ItMasterInfoStore = new Ext.data.Store({
        proxy: proxy,
        reader: reader
    });

    var nm = new Ext.grid.RowNumberer();
    var ItMasterInfoCm = new Ext.grid.ColumnModel([nm, {
        header: "RowId",
        dataIndex: 'init',
        width: 100,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: "转移单号",
        dataIndex: 'initNo',
        width: 150,
        align: 'left',
        sortable: true
    }, {
        header: "请求单号",
        dataIndex: 'reqNo',
        width: 150,
        align: 'left',
        sortable: true
    }, {
        header: "请求部门",
        dataIndex: 'toLocDesc',
        width: 200,
        align: 'left',
        sortable: true
    }, {
        header: "供给部门",
        dataIndex: 'frLocDesc',
        width: 200,
        align: 'left',
        sortable: true
    }, {
        header: '完成状态',
        dataIndex: 'comp',
        width: 90,
        align: 'center',
        sortable: true
    }, {
        header: '单据状态',
        dataIndex: 'StatusCode',
        width: 90,
        align: 'center',
        sortable: true
    }, {
        header: '日期',
        dataIndex: 'dd',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: "时间",
        dataIndex: 'tt',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: '制单人',
        dataIndex: 'userName',
        width: 100,
        align: 'left',
        sortable: true
    }]);
    ItMasterInfoCm.defaultSortable = true;

    var GridPagingToolbar = new Ext.PagingToolbar({
        store: ItMasterInfoStore,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
        emptyMsg: "没有记录"
    });

    var ItMasterInfoGrid = new Ext.grid.GridPanel({
        id: 'ItMasterInfoGrid',
        cm: ItMasterInfoCm,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        store: ItMasterInfoStore,
        trackMouseOver: true,
        stripeRows: true,
        loadMask: true,
        bbar: GridPagingToolbar
    });

    // 添加表格单击行事件
    ItMasterInfoGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
        var InIt = ItMasterInfoStore.getAt(rowIndex).get("init");
        ItDetailInfoStore.setBaseParam('Parref', InIt);
        ItDetailInfoStore.removeAll();
        ItDetailInfoStore.load({ params: { start: 0, limit: GridDetailPagingToolbar.pageSize, sort: 'Rowid', dir: 'Desc' } });
    });

    // 访问路径
    var DetailInfoUrl = DictUrl +
        'dhcinistrfaction.csp?actiontype=QueryDetail';

    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
        url: DetailInfoUrl,
        method: "POST"
    });

    // 指定列参数
    var fields = ["initi", "inrqi", "inci", "inciCode",
        "inciDesc", "inclb", "batexp", "manf", "manfName",
        "qty", "uom", "sp", "status", "remark",
        "reqQty", "inclbQty", "reqLocStkQty", "stkbin",
        "pp", "spec", "gene", "formDesc", "newSp",
        "spAmt", "rp", "rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty", "TrUomDesc"
    ];

    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "initi",
        fields: fields
    });

    // 数据集
    var ItDetailInfoStore = new Ext.data.Store({
        proxy: proxy,
        reader: reader
    });

    var nm = new Ext.grid.RowNumberer();
    var ItDetailInfoCm = new Ext.grid.ColumnModel([nm, {
        header: "转移细项RowId",
        dataIndex: 'initi',
        width: 100,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: '药品代码',
        dataIndex: 'inciCode',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: '药品名称',
        dataIndex: 'inciDesc',
        width: 200,
        align: 'left',
        sortable: true
    }, {
        header: "批次~效期",
        dataIndex: 'batexp',
        width: 200,
        align: 'left',
        sortable: true
    }, {
        header: "生产厂商",
        dataIndex: 'manfName',
        width: 180,
        align: 'left'
    }, {
        header: "转移数量",
        dataIndex: 'qty',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: "转移单位",
        dataIndex: 'TrUomDesc',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: "进价",
        dataIndex: 'rp',
        width: 60,
        align: 'right',

        sortable: true
    }, {
        header: "售价",
        dataIndex: 'sp',
        width: 60,
        align: 'right',

        sortable: true
    }, {
        header: "请求数量",
        dataIndex: 'reqQty',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: "货位码",
        dataIndex: 'stkbin',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: "批次售价",
        dataIndex: 'newSp',
        width: 100,
        align: 'right',

        sortable: true
    }, {
        header: "规格",
        dataIndex: 'spec',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: "处方通用名",
        dataIndex: 'gene',
        width: 120,
        align: 'left',
        sortable: true
    }, {
        header: "剂型",
        dataIndex: 'formDesc',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: "售价金额",
        dataIndex: 'spAmt',
        width: 100,
        align: 'right',

        sortable: true
    }]);
    ItDetailInfoCm.defaultSortable = true;

    var GridDetailPagingToolbar = new Ext.PagingToolbar({
        store: ItDetailInfoStore,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
        emptyMsg: "没有记录"
    });

    var ItDetailInfoGrid = new Ext.grid.GridPanel({
        title: '',
        height: 170,
        cm: ItDetailInfoCm,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        store: ItDetailInfoStore,
        trackMouseOver: true,
        stripeRows: true,
        bbar: GridDetailPagingToolbar,
        loadMask: true
    });

    // 双击事件
    ItMasterInfoGrid.on('rowdblclick', function() {
        returnData();
    });

    var InfoForm3 = new Ext.form.FormPanel({
        height: DHCSTFormStyle.FrmHeight(1),
        region: "north",
        frame: true,
        labelAlign: 'right',
        labelWidth: 60,
        id: "InfoForm3",
        tbar: [searchBT, '-', returnBT, '-', clearBT, '-', deleteBT, '-', closeBT],
        items: [{
            xtype: 'fieldset',
            title: '查询条件',
            style: DHCSTFormStyle.FrmPaddingV,
            defaults: { border: false },
            layout: 'column',
            items: [{
                columnWidth: .33,
                xtype: 'fieldset',
                items: [StartDate2, EndDate2]
            }, {
                columnWidth: .33,
                xtype: 'fieldset',
                items: [RequestPhaLoc2, Status]
            }, {
                columnWidth: .33,
                xtype: 'fieldset',
                items: [InItNo2, InRqNo2]
            }]
        }]
    });

    var window = new Ext.Window({
        title: '转移单查询',
        width: document.body.clientWidth * 0.9,
        height: document.body.clientHeight * 0.9,
        minWidth: document.body.clientWidth * 0.5,
        minHeight: document.body.clientHeight * 0.5,
        layout: 'border',
        items: [
            InfoForm3, {
                region: 'center',
                title: '出库单',
                collapsible: true,
                split: true,
                minSize: 175,
                maxSize: 400,
                layout: 'fit',
                items: ItMasterInfoGrid

            }, {
                region: 'south',
                title: '出库单明细',
                height: document.body.clientHeight * 0.9 * 0.4,
                layout: 'fit',
                items: ItDetailInfoGrid

            }
        ]
    });
    window.show();
    searchDurgData();
}