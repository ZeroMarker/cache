///库存请求-查询
findRec = function(Fn, WinTitle) {
    //var ctLocId = session['LOGON.CTLOCID'];
    //var Arr = window.status.split(":");
    //var length = Arr.length;
    if ((WinTitle == null) || (WinTitle == undefined)) { WinTitle = ""; }
    var url = 'dhcst.inrequestaction.csp';
    var jReq = "";
    //起始日期
    var startDate = new Ext.ux.DateField({
        id: 'startDate',
        listWidth: 210,
        allowBlank: true,
        fieldLabel: '起始日期',
        anchor: '95%',
        value: new Date()
    });
    //截止日期
    var endDate = new Ext.ux.DateField({
        id: 'endDate',
        listWidth: 210,
        allowBlank: true,
        fieldLabel: '截止日期',
        anchor: '95%',
        value: new Date()
    });

    var Loc = new Ext.ux.LocComboBox({
        id: 'Loc',
        anchor: '95%',
        fieldLabel: '请求部门',
        emptyText: '请求部门...',
        groupId: gGroupId
    });
    /*
    GetGroupDeptStore.load();
    GetGroupDeptStore.on('load',function(ds,records,o){
    	Ext.getCmp('Loc').setRawValue(Arr[length-1]);
    	Ext.getCmp('Loc').setValue(ctLocId);
    });	
    */
    var SupplyLoc = new Ext.ux.LocComboBox({
        id: 'SupplyLoc',
        fieldLabel: '供给部门',
        anchor: '95%',
        emptyText: '供给部门...',
        defaultLoc: {}
    });

    var NoTransfer = new Ext.form.Checkbox({
        id: 'NoTransfer',
        fieldLabel: '未转移',
        allowBlank: true,
        checked: true
    });

    var PartTransfer = new Ext.form.Checkbox({
        id: 'PartTransfer',
        fieldLabel: '部分转移',
        allowBlank: true,
        checked: true
    });

    var AllTransfer = new Ext.form.Checkbox({
        id: 'AllTransfer',
        fieldLabel: '全部转移',
        allowBlank: true
    });

    var Over = new Ext.form.Checkbox({
        id: 'Over',
        fieldLabel: '完成',
        allowBlank: true
    });
    var NotIncludeTrans = new Ext.form.Checkbox({
        id: 'NotIncludeTrans',
        fieldLabel: '不包含已转移',
        allowBlank: true,
        handler: function() {
            var rowrecord = Grid.getSelectionModel().getSelected();
            var recordrow = OrderDs.indexOf(rowrecord);
            if (recordrow >= 0) {
                Grid.getSelectionModel().selectRow(recordrow);
                Grid.focus();
                Grid.getView().focusRow(recordrow);
            }
        }

    });
    var fB = new Ext.Toolbar.Button({
        text: '查询',
        tooltip: '查询',
        iconCls: 'page_find',
        width: 70,
        height: 30,
        handler: function() {
            QueryReqList();

        }
    });

    function QueryReqList() {
        var startDate = Ext.getCmp('startDate').getValue();
        if ((startDate != "") && (startDate != null)) {
            startDate = startDate.format(App_StkDateFormat);
        } else {
            Msg.info("error", "请选择起始日期!");
            return false;
        }
        var endDate = Ext.getCmp('endDate').getValue();
        if ((endDate != "") && (endDate != null)) {
            endDate = endDate.format(App_StkDateFormat);
        } else {
            Msg.info("error", "请选择截止日期!");
            return false;
        }

        var toLocId = Ext.getCmp('Loc').getValue();
        if ((toLocId == "") || (toLocId == null)) {
            Msg.info("error", "请选择请求部门!");
            return false;
        }
        var frLocId = Ext.getCmp('SupplyLoc').getValue();
        var comp = (Ext.getCmp('Over').getValue() == true ? 'Y' : 'N');
        var noTrans = (Ext.getCmp('NoTransfer').getValue() == true ? 1 : 0);
        var partTrans = (Ext.getCmp('PartTransfer').getValue() == true ? 1 : 0);
        var allTrans = (Ext.getCmp('AllTransfer').getValue() == true ? 1 : 0);
        if ((partTrans == 1) || (allTrans == 1)) {
            comp = "Y";
        }
        var tranStatus = noTrans + "%" + partTrans + "%" + allTrans;
        var strPar = startDate + "^" + endDate + "^" + toLocId + "^" + frLocId + "^" + comp + "^" + tranStatus;
        OrderDs2.removeAll();
        OrderDs.removeAll();
        OrderDs.load({ params: { start: 0, limit: pagingToolbar3.pageSize, sort: '', dir: 'desc', strPar: strPar } });
        OrderDs.on('load', function() {
            if (OrderDs.getCount() > 0) {
                Grid.getSelectionModel().selectFirstRow();
                Grid.focus();
                Grid.getView().focusRow(0);
            }

        })
    }
    var cB = new Ext.Toolbar.Button({
        text: '清屏',
        tooltip: '清屏',
        iconCls: 'page_clearscreen',
        width: 70,
        height: 30,
        handler: function() {
            OrderDs.removeAll();
            OrderDs2.removeAll();
        }
    });

    var closeB = new Ext.Toolbar.Button({
        iconCls: 'page_close',
        height: 30,
        width: 70,
        text: '关闭',
        tooltip: '关闭',
        handler: function() {
            findWin.close();
        }
    });

    var deleteB = new Ext.Toolbar.Button({
        iconCls: 'page_delete',
        height: 30,
        width: 70,
        text: '删除',
        tooltip: '点击删除未完成库存请求',
        handler: function() {
            var selectRows = Grid.getSelectionModel().getSelections();
            if (selectRows.length == 0) {
                Msg.info("warning", "请先选择需要删除的请求单!");
            } else {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: '是否确定删除请求单',
                    buttons: Ext.MessageBox.YESNO,
                    fn: DeleteHandler,
                    icon: Ext.MessageBox.QUESTION
                });
            }
        }
    });

    function DeleteHandler(btn) {
        if (btn == "yes") {
            var selectRows = Grid.getSelectionModel().getSelections();
            var reqId = selectRows[0].get("req");
            Ext.Ajax.request({
                url: DictUrl + "inrequestaction.csp?actiontype=Delete",
                method: 'POST',
                params: { req: reqId },
                success: function(response, opts) {
                    var jsonData = Ext.util.JSON.decode(response.responseText);
                    if (jsonData.success == 'true') {
                        Msg.info("success", "删除成功!");
                        QueryReqList();

                    } else {
                        if (jsonData.info == -1) {
                            Msg.info("warning", "该请求单已完成，不允许删除！");
                        } else {
                            Msg.info("error", "删除失败:" + jsonData.info);
                        }
                    }
                },
                failure: function(response, opts) {
                    Msg.info("error", "server-side failure with status code：" + response.status);
                }

            });
        }
    }
    var OrderProxy = new Ext.data.HttpProxy({ url: url + '?actiontype=query', method: 'GET' });
    var OrderDs = new Ext.data.Store({
        proxy: OrderProxy,
        reader: new Ext.data.JsonReader({
            totalProperty: 'results',
            root: 'rows'
        }, [
            { name: 'req' },
            { name: 'reqNo' },
            { name: 'toLoc' },
            { name: 'toLocDesc' },
            { name: 'frLoc' },
            { name: 'frLocDesc' },
            { name: 'reqUser' },
            { name: 'userName' },
            { name: 'date' },
            { name: 'time' },
            { name: 'status' },
            { name: 'comp' },
            { name: 'remark' }
        ]),
        remoteSort: false
    });


    var OrderCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(),
        {
            header: 'rowid',
            dataIndex: 'req',
            width: 100,
            hidden: true,
            align: 'left'
        }, {
            header: '请求编号',
            dataIndex: 'reqNo',
            width: 125,
            sortable: true,
            align: 'left'
        }, {
            header: '请求部门',
            dataIndex: 'toLocDesc',
            width: 125,
            sortable: true,
            align: 'left'
        }, {
            header: "供给部门",
            dataIndex: 'frLocDesc',
            width: 125,
            align: 'left',
            sortable: true
        }, {
            header: "请求人",
            dataIndex: 'userName',
            width: 125,
            align: 'left',
            sortable: true
        }, {
            header: "日期",
            dataIndex: 'date',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: "时间",
            dataIndex: 'time',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: '完成状态',
            dataIndex: 'comp',
            align: 'center',
            width: 100,
            sortable: true,
            renderer: function(v, p, record) {
                p.css += ' x-grid3-check-col-td';
                return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
            }
        }, {
            header: "其他状态",
            dataIndex: 'status',
            width: 100,
            align: 'left',
            renderer: function(value) {
                var status = "";
                if (value == 0) {
                    status = "未转移";
                } else if (value == 1) {
                    status = "部分转移";
                } else if (value == 2) {
                    status = "全部转移";
                }
                return status;
            },
            sortable: true
        }, {
            header: '备注',
            dataIndex: 'remark',
            width: 130,
            align: 'left'
        }
    ]);
    var pagingToolbar3 = new Ext.PagingToolbar({
        store: OrderDs,
        pageSize: 20,
        displayInfo: true,
        displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
        emptyMsg: "没有记录",
        doLoad: function(C) {
            var B = {},
                A = this.getParams();
            B[A.start] = C;
            B[A.limit] = this.pageSize;
            B['sort'] = 'req';
            B['dir'] = 'desc';
            B['strPar'] = Ext.getCmp('startDate').getValue().format(App_StkDateFormat) + "^" + Ext.getCmp('endDate').getValue().format(App_StkDateFormat) + "^" + Ext.getCmp('Loc').getValue() + "^" + Ext.getCmp('SupplyLoc').getValue() + "^" + (Ext.getCmp('Over').getValue() == true ? 'Y' : 'N') + "^" + (Ext.getCmp('NoTransfer').getValue() == true ? 1 : 0) + "%" + (Ext.getCmp('PartTransfer').getValue() == true ? 1 : 0) + "%" + (Ext.getCmp('AllTransfer').getValue() == true ? 1 : 0);
            if (this.fireEvent("beforechange", this, B) !== false) {
                this.store.load({ params: B });
            }
        }
    });

    var Grid = new Ext.grid.GridPanel({
        region: 'center',
        store: OrderDs,
        cm: OrderCm,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
        loadMask: true,
        height: 225,
        bbar: pagingToolbar3
    });

    var OrderProxy2 = new Ext.data.HttpProxy({ url: url + '?actiontype=queryDetail', method: 'GET' });
    var OrderDs2 = new Ext.data.Store({
        proxy: OrderProxy2,
        reader: new Ext.data.JsonReader({
            totalProperty: 'results',
            root: 'rows'
        }, [
            { name: 'rowid' },
            { name: 'cancel' },
            { name: 'inci' },
            { name: 'code' },
            { name: 'desc' },
            { name: 'qty' },
            { name: 'uom' },
            { name: 'uomDesc' },
            { name: 'spec' },
            { name: 'manf' },
            { name: 'sp' },
            { name: 'spAmt' },
            { name: 'generic' },
            { name: 'drugForm' },
            { name: 'remark' }
        ]),
        remoteSort: false
    });


    var OrderCm2 = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(),
        {
            header: '作废',
            dataIndex: 'cancel',
            width: 60,
            sortable: true,
            align: 'center',
            renderer: function(v) {
                return '<input type="checkbox"' + (v == "1" ? "checked" : "") + '/>'; //根据值返回checkbox是否勾选    
            }
        }, {
            header: '代码',
            dataIndex: 'code',
            width: 100,
            sortable: true,
            align: 'left'
        }, {
            header: '名称',
            dataIndex: 'desc',
            width: 220,
            sortable: true,
            align: 'left'
        }, {
            header: "厂商",
            dataIndex: 'manf',
            width: 120,
            align: 'left',
            sortable: true
        }, {
            header: "请求数量",
            dataIndex: 'qty',
            width: 80,
            align: 'right',
            sortable: true
        }, {
            header: "单位",
            dataIndex: 'uomDesc',
            width: 72,
            align: 'left',
            sortable: true
        }, {
            header: '售价',
            dataIndex: 'sp',
            align: 'right',
            width: 80,
            sortable: true
        }, {
            header: "售价金额",
            dataIndex: 'spAmt',
            width: 80,
            align: 'right',
            sortable: true
        }, {
            header: '处方通用名',
            dataIndex: 'generic',
            align: 'left',
            width: 120,
            sortable: true
        }, {
            header: '剂型',
            dataIndex: 'drugForm',
            align: 'left',
            width: 120,
            sortable: true
        }, {
            header: '备注',
            dataIndex: 'remark',
            align: 'left',
            width: 80,
            sortable: true
        }, {
            header: '规格',
            dataIndex: 'spec',
            align: 'left',
            width: 120,
            sortable: true
        }
    ]);
    var pagingToolbar4 = new Ext.PagingToolbar({
        store: OrderDs2,
        pageSize: 20,
        displayInfo: true,
        displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
        emptyMsg: "没有记录"
    });
    var detailTBar = new Ext.Toolbar({
        region: 'center',
        items: [NotIncludeTrans, "不包含已转移"]
    });
    var Grid2 = new Ext.grid.GridPanel({
        region: 'south',
        store: OrderDs2,
        cm: OrderCm2,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({ singleSelect: false }),
        loadMask: true,
        height: 225,
        tbar: [],
        bbar: pagingToolbar4,
        listeners: {
            'render': function() {
                if (WinTitle == "复制库存转移请求单") {
                    detailTBar.render(this.tbar);

                }
            }

        }
    });

    Grid.getSelectionModel().on('rowselect', function(sm, rowIndex, rec) {
        OrderDs2.removeAll();
        jReq = OrderDs.data.items[rowIndex].data["req"];
        jReq = jReq;
        var transflag = (Ext.getCmp('NotIncludeTrans').getValue() == true ? 0 : "");
        OrderDs2.setBaseParam('req', jReq);
        OrderDs2.setBaseParam('sort', 'rowid');
        OrderDs2.setBaseParam('dir', 'desc');
        OrderDs2.setBaseParam('TransferedFlag', transflag);
        OrderDs2.load({ params: { start: 0, limit: pagingToolbar4.pageSize } });
    });
    Grid.on('rowdblclick', function(grid, rowIndex, e) {
        var rec = OrderDs.data.items[rowIndex];
        req = rec.data["req"];
        var transflag = (Ext.getCmp('NotIncludeTrans').getValue() == true ? 1 : 0);
        Fn(req, transflag);
        findWin.close();
    });

    var conPanel = new Ext.form.FormPanel({
        region: 'north',
        labelWidth: 60,
        autoScroll: true,
        labelAlign: 'right',
        autoHeight: true,
        tbar: [fB, '-', cB, '-', deleteB, '-', closeB],
        frame: true,
        layout: 'fit',
        items: [{
            xtype: 'fieldset',
            title: '查询条件',
            layout: 'column',
            autoHeight: true,
            style: DHCSTFormStyle.FrmPaddingV,
            items: [{
                    columnWidth: .2,
                    xtype: 'fieldset',
                    border: false,
                    items: [startDate, endDate]
                },
                {
                    columnWidth: .3,
                    xtype: 'fieldset',
                    border: false,
                    items: [SupplyLoc, Loc]
                },
                {
                    columnWidth: .1,
                    xtype: 'fieldset',
                    border: false,
                    items: [NoTransfer, Over]
                }, {
                    columnWidth: .1,
                    xtype: 'fieldset',
                    border: false,
                    items: [PartTransfer]
                }, {
                    columnWidth: .1,
                    xtype: 'fieldset',
                    border: false,
                    items: [AllTransfer]
                }
            ]
        }]
    });

    var findWin = new Ext.Window({
        title: '查找库存转移请求单',
        height: document.body.clientHeight * 0.9,
        width: document.body.clientWidth * 0.9,
        minWidth: document.body.clientWidth * 0.5,
        minHeight: document.body.clientHeight * 0.5,
        layout: 'border',
        plain: true,
        modal: true,
        //bodyStyle:'padding:5px;',
        buttonAlign: 'center',
        items: [{
            region: 'north',
            height: DHCSTFormStyle.FrmHeight(1),
            layout: 'fit',
            items: conPanel
        }, {
            region: 'center',
            height: 180,
            layout: 'fit',
            items: Grid

        }, {
            region: 'south',
            split: true,
            height: document.body.clientHeight * 0.95 * 0.4,
            minSize: 100,
            maxSize: 400,
            layout: 'fit',
            items: Grid2

        }]
    });

    if (WinTitle == "复制库存转移请求单") {
        findWin.title = WinTitle;
    }
    //显示窗口
    findWin.show();
    CopyComboBoxStore({ frombox: "LocField", tobox: "Loc" });
    CopyComboBoxStore({ frombox: "supplyLocField", tobox: "SupplyLoc" });
};