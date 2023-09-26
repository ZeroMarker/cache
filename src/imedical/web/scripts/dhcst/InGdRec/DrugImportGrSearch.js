// /名称: 查询界面
// /描述: 查询界面
// /编写者：zhangdongmei
// /编写日期: 2012.07.18
var deleteingdr = ""
var closeflag = ""

function DrugImportGrSearch(dataStore, Fn) {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    // 入库单号
    var InGrNoS = new Ext.form.TextField({
        fieldLabel: '入库单号',
        id: 'InGrNoS',
        name: 'InGrNoS',
        anchor: '90%',
        width: 120
    });

    // 供应商
    var VendorS = new Ext.ux.VendorComboBox({
        fieldLabel: '供应商',
        id: 'VendorS',
        name: 'VendorS',
        anchor: '90%',
        emptyText: '供应商...'
    });

    // 入库部门
    var PhaLocS = new Ext.ux.LocComboBox({
        fieldLabel: '入库部门',
        id: 'PhaLocS',
        name: 'PhaLocS',
        anchor: '90%',
        emptyText: '入库部门...',
        groupId: session['LOGON.GROUPID']
    });

    // 起始日期
    var StartDateS = new Ext.ux.DateField({
        fieldLabel: '起始日期',
        id: 'StartDateS',
        name: 'StartDateS',
        anchor: '90%',
        value: DefaultStDate()
    });

    // 结束日期
    var EndDateS = new Ext.ux.DateField({
        fieldLabel: '结束日期',
        id: 'EndDateS',
        name: 'EndDateS',
        anchor: '90%',
        value: DefaultEdDate()
    });

    // 检索按钮
    var searchBT = new Ext.Toolbar.Button({
        text: '查询',
        tooltip: '点击查询入库单信息',
        iconCls: 'page_find',
        height: 30,
        width: 70,
        handler: function() {
            searchDurgData();
        }
    });

    function searchDurgData() {
        var StartDate = Ext.getCmp("StartDateS").getValue();
        if ((StartDate != "") && (StartDate != null)) {
            StartDate = StartDate.format(App_StkDateFormat);
        }
        var EndDate = Ext.getCmp("EndDateS").getValue();
        if ((EndDate != "") && (EndDate != null)) {
            EndDate = EndDate.format(App_StkDateFormat);
        }
        var InGrNo = Ext.getCmp("InGrNoS").getValue();
        var Vendor = Ext.getCmp("VendorS").getValue();
        var PhaLoc = Ext.getCmp("PhaLocS").getValue();
        if (PhaLoc == "") {
            Msg.info("warning", "请选择入库部门!");
            return;
        }

        if (StartDate == "" || EndDate == "") {
            Msg.info("warning", "请选择开始日期和截止日期!");
            return;
        }
        var ListParam = StartDate + '^' + EndDate + '^' + InGrNo + '^' + Vendor + '^' + PhaLoc + '^^^N';
        var Page = GridPagingToolbar.pageSize;
        GrMasterInfoStore.baseParams = { ParamStr: ListParam };
        GrMasterInfoStore.removeAll();
        GrDetailInfoStore.removeAll();
        GrMasterInfoGrid.store.removeAll();
        GrMasterInfoStore.load({
            params: { start: 0, limit: Page },
            callback: function(r, options, success) {
                if (success == false) {
                    Msg.info("error", "查询错误，请查看日志!");
                } else {
                    if (r.length > 0) {
                        GrMasterInfoGrid.getSelectionModel().selectFirstRow();
                        GrMasterInfoGrid.getSelectionModel().fireEvent('rowselect', this, 0);
                        GrMasterInfoGrid.getView().focusRow(0);
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
            closeflag = "1";
            returnData();
        }
    });

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
        Ext.getCmp("InGrNoS").setValue("");
        Ext.getCmp("VendorS").setValue("");
        Ext.getCmp("PhaLocS").setValue(session['LOGON.CTLOCID']);
        Ext.getCmp("StartDateS").setValue(DefaultStDate());
        Ext.getCmp("EndDateS").setValue(DefaultEdDate());
        closeflag = "";
        deleteingdr = "";
        GrMasterInfoGrid.store.removeAll();
        GrDetailInfoGrid.store.removeAll();
    }

    // 3关闭按钮
    var closeBT = new Ext.Toolbar.Button({
        text: '关闭',
        tooltip: '关闭界面',
        iconCls: 'page_close',
        height: 30,
        width: 70,
        handler: function() {
            clearData();
            window.close();
        }
    });

    // 删除按钮
    var DeleteBT = new Ext.Toolbar.Button({
        id: "DeleteBT",
        text: '删除',
        tooltip: '点击删除',
        width: 70,
        height: 30,
        iconCls: 'page_delete',
        handler: function() {
            deleteData();
        }
    });

    function deleteData() {
        var selectRows = GrMasterInfoGrid.getSelectionModel().getSelections();
        if (selectRows.length == 0) {
            Ext.Msg.show({
                title: '错误',
                msg: '请选择要删除的入库单信息！',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
        } else {
            var InGrRowId = selectRows[0].get("IngrId");
            deleteingdr = InGrRowId;
            Ext.MessageBox.show({
                title: '提示',
                msg: '是否确定删除整张入库单',
                buttons: Ext.MessageBox.YESNO,
                fn: showDeleteGr,
                icon: Ext.MessageBox.QUESTION
            });
        }
    }

    /**
     * 删除入库单提示
     */
    function showDeleteGr(btn) {
        if (btn == "yes") {
            var url = DictUrl + "ingdrecaction.csp?actiontype=Delete&IngrRowid=" + deleteingdr;
            Ext.Ajax.request({
                url: url,
                method: 'POST',
                waitMsg: '处理中...',
                success: function(result, request) {
                    var jsonData = Ext.util.JSON
                        .decode(result.responseText);
                    if (jsonData.success == 'true') {
                        // 删除单据
                        Msg.info("success", "入库单删除成功!");
                        deleteingdr = "";
                        searchDurgData();
                    } else {
                        var ret = jsonData.info;
                        if (ret == -1) {
                            Msg.info("error", "入库单已经完成，不能删除!");
                        } else if (ret == -2) {
                            Msg.info("error", "入库单已经审核，不能删除!");
                        } else if (ret == -3) {
                            Msg.info("error", "入库单部分明细已经审核，不能删除!");
                        } else {
                            Msg.info("error", "删除失败,请查看错误日志!");
                        }
                    }
                },
                scope: this
            });
        }
    }

    // 访问路径
    var MasterInfoUrl = DictUrl + 'ingdrecaction.csp?actiontype=Query';

    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
        url: MasterInfoUrl,
        method: "POST"
    });

    // 指定列参数
    var fields = ["IngrId", "IngrNo", "Vendor", "RecLoc", "IngrType", "PurchUser",
        "PoNo", "CreateUser", "CreateDate", "Complete", "ReqLoc",
        "StkGrp", "RpAmt", "SpAmt"
    ];

    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "IngrId",
        fields: fields
    });

    // 数据集
    var GrMasterInfoStore = new Ext.data.Store({
        proxy: proxy,
        reader: reader
    });

    var nm = new Ext.grid.RowNumberer();
    var GrMasterInfoCm = new Ext.grid.ColumnModel([nm, {
        header: "RowId",
        dataIndex: 'IngrId',
        width: 100,
        align: 'left',
        sortable: true,
        hidden: true,
        hideable: false
    }, {
        header: "入库单号",
        dataIndex: 'IngrNo',
        width: 120,
        align: 'left',
        sortable: true
    }, {
        header: "供应商",
        dataIndex: 'Vendor',
        width: 200,
        align: 'left',
        sortable: true
    }, {
        header: '订购科室',
        dataIndex: 'RecLoc',
        width: 150,
        align: 'left',
        sortable: true
    }, {
        header: '创建人',
        dataIndex: 'CreateUser',
        width: 70,
        align: 'left',
        sortable: true
    }, {
        header: '创建日期',
        dataIndex: 'CreateDate',
        width: 90,
        align: 'left',
        sortable: true
    }, {
        header: '采购员',
        dataIndex: 'PurchUser',
        width: 70,
        align: 'left',
        sortable: true
    }, {
        header: "入库类型",
        dataIndex: 'IngrType',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: "完成标志",
        dataIndex: 'Complete',
        width: 70,
        align: 'left',
        sortable: true
    }, {
        header: "进价金额",
        dataIndex: 'RpAmt',
        width: 100,
        align: 'right',
        sortable: true
    }, {
        header: "售价金额",
        dataIndex: 'SpAmt',
        width: 100,
        align: 'right',
        sortable: true
    }]);
    GrMasterInfoCm.defaultSortable = true;

    var GridPagingToolbar = new Ext.PagingToolbar({
        store: GrMasterInfoStore,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
        emptyMsg: "没有记录"
    });

    var GrMasterInfoGrid = new Ext.grid.GridPanel({
        id: 'GrMasterInfoGrid',
        title: '',
        height: 170,
        cm: GrMasterInfoCm,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true,
            listeners: {
                'rowselect': function(sm, rowIndex, r) {
                    var InGr = GrMasterInfoStore.getAt(rowIndex).get("IngrId");
                    var pagesize = DetailGridPagingToolbar.pageSize;
                    GrDetailInfoStore.setBaseParam('Parref', InGr);
                    GrDetailInfoStore.load({ params: { start: 0, limit: pagesize, sort: 'Rowid', dir: 'Desc' } });
                }
            }
        }),
        store: GrMasterInfoStore,
        trackMouseOver: true,
        stripeRows: true,
        loadMask: true,
        bbar: GridPagingToolbar
    });

    // 添加表格单击行事件
    GrMasterInfoGrid.on('rowclick', function(grid, rowIndex, e) {
        //var InGr = GrMasterInfoStore.getAt(rowIndex).get("IngrId");
        //GrDetailInfoStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',Parref:InGr}});
    });

    // 访问路径
    var DetailInfoUrl = DictUrl +
        'ingdrecaction.csp?actiontype=QueryDetail';

    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
        url: DetailInfoUrl,
        method: "POST"
    });

    // 指定列参数
    var fields = ["Ingri", "BatchNo", "IngrUom", "ExpDate", "Inclb", "Margin", "RecQty",
        "Remarks", "IncCode", "IncDesc", "InvNo", "Manf", "Rp", "RpAmt",
        "Sp", "SpAmt", "InvDate", "QualityNo", "SxNo", "Remark", "MtDesc", "PubDesc"
    ];

    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "Ingri",
        fields: fields
    });

    // 数据集
    var GrDetailInfoStore = new Ext.data.Store({
        proxy: proxy,
        reader: reader
    });
    var nm = new Ext.grid.RowNumberer();
    var GrDetailInfoCm = new Ext.grid.ColumnModel([nm, {
        header: "Ingri",
        dataIndex: 'Ingri',
        width: 100,
        align: 'left',
        sortable: true,
        hidden: true,
        hideable: false
    }, {
        header: '药品代码',
        dataIndex: 'IncCode',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: '药品名称',
        dataIndex: 'IncDesc',
        width: 230,
        align: 'left',
        sortable: true
    }, {
        header: "厂商",
        dataIndex: 'Manf',
        width: 180,
        align: 'left',
        sortable: true
    }, {
        header: "批号",
        dataIndex: 'BatchNo',
        width: 90,
        align: 'left',
        sortable: true
    }, {
        header: "有效期",
        dataIndex: 'ExpDate',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: "单位",
        dataIndex: 'IngrUom',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: "数量",
        dataIndex: 'RecQty',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: "进价",
        dataIndex: 'Rp',
        width: 60,
        align: 'right',

        sortable: true
    }, {
        header: "售价",
        dataIndex: 'Sp',
        width: 60,
        align: 'right',

        sortable: true
    }, {
        header: "发票号",
        dataIndex: 'InvNo',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: "发票日期",
        dataIndex: 'InvDate',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: "进价金额",
        dataIndex: 'RpAmt',
        width: 100,
        align: 'left',

        sortable: true
    }, {
        header: "售价金额",
        dataIndex: 'SpAmt',
        width: 100,
        align: 'left',
        sortable: true
    }]);
    GrDetailInfoCm.defaultSortable = true;
    var DetailGridPagingToolbar = new Ext.PagingToolbar({
        store: GrDetailInfoStore,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
        emptyMsg: "没有记录"
    });
    var GrDetailInfoGrid = new Ext.grid.GridPanel({
        title: '',
        height: 170,
        cm: GrDetailInfoCm,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        store: GrDetailInfoStore,
        trackMouseOver: true,
        stripeRows: true,
        loadMask: true,
        bbar: DetailGridPagingToolbar
    });

    // 双击事件
    GrMasterInfoGrid.on('rowdblclick', function() {
        closeflag = "1";
        returnData();
    });
    var InfoFormS = new Ext.form.FormPanel({
        frame: true,
        labelAlign: 'right',
        id: "InfoFormS",
        region: "north",
        height: DHCSTFormStyle.FrmHeight(1),
        fit: true,
        layout: "fit",
        labelWidth: 60,
        tbar: [searchBT, '-', returnBT, '-', clearBT, '-', DeleteBT, '-', closeBT],
        items: [{
            layout: 'column',
            xtype: 'fieldset',
            title: '查询条件',
            style: DHCSTFormStyle.FrmPaddingV,
            defaults: { border: false },
            items: [{
                columnWidth: 0.33,
                xtype: 'fieldset',
                defaultType: 'textfield',
                items: [PhaLocS, VendorS]

            }, {
                columnWidth: 0.33,
                xtype: 'fieldset',
                items: [StartDateS, EndDateS]

            }, {
                columnWidth: 0.33,
                xtype: 'fieldset',
                items: [InGrNoS]

            }]
        }]
    });
    // 页面布局
    var mainPanel1 = new Ext.form.FormPanel({
        activeTab: 0,
        height: 410,
        width: 1200,
        region: 'center',
        layout: 'border',
        items: [{
            region: 'west',
            title: '入库单',
            collapsible: true,
            split: true,
            width: 225,
            minSize: 175,
            maxSize: 500,
            margins: '0 5 0 0',
            layout: 'fit',
            items: GrMasterInfoGrid

        }, {
            region: 'center',
            title: '入库单明细',
            layout: 'fit',
            items: GrDetailInfoGrid

        }]
    });

    var window = new Ext.Window({
        title: '入库单查询',
        width: document.body.clientWidth * 0.9,
        height: document.body.clientHeight * 0.9,
        minWidth: 600,
        minHeight: 300,
        layout: 'border',
        plain: true,
        modal: true,
        items: [InfoFormS, mainPanel1],

    });
    window.show();

    window.on('close', function(panel) {
        if (closeflag == "") { clearData(); }
        var selectRows = GrMasterInfoGrid.getSelectionModel().getSelections();
        if (selectRows.length == 0) {
            Fn("");
        } else {
            var InGrRowId = selectRows[0].get("IngrId");
            Fn(InGrRowId);
        }
    });

    function returnData() {
        var selectRows = GrMasterInfoGrid.getSelectionModel().getSelections();
        if (selectRows.length == 0) {
            Ext.Msg.show({
                title: '错误',
                msg: '请选择要返回的入库单信息！',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
        } else {
            var InGrRowId = selectRows[0].get("IngrId");
            var LockRet = DHCSTLockToggle(InGrRowId, "G", "L");
            if (LockRet != 0) {
                return false;
            }
            if ((gIngrRowid != "") && (gIngrRowid != InGrRowId)) {
                DHCSTLockToggle(gIngrRowid, "G", "UL"); //解锁上一张单据
            }
            //getInGrInfoByInGrRowId(InGrRowId, selectRows[0]);
            window.close();
        }
    }
}