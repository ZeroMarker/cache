// /����: ���ⵥ��ѯ
// /����: ���ⵥ��ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.24

Ext.onReady(function() {
    var userId = session['LOGON.USERID'];
    var gGroupId = session['LOGON.GROUPID'];
    var gLocId = session['LOGON.CTLOCID'];
    var gInciRowId = "";
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    ChartInfoAddFun();
    // ��¼����Ĭ��ֵ
    SetLogInDept(PhaDeptStore, "SupplyPhaLoc");
    //ȡ��������
    if (gParam == null || gParam.length < 1) {
        GetParam();
    }
    if (gParamCommon.length < 1) {
        GetParamCommon(); //��ʼ��������������
    }

    function ChartInfoAddFun() {

        // ������
        var RequestPhaLoc = new Ext.ux.LocComboBox({
            fieldLabel: '������',
            id: 'RequestPhaLoc',
            name: 'RequestPhaLoc',
            anchor: '90%',
            width: 120,
            emptyText: '������...',
            defaultLoc: {}
        });

        // ��������
        var SupplyPhaLoc = new Ext.ux.LocComboBox({
            fieldLabel: '��������',
            id: 'SupplyPhaLoc',
            name: 'SupplyPhaLoc',
            anchor: '90%',
            width: 120,
            emptyText: '��������...',
            groupId: gGroupId
        });

        // ��ʼ����
        var StartDate = new Ext.ux.DateField({
            fieldLabel: '��ʼ����',
            id: 'StartDate',
            name: 'StartDate',
            anchor: '90%',
            width: 120,
            value: DefaultStDate()
        });

        // ��ֹ����
        var EndDate = new Ext.ux.DateField({
            fieldLabel: '��ֹ����',
            id: 'EndDate',
            name: 'EndDate',
            anchor: '90%',
            width: 120,
            value: DefaultEdDate()
        });

        //ת�Ƶ���
        var IsTrNo = new Ext.form.TextField({
            fieldLabel: 'ת�Ƶ���',
            id: 'IsTrNo',
            name: 'IsTrNo',
            anchor: '90%',
            width: 120,
            disabled: false
        });

        var StatusStore = new Ext.data.SimpleStore({
            fields: ['RowId', 'Description'],
            data: [
                ['10', 'δ���'],
                ['11', '�����'],
                ['20', '������˲�ͨ��'],
                ['21', '�������ͨ��'],
                ['30', '�ܾ�����'],
                ['31', '�ѽ���'],
                ['32', '���ֽ���']
            ]
        });

        // ��������
        var OperateOutType = new Ext.ux.ComboBox({
            fieldLabel: '��������',
            id: 'OperateOutType',
            name: 'OperateOutType',
            store: OperateOutTypeStore,
            valueField: 'RowId',
            displayField: 'Description'
        });

        var Status = new Ext.form.ComboBox({
            fieldLabel: 'ת��״̬',
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

        // ҩƷ����
        var StkGrpType = new Ext.ux.StkGrpComboBox({
            id: 'StkGrpType',
            name: 'StkGrpType',
            StkType: App_StkTypeCode, //��ʶ��������
            LocId: gLocId,
            UserId: userId,
            anchor: '90%',
            width: 200,
            fieldLabel: '�ࡡ����'
        });

        // ҩƷ����
        var InciDesc = new Ext.form.TextField({
            fieldLabel: 'ҩƷ����',
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

        // ����ҩƷ���岢���ؽ��
        function GetPhaOrderInfo(item, stktype) {
            if (item != null && item.length > 0) {
                GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "", getDrugList);
            }
        }

        // ���ط���
        function getDrugList(record) {
            if (record == null || record == "") {
                return;
            }
            var inciDr = record.get("InciDr");
            var InciDesc = record.get("InciDesc");
            Ext.getCmp("InciDesc").setValue(InciDesc);
            gInciRowId = inciDr;
        }

        // ��ѯ��ť
        var SearchBT = new Ext.Toolbar.Button({
            text: '��ѯ',
            tooltip: '�����ѯ',
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
                Msg.info("warning", "��ѡ��Ӧ����!");
                return;
            }
            var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
            var startDate = Ext.getCmp("StartDate").getRawValue();
            var endDate = Ext.getCmp("EndDate").getRawValue();
            var statue = Ext.getCmp("Status").getValue();
            var stkgrpid = Ext.getCmp("StkGrpType").getValue();
            var inci = gInciRowId;
            var IsTrNo = Ext.getCmp("IsTrNo").getValue(); //���Ź��� 
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

        // ��հ�ť
        var ClearBT = new Ext.Toolbar.Button({
            text: '���',
            tooltip: '������',
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

        // ��ӡ��ť
        var PrintBT = new Ext.Toolbar.Button({
            text: '��ӡ',
            tooltip: '�����ӡ',
            width: 70,
            height: 30,
            iconCls: 'page_print',
            handler: function() {
                var rowData = MasterGrid.getSelectionModel().getSelected();
                if (rowData == null) {
                    Msg.info("warning", "��ѡ����Ҫ��ӡ��ת�Ƶ�!");
                    return;
                }
                var init = rowData.get("init");
                PrintInIsTrf(init, gParam[8]);
            }
        });

        // ��水ť
        var SaveAsBT = new Ext.Toolbar.Button({
            text: '���',
            tooltip: '���ΪExcel',
            iconCls: 'page_export',
            width: 70,
            height: 30,
            handler: function() {
                ExportAllToExcel(DetailGrid);
            }
        });

        // ����·��
        var MasterUrl = DictUrl + 'dhcinistrfaction.csp?actiontype=Query';

        // ͨ��AJAX��ʽ���ú�̨����
        var proxy = new Ext.data.HttpProxy({
            url: MasterUrl,
            method: "POST"
        });

        // ָ���в���
        var fields = ["init", "initNo", "reqNo", "toLocDesc", "frLocDesc", "dd", "tt", "comp", "userName",
            "status", "RpAmt", "SpAmt", "MarginAmt", "Remark", "StatusCode"
        ];

        // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
        var reader = new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: "results",
            id: "init",
            fields: fields
        });

        // ���ݼ�
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
            header: "ת�Ƶ���",
            dataIndex: 'initNo',
            width: 150,
            align: 'left',
            sortable: true
        }, {
            header: '���󵥺�',
            dataIndex: 'reqNo',
            width: 150,
            align: 'left',
            sortable: true
        }, {
            header: "������",
            dataIndex: 'toLocDesc',
            width: 180,
            align: 'left',
            sortable: true
        }, {
            header: "��������",
            dataIndex: 'frLocDesc',
            width: 180,
            align: 'left',
            sortable: true
        }, {
            header: "ת������",
            dataIndex: 'dd',
            width: 90,
            align: 'center',
            sortable: true
        }, {
            header: "����״̬",
            dataIndex: 'StatusCode',
            width: 120,
            align: 'left',
            sortable: true
        }, {
            header: "�Ƶ���",
            dataIndex: 'userName',
            width: 90,
            align: 'left',
            sortable: true
        }, {
            header: "���۽��",
            dataIndex: 'RpAmt',
            width: 80,
            align: 'right',
            sortable: true,
            renderer: FormatGridRpAmount
        }, {
            header: "�ۼ۽��",
            dataIndex: 'SpAmt',
            width: 80,
            align: 'right',
            sortable: true,
            renderer: FormatGridSpAmount
        }, {
            header: "�������",
            dataIndex: 'MarginAmt',
            width: 80,
            align: 'right',
            sortable: true,
            renderer: FormatGridRpAmount
        }, {
            header: "��ע",
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
            displayMsg: '�� {0} ���� {1}��, һ�� {2} ��',
            emptyMsg: "û�м�¼"
        });

        var MasterGrid = new Ext.grid.GridPanel({
            title: '',
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

        // ��ӱ�񵥻����¼�
        MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
            var InIt = MasterStore.getAt(rowIndex).get("init");
            DetailStore.setBaseParam('Parref', InIt)
            DetailStore.load({ params: { start: 0, limit: GridDetailPagingToolbar.pageSize, sort: 'Rowid', dir: 'Desc' } });
        });

        // ת����ϸ
        // ����·��
        var DetailUrl = DictUrl +
            'dhcinistrfaction.csp?actiontype=QueryDetail';

        // ͨ��AJAX��ʽ���ú�̨����
        var proxy = new Ext.data.HttpProxy({
            url: DetailUrl,
            method: "POST"
        });

        // ָ���в���
        var fields = ["initi", "inrqi", "inci", "inciCode",
            "inciDesc", "inclb", "batexp", "manf", "manfName",
            "qty", "uom", "sp", "status", "remark",
            "reqQty", "inclbQty", "reqLocStkQty", "stkbin",
            "pp", "spec", "gene", "formDesc", "newSp",
            "spAmt", "rp", "rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty", "TrUomDesc", "reqstkbin"
        ];

        // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
        var reader = new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: "results",
            id: "initi",
            fields: fields
        });

        // ���ݼ�
        var DetailStore = new Ext.data.Store({
            proxy: proxy,
            reader: reader
        });

        var nm = new Ext.grid.RowNumberer();

        var DetailCm = new Ext.grid.ColumnModel([nm, {
            header: "ת��ϸ��RowId",
            dataIndex: 'initi',
            width: 100,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: "ҩƷId",
            dataIndex: 'inci',
            width: 80,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: 'ҩƷ����',
            dataIndex: 'inciCode',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: 'ҩƷ����',
            dataIndex: 'inciDesc',
            width: 220,
            align: 'left',
            sortable: true
        }, {
            header: "����Id",
            dataIndex: 'inclb',
            width: 180,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: "����/Ч��",
            dataIndex: 'batexp',
            width: 185,
            align: 'left',
            sortable: true
        }, {
            header: "��������",
            dataIndex: 'manfName',
            width: 180,
            align: 'left',
            sortable: true
        }, {
            header: "���ο��",
            dataIndex: 'inclbQty',
            width: 80,
            align: 'right',
            sortable: true
        }, {
            header: "ת������",
            dataIndex: 'qty',
            width: 80,
            align: 'right',
            sortable: true
        }, {
            header: "ת�Ƶ�λ",
            dataIndex: 'TrUomDesc',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: "����",
            dataIndex: 'rp',
            width: 60,
            align: 'right',

            sortable: true
        }, {
            header: "�ۼ�",
            dataIndex: 'sp',
            width: 60,
            align: 'right',

            sortable: true
        }, {
            header: "��������",
            dataIndex: 'reqQty',
            width: 80,
            align: 'right',
            sortable: true
        }, {
            header: "��������λ",
            dataIndex: 'stkbin',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: "���󷽻�λ",
            dataIndex: 'reqstkbin',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: "���󷽿��",
            dataIndex: 'reqLocStkQty',
            width: 100,
            align: 'right',
            sortable: true
        }, {
            header: "ռ������",
            dataIndex: 'inclbDirtyQty',
            width: 80,
            align: 'right',
            sortable: true
        }, {
            header: "��������",
            dataIndex: 'inclbAvaQty',
            width: 80,
            align: 'right',
            sortable: true
        }, {
            header: "�����ۼ�",
            dataIndex: 'newSp',
            width: 100,
            align: 'right',

            sortable: true
        }, {
            header: "���",
            dataIndex: 'spec',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: "����ͨ����",
            dataIndex: 'gene',
            width: 120,
            align: 'left',
            sortable: true
        }, {
            header: "����",
            dataIndex: 'formDesc',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: "�ۼ۽��",
            dataIndex: 'spAmt',
            width: 100,
            align: 'right',
            sortable: true,
            renderer: FormatGridSpAmount
        }, {
            header: "���۽��",
            dataIndex: 'rpAmt',
            width: 100,
            align: 'right',
            sortable: true,
            renderer: FormatGridRpAmount
        }]);

        var GridDetailPagingToolbar = new Ext.PagingToolbar({
            store: DetailStore,
            pageSize: PageSize,
            displayInfo: true,
            displayMsg: '�� {0} ���� {1}��, һ�� {2} ��',
            emptyMsg: "û�м�¼"
        });

        var DetailGrid = new Ext.grid.GridPanel({
            title: '',
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
            rightClickTransMenu.showAt(e.getXY()); //��ȡ����

        }

        // ��ѯδת����
        function RequestNotMoveShow() {
            var rowData = MasterGrid.getSelectionModel().getSelected();
            if (rowData == null) {
                Msg.info("warning", "��ѡ��ת�Ƶ�!");
                return;
            }
            var transno = rowData.get("initNo");
            var reqno = rowData.get("reqNo");
            if (reqno == "") {
                Msg.info("warning", "�޶�Ӧ����!");
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
                text: '�鿴δת������'
            }]
        });

        var HisListTab = new Ext.form.FormPanel({
            labelWidth: 60,
            labelAlign: 'right',
            title: "���ⵥ��ѯ",
            frame: true,
            //autoScroll : true,
            autoHeight: true,
            tbar: [SearchBT, '-', ClearBT, '-', PrintBT, '-', SaveAsBT],
            //layout: 'fit',    // Specifies that the items will now be arranged in columns
            items: [{
                xtype: 'fieldset',
                layout: 'column',
                defaults: { border: false },
                style: DHCSTFormStyle.FrmPaddingV,
                title: '��ѯ����',
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

        // ҳ�沼��
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
                    title: '���ⵥ',
                    layout: 'fit', // specify layout manager for items
                    items: MasterGrid
                }, {
                    region: 'south',
                    split: true,
                    height: 250,
                    minSize: 200,
                    maxSize: 350,
                    collapsible: true,
                    title: '���ⵥ��ϸ',
                    layout: 'fit', // specify layout manager for items
                    items: DetailGrid
                }
            ],
            renderTo: 'mainPanel'
        });
    }
})