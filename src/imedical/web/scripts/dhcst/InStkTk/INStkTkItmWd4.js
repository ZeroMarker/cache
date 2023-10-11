// /����: ʵ�̣�¼�뷽ʽ�ģ�����λ����¼�뷽ʽ��
// /����: ʵ�̣�¼�뷽ʽ�ģ�����λ����¼�뷽ʽ��
// /��д�ߣ�zhangdongmei
// /��д����: 2012.09.05
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gStrDetailParams = '';
    var url = DictUrl + 'instktkaction.csp';
    var inciRowid = "";
    var activetabI = 0;
    //wyx add�������� 2013-11-28
    if (gParam.length < 1) {
        GetParam(); //��ʼ����������

    }
    var LocManaGrp = new Ext.form.ComboBox({
        fieldLabel: $g('������'),
        id: 'LocManaGrp',
        name: 'LocManaGrp',
        anchor: '90%',
        width: 140,
        store: LocManGrpStore,
        valueField: 'RowId',
        displayField: 'Description',
        allowBlank: true,
        triggerAction: 'all',
        emptyText: $g('������...'),
        selectOnFocus: true,
        forceSelection: true,
        minChars: 1,
        pageSize: 20,
        listWidth: 250,
        valueNotFoundText: '',
        listeners: {
            'beforequery': function(combox) {
                LocManGrpStore.removeAll();
                LocManGrpStore.setBaseParam('locId', InstkLocRowid);
                LocManGrpStore.load({ params: { start: 0, limit: 20 } });
            }
        }
    });

    var PhaWindow = new Ext.form.ComboBox({
        fieldLabel: $g('ʵ�̴���'),
        id: 'PhaWindow',
        name: 'PhaWindow',
        anchor: '90%',
        store: INStkTkWindowStore,
        valueField: 'RowId',
        displayField: 'Description',
        emptyText: $g('ʵ�̴���...'),
        disabled: true,
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
            Ext.getCmp("PhaWindow").setValue(gInstwWin);
        }
    });

    var StkGrpType = new Ext.ux.StkGrpComboBox({
        id: 'StkGrpType',
        name: 'StkGrpType',
        StkType: App_StkTypeCode, //��ʶ��������
        anchor: '90%',
        width: 140
    });

    StkGrpType.on('change', function() {
        Ext.getCmp("StkGrpType").getValue();;
    });

    var DHCStkCatGroup = new Ext.ux.ComboBox({
        fieldLabel: $g('������'),
        id: 'DHCStkCatGroup',
        name: 'DHCStkCatGroup',
        store: StkCatStore,
        valueField: 'RowId',
        displayField: 'Description',
        params: { StkGrpId: 'StkGrpType' }
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
            'beforequery': function(e) {
                this.store.removeAll();

                this.store.setBaseParam('LocId', InstkLocRowid);
                this.store.setBaseParam('Desc', this.getRawValue());
                this.store.load({ params: { start: 0, limit: 20 } });
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
            'beforequery': function(e) {
                this.store.removeAll();
                this.store.setBaseParam('LocId', InstkLocRowid);
                this.store.setBaseParam('Desc', this.getRawValue());
                this.store.load({ params: { start: 0, limit: 20 } });
            }
        }
    });

    var label = new Ext.form.TextField({
        fieldLabel: $g('����'),
        id: 'label',
        name: 'label',
        anchor: '90%'
    });

    var InstNo = new Ext.form.TextField({
        id: 'InstNo',
        name: 'InstNo',
        fieldLabel: $g('�̵㵥��'),
        anchor: '90%',
        width: 140,
        disabled: true
    });

    //�Ƿ����ʵ������
    function CheckExistNO() {
        if (gRowid == null || gRowid == "") {
            return;
        }
        var phaWindow=Ext.getCmp("PhaWindow").getValue();
        var retflag = 0
        var mask = ShowLoadMask(Ext.getBody(), $g("���������Ժ�..."));
        Ext.Ajax.request({
            url: url,
            async: true, //ͬ����������
            params: { actiontype: 'CheckExist', Rowid: gRowid,PhaWinow:phaWindow },
            method: 'post',
            success: function(response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    retflag = jsonData.info;
                    if (retflag != "0") {
                        Ext.MessageBox.show({
                            title: $g('��ʾ'),
                            msg: '</br>'+$g('����ʵ������,������')+'<font style="font-size:14px;color:#E40000;font-weight:bold;">'+$g('���[��ѯ]����¼��')+'</font></br></br>'+$g('�����Ҫ')+'<font style="font-size:14px;color:#E40000;font-weight:bold;">'+$g('��������ʵ������')+'</font>,'+$g('����[��]')+'</br>',
                            buttons: Ext.MessageBox.YESNO,
                            fn: function(btnSelect){
	                        	if (btnSelect=="yes"){
					             	Ext.MessageBox.show({
			                            title: $g('��ʾ'),
			                            msg: '<font style=";">'+$g('��������ʵ�����ݺ�,��¼�����ݽ���')+'<span style="font-size:14px;color:#E40000;font-weight:bold;">'+$g('���')+'</span>,'+$g('�Ƿ������')+'</font>',
			                            buttons: Ext.MessageBox.YESNO,
			                            fn:showCheckGr,
			                            icon: Ext.MessageBox.QUESTION
			                        });
		                        }
	                        },
                            icon: Ext.MessageBox.QUESTION
                        });
                    } //�Ƿ����ʵ������
                    else { create(gRowid, gInstwWin); }
                }
            }
        })
    }

    // ¼�밴ť
    var AddBT = new Ext.Toolbar.Button({
        text: $g('����'),
        tooltip: $g('������Ӽ�¼'),
        iconCls: 'page_add',
        width: 70,
        height: 30,
        handler: function() {
            CheckExistNO();
            //QueryDetail();
        }
    });

    function showCheckGr(btn) {
        if (btn == "yes") { create(gRowid, gInstwWin); }
    }

    // ��ѯ��ť
    var SearchBT = new Ext.Toolbar.Button({
        text: $g('��ѯ'),
        tooltip: $g('�����ѯ'),
        iconCls: 'page_find',
        width: 70,
        height: 30,
        handler: function() {
            if (talPanel.getActiveTab().id == '10') { QueryDetail(); }
            if (talPanel.getActiveTab().id == '20') { QueryDetailPc(); }
            if (talPanel.getActiveTab().id == '30') { QueryDetailYp(); }
            if (talPanel.getActiveTab().id == '40') { QueryDetailNoImp(); }
        }
    });

    // ��հ�ť
    var RefreshBT = new Ext.Toolbar.Button({
        text: $g('����'),
        tooltip: $g('�������'),
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
        Ext.getCmp("DHCStkCatGroup").setValue('');
        Ext.getCmp("StStkBin").setValue('');
        Ext.getCmp("EdStkBin").setValue('');
        //Ext.getCmp("Complete").setValue(false);
        Ext.getCmp("StkGrpType").setValue('');
        Ext.getCmp("PhaWindow").setValue('');
        Ext.getCmp("LocManaGrp").setValue('');
        InstDetailGrid.store.removeAll();
        InstDetailGrid.getView().refresh();
        InstDetailGridYp.store.removeAll();
        InstDetailGridPc.store.removeAll();
        InstDetailGridNoImp.store.removeAll();
        //InstDetailGridNoImp.getView().refresh();
    }

    var SaveBT = new Ext.Toolbar.Button({
        text: $g('����'),
        tooltip: $g('�������'),
        iconCls: 'page_save',
        width: 70,
        height: 30,
        handler: function() {
            if (talPanel.getActiveTab().id == '10') { save(); }
        }
    });

    //�����̵㵥����ϸ��Ϣ
    function QueryDetail() {
        var StkGrpId = Ext.getCmp('StkGrpType').getValue();
        var StkCatId = Ext.getCmp('DHCStkCatGroup').getValue();
        var PhaWinId = Ext.getCmp('PhaWindow').getValue();
        var ManaGrpId = Ext.getCmp('LocManaGrp').getValue();
        var size = StatuTabPagingToolbar.pageSize;
        var StStkBinId = Ext.getCmp('StStkBin').getValue();
        var EnStkBinId = Ext.getCmp('EdStkBin').getValue();
        var StkBinId = StStkBinId + "," + EnStkBinId
        gStrDetailParams = gRowid + '^' + ManaGrpId + '^' + StkGrpId + '^' + StkCatId + '^' + StkBinId + '^' + PhaWinId + '^' + inciRowid + '^' + InstkLocRowid;
        InstDetailStore.removeAll();
        //actiontype:'INStkTkItmWd',start:0,limit:size,sort:'stkbin',dir:'ASC',Params:gStrDetailParams
        InstDetailStore.setBaseParam('sort', 'stkbin');
        InstDetailStore.setBaseParam('dir', 'ASC');
        InstDetailStore.setBaseParam('Params', gStrDetailParams);
        InstDetailStore.setBaseParam('start', 0);
        InstDetailStore.setBaseParam('limit', size);
        InstDetailStore.setBaseParam('actiontype', 'INStkTkItmWdStkBin');
        InstDetailStore.load();
        inciRowid = ''
    }

    //�����̵㵥����ϸ��Ϣ������
    function QueryDetailPc() {
        var StkGrpId = Ext.getCmp('StkGrpType').getValue();
        var StkCatId = Ext.getCmp('DHCStkCatGroup').getValue();
        var PhaWinId = Ext.getCmp('PhaWindow').getValue();
        var ManaGrpId = Ext.getCmp('LocManaGrp').getValue();
        var size = StatuTabPagingToolbarPc.pageSize;
        var StStkBinId = Ext.getCmp('StStkBin').getValue();
        var EnStkBinId = Ext.getCmp('EdStkBin').getValue();
        var StkBinId = StStkBinId + "," + EnStkBinId
        var StkBinId = ""
        gStrDetailParams = gRowid + '^' + ManaGrpId + '^' + StkGrpId + '^' + StkCatId + '^' + StkBinId + '^' + PhaWinId + '^' + inciRowid;
        InstDetailStorePc.removeAll();
        //actiontype:'INStkTkItmWd',start:0,limit:size,sort:'stkbin',dir:'ASC',Params:gStrDetailParams
        InstDetailStorePc.setBaseParam('sort', 'stkbin');
        InstDetailStorePc.setBaseParam('dir', 'ASC');
        InstDetailStorePc.setBaseParam('Params', gStrDetailParams);
        InstDetailStorePc.setBaseParam('start', 0);
        InstDetailStorePc.setBaseParam('limit', size);
        InstDetailStorePc.setBaseParam('actiontype', 'INStkTkItmWdPc');
        InstDetailStorePc.load();
        inciRowid = ''

    }
    //�����̵㵥����ϸ��Ϣ��ҩƷ
    function QueryDetailYp() {
        var StkGrpId = Ext.getCmp('StkGrpType').getValue();
        var StkCatId = Ext.getCmp('DHCStkCatGroup').getValue();
        var PhaWinId = Ext.getCmp('PhaWindow').getValue();
        var ManaGrpId = Ext.getCmp('LocManaGrp').getValue();
        var size = StatuTabPagingToolbarPc.pageSize;
        var StStkBinId = Ext.getCmp('StStkBin').getValue();
        var EnStkBinId = Ext.getCmp('EdStkBin').getValue();
        var StkBinId = StStkBinId + "," + EnStkBinId
        var StkBinId = ""
        gStrDetailParams = gRowid + '^' + ManaGrpId + '^' + StkGrpId + '^' + StkCatId + '^' + StkBinId + '^' + PhaWinId + '^' + inciRowid;
        InstDetailStoreYp.removeAll();
        //actiontype:'INStkTkItmWd',start:0,limit:size,sort:'stkbin',dir:'ASC',Params:gStrDetailParams
        InstDetailStoreYp.setBaseParam('sort', 'stkbin');
        InstDetailStoreYp.setBaseParam('dir', 'ASC');
        InstDetailStoreYp.setBaseParam('Params', gStrDetailParams);
        InstDetailStoreYp.setBaseParam('start', 0);
        InstDetailStoreYp.setBaseParam('limit', size);
        InstDetailStoreYp.setBaseParam('actiontype', 'INStkTkItmWdYp');
        InstDetailStoreYp.load();
        inciRowid = ''

    }
    //�����̵㵥����ϸ��Ϣδ¼��
    function QueryDetailNoImp() {
        var StkGrpId = Ext.getCmp('StkGrpType').getValue();
        var StkCatId = Ext.getCmp('DHCStkCatGroup').getValue();
        var PhaWinId = Ext.getCmp('PhaWindow').getValue();
        var ManaGrpId = Ext.getCmp('LocManaGrp').getValue();
        var size = StatuTabPagingToolbar.pageSize;
        var StStkBinId = Ext.getCmp('StStkBin').getValue();
        var EnStkBinId = Ext.getCmp('EdStkBin').getValue();
        var StkBinId = StStkBinId + "," + EnStkBinId
        gStrDetailParams = gRowid + '^' + ManaGrpId + '^' + StkGrpId + '^' + StkCatId + '^' + StkBinId + '^' + PhaWinId + '^' + inciRowid + "^" + InstkLocRowid;
        InstDetailStoreNoImp.removeAll();
        //actiontype:'INStkTkItmWd',start:0,limit:size,sort:'stkbin',dir:'ASC',Params:gStrDetailParams
        InstDetailStoreNoImp.setBaseParam('sort', 'stkbin');
        InstDetailStoreNoImp.setBaseParam('dir', 'ASC');
        InstDetailStoreNoImp.setBaseParam('Params', gStrDetailParams);
        InstDetailStoreNoImp.setBaseParam('start', 0);
        InstDetailStoreNoImp.setBaseParam('limit', size);
        InstDetailStoreNoImp.setBaseParam('actiontype', 'INStkTkItmWdNoImp');
        InstDetailStoreNoImp.load();
        inciRowid = ''
    }

    function Select() {
        if (gRowid == null || gRowid == "") {
            return;
        }
        var mask = ShowLoadMask(Ext.getBody(), $g("���������Ժ�..."));
        Ext.Ajax.request({
            url: url,
            params: { actiontype: 'Select', Rowid: gRowid },
            method: 'post',
            success: function(response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    var info = jsonData.info;
                    if (info != "") {
                        var detail = info.split("^");
                        var InstNo = detail[0];
                        var StkGrpId = detail[17];
                        var StkGrpDesc = detail[24];
                        var StkCatId = detail[18];
                        var StkCatDesc = detail[19];
                        InstkLocRowid = detail[5];
                        Ext.getCmp("InstNo").setValue(InstNo);
                        Ext.getCmp("StkGrpType").setValue(StkGrpId);
                        addComboData(StkCatStore, StkCatId, StkCatDesc);
                        Ext.getCmp("DHCStkCatGroup").setValue(StkCatId);
                    }
                    //QueryDetail();	//��ѯ��ϸ��Ϣ
                }
            }

        });
    }
    //*����Ҽ��˵�,wyx,2013-11-18***
    var GridRowIndex = ""

    function ScanItmShow() {
        ScanItmQuery(GetRetRowid);
    }

    function EntryBatShow() {
        EntryBatQuery(GetInLocBt);
    }

    function GetRetRowid(retRowid) {
        inciRowid = retRowid;
        if (talPanel.getActiveTab().id == '10') { QueryDetail(); }
        if (talPanel.getActiveTab().id == '20') { QueryDetailPc(); }
        if (talPanel.getActiveTab().id == '30') { QueryDetailYp(); }
        if (talPanel.getActiveTab().id == '40') { QueryDetailNoImp(); }
    }

    function GetInLocBt(retValue) {
        var retstr = retValue.split("^")
        if (retstr[0] != '-1') {
            InsStkTk(retValue);

        }
    }
    /**
     * ����¼�������ҩƷ
     */

    function InsStkTk(retValue) {
        var retstr = retValue.split("^")
        var UserId = session['LOGON.USERID'];
        var mask = ShowLoadMask(Ext.getBody(), $g("���������Ժ�..."));
        Ext.Ajax.request({
            url: url,
            params: { actiontype: 'InsStTkInput', IncLocBt: retstr[0], Qty: retstr[1], InputUom: retstr[2], RowidM: gRowid, UserId: UserId, InstwWin: gInstwWin },
            //waitMsg:'������...',
            success: function(response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    //Select();		//��ѯ�̵㵥������Ϣ
                    QueryDetail(); //����ʵ���б�
                } else {
                    var ret = jsonData.info;
                    if (ret == '-1') { Msg.info("error", $g("RowidMΪ�գ�" )+ ret); } else if (ret == '-2') { Msg.info("error", $g("IncLocBtΪ�գ�") + ret); } else if (ret == '-3') { Msg.info("error", $g("SQL��ѯʧ�ܣ�") + ret); } else if (ret == '-4') { Msg.info("error", $g("���ڸ�����ҩƷ��") + ret); } else if (ret == '-5') { Msg.info("error", $g("instiΪ�գ�") + ret); } else { Msg.info("error", $g("��������ʧ�ܣ�") + ret); }
                }
            }
        });
    }



    //����ʵ������
    function save() {
        if (InstDetailGrid.activeEditor != null) {
            InstDetailGrid.activeEditor.completeEdit();
        }
        var rowCount = InstDetailStore.getCount();
        var ListDetail = '';
        for (var i = 0; i < rowCount; i++) {
            var rowData = InstDetailStore.getAt(i);
            //�������޸Ĺ�������
            if (rowData.dirty || rowData.data.newRecord) {
                var Parref = rowData.get('insti');
                var Rowid = rowData.get('instw');
                var incidesc = rowData.get('desc');
                var UserId = session['LOGON.USERID'];
                //modify 2014-12-04 wyx 
                var bQty = rowData.get('bcountQty'); //������λ����
                var pQty = rowData.get('pcountQty'); //��λ����
                if (bQty == "") {
                    bQty = 0;
                }
                if (pQty == "") {
                    pQty = 0;
                }
                if (bQty < 0 || pQty < 0) {
	                    Msg.info('warning', incidesc+$g(' ¼���ʵ����������С����!'));
	                    return;
	                }
                
                
                var CountUomId = rowData.get('uom');
                var StkBin = '';
                var PhaWin = Ext.getCmp('PhaWindow').getValue();
                var Detail = Parref + '^' + Rowid + '^' + UserId + '^' + "" + '^' + CountUomId + '^' + StkBin + '^' + PhaWin + '^' + bQty + "^" + pQty;
                if (incidesc != $g('�ϼ�')) {
                    if (ListDetail == '') {
                        ListDetail = Detail;
                    } else {
                        ListDetail = ListDetail + xRowDelim() + Detail;
                    }
                }
            }
        }
        if (ListDetail == '') {
            Msg.info('Warning', $g('û����Ҫ���������!'));
            return;
        }
        var mask = ShowLoadMask(Ext.getBody(), $g("���������Ժ�..."));
        Ext.Ajax.request({
            url: url,
            params: { actiontype: 'SaveTkItmWd', Params: ListDetail },
            method: 'post',
            //waitMsg:'������...',
            success: function(response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    Msg.info('success', $g('����ɹ�!'));
                    InstDetailStore.reload();
                    //QueryDetail();
                } else {
                    var ret = jsonData.info;
                    if (ret == '-1') {
                        Msg.info('warning', $g('û����Ҫ���������!'));
                    } else if (ret == '-2') {
                        Msg.info('error', $g('����ʧ��!'));
                    } else {
                        Msg.info('error', $g('�������ݱ���ʧ��:') + ret);
                    }
                }
            }
        });
    }
    //�����������ݲ���ʵ���б�
    function create(inst, instwWin) {
        if (inst == null || inst == '') {
            Msg.info('warning', $g('��ѡ���̵㵥'));
            return;
        }
        var UserId = session['LOGON.USERID'];
        var mask = ShowLoadMask(Ext.getBody(), $g("���������Ժ�..."));
        Ext.Ajax.request({
            url: url,
            params: { actiontype: 'CreateTkItmStkBinWd', Inst: inst, UserId: UserId, InstwWin: instwWin },
            //waitMsg:'������...',
            success: function(response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    Select(); //��ѯ�̵㵥������Ϣ
                    Msg.info('success', $g('���ӳɹ�!'));
                    InstDetailStore.reload();
                    //QueryDetail(inst);    //����ʵ���б�
                } else {
                    var ret = jsonData.info;
                    Msg.info("error", $g("��ȡʵ���б�ʧ�ܣ�") + ret);
                }
            }
        });
    }
    var nm = new Ext.grid.RowNumberer();
    var InstDetailGridCm = new Ext.grid.ColumnModel([nm,
        {
            header: "rowid",
            dataIndex: 'insti',
            width: 80,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: "inclb",
            dataIndex: 'inclb',
            width: 80,
            align: 'left',
            sortable: true,
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
            header: $g("���"),
            dataIndex: 'spec',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: $g('����'),
            dataIndex: 'batNo',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g('Ч��'),
            dataIndex: 'expDate',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g("��λ"),
            dataIndex: 'uomDesc',
            width: 60,
            align: 'left',
            sortable: true
        }, {
            header: $g('��������'),
            dataIndex: 'freQty',
            width: 80,
            align: 'right',
            sortable: true
        }, {
            header: $g('ʵ����(��ⵥλ)'),
            dataIndex: 'pcountQty',
            width: 80,
            align: 'left',
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
                            var pqty = field.getValue();
                            var record = InstDetailGrid.getStore().getAt(cell[0]);
                            if (pqty < 0) {
                                Msg.info('warning', $g('ʵ����������С����!'));
                                return;
                            }
                            var bqty = record.get("bcountQty")

                            var incifac = record.get("incifac")
                            var qty = pqty / incifac
                            var qty = bqty + qty
                            var SpAmt = Number(record.get("sp")).mul(qty);
                            var RpAmt = Number(record.get("rp")).mul(qty);
                            //record.set("countQty",qty);
                            record.set("rpamt", RpAmt);
                            record.set("spamt", SpAmt);
                            var Count = InstDetailGrid.getStore().getCount();

                            var row = cell[0] + 1;
                            if (row < rowCount) {
                                InstDetailGrid.startEditing(row, col);
                            }

                        }
                        if (keyCode == Ext.EventObject.UP) {
                            if (event.keyCode == 38) {
                                if (event.preventDefault) { event.preventDefault(); } else { event.keyCode = 40; }
                            }
                            var row = cell[0] - 1;
                            if (row >= 0) {
                                InstDetailGrid.getSelectionModel().select(row, col);
                                InstDetailGrid.startEditing(row, col);
                            }
                        }
                        if (keyCode == Ext.EventObject.DOWN) {
                            if (event.keyCode == 40) {
                                if (event.preventDefault) { event.preventDefault(); } else { event.keyCode = 40; }
                            }
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
            header: $g('��ⵥλ'),
            dataIndex: 'puomdesc',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: $g('ʵ������'),
            dataIndex: 'bcountQty',
            width: 80,
            align: 'right',
            sortable: true,
            editor: new Ext.form.NumberField({
                selectOnFocus: true,
                allowNegative: false,
                //allowBlank : false,
                listeners: {
                    'specialkey': function(field, e) {
                        var keyCode = e.getKey();
                        var col = GetColIndex(InstDetailGrid, 'bcountQty');
                        var cell = InstDetailGrid.getSelectionModel().getSelectedCell();
                        var rowCount = InstDetailGrid.getStore().getCount();
                        if (keyCode == Ext.EventObject.ENTER) {
                            var qty = field.getValue();
                            var record = InstDetailGrid.getStore().getAt(cell[0]);
                            if (qty < 0) {
                                Msg.info('warning', $g('ʵ����������С����!'));
                                return;
                            }
                            var incifac = record.get("incifac")
                            var pqty = record.get("pcountQty")
                            var pqty2 = pqty / incifac
                                //var pqty=Number(qty).mul(incifac)
                            var qty = qty + pqty2
                            var SpAmt = Number(record.get("sp")).mul(qty);
                            var RpAmt = Number(record.get("rp")).mul(qty);
                            //record.set("pcountQty",pqty)
                            record.set("rpamt", RpAmt);
                            record.set("spamt", SpAmt);
                            var Count = InstDetailGrid.getStore().getCount();



                            var row = cell[0] + 1;
                            if (row < rowCount) {
                                InstDetailGrid.startEditing(row, col);
                            }

                        }
                        if (keyCode == Ext.EventObject.UP) {
                            if (event.keyCode == 38) {
                                if (event.preventDefault) { event.preventDefault(); } else { event.keyCode = 38; }
                            }
                            var row = cell[0] - 1;
                            if (row >= 0) {
                                InstDetailGrid.getSelectionModel().select(row, col);
                                InstDetailGrid.startEditing(row, col);
                            }
                        }
                        if (keyCode == Ext.EventObject.DOWN) {
                            if (event.keyCode == 40) {
                                if (event.preventDefault) { event.preventDefault(); } else { event.keyCode = 40; }
                            }
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
            header: $g("��λ"),
            dataIndex: 'buomDesc',
            width: 60,
            align: 'left',
            sortable: true
        }, {
            header: $g('������(��)'),
            dataIndex: 'countQty',
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
            header: $g("������ҵ"),
            dataIndex: 'manf',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g('�ۼ�'),
            dataIndex: 'sp',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: $g('����'),
            dataIndex: 'rp',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: $g('�ۼ۽��'),
            dataIndex: 'spamt',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: $g('���۽��'),
            dataIndex: 'rpamt',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: $g('�����ۼ۽��'),
            dataIndex: 'freezespamt',
            width: 100,
            align: 'right',
            sortable: true
        }, {
            header: $g('���̽��۽��'),
            dataIndex: 'freezerpamt',
            width: 100,
            align: 'right',
            sortable: true
        }, {
            header: $g('��������'),
            dataIndex: 'diffQty',
            width: 100,
            align: 'right',
            sortable: true
        }, {
            header: $g('���۲��'),
            dataIndex: 'diffrpamt',
            width: 100,
            align: 'right',
            sortable: true
        }, {
            header: $g('�ۼ۲��'),
            dataIndex: 'diffspamt',
            width: 100,
            align: 'right',
            sortable: true
        }, {
            header: $g('ϵ��'),
            dataIndex: 'incifac',
            width: 80,
            align: 'left',
            sortable: true
        }
    ]);
    InstDetailGridCm.defaultSortable = true;

    var InstDetailGridPcCm = new Ext.grid.ColumnModel([nm, {
        header: "insti",
        dataIndex: 'insti',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: "inclb",
        dataIndex: 'inclb',
        width: 80,
        align: 'left',
        sortable: true,
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
        header: $g("���"),
        dataIndex: 'spec',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g('����'),
        dataIndex: 'batNo',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g('Ч��'),
        dataIndex: 'expDate',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g("��λ"),
        dataIndex: 'uomDesc',
        width: 60,
        align: 'left',
        sortable: true
    }, {
        header: $g('��������'),
        dataIndex: 'freQty',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: $g('ʵ������'),
        dataIndex: 'countQty',
        width: 80,
        align: 'right',
        sortable: true

    }, {
        header: $g('��������'),
        dataIndex: 'diffQty',
        width: 80,
        align: 'right',
        sortable: true

    }, {
        header: $g("��λ��"),
        dataIndex: 'stkbin',
        width: 100,
        align: 'left',
        sortable: true
    }]);
    InstDetailGridPcCm.defaultSortable = true;
    var InstDetailGridYpCm = new Ext.grid.ColumnModel([nm, {
        header: "inci",
        dataIndex: 'inci',
        width: 80,
        align: 'left',
        sortable: true,
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
        header: $g("���"),
        dataIndex: 'spec',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g("��λ"),
        dataIndex: 'uomDesc',
        width: 60,
        align: 'left',
        sortable: true
    }, {
        header: $g('ʵ������'),
        dataIndex: 'countQty',
        width: 80,
        align: 'right',
        sortable: true

    }, {
        header: $g('��������'),
        dataIndex: 'freQty',
        width: 80,
        align: 'right',
        sortable: true

    }, {
        header: $g('��������'),
        dataIndex: 'diffQty',
        width: 80,
        align: 'right',
        sortable: true

    }, {
        header: $g("��λ��"),
        dataIndex: 'stkbin',
        width: 100,
        align: 'left',
        sortable: true
    }]);
    InstDetailGridYpCm.defaultSortable = true;
    var InstDetailGridNoImpCm = new Ext.grid.ColumnModel([nm, {
            header: "rowid",
            dataIndex: 'insti',
            width: 80,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: "inclb",
            dataIndex: 'inclb',
            width: 80,
            align: 'left',
            sortable: true,
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
            header:$g("���"),
            dataIndex: 'spec',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: $g('����'),
            dataIndex: 'batNo',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g('Ч��'),
            dataIndex: 'expDate',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header:$g( "��λ"),
            dataIndex: 'uomDesc',
            width: 60,
            align: 'left',
            sortable: true
        }, {
            header: $g('��������'),
            dataIndex: 'freQty',
            width: 80,
            align: 'right',
            sortable: true
        }

        , {
            header: $g("��λ��"),
            dataIndex: 'stkbin',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g("������ҵ"),
            dataIndex: 'manf',
            width: 100,
            align: 'left',
            sortable: true
        }
    ]);

    InstDetailGridNoImpCm.defaultSortable = true;
    // ���ݼ�
    var InstDetailStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: url,
            method: "POST"
        }),
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: "results",
            id: "instw",
            fields: ["instw", "insti", "inclb", "code", "desc", "spec", "manf", "batNo", "expDate",
                "freQty", "uom", "uomDesc", "buom", "buomDesc", "rp", "sp", "bcountQty",
                "countDate", "countTime", "userName", "stkbin", "spamt", "rpamt", "puom", "puomdesc", "pcountQty", "incifac", "countQty",
                "freezespamt", "freezerpamt", "diffQty", "diffspamt", "diffrpamt"
            ]
        }),
        pruneModifiedRecords: true,
        remoteSort: true
    });

    // ���ݼ�
    var InstDetailStorePc = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: url,
            method: "POST"
        }),
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: "results",
            id: "instwPc",
            fields: ["insti", "inclb", "code", "desc", "spec", "manf", "batNo", "expDate",
                "freQty", "uom", "uomDesc", "buom", "buomDesc", "rp", "sp", "countQty", "diffQty", "stkbin"
            ]
        }),
        pruneModifiedRecords: true,
        remoteSort: true
    });

    // ���ݼ�
    var InstDetailStoreYp = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: url,
            method: "POST"
        }),
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: "results",
            id: "instwPc",
            fields: ["inci", "code", "desc", "spec", "manf",
                "uom", "uomDesc", "buom", "buomDesc", "rp", "sp", "countQty", "stkbin", "freQty", "diffQty"
            ]
        }),
        pruneModifiedRecords: true,
        remoteSort: true
    });

    // ���ݼ�
    var InstDetailStoreNoImp = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: url,
            method: "POST"
        }),
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: "results",
            id: "instw",
            fields: ["instw", "insti", "inclb", "code", "desc", "spec", "manf", "batNo", "expDate",
                "uom", "uomDesc", "buom", "buomDesc", "rp", "sp", "countQty",
                "countDate", "countTime", "userName", "stkbin", "freQty"
            ]
        }),
        pruneModifiedRecords: true,
        remoteSort: true
    })

    var StatuTabPagingToolbar = new Ext.PagingToolbar({
        store: InstDetailStore,
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
        afterPageText: $g("��{0}ҳ"),
        emptyMsg: $g("û������")
    });

    StatuTabPagingToolbar.addListener('beforechange', function(toolbar, params) {
        if (InstDetailGrid.activeEditor != null) {
            InstDetailGrid.activeEditor.completeEdit();
        }
        var records = InstDetailStore.getModifiedRecords();
        if (records.length > 0) {
            Msg.info("warning", $g("��ҳ���ݷ����仯�����ȱ��棡"));
            return false;
        }
    });

    var StatuTabPagingToolbarPc = new Ext.PagingToolbar({
        store: InstDetailStorePc,
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
        afterPageText: $g("��{0}ҳ"),
        emptyMsg: $g("û������")
    });

    var StatuTabPagingToolbarYp = new Ext.PagingToolbar({
        store: InstDetailStoreYp,
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
        afterPageText: $g("��{0}ҳ"),
        emptyMsg: $g("û������")
    });

    var StatuTabPagingToolbarNoImp = new Ext.PagingToolbar({
        store: InstDetailStoreNoImp,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: $g('��ǰ��¼ {0} -- {1} �� �� {2} ����¼'),
        emptyMsg: "No results to display",
        prevText:$g( "��һҳ"),
        nextText: $g("��һҳ"),
        refreshText: $g("ˢ��"),
        lastText: $g("���ҳ"),
        firstText: $g("��һҳ"),
        beforePageText: $g("��ǰҳ"),
        afterPageText: $g("��{0}ҳ"),
        emptyMsg: $g("û������")
    });

    var InstDetailGrid = new Ext.grid.EditorGridPanel({
        id: 'InstDetailGrid',
        cm: InstDetailGridCm,
        store: InstDetailStore,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.CellSelectionModel(), // wyx modify 2013-11-18��Ϊ��ģʽ
        loadMask: true,
        bbar: StatuTabPagingToolbar,
        clicksToEdit: 1,
        viewConfig: {
            getRowClass: function(record, rowIndex, rowParams, store) {
                var bcountqty = record.get("bcountQty");
                var pcountqty = record.get("pcountQty");
                var incidesc = record.get("desc");
                var diffQty = record.get("diffQty");
                var colorflag = "";
                if (incidesc == "�ϼ�") { return; }
                if (((bcountqty == "") || (bcountqty == null)) && ((pcountqty == "") || (bcountqty == null))) {
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
            var pqty = e.record.get("pcountQty")
            var instwd = e.record.get("instw")
            var returninfo = tkMakeServerCall("web.DHCST.INStkTkItmWd", "CacuInstwData", instwd, pqty, bqty)
            var returnarr = returninfo.split("^")
            e.record.set("countQty", returnarr[0]);
            e.record.set("rpamt", returnarr[1]);
            e.record.set("spamt", returnarr[2]);
            e.record.set("diffQty", returnarr[3]);
            e.record.set("diffrpamt", returnarr[4]);
            e.record.set("diffspamt", returnarr[5]);
            //e.record.dirty=false
            //e.record.commit(); 
        }
    })
    var InstDetailGridPc = new Ext.grid.GridPanel({
        id: 'InstDetailGridPc',
        region: 'center',
        cm: InstDetailGridPcCm,
        store: InstDetailStorePc,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        loadMask: true,
        bbar: StatuTabPagingToolbarPc,
        clicksToEdit: 1,
        viewConfig: {
            getRowClass: function(record, rowIndex, rowParams, store) {
                var countqty = record.get("countQty");
                var incidesc = record.get("desc");
                var diffQty = record.get("diffQty");
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
    var InstDetailGridYp = new Ext.grid.GridPanel({
        id: 'InstDetailGridYp',
        region: 'center',
        cm: InstDetailGridYpCm,
        store: InstDetailStoreYp,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        loadMask: true,
        bbar: StatuTabPagingToolbarYp,
        clicksToEdit: 1,
        viewConfig: {
            getRowClass: function(record, rowIndex, rowParams, store) {
                var countqty = record.get("countQty");
                var incidesc = record.get("desc");
                var diffQty = record.get("diffQty");
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
    var InstDetailGridNoImp = new Ext.grid.GridPanel({
        id: 'InstDetailGridNoImp',
        region: 'center',
        cm: InstDetailGridNoImpCm,
        store: InstDetailStoreNoImp,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        loadMask: true,
        bbar: StatuTabPagingToolbarNoImp,
        clicksToEdit: 1
    });

    /***
     **����Ҽ��˵�,wyx,2013-11-18***
     **/
    //�Ҽ��˵�����ؼ����� 
    var rightClick = new Ext.menu.Menu({
        id: 'rightClickCont',
        items: [{
            id: 'mnuScanItm1',
            handler: ScanItmShow,
            text: $g('������'),
            click: true

        }]
    });
    var rightClickDetail = new Ext.menu.Menu({
        id: 'rightClickContDetail',
        items: [{
                id: 'mnuScanItm2',
                handler: ScanItmShow,
                text: $g('������'),
                click: true

            }, {
                id: 'mnuEntryBat',
                handler: EntryBatShow,
                text: $g('¼����'),
                click: true,
                hidden: (gParam[0] == 'Y' ? false : true)
            }

        ]
    });

    function rightClickFn(grid, rowindex, e) {
        e.preventDefault();
        rightClick.showAt(e.getXY()); //��ȡ����
    }

    function rightClickDetailFn(grid, rowindex, e) {
        e.preventDefault();
        rightClickDetail.showAt(e.getXY()); //��ȡ����
    }
    InstDetailGrid.addListener('rowcontextmenu', rightClickDetailFn); //�Ҽ��˵�����ؼ����� 
    InstDetailGridPc.addListener('rowcontextmenu', rightClickFn); //�Ҽ��˵�����ؼ����� 
    InstDetailGridYp.addListener('rowcontextmenu', rightClickFn); //�Ҽ��˵�����ؼ�����
    InstDetailGridNoImp.addListener('rowcontextmenu', rightClickFn); //�Ҽ��˵�����ؼ�����

    var form = new Ext.form.FormPanel({
        labelwidth: 30,
        width: 400,
        labelAlign: 'right',
        frame: true,
        autoScroll: true,
        bodyStyle: 'padding:10px 0px 0px 0px;',
        style: 'padding:0 0 0 0;',
        tbar: [SearchBT, '-', RefreshBT, '-', AddBT, '-', SaveBT],
        items: [{
            xtype: 'fieldset',
            layout: 'column',
            bodyStyle: 'padding:0 0 0 0;',
            style: 'padding:5px 0 5 0;',
            items: [{
                columnWidth: 0.34,
                xtype: 'fieldset',
                labelWidth: 60,
                defaults: { width: 180, border: false },
                autoHeight: true,
                boderStyle: 'padding:0 0 0 0;',
                style: 'padding:0 0 0 0;',
                border: false,
                items: [LocManaGrp, StStkBin, EdStkBin]

            }, {
                columnWidth: 0.33,
                xtype: 'fieldset',
                labelWidth: 60,
                defaults: { width: 140, border: false },
                defaultType: 'textfield',
                autoHeight: true,
                border: false,
                style: 'padding:0 0 0 0;',
                items: [StkGrpType, DHCStkCatGroup]

            }, {
                columnWidth: 0.33,
                xtype: 'fieldset',
                labelWidth: 60,
                defaults: { width: 140, border: false },
                defaultType: 'textfield',
                autoHeight: true,
                border: false,
                style: 'padding:0 0 0 0;',
                items: [PhaWindow, InstNo]
            }]
        }, {
            xtype: 'fieldset',
            title: $g('ɨ������¼��'),
            layout: 'column',
            bodyStyle: 'padding:0 0 0 0;',
            style: 'padding:5px 0 5 0;',
            items: [{
                columnWidth: 0.33,
                xtype: 'fieldset',
                labelWidth: 60,
                defaults: { width: 180, border: false },
                autoHeight: true,
                boderStyle: 'padding:0 0 0 0;',
                style: 'padding:0 0 0 0;',
                border: false,
                items: [label]
            }]
        }]
    });

    // ҳǩ
    var talPanel = new Ext.TabPanel({
        activeTab: 0,
        deferredRender: true,
        items: [{
            activate: QueryDetail(),
            title: $g('ʵ����ϸ'),
            id: '10',
            layout: 'fit',
            region: "center",
            items: [InstDetailGrid],
            listeners: {
                'activate': function() {
                    QueryDetail();
                    activetabI = 1;
                }
            }
        }, {
            activate: QueryDetailPc(),
            title: $g('����Ԥ��(������)'),
            id: '20',
            layout: 'fit',
            region: "center",
            items: [InstDetailGridPc],
            listeners: {
                'activate': function() {
                    QueryDetailPc();
                    activetabI = 0;
                }
            }
        }, {
            activate: QueryDetailYp(),
            title: $g('����Ԥ��(��ҩƷ)'),
            id: '30',
            layout: 'fit',
            region: "center",
            items: [InstDetailGridYp],
            listeners: {
                'activate': function() {
                    QueryDetailYp();
                    activetabI = 0;
                }
            }
        }, {
            activate: QueryDetailNoImp(),
            title: $g('δ¼��ҩƷ(��ϸ)'),
            id: '40',
            layout: 'fit',
            region: "center",
            items: [InstDetailGridNoImp],
            listeners: {
                'activate': function() {
                    QueryDetailNoImp();
                    activetabI = 0;
                }
            }
        }]
    })

    // 5.2.ҳ�沼��
    var mainPanel = new Ext.Viewport({
        layout: 'border', //��񲼾�
        items: [{
            region: 'north',
            height: 180,
            title: $g('ʵ��:¼�뷽ʽ��(����λ����) [��ܰ��ʾ:���ȵ������,Ȼ��ѡ���λ��ѯ,�ٽ���¼��]'),
            layout: 'fit',
            items: [form]
        }, {
            region: 'center',
            layout: 'fit',
            items: [talPanel]
        }],
        renderTo: 'mainPanel'
    });
    Select();
})