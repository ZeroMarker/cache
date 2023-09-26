/// ���-�������
Ext.onReady(function () {
    var userId = session['LOGON.USERID'];
    var gGroupId = session['LOGON.GROUPID'];
    var LocId = session['LOGON.CTLOCID'];
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    if (gParam.length < 1) {
        GetParam(); //��ʼ����������
    }
    ChartInfoAddFun();

    function ChartInfoAddFun() {
        var PhaLoc = new Ext.ux.LocComboBox({
            fieldLabel: '��ⲿ��',
            id: 'PhaLoc',
            name: 'PhaLoc',
            anchor: '90%',
            width: 120,
            emptyText: '��ⲿ��...',
            groupId: gGroupId,
            listeners: {
                'select': function (e) {
                    var SelLocId = Ext.getCmp('PhaLoc').getValue(); //add wyx ����ѡ��Ŀ��Ҷ�̬��������
                    M_StkGrpType.getStore().removeAll();
                    M_StkGrpType.getStore().setBaseParam("locId", SelLocId)
                    M_StkGrpType.getStore().setBaseParam("userId", UserId)
                    M_StkGrpType.getStore().setBaseParam("type", App_StkTypeCode)
                    M_StkGrpType.getStore().load();
                }
            }
        });
        var Vendor = new Ext.ux.VendorComboBox({
            id: 'Vendor',
            name: 'Vendor',
            anchor: '90%',
            width: 140
        });
        // �������
        var IngrDate = new Ext.ux.DateField({
            fieldLabel: '�������',
            id: 'IngrDate',
            name: 'IngrDate',
            anchor: '90%',
            width: 100,
            value: new Date(),
            disabled: true
        });
        // ��ⵥ��
        var InGrNo = new Ext.form.TextField({
            fieldLabel: '��ⵥ��',
            id: 'InGrNo',
            name: 'InGrNo',
            anchor: '90%',
            disabled: true
        });
        // ҩƷ����
        var M_StkGrpType = new Ext.ux.StkGrpComboBox({
            id: 'M_StkGrpType',
            name: 'M_StkGrpType',
            StkType: App_StkTypeCode, //��ʶ��������
            LocId: LocId,
            UserId: userId,
            anchor: '90%'
        });
        var M_InciDesc = new Ext.form.TextField({
            fieldLabel: 'ҩƷ����',
            id: 'M_InciDesc',
            name: 'M_InciDesc',
            anchor: '90%',
            width: 150,
            listeners: {
                specialkey: function (field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        var stktype = Ext.getCmp("M_StkGrpType").getValue();
                        GetPhaOrderInfo(field.getValue(), stktype);
                    }
                }
            }
        });
        var M_InciCode = new Ext.form.TextField({
            fieldLabel: 'ҩƷ����',
            id: 'M_InciCode',
            name: 'M_InciCode',
            anchor: '90%',
            width: 150,
            valueNotFoundText: ''
        });
        // ��ѯ��ť
        var SearchBT = new Ext.Toolbar.Button({
            id: "SearchBT",
            text: '��ѯ����',
            tooltip: '�����ѯ����',
            width: 70,
            height: 30,
            iconCls: 'page_find',
            handler: function () {
                Query();
            }
        });
        // ��հ�ť
        var ClearBT = new Ext.Toolbar.Button({
            id: 'ClearBT',
            text: '����',
            tooltip: '�������',
            width: 70,
            height: 30,
            iconCls: 'page_clearscreen',
            handler: function () {
                clearData();
            }
        });
        // ���水ť
        var SaveBT = new Ext.Toolbar.Button({
            id: 'SaveBT',
            text: '����',
            tooltip: '�������',
            width: 70,
            height: 30,
            iconCls: 'page_save',
            //disabled : true,
            handler: function () {
                Save();
            }
        });
        // �����б�ť
        var AddBT = new Ext.Toolbar.Button({
            id: 'AddBT',
            text: '����',
            tooltip: '�����������б�',
            width: 70,
            height: 30,
            iconCls: 'page_add',
            //disabled : true,
            handler: function () {
                Add();
                GridPagingToolbar.updateInfo();
                BatGridPagingToolbar.updateInfo();
            }
        });
        /**
         * ��շ���
         */
        function clearData() {
            SetLogInDept(PhaLoc.getStore(), 'PhaLoc');
            Ext.getCmp("Vendor").setValue("");
            Ext.getCmp("IngrDate").setValue(new Date());
            Ext.getCmp("InGrNo").setValue("");
            Ext.getCmp("M_InciDesc").setValue("");
            Ext.getCmp("M_InciCode").setValue("");
            MasterStore.setBaseParam('Parref', '');
            MasterStore.removeAll();
            DetailStore.removeAll();
            GridPagingToolbar.updateInfo();
            BatGridPagingToolbar.updateInfo();
            Ext.getCmp("PhaLoc").fireEvent("select")
        }

        function Save() {
            var Locid = Ext.getCmp("PhaLoc").getValue();
            var Venid = Ext.getCmp("Vendor").getValue();
            if (Venid == "") {
                Msg.info("warning", "��ѡ��Ӧ��!");
                return;
            }
            var Stkgrptype = Ext.getCmp("M_StkGrpType").getValue();
            var CreateUser = userId;
            var IngdNo = Ext.getCmp("InGrNo").getValue();
            var MainInfo = Locid + "^" + Venid + "^" + Stkgrptype + "^" + CreateUser + "^" + IngdNo;
            var ListDetail = "";
            var rowCount = DetailGrid.getStore().getCount();
            for (var i = 0; i < rowCount; i++) {
                var rowData = DetailStore.getAt(i);
                var inclb = rowData.get("Inclb");
                var incicode = rowData.get("Incicode");
                var incidesc = rowData.get("Incidesc");
                var batno = rowData.get("Batno");
                var expdate = rowData.get("Expdate");
                var uom = rowData.get("Uom");
                var rp = rowData.get("Rp");
                var sp = rowData.get("Sp");
                var stkqty = rowData.get("StkQty");
                var recqty = rowData.get("RecQty");
                var manfid = rowData.get("ManfId");
                var str = inclb + "^" + incicode + "^" + incidesc + "^" + batno + "^" + expdate + "^" + uom + "^" +
                    rp + "^" + sp + "^" + stkqty + "^" + recqty + "^" + manfid
                if (ListDetail == "") {
                    ListDetail = str;
                } else {
                    ListDetail = ListDetail + RowDelim + str;
                }

            }
            if (ListDetail == "") {
                Msg.info("warning", "û����Ҫ���������");
                return;
            }
            var url = DictUrl +
                "virtualimpaction.csp?actiontype=Save";
            var loadMask = ShowLoadMask(Ext.getBody(), "������...");
            Ext.Ajax.request({
                url: url,
                method: 'POST',
                params: {
                    MainInfo: MainInfo,
                    ListDetail: ListDetail
                },
                waitMsg: '������...',
                success: function (result, request) {
                    var jsonData = Ext.util.JSON
                        .decode(result.responseText);
                    if (jsonData.success == 'true') {
                        // ˢ�½���
                        var IngrRowid = jsonData.info;
                        Msg.info("success", "����ɹ�!");
                        Ext.getCmp("InGrNo").setValue(jsonData.ingdrecNo);
                    } else {
                        var ret = jsonData.info;
                        if (ret == -99) {
                            Msg.info("error", "����ʧ��,���ܱ���!");
                        } else if (ret == -2) {
                            Msg.info("error", "������ⵥ��ʧ��,���ܱ���!");
                        } else if (ret == -3) {
                            Msg.info("error", "������ⵥ��ϸʧ��!");
                        } else if (ret == -4) {
                            Msg.info("error", "������ⵥʧ��!");
                        } else if (ret == -5) {
                            Msg.info("error", "������ⵥʧ��!");
                        } else {
                            Msg.info("error", "������ϸ���治�ɹ���" + ret);
                        }
                    }
                },
                scope: this
            });
            loadMask.hide();
        }

        function Add() {
            var rowData = BatGrid.getSelectionModel().getSelected();
            if (rowData == null) {
                Msg.info("warning", "û��ѡ����!");
                return;
            }
            var inclb = rowData.get("Inclb");
            var incicode = rowData.get("Incicode");
            var incidesc = rowData.get("Incidesc");
            var batno = rowData.get("Batno");
            var expdate = rowData.get("Expdate");
            var uom = rowData.get("UomDesc");
            var rp = rowData.get("Rp");
            var sp = rowData.get("Sp");
            var stkqty = rowData.get("StkQty");
            var recqty = rowData.get("RecQty");
            var manfid = rowData.get("ManfId");
            var manfdesc = rowData.get("Manf");
            if ((rp == null || rp <= 0 || rp == "") || (sp == null || sp <= 0 || sp == "")) {
                Msg.info("warning", "��������ȷ�۸�!");
                return;
            }
            if (parseFloat(rp) > parseFloat(sp)) {
                Msg.info("warning", "���۴����ۼ�!");
                return;
            }
            if (recqty == null || recqty.length <= 0) {
                Msg.info("warning", "�����������Ϊ��!");
                return;
            } else if (recqty <= 0) {
                Msg.info("warning", "�����������С�ڻ����0!");
                return;
            } else {
                if (recqty > stkqty) {
                    Msg.info("warning", "����������ܴ��ڿ����!");
                    return;
                }
            }
            var record = Ext.data.Record.create([{
                name: 'Inclb',
                type: 'string'
            }, {
                name: 'Incicode',
                type: 'string'
            }, {
                name: 'Incidesc',
                type: 'string'
            }, {
                name: 'Batno',
                type: 'string'
            }, {
                name: 'Expdate',
                type: 'string'
            }, {
                name: 'Uom',
                type: 'string'
            }, {
                name: 'Rp',
                type: 'string'
            }, {
                name: 'Sp',
                type: 'string'
            }, {
                name: 'StkQty',
                type: 'double'
            }, {
                name: 'RecQty',
                type: 'double'

            }, {
                name: 'ManfId',
                type: 'string'

            }, {
                name: 'Manf',
                type: 'String'

            }]);
            var NewRecord = new record({
                Inclb: inclb,
                Incicode: incicode,
                Incidesc: incidesc,
                Batno: batno,
                Expdate: expdate,
                Uom: uom,
                Rp: rp,
                Sp: sp,
                StkQty: stkqty,
                RecQty: recqty,
                ManfId: manfid,
                Manf: manfdesc
            });
            DetailStore.add(NewRecord);
            var row = BatGrid.getSelectionModel().getSelected();
            BatGrid.getStore().remove(row);
            BatGrid.getView().refresh();
        }

        function Query() {
            var phaloc = Ext.getCmp("PhaLoc").getValue();
            var incicode = Ext.getCmp("M_InciCode").getValue();
            var parref = phaloc + '^' + incicode
            if (incicode == "") {
                Msg.info("warning", "����������Ŀ!");
                return;
            }
            MasterStore.setBaseParam('Parref', parref);
            var Page = GridPagingToolbar.pageSize;
            MasterStore.load({
                params: {
                    start: 0,
                    limit: Page
                },
                callback: function (r, options, success) {
                    if (success == false) {
                        Ext.MessageBox.alert("��ѯ����", MasterStore.reader.jsonData.Error);
                    } else {
                        if (r.length > 0) {
                            BatGrid.getSelectionModel().selectFirstRow();
                            BatGrid.getSelectionModel().fireEvent('rowselect', this, 0);
                            BatGrid.getView().focusRow(0);
                        }
                    }
                }
            })
        }
        /**
         * ����ҩƷ���岢���ؽ��
         */
        function GetPhaOrderInfo(item, stktype) {
            if (item != null && item.length > 0) {
                GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "", getDrugList);
            }
        }
        /**
         * ���ط���
         */
        function getDrugList(record) {
            if (record == null || record == "") {
                return;
            }
            var inciDr = record.get("InciDr");
            var InciCode = record.get("InciCode");
            var InciDesc = record.get("InciDesc");
            Ext.getCmp("M_InciDesc").setValue(InciDesc);
            Ext.getCmp("M_InciCode").setValue(InciCode);
            Query();
        }
        var Manf = new Ext.ux.ComboBox({
            fieldLabel: '����',
            id: 'Manf',
            name: 'Manf',
            store: PhManufacturerStore,
            valueField: 'RowId',
            displayField: 'Description',
            emptyText: '����...',
            filterName: 'PHMNFName'
        });
        // ��λ
        var CTUom = new Ext.form.ComboBox({
            fieldLabel: '��λ',
            id: 'CTUom',
            name: 'CTUom',
            anchor: '90%',
            width: 120,
            store: ItmUomStore,
            valueField: 'RowId',
            displayField: 'Description',
            allowBlank: false,
            triggerAction: 'all',
            emptyText: '��λ...',
            selectOnFocus: true,
            forceSelection: true,
            minChars: 1,
            pageSize: 10,
            listWidth: 250,
            valueNotFoundText: ''
        });
        /**
         * ��λչ���¼�
         */
        CTUom.on('expand', function (combo) {
            var rowData = BatGrid.getSelectionModel().getSelected();
            var InciDr = rowData.get("Inci");
            ItmUomStore.removeAll();
            /*
            var url = DictUrl
            		+ 'drugutil.csp?actiontype=INCIUom&ItmRowid='
            		+ InciDr;
            CTUomStore.proxy = new Ext.data.HttpProxy({
            			url : url
            		}); */
            ItmUomStore.load({
                params: {
                    ItmRowid: InciDr
                }
            });
        });

        // ����·��
        var MasterUrl = DictUrl + 'virtualimpaction.csp?actiontype=QueryDetail';;
        // ͨ��AJAX��ʽ���ú�̨����
        var proxy = new Ext.data.HttpProxy({
            url: MasterUrl,
            method: "POST"
        });
        // ָ���в���
        var fields = ["Inclb", "Incicode", "Incidesc", "Batno", "Expdate", "Uom",
            "UomDesc", "Rp", "Sp", "StkQty", "RecQty", "Inci", "ManfId", "Manf"
        ];
        // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
        var reader = new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: "results",
            id: "IngrId",
            fields: fields
        });
        // ���ݼ�
        var MasterStore = new Ext.data.Store({
            proxy: proxy,
            reader: reader,
            baseParams: {
                ParamStr: ''
            }
        });

        var nm = new Ext.grid.RowNumberer();
        var MasterCm = new Ext.grid.ColumnModel([nm, {
            header: "rowid",
            dataIndex: 'Inclb',
            width: 60,
            align: 'right',
            sortable: true,
            hidden: true
        }, {
            header: "����",
            dataIndex: 'Incicode',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: '����',
            dataIndex: 'Incidesc',
            width: 220,
            align: 'left',
            sortable: true
        }, {
            header: '����',
            dataIndex: 'Batno',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: "Ч��",
            dataIndex: 'Expdate',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: "����",
            dataIndex: 'ManfId',
            id: 'ManfId',
            width: 200,
            align: 'left',
            sortable: true,
            editor: new Ext.grid.GridEditor(Manf),
            renderer: Ext.util.Format.comboRenderer2(Manf, "ManfId", "Manf")
        }, {
            header: "��λ",
            dataIndex: 'Uom',
            width: 90,
            align: 'left',
            sortable: true,
            renderer: Ext.util.Format.comboRenderer2(CTUom, "Uom", "UomDesc"),
            editor: new Ext.grid.GridEditor(CTUom)

        }, {
            header: "����",
            dataIndex: 'Rp',
            width: 70,
            align: 'right',
            sortable: true,
            editor: new Ext.ux.NumberField({
                selectOnFocus: true,
                allowBlank: false,
                formatType: 'FmtRP',
                allowNegative: false,
                listeners: {
                    specialkey: function (field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {

                        }
                    }
                }
            })
        }, {
            header: "�ۼ�",
            dataIndex: 'Sp',
            width: 60,
            align: 'right',
            sortable: true,
            editor: new Ext.ux.NumberField({
                selectOnFocus: true,
                allowBlank: false,
                formatType: 'FmtSP',
                allowNegative: false,
                listeners: {
                    specialkey: function (field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {

                        }
                    }
                }
            })
        }, {
            header: '���',
            dataIndex: 'StkQty',
            width: 80,
            align: 'right',
            sortable: true
        }, {
            header: "�����",
            dataIndex: 'RecQty',
            width: 110,
            align: 'right',
            sortable: true,
            editor: new Ext.form.NumberField({
                selectOnFocus: true,
                allowBlank: false,
                listeners: {
                    specialkey: function (field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {}
                    }
                }
            })

        }]);
        MasterCm.defaultSortable = true;
        var GridPagingToolbar = new Ext.PagingToolbar({
            store: MasterStore,
            pageSize: PageSize,
            displayInfo: true,
            displayMsg: '�� {0} ���� {1}��',
            emptyMsg: "û�м�¼"
        });

        var BatGrid = new Ext.grid.EditorGridPanel({
            region: 'center',
            title: '',
            height: 170,
            cm: MasterCm,
            //sm : new Ext.grid.CellSelectionModel({}),
            sm: new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            }),
            store: MasterStore,
            trackMouseOver: true,
            stripeRows: true,
            loadMask: true,
            bbar: [GridPagingToolbar],
            clicksToEdit: 1
        });
        //���˫���¼�
        BatGrid.on('rowdblclick', function (sm, rowIndex, r) {
            Add();
            GridPagingToolbar.updateInfo();
            BatGridPagingToolbar.updateInfo();
        })
        BatGrid.on('afteredit', function (e) {
            if (e.field == "RecQty") {
                var recQty = e.value;
                if (recQty == null || recQty.length <= 0) {
                    Msg.info("warning", "�����������Ϊ��!");
                    validFlag = 1;
                } else if (recQty <= 0) {
                    Msg.info("warning", "�����������С�ڻ����0!");
                    validFlag = 1;
                } else {
                    var curQty = e.record.get("StkQty");
                    if (recQty > curQty) {
                        Msg.info("warning", "����������ܴ��ڿ����!");
                        validFlag = 1;
                    }
                }
            }
        })
        // ��Ϣ�б�
        // ����·��
        var DetailUrl = DictUrl + 'virtualimpaction.csp?actiontype=Query';;
        // ͨ��AJAX��ʽ���ú�̨����
        var proxy = new Ext.data.HttpProxy({
            url: DetailUrl,
            method: "POST"
        });
        // ָ���в���
        var fields = ["Inclb", "Incicode", "Incidesc", "Batno", "Expdate", "Uom",
            "UomDesc", "Rp", "Sp", "StkQty", "RecQty", "Manf", "ManfId"
        ];
        // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
        var reader = new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: "results",
            id: "IngrId",
            fields: fields
        });
        // ���ݼ�
        var DetailStore = new Ext.data.Store({
            proxy: proxy,
            reader: reader,
            baseParams: {
                ParamStr: ''
            }
        });

        var nm = new Ext.grid.RowNumberer();
        var DetailCm = new Ext.grid.ColumnModel([nm, {
            header: "rowid",
            dataIndex: 'Inclb',
            width: 60,
            align: 'right',
            sortable: true,
            hidden: true
        }, {
            header: "����",
            dataIndex: 'Incicode',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: '����',
            dataIndex: 'Incidesc',
            width: 220,
            align: 'left',
            sortable: true
        }, {
            header: '����',
            dataIndex: 'Batno',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: "Ч��",
            dataIndex: 'Expdate',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: "����",
            dataIndex: 'Manf',
            width: 200,
            align: 'left',
            sortable: true
        }, {
            header: "����ID",
            dataIndex: 'ManfId',
            width: 80,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: "��λ",
            dataIndex: 'Uom',
            width: 90,
            align: 'left',
            sortable: true
        }, {
            header: "����",
            dataIndex: 'Rp',
            width: 70,
            align: 'right',
            sortable: true
        }, {
            header: "�ۼ�",
            dataIndex: 'Sp',
            width: 60,
            align: 'right',
            sortable: true
        }, {
            header: '���',
            dataIndex: 'StkQty',
            width: 80,
            align: 'right',
            sortable: true
        }, {
            header: "�����",
            dataIndex: 'RecQty',
            width: 110,
            align: 'right',
            sortable: true
        }]);
        DetailCm.defaultSortable = true;

        var BatGridPagingToolbar = new Ext.PagingToolbar({
            store: DetailStore,
            pageSize: PageSize,
            displayInfo: true,
            displayMsg: '�� {0} ���� {1}��',
            emptyMsg: "û�м�¼"
        });

        var DetailGrid = new Ext.grid.EditorGridPanel({
            region: 'center',
            title: '',
            height: 170,
            cm: DetailCm,
            sm: new Ext.grid.RowSelectionModel({
                singleSelect: true
            }),
            store: DetailStore,
            trackMouseOver: true,
            stripeRows: true,
            loadMask: true,
            bbar: [BatGridPagingToolbar]
        });

        var HisListTab = new Ext.form.FormPanel({
            labelWidth: 60,
            labelAlign: 'right',
            frame: true,
            title: '�������',
            autoScroll: false,
            autoHeight: true,
            //bodyStyle : 'padding:0px 0px 0px 0px;',					
            tbar: [SearchBT, '-', ClearBT, '-', AddBT, '-', SaveBT],
            items: [{
                xtype: 'fieldset',
                title: '�����Ϣ',
                layout: 'column',
                style: DHCSTFormStyle.FrmPaddingV,
                items: [{
                    columnWidth: 0.3,
                    xtype: 'fieldset',
                    defaults: {
                        width: 220,
                        border: false
                    },
                    border: false,
                    items: [PhaLoc, M_InciCode]
                }, {
                    columnWidth: 0.3,
                    xtype: 'fieldset',
                    defaults: {
                        width: 220,
                        border: false
                    },
                    border: false,
                    items: [Vendor, M_InciDesc]
                }, {
                    columnWidth: 0.2,
                    xtype: 'fieldset',
                    defaults: {
                        width: 100,
                        border: false
                    },
                    border: false,
                    items: [InGrNo, M_StkGrpType]
                }, {
                    columnWidth: 0.2,
                    xtype: 'fieldset',
                    defaults: {
                        width: 100,
                        border: false
                    },
                    border: false,
                    items: [IngrDate]
                }]
            }]
        });

        // ҳ�沼��
        var mainPanel = new Ext.Viewport({
            layout: 'border',
            items: [{
                region: 'north',
                height: DHCSTFormStyle.FrmHeight(2),
                layout: 'fit',
                items: HisListTab
            }, {
                region: 'center',
                title: '�������',
                layout: 'fit',
                items: BatGrid
            }, {
                region: 'south',
                split: true,
                height: 250,
                minSize: 200,
                maxSize: 350,
                collapsible: true,
                title: '���������ϸ�б�',
                layout: 'fit',
                items: DetailGrid
            }],
            renderTo: 'mainPanel'
        });
    }

})