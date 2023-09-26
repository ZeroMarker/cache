// /����: ��ѯ����
// /����: ��ѯ����
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.18
var deleteingdr = ""
var closeflag = ""

function DrugImportGrSearch(dataStore, Fn) {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    // ��ⵥ��
    var InGrNoS = new Ext.form.TextField({
        fieldLabel: '��ⵥ��',
        id: 'InGrNoS',
        name: 'InGrNoS',
        anchor: '90%',
        width: 120
    });

    // ��Ӧ��
    var VendorS = new Ext.ux.VendorComboBox({
        fieldLabel: '��Ӧ��',
        id: 'VendorS',
        name: 'VendorS',
        anchor: '90%',
        emptyText: '��Ӧ��...'
    });

    // ��ⲿ��
    var PhaLocS = new Ext.ux.LocComboBox({
        fieldLabel: '��ⲿ��',
        id: 'PhaLocS',
        name: 'PhaLocS',
        anchor: '90%',
        emptyText: '��ⲿ��...',
        groupId: session['LOGON.GROUPID']
    });

    // ��ʼ����
    var StartDateS = new Ext.ux.DateField({
        fieldLabel: '��ʼ����',
        id: 'StartDateS',
        name: 'StartDateS',
        anchor: '90%',
        value: DefaultStDate()
    });

    // ��������
    var EndDateS = new Ext.ux.DateField({
        fieldLabel: '��������',
        id: 'EndDateS',
        name: 'EndDateS',
        anchor: '90%',
        value: DefaultEdDate()
    });

    // ������ť
    var searchBT = new Ext.Toolbar.Button({
        text: '��ѯ',
        tooltip: '�����ѯ��ⵥ��Ϣ',
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
            Msg.info("warning", "��ѡ����ⲿ��!");
            return;
        }

        if (StartDate == "" || EndDate == "") {
            Msg.info("warning", "��ѡ��ʼ���ںͽ�ֹ����!");
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
                    Msg.info("error", "��ѯ������鿴��־!");
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

    // ѡȡ��ť
    var returnBT = new Ext.Toolbar.Button({
        text: 'ѡȡ',
        tooltip: '���ѡȡ',
        iconCls: 'page_goto',
        height: 30,
        width: 70,
        handler: function() {
            closeflag = "1";
            returnData();
        }
    });

    // ��հ�ť
    var clearBT = new Ext.Toolbar.Button({
        text: '����',
        tooltip: '�������',
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

    // 3�رհ�ť
    var closeBT = new Ext.Toolbar.Button({
        text: '�ر�',
        tooltip: '�رս���',
        iconCls: 'page_close',
        height: 30,
        width: 70,
        handler: function() {
            clearData();
            window.close();
        }
    });

    // ɾ����ť
    var DeleteBT = new Ext.Toolbar.Button({
        id: "DeleteBT",
        text: 'ɾ��',
        tooltip: '���ɾ��',
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
                title: '����',
                msg: '��ѡ��Ҫɾ������ⵥ��Ϣ��',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
        } else {
            var InGrRowId = selectRows[0].get("IngrId");
            deleteingdr = InGrRowId;
            Ext.MessageBox.show({
                title: '��ʾ',
                msg: '�Ƿ�ȷ��ɾ��������ⵥ',
                buttons: Ext.MessageBox.YESNO,
                fn: showDeleteGr,
                icon: Ext.MessageBox.QUESTION
            });
        }
    }

    /**
     * ɾ����ⵥ��ʾ
     */
    function showDeleteGr(btn) {
        if (btn == "yes") {
            var url = DictUrl + "ingdrecaction.csp?actiontype=Delete&IngrRowid=" + deleteingdr;
            Ext.Ajax.request({
                url: url,
                method: 'POST',
                waitMsg: '������...',
                success: function(result, request) {
                    var jsonData = Ext.util.JSON
                        .decode(result.responseText);
                    if (jsonData.success == 'true') {
                        // ɾ������
                        Msg.info("success", "��ⵥɾ���ɹ�!");
                        deleteingdr = "";
                        searchDurgData();
                    } else {
                        var ret = jsonData.info;
                        if (ret == -1) {
                            Msg.info("error", "��ⵥ�Ѿ���ɣ�����ɾ��!");
                        } else if (ret == -2) {
                            Msg.info("error", "��ⵥ�Ѿ���ˣ�����ɾ��!");
                        } else if (ret == -3) {
                            Msg.info("error", "��ⵥ������ϸ�Ѿ���ˣ�����ɾ��!");
                        } else {
                            Msg.info("error", "ɾ��ʧ��,��鿴������־!");
                        }
                    }
                },
                scope: this
            });
        }
    }

    // ����·��
    var MasterInfoUrl = DictUrl + 'ingdrecaction.csp?actiontype=Query';

    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
        url: MasterInfoUrl,
        method: "POST"
    });

    // ָ���в���
    var fields = ["IngrId", "IngrNo", "Vendor", "RecLoc", "IngrType", "PurchUser",
        "PoNo", "CreateUser", "CreateDate", "Complete", "ReqLoc",
        "StkGrp", "RpAmt", "SpAmt"
    ];

    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "IngrId",
        fields: fields
    });

    // ���ݼ�
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
        header: "��ⵥ��",
        dataIndex: 'IngrNo',
        width: 120,
        align: 'left',
        sortable: true
    }, {
        header: "��Ӧ��",
        dataIndex: 'Vendor',
        width: 200,
        align: 'left',
        sortable: true
    }, {
        header: '��������',
        dataIndex: 'RecLoc',
        width: 150,
        align: 'left',
        sortable: true
    }, {
        header: '������',
        dataIndex: 'CreateUser',
        width: 70,
        align: 'left',
        sortable: true
    }, {
        header: '��������',
        dataIndex: 'CreateDate',
        width: 90,
        align: 'left',
        sortable: true
    }, {
        header: '�ɹ�Ա',
        dataIndex: 'PurchUser',
        width: 70,
        align: 'left',
        sortable: true
    }, {
        header: "�������",
        dataIndex: 'IngrType',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: "��ɱ�־",
        dataIndex: 'Complete',
        width: 70,
        align: 'left',
        sortable: true
    }, {
        header: "���۽��",
        dataIndex: 'RpAmt',
        width: 100,
        align: 'right',
        sortable: true
    }, {
        header: "�ۼ۽��",
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
        displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
        emptyMsg: "û�м�¼"
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

    // ��ӱ�񵥻����¼�
    GrMasterInfoGrid.on('rowclick', function(grid, rowIndex, e) {
        //var InGr = GrMasterInfoStore.getAt(rowIndex).get("IngrId");
        //GrDetailInfoStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',Parref:InGr}});
    });

    // ����·��
    var DetailInfoUrl = DictUrl +
        'ingdrecaction.csp?actiontype=QueryDetail';

    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
        url: DetailInfoUrl,
        method: "POST"
    });

    // ָ���в���
    var fields = ["Ingri", "BatchNo", "IngrUom", "ExpDate", "Inclb", "Margin", "RecQty",
        "Remarks", "IncCode", "IncDesc", "InvNo", "Manf", "Rp", "RpAmt",
        "Sp", "SpAmt", "InvDate", "QualityNo", "SxNo", "Remark", "MtDesc", "PubDesc"
    ];

    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "Ingri",
        fields: fields
    });

    // ���ݼ�
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
        header: 'ҩƷ����',
        dataIndex: 'IncCode',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: 'ҩƷ����',
        dataIndex: 'IncDesc',
        width: 230,
        align: 'left',
        sortable: true
    }, {
        header: "����",
        dataIndex: 'Manf',
        width: 180,
        align: 'left',
        sortable: true
    }, {
        header: "����",
        dataIndex: 'BatchNo',
        width: 90,
        align: 'left',
        sortable: true
    }, {
        header: "��Ч��",
        dataIndex: 'ExpDate',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: "��λ",
        dataIndex: 'IngrUom',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: "����",
        dataIndex: 'RecQty',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: "����",
        dataIndex: 'Rp',
        width: 60,
        align: 'right',

        sortable: true
    }, {
        header: "�ۼ�",
        dataIndex: 'Sp',
        width: 60,
        align: 'right',

        sortable: true
    }, {
        header: "��Ʊ��",
        dataIndex: 'InvNo',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: "��Ʊ����",
        dataIndex: 'InvDate',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: "���۽��",
        dataIndex: 'RpAmt',
        width: 100,
        align: 'left',

        sortable: true
    }, {
        header: "�ۼ۽��",
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
        displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
        emptyMsg: "û�м�¼"
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

    // ˫���¼�
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
            title: '��ѯ����',
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
    // ҳ�沼��
    var mainPanel1 = new Ext.form.FormPanel({
        activeTab: 0,
        height: 410,
        width: 1200,
        region: 'center',
        layout: 'border',
        items: [{
            region: 'west',
            title: '��ⵥ',
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
            title: '��ⵥ��ϸ',
            layout: 'fit',
            items: GrDetailInfoGrid

        }]
    });

    var window = new Ext.Window({
        title: '��ⵥ��ѯ',
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
                title: '����',
                msg: '��ѡ��Ҫ���ص���ⵥ��Ϣ��',
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
                DHCSTLockToggle(gIngrRowid, "G", "UL"); //������һ�ŵ���
            }
            //getInGrInfoByInGrRowId(InGrRowId, selectRows[0]);
            window.close();
        }
    }
}