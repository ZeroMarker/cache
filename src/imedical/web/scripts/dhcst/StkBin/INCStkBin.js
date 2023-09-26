// /名称: 货位码维护
// /描述: 货位码维护
// /编写者：zhangdongmei
// /编写日期: 2012.08.20
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gStrParam = '';
    var gGroupId = session['LOGON.GROUPID'];
	var HOSP_SELECT_TIMES=0;
    ChartInfoAddFun();

    function ChartInfoAddFun() {
        var PhaLoc = new Ext.ux.LocComboBox({
            fieldLabel: '科室',
            id: 'PhaLoc',
            name: 'PhaLoc',
            width: 250,
            groupId: gGroupId
        });
        var StkBin = new Ext.form.TextField({
            fieldLabel: '货位码',
            id: 'StkBin',
            name: 'StkBin',
            width: 150,
            disabled: false,
            listeners: {
                specialkey: function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        searchData();
                    }
                }
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
                searchData();
            }
        });

        /**
         * 查询方法
         */
        function searchData() {
            // 必选条件
            var phaLoc = Ext.getCmp("PhaLoc").getValue();
            if (phaLoc == null || phaLoc.length <= 0) {
                Msg.info("warning", "科室不能为空！");
                Ext.getCmp("PhaLoc").focus();
                return;
            }
            var stkBinDesc = Ext.getCmp("StkBin").getValue();
            gStrParam = phaLoc;
            var pagesize = GridPagingToolbar.pageSize;
            StkBinStore.removeAll();
            StkBinStore.setBaseParam('LocId', gStrParam);
            StkBinStore.setBaseParam('sbDesc', stkBinDesc);
            StkBinStore.load({ params: { start: 0, limit: 50 } });
        }

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
            var cell = StkBinGrid.getSelectionModel().getSelectedCell();
            if (cell == null) {
                Msg.info("warning", "没有选中行!");
                return;
            }
            // 选中行
            var row = cell[0];
            var record = StkBinGrid.getStore().getAt(row);
            var Rowid = record.get("sb");
            if (Rowid == null || Rowid.length <= 0) {
                StkBinGrid.getStore().remove(record);
            } else {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: '是否确定删除该货位信息',
                    buttons: Ext.MessageBox.YESNO,
                    parm: Rowid,
                    fn: showResult,
                    icon: Ext.MessageBox.QUESTION
                });
            }
        }

        /**
         * 删除货位提示
         */
        function showResult(btn, text, opt) {
            if (btn == "yes") {
                var url = DictUrl +
                    "incstkbinaction.csp?actiontype=Delete&Rowid=" +
                    opt.parm;
                var mask = ShowLoadMask(Ext.getBody(), "处理中请稍候...");
                Ext.Ajax.request({
                    url: url,
                    method: 'POST',
                    waitMsg: '查询中...',
                    success: function(result, request) {
                        var jsonData = Ext.util.JSON
                            .decode(result.responseText);
                        mask.hide();
                        if (jsonData.success == 'true') {
                            Msg.info("success", "删除成功!");
                            searchData();
                        } else {
                            var ret = jsonData.info;
                            if (ret == -2) {
                                Msg.info("error", "该货位已经在用，不能删除！");
                            } else {
                                Msg.info("error", "删除失败:" + jsonData.info);
                            }
                        }
                    },
                    scope: this
                });
            }
        }

        // 清空按钮
        var RefreshBT = new Ext.Toolbar.Button({
            text: '清空',
            tooltip: '点击清空',
            iconCls: 'page_refresh',
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
            gStrParam = '';
            Ext.getCmp("PhaLoc").setValue("");
            StkBinGrid.store.removeAll();
            StkBinGrid.getView().refresh();
        }
        // 新建按钮
        var AddBT = new Ext.Toolbar.Button({
            id: "AddBT",
            text: '新建',
            tooltip: '点击新建',
            width: 70,
            height: 30,
            iconCls: 'page_add',
            handler: function() {
                // 判断是否已经有添加行
                var rowCount = StkBinGrid.getStore().getCount();
                if (rowCount > 0) {
                    var rowData = StkBinStore.data.items[rowCount - 1];
                    var data = rowData.get("sb");
                    if (data == null || data.length <= 0) {
                        Msg.info("warning", "已存在新建行!");
                        return;
                    }
                }
                addNewRow();
            }
        });
        /**
         * 新增一行
         */
        function addNewRow() {
            var record = Ext.data.Record.create([{
                name: 'sb',
                type: 'string'
            }, {
                name: 'code',
                type: 'string'
            }, {
                name: 'desc',
                type: 'string'
            }]);
            var NewRecord = new record({
                sb: '',
                code: '',
                desc: ''
            });
            StkBinStore.add(NewRecord);
            StkBinGrid.getSelectionModel().select(StkBinStore.getCount() - 1, 3);
            StkBinGrid.startEditing(StkBinStore.getCount() - 1, 3);
        };

        // 保存按钮
        var SaveBT = new Ext.Toolbar.Button({
            id: "SaveBT",
            text: '保存',
            tooltip: '点击保存',
            width: 70,
            height: 30,
            iconCls: 'page_save',
            handler: function() {
                save();
            }
        });

        function save() {
            PhaLocId = Ext.getCmp('PhaLoc').getValue();
            if (PhaLocId == null || PhaLocId.length < 1) {
                Msg.info("warning", "科室不能为空!");
                return;
            }
            var ListDetail = "";
            var rowCount = StkBinGrid.getStore().getCount();
            for (var i = 0; i < rowCount; i++) {
                var rowData = StkBinStore.getAt(i);
                //新增或数据发生变化时执行下述操作
                if (rowData.data.newRecord || rowData.dirty) {
                    var Rowid = rowData.get("sb");
                    var Desc = rowData.get("desc");

                    var str = Rowid + "^" + Desc;
                    if (ListDetail == "") {
                        ListDetail = str;
                    } else {
                        ListDetail = ListDetail + xRowDelim() + str;
                    }
                }
            }
            var url = DictUrl +
                "incstkbinaction.csp?actiontype=Save";
            var mask = ShowLoadMask(Ext.getBody(), "处理中请稍候...");
            Ext.Ajax.request({
                url: url,
                method: 'POST',
                params: { LocId: PhaLocId, Detail: ListDetail },
                waitMsg: '处理中...',
                success: function(result, request) {
                    var jsonData = Ext.util.JSON
                        .decode(result.responseText);
                    mask.hide();
                    if (jsonData.success == 'true') {

                        Msg.info("success", "保存成功!");
                        // 刷新界面
                        searchData();

                    } else {
                        var ret = jsonData.info;
                        if (ret == -1) {
                            Msg.info("error", "科室为空,不能保存!");
                        } else if (ret == -2) {
                            Msg.info("error", "没有需要保存的数据!");
                        } else if (ret == -4) {
                            Msg.info("error", "货位名称重复!");
                        } else {
                            Msg.info("error", "部分明细保存不成功：" + ret);
                        }
                    }
                },
                scope: this
            });
        }

        var nm = new Ext.grid.RowNumberer();
        var StkBinCm = new Ext.grid.ColumnModel([nm, {
            header: "rowid",
            dataIndex: 'sb',
            width: 80,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: '代码',
            dataIndex: 'code',
            width: 80,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: "货位码",
            dataIndex: 'desc',
            width: 400,
            align: 'left',
            sortable: true,
            editor: new Ext.form.TextField({
                allowBlank: false,
                listeners: {
                    specialkey: function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            addNewRow();
                        }
                    }
                }
            })
        }]);
        StkBinCm.defaultSortable = true;

        // 访问路径
        var DspPhaUrl = DictUrl +
            'incstkbinaction.csp?actiontype=Query&start=&limit=';
        // 通过AJAX方式调用后台数据
        var proxy = new Ext.data.HttpProxy({
            url: DspPhaUrl,
            method: "POST"
        });
        // 指定列参数
        var fields = ["sb", "code", "desc"];
        // 支持分页显示的读取方式
        var reader = new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: "results",
            id: "sb",
            fields: fields
        });
        // 数据集
        var StkBinStore = new Ext.data.Store({
            proxy: proxy,
            reader: reader
        });

        var GridPagingToolbar = new Ext.PagingToolbar({
            store: StkBinStore,
            pageSize: 50,
            displayInfo: true,
            displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
            emptyMsg: "没有记录"
        });

        var StkBinGrid = new Ext.grid.EditorGridPanel({
            id: 'StkBinGrid',
            region: 'center',
            cm: StkBinCm,
            store: StkBinStore,
            trackMouseOver: true,
            stripeRows: true,
            sm: new Ext.grid.CellSelectionModel({}),
            clicksToEdit: 1,
            loadMask: true,
            bbar: GridPagingToolbar
        });
		var HospPanel = InitHospCombo('PHA-IN-StkBin',function(combo, record, index){
			HOSP_SELECT_TIMES++;
			if (HOSP_SELECT_TIMES>1){
				Ext.getCmp("PhaLoc").setValue("");
				HospId = this.value; 
				StkBinGrid.store.removeAll();
				StkBinGrid.getView().refresh();
				StkBinStore.setBaseParam('LocId', '');
			}
		});
        var HisListTab = new Ext.form.FormPanel({
	        id:"HisListTab",
            labelWidth: 60,
            height: DHCSTFormStyle.FrmHeight(1),
            labelAlign: 'right',
            title: '货位码维护',
            region: 'north',
            frame: true,
            tbar: [SearchBT, '-', AddBT, '-', SaveBT, '-', DeleteBT],
            items: [{
                xtype: 'fieldset',
                title: '查询条件',
                layout: 'column',
                style: DHCSTFormStyle.FrmPaddingV,
                layout: 'column',
                items: [{
                    columnWidth: .3,
                    xtype: 'fieldset',
                    border: false,
                    items: [PhaLoc]
                }, {
                    columnWidth: .5,
                    xtype: 'fieldset',
                    border: false,
                    items: [StkBin]
                }]
            }]
        });

        // 5.2.页面布局
        var mainPanel = new Ext.Viewport({
            layout: 'border',
			items:[
				{
					region:'north',
					height:'500px',
					items:[HospPanel,HisListTab]
				},StkBinGrid
			],
            renderTo: 'mainPanel'
        });

        // 登录设置默认值
        SetLogInDept(PhaLoc.getStore(), "PhaLoc");
        searchData();
    }
})