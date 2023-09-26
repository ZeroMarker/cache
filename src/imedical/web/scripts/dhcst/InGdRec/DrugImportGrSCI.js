/**
 * creator:    yunhaibao
 * createdate: 2017-04-19
 * description:供应链接口入库(SCI入库),调取数据界面
 */
function DrugImportGrSCI(Fn) {
    Ext.Msg.show({
        title: '注意',
        msg: "尚未开启接口,可联系工程师了解详细内容!",
        buttons: Ext.Msg.OK,
        icon: Ext.MessageBox.INFO
    });
    return;
    var gUserId = session['LOGON.USERID'];
    var gLocId = session['LOGON.CTLOCID'];
    var HospId = session['LOGON.HOSPID'];
    var gGroupId = session['LOGON.GROUPID'];
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    
    // 供应商
    var SCIVendor = new Ext.ux.VendorComboBox({
        fieldLabel: '供应商',
        id: 'SCIVendor',
        name: 'SCIVendor',
        anchor: '90%',
        emptyText: '供应商...'
            //disabled : true
    });

    // 入库部门
    var SCIRecLoc = new Ext.ux.LocComboBox({
        fieldLabel: '入库部门',
        id: 'SCIRecLoc',
        name: 'SCIRecLoc',
        anchor: '90%',
        emptyText: '入库部门...',
        groupId: session['LOGON.GROUPID']
            //disabled : true
    });

    // 起始日期
    var SCIStartDate = new Ext.ux.EditDate({
        fieldLabel: '起始日期',
        id: 'SCIStartDate',
        name: 'SCIStartDate',
        anchor: '90%',
        format: 'Y-m-d',
        width: 120,
        value: new Date().add(Date.DAY, -7)
    });

    // 截止日期
    var SCIEndDate = new Ext.ux.EditDate({
        fieldLabel: '截止日期',
        id: 'SCIEndDate',
        name: 'SCIEndDate',
        anchor: '90%',
        format: 'Y-m-d',
        width: 120,
        value: new Date()
    });

    // 药品类组
    var SCIStkGrpType = new Ext.ux.StkGrpComboBox({
        id: 'SCIStkGrpType',
        name: 'SCIStkGrpType',
        StkType: App_StkTypeCode, //标识类组类型
        LocId: '', //gLocId,
        UserId: '', //gUserId,
        anchor: '80%'
            //disabled : true
    });

    // 入库状态
    var SCIImportStatStore = new Ext.data.SimpleStore({
        fields: ['RowId', 'Description'],
        data: [
            ['N', '未入库'],
            ['Y', '已入库']
        ]
    });
    
    var SCIImportStat = new Ext.form.ComboBox({
        fieldLabel: '入库状态',
        id: 'SCIImportStat',
        name: 'SCIImportStat',
        store: SCIImportStatStore,
        valueField: 'RowId',
        displayField: 'Description',
        mode: 'local',
        allowBlank: true,
        triggerAction: 'all',
        selectOnFocus: true,
        forceSelection: true,
        anchor: '80%'
    });

    var SCISxNo = new Ext.form.TextField({
        fieldLabel: '随行单号',
        id: 'SCISxNo',
        name: 'SCISxNo',
        anchor: '90%',
        listeners: {
            specialkey: function(field, e) {
                if (e.getKey() == Ext.EventObject.ENTER) {
                    //SCIQuery();
                }
            }
        }
    });
    
    var SCIFormS = new Ext.form.FormPanel({
        frame: true,
        labelAlign: 'right',
        id: "SCIFormS",
        labelWidth: 60,
        items: [{
            layout: 'column', // Specifies that the items will now be arranged in columns
            xtype: 'fieldset',
            title: '查询条件',
            style: 'padding:5px 0px 0px 0px',
            defaults: { border: false }, // Default config options for child items
            items: [{
                    columnWidth: 0.2,
                    xtype: 'fieldset',
                    defaultType: 'textfield',
                    items: [SCIStartDate, SCIEndDate]
                },
                {
                    columnWidth: 0.3,
                    xtype: 'fieldset',
                    defaultType: 'textfield',
                    items: [SCIVendor, SCIRecLoc]
                },
                {
                    columnWidth: 0.2,
                    xtype: 'fieldset',
                    defaultType: 'textfield',
                    items: [SCIStkGrpType, SCIImportStat]
                }, {
                    columnWidth: 0.2,
                    xtype: 'fieldset',
                    defaultType: 'textfield',
                    items: [SCISxNo]
                }

            ]
        }]
    });
    
    var SCISynRecBT = new Ext.Toolbar.Button({
        id: "SCISynRecBT",
        text: '提取云平台数据',
        tooltip: '提取云平台数据',
        iconCls: 'world_link',
        height: 30,
        width: 70,
        handler: function() {
            var SCISXNo = Ext.getCmp("SCISxNo").getValue();
            if (SCISXNo == "") {
                Msg.info("warning", "随行单号为空!");
                return;
            }
            var ret = tkMakeServerCall("web.DHCST.SCI.Method.Interface", "GetRecData", SCISXNo, gUserId)
            if (ret == 0) {
                Msg.info("success", "提取成功!");
            } else {
                var msginfo = ret.split("|@|")[1];
                Ext.Msg.show({
                    title: '注意',
                    msg: msginfo,
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.INFO
                });
            }
        }
    });
    
    // 检索按钮
    var SCISearchBT = new Ext.Toolbar.Button({
        text: '查询',
        tooltip: '点击查询供应链需要入库的信息',
        iconCls: 'page_find',
        height: 30,
        width: 70,
        handler: function() {
            QueryHHImport();
            ///GetELinkNetData();
        }
    });

    function QueryHHImport() {
        var SCIVendor = Ext.getCmp("SCIVendor").getValue();
        var SCIRecLoc = Ext.getCmp("SCIRecLoc").getValue();
        var SCIStartDate = Ext.getCmp("SCIStartDate").getValue().format('Y-m-d').toString();
        var SCIEndDate = Ext.getCmp("SCIEndDate").getValue().format('Y-m-d').toString();
        var SCIStkCatGrp = Ext.getCmp("SCIStkGrpType").getValue();
        var SCIImportStat = Ext.getCmp("SCIImportStat").getValue();
        var ListParam = SCIStartDate + "^" + SCIEndDate + "^" + SCIVendor + "^" + SCIRecLoc + "^" + SCIStkCatGrp + "^" + SCIImportStat;
        var Page = GridPagingToolbar.pageSize;
        SCIMasterInfoStore.baseParams = { StrParam: ListParam };
        SCIMasterInfoStore.removeAll();
        SCIDetailInfoStore.removeAll();
        SCIMasterInfoGrid.store.removeAll();
        SCIMasterInfoStore.load({
            params: { start: 0, limit: Page },
            callback: function(r, options, success) {
                if (success == false) {
                    Ext.MessageBox.alert("查询错误",SCIMasterInfoStore.reader.jsonData.Error);  
                } else {
                    if (r.length > 0) {
                        SCIMasterInfoGrid.getSelectionModel().selectFirstRow();
                        SCIMasterInfoGrid.getSelectionModel().fireEvent('rowselect', this, 0);
                        SCIMasterInfoGrid.getView().focusRow(0);
                    }
                }
            }
        });
    }

    // 选取按钮
    var SCICommitBT = new Ext.Toolbar.Button({
        text: '提交入库',
        tooltip: '点击生成HIS入库单',
        iconCls: 'page_goto',
        height: 30,
        width: 70,
        handler: function() {
            CommitImport();
        }
    });

    // 清空按钮
    var SCIClearBT = new Ext.Toolbar.Button({
        text: '清空',
        tooltip: '点击清空',
        iconCls: 'page_clearscreen',
        height: 30,
        width: 70,
        handler: function() {
            SCIClearData();
        }
    });

    function SCIClearData() {
        Ext.getCmp("SCIVendor").setValue("");
        Ext.getCmp("SCIRecLoc").setValue(Ext.getCmp("PhaLoc").getValue());
        Ext.getCmp("SCIImportStat").setValue("N");
        Ext.getCmp("SCISxNo").setValue("");
        SCIMasterInfoGrid.store.removeAll();
        SCIDetailInfoGrid.store.removeAll();
        Ext.getCmp("SCISxNo").focus(true, 100);
    }

    // 关闭按钮
    var SCICloseBT = new Ext.Toolbar.Button({
        text: '关闭',
        tooltip: '关闭界面',
        iconCls: 'page_delete',
        height: 30,
        width: 70,
        handler: function() {
            SCIClearData();
            window.close();
        }
    });

    // 访问路径
    var MasterInfoUrl = DictUrl + 'hhimportaction.csp?actiontype=QueryHHImport'; //获取主信息
    
    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
        url: MasterInfoUrl,
        method: "POST"
    });

    // 指定列参数
    var fields = ["SCIOrderNo", "VendorDesc", "LocDesc", "SCIRecDate", "VendorId","LocId", "HHImport"];
    
    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "HHImport",
        fields: fields
    });
    
    // 数据集
    var SCIMasterInfoStore = new Ext.data.Store({
        proxy: proxy,
        reader: reader
    });
    
    var nm = new Ext.grid.RowNumberer();
    
    var SCIMasterInfoCm = new Ext.grid.ColumnModel([nm, {
            header: "SCI单号",
            dataIndex: 'SCIOrderNo',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: "供应商",
            dataIndex: 'VendorDesc',
            width: 125,
            align: 'left',
            sortable: true
        }, {
            header: "入库科室",
            dataIndex: 'LocDesc',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: "单据日期",
            dataIndex: 'SCIRecDate',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: "供应商ID",
            dataIndex: 'VendorId',
            width: 20,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: "科室ID",
            dataIndex: 'LocId',
            width: 20,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: "HHImport",
            dataIndex: 'HHImport',
            width: 100,
            align: 'left',
            sortable: true,
            hidden:true
        }
    ]);
    
    SCIMasterInfoCm.defaultSortable = true;
    
    var GridPagingToolbar = new Ext.PagingToolbar({
        store: SCIMasterInfoStore,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
        emptyMsg: "没有记录"
    });
    
    var SCIMasterInfoGrid = new Ext.grid.GridPanel({
        id: 'SCIMasterInfoGrid',
        title: '',
        height: 170,
        cm: SCIMasterInfoCm,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true,
            listeners: {
                'rowselect': function(sm, rowIndex, r) {
                    var HHImport = SCIMasterInfoStore.getAt(rowIndex).get("HHImport");
                    var pagesize = SCIDetailGridPagingToolbar.pageSize;
                    SCIDetailInfoStore.setBaseParam('StrParam', HHImport);
                    SCIDetailInfoStore.load({ 
                    	params: { start: 0, limit: 999, sort: '', dir: '' },
			           	callback: function(r, options, success) {
			                if (success == false) {
			                    Ext.MessageBox.alert("查询错误",SCIDetailInfoStore.reader.jsonData.Error);  
			                };
			            }                     
                    });
                }
            }
        }),
        store: SCIMasterInfoStore,
        trackMouseOver: true,
        stripeRows: true,
        loadMask: true,
        bbar: GridPagingToolbar
    });

    // 访问路径
    var DetailInfoUrl = DictUrl +
        'hhimportaction.csp?actiontype=QueryHHImportDetail'; //获取明细数据
        
    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
        url: DetailInfoUrl,
        method: "POST"
    });
    
    // 指定列参数
    var fields = ["IncId", "BatchNo", "IngrUom", "ExpDate", "Margin", "RecQty",
        "IncCode", "IncDesc", "InvNo", "Manf", "Rp", "RpAmt",
        "Sp", "SpAmt", "InvDate", "Spec", "InvMonney", "HHImportItm", "ReqLocDesc"
    ];
    
    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "HHImportItm",
        fields: fields
    });
    
    // 数据集
    var SCIDetailInfoStore = new Ext.data.Store({
        proxy: proxy,
        reader: reader
    });
    
    var nm = new Ext.grid.RowNumberer();
    
    var SCIDetailInfoCm = new Ext.grid.ColumnModel([nm, {
            header: "IncRowid",
            dataIndex: 'IncId',
            width: 100,
            align: 'left',
            sortable: true,
            hidden: true,
            hideable: false
        },
        {
            header: '直送科室',
            dataIndex: 'ReqLocDesc',
            width: 120,
            align: 'left',
            sortable: true,
            renderer: BoldBlueRender,
            hidden:true
        },
        {
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
        }, {
            header: "发票金额",
            dataIndex: 'InvMoney',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: "规格",
            dataIndex: 'Spec',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: "RowId",
            dataIndex: 'HHImportItm',
            width: 100,
            align: 'left',
            sortable: true,
            hidden:true
        }

    ]);

    function BoldBlueRender(val) {
        return '<span style="color:blue;font-weight:bold">' + val + '</span>';
    }
    
    SCIDetailInfoCm.defaultSortable = true;
    
    var SCIDetailGridPagingToolbar = new Ext.PagingToolbar({
        store: SCIDetailInfoStore,
        pageSize: 9999,
        displayInfo: true,
        displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
        emptyMsg: "没有记录"
    });
    
    var SCIDetailInfoGrid = new Ext.grid.GridPanel({
        title: '',
        height: 170,
        cm: SCIDetailInfoCm,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        store: SCIDetailInfoStore,
        trackMouseOver: true,
        stripeRows: true,
        loadMask: true,
        bbar: SCIDetailGridPagingToolbar
    });

    // 双击事件
    SCIMasterInfoGrid.on('rowdblclick', function() {
        //returnData();
    });

    var window = new Ext.Window({
        title: '供应链接口入库',
        width: document.body.clientWidth * 0.98,
        height: document.body.clientHeight * 0.98,
        layout: 'border',
        modal: true,
        items: [ 
            {
                region: 'north',
                height: 110,
                layout: 'fit',
                items: SCIFormS
            }, {
                region: 'west',
                title: '供应链入库单',
                collapsible: true,
                split: true,
                width: 400,
                minSize: document.body.clientWidth * 0.1,
                maxSize: document.body.clientWidth * 0.9,
                margins: '0 5 0 0',
                layout: 'fit',
                items: SCIMasterInfoGrid

            }, {
                region: 'center',
                title: '供应链入库单明细',
                layout: 'fit',
                items: SCIDetailInfoGrid

            }
        ],
        tbar: [SCISearchBT, '-', SCICommitBT, '-', SCISynRecBT, '-', SCIClearBT, '-', SCICloseBT]
    });
    
    window.show();

    ///提交入库
    function CommitImport() {
        var selectRows = SCIMasterInfoGrid.getSelectionModel().getSelections();
        if (selectRows.length == 0) {
            Ext.Msg.show({
                title: '错误',
                msg: '请选择供应链入库信息！',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
        } else {
            var HHImport = selectRows[0].get("HHImport");
            var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候...", removeMask: true });
            loadMask.show();
            var url = DictUrl + "hhimportaction.csp?actiontype=CommitImport";
            Ext.Ajax.request({
                url: url,
                method: 'Post',
                params: { StrParam: HHImport, UserId: gUserId },
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    if (jsonData.success == 'false') {
                        ret = jsonData.info;
                        Ext.Msg.show({
                            title: '错误',
                            msg: ret,
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    } else {
                        var ImportId = jsonData.info;
                        Msg.info("success", "提交入库成功!");
                        window.close();
                        Fn(ImportId);
                    }
                    loadMask.hide();
                    //searchDHCNetData();
                },
                scope: this
            });

            return true;
        }
    }

    function addComboData(store, id, desc) {
        var defaultData = {
            RowId: id,
            Description: desc
        };
        var r = new store.recordType(defaultData);
        store.add(r);
    }
    
    // 初始化下拉
    var IngVendor = Ext.getCmp("Vendor").getValue();
    var IngVendorText = Ext.getCmp("Vendor").getRawValue();
    addComboData(Ext.getCmp("SCIVendor").getStore(), IngVendor, IngVendorText);
    Ext.getCmp("SCIVendor").setValue(IngVendor);
    var IngPhaLoc = Ext.getCmp("PhaLoc").getValue();
    var IngPhaText = Ext.getCmp("PhaLoc").getRawValue();
    addComboData(Ext.getCmp("SCIRecLoc").getStore(), IngPhaLoc, IngPhaText);
    Ext.getCmp("SCIRecLoc").setValue(IngPhaLoc);
    var IngStkGrp = Ext.getCmp("StkGrpType").getValue();
    var IngStkGrpText = Ext.getCmp("StkGrpType").getRawValue();
    addComboData(Ext.getCmp("SCIStkGrpType").getStore(), IngStkGrp, IngStkGrpText);
    Ext.getCmp("SCIStkGrpType").setValue(IngStkGrp);
    Ext.getCmp("SCIImportStat").setValue("N");
    Ext.getCmp("SCISxNo").focus(true, 100);

}