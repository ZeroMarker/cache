/**
 * ���ת���Ƶ�-��ѯ����
 */
function StockTransferSearch(dataStore, Fn) {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    //ȡ��������
    if (gParam == null || gParam.length < 1) {
        GetParam();
    }
    // ת�Ƶ���
    var InItNo2 = new Ext.form.TextField({
        fieldLabel: $g('ת�Ƶ���'),
        id: 'InItNo2',
        name: 'InItNo2',
        anchor: '90%',
        width: 120
    });

    // ������
    var RequestPhaLoc2 = new Ext.ux.LocComboBox({
        fieldLabel: $g('������'),
        id: 'RequestPhaLoc2',
        name: 'RequestPhaLoc2',
        anchor: '90%',
        width: 120,
        emptyText: $g('������...'),
        defaultLoc: {}
    });

    // ��ʼ����
    var StartDate2 = new Ext.ux.DateField({
        fieldLabel:$g( '��ʼ����'),
        id: 'StartDate2',
        name: 'StartDate2',
        anchor: '90%',
        width: 120,
        value: DefaultStDate()
    });

    // ��������
    var EndDate2 = new Ext.ux.DateField({
        fieldLabel: $g('��������'),
        id: 'EndDate2',
        name: 'EndDate3',
        anchor: '90%',
        width: 120,
        value: DefaultEdDate()
    });

    // ���󵥺�
    var InRqNo2 = new Ext.form.TextField({
        fieldLabel: $g('���󵥺�'),
        id: 'InRqNo2',
        name: 'InRqNo2',
        anchor: '90%',
        width: 120
    });

    var StatusStore = new Ext.data.SimpleStore({
        fields: ['RowId', 'Description'],
        data: [
            ['10', $g('δ���')],
            ['11', $g('�����')],
            ['20', $g('������˲�ͨ��')],
            ['30', $g('�ܾ�����')]
        ]
    });

    var Status = new Ext.form.ComboBox({
        fieldLabel: $g('����״̬'),
        id: 'Status',
        name: 'Status',
        anchor: '90%',
        width: 120,
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
    Ext.getCmp("Status").setValue(10);

    // ��ѯ��ť
    var searchBT = new Ext.Toolbar.Button({
        text:$g( '��ѯ'),
        tooltip: $g('�����ѯת����Ϣ'),
        iconCls: 'page_find',
        height: 30,
        width: 70,
        handler: function() {
            searchDurgData();
        }
    });

    function searchDurgData() {
        var SupplyPhaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
        if (SupplyPhaLoc == null || SupplyPhaLoc.length <= 0) {
            Msg.info("warning", $g("�������Ų���Ϊ��,��رմ���ѡ�񹩸����ţ�"));
            return;
        }
        var StartDate = Ext.getCmp("StartDate2").getValue();
        if ((StartDate != "") && (StartDate != null)) {
            StartDate = StartDate.format(App_StkDateFormat);
        }
        if ((StartDate == "") || (StartDate == null)) {
            Msg.info("error", $g("��ѡ����ʼ����!"));
            return;
        }
        var EndDate = Ext.getCmp("EndDate2").getValue();
        if ((EndDate != "") && (EndDate != null)) {
            EndDate = EndDate.format(App_StkDateFormat);
        }
        if ((EndDate == "") || (EndDate == null)) {
            Msg.info("error", $g("��ѡ���ֹ����!"));
            return;
        }
        var RequestPhaLoc = Ext.getCmp("RequestPhaLoc2").getValue();
        var InRqNo = Ext.getCmp("InRqNo2").getValue();
        var InItNo = Ext.getCmp("InItNo2").getValue();
        var Status = Ext.getCmp("Status").getValue();
        if (Status == null || Status == "") {
            Status = '10,11,20';
        }
        var ListParam = StartDate + '^' + EndDate + '^' + SupplyPhaLoc + '^' + RequestPhaLoc + '^^' + Status + '^' + InItNo + '^' + InRqNo;
        var Page = GridPagingToolbar.pageSize;
        ItMasterInfoStore.setBaseParam('ParamStr', ListParam);
        ItMasterInfoStore.removeAll();
        ItDetailInfoGrid.store.removeAll();
        ItMasterInfoStore.load({
            params: { start: 0, limit: Page },
            callback: function(r, options, success) {
                if (success == false) {
                    Msg.info("error", $g("��ѯ������鿴��־!"));
                } else {
                    if (r.length > 0) {
                        ItMasterInfoGrid.getSelectionModel().selectFirstRow();
                        ItMasterInfoGrid.getSelectionModel().fireEvent('rowselect', this, 0);
                        ItMasterInfoGrid.getView().focusRow(0);
                    }
                }
            }
        });
    }

    // ѡȡ��ť
    var returnBT = new Ext.Toolbar.Button({
        text: $g('ѡȡ'),
        tooltip: $g('���ѡȡ'),
        iconCls: 'page_goto',
        height: 30,
        width: 70,
        handler: function() {
            returnData();
        }
    });

function returnData() {
        var selectRows = ItMasterInfoGrid.getSelectionModel().getSelections();
        if (selectRows.length == 0) {
            Msg.info("warning", $g("��ѡ��Ҫ���ص�ת�Ƶ���Ϣ��"));
            Fn("");
            window.close();
        } else {
            var InitRowId = selectRows[0].get("init");
            //�ж��Ƿ�Ϊ�ܾ�����״̬�����������Ҫ���˿�治��ҩƷȻ�������µ�ת�Ƶ�
            var ret=tkMakeServerCall("web.DHCST.DHCINIsTrf","GetNotEnoughStorByINIT",InitRowId)
            if(ret=="") 
            {
	            Fn(InitRowId);
	            window.close();
            }
            else
            {
	            //ת���з���ֱ�Ӻ�̨��\nû����
	            var arrRet=ret.split("##")
	            var len=arrRet.length
	            var NewRetStr=""
	            for(i=0;i<len;i++)
	            {
		            if (NewRetStr=="")  NewRetStr=arrRet[i]
		            else NewRetStr=NewRetStr+"<br>"+"<font color='red'>"+arrRet[i]+"</font>"
	            }
	            //alert(NewRetStr)
	             Ext.MessageBox.show({
						title : $g('��ʾ'),
						msg : NewRetStr,
						buttons : Ext.MessageBox.YESNO,
						fn : GetNewInti,
						icon : Ext.MessageBox.QUESTION
					});
            }
        }
        //window.close();
    }
    
    function GetNewInti(btn)
    {
	    if (btn == "yes") {
			var selectRows = ItMasterInfoGrid.getSelectionModel().getSelections();
            var InitRowId = selectRows[0].get("init");
            var NewInti=tkMakeServerCall("web.DHCST.DHCINIsTrf","TransByRefuseINIT",InitRowId,session['LOGON.USERID'])
            if(NewInti.split("^")[0]<0) 
            {
	            Msg.info("error", $g("������תʧ��:")+NewInti);
	            return;
            }
            else
            {
	            Fn(NewInti);
	            window.close();
            }
		}
		
    } 
    
	  
    // ��հ�ť
    var clearBT = new Ext.Toolbar.Button({
        text: $g('����'),
        tooltip: $g('�������'),
        iconCls: 'page_clearscreen',
        height: 30,
        width: 70,
        handler: function() {
            clearData();
        }
    });

    function clearData() {
        Ext.getCmp("RequestPhaLoc2").setValue("");
        //Ext.getCmp("SupplyPhaLoc2").setValue("");
        Ext.getCmp("StartDate2").setValue(DefaultStDate());
        Ext.getCmp("EndDate2").setValue(DefaultEdDate());
        Ext.getCmp("InItNo2").setValue("");
        Ext.getCmp("InRqNo2").setValue("");
        Ext.getCmp("Status").setValue("10");
        ItMasterInfoGrid.store.removeAll();
        ItDetailInfoGrid.store.removeAll();
    }

    // 3�رհ�ť
    var closeBT = new Ext.Toolbar.Button({
        text: $g('�ر�'),
        tooltip: $g('�رս���'),
        iconCls: 'page_close',
        height: 30,
        width: 70,
        handler: function() {
            window.close();
        }
    });
    // ɾ����ť
    var deleteBT = new Ext.Toolbar.Button({
        id: "deleteBT",
        text: $g('ɾ��'),
        tooltip: $g('���ɾ��'),
        width: 70,
        height: 30,
        iconCls: 'page_delete',
        handler: function() {
            Ext.MessageBox.show({
                title: $g('��ʾ'),
                msg: $g('�Ƿ�ȷ��ɾ������ת�Ƶ�?'),
                buttons: Ext.MessageBox.YESNO,
                fn: DeleteHandler,
                icon: Ext.MessageBox.QUESTION
            });
        }
    });

    function DeleteHandler(btn) {
        if (btn == "yes") {
            var selectRows = ItMasterInfoGrid.getSelectionModel().getSelections();
            if (selectRows.length == 0) {
                Msg.info("warning", $g("����ѡ����Ҫɾ����ת�Ƶ�!"));
                return;
            }
            var initId = selectRows[0].get("init");
            var completeFlag = selectRows[0].get("comp");
            if (completeFlag == "Y") {
                Msg.info("warning", $g("ֻ�б���״̬��ת�Ƶ�����ɾ��������ת�Ƶ�״̬!"));
                return;
            }
            var url = DictUrl +
                "dhcinistrfaction.csp?actiontype=Delete&Rowid=" +
                initId;
            Ext.Ajax.request({
                url: url,
                method: 'POST',
                waitMsg: $g('ɾ��������...'),
                success: function(result, request) {
                    var jsonData = Ext.util.JSON
                        .decode(result.responseText);
                    if (jsonData.success == 'true') {
                        // ɾ������
                        Msg.info("success", $g("ת�Ƶ�ɾ���ɹ�!"));
                        searchDurgData();
                    } else {
                        Msg.info("error", $g("ת�Ƶ�ɾ��ʧ��:") + jsonData.info);
                    }
                },
                scope: this
            });
        }
    }
    // ����·��
    var MasterInfoUrl = DictUrl + 'dhcinistrfaction.csp?actiontype=Query';

    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
        url: MasterInfoUrl,
        method: "POST"
    });

    // ָ���в���
    var fields = ["init", "initNo", "reqNo", "toLocDesc", "frLocDesc", "dd", "tt", "comp", "userName", "status", "StatusCode"];

    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "init",
        fields: fields
    });

    // ���ݼ�
    var ItMasterInfoStore = new Ext.data.Store({
        proxy: proxy,
        reader: reader
    });

    var nm = new Ext.grid.RowNumberer();
    var ItMasterInfoCm = new Ext.grid.ColumnModel([nm, {
        header: "RowId",
        dataIndex: 'init',
        width: 100,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: $g("ת�Ƶ���"),
        dataIndex: 'initNo',
        width: 150,
        align: 'left',
        sortable: true
    }, {
        header: $g("���󵥺�"),
        dataIndex: 'reqNo',
        width: 150,
        align: 'left',
        sortable: true
    }, {
        header: $g("������"),
        dataIndex: 'toLocDesc',
        width: 200,
        align: 'left',
        sortable: true
    }, {
        header: $g("��������"),
        dataIndex: 'frLocDesc',
        width: 200,
        align: 'left',
        sortable: true
    }, {
        header: $g('���״̬'),
        dataIndex: 'comp',
        width: 90,
        align: 'center',
        sortable: true
    }, {
        header: $g('����״̬'),
        dataIndex: 'StatusCode',
        width: 90,
        align: 'center',
        sortable: true
    }, {
        header: $g('����'),
        dataIndex: 'dd',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g("ʱ��"),
        dataIndex: 'tt',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g('�Ƶ���'),
        dataIndex: 'userName',
        width: 100,
        align: 'left',
        sortable: true
    }]);
    ItMasterInfoCm.defaultSortable = true;

    var GridPagingToolbar = new Ext.PagingToolbar({
        store: ItMasterInfoStore,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: $g('�� {0} ���� {1}�� ��һ�� {2} ��'),
        emptyMsg: $g("û�м�¼")
    });

    var ItMasterInfoGrid = new Ext.grid.GridPanel({
        id: 'ItMasterInfoGrid',
        cm: ItMasterInfoCm,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        store: ItMasterInfoStore,
        trackMouseOver: true,
        stripeRows: true,
        loadMask: true,
        bbar: GridPagingToolbar
    });

    // ��ӱ�񵥻����¼�
    ItMasterInfoGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
        var InIt = ItMasterInfoStore.getAt(rowIndex).get("init");
        ItDetailInfoStore.setBaseParam('Parref', InIt);
        ItDetailInfoStore.removeAll();
        ItDetailInfoStore.load({ params: { start: 0, limit: GridDetailPagingToolbar.pageSize, sort: 'Rowid', dir: 'Desc' } });
    });

    // ����·��
    var DetailInfoUrl = DictUrl +
        'dhcinistrfaction.csp?actiontype=QueryDetail';

    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
        url: DetailInfoUrl,
        method: "POST"
    });

    // ָ���в���
    var fields = ["initi", "inrqi", "inci", "inciCode",
        "inciDesc", "inclb", "batexp", "manf", "manfName",
        "qty", "uom", "sp", "status", "remark",
        "reqQty", "inclbQty", "reqLocStkQty", "stkbin",
        "pp", "spec", "gene", "formDesc", "newSp",
        "spAmt", "rp", "rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty", "TrUomDesc"
    ];

    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "initi",
        fields: fields
    });

    // ���ݼ�
    var ItDetailInfoStore = new Ext.data.Store({
        proxy: proxy,
        reader: reader
    });

    var nm = new Ext.grid.RowNumberer();
    var ItDetailInfoCm = new Ext.grid.ColumnModel([nm, {
        header: $g("ת��ϸ��RowId"),
        dataIndex: 'initi',
        width: 100,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: $g('ҩƷ����'),
        dataIndex: 'inciCode',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g('ҩƷ����'),
        dataIndex: 'inciDesc',
        width: 200,
        align: 'left',
        sortable: true
    }, {
        header: $g("����~Ч��"),
        dataIndex: 'batexp',
        width: 200,
        align: 'left',
        sortable: true
    }, {
        header: $g("������ҵ"),
        dataIndex: 'manfName',
        width: 180,
        align: 'left'
    }, {
        header: $g("ת������"),
        dataIndex: 'qty',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: $g("ת�Ƶ�λ"),
        dataIndex: 'TrUomDesc',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g("����"),
        dataIndex: 'rp',
        width: 60,
        align: 'right',

        sortable: true
    }, {
        header: $g("�ۼ�"),
        dataIndex: 'sp',
        width: 60,
        align: 'right',

        sortable: true
    }, {
        header: $g("��������"),
        dataIndex: 'reqQty',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: $g("��λ��"),
        dataIndex: 'stkbin',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g("�����ۼ�"),
        dataIndex: 'newSp',
        width: 100,
        align: 'right',

        sortable: true
    }, {
        header: $g("���"),
        dataIndex: 'spec',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g("����ͨ����"),
        dataIndex: 'gene',
        width: 120,
        align: 'left',
        sortable: true
    }, {
        header: $g("����"),
        dataIndex: 'formDesc',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g("�ۼ۽��"),
        dataIndex: 'spAmt',
        width: 100,
        align: 'right',

        sortable: true
    }]);
    ItDetailInfoCm.defaultSortable = true;

    var GridDetailPagingToolbar = new Ext.PagingToolbar({
        store: ItDetailInfoStore,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: $g('�� {0} ���� {1}�� ��һ�� {2} ��'),
        emptyMsg: $g("û�м�¼")
    });

    var ItDetailInfoGrid = new Ext.grid.GridPanel({
        title: '',
        height: 170,
        cm: ItDetailInfoCm,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        store: ItDetailInfoStore,
        trackMouseOver: true,
        stripeRows: true,
        bbar: GridDetailPagingToolbar,
        loadMask: true
    });

    // ˫���¼�
    ItMasterInfoGrid.on('rowdblclick', function() {
        returnData();
    });

    var InfoForm3 = new Ext.form.FormPanel({
        height: DHCSTFormStyle.FrmHeight(1),
        region: "north",
        frame: true,
        labelAlign: 'right',
        labelWidth: 60,
        id: "InfoForm3",
        tbar: [searchBT, '-', returnBT, '-', clearBT, '-', deleteBT, '-', closeBT],
        items: [{
            xtype: 'fieldset',
            title: $g('��ѯ����'),
            style: DHCSTFormStyle.FrmPaddingV,
            defaults: { border: false },
            layout: 'column',
            items: [{
                columnWidth: .33,
                xtype: 'fieldset',
                items: [StartDate2, EndDate2]
            }, {
                columnWidth: .33,
                xtype: 'fieldset',
                items: [RequestPhaLoc2, Status]
            }, {
                columnWidth: .33,
                xtype: 'fieldset',
                items: [InItNo2, InRqNo2]
            }]
        }]
    });

    var window = new Ext.Window({
        title: $g('ת�Ƶ���ѯ'),
        width: document.body.clientWidth * 0.9,
        height: document.body.clientHeight * 0.9,
        minWidth: document.body.clientWidth * 0.5,
        minHeight: document.body.clientHeight * 0.5,
        layout: 'border',
        modal: true,
        items: [
            InfoForm3, {
                region: 'center',
                title: $g('���ⵥ'),
                collapsible: true,
                split: true,
                minSize: 175,
                maxSize: 400,
                layout: 'fit',
                items: ItMasterInfoGrid

            }, {
                region: 'south',
                title: $g('���ⵥ��ϸ'),
                height: document.body.clientHeight * 0.9 * 0.4,
                layout: 'fit',
                items: ItDetailInfoGrid

            }
        ]
    });
    window.show();
    searchDurgData();
}