// /����:   ʵ�̣�¼�뷽ʽһ�������������ݰ��������ʵ������
// /����:   ʵ�̣�¼�뷽ʽһ�������������ݰ��������ʵ������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.30
Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gStrDetailParams = '';
    var inciRowid = '';
    var url = DictUrl + 'instktkaction.csp';
    var logonLocId = session['LOGON.CTLOCID'];
    var logonUserId = session['LOGON.USERID'];
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
            'expand': function (combox) {
                LocManGrpStore.removeAll();
                LocManGrpStore.load({
                    params: {
                        start: 0,
                        limit: 20,
                        locId: InstkLocRowid
                    }
                });
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
        disabled: true,
        allowBlank: true,
        triggerAction: 'all',
        emptyText: $g('ʵ�̴���...'),
        listeners: {
            'beforequery': function (e) {
                this.store.removeAll();
                this.store.setBaseParam('LocId', InstkLocRowid);
                this.store.load({
                    params: {
                        start: 0,
                        limit: 99
                    }
                });
            }
        }
    });
    INStkTkWindowStore.load({
        params: {
            start: 0,
            limit: 99,
            'LocId': InstkLocRowid
        },
        callback: function () {
            Ext.getCmp("PhaWindow").setValue(gInstwWin);
        }
    });

    var StkGrpType = new Ext.ux.StkGrpComboBox({
        id: 'StkGrpType',
        name: 'StkGrpType',
        StkType: App_StkTypeCode, //��ʶ��������
        LocId: logonLocId,
        UserId: logonUserId,
        anchor: '90%',
        width: 140
    });

    var DHCStkCatGroup = new Ext.form.ComboBox({
        fieldLabel: $g('������'),
        id: 'DHCStkCatGroup',
        name: 'DHCStkCatGroup',
        anchor: '90%',
        width: 140,
        listWidth: 180,
        store: StkCatStore,
        valueField: 'RowId',
        displayField: 'Description',
        allowBlank: true,
        typeAhead: false,
        selectOnFocus: true,
        forceSelection: true,
        minChars: 1,
        valueNotFoundText: '',
        pageSize: 20,
        listeners: {
            'beforequery': function (e) {
                var stkgrpid = Ext.getCmp("StkGrpType").getValue();
                StkCatStore.removeAll();
                StkCatStore.load({
                    params: {
                        StkGrpId: stkgrpid,
                        start: 0,
                        limit: 20
                    }
                });

            }
        }
    });

    var StkBin = new Ext.form.ComboBox({
        fieldLabel: $g('��λ'),
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
            'beforequery': function (e) {
                LocStkBinStore.removeAll();
                LocStkBinStore.setBaseParam('LocId', InstkLocRowid);
                LocStkBinStore.setBaseParam('Desc', this.getRawValue());
                LocStkBinStore.load({
                    params: {
                        start: 0,
                        limit: 20
                    }
                });
            }
        }
    });

    //�̵㵥��
    var InstNo = new Ext.form.TextField({
        id: 'InstNo',
        name: 'InstNo',
        fieldLabel: $g('�̵㵥��'),
        anchor: '90%',
        width: 140,
        disabled: true
    });

    // ��ѯ��ť
    var SearchBT = new Ext.Toolbar.Button({
        text: $g('��ѯ'),
        tooltip: $g('�����ѯ'),
        iconCls: 'page_find',
        width: 70,
        height: 30,
        handler: function () {
            QueryDetail();
        }
    });

    //����δ��������������
    var SetDefaultBT2 = new Ext.Toolbar.Button({
        text: $g('����δ��������������'),
        tooltip: $g('�������δ��������������'),
        iconCls: 'page_gear',
        width: 70,
        height: 30,
        handler: function () {
            var ss = Ext.Msg.show({
                title: $g('��ʾ'),
                msg: $g('����δ��ʵ�����������������޸Ĵ��̵㵥����δ¼��ļ�¼���Ƿ������'),
                buttons: Ext.Msg.YESNO,
                fn: function (b, t, o) {
                    if (b == 'yes') {
                        SetDefaultQty(2);
                    }
                },
                icon: Ext.MessageBox.QUESTION
            });
        }
    });
	function callback(but,txt){
		if(but == "ok") {
			if(txt != "ʵ��Ϊ0"){
				Msg.info('error', $g('����ȷ����Ϣ�������������룡'));
				Ext.Msg.prompt($g("ϵͳ��ʾ"),$g("ʵ��Ϊ0������Ӱ��ϴ�������>>>ʵ��Ϊ0<<<��ȷ�ϲ���"),callback);
			}
			else{
				SetDefaultQty(1);
			}
		}
	}
    //����δ��������0
    var SetDefaultBT = new Ext.Toolbar.Button({
        text: $g('����δ��������0'),
        tooltip: $g('�������δ��������0'),
        iconCls: 'page_gear',
        width: 70,
        height: 30,
        handler: function () {
	        Ext.Msg.prompt($g("ϵͳ��ʾ"),$g("ʵ��Ϊ0������Ӱ��ϴ�������>>>ʵ��Ϊ0<<<��ȷ�ϲ���"),callback);
           /* var ss = Ext.Msg.show({
                title: $g('��ʾ'),
                msg: $g('����δ��ʵ��������0���޸Ĵ��̵㵥����δ¼��ļ�¼���Ƿ������'),
                buttons: Ext.Msg.YESNO,
                fn: function (b, t, o) {
                    if (b == 'yes') {
                        SetDefaultQty(1);
                    }
                },
                icon: Ext.MessageBox.QUESTION
            });
            */
        }
    });

    //����δ��ʵ����
    function SetDefaultQty(flag) {
        if (gRowid == '') {
            Msg.info('Warning', $g('û��ѡ�е��̵㵥��'));
            return;
        }
        var InstwWin = Ext.getCmp("PhaWindow").getValue();
        var UserId = session['LOGON.USERID'];
        var mask = ShowLoadMask(Ext.getBody(), $g("���������Ժ�..."));
        Ext.Ajax.request({
            url: url,
            params: {
                actiontype: 'SetDefaultQty',
                Inst: gRowid,
                UserId: UserId,
                Flag: flag,
                InstwWin: InstwWin
            },
            method: 'post',
            waitMsg: $g('������...'),
            success: function (response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    Msg.info('success', $g('�ɹ�!'));
                    QueryDetail();
                } else {
                    var ret = jsonData.info;
                    Msg.info('error', $g('����δ���¼ʵ����ʧ��:') + ret);
                }
            }
        });
    }

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
        Ext.getCmp("DHCStkCatGroup").setValue('');
        Ext.getCmp("StkBin").setValue('');
        //Ext.getCmp("Complete").setValue(false);
        Ext.getCmp("StkGrpType").setValue('');
        Ext.getCmp("PhaWindow").setValue('');
        Ext.getCmp("LocManaGrp").setValue('');
        Ext.getCmp("M_InciDesc").setValue('');
        inciRowid = '';
        InstDetailGrid.store.removeAll();
        InstDetailGrid.getView().refresh();
    }

    var SaveBT = new Ext.Toolbar.Button({
        text: $g('����'),
        tooltip: $g('�������'),
        iconCls: 'page_save',
        width: 70,
        height: 30,
        handler: function () {
            save();
        }
    });
    //����δ��������������
    var AddItmBT = new Ext.Toolbar.Button({
        text: $g('��������'),
        tooltip: $g('�������̵㵥�ڲ����ڵ�����'),
        iconCls: 'page_add',
        width: 70,
        height: 30,
        handler: function () {
            AddItmQuery();
        }
    });
    //*����Ҽ��˵�,wyx,2013-11-18***
    var GridRowIndex = ""
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
                var incidesc = rowData.get('desc');
                var Rowid = rowData.get('instw');
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

                var CountUomId = rowData.get('uom'); //������λ
                var StkBin = '';
                var PhaWin = Ext.getCmp('PhaWindow').getValue();
                var Detail = Parref + '^' + Rowid + '^' + UserId + '^' + "" + '^' + CountUomId + '^' + StkBin + '^' + PhaWin + '^' + bQty + "^" + pQty;
                if (incidesc != '�ϼ�') {
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
            params: {
                actiontype: 'SaveTkItmWd',
                Params: ListDetail
            },
            method: 'post',
            waitMsg: $g('������...'),
            success: function (response, opt) {
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
            params: {
                actiontype: 'CreateTkItmWd',
                Inst: inst,
                UserId: UserId,
                InstwWin: instwWin
            },
            waitMsg: $g('������...'),
            success: function (response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    Select(); //��ѯ�̵㵥������Ϣ
                    //QueryDetail(inst);    //����ʵ���б�
                } else {
                    var ret = jsonData.info;
                    Msg.info("error", $g("��ȡʵ���б�ʧ�ܣ�") + ret);
                }
            }
        });
    }

    //�����̵㵥����ϸ��Ϣ
    function QueryDetail() {
        //��ѯ�̵㵥��ϸ
        var StkGrpId = Ext.getCmp('StkGrpType').getValue();
        var StkCatId = Ext.getCmp('DHCStkCatGroup').getValue();
        var StkBinId = Ext.getCmp('StkBin').getValue();
        var PhaWinId = Ext.getCmp('PhaWindow').getValue();
        var ManaGrpId = Ext.getCmp('LocManaGrp').getValue();
        var size = StatuTabPagingToolbar.pageSize;
        gStrDetailParams = gRowid + '^' + ManaGrpId + '^' + StkGrpId + '^' + StkCatId + '^' + StkBinId + '^' + PhaWinId + '^' + inciRowid;
        InstDetailStore.removeAll();
        InstDetailStore.setBaseParam('sort', 'rowid');
        InstDetailStore.setBaseParam('dir', 'ASC');
        InstDetailStore.setBaseParam('Params', gStrDetailParams);
        InstDetailStore.setBaseParam('start', 0);
        InstDetailStore.setBaseParam('limit', size);
        InstDetailStore.setBaseParam('actiontype', 'INStkTkItmWd');
        InstDetailStore.load({
            callback: function (o, response, success) {
                if (success == false) {
                    Ext.MessageBox.alert($g("��ѯ����"), InstDetailStore.reader.jsonData.Error);
                }
            }
        });
        inciRowid = '';
    }

    function Select() {
        if (gRowid == null || gRowid == "") {
            return;
        }
        var mask = ShowLoadMask(Ext.getBody(), $g("���������Ժ�..."));
        Ext.Ajax.request({
            url: url,
            params: {
                actiontype: 'Select',
                Rowid: gRowid
            },
            method: 'post',
            success: function (response, opt) {
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
                    QueryDetail(); //��ѯ��ϸ��Ϣ
                }
            }

        });
    }
    // ��С��1����ֵ��0�����������ֵ��ֵ����
    function SetNumber(val,meta){
			//if (val=="����������Ч��¼")
			//meta.css='classRed';
			var newnum=parseFloat(val)
			if(!newnum) newnum=val
			else newnum=Number(val) 
			
			return newnum
		
		}

    var nm = new Ext.grid.RowNumberer();
    var InstDetailGridCm = new Ext.grid.ColumnModel([nm, {
        header: "rowid",
        dataIndex: 'instw',
        width: 80,
        align: 'left',
        sortable: true,
        hidden: true
    }, {
        header: "parref",
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
        header: $g('��λ��'),
        dataIndex: 'stkbin',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g('����'),
        dataIndex: 'code',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g("����"),
        dataIndex: 'desc',
        width: 225,
        align: 'left',
        sortable: true
    }, {
        header: $g("���"),
        dataIndex: 'spec',
        width: 100,
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
            allowBlank: false,
            selectOnFocus: true,
            listeners: {
                'specialkey': function (field, e) {
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
                        if (event.keyCode == 38) { //��ֹIE11Ĭ���¼����µ����¼������Զ�startedit,yunhaibao20151123
                            if (event.preventDefault) {
                                event.preventDefault();
                            } else {
                                event.keyCode = 38;
                            }
                        }
                        var row = cell[0] - 1;
                        if (row >= 0) {
                            InstDetailGrid.getSelectionModel().select(row, col);
                            InstDetailGrid.startEditing(row, col);
                        }
                    }
                    if (keyCode == Ext.EventObject.DOWN) {
                        if (event.keyCode == 40) {
                            if (event.preventDefault) {
                                event.preventDefault();
                            } else {
                                event.keyCode = 40;
                            }
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
            allowBlank: false,
            listeners: {
                'specialkey': function (field, e) {
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
                            if (event.preventDefault) {
                                event.preventDefault();
                            } else {
                                event.keyCode = 38;
                            }
                        }
                        var row = cell[0] - 1;
                        if (row >= 0) {
                            InstDetailGrid.getSelectionModel().select(row, col);
                            InstDetailGrid.startEditing(row, col);
                        }
                    }
                    if (keyCode == Ext.EventObject.DOWN) {
                        if (event.keyCode == 40) {
                            if (event.preventDefault) {
                                event.preventDefault();
                            } else {
                                event.keyCode = 40;
                            }
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
        sortable: true,
        renderer:SetNumber
    }, {
        header: $g("������ҵ"),
        dataIndex: 'manf',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g('ʵ������'),
        dataIndex: 'countDate',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g("ʵ��ʱ��"),
        dataIndex: 'countTime',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g('ʵ����'),
        dataIndex: 'userName',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g('�ۼ�'),
        dataIndex: 'sp',
        width: 80,
        align: 'left',
        sortable: true,
        renderer:SetNumber
    }, {
        header: $g('����'),
        dataIndex: 'rp',
        width: 80,
        align: 'left',
        sortable: true,
        renderer:SetNumber
        
    }, {
        header: $g('�ۼ۽��'),
        dataIndex: 'spamt',
        width: 100,
        align: 'right',
        sortable: true,
        renderer:SetNumber
    }, {
        header: $g('���۽��'),
        dataIndex: 'rpamt',
        width: 100,
        align: 'right',
        sortable: true,
        renderer:SetNumber
    }, {
        header: $g('�����ۼ۽��'),
        dataIndex: 'freezespamt',
        width: 100,
        align: 'right',
        sortable: true,
        renderer:SetNumber
    }, {
        header: $g('���̽��۽��'),
        dataIndex: 'freezerpamt',
        width: 100,
        align: 'right',
        sortable: true,
        renderer:SetNumber
    }, {
        header: $g('��������'),
        dataIndex: 'diffQty',
        width: 100,
        align: 'right',
        sortable: true,
        renderer:SetNumber
    }, {
        header: $g('���۲��'),
        dataIndex: 'diffrpamt',
        width: 100,
        align: 'right',
        sortable: true,
        renderer:SetNumber
    }, {
        header: $g('�ۼ۲��'),
        dataIndex: 'diffspamt',
        width: 100,
        align: 'right',
        sortable: true,
        renderer:SetNumber
    }, {
        header: $g('ϵ��'),
        dataIndex: 'incifac',
        width: 80,
        align: 'left',
        sortable: true
    }]);
    InstDetailGridCm.defaultSortable = true;

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
            fields: ["instw", "insti", "inclb", "inci", "code", "desc", "spec", "manf", "batNo", "expDate",
                "freQty", "uom", "uomDesc", "buom", "buomDesc", "rp", "sp", "bcountQty",
                "countDate", "countTime", "userName", "stkbin", "spamt", "rpamt", "puom", "puomdesc",
                "pcountQty", "incifac", "countQty", "freezespamt", "freezerpamt", "diffQty", "diffspamt", "diffrpamt"
            ]
        }),
        pruneModifiedRecords: true,
        remoteSort: true
    });

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

    StatuTabPagingToolbar.addListener('beforechange', function (toolbar, params) {
        if (InstDetailGrid.activeEditor != null) {
            InstDetailGrid.activeEditor.completeEdit();
        }
        var records = InstDetailStore.getModifiedRecords();
        if (records.length > 0) {
            Msg.info("warning", $g("��ҳ���ݷ����仯�����ȱ��棡"));
            return false;
        }
    });
    var M_InciDesc = new Ext.form.TextField({
        fieldLabel: $g('ҩƷ����'),
        id: 'M_InciDesc',
        name: 'M_InciDesc',
        emptyText: $g('ҩƷ����...'),
        width: 300,
        listeners: {
            specialkey: function (field, e) {
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
                    GetPhaOrderLookUp(field.getValue(), stktype, App_StkTypeCode, "", "N", "0", "", getDrugList);
                }
            }
        }
    })

    function getDrugList(record) {
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

    var InstDetailGrid = new Ext.grid.EditorGridPanel({
        id: 'InstDetailGrid',
        region: 'center',
        cm: InstDetailGridCm,
        store: InstDetailStore,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.CellSelectionModel(),
        loadMask: true,
        bbar: StatuTabPagingToolbar,
        clicksToEdit: 1,
        loadMask: true,
        viewConfig: {
            getRowClass: function (record, rowIndex, rowParams, store) {
                var bcountqty = record.get("bcountQty");
                var pcountqty = record.get("pcountQty");
                var incidesc = record.get("desc");
                var diffQty = record.get("diffQty");
                var colorflag = "";
                if (incidesc == "�ϼ�") {
                    return;
                }
                if (((bcountqty == "") || (bcountqty == null)) && ((pcountqty == "") || (bcountqty == null))) {
                    return; //δ�����ɫ
                }
                if (Number(diffQty) > 0) {
                    colorflag = "1";
                } else if (Number(diffQty) < 0) {
                    colorflag = "-1";
                }
                switch (colorflag) {
                    case "1":
                        return 'classAquamarine';
                        break;
                    case "-1":
                        return 'classSalmon';
                        break;
                }
            }
        },
        tbar: [M_InciDesc]
    });

    ///yunhaibao,20151123,���޸ĺ��������Ϣ,��̨����
    InstDetailGrid.on('afteredit', function (e) {
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
    });

    //*����Ҽ��˵�,wyx,2013-11-18*** 
    var form = new Ext.form.FormPanel({
        labelWidth: 60,
        labelAlign: 'right',
        frame: true,
        tbar: [SearchBT, '-', RefreshBT, '-', SaveBT, '-', SetDefaultBT, '-', SetDefaultBT2, '-', AddItmBT],
        items: [{
            xtype: 'fieldset',
            title: $g('��ѯ����'),
            layout: 'column',
            style: DHCSTFormStyle.FrmPaddingV,
            items: [{
                columnWidth: 0.34,
                xtype: 'fieldset',
                labelWidth: 60,
                defaults: {
                    width: 180,
                    border: false
                }, // Default config options for child items
                border: false,
                items: [LocManaGrp, StkBin]

            }, {
                columnWidth: 0.33,
                xtype: 'fieldset',
                labelWidth: 60,
                defaults: {
                    width: 140,
                    border: false
                }, // Default config options for child items
                border: false,
                items: [StkGrpType, DHCStkCatGroup]

            }, {
                columnWidth: 0.33,
                xtype: 'fieldset',
                labelWidth: 60,
                defaults: {
                    width: 140,
                    border: false
                }, // Default config options for child items
                border: false,
                items: [PhaWindow, InstNo]

            }]
        }]
    });

    // 5.2.ҳ�沼��
    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: [{
            region: 'north',
            height: DHCSTFormStyle.FrmHeight(2),
            title: $g('ʵ�̣�¼�뷽ʽһ(���������ʵ����)'),
            layout: 'fit',
            items: [form]
        }, {
            region: 'center',
            layout: 'fit',
            items: [InstDetailGrid]
        }],
        renderTo: 'mainPanel'
    });

    //�Զ������̵㵥
    create(gRowid, gInstwWin);
})