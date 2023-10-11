// /����: ѡҩƷ����Ӧ���δ���
// /����: ѡҩƷ����Ӧ����
// /��д�ߣ�zhangdongmei
// /��д����: 2013.01.22

/**
 Input:ҩƷ����¼��ֵ
 StkGrpRowId������id
 StkGrpType���������ͣ�G��ҩƷ
 Locdr:����id
 NotUseFlag�������ñ�־
 QtyFlag���Ƿ����0�����Ŀ
 HospID��ҽԺid
 ReqLoc:�������id(�������idΪ��ʱ��������ҿ����ʾΪ��)
 Fn���ص�����
 */
IncItmBatWindow = function(Input, StkGrpRowId, StkGrpType, Locdr, NotUseFlag,
    QtyFlag, HospID, ReqLoc, Fn) {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    if (StkGrpRowId == null) { 
        StkGrpRowId = ""; 
    }
    var flg = false;

    // �滻�����ַ�
    while (Input.indexOf("*") >= 0) {
        Input = Input.substring(0, Input.indexOf("*"));
    }

    /*ҩƷ����------------------------------*/
    var PhaOrderUrl = 'dhcst.drugutil.csp?actiontype=GetPhaOrderItemForDialog&Input=' +
        encodeURI(Input) + '&StkGrpRowId=' + StkGrpRowId + '&StkGrpType=' +
        StkGrpType + '&Locdr=' + Locdr + '&NotUseFlag=' + NotUseFlag +
        '&QtyFlag=' + QtyFlag + '&HospID=' + HospID + '&start=' + 0 +
        '&limit=' + 15+'&ReqLocDr='+ReqLoc;

    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
        url: PhaOrderUrl,
        method: "POST"
    });

    // ָ���в���
    var fields = ["InciDr", "InciItem", "InciCode", "InciDesc", "Spec",
        "ManfName", "PuomDesc", "pRp", "pSp", "PuomQty", "BuomDesc", "bRp",
        "bSp", "BuomQty", "BillUomDesc", "BillSp", "BillRp", "BillUomQty",
        "PhcFormDesc", "GoodName", "GeneName", { name: 'NotUseFlag', type: 'bool' }, "PuomDr",
        "PFac", "Manfdr", "MaxQty", "MinQty", "StockQty", "Remark","ReqStockQty","StkBin","InsuCode","InsuDesc"
    ];

    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "InciDr",
        fields: fields
    });

    // ���ݼ�
    var PhaOrderStore = new Ext.data.Store({
        proxy: proxy,
        reader: reader
    });

    var StatuTabPagingToolbar = new Ext.PagingToolbar({
        store: PhaOrderStore,
        pageSize: 15,
        displayInfo: true,
        displayMsg: $g('��ǰ��¼ {0} -- {1} �� �� {2} ����¼'),
        emptyMsg: "No results to display",
        prevText: $g("��һҳ"),
        nextText: $g("��һҳ"),
        refreshText: $g("ˢ��"),
        lastText: $g("���ҳ"),
        firstText: $g("��һҳ"),
        beforePageText: $g("��ǰҳ"),
        afterPageText: $g("��{0}ҳ"),
        emptyMsg: $g("û������")
    });

    var nm = new Ext.grid.RowNumberer();

    var sm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true,
        listeners: {
            'rowselect': function(selmod, rowindex, record) {
                var record = PhaOrderGrid.getStore().getAt(rowindex);
                var incid = record.get("InciDr");
                var pagesize = ItmBatPagingToolbar.pageSize;
                ItmLcBtStore.setBaseParam("IncId", incid);
                ItmLcBtStore.setBaseParam("ProLocId", Locdr);
                ItmLcBtStore.setBaseParam("ReqLocId", ReqLoc);
                ItmLcBtStore.setBaseParam("QtyFlag", QtyFlag);
                ItmLcBtStore.load({ params: { start: 0, limit: pagesize } });
            }
        }
    });


    // the check column is created using a custom plugin
    var ColumnNotUseFlag = new Ext.grid.CheckColumn({
        header:$g( '������'),
        dataIndex: 'NotUseFlag',
        width: 45
    });
    var PhaOrderCm = new Ext.grid.ColumnModel([nm, sm, {
        header: $g("����"),
        dataIndex: 'InciCode',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g('����'),
        dataIndex: 'InciDesc',
        width: 200,
        align: 'left',
        sortable: true
    }, {
        header: $g("���"),
        dataIndex: 'Spec',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g("������ҵ"),
        dataIndex: 'ManfName',
        width: 180,
        align: 'left',
        sortable: true
    }, {
        header: $g('��ⵥλ'),
        dataIndex: 'PuomDesc',
        width: 70,
        align: 'left',
        sortable: true
    }, {
        header: $g("�ۼ�(��ⵥλ)"),
        dataIndex: 'pSp',
        width: 100,
        align: 'right',

        sortable: true
    }, {
        header: $g("����(��ⵥλ)"),
        dataIndex: 'PuomQty',
        width: 100,
        align: 'right',
        sortable: true
    }, {
        header: $g("���󷽿��"),
        dataIndex: 'ReqStockQty',
        width: 100,
        align: 'right',
        sortable: true,
        hidden:ReqLoc==""?true:false
    }, {
        header: $g("������λ"),
        dataIndex: 'BuomDesc',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g("�ۼ�(������λ)"),
        dataIndex: 'bSp',
        width: 100,
        align: 'right',

        sortable: true
    }, {
        header: $g("����(������λ)"),
        dataIndex: 'BuomQty',
        width: 100,
        align: 'right',
        sortable: true
    }, {
        header: $g("�Ƽ۵�λ"),
        dataIndex: 'BillUomDesc',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g("�ۼ�(�Ƽ۵�λ)"),
        dataIndex: 'BillSp',
        width: 100,
        align: 'right',

        sortable: true
    }, {
        header: $g("����(�Ƽ۵�λ)"),
        dataIndex: 'BillUomQty',
        width: 100,
        align: 'right',
        sortable: true
    }, {
        header: $g("����"),
        dataIndex: 'PhcFormDesc',
        width: 60,
        align: 'left',
        sortable: true
    }, {
        header: $g("��Ʒ��"),
        dataIndex: 'GoodName',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g("����ͨ����"),
        dataIndex: 'GeneName',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g("��λ��"),
        dataIndex: 'StkBin',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g("����ҽ������"),
        dataIndex: 'InsuCode',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g("����ҽ������"),
        dataIndex: 'InsuDesc',
        width: 100,
        align: 'left',
        sortable: true
    }
    
    ,ColumnNotUseFlag]);
    
    PhaOrderCm.defaultSortable = true;
    
    var PhaOrderGrid = new Ext.grid.GridPanel({
        cm: PhaOrderCm,
        store: PhaOrderStore,
        trackMouseOver: true,
        stripeRows: true,
        sm: sm,
        loadMask: true,
        bbar: StatuTabPagingToolbar,
        deferRowRender: false
    });

    // �س��¼�
    PhaOrderGrid.on('keydown', function(e) {
        if (e.getKey() == Ext.EventObject.ENTER) {
            ItmLcBtGrid.getSelectionModel().selectFirstRow(); // ѡ�е�һ�в���ý���
            row = ItmLcBtGrid.getView().getRow(0);
            if (row) {
                var element = Ext.get(row);
                if (typeof(element) != "undefined" && element != null) {
                    element.focus();
                    ItmLcBtGrid.getView().focusRow(0);
                }
            }
        }
    });

    // ˫���¼�
    PhaOrderGrid.on('rowclick', function(grid, rowindex, e) {
        if (rowindex > 0) {
            var record = PhaOrderGrid.getStore().getAt(rowindex);
            var incid = record.get("InciDr");
            var pagesize = StatuTabPagingToolbar.pageSize;
            ItmLcBtStore.setBaseParam("IncId", incid);
            ItmLcBtStore.setBaseParam("ProLocId", Locdr);
            ItmLcBtStore.setBaseParam("ReqLocId", ReqLoc);
            ItmLcBtStore.load({
                params: { start: 0, limit: pagesize },
                callback: function(r, options, success) {
                    if (success == false) {
                        Msg.info('warning', $g('û���κμ�¼��'));
                        if (window) {
                            window.focus();
                        }
                    } else {
                        /*ItmLcBtGrid.getSelectionModel().selectFirstRow();// ѡ�е�һ�в���ý���,�˴�Ĭ�ϲ�ѡ������
                        row = ItmLcBtGrid.getView().getRow(0);
                        if (row){
                        	var element = Ext.get(row);
                        	if (typeof(element) != "undefined" && element != null) {
                        		element.focus();
                        	}	
                        }*/
                    }
                }
            });
        }
    });

    PhaOrderStore.load({
        callback: function(r, options, success) {
            if (success == false) {
                Msg.info('warning', $g('û���κη��ϵļ�¼��'));
                if (window) { window.hide(); }
            } else {
                PhaOrderGrid.getSelectionModel().selectFirstRow(); // ѡ�е�һ�в���ý���
                row = PhaOrderGrid.getView().getRow(0);
                if (row) {
                    var element = Ext.get(row);
                    if (typeof(element) != "undefined" && element != null) {
                        element.focus();
                        PhaOrderGrid.getView().focusRow(0);
                    }
                }
            }
        }
    });

    /*���δ���------------------------------*/
    // ָ���в���
    // ���ݼ�
    var ItmLcBtStore = new Ext.data.JsonStore({
        autoDestroy: true,
        url: DictUrl + 'drugutil.csp?actiontype=GetDrugBatInfo',
        root: 'rows',
        totalProperty: "results",
        remoteSort: true,
        idProperty: "Inclb",
        fields: ["Inclb", "BatExp", "Manf", "InclbQty", "PurUomDesc", "Sp", "ReqQty",
            "BUomDesc", "Rp", "StkBin", "SupplyStockQty", "RequrstStockQty", "IngrDate",
            "PurUomId", "BUomId", "ConFac", "DirtyQty", "AvaQty", "BatSp", "InclbWarnFlag","InsuCode","InsuDesc"
        ],
        baseParams: {
            IncId: '',
            ProLocId: '',
            ReqLocId: '',
            QtyFlag: ''
        }
    });

    var ItmBatPagingToolbar = new Ext.PagingToolbar({
        store: ItmLcBtStore,
        pageSize: 15,
        displayInfo: true,
        displayMsg: $g('��ǰ��¼ {0} -- {1} �� �� {2} ����¼'),
        emptyMsg: "No results to display",
        prevText: $g("��һҳ"),
        nextText: $g("��һҳ"),
        refreshText: $g("ˢ��"),
        lastText: $g("���ҳ"),
        firstText: $g("��һҳ"),
        beforePageText: $g("��ǰҳ"),
        afterPageText: $g("��{0}ҳ"),
        emptyMsg: $g("û������")
    });

    var nm2 = new Ext.grid.RowNumberer();
    //var sm2 = new Ext.grid.CheckboxSelectionModel({singleSelect:true});
    var sm2 = new Ext.grid.CheckboxSelectionModel({ singleSelect: true });
    var ItmLcBtCm = new Ext.grid.ColumnModel([nm2, sm2, {
        header: "����RowID",
        dataIndex: 'Inclb',
        width: 100,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: $g("����/Ч��"),
        dataIndex: 'BatExp',
        width: 180,
        align: 'left',
        sortable: true,
        renderer: InclbQuickTips
    }, {
        header: $g("���ο��"),
        dataIndex: 'InclbQty',
        width: 90,
        align: 'right',
        sortable: true
    }, {
        header: $g("��λ"),
        dataIndex: 'PurUomDesc',
        width: 80,
        align: 'left',
        sortable: true,
        hidden:true
    }, {
        header: $g("�����ۼ�(���)"),
        dataIndex: 'BatSp',
        width: 60,
        align: 'right',

        sortable: true
    }, {
        header: $g("��������"),
        dataIndex: 'ReqQty',
        width: 80,
        align: 'right',
        sortable: true,
        hidden:true
    }, {
        header: $g("������λRowId"),
        dataIndex: 'BUomId',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: $g("������λ"),
        dataIndex: 'BUomDesc',
        width: 80,
        align: 'left',
        sortable: true,
        hidden:true
    }, {
        header: $g("�ۼ�"),
        dataIndex: 'Sp',
        width: 60,
        align: 'right',

        sortable: true
    }, {
        header: $g("����"),
        dataIndex: 'Rp',
        width: 60,
        align: 'right',

        sortable: true
    }, {
        header: $g("��λ��"),
        dataIndex: 'StkBin',
        width: 100,
        align: 'left',
        sortable: true,
        hidden:true
    }, {
        header:$g("��Ӧ�����"),
        dataIndex: 'SupplyStockQty',
        width: 100,
        align: 'right',
        sortable: true,
        hidden:true
    }, {
        header: $g("���󷽿��"),
        dataIndex: 'RequrstStockQty',
        width: 100,
        align: 'right',
        sortable: true,
        hidden:true
    }, {
        header: $g("�������"),
        dataIndex: 'IngrDate',
        width: 90,
        align: 'center',
        sortable: true
    }, {
        header: $g("ת����"),
        dataIndex: 'ConFac',
        width: 100,
        align: 'left',
        sortable: true,
        hidden:true
    }, {
        header: $g("ռ�ÿ��"),
        dataIndex: 'DirtyQty',
        width: 90,
        align: 'right',
        sortable: true
    }, {
        header: $g("���ÿ��"),
        dataIndex: 'AvaQty',
        width: 90,
        align: 'right',
        sortable: true
    }, {
        header: $g("��ʾ����"),
        dataIndex: 'InclbWarnFlag',
        width: 90,
        align: 'right',
        sortable: true,
        hidden: true

    }, {
        header: $g("������ҵ"),
        dataIndex: 'Manf',
        width: 180,
        align: 'left',
        sortable: true
    }, {
        header: $g("����ҽ������"),
        dataIndex: 'InsuCode',
        width: 180,
        align: 'left',
        sortable: true,
        hidden:true
    }, {
        header: $g("����ҽ������"),
        dataIndex: 'InsuDesc',
        width: 180,
        align: 'left',
        sortable: true,
        hidden:true
    }
    
    ]);
    ItmLcBtCm.defaultSortable = true;
    var ItmLcBtGrid = new Ext.grid.GridPanel({
        cm: ItmLcBtCm,
        store: ItmLcBtStore,
        trackMouseOver: true,
        stripeRows: true,
        sm: sm2, //new Ext.grid.CheckboxSelectionModel({singleSelect:true}),
        loadMask: true,
        bbar: ItmBatPagingToolbar,
        deferRowRender: false,
        viewConfig: {
            getRowClass: function(record, rowIndex, rowParams, store) {
                var InciWarnFlag = record.get("InclbWarnFlag");
                switch (InciWarnFlag) {
                    case "1":
                        return 'classOrange';
                        break;
                    case "2":
                        return 'classSalmon';
                        break;
                }
            }
        }
    });

    function InclbQuickTips(data, metadata, record, rowIndex) {
        var title = "";
        var qtipinfo = "";
        var InciWarnFlag = record.get("InclbWarnFlag");
        if (InciWarnFlag == "1") {
            qtipinfo = $g("�����ѹ���!");
        } else if (InciWarnFlag == "2") {
            qtipinfo = $g("���β�����!");
        } else {
            return data;
        }
        metadata.attr = ' ext:qtip="' + qtipinfo + '"';
        return data;
    }

    // �س��¼�
    ItmLcBtGrid.on('keydown', function(e) {
        if (e.getKey() == Ext.EventObject.ENTER) {
            returnData();
        }
    });

    // ˫���¼�
    ItmLcBtGrid.on('rowdblclick', function() {
        returnData();
    });

    // ���ذ�ť
    var returnBT = new Ext.Toolbar.Button({
        text: $g('����'),
        tooltip: $g('�������'),
        iconCls: 'page_goto',
        handler: function() {
            returnData();
        }
    });

    // ��������
    function returnData() {
        var selectRows = ItmLcBtGrid.getSelectionModel().getSelections();
        if (selectRows.length == 0) {
            Msg.info("warning", $g("��ѡ��һ��������Ϣ��"));
        } else if (selectRows.length > 1) {
            Msg.info("warning", $g("ֻ��ѡ��һ��������Ϣ��"));
        } else {
            flg = true;
            window.close();
        }
    }

    // �رհ�ť
    var closeBT = new Ext.Toolbar.Button({
        text: $g('�ر�'),
        tooltip: $g('����ر�'),
        iconCls: 'page_delete',
        handler: function() {
            flg = false;
            window.close();
        }
    });

    if (!window) {
        var window = new Ext.Window({
            title: $g('���ҿ����������Ϣ'),
            width: document.body.clientWidth * 0.7,
            height: document.body.clientHeight * 0.9,
            layout: 'border',
            plain: true,
            tbar: [returnBT, '-', closeBT],
            modal: true,
            buttonAlign: 'center',
            autoScroll: true,
            items: [{
                region: 'north',
                height: document.body.clientHeight * 0.9 * 0.4,
                split: true,
                layout: 'fit',
                items: PhaOrderGrid
            }, {
                region: 'center',
                layout: 'fit',
                items: ItmLcBtGrid
            }]
        });
    }

    window.show();

    window.on('close', function(panel) {
        var selectRows = ItmLcBtGrid.getSelectionModel().getSelections();
        if (selectRows.length == 0) {
            Fn("");
        } else {
            if (flg) {
                var batRecord = selectRows[0];
                var itmRecord = PhaOrderGrid.getSelectionModel().getSelected();
                Ext.applyIf(batRecord.data, itmRecord.data);
                Fn(batRecord);
            } else {
                Fn("");
            }
        }
    });
}