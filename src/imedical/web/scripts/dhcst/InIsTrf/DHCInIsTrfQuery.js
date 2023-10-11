// /名称: 出库单查询
// /描述: 出库单查询
// /编写者：zhangdongmei
// /编写日期: 2012.07.24

Ext.onReady(function() {
    var userId = session['LOGON.USERID'];
    var gGroupId = session['LOGON.GROUPID'];
    var gLocId = session['LOGON.CTLOCID'];
    var gInciRowId = "";
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    ChartInfoAddFun();
    // 登录设置默认值
    SetLogInDept(PhaDeptStore, "SupplyPhaLoc");
    //取参数配置
    if (gParam == null || gParam.length < 1) {
        GetParam();
    }
    if (gParamCommon.length < 1) {
        GetParamCommon(); //初始化公共参数配置
    }

    function ChartInfoAddFun() {

        // 请求部门
        var RequestPhaLoc = new Ext.ux.LocComboBox({
            fieldLabel: $g('请求部门'),
            id: 'RequestPhaLoc',
            name: 'RequestPhaLoc',
            anchor: '90%',
            width: 120,
            emptyText: $g('请求部门...'),
            defaultLoc: {}
        });

        // 供给部门
        var SupplyPhaLoc = new Ext.ux.LocComboBox({
            fieldLabel: $g('供给部门'),
            id: 'SupplyPhaLoc',
            name: 'SupplyPhaLoc',
            anchor: '90%',
            width: 120,
            emptyText: $g('供给部门...'),
            groupId: gGroupId
        });

        // 起始日期
        var StartDate = new Ext.ux.DateField({
            fieldLabel: $g('起始日期'),
            id: 'StartDate',
            name: 'StartDate',
            anchor: '90%',
            width: 120,
            value: DefaultStDate()
        });

        // 截止日期
        var EndDate = new Ext.ux.DateField({
            fieldLabel: $g('截止日期'),
            id: 'EndDate',
            name: 'EndDate',
            anchor: '90%',
            width: 120,
            value: DefaultEdDate()
        });

        //转移单号
        var IsTrNo = new Ext.form.TextField({
            fieldLabel: $g('转移单号'),
            id: 'IsTrNo',
            name: 'IsTrNo',
            anchor: '90%',
            width: 120,
            disabled: false
        });

        var StatusStore = new Ext.data.SimpleStore({
            fields: ['RowId', 'Description'],
            data: [
                ['10', $g('未完成')],
                ['11', $g('已完成')],
                ['20', $g('出库审核不通过')],
                ['21', $g('出库审核通过')],
                ['30', $g('拒绝接收')],
                ['31', $g('已接收')],
                ['32', $g('部分接收')],
                ['40', $g('重转作废')]
                
            ]
        });

        // 出库类型
        var OperateOutType = new Ext.ux.ComboBox({
            fieldLabel: $g('出库类型'),
            id: 'OperateOutType',
            name: 'OperateOutType',
            store: OperateOutTypeStore,
            valueField: 'RowId',
            displayField: 'Description'
        });

        var Status = new Ext.form.ComboBox({
            fieldLabel: $g('转移状态'),
            id: 'Status',
            name: 'Status',
            anchor: '90%',
            width: 100,
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

        // 药品类组
        var StkGrpType = new Ext.ux.StkGrpComboBox({
            id: 'StkGrpType',
            name: 'StkGrpType',
            StkType: App_StkTypeCode, //标识类组类型
            LocId: gLocId,
            UserId: userId,
            anchor: '90%',
            width: 200,
            fieldLabel: $g('类　　组')
        });

        // 药品名称
        var InciDesc = new Ext.form.TextField({
            fieldLabel: $g('药品名称'),
            id: 'InciDesc',
            name: 'InciDesc',
            anchor: '90%',
            width: 150,
            listeners: {
                specialkey: function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        var stktype = Ext.getCmp("StkGrpType").getValue();
                        GetPhaOrderInfo(field.getValue(), stktype);
                    }
                }
            }
        });

        // 调用药品窗体并返回结果
        function GetPhaOrderInfo(item, stktype) {
            if (item != null && item.length > 0) {
                GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "", getDrugList);
            }
        }

        // 返回方法
        function getDrugList(record) {
            if (record == null || record == "") {
                return;
            }
            var inciDr = record.get("InciDr");
            var InciDesc = record.get("InciDesc");
            Ext.getCmp("InciDesc").setValue(InciDesc);
            gInciRowId = inciDr;
        }

        // 查询按钮
        var SearchBT = new Ext.Toolbar.Button({
            text: $g('查询'),
            tooltip: $g('点击查询'),
            width: 70,
            height: 30,
            iconCls: 'page_find',
            handler: function() {
                Query();
            }
        });

        function Query() {
            var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
            if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
                Msg.info("warning", $g("请选择供应部门!"));
                return;
            }
            var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
            var startDate = Ext.getCmp("StartDate").getRawValue();
            var endDate = Ext.getCmp("EndDate").getRawValue();
            var statue = Ext.getCmp("Status").getValue();
            var stkgrpid = Ext.getCmp("StkGrpType").getValue();
            var inci = gInciRowId;
            var IsTrNo = Ext.getCmp("IsTrNo").getValue(); //单号过滤 
            if (Ext.getCmp("InciDesc").getValue() == "") {
                inci = "";
            }
            var OperateOutTypeId = Ext.getCmp("OperateOutType").getValue();
            var ListParam = startDate + '^' + endDate + '^' + supplyphaLoc + '^' + requestphaLoc + '^^' + statue + '^' + IsTrNo + '^^' + stkgrpid + "^" + inci + "^" + OperateOutTypeId;
            var Page = GridPagingToolbar.pageSize;
            MasterStore.setBaseParam('ParamStr', ListParam);
            DetailGrid.store.removeAll();
            DetailGrid.getView().refresh();
            MasterStore.removeAll();
            MasterStore.load({ params: { start: 0, limit: Page } });
            MasterStore.on('load', function() {
                if (MasterStore.getCount() > 0) {
                    MasterGrid.getSelectionModel().selectFirstRow();
                    MasterGrid.getView().focusRow(0)
                }
            });
        }

        // 清空按钮
        var ClearBT = new Ext.Toolbar.Button({
            text: $g('清空'),
            tooltip: $g('点击清空'),
            width: 70,
            height: 30,
            iconCls: 'page_clearscreen',
            handler: function() {
                clearData();
            }
        });

        function clearData() {
            SetLogInDept(PhaDeptStore, "SupplyPhaLoc");
            Ext.getCmp("RequestPhaLoc").setValue("");
            //Ext.getCmp("SupplyPhaLoc").setValue("");
            Ext.getCmp("Status").setValue("");
            //Ext.getCmp("StkGrpType").setValue("");
            StkGrpType.store.reload();
            Ext.getCmp("IsTrNo").setValue("");
            Ext.getCmp("InciDesc").setValue("");
            Ext.getCmp("StartDate").setValue(DefaultStDate());
            Ext.getCmp("EndDate").setValue(DefaultEdDate());
            Ext.getCmp("OperateOutType").setValue("");
            
            MasterGrid.store.removeAll();
            MasterGrid.getView().refresh();
            DetailGrid.store.removeAll();
            DetailGrid.getView().refresh();
        }

        // 打印按钮
        var PrintBT = new Ext.Toolbar.Button({
            text: $g('打印'),
            tooltip: $g('点击打印'),
            width: 70,
            height: 30,
            iconCls: 'page_print',
            handler: function() {
                var rowData = MasterGrid.getSelectionModel().getSelected();
                if (rowData == null) {
                    Msg.info("warning", $g("请选择需要打印的转移单!"));
                    return;
                }
                var init = rowData.get("init");
                PrintInIsTrf(init, gParam[8]);
            }
        });

        // 另存按钮
        var SaveAsBT = new Ext.Toolbar.Button({
            text: $g('另存'),
            tooltip: $g('另存为Excel'),
            iconCls: 'page_export',
            width: 70,
            height: 30,
            handler: function() {
                ExportAllToExcel(DetailGrid);
            }
        });
        /* 列设置按钮 */
        var GridColSetBT = new Ext.Toolbar.Button({
            text:$g('列设置'),
            tooltip:$g('列设置'),
            iconCls:'page_gear',
            handler:function(){
                GridSelectWin.show();
            }
        });

        // 确定按钮
        var returnBT = new Ext.Toolbar.Button({
            text : $g('确定'),
            tooltip : $g('点击确定'),
            iconCls : 'page_goto',
            handler : function() {
                var selectradio = Ext.getCmp('GridSelectModel').getValue();
                if(selectradio){
                    var selectModel =selectradio.inputValue;	
                    if (selectModel=='1') {
                        GridColSet(MasterGrid,"DHCSTTRANSFER");
                        
                    }
                    else {
                        GridColSet(DetailGrid,"DHCSTTRANSFER");   							
                    }						
                }
                GridSelectWin.hide();
            }
        });

        // 取消按钮
        var cancelBT = new Ext.Toolbar.Button({
                text : $g('取消'),
                tooltip : $g('点击取消'),
                iconCls : 'page_delete',
                handler : function() {
                    GridSelectWin.hide();
                }
            });

        //选择按钮
        var GridSelectWin=new Ext.Window({
            title:$g('选择'),
            width : 210,
            height : 110,
            labelWidth:100,
            closeAction:'hide' ,
            plain:true,
            modal:true,
            items:[{
                xtype:'radiogroup',
                id:'GridSelectModel',
                anchor: '95%',
                columns: 2,
                style: 'padding:10px 10px 10px 10px;',
                items : [{
                        checked: true,				             
                            boxLabel: $g('出库单'),
                            id: 'GridSelectModel1',
                            name:'GridSelectModel',
                            inputValue: '1' 							
                        },{
                        checked: false,				             
                            boxLabel: $g('出库单明细'),
                            id: 'GridSelectModel2',
                            name:'GridSelectModel',
                            inputValue: '2' 							
                        }]
                    }],
            
            buttons:[returnBT,cancelBT]
        })	

        // 访问路径
        var MasterUrl = DictUrl + 'dhcinistrfaction.csp?actiontype=Query';

        // 通过AJAX方式调用后台数据
        var proxy = new Ext.data.HttpProxy({
            url: MasterUrl,
            method: "POST"
        });

        // 指定列参数
        var fields = ["init", "initNo", "reqNo", "toLocDesc", "frLocDesc", "dd", "tt", "comp", "userName",
            "status", "RpAmt", "SpAmt", "MarginAmt", "Remark", "StatusCode"
        ];

        // 支持分页显示的读取方式
        var reader = new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: "results",
            id: "init",
            fields: fields
        });

        // 数据集
        var MasterStore = new Ext.data.Store({
            proxy: proxy,
            reader: reader
        });

        var nm = new Ext.grid.RowNumberer();

        var MasterCm = new Ext.grid.ColumnModel([nm, {
            header: "RowId",
            dataIndex: 'init',
            width: 100,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: $g("转移单号"),
            dataIndex: 'initNo',
            width: 150,
            align: 'left',
            sortable: true
        }, {
            header: $g('请求单号'),
            dataIndex: 'reqNo',
            width: 150,
            align: 'left',
            sortable: true
        }, {
            header: $g("请求部门"),
            dataIndex: 'toLocDesc',
            width: 180,
            align: 'left',
            sortable: true
        }, {
            header: $g("供给部门"),
            dataIndex: 'frLocDesc',
            width: 180,
            align: 'left',
            sortable: true
        }, {
            header: $g("转移日期"),
            dataIndex: 'dd',
            width: 90,
            align: 'center',
            sortable: true
        }, {
            header: $g("单据状态"),
            dataIndex: 'StatusCode',
            width: 120,
            align: 'left',
            sortable: true
        }, {
            header: $g("制单人"),
            dataIndex: 'userName',
            width: 90,
            align: 'left',
            sortable: true
        }, {
            header: $g("进价金额"),
            dataIndex: 'RpAmt',
            width: 80,
            align: 'right',
            sortable: true,
            renderer: FormatGridRpAmount
        }, {
            header: $g("售价金额"),
            dataIndex: 'SpAmt',
            width: 80,
            align: 'right',
            sortable: true,
            renderer: FormatGridSpAmount
        }, {
            header: $g("进销差价"),
            dataIndex: 'MarginAmt',
            width: 80,
            align: 'right',
            sortable: true,
            renderer: FormatGridRpAmount
        }, {
            header:$g( "备注"),
            dataIndex: 'Remark',
            width: 100,
            align: 'left',
            sortable: true
        }]);

        MasterCm.defaultSortable = true;
        var GridPagingToolbar = new Ext.PagingToolbar({
            store: MasterStore,
            pageSize: PageSize,
            displayInfo: true,
            displayMsg: $g('第 {0} 条到 {1}条, 一共 {2} 条'),
            emptyMsg: $g("没有记录")
        });

        var MasterGrid = new Ext.grid.GridPanel({
            title: '',
            id : 'MasterGrid',
            height: 170,
            cm: MasterCm,
            sm: new Ext.grid.RowSelectionModel({
                singleSelect: true
            }),
            store: MasterStore,
            trackMouseOver: true,
            stripeRows: true,
            loadMask: true,
            bbar: GridPagingToolbar
        });

        // 添加表格单击行事件
        MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
            var InIt = MasterStore.getAt(rowIndex).get("init");
            DetailStore.setBaseParam('Parref', InIt)
            DetailStore.load({ params: { start: 0, limit: GridDetailPagingToolbar.pageSize, sort: 'Rowid', dir: 'Desc' } });
        });

        // 转移明细
        // 访问路径
        var DetailUrl = DictUrl +
            'dhcinistrfaction.csp?actiontype=QueryDetail';

        // 通过AJAX方式调用后台数据
        var proxy = new Ext.data.HttpProxy({
            url: DetailUrl,
            method: "POST"
        });

        // 指定列参数
        var fields = ["initi", "inrqi", "inci", "inciCode",
            "inciDesc", "inclb", "batexp", "manf", "manfName",
            "qty", "uom", "sp", "status", "remark",
            "reqQty", "inclbQty", "reqLocStkQty", "stkbin",
            "pp", "spec", "gene", "formDesc", "newSp",
            "spAmt", "rp", "rpAmt", "ConFac", "BUomId", 
            "inclbDirtyQty", "inclbAvaQty", "TrUomDesc", "reqstkbin","InsuCode",
            "InsuDesc"
        ];

        // 支持分页显示的读取方式
        var reader = new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: "results",
            id: "initi",
            fields: fields
        });

        // 数据集
        var DetailStore = new Ext.data.Store({
            proxy: proxy,
            reader: reader
        });

        var nm = new Ext.grid.RowNumberer();

        var DetailCm = new Ext.grid.ColumnModel([nm, {
            header: $g("转移细项RowId"),
            dataIndex: 'initi',
            width: 100,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: $g("药品Id"),
            dataIndex: 'inci',
            width: 80,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: $g('药品代码'),
            dataIndex: 'inciCode',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: $g('药品名称'),
            dataIndex: 'inciDesc',
            width: 220,
            align: 'left',
            sortable: true
        }, {
            header: $g("批次Id"),
            dataIndex: 'inclb',
            width: 180,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: $g("批次/效期"),
            dataIndex: 'batexp',
            width: 185,
            align: 'left',
            sortable: true
        }, {
            header: $g("生产企业"),
            dataIndex: 'manfName',
            width: 180,
            align: 'left',
            sortable: true
        }, {
            header: $g("批次库存"),
            dataIndex: 'inclbQty',
            width: 80,
            align: 'right',
            sortable: true
        }, {
            header: $g("转移数量"),
            dataIndex: 'qty',
            width: 80,
            align: 'right',
            sortable: true
        }, {
            header: $g("转移单位"),
            dataIndex: 'TrUomDesc',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: $g("进价"),
            dataIndex: 'rp',
            width: 60,
            align: 'right',

            sortable: true
        }, {
            header: $g("售价"),
            dataIndex: 'sp',
            width: 60,
            align: 'right',

            sortable: true
        }, {
            header:$g( "请求数量"),
            dataIndex: 'reqQty',
            width: 80,
            align: 'right',
            sortable: true
        }, {
            header: $g("供给方货位"),
            dataIndex: 'stkbin',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g("请求方货位"),
            dataIndex: 'reqstkbin',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g("请求方库存"),
            dataIndex: 'reqLocStkQty',
            width: 100,
            align: 'right',
            sortable: true
        }, {
            header: $g("占用数量"),
            dataIndex: 'inclbDirtyQty',
            width: 80,
            align: 'right',
            sortable: true
        }, {
            header: $g("可用数量"),
            dataIndex: 'inclbAvaQty',
            width: 80,
            align: 'right',
            sortable: true
        }, {
            header: $g("批次售价"),
            dataIndex: 'newSp',
            width: 100,
            align: 'right',

            sortable: true
        }, {
            header: $g("规格"),
            dataIndex: 'spec',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g("处方通用名"),
            dataIndex: 'gene',
            width: 120,
            align: 'left',
            sortable: true
        }, {
            header: $g("剂型"),
            dataIndex: 'formDesc',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g("售价金额"),
            dataIndex: 'spAmt',
            width: 100,
            align: 'right',
            sortable: true,
            renderer: FormatGridSpAmount
        }, {
            header: $g("进价金额"),
            dataIndex: 'rpAmt',
            width: 100,
            align: 'right',
            sortable: true,
            renderer: FormatGridRpAmount
        }, {
			header : $g("国家医保编码"),
			dataIndex : 'InsuCode',
			width : 100,
			align : 'right',					
			sortable : true,
		}, {
			header : $g("国家医保名称"),
			dataIndex : 'InsuDesc',
			width : 100,
			align : 'right',					
			sortable : true,
		}]);

        var GridDetailPagingToolbar = new Ext.PagingToolbar({
            store: DetailStore,
            pageSize: PageSize,
            displayInfo: true,
            displayMsg: $g('第 {0} 条到 {1}条, 一共 {2} 条'),
            emptyMsg: $g("没有记录")
        });

        var DetailGrid = new Ext.grid.GridPanel({
            title: '',
            id : 'DetailGrid',
            height: 200,
            cm: DetailCm,
            store: DetailStore,
            trackMouseOver: true,
            stripeRows: true,
            bbar: GridDetailPagingToolbar,
            loadMask: true
        });

        function rightClickFn(grid, rowindex, e) {
            grid.getSelectionModel().selectRow(rowindex);
            e.preventDefault();
            rightClickTransMenu.showAt(e.getXY()); //获取坐标

        }

        // 查询未转移项
        function RequestNotMoveShow() {
            var rowData = MasterGrid.getSelectionModel().getSelected();
            if (rowData == null) {
                Msg.info("warning", $g("请选择转移单!"));
                return;
            }
            var transno = rowData.get("initNo");
            var reqno = rowData.get("reqNo");
            if (reqno == "") {
                Msg.info("warning", $g("无对应请求单!"));
                return
            }
            TransNotMove(transno, reqno);
        }

        MasterGrid.addListener('rowcontextmenu', rightClickFn)

        var rightClickTransMenu = new Ext.menu.Menu({
            id: 'rightClickTransMenu',
            items: [{
                id: 'mnuNotMove',
                handler: RequestNotMoveShow,
                text: $g('查看未转移请求单')
            }]
        });

        var HisListTab = new Ext.form.FormPanel({
            labelWidth: 60,
            labelAlign: 'right',
            title: $g("出库单查询"),
            frame: true,
            //autoScroll : true,
            autoHeight: true,
            tbar: [SearchBT, '-', ClearBT, '-', PrintBT, '-', SaveAsBT, '-',GridColSetBT],
            //layout: 'fit',    // Specifies that the items will now be arranged in columns
            items: [{
                xtype: 'fieldset',
                layout: 'column',
                defaults: { border: false },
                style: DHCSTFormStyle.FrmPaddingV,
                title: $g('查询条件'),
                autoHeight: true,
                items: [{
                    columnWidth: 0.25,
                    xtype: 'fieldset',
                    items: [SupplyPhaLoc, RequestPhaLoc]

                }, {
                    columnWidth: 0.17,
                    xtype: 'fieldset',
                    items: [StkGrpType, Status]

                }, {
                    columnWidth: 0.2,
                    xtype: 'fieldset',
                    items: [StartDate, EndDate]

                }, {
                    columnWidth: 0.23,
                    xtype: 'fieldset',
                    items: [InciDesc, IsTrNo]

                }, {
                    columnWidth: 0.15,
                    xtype: 'fieldset',
                    items: [OperateOutType]

                }]
            }]
        });

        // 页面布局
        var mainPanel = new Ext.Viewport({
            layout: 'border',
            items: [ // create instance immediately
                {
                    region: 'north',
                    height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
                    layout: 'fit', // specify layout manager for items
                    items: HisListTab
                }, {
                    region: 'center',
                    title: $g('出库单'),
                    layout: 'fit', // specify layout manager for items
                    items: MasterGrid
                }, {
                    region: 'south',
                    split: true,
                    height: 250,
                    minSize: 200,
                    maxSize: 350,
                    collapsible: true,
                    title: $g('出库单明细'),
                    layout: 'fit', // specify layout manager for items
                    items: DetailGrid
                }
            ],
            renderTo: 'mainPanel'
        });

        RefreshGridColSet(MasterGrid,"DHCSTTRANSFER");
		RefreshGridColSet(DetailGrid,"DHCSTTRANSFER");
    }
})
