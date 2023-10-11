// /����: ������
// /����: �̵�����
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.24
Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    Ext.Ajax.timeout = 900000;
    var gRowid = '';
    var today = new Date();
    var url = DictUrl + 'instktkaction.csp';
    var gGroupId = session["LOGON.GROUPID"];
    var gLocId = session["LOGON.CTLOCID"];
    var gUserId = session["LOGON.USERID"];
    //wyx add�������� 2014-03-06
    if (gParam.length < 1) {
        GetParam(); //��ʼ����������
    }
    var PhaLoc = new Ext.ux.LocComboBox({
        fieldLabel: $g('����'),
        id: 'PhaLoc',
        name: 'PhaLoc',
        anchor: '85%',
        emptyText: $g('����...'),
        groupId: gGroupId,
        listeners: {
            'select': function (e) {
                var SelLocId = Ext.getCmp('PhaLoc').getValue();
                StkGrpType.getStore().removeAll();
                StkGrpType.getStore().setBaseParam("locId", SelLocId)
                StkGrpType.getStore().setBaseParam("userId", UserId)
                StkGrpType.getStore().setBaseParam("type", App_StkTypeCode)
                StkGrpType.getStore().load();
                Ext.getCmp("StStkBin").setValue('');
                Ext.getCmp("EdStkBin").setValue('');
            }
        }
    });
    PhaLoc.addListener('change', function (field, newValue, oldValue) {
        LoadLocManGrp();
    });

    var TkDate = new Ext.ux.DateField({
        fieldLabel: $g('����'),
        id: 'TkDate',
        name: 'TkDate',
        anchor: '85%',
        width: 140,
        disabled: true,
        value: new Date()
    });

    var TkTime = new Ext.form.TextField({
        fieldLabel: $g('ʱ��'),
        id: 'TkTime',
        name: 'TkTime',
        anchor: '85%',
        width: 140,
        disabled: true
    });

    var InstNo = new Ext.form.TextField({
        fieldLabel: $g('�̵㵥��'),
        id: 'InstNo',
        name: 'InstNo',
        anchor: '85%',
        width: 140,
        disabled: true
    });

    var Complete = new Ext.form.Checkbox({
        fieldLabel: $g('���'),
        id: 'Complete',
        name: 'Complete',
        width: 80,
        disabled: true
    });

    // ȷ����ť
    var returnBT = new Ext.Toolbar.Button({
        text: $g('ȷ��'),
        tooltip: $g('���ȷ��'),
        iconCls: 'page_goto',
        handler: function () {
            var selectradio = Ext.getCmp('PrintModel').getValue();
            if (selectradio) {
                var selectModel = selectradio.inputValue;
                if (selectModel == '1') {
                    PrintINStk(gRowid);
                    PrintAskWin.hide();
                } else if (selectModel == '2')
                {
                    PrintINStkStkBin(gRowid);
                    PrintAskWin.hide();
                } else if (selectModel == '3')
                {
                    PrintINStkTotal(gRowid);
                    PrintAskWin.hide();
                }
                
            }
        }
    });

    // ȡ����ť
    var cancelBT = new Ext.Toolbar.Button({
        text: $g('�ر�'),
        tooltip: $g('����ر�'),
        iconCls: 'page_delete',
        handler: function () {
            PrintAskWin.hide();
        }
    });
    //��ӡѡ��ť
    var PrintAskWin = new Ext.Window({
        title: $g('��ӡģʽѡ��'),
        width: 200,
        height: 170,
        labelWidth: 100,
        closeAction: 'hide',
        plain: true,
        modal: true,
        items: [{
            xtype: 'radiogroup',
            id: 'PrintModel',
            anchor: '95%',
            columns: 1,
            style: 'padding:5px 5px 5px 5px;',
            items: [{
                checked: true,
                boxLabel: $g('����λ-���δ�ӡ'),
                id: 'PrintModel2',
                name: 'PrintModel',
                inputValue: '2'
            }, {
                checked: false,
                boxLabel: $g('��ҩƷ-���δ�ӡ'),
                id: 'PrintModel1',
                name: 'PrintModel',
                inputValue: '1'
            }, {
                checked: false,
                boxLabel: $g('��ҩƷ-Ʒ�ִ�ӡ'),
                id: 'PrintModel3',
                name: 'PrintModel',
                inputValue: '3'
            }]
        }],
        buttons: [returnBT, cancelBT]
    })
    // ��ӡ�̵㵥��ť
    var PrintBT = new Ext.Toolbar.Button({
        id: "PrintBT",
        text: $g('��ӡ'),
        tooltip: $g('�����ӡ�̵㵥'),
        width: 70,
        height: 30,
        iconCls: 'page_print',
        handler: function () {
	        if(gRowid=="")
	        {
		        Msg.info("warning",$g( "��������һ�����̵��ٴ�ӡ!"));
		        return;
	        }
            PrintAskWin.show();
        }
    });

    var TkUomStore = new Ext.data.SimpleStore({
        fields: ['RowId', 'Description'],
        data: [
            [0, $g('������λ')],
            [1, $g('��ⵥλ')]
        ]
    });

    var TkUom = new Ext.form.ComboBox({
        fieldLabel: $g('Ĭ��ʵ�̵�λ'),
        id: 'TkUom',
        name: 'TkUom',
        anchor: '85%',
        width: 140,
        store: TkUomStore,
        valueField: 'RowId',
        displayField: 'Description',
        allowBlank: false,
        triggerAction: 'all',
        emptyText: $g('Ĭ��ʵ�̵�λ...'),
        selectOnFocus: true,
        forceSelection: true,
        minChars: 1,
        valueNotFoundText: '',
        mode: 'local'
    });
    Ext.getCmp("TkUom").setValue(1);

    var StkGrpType = new Ext.ux.StkGrpComboBox({
        id: 'StkGrpType',
        name: 'StkGrpType',
        StkType: App_StkTypeCode, //��ʶ��������
        LocId: gLocId,
        UserId: gUserId,
        anchor: '90%',
        width: 140
    });
    StkGrpType.on('change', function () {
        Ext.getCmp("DHCStkCatGroup").setValue("");
    });

    var DHCStkCatGroup = new Ext.ux.ComboBox({
        fieldLabel: $g('������'),
        id: 'DHCStkCatGroup',
        name: 'DHCStkCatGroup',
        store: StkCatStore,
        valueField: 'RowId',
        displayField: 'Description',
        params: {
            StkGrpId: 'StkGrpType'
        }
    });

    var StStkBin = new Ext.form.ComboBox({
        fieldLabel: $g('��ʼ��λ'),
        id: 'StStkBin',
        name: 'StStkBin',
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
            'beforequery': function (e) {
                this.store.removeAll();
                this.store.setBaseParam('LocId', Ext.getCmp("PhaLoc").getValue());
                this.store.setBaseParam('Desc', this.getRawValue());
                this.store.load({
                    params: {
                        start: 0,
                        limit: 20
                    }
                });
            }
        }
    });

    var EdStkBin = new Ext.form.ComboBox({
        fieldLabel: $g('��ֹ��λ'),
        id: 'EdStkBin',
        name: 'EdStkBin',
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
            'beforequery': function (e) {
                this.store.removeAll();
                this.store.setBaseParam('LocId', Ext.getCmp("PhaLoc").getValue());
                this.store.setBaseParam('Desc', this.getRawValue());
                this.store.load({
                    params: {
                        start: 0,
                        limit: 20
                    }
                });
            }
        }
    });

    var ManageDrug = new Ext.form.Checkbox({
        fieldLabel: $g('������ҩ'),
        id: 'ManageDrug',
        name: 'ManageDrug',
        anchor: '90%',
        width: 100,
        height: 8,
        checked: false
    });

    var IncludeNotUse = new Ext.form.Checkbox({
        fieldLabel: $g('����������Ʒ��'),
        id: 'IncludeNotUse',
        name: 'IncludeNotUse',
        anchor: '90%',
        width: 100,
        height: 8,
        checked: false
    });

    var NotUseFlag = new Ext.form.Checkbox({
        fieldLabel: $g('��������Ʒ��'),
        id: 'NotUseFlag',
        name: 'NotUseFlag',
        anchor: '90%',
        width: 100,
        height: 8,
        checked: false
    });
    var InclbZeroFlag = new Ext.form.Checkbox({
        fieldLabel: $g('���������ο��'),
        id: 'InclbZeroFlag',
        name: 'InclbZeroFlag',
        anchor: '90%',
        width: 100,
        height: 8,
        checked: false
    });
      var WithOutSelectLMG = new Ext.form.Checkbox({
	    //fieldLabel: '',
        boxLabel: $g('�������·���ѡ������'),
        id: 'WithOutSelectLMG',
        name: 'WithOutSelectLMG',
        anchor: '90%',
        //width: 100,
        //height: 8,
        checked: false
    });
    
    var num = new Ext.grid.RowNumberer();
    var sm = new Ext.grid.CheckboxSelectionModel();
    var LocManGrpCm = new Ext.grid.ColumnModel([sm, num, {
        header: "Rowid",
        dataIndex: 'Rowid',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: $g("����"),
        dataIndex: 'Desc',
        width: 150,
        align: 'left',
        sortable: true
    }, {
        header: $g("�Ƿ����"),
        dataIndex: 'IfInclude',
        width: 80,
        align: 'left',
        sortable: true
    }
    ]);
    LocManGrpCm.defaultSortable = true;

    // ����·��
    var LocManGrpUrl = DictUrl +
        'locmangrpaction.csp?actiontype=Query&start=&limit=';
    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
        url: LocManGrpUrl,
        method: "POST"
    });
    // ָ���в���
    // ���ݼ�
    var LocManGrpStore = new Ext.data.Store({
        proxy: proxy,
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: "results",
            id: "Rowid",
            fields: ["Rowid", "Desc"]
        })
    });
    var LocManGrpGrid = new Ext.grid.GridPanel({
        id: 'LocManGrpGrid',
        cm: LocManGrpCm,
        store: LocManGrpStore,
        trackMouseOver: true,
        stripeRows: true,
        title: $g('������'),
        sm: sm,
        clicksToEdit: 1,
        loadMask: true,
        height: 200,
        tbar:['->',WithOutSelectLMG],
    });

    // ��ѯ��ť
    var SearchBT = new Ext.Toolbar.Button({
        text: $g('��ѯ'),
        tooltip: $g('�����ѯ'),
        iconCls: 'page_find',
        width: 70,
        height: 30,
        handler: function () {
            InStkTkSearch(Query);
        }
    });

    // ��հ�ť
    var RefreshBT = new Ext.Toolbar.Button({
        text: $g('����'),
        tooltip: $g('�������'),
        iconCls: 'page_clearscreen',
        width: 70,
        height: 30,
        handler: function () {
            clearData();
        }
    });

    /**
     * ��շ���
     */
    function clearData() {
        gRowid = '';
        Ext.getCmp("DHCStkCatGroup").setValue('');
        Ext.getCmp("StStkBin").setValue('');
        Ext.getCmp("EdStkBin").setValue('');
        Ext.getCmp("InstNo").setValue('');
        SetLogInDept(Ext.getCmp("PhaLoc").getStore(), 'PhaLoc');
        Ext.getCmp("Complete").setValue(false);
        Ext.getCmp("ManageDrug").setValue(false);
        Ext.getCmp("TkUom").setValue(1);
        Ext.getCmp("DHCStkCatGroup").setValue('');
        Ext.getCmp("StkGrpType").getStore().load();
        Ext.getCmp("StStkBin").setValue('');
        Ext.getCmp("EdStkBin").setValue('');
        Ext.getCmp("IncludeNotUse").setValue(false);
        Ext.getCmp("NotUseFlag").setValue(false);
        Ext.getCmp("InclbZeroFlag").setValue(false);
        Ext.getCmp("WithOutSelectLMG").setValue(false);
        Ext.getCmp("TkTime").setValue('');
        
        LoadLocManGrp();
        StockQtyGrid.store.removeAll();
        StockQtyGrid.store.load({
            params: {
                start: 0,
                limit: 0
            }
        });
    }

    var CreateBT = new Ext.Toolbar.Button({
        text: $g('�����̵㵥'),
        tooltip: $g('��������̵㵥'),
        iconCls: 'page_add',
        width: 70,
        height: 30,
        handler: function () {
            StockQtyGrid.store.removeAll();
            save();
        }
    });
    var QueryTmpData = new Ext.Toolbar.Button({
        text: $g('��ѯԤ������'),
        tooltip: $g('��ѯԤ������'),
        iconCls: 'page_Find',
        width: 70,
        height: 30,
        handler: function () {
            StockQtyGrid.store.removeAll();
            QueryTmpDetail();
        }
    });
    
    
    var GridColSetBT = new Ext.Toolbar.Button({
        text: $g('������'),
        tooltip: $g('������'),
        iconCls: 'page_gear',
        handler: function () {
            GridColSet(StockQtyGrid, "DHCSTINSTKTK");
        }
    });
    
    //��ѯ�̵㵥��ϸ(������ѯʹ��)
    function QueryTmpDetail()
    {
	    var PhaLocId = Ext.getCmp("PhaLoc").getValue();
        if (PhaLocId == "") {
            Msg.info("warning", $g("��ѡȡ����!"));
            return;
        }
        var UserId = session['LOGON.USERID'];
        var UomType = Ext.getCmp("TkUom").getValue();
        var SelectRows = LocManGrpGrid.getSelectionModel().getSelections();
        var LocManGrp = '';
        if (SelectRows != null) {
            for (i = 0; i < SelectRows.length; i++) {
                if (LocManGrp == '') {
                    LocManGrp = SelectRows[i].get("Rowid");
                } else {
                    LocManGrp = LocManGrp + "," + SelectRows[i].get("Rowid");
                }

            }
        }
        var curStartDate = Ext.getCmp("TkDate").getValue();
        var StartDate = curStartDate.format("Y-m-") + "01"
        var EndDate = curStartDate.format("Y-m-d")
        var CompleteStr = CheckIfCompleted(PhaLocId, StartDate, EndDate);

        if ((CompleteStr != "") & (gParam[0] == 'Y')) {
            Msg.info("warning", $g('��δ��ɵ�ҵ�񵥣����������̵㵥��') + CompleteStr);
            return;

        }

        var StkGrpId = Ext.getCmp('StkGrpType').getValue();
        var StkCatId = Ext.getCmp('DHCStkCatGroup').getValue();
        var ManageDrug = (Ext.getCmp('ManageDrug').getValue() == true ? 'Y' : 'N');
        var IncludeNotUseFlag = (Ext.getCmp('IncludeNotUse').getValue() == true ? 'Y' : 'N');
        var NotUseFlag = (Ext.getCmp('NotUseFlag').getValue() == true ? 'Y' : 'N');
        var StStkBin = Ext.getCmp('StStkBin').getValue();
        var EdStkBin = Ext.getCmp('EdStkBin').getValue();
        var InclbZeroFlag = (Ext.getCmp('InclbZeroFlag').getValue() == true ? 'Y' : 'N');
        var WithOutSelectLMGFlag=(Ext.getCmp('WithOutSelectLMG').getValue() == true ? 'Y' : 'N');
        var params = PhaLocId + '^' + UserId + '^' + UomType + '^' + LocManGrp + '^' + StkGrpId + '^' + StkCatId +
            '^' + ManageDrug + '^' + IncludeNotUseFlag + '^' + NotUseFlag + '^' + StStkBin + '^' + EdStkBin +
            '^' + InclbZeroFlag+'^'+WithOutSelectLMGFlag;
	    
        var size = StatuTabPagingToolbar.pageSize;
        StockQtyStore.setBaseParam('TMPMianInfo', params)
        StockQtyStore.load({
            params: {
                start: 0,
                limit: size,
                Parref: "",
                TMPMianInfo:params,
            }
        });
                 
    }
    function save() {
        var PhaLocId = Ext.getCmp("PhaLoc").getValue();
        if (PhaLocId == "") {
            Msg.info("warning", $g("��ѡȡ����!"));
            return;
        }
        var UserId = session['LOGON.USERID'];
        var UomType = Ext.getCmp("TkUom").getValue();
        var SelectRows = LocManGrpGrid.getSelectionModel().getSelections();
        var LocManGrp = '';
        if (SelectRows != null) {
            for (i = 0; i < SelectRows.length; i++) {
                if (LocManGrp == '') {
                    LocManGrp = SelectRows[i].get("Rowid");
                } else {
                    LocManGrp = LocManGrp + "," + SelectRows[i].get("Rowid");
                }

            }
        }
        var curStartDate = Ext.getCmp("TkDate").getValue();
        var StartDate = curStartDate.format("Y-m-") + "01"
        var EndDate = curStartDate.format("Y-m-d")
        var CompleteStr = CheckIfCompleted(PhaLocId, StartDate, EndDate);

        if ((CompleteStr != "") & (gParam[0] == 'Y')) {
            Msg.info("warning", $g('��δ��ɵ�ҵ�񵥣����������̵㵥��') + CompleteStr);
            return;

        }

        var StkGrpId = Ext.getCmp('StkGrpType').getValue();
        var StkCatId = Ext.getCmp('DHCStkCatGroup').getValue();
        var ManageDrug = (Ext.getCmp('ManageDrug').getValue() == true ? 'Y' : 'N');
        var IncludeNotUseFlag = (Ext.getCmp('IncludeNotUse').getValue() == true ? 'Y' : 'N');
        var NotUseFlag = (Ext.getCmp('NotUseFlag').getValue() == true ? 'Y' : 'N');
        var StStkBin = Ext.getCmp('StStkBin').getValue();
        var EdStkBin = Ext.getCmp('EdStkBin').getValue();
        var InclbZeroFlag = (Ext.getCmp('InclbZeroFlag').getValue() == true ? 'Y' : 'N');
        var WithOutSelectLMGFlag=(Ext.getCmp('WithOutSelectLMG').getValue() == true ? 'Y' : 'N');
        var params = PhaLocId + '^' + UserId + '^' + UomType + '^' + LocManGrp + '^' + StkGrpId + '^' + StkCatId +
            '^' + ManageDrug + '^' + IncludeNotUseFlag + '^' + NotUseFlag + '^' + StStkBin + '^' + EdStkBin +
            '^' + InclbZeroFlag+'^'+WithOutSelectLMGFlag;

        var mask = ShowLoadMask(Ext.getBody(), $g("������..."));
        Ext.Ajax.request({
            url: url,
            params: {
                actiontype: 'Create',
                Params: params
            },
            success: function (response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                if (jsonData.success == 'true') {
                    var InstId = jsonData.info;
                    Msg.info("success", $g("�����̵㵥�ɹ�!"));
                    Query(InstId);
                } else {
                    var ret = jsonData.info;
                    if (ret == -1) {
                        Msg.info("error", $g("�̵���Ҳ���Ϊ��!"));
                    } else if (ret == -2) {
                        Msg.info("error", $g("�̵��˲���Ϊ��!"));
                    } else if (ret == -3) {
                        Msg.info("error", $g("�����̵���Ϣʧ��!"));
                    } else if (ret == -4) {
                        Msg.info("error", $g("�����̵㵥��ʧ��!"));
                    } else if (ret == -5) {
                        Msg.info("error", $g("�������¼����ʧ��!"));
                    } else if (ret == -6) {
                        Msg.info("error", $g("�����̵���ϸʧ��!"));
                    } else if (ret == -7) {
                        Msg.info("error", $g("û�з����������̵���ϸ!"));
                    } else {
                        Msg.info("error", $g("�����̵㵥ʧ��"));
                    }
                }
                mask.hide();
            }
        });
    }

    //�����̵㵥����ϸ��Ϣ
    function Query(inst) {
        if (inst == null || inst.length < 1) {
            Msg.info("warning", $g("�̵�id����Ϊ��!"));
        }
        gRowid = inst;
        //��ѯ�̵㵥����Ϣ
        Ext.Ajax.request({
            url: url,
            method: 'post',
            timeout: 100000000, 
            params: {
                actiontype: 'Select',
                Rowid: inst
            },
            success: function (reponse, opt) {
                var jsonData = Ext.util.JSON.decode(reponse.responseText);
                if (jsonData.success == 'true') {
                    var data = jsonData.info;
                    if (data != "") {
                        var detail = data.split("^");

                        var instNo = detail[0];
                        var locId = detail[5];
                        var locDesc = detail[6];
                        var userId = detail[3];
                        var userName = detail[4];
                        var tkDate = detail[1];
                        var tkTime = detail[2];
                        var compFlag = (detail[9] == 'Y' ? true : false);
                        var manaFlag = (detail[13] == 'Y' ? true : false);
                        var tkUom = detail[14];
                        var includeNotUse = (detail[15] == 'Y' ? true : false);
                        var onlyNotUse = (detail[16] == 'Y' ? true : false);
                        var stkgrpid = detail[17];
                        var stkcatid = detail[18];
                        var stkCatDesc = detail[19];
                        var frStkBin = detail[20];
                        var frStkBinDesc = detail[21];
                        var toStkBin = detail[22];
                        var toStkBinDesc = detail[23];

                        Ext.getCmp("InstNo").setValue(instNo);
                        Ext.getCmp("TkDate").setValue(tkDate);
                        Ext.getCmp("TkTime").setValue(tkTime);
                        addComboData(PhaLoc.getStore(), locId, locDesc);
                        Ext.getCmp("PhaLoc").setValue(locId);
                        Ext.getCmp("Complete").setValue(compFlag);
                        Ext.getCmp("ManageDrug").setValue(manaFlag);
                        Ext.getCmp("TkUom").setValue(tkUom);
                        addComboData(StkCatStore, stkcatid, stkCatDesc);
                        Ext.getCmp("DHCStkCatGroup").setValue(stkcatid);
                        Ext.getCmp("StkGrpType").setValue(stkgrpid);
                        addComboData(StStkBin.getStore(), frStkBin, frStkBinDesc);
                        Ext.getCmp("StStkBin").setValue(frStkBin);
                        addComboData(EdStkBin.getStore(), toStkBin, toStkBinDesc);
                        Ext.getCmp("EdStkBin").setValue(toStkBin);
                        Ext.getCmp("IncludeNotUse").setValue(includeNotUse);
                        Ext.getCmp("NotUseFlag").setValue(onlyNotUse);
                    }
                }
            },
            failure: function (response, opts) {
                console.log('server-side failure with status code ' + response.status);
            }

        });

        //��ѯ�̵㵥��ϸ
        var size = StatuTabPagingToolbar.pageSize;
        StockQtyStore.setBaseParam('Parref', inst)
        StockQtyStore.load({
            params: {
                start: 0,
                limit: size,
                Parref: inst,
                TMPMianInfo:''
            }
        });
        
        

        //��ѯ���ҹ�����
        Ext.Ajax.request({
            url: url,
            params: {
                actiontype: 'GetStkManGrp',
                Rowid: inst
            },
            method: 'post',
            success: function (response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                var data = jsonData.info;
                if (data != null || data.length > 0) {
                    var lmgArr = new Array();
                    var detail = data.split(",");
                    for (var i = 0; i < detail.length; i++) {
                        var rowdata = detail[i];
                        var lmg = rowdata.split("^")[0];
                        var ifInclude = rowdata.split("^")[2];

                        var rowcount = LocManGrpGrid.getStore().getCount();
                        for (var j = 0; j < rowcount; j++) {
                            var record = LocManGrpStore.getAt(j);
                            if (lmg == record.get("Rowid")) {
	                            if(ifInclude=="Y") record.set("IfInclude",$g("������"))
	                            else record.set("IfInclude",$g("������"))
                                lmgArr[i] = j;
                                break;
                            }
                        }
                    }
                    LocManGrpGrid.getSelectionModel().selectRows(lmgArr);
                }
            }
        });
    }

    var CompleteBT = new Ext.Toolbar.Button({
        text: $g('ȷ�����'),
        tooltip: $g('���ȷ�����'),
        iconCls: 'page_gear',
        width: 70,
        height: 30,
        handler: function () {
            InstComplete();
        }
    });

    //ȷ�����
    function InstComplete() {
        if (gRowid == "" || gRowid == null) {
            Msg.info("warning", $g("û����Ҫ��ɵ��̵㵥!"));
            return;
        }
        Ext.Ajax.request({
            url: url,
            params: {
                actiontype: 'Complete',
                Rowid: gRowid
            },
            method: 'post',
            waitMsg: $g('������...'),
            success: function (response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                if (jsonData.success == 'true') {
                    Msg.info("success", $g("�����ɹ�!"));
                    Ext.getCmp('Complete').setValue(true);
                } else {
                    var ret = jsonData.info;
                    if (ret == -99) {
                        Msg.info("error", $g("����ʧ��!"));
                    } else if (ret == -2) {
                        Msg.info("error", $g("�̵㵥�Ѿ����!"));
                    } else {
                        Msg.info("error", $g("����ʧ��!"));
                    }
                }
            }
        });
    }
    var DeleteBT = new Ext.Toolbar.Button({
        text: $g('ɾ��'),
        tooltip: $g('���ɾ��'),
        iconCls: 'page_delete',
        width: 70,
        height: 30,
        handler: function () {
            Delete();
        }
    });

    //ɾ��
    function Delete() {
        if (gRowid == "" || gRowid == null) {
            Msg.info("warning", $g("û����Ҫɾ�����̵㵥!"));
            return;
        }
        Ext.Ajax.request({
            url: url,
            params: {
                actiontype: 'Delete',
                Rowid: gRowid
            },
            method: 'post',
            waitMsg: $g('������...'),
            success: function (response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                if (jsonData.success == 'true') {
                    Msg.info("success", $g("�����ɹ�!"));
                    clearData();
                } else {
                    var ret = jsonData.info;
                    if (ret == -99) {
                        Msg.info("error",$g( "����ʧ��!"));
                    } else if (ret == -3) {
                        Ext.MessageBox.confirm($g('��ʾ'), $g('�̵㵥Ϊ�������״̬,�Ƿ�ȷ��ɾ��?'),
                            function (btn) {
                                if (btn == 'yes') {
                                    Ext.Ajax.request({
                                        url: url,
                                        params: {
                                            actiontype: 'Delete',
                                            Rowid: gRowid,
                                            Allow: 1
                                        },
                                        method: 'post',
                                        waitMsg: $g('������...'),
                                        success: function (response, opt) {
                                            var jsonData = Ext.util.JSON.decode(response.responseText);
                                            var ret = jsonData.info;
                                            if (jsonData.success == 'true') {
                                                Msg.info("success", $g("�����ɹ�!"));
                                                clearData();
                                            } else if (ret == -1) {
                                                Msg.info("error", $g("�̵㵥�Ѿ�ʵ�̻��ܣ�������ɾ��!"));
                                            } else if (ret == -2) {
                                                Msg.info("error", $g("�̵㵥�Ѿ�������������ɾ��!"));
                                            }else if (ret == -5) {
                                                Msg.info("error", $g("�Ѿ���������������������ɾ��!"));
                                            } else {
                                                Msg.info("error", $g("����ʧ��!"));
                                            }

                                        }
                                    })

                                }
                            }
                        )
                    } else if (ret == -1) {
                        Msg.info("error", $g("�̵㵥�Ѿ�ʵ�̻��ܣ�������ɾ��!"));
                    } else if (ret == -2) {
                        Msg.info("error", $g("�̵㵥�Ѿ�������������ɾ��!"));
                    } else {
                        Msg.info("error", $g("����ʧ��!"));
                    }
                }
            }
        });
    }
    //���ĳ����ĳ�·��±��Ƿ���δ��ɵĵ��� //add wyx 2014-03-06 
    function CheckIfCompleted(LocId, StartDate, EndDate) {
        var flag = false;
        var NewUrl = url + "?actiontype=CheckIfCompleted&LocId=" + LocId + "&StartDate=" + StartDate + "&EndDate=" + EndDate;
        var responseText = ExecuteDBSynAccess(NewUrl);
        var jsonData = Ext.util.JSON.decode(responseText);
        return jsonData.info;
    }

    function LoadLocManGrp() {
        var locId = Ext.getCmp("PhaLoc").getValue();
        if (locId == null || locId.length < 0) {
            locId = session['LOGON.CTLOCID'];

        }
        UserId = session["LOGON.USERID"];
        LocManGrpStore.removeAll();
        LocManGrpStore.load({
            params: {
                LocId: locId,
                UserId: UserId
            }
        });
    }

    var nm = new Ext.grid.RowNumberer();
    var StockQtyCm = new Ext.grid.ColumnModel([nm, {
        header: "rowid",
        dataIndex: 'rowid',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: "inclb",
        dataIndex: 'inclb',
        width: 80,
        align: 'left',
        hidden: true
    }, {
        header: $g('����'),
        dataIndex: 'code',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g("����"),
        dataIndex: 'desc',
        width: 200,
        align: 'left',
        sortable: true
    }, {
        header:$g( "���"),
        dataIndex: 'spec',
        width: 90,
        align: 'left',
    }, {
        header: $g("������λ"),
        dataIndex: 'uomDesc',
        width: 80,
        align: 'left',
    }, {
        header: $g('��������'),
        dataIndex: 'freQty',
        width: 100,
        align: 'right',
        sortable: true
    }, {
        header: $g("��ⵥλ"),
        dataIndex: 'purUomDesc',
        width: 80,
        align: 'left',
    }, {
        header: $g('��������(��ⵥλ)'),
        dataIndex: 'purFreQty',
        width: 100,
        align: 'right',
    }, {
        header: $g('��������'),
        dataIndex: 'freDate',
        width: 80,
        align: 'left',
    }, {
        header: $g('����ʱ��'),
        dataIndex: 'freTime',
        width: 80,
        align: 'left',
    }, {
        header:$g( "������ҵ"),
        dataIndex: 'manf',
        width: 100,
        align: 'left',
    }, {
        header: $g('����'),
        dataIndex: 'batchNo',
        width: 100,
        align: 'left',
    }, {
        header: $g('Ч��'),
        dataIndex: 'expDate',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g('��λ'),
        dataIndex: 'sbDesc',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g("����"),
        dataIndex: 'barcode',
        width: 80,
        align: 'left',
    }, {
        header: $g("��ע"),
        dataIndex: 'remark',
        width: 80,
        align: 'left',
    }, {
        header: $g("״̬"),
        dataIndex: 'status',
        width: 80,
        align: 'left',
    }, {
        header: $g('���̽��۽��'),
        dataIndex: 'freezeRpAmt',
        width: 120,
        align: 'right',
        sortable: true
    }/*, {
        header: $g('ʵ�̽��۽��',
        dataIndex: 'countRpAmt',
        width: 120,
        align: 'right',
        sortable: true,
        hidden: true
    }*/, {
        header: $g('�����ۼ۽��'),
        dataIndex: 'freezeSpAmt',
        width: 120,
        align: 'right',
        sortable: true
    }/*, {
        header: $g('ʵ���ۼ۽��'),
        dataIndex: 'countSpAmt',
        width: 120,
        align: 'right',
        sortable: true,
        hidden: true
    }, {
        header: $g('���۲��'),
        dataIndex: 'varianceRpAmt',
        width: 120,
        align: 'right',
        sortable: true,
        hidden: true
    }, {
        header: $g('�ۼ۲��'),
        dataIndex: 'varianceSpAmt',
        width: 120,
        align: 'right',
        sortable: true,
        hidden: true
    }*/]);
    //StockQtyCm.defaultSortable = true;

    // ����·��
    var DspPhaUrl = DictUrl +
        'instktkaction.csp?actiontype=QueryDetail&start=&limit=&sort=rowid&dir=ASC';
    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
        url: DspPhaUrl,
        method: "POST"
    });
    // ָ���в���
    //adjFlag:%String,:%String,inadi:%String
    var fields = ["rowid", "inclb", "code", "desc", "spec", "manf", "barcode", "freQty",
        "freDate", "freTime", "remark", "status", "uomDesc", "batchNo", "expDate", "sbDesc", "purUomDesc", "purFreQty", "freezeSpAmt", "freezeRpAmt", "countSpAmt",
        "countRpAmt", "varianceSpAmt", "varianceRpAmt"
    ];
    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "rowid",
        fields: fields
    });
    // ���ݼ�
    var StockQtyStore = new Ext.data.Store({
        proxy: proxy,
        reader: reader,
        remoteSort: true,
        baseParams: {
            Parref: '',
            TMPMianInfo:''
        }
    });

    var StatuTabPagingToolbar = new Ext.PagingToolbar({
        store: StockQtyStore,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: $g('��ǰ��¼ {0} -- {1} �� �� {2} ����¼'),
        emptyMsg: "No results to display",
        prevText: $g("��һҳ"),
        nextText: $g("��һҳ"),
        refreshText: $g("ˢ��"),
        lastText: $g("���ҳ"),
        firstText: $g("��һҳ"),
        beforePageText: $g("��ǰҳ"),
        afterPageText:$g( "��{0}ҳ"),
        emptyMsg: $g("û������")
    });

    var StockQtyGrid = new Ext.grid.GridPanel({
        id: 'StockQtyGrid',
        region: 'center',
        cm: StockQtyCm,
        store: StockQtyStore,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        loadMask: true,
        bbar: StatuTabPagingToolbar
    });

    var form = new Ext.form.FormPanel({
        labelwidth: 30,
        width: 400,
        labelAlign: 'right',
        frame: true,
        autoScroll: true,
        //bodyStyle : 'padding:10px 0px 0px 0px;',                                
        items: [InstNo, PhaLoc, TkDate, TkTime, Complete, {
            title:$g( '�޶���Χ'),
            xtype: 'fieldset',
            items: [StkGrpType, DHCStkCatGroup, StStkBin, EdStkBin, ManageDrug,
                IncludeNotUse, NotUseFlag, InclbZeroFlag, LocManGrpGrid
            ]
        }]
    });
    var myToolBar = new Ext.Toolbar({
        items: [SearchBT, '-', RefreshBT, '-', QueryTmpData , '-', CreateBT, '-', CompleteBT, '-', PrintBT, '-', GridColSetBT, '-', DeleteBT]
    });

    // 5.2.ҳ�沼��
    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: [{
            region: 'north',
            height: 65,
            layout: 'fit', // specify layout manager for items
            title: $g('�̵�-����'),
            items: myToolBar
        }, {
            region: 'west',
            split: true,
            width: 350,
            minSize: 200,
            maxSize: 380,
            collapsible: true,
            layout: 'fit', // specify layout manager for items
            items: form

        }, {
            region: 'center',
            region: 'center',
            layout: 'fit', // specify layout manager for items
            items: StockQtyGrid

        }],
        renderTo: 'mainPanel'
    });

    LoadLocManGrp();
    RefreshGridColSet(StockQtyGrid, "DHCSTINSTKTK");
})