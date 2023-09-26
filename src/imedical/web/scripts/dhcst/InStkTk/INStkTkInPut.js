// /����: ʵ�̣�¼�뷽ʽ���������������ݰ�Ʒ�����ʵ������
// /����: ʵ�̣�¼�뷽ʽ���������������ݰ�Ʒ�����ʵ������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.09.07
// /�����ߣ�hulihua 2015-09-21 ���Ӵ�С��λ��ʽ¼�롢�����á�Excel����
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gUserId = session['LOGON.USERID'];
    var gLocId = session['LOGON.CTLOCID'];
    var gStrDetailParams = '';
    var StkLocId = '';
    var inciRowid = '';
    var impWindow = '';
    var url = DictUrl + 'instktkaction.csp';
    var LocManaGrp = new Ext.form.ComboBox({
        fieldLabel: '������',
        id: 'LocManaGrp',
        name: 'LocManaGrp',
        anchor: '90%',
        store: LocManGrpStore,
        valueField: 'RowId',
        displayField: 'Description',
        allowBlank: true,
        triggerAction: 'all',
        emptyText: '������...',
        selectOnFocus: true,
        forceSelection: true,
        minChars: 1,
        pageSize: 20,
        listWidth: 250,
        valueNotFoundText: '',
        listeners: {
            'beforequery': function(combox) {
                this.store.removeAll();
                if (StkLocId == "") { LocManGrpStore.setBaseParam('locId', InstkLocRowid); } else { LocManGrpStore.setBaseParam('locId', StkLocId); }
                LocManGrpStore.load({ params: { start: 0, limit: 20 } });
            }
        }
    });

    var StkGrpType = new Ext.ux.StkGrpComboBox({
        id: 'StkGrpType',
        name: 'StkGrpType',
        StkType: App_StkTypeCode, //��ʶ��������
        UserId: gUserId,
        LocId: InstkLocRowid,
        anchor: '90%'
    });

    StkGrpType.on('change', function() {
        Ext.getCmp("DHCStkCatGroup").setValue("");
    });

    var DHCStkCatGroup = new Ext.ux.ComboBox({
        fieldLabel: '������',
        id: 'DHCStkCatGroup',
        name: 'DHCStkCatGroup',
        store: StkCatStore,
        valueField: 'RowId',
        displayField: 'Description',
        params: { StkGrpId: 'StkGrpType' }
    });


    var StkBin = new Ext.ux.ComboBox({
        fieldLabel: '��λ',
        id: 'StkBin',
        name: 'StkBin',
        anchor: '90%',
        width: 140,
        store: LocStkBinStore,
        valueField: 'RowId',
        displayField: 'Description',
        allowBlank: true,
        triggerAction: 'all',
        selectOnFocus: true,
        forceSelection: true,
        minChars: 1,
        pageSize: 20,
        listWidth: 250,
        valueNotFoundText: '',
        enableKeyEvents: true,
        listeners: {
            'beforequery': function(e) {
                this.store.removeAll();
                if (StkLocId == "") { LocStkBinStore.setBaseParam('LocId', InstkLocRowid); } else { LocStkBinStore.setBaseParam('LocId', StkLocId); }
                LocStkBinStore.setBaseParam('Desc', Ext.getCmp('StkBin').getRawValue());
                LocStkBinStore.load({ params: { start: 0, limit: 20 } });
            }
        }
    });

    var InstNo = new Ext.form.TextField({
        id: 'InstNo',
        name: 'InstNo',
        fieldLabel: '�̵㵥��',
        width: 140,
        anchor: '90%',
        disabled: true
    });

    var InputWin = new Ext.form.ComboBox({
        fieldLabel: 'ʵ�̴���',
        id: 'InputWin',
        name: 'InputWin',
        anchor: '90%',
        store: INStkTkWindowStore,
        valueField: 'RowId',
        displayField: 'Description',
        disabled: true,
        allowBlank: true,
        triggerAction: 'all',
        emptyText: 'ʵ�̴���...',
        listeners: {
            'beforequery': function(e) {
                this.store.removeAll();
                this.store.setBaseParam('LocId', InstkLocRowid);
                this.store.load({ params: { start: 0, limit: 99 } });
            }
        }
    });
    INStkTkWindowStore.load({
        params: { start: 0, limit: 99, 'LocId': InstkLocRowid },
        callback: function() {
            Ext.getCmp("InputWin").setValue(gInputWin);
        }
    });

    // ��ѯ��ť
    var SearchBT = new Ext.Toolbar.Button({
        text: '��ѯ',
        tooltip: '�����ѯ',
        iconCls: 'page_find',
        width: 70,
        height: 30,
        handler: function() {
            QueryDetail();
        }
    });

    // ��հ�ť
    var RefreshBT = new Ext.Toolbar.Button({
        text: '����',
        tooltip: '�������',
        iconCls: 'page_clearscreen',
        width: 70,
        height: 30,
        handler: function() {
            clearData();
        }
    });

    /**
     * ��շ���
     */
    function clearData() {
        inciRowid = "";
        Ext.getCmp("DHCStkCatGroup").setValue('');
        Ext.getCmp("StkBin").setValue('');
        Ext.getCmp("StkGrpType").setValue('');
        Ext.getCmp("LocManaGrp").setValue('');
        Select();
        InstDetailGrid.store.removeAll();
        InstDetailGrid.getView().refresh();
    }

    /**
     * ���ط���
     */
    function getImportFlag(Flag) {
        if (Flag == null || Flag == "") {
            return;
        }
        QueryDetail();
    }

    var ImpInstDataBT = new Ext.Toolbar.Button({
        text: 'Excel����',
        tooltip: '��ȡExcel�ļ�',
        iconCls: 'page_excel',
        width: 70,
        height: 30,
        handler: function() {
            var InputWin = Ext.getCmp('InputWin').getValue();
            if (InputWin == '' || InputWin == null) {
                Msg.info('warning', 'Excel�����ʱ�����ѡ��ʵ�̴���!');
                return;
            }
            if (impWindow) {
                impWindow.ShowOpen();
            } else {
                impWindow = new ActiveXObject("MSComDlg.CommonDialog");
                impWindow.Filter = "All Files (*.*)|*.*|xls Files(*.xls)|*.xls|xlsx Files(*.xlsx)|*.xlsx";
                impWindow.FilterIndex = 3;

                // ��������MaxFileSize. �������
                impWindow.MaxFileSize = 32767;
                // ��ʾ�Ի���
                impWindow.ShowOpen();
            }

            var fileName = impWindow.FileName;
            if (fileName == '') {
                Msg.info('warning', '��ѡ��Excel�ļ�!');
                return;
            }
            var InstNo = Ext.getCmp("InstNo").getValue();
            var pid = tkMakeServerCall("web.DHCST.InStkTkInput", "NewImpGlobal");
            previewInstData(fileName, InstNo, pid, getImportFlag, InputWin);
            QueryDetail();
        }
    })

    var HelpBT = new Ext.Toolbar.Button({
	    id: 'HelpBtn',
        text: '����ģ��˵��',
        width: 70,
        height: 30,
        iconCls: 'page_key',
        renderTo: Ext.get("tipdiv")

    });

    var SaveBT = new Ext.Toolbar.Button({
        text: '����',
        tooltip: '�������',
        iconCls: 'page_save',
        width: 70,
        height: 30,
        handler: function() {
            save();
        }
    });

    var M_InciDesc = new Ext.form.TextField({
        fieldLabel: 'ҩƷ����',
        id: 'M_InciDesc',
        name: 'M_InciDesc',
        emptyText: 'ҩƷ����...',
        width: 300,
        listeners: {
            specialkey: function(field, e) {
                if (e.getKey() == Ext.EventObject.ENTER) {
                    if (document.getElementById('bodyLookupComponetId').innerHTML != "") {
                        if (document.getElementById('bodyLookupComponetId').style.display != "none") {
                            InciDescLookupGrid.doSearch()
                            e.stopEvent();
                            e.preventDefault();
                            e.stopPropagation();
                            return false;
                        }
                    }
                    var stktype = Ext.getCmp("StkGrpType").getValue();
                    GetPhaOrderLookUp(field.getValue(), stktype, App_StkTypeCode, "", "N", "0", "", getDrugListF);
                }
            }
        }
    })

    function getDrugListF(record) {
        if (record == null || record == "") {
            return;
        }
        var inciDr = record.get("InciDr");
        var InciCode = record.get("InciCode");
        var InciDesc = record.get("InciDesc");
        Ext.getCmp("M_InciDesc").setValue(InciDesc);
        inciRowid = inciDr;
        QueryDetail();
        M_InciDesc.focus(true, true);
    }

    //����ʵ������
    function save() {
        if (InstDetailGrid.activeEditor != null) {
            InstDetailGrid.activeEditor.completeEdit();
        }
        var rowCount = InstDetailStore.getCount();
        var ListDetail = '';
        var InputWin = Ext.getCmp("InputWin").getValue();
        for (var i = 0; i < rowCount; i++) {
            var rowData = InstDetailStore.getAt(i);
            //�������޸Ĺ�������
            if (rowData.dirty || rowData.data.newRecord) {
                var Parref = rowData.get('parref');
                var Rowid = rowData.get('rowid');
                var UserId = session['LOGON.USERID'];
                var CountQty = rowData.get('countQty');
                if (CountQty == "") {
                    CountQty = 0;
                }
                var IncId = rowData.get('inci');
                var PCountQty = rowData.get('pcountQty');
                if (PCountQty == "") {
                    PCountQty = 0;
                }
                var BCountQty = rowData.get('bcountQty'); //add by myq 20141027 ʵ����С
                if (BCountQty == "") {
                    BCountQty = 0;
                }
                var incidesc = rowData.get('desc');
                 if (PCountQty < 0 || BCountQty < 0) {
	                    Msg.info('warning', incidesc+' ¼���ʵ����������С����!');
	                    return;
	                }
                
                var Detail = Rowid + '^' + Parref + '^' + IncId + '^' + PCountQty + '^' + UserId + '^' + InputWin + '^' + BCountQty;
                if (ListDetail == '') {
                    ListDetail = Detail;
                } else {
                    ListDetail = ListDetail + xRowDelim() + Detail;
                }
            }
        }
        if (ListDetail == '') {
            Msg.info('Warning', 'û����Ҫ���������!');
            return;
        }
        var mask = ShowLoadMask(Ext.getBody(), "���������Ժ�...");
        Ext.Ajax.request({
            url: url,
            params: { actiontype: 'SaveInput', Params: ListDetail },
            method: 'post',
            waitMsg: '������...',
            success: function(response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    Msg.info('success', '����ɹ�!');
                    InstDetailStore.reload();
                    //QueryDetail();
                } else {
                    var ret = jsonData.info;
                    if (ret == '-1') {
                        Msg.info('warning', 'û����Ҫ���������!');
                    } else if (ret == '-2') {
                        Msg.info('error', '����ʧ��!');
                    } else {
                        Msg.info('error', '�������ݱ���ʧ��:' + ret);
                    }
                }
            }
        });
    }

    //�����������ݲ���ʵ���б�
    function create(inst) {
        if (inst == null || inst == '') {
            Msg.info('warning', '��ѡ���̵㵥');
            return;
        }
        var UserId = session['LOGON.USERID'];
        var mask = ShowLoadMask(Ext.getBody(), "���������Ժ�...");
        Ext.Ajax.request({
            url: url,
            params: { actiontype: 'CreateStkTkInput', Inst: inst, UserId: UserId, InputWin: gInputWin },
            waitMsg: '������...',
            success: function(response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    QueryDetail(); //����ʵ���б�
                } else {
                    var ret = jsonData.info;
                    Msg.info("error", "��ȡʵ���б�ʧ�ܣ�" + ret);
                }
            }
        });
    }

    //�����̵㵥��ϸ��Ϣ
    function QueryDetail() {

        //��ѯ�̵㵥��ϸ
        var StkGrpId = Ext.getCmp('StkGrpType').getValue();
        var StkCatId = Ext.getCmp('DHCStkCatGroup').getValue();
        var StkBinId = Ext.getCmp('StkBin').getValue();
        var ManaGrpId = Ext.getCmp('LocManaGrp').getValue();
        var InputWin = Ext.getCmp('InputWin').getValue();
        var size = StatuTabPagingToolbar.pageSize;

        gStrDetailParams = gRowid + '^' + ManaGrpId + '^' + StkGrpId + '^' + StkCatId + '^' + StkBinId + '^' + InputWin + '^' + inciRowid;
        InstDetailStore.setBaseParam('sort', 'stkbin');
        InstDetailStore.setBaseParam('dir', 'ASC');
        InstDetailStore.setBaseParam('Params', gStrDetailParams)
        InstDetailStore.load({
            params: { start: 0, limit: size },
            callback: function(r, options, success) {
                if (success == false) {
                    Msg.info("error", "��ѯ����,��鿴��־!");
                }
            }
        });
        inciRowid = '';
    }
    //��ѯ�̵㵥������Ϣ
    function Select() {
        if (gRowid == null || gRowid == "") {
            return;
        }

        Ext.Ajax.request({
            url: url,
            params: { actiontype: 'Select', Rowid: gRowid },
            method: 'post',
            success: function(response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                if (jsonData.success == 'true') {
                    var info = jsonData.info;
                    if (info != "") {
                        var detail = info.split("^");
                        var InstNo = detail[0];
                        StkLocId = detail[5]; //add wyx �����̵���� 2013-04-30						
                        var StkGrpId = detail[17];
                        var StkCatId = detail[18];
                        var StkCatDesc = detail[19];
                        Ext.getCmp("InstNo").setValue(InstNo);
                        Ext.getCmp("StkGrpType").setValue(StkGrpId);
                        addComboData(StkCatStore, StkCatId, StkCatDesc);
                        Ext.getCmp("DHCStkCatGroup").setValue(StkCatId);
                    }
                }
            }

        });
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
        header: "parref",
        dataIndex: 'parref',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: "inci",
        dataIndex: 'inci',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: '��λ',
        dataIndex: 'stkbin',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: '����',
        dataIndex: 'code',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: "����",
        dataIndex: 'desc',
        width: 200,
        align: 'left',
        sortable: true
    }, {
        header: "���",
        dataIndex: 'spec',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: "��������",
        dataIndex: 'freQty',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: "��λ",
        dataIndex: 'uomDesc',
        width: 60,
        align: 'left',
        sortable: true
    }, {
        header: 'ʵ������(��)',
        dataIndex: 'pcountQty',
        width: 100,
        align: 'right',
        sortable: true,
        editor: new Ext.form.NumberField({
            selectOnFocus: true,
            allowNegative: false,
            listeners: {
                'specialkey': function(field, e) {
                    var keyCode = e.getKey();
                    var col = GetColIndex(InstDetailGrid, 'bcountQty');
                    var cell = InstDetailGrid.getSelectionModel().getSelectedCell();
                    var rowCount = InstDetailGrid.getStore().getCount();
                    if (keyCode == Ext.EventObject.ENTER) {
                        var qty = field.getValue();
                        if (qty < 0) {
                            Msg.info('warning', 'ʵ����������С����!');
                            return;
                        }
                        var row = cell[0];
                        if (row < rowCount) {
                            InstDetailGrid.startEditing(row, col);
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
                        var row = cell[0];
                        if (row < rowCount) {
                            InstDetailGrid.getSelectionModel().select(row, col);
                            InstDetailGrid.startEditing(row, col);
                        }
                    }
                }
            }
        })
    }, {
        header: '��ⵥλ',
        dataIndex: 'puomdesc',
        width: 60,
        align: 'left',
        sortable: true
    }, {
        header: 'ʵ������(С)',
        dataIndex: 'bcountQty',
        width: 100,
        align: 'right',
        sortable: true,
        editor: new Ext.form.NumberField({
            selectOnFocus: true,
            allowNegative: false,
            listeners: {
                'specialkey': function(field, e) {
                    var keyCode = e.getKey();
                    var col = GetColIndex(InstDetailGrid, 'pcountQty');
                    var cell = InstDetailGrid.getSelectionModel().getSelectedCell();
                    var rowCount = InstDetailGrid.getStore().getCount();
                    if (keyCode == Ext.EventObject.ENTER) {
                        var qty = field.getValue();
                        if (qty < 0) {
                            Msg.info('warning', 'ʵ����������С����!');
                            return;
                        }
                        var row = cell[0] + 1;
                        if (row < rowCount) {
                            InstDetailGrid.startEditing(row, col);
                        }
                    }
                    if (keyCode == Ext.EventObject.UP) {
                        var row = cell[0];
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
        header: '������λ',
        dataIndex: 'buomdesc',
        width: 60,
        align: 'left',
        sortable: true
    }, {
        header: 'ʵ��������(��)',
        dataIndex: 'countQty',
        width: 110,
        align: 'right',
        sortable: true
    }, {
        header: 'ʵ������',
        dataIndex: 'countDate',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: "ʵ��ʱ��",
        dataIndex: 'countTime',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: 'ʵ����',
        dataIndex: 'userName',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: 'ת��ϵ��',
        dataIndex: 'fac',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: 'true'
    }]);

    var GridColSetBT = new Ext.Toolbar.Button({
        text: '������',
        tooltip: '������',
        iconCls: 'page_gear',
        handler: function() {
            GridColSet(InstDetailGrid, "DHCSTINSTKTKINPUT");
        }
    });

    InstDetailGridCm.defaultSortable = true;

    // ���ݼ�
    var InstDetailStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: url + "?actiontype=QueryInput",
            method: "POST"
        }),
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: "results",
            id: "rowid",
            fields: ["rowid", "parref", "inci", "code", "desc", "spec",
                "uom", "uomDesc", "freQty", "countQty", "pcountQty", "puomdesc",
                "bcountQty", "buomdesc", "countDate", "countTime", "userName", "stkbin", "fac"
            ]
        }),
        remoteSort: true,
        pruneModifiedRecords: true
    });

    var StatuTabPagingToolbar = new Ext.PagingToolbar({
        store: InstDetailStore,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
        emptyMsg: "No results to display",
        prevText: "��һҳ",
        nextText: "��һҳ",
        refreshText: "ˢ��",
        lastText: "���ҳ",
        firstText: "��һҳ",
        beforePageText: "��ǰҳ",
        afterPageText: "��{0}ҳ",
        emptyMsg: "û������"
    });

    StatuTabPagingToolbar.addListener('beforechange', function(toolbar, params) {
        if (InstDetailGrid.activeEditor != null) {
            InstDetailGrid.activeEditor.completeEdit();
        }
        var records = InstDetailStore.getModifiedRecords();
        if (records.length > 0) {
            Ext.Msg.show({
                title: '��ʾ',
                msg: '��ҳ���ݷ����ı䣬�Ƿ���Ҫ���棿',
                buttons: Ext.Msg.YESNOCANCEL,
                fn: function(btn, text, opt) {
                    if (btn == 'yes') {
                        save();
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

    ///startRow:��ǰҳ�п�ʼ�е������м�¼�е�˳��
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
        id: 'InstDetailGrid',
        region: 'center',
        cm: InstDetailGridCm,
        store: InstDetailStore,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.CellSelectionModel(), //wyx modify 2013-11-18��Ϊ��ģʽ	
        loadMask: true,
        bbar: StatuTabPagingToolbar,
        tbar: [M_InciDesc],
        clicksToEdit: 1,
        viewConfig: {
            getRowClass: function(record, rowIndex, rowParams, store) {
                var countqty = record.get("countQty");
                var freezeqty = record.get("freQty");
                var incidesc = record.get("desc");
                var diffQty = accAdd(countqty, -freezeqty)
                var colorflag = "";
                if (incidesc == "�ϼ�") { return; }
                if ((countqty == "") || (countqty == null)) {
                    return; //δ�����ɫ
                }
                if (Number(diffQty) > 0) { colorflag = "1"; } else if (Number(diffQty) < 0) { colorflag = "-1"; }
                switch (colorflag) {
                    case "1":
                        return 'classAquamarine';
                        break;
                    case "-1":
                        return 'classSalmon';
                        break;
                }
            }
        }

    });
    ///yunhaibao,20151123,���޸ĺ��������Ϣ,��̨����
    InstDetailGrid.on('afteredit', function(e) {
        if ((e.field == "bcountQty") || (e.field == "pcountQty")) {
            var bqty = e.record.get("bcountQty")
            if (bqty == "") { bqty = 0 }
            var pqty = e.record.get("pcountQty")
            if (pqty == "") { pqty = 0 }
            var bpfac = e.record.get("fac")
            var newbqty = accMul(pqty, bpfac)
            var newqty = accAdd(newbqty, bqty)
            e.record.set("countQty", newqty);
        }
    })



    var form = new Ext.form.FormPanel({
        //labelwidth : 30,
        labelWidth: 60,
        width: 400,
        labelAlign: 'right',
        title: 'ʵ��:¼�뷽ʽ��(��Ʒ��¼��)',
        frame: true,
        tbar: [SearchBT, '-', RefreshBT, '-', SaveBT],
        items: [{
            xtype: 'fieldset',
            title: '��ѯ����',
            layout: 'column',
            style: DHCSTFormStyle.FrmPaddingV,
            items: [{
                columnWidth: 0.34,
                xtype: 'fieldset',
                defaults: { width: 180, border: false }, // Default config options for child items
                border: false,
                items: [LocManaGrp, StkBin]

            }, {
                columnWidth: 0.33,
                xtype: 'fieldset',
                defaults: { width: 140, border: false }, // Default config options for child items
                border: false,
                items: [StkGrpType, InstNo]

            }, {
                columnWidth: 0.33,
                xtype: 'fieldset',
                defaults: { width: 140, border: false }, // Default config options for child items
                border: false,
                items: [DHCStkCatGroup, InputWin]

            }]
        }]
    });

    // 5.2.ҳ�沼��
    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: [{
            region: 'north',
            height: DHCSTFormStyle.FrmHeight(2),
            layout: 'fit',
            items: [form]
        }, {
            region: 'center',
            layout: 'fit',
            items: [InstDetailGrid]
        }],
        renderTo: 'mainPanel'
    });

    Select();
    //�Զ������̵㵥
    create(gRowid);
})