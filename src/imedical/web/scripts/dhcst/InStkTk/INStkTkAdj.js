// /名称: 盘点单调整
// /描述: 盘点单调整
// /编写者：zhangdongmei
// /编写日期: 2012.09.12
Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gStrParams = '';
    var gRowid = '';
    Ext.Ajax.timeout = 900000;
    var gGroupId = session["LOGON.GROUPID"];
    var url = DictUrl + 'instktkaction.csp';
    var PhaLoc = new Ext.ux.LocComboBox({
        fieldLabel: $g('科室'),
        id: 'PhaLoc',
        name: 'PhaLoc',
        anchor: '90%',
        emptyText: $g('科室...'),
        groupId: gGroupId
    });

    // 起始日期
    var StartDate = new Ext.ux.DateField({
        fieldLabel: $g('起始日期'),
        id: 'StartDate',
        name: 'StartDate',
        anchor: '90%',
        width: 80,
        value: new Date().add(Date.DAY, -30)
    });

    // 结束日期
    var EndDate = new Ext.ux.DateField({
        fieldLabel: $g('结束日期'),
        id: 'EndDate',
        name: 'EndDate',
        anchor: '90%',
        width: 80,
        value: new Date()
    });

    // 查询按钮
    var QueryBT = new Ext.Toolbar.Button({
        text: $g('查询'),
        tooltip: $g('点击查询'),
        iconCls: 'page_find',
        width: 70,
        height: 30,
        handler: function () {
            Query();
        }
    });

    //查询盘点单
    function Query() {

        var StartDate = Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();;
        var EndDate = Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();
        var PhaLoc = Ext.getCmp("PhaLoc").getValue();
        if (PhaLoc == "") {
            Msg.info("warning", $g("请选择盘点科室!"));
            return;
        }
        if (StartDate == "" || EndDate == "") {
            Msg.info("warning", $g("请选择开始日期和截止日期!"));
            return;
        }
        var CompFlag = 'Y';
        var TkComplete = 'Y'; //实盘完成标志
        var AdjComplete = 'N'; //调整完成标志
        var Page = GridPagingToolbar.pageSize;
        gStrParams = PhaLoc + '^' + StartDate + '^' + EndDate + '^' + CompFlag + '^' + TkComplete + '^' + AdjComplete;
        MasterInfoStore.load({
            params: {
                actiontype: 'Query',
                start: 0,
                limit: Page,
                sort: 'instNo',
                dir: 'asc',
                Params: gStrParams
            }
        });
    }

    // 清空按钮
    var RefreshBT = new Ext.Toolbar.Button({
        text: $g('清屏'),
        tooltip: $g('点击清屏'),
        iconCls: 'page_clearscreen',
        width: 70,
        height: 30,
        handler: function () {
            clearData();
        }
    });

    /**
     * 清空方法
     */
    function clearData() {

        gStrParams = '';
        var stDate = new Date().add(Date.DAY, -30);
        var edDate = new Date();
        Ext.getCmp("StartDate").setValue(stDate);
        Ext.getCmp("EndDate").setValue(edDate);

        MasterInfoStore.removeAll();
        MasterInfoStore.load({
            params: {
                start: 0,
                limit: 0
            }
        })
        MasterInfoGrid.getView().refresh();
        GridPagingToolbar.updateInfo();
        StatuTabPagingToolbar.updateInfo();
        gRowid = ""
        InstDetailStore.removeAll();
        InstDetailStore.load({
            params: {
                actiontype: 'QueryDetail',
                start: 0,
                limit: 0,
                Parref: 0
            }
        })
        InstDetailGrid.getView().refresh();


    }

    var CompleteBT = new Ext.Toolbar.Button({
        text: $g('确认'),
        tooltip: $g('点击确认调整'),
        iconCls: 'page_gear',
        width: 70,
        height: 30,
        handler: function () {
            Complete();
        }
    });

    function Complete() {

        var selectRow = MasterInfoGrid.getSelectionModel().getSelected();
        if (selectRow == null || selectRow == "") {
            Msg.info("Warning", $g("请选择要调整的盘点单!"));
            return;
        }

        var inst = selectRow.get('inst');
        if (inst == null || inst == "") {
            Msg.info("Warning", $g("请选择要调整的盘点单!"));
            return;
        }
        var userId = session['LOGON.USERID'];
        var mask = ShowLoadMask(Ext.getBody(), $g("处理中..."));
        Ext.Ajax.request({
            url: url,
            params: {
                actiontype: 'StkTkAdj',
                Inst: inst,
                UserId: userId
            },
            method: 'post',
            waitMsg: $g('处理中...'),
            success: function (response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                if (jsonData.success == 'true') {
                    Msg.info("success", $g("调整成功!"));
                    Query();
                    InstDetailGrid.store.removeAll();
                    InstDetailGrid.store.load({
                        params: {
                            start: 0,
                            limit: 0
                        }
                    })
                    InstDetailGrid.getView().refresh();
                } else {
                    var ret = jsonData.info;
                    if (ret == -1) {
                        Msg.info("error", $g("该盘点单账盘尚未完成!"));
                    } else if (ret == -2) {
                        Msg.info("error", $g("该盘点单实盘数尚未汇总!"));
                    } else if (ret == -3) {
                        Msg.info("error", $g("该盘点单已经调整!"));
                    } else if (ret == -4) {
                        Msg.info("error", $g("保存调整单失败!"));
                    } else if (ret == -6) {
                        Msg.info("error", $g("保存调整明细失败!"));
                    } else if (ret == -8) {
                        Msg.info("error", $g("调整审核失败!"));
                    } else {
                        ret = ret.replace('-8:-100^', '');
                        Ext.Msg.show({
                            title: '错误提示',
                            msg: ret,
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    }
                }

                mask.hide();
            }
        });
    }

    var SaveBT = new Ext.Toolbar.Button({
        text: $g('保存'),
        tooltip: $g('点击保存修改后的实盘数量'),
        iconCls: 'page_save',
        width: 70,
        height: 30,
        handler: function () {
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
                var desc = rowData.get('desc');
                var rowid = rowData.get('rowid');
                var inclb = rowData.get('inclb');
                var countQty = rowData.get('countQty');
                var freQty = rowData.get('freQty');
                var curqty = rowData.get('curqty');
                var afterqty = Number(countQty) - Number(freQty) + Number(curqty)
                if (afterqty < 0) {
                    changeBgColor(i, "yellow");
                    Msg.info("warning", desc + $g(",第") + i + $g("行调整后库存为负数,请修改实盘数!"));
                    return;
                }
                var Detail = rowid + '^' + inclb + '^' + countQty;
                if (ListDetail == '') {
                    ListDetail = Detail;
                } else {
                    ListDetail = ListDetail + xRowDelim() + Detail;
                }
            }
        }
        if (ListDetail == '') {
            Msg.info('Warning', $g('没有需要保存的数据!'));
            return;
        }
        var mask = ShowLoadMask(Ext.getBody(), $g("处理中请稍候..."));
        Ext.Ajax.request({
            url: url,
            params: {
                actiontype: 'SaveAdjInput',
                Params: ListDetail
            },
            method: 'post',
            waitMsg: $g('处理中...'),
            success: function (response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    Msg.info('success', $g('保存成功!'));
                    InstDetailStore.reload();
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

    // 变换行颜色
    function changeBgColor(row, color) {
        InstDetailGrid.getView().getRow(row).style.backgroundColor = color;
    }

    // 指定列参数
    var fields = ["inst", "instNo", "date", "time", "userName", "status", "locDesc", "comp", "stktkComp",
        "adjComp", "adj", "manFlag", "freezeUom", "includeNotUse", "onlyNotUse", "scgDesc", "scDesc", "frSb", "toSb"
    ];
    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "inst",
        fields: fields
    });
    // 数据集
    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
        url: url,
        method: "POST"
    });
    var MasterInfoStore = new Ext.data.Store({
        proxy: proxy,
        reader: reader
    });

    function renderManaFlag(value) {
        if (value == 'Y') {
            return $g('管理药');
        } else {
            return $g('非管理药')
        }
    }

    function renderYesNo(value) {
        if (value == 'Y') {
            return $g('是');
        } else {
            return $g('否')
        }
    }
    var nm = new Ext.grid.RowNumberer();
    var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
        header: "RowId",
        dataIndex: 'inst',
        width: 100,
        align: 'left',
        sortable: true,
        hidden: true,
        hideable: false
    }, {
        header: $g("盘点单号"),
        dataIndex: 'instNo',
        width: 150,
        align: 'left',
        sortable: true
    }, {
        header: $g("盘点日期"),
        dataIndex: 'date',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g('盘点时间'),
        dataIndex: 'time',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g('盘点人'),
        dataIndex: 'userName',
        width: 70,
        align: 'left',
        sortable: true
    }, {
        header: $g('管理药标志'),
        dataIndex: 'manFlag',
        width: 80,
        align: 'left',
        renderer: renderManaFlag,
        sortable: true
    }, {
        header: $g("账盘单位"),
        dataIndex: 'freezeUom',
        width: 80,
        align: 'left',
        renderer: function (value) {
            if (value == 1) {
                return $g('入库单位');
            } else {
                return $g('基本单位');
            }
        },
        sortable: true
    }, {
        header: $g("包含不可用"),
        dataIndex: 'includeNotUse',
        width: 80,
        align: 'center',
        renderer: renderYesNo,
        sortable: true
    }, {
        header: $g("仅不可用"),
        dataIndex: 'onlyNotUse',
        renderer: renderYesNo,
        width: 60,
        align: 'center',
        sortable: true
    }, {
        header:$g( "类组"),
        dataIndex: 'scgDesc',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g("库存分类"),
        dataIndex: 'scDesc',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g("开始货位"),
        dataIndex: 'frSb',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g("截止货位"),
        dataIndex: 'toSb',
        width: 100,
        align: 'left',
        sortable: true
    }]);
    MasterInfoCm.defaultSortable = true;
    var GridPagingToolbar = new Ext.PagingToolbar({
        store: MasterInfoStore,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: $g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
        emptyMsg: "No results to display",
        prevText:$g( "上一页"),
        nextText: $g("下一页"),
        refreshText: $g("刷新"),
        lastText: $g("最后页"),
        firstText: $g("第一页"),
        beforePageText: $g("当前页"),
        afterPageText:$g( "共{0}页"),
        emptyMsg: $g("没有数据")
        /*,
                            doLoad:function(C){
                                var B={},
                                A=this.getParams();
                                B[A.start]=C;
                                B[A.limit]=this.pageSize;
                                B[A.sort]='Rowid';
                                B[A.dir]='desc';
                                B['Params']=gStrParams;
                                B['actiontype']='Query';
                                if(this.fireEvent("beforechange",this,B)!==false){
                                    this.store.load({params:B});
                                }
                            }*/
    });
    var MasterInfoGrid = new Ext.grid.GridPanel({
        id: 'MasterInfoGrid',
        title: $g('盘点单'),
        height: 170,
        cm: MasterInfoCm,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        store: MasterInfoStore,
        trackMouseOver: true,
        stripeRows: true,
        loadMask: true,
        bbar: [GridPagingToolbar]
    });
    MasterInfoStore.on('load', function () {
        if (MasterInfoStore.getCount() > 0) {
            MasterInfoGrid.getSelectionModel().selectRow(0);
            MasterInfoGrid.getView().focusRow(0);
        } else {
            gRowid = ""
            InstDetailStore.removeAll();
            InstDetailStore.load({
                params: {
                    actiontype: 'QueryDetail',
                    start: 0,
                    limit: 0,
                    Parref: 0
                }
            })
            InstDetailGrid.getView().refresh();
        }
    });
    // 添加表格单击行事件
    MasterInfoGrid.on('rowclick', QueryDetail);
    MasterInfoGrid.getSelectionModel().on('rowselect', QueryDetail);

    function QueryDetail(sm, rowIndex, r) {
        var selectRow = MasterInfoStore.getAt(rowIndex);
        gRowid = selectRow.get('inst');
        var size = StatuTabPagingToolbar.pageSize;
        var othersArr = [];
        othersArr[4] = (Ext.getCmp("adjFail").getValue() == true) ? 'Y' : 'N';
        othersArr[5] = (Ext.getCmp("avaLessAdj").getValue() == true) ? 'Y' : 'N';
        InstDetailStore.load({
            params: {
                actiontype: 'QueryDetail',
                start: 0,
                limit: size,
                sort: 'rowid',
                dir: 'ASC',
                Parref: gRowid,
                Params: othersArr.join("^")
            }
        });
    }
   function StatusColorRenderer(val,meta){
			if (val==$g("已调整"))
			meta.css='classCyan';
			return val
		
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
        header: "inclb",
        dataIndex: 'inclb',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: $g('状态'),
        dataIndex: 'statusi',
        width: 60,
        align: 'left',
        sortable: true,
		renderer:StatusColorRenderer
    }, {
        header: $g('代码'),
        dataIndex: 'code',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g("名称"),
        dataIndex: 'desc',
        width: 200,
        align: 'left',
        sortable: true
    }, {
        header: $g("规格"),
        dataIndex: 'spec',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g('批号'),
        dataIndex: 'batchNo',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: $g('效期'),
        dataIndex: 'expDate',
        width: 100,
        align: 'right',
        sortable: true
    }, {
        header: $g("单位"),
        dataIndex: 'uomDesc',
        width: 60,
        align: 'left',
        sortable: true
    }, {
        header: $g('冻结数量'),
        dataIndex: 'freQty',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: '<font color=blue>'+$g('实盘数量')+'</font>',
        dataIndex: 'countQty',
        width: 80,
        align: 'right',
        sortable: true,
        editor: new Ext.form.NumberField({
            selectOnFocus: true,
            allowNegative: false,
            listeners: {
                'specialkey': function (field, e) {
                    var keyCode = e.getKey();
                    if (keyCode == 8) { //屏蔽backspace建
                        return;
                    }
                    var col = GetColIndex(InstDetailGrid, 'countQty');
                    var cell = InstDetailGrid.getSelectionModel().getSelectedCell();
                    InstDetailGrid.stopEditing(cell[0], col);
                    var record = InstDetailGrid.getStore().getAt(cell[0]);
                    var rowCount = InstDetailGrid.getStore().getCount();
                    if (keyCode == Ext.EventObject.ENTER) {
                        var qty = field.getValue();
                        if (qty < 0) {
                            Msg.info('warning', $g('实盘数量不能小于零!'));
                            return;
                        }
                        var freQty = record.get("freQty")
                        record.set("variance", (Number(qty) - Number(freQty)));
                        var row = cell[0] + 1;
                        if (row < rowCount) {
                            var task = new Ext.util.DelayedTask(function () {
                                InstDetailGrid.startEditing(row, col);
                            })
                            task.delay(100);
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
        header: $g('损益数量'),
        dataIndex: 'variance',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: $g('可用库存'),
        dataIndex: 'avaqty',
        width: 100,
        align: 'right',
        sortable: true
    }, {
        header: $g('当前库存'),
        dataIndex: 'curqty',
        width: 100,
        align: 'right',
        sortable: true
    }, {
        header: $g('调后库存'),
        dataIndex: 'afterqty',
        width: 100,
        align: 'right',
        sortable: true
    }, {
        header: $g("生产企业"),
        dataIndex: 'manf',
        width: 100,
        align: 'right',
        sortable: true
    },{
		header:$g('账盘进价金额'),
		dataIndex:'freezeRpAmt',
		width:120,
		align:'right',
		sortable:true
	},{
		header:$g('实盘进价金额'),
		dataIndex:'countRpAmt',
		width:120,
		align:'right',
		sortable:true
	},{
		header:$g('账盘售价金额'),
		dataIndex:'freezeSpAmt',
		width:120,
		align:'right',
		sortable:true
	},{
		header:$g('实盘售价金额'),
		dataIndex:'countSpAmt',
		width:120,
		align:'right',
		sortable:true
	},{
		header:$g('进价差额'),
		dataIndex:'varianceRpAmt',
		width:120,
		align:'right',
		sortable:true
	},{
		header:$g('售价差额'),
		dataIndex:'varianceSpAmt',
		width:120,
		align:'right',
		sortable:true
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
            fields: ["rowid", "inclb", "inci", "code", "desc", "spec", "manf", "batchNo", "expDate",
                "freQty", "uom", "uomDesc", "countQty", "freDate", "freTime",
                "countDate", "countTime", "countPersonName", "variance", "curqty", "afterqty", "avaqty","statusi" 
            ,"freezeSpAmt","freezeRpAmt","countSpAmt","countRpAmt","varianceSpAmt","varianceRpAmt"]
        }),
        remoteSort: true,
        pruneModifiedRecords: true
    });

    var StatuTabPagingToolbar = new Ext.PagingToolbar({
        store: InstDetailStore,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: $g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
        prevText: $g("上一页"),
        nextText: $g("下一页"),
        refreshText: $g("刷新"),
        lastText: $g("最后页"),
        firstText: $g("第一页"),
        beforePageText: $g("当前页"),
        afterPageText: $g("共{0}页"),
        emptyMsg: $g("没有数据"),
        doLoad: function (C) {
            var B = {},
                A = this.getParams();
            B[A.start] = C;
            B[A.limit] = this.pageSize;
            B[A.sort] = 'rowid';
            B[A.dir] = 'asc';
            B['Parref'] = gRowid;
            B['actiontype'] = 'QueryDetail';
            var othersArr = [];
            othersArr[4] = (Ext.getCmp("adjFail").getValue() == true) ? 'Y' : 'N';
            othersArr[5] = (Ext.getCmp("avaLessAdj").getValue() == true) ? 'Y' : 'N';
            B['Params'] = othersArr.join("^");
            if (this.fireEvent("beforechange", this, B) !== false) {
                this.store.load({
                    params: B
                });
            }
        }
    });

    StatuTabPagingToolbar.addListener('beforechange', function (toolbar, params) {
        if (InstDetailGrid.activeEditor != null) {
            InstDetailGrid.activeEditor.completeEdit();
        }
        var records = InstDetailStore.getModifiedRecords();
        if (records.length > 0) {
            Ext.Msg.show({
                title: $g('提示'),
                msg: $g('本页数据发生改变，是否需要保存？'),
                buttons: Ext.Msg.YESNOCANCEL,
                fn: function (btn, text, opt) {
                    if (btn == 'yes') {
                        //save();
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
        title: $g("盘点单明细"),
        id: 'InstDetailGrid',
        region: 'center',
        cm: InstDetailGridCm,
        store: InstDetailStore,
        trackMouseOver: true,
        stripeRows: true,
        //sm : new Ext.grid.RowSelectionModel(),
        sm: new Ext.grid.CellSelectionModel(), //liangjiaquan modify 2018-10-23改为行模式
        loadMask: true,
        clicksToEdit: 1,
        bbar: [StatuTabPagingToolbar],
        tbar: ['       ', {
                xtype: 'checkbox',
                boxLabel:$g( '明细未调整'),
                id: 'adjFail',
                checked: false,
                width: '100px'
            },
            {
                xtype: 'checkbox',
                boxLabel: $g('可用数量小于调整数'),
                id: 'avaLessAdj',
                checked: false,
                width: '155px'
            }

        ],
        viewConfig: {
            getRowClass: function (record, rowIndex, rowParams, store) {
                var countQty = record.get("countQty");
                var freQty = record.get("freQty");
                var variance = Number(countQty) - Number(freQty)
                //var variance=record.get("variance");
                var code = record.get("code");
                var ststusi=record.get("ststusi");
                if (code == "合计") {
                    return;
                }
                if (Number(variance) < 0) return 'classSalmon';
                //if(ststusi!="") s
                if (Number(variance) > 0) return 'classAquamarine';
                
            }
        },
         listeners:{  
            'beforeedit':function(o ){  
	            var cellrow=o.row;
	            var rowData = InstDetailStore.getAt(cellrow);
                var statusi = rowData.get("statusi"); 
                if(statusi != "") 
                { 
                	Msg.info("warning", $g("已经调整的记录不允许再修改！"));
                    return false; 
                } 
                else  
                    return true;  
            }  
        }


    });
    /*
      InstDetailGrid.on('beforeedit', function(e) {
        if (e.field == "countQty") {
			e.cancel = true;
        }
	});
	*/
    

    var form = new Ext.form.FormPanel({
        labelAlign: 'right',
        labelWidth: 60,
        frame: true,
        autoHeight: true,
        title: $g('盘点调整'),
        tbar: [QueryBT, '-', RefreshBT, '-', SaveBT, '-', CompleteBT],
        items: [{
            xtype: 'fieldset',
            title: $g('查询条件'),
            layout: 'column',
            defaults: {
                border: false
            },
            style: DHCSTFormStyle.FrmPaddingV,
            items: [{
                columnWidth: 0.25,
                xtype: 'fieldset',
                items: [PhaLoc]

            }, {
                columnWidth: 0.25,
                xtype: 'fieldset',
                items: [StartDate]

            }, {
                columnWidth: 0.25,
                xtype: 'fieldset',
                items: [EndDate]

            }]
        }]
    });

    // 5.2.页面布局
    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: [{
            region: 'north',
            split: false,
            height: DHCSTFormStyle.FrmHeight(1),
            layout: 'fit', // specify layout manager for items
            items: form

        }, {
            region: 'west',
            split: true,
            //collapsible: true, 
            width: document.body.clientWidth * 0.3,
            minSize: document.body.clientWidth * 0.1,
            maxSize: document.body.clientWidth * 0.9,
            layout: 'fit', // specify layout manager for items
            items: MasterInfoGrid

        }, {
            region: 'center',
            layout: 'fit',
            items: [InstDetailGrid]
        }],
        renderTo: 'mainPanel'
    });

    Query();
})