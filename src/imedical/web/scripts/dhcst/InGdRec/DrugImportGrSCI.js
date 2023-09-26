/**
 * creator:    yunhaibao
 * createdate: 2017-04-19
 * description:��Ӧ���ӿ����(SCI���),��ȡ���ݽ���
 */
function DrugImportGrSCI(Fn) {
    Ext.Msg.show({
        title: 'ע��',
        msg: "��δ�����ӿ�,����ϵ����ʦ�˽���ϸ����!",
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
    
    // ��Ӧ��
    var SCIVendor = new Ext.ux.VendorComboBox({
        fieldLabel: '��Ӧ��',
        id: 'SCIVendor',
        name: 'SCIVendor',
        anchor: '90%',
        emptyText: '��Ӧ��...'
            //disabled : true
    });

    // ��ⲿ��
    var SCIRecLoc = new Ext.ux.LocComboBox({
        fieldLabel: '��ⲿ��',
        id: 'SCIRecLoc',
        name: 'SCIRecLoc',
        anchor: '90%',
        emptyText: '��ⲿ��...',
        groupId: session['LOGON.GROUPID']
            //disabled : true
    });

    // ��ʼ����
    var SCIStartDate = new Ext.ux.EditDate({
        fieldLabel: '��ʼ����',
        id: 'SCIStartDate',
        name: 'SCIStartDate',
        anchor: '90%',
        format: 'Y-m-d',
        width: 120,
        value: new Date().add(Date.DAY, -7)
    });

    // ��ֹ����
    var SCIEndDate = new Ext.ux.EditDate({
        fieldLabel: '��ֹ����',
        id: 'SCIEndDate',
        name: 'SCIEndDate',
        anchor: '90%',
        format: 'Y-m-d',
        width: 120,
        value: new Date()
    });

    // ҩƷ����
    var SCIStkGrpType = new Ext.ux.StkGrpComboBox({
        id: 'SCIStkGrpType',
        name: 'SCIStkGrpType',
        StkType: App_StkTypeCode, //��ʶ��������
        LocId: '', //gLocId,
        UserId: '', //gUserId,
        anchor: '80%'
            //disabled : true
    });

    // ���״̬
    var SCIImportStatStore = new Ext.data.SimpleStore({
        fields: ['RowId', 'Description'],
        data: [
            ['N', 'δ���'],
            ['Y', '�����']
        ]
    });
    
    var SCIImportStat = new Ext.form.ComboBox({
        fieldLabel: '���״̬',
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
        fieldLabel: '���е���',
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
            title: '��ѯ����',
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
        text: '��ȡ��ƽ̨����',
        tooltip: '��ȡ��ƽ̨����',
        iconCls: 'world_link',
        height: 30,
        width: 70,
        handler: function() {
            var SCISXNo = Ext.getCmp("SCISxNo").getValue();
            if (SCISXNo == "") {
                Msg.info("warning", "���е���Ϊ��!");
                return;
            }
            var ret = tkMakeServerCall("web.DHCST.SCI.Method.Interface", "GetRecData", SCISXNo, gUserId)
            if (ret == 0) {
                Msg.info("success", "��ȡ�ɹ�!");
            } else {
                var msginfo = ret.split("|@|")[1];
                Ext.Msg.show({
                    title: 'ע��',
                    msg: msginfo,
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.INFO
                });
            }
        }
    });
    
    // ������ť
    var SCISearchBT = new Ext.Toolbar.Button({
        text: '��ѯ',
        tooltip: '�����ѯ��Ӧ����Ҫ������Ϣ',
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
                    Ext.MessageBox.alert("��ѯ����",SCIMasterInfoStore.reader.jsonData.Error);  
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

    // ѡȡ��ť
    var SCICommitBT = new Ext.Toolbar.Button({
        text: '�ύ���',
        tooltip: '�������HIS��ⵥ',
        iconCls: 'page_goto',
        height: 30,
        width: 70,
        handler: function() {
            CommitImport();
        }
    });

    // ��հ�ť
    var SCIClearBT = new Ext.Toolbar.Button({
        text: '���',
        tooltip: '������',
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

    // �رհ�ť
    var SCICloseBT = new Ext.Toolbar.Button({
        text: '�ر�',
        tooltip: '�رս���',
        iconCls: 'page_delete',
        height: 30,
        width: 70,
        handler: function() {
            SCIClearData();
            window.close();
        }
    });

    // ����·��
    var MasterInfoUrl = DictUrl + 'hhimportaction.csp?actiontype=QueryHHImport'; //��ȡ����Ϣ
    
    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
        url: MasterInfoUrl,
        method: "POST"
    });

    // ָ���в���
    var fields = ["SCIOrderNo", "VendorDesc", "LocDesc", "SCIRecDate", "VendorId","LocId", "HHImport"];
    
    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "HHImport",
        fields: fields
    });
    
    // ���ݼ�
    var SCIMasterInfoStore = new Ext.data.Store({
        proxy: proxy,
        reader: reader
    });
    
    var nm = new Ext.grid.RowNumberer();
    
    var SCIMasterInfoCm = new Ext.grid.ColumnModel([nm, {
            header: "SCI����",
            dataIndex: 'SCIOrderNo',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: "��Ӧ��",
            dataIndex: 'VendorDesc',
            width: 125,
            align: 'left',
            sortable: true
        }, {
            header: "������",
            dataIndex: 'LocDesc',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: "��������",
            dataIndex: 'SCIRecDate',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: "��Ӧ��ID",
            dataIndex: 'VendorId',
            width: 20,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: "����ID",
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
        displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
        emptyMsg: "û�м�¼"
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
			                    Ext.MessageBox.alert("��ѯ����",SCIDetailInfoStore.reader.jsonData.Error);  
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

    // ����·��
    var DetailInfoUrl = DictUrl +
        'hhimportaction.csp?actiontype=QueryHHImportDetail'; //��ȡ��ϸ����
        
    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
        url: DetailInfoUrl,
        method: "POST"
    });
    
    // ָ���в���
    var fields = ["IncId", "BatchNo", "IngrUom", "ExpDate", "Margin", "RecQty",
        "IncCode", "IncDesc", "InvNo", "Manf", "Rp", "RpAmt",
        "Sp", "SpAmt", "InvDate", "Spec", "InvMonney", "HHImportItm", "ReqLocDesc"
    ];
    
    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "HHImportItm",
        fields: fields
    });
    
    // ���ݼ�
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
            header: 'ֱ�Ϳ���',
            dataIndex: 'ReqLocDesc',
            width: 120,
            align: 'left',
            sortable: true,
            renderer: BoldBlueRender,
            hidden:true
        },
        {
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
        }, {
            header: "��Ʊ���",
            dataIndex: 'InvMoney',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: "���",
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
        displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
        emptyMsg: "û�м�¼"
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

    // ˫���¼�
    SCIMasterInfoGrid.on('rowdblclick', function() {
        //returnData();
    });

    var window = new Ext.Window({
        title: '��Ӧ���ӿ����',
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
                title: '��Ӧ����ⵥ',
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
                title: '��Ӧ����ⵥ��ϸ',
                layout: 'fit',
                items: SCIDetailInfoGrid

            }
        ],
        tbar: [SCISearchBT, '-', SCICommitBT, '-', SCISynRecBT, '-', SCIClearBT, '-', SCICloseBT]
    });
    
    window.show();

    ///�ύ���
    function CommitImport() {
        var selectRows = SCIMasterInfoGrid.getSelectionModel().getSelections();
        if (selectRows.length == 0) {
            Ext.Msg.show({
                title: '����',
                msg: '��ѡ��Ӧ�������Ϣ��',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
        } else {
            var HHImport = selectRows[0].get("HHImport");
            var loadMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�...", removeMask: true });
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
                            title: '����',
                            msg: ret,
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    } else {
                        var ImportId = jsonData.info;
                        Msg.info("success", "�ύ���ɹ�!");
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
    
    // ��ʼ������
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