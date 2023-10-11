// /名称: 实盘：录入方式四（按货位批次录入方式）
// /描述: 实盘：录入方式四（按货位批次录入方式）
// /编写者：zhangdongmei
// /编写日期: 2012.09.05
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gStrDetailParams = '';
    var url = DictUrl + 'instktkaction.csp';
    var inciRowid = "";
    var activetabI = 0;
    //wyx add参数配置 2013-11-28
    if (gParam.length < 1) {
        GetParam(); //初始化参数配置

    }
    var LocManaGrp = new Ext.form.ComboBox({
        fieldLabel: $g('管理组'),
        id: 'LocManaGrp',
        name: 'LocManaGrp',
        anchor: '90%',
        width: 140,
        store: LocManGrpStore,
        valueField: 'RowId',
        displayField: 'Description',
        allowBlank: true,
        triggerAction: 'all',
        emptyText: $g('管理组...'),
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
        fieldLabel: $g('实盘窗口'),
        id: 'PhaWindow',
        name: 'PhaWindow',
        anchor: '90%',
        store: INStkTkWindowStore,
        valueField: 'RowId',
        displayField: 'Description',
        emptyText: $g('实盘窗口...'),
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
        StkType: App_StkTypeCode, //标识类组类型
        anchor: '90%',
        width: 140
    });

    StkGrpType.on('change', function() {
        Ext.getCmp("StkGrpType").getValue();;
    });

    var DHCStkCatGroup = new Ext.ux.ComboBox({
        fieldLabel: $g('库存分类'),
        id: 'DHCStkCatGroup',
        name: 'DHCStkCatGroup',
        store: StkCatStore,
        valueField: 'RowId',
        displayField: 'Description',
        params: { StkGrpId: 'StkGrpType' }
    });

    var StStkBin = new Ext.form.ComboBox({
        fieldLabel: $g('起始货位'),
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
        fieldLabel: $g('截止货位'),
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
        fieldLabel: $g('条码'),
        id: 'label',
        name: 'label',
        anchor: '90%'
    });

    var InstNo = new Ext.form.TextField({
        id: 'InstNo',
        name: 'InstNo',
        fieldLabel: $g('盘点单号'),
        anchor: '90%',
        width: 140,
        disabled: true
    });

    //是否存在实盘数据
    function CheckExistNO() {
        if (gRowid == null || gRowid == "") {
            return;
        }
        var phaWindow=Ext.getCmp("PhaWindow").getValue();
        var retflag = 0
        var mask = ShowLoadMask(Ext.getBody(), $g("处理中请稍候..."));
        Ext.Ajax.request({
            url: url,
            async: true, //同步请求数据
            params: { actiontype: 'CheckExist', Rowid: gRowid,PhaWinow:phaWindow },
            method: 'post',
            success: function(response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    retflag = jsonData.info;
                    if (retflag != "0") {
                        Ext.MessageBox.show({
                            title: $g('提示'),
                            msg: '</br>'+$g('已有实盘数据,您可以')+'<font style="font-size:14px;color:#E40000;font-weight:bold;">'+$g('点击[查询]继续录入')+'</font></br></br>'+$g('如果需要')+'<font style="font-size:14px;color:#E40000;font-weight:bold;">'+$g('重新生成实盘数据')+'</font>,'+$g('请点击[是]')+'</br>',
                            buttons: Ext.MessageBox.YESNO,
                            fn: function(btnSelect){
	                        	if (btnSelect=="yes"){
					             	Ext.MessageBox.show({
			                            title: $g('提示'),
			                            msg: '<font style=";">'+$g('重新生成实盘数据后,已录入数据将被')+'<span style="font-size:14px;color:#E40000;font-weight:bold;">'+$g('清空')+'</span>,'+$g('是否继续？')+'</font>',
			                            buttons: Ext.MessageBox.YESNO,
			                            fn:showCheckGr,
			                            icon: Ext.MessageBox.QUESTION
			                        });
		                        }
	                        },
                            icon: Ext.MessageBox.QUESTION
                        });
                    } //是否存在实盘数据
                    else { create(gRowid, gInstwWin); }
                }
            }
        })
    }

    // 录入按钮
    var AddBT = new Ext.Toolbar.Button({
        text: $g('增加'),
        tooltip: $g('点击增加记录'),
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

    // 查询按钮
    var SearchBT = new Ext.Toolbar.Button({
        text: $g('查询'),
        tooltip: $g('点击查询'),
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

    // 清空按钮
    var RefreshBT = new Ext.Toolbar.Button({
        text: $g('清屏'),
        tooltip: $g('点击清屏'),
        iconCls: 'page_clearscreen',
        width: 70,
        height: 30,
        handler: function() {
            clearData();
        }
    });

    /**
     * 清空方法
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
        text: $g('保存'),
        tooltip: $g('点击保存'),
        iconCls: 'page_save',
        width: 70,
        height: 30,
        handler: function() {
            if (talPanel.getActiveTab().id == '10') { save(); }
        }
    });

    //查找盘点单及明细信息
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

    //查找盘点单及明细信息按批次
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
    //查找盘点单及明细信息按药品
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
    //查找盘点单及明细信息未录入
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
        var mask = ShowLoadMask(Ext.getBody(), $g("处理中请稍候..."));
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
                    //QueryDetail();	//查询明细信息
                }
            }

        });
    }
    //*添加右键菜单,wyx,2013-11-18***
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
     * 保存录入的批次药品
     */

    function InsStkTk(retValue) {
        var retstr = retValue.split("^")
        var UserId = session['LOGON.USERID'];
        var mask = ShowLoadMask(Ext.getBody(), $g("处理中请稍候..."));
        Ext.Ajax.request({
            url: url,
            params: { actiontype: 'InsStTkInput', IncLocBt: retstr[0], Qty: retstr[1], InputUom: retstr[2], RowidM: gRowid, UserId: UserId, InstwWin: gInstwWin },
            //waitMsg:'处理中...',
            success: function(response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    //Select();		//查询盘点单主表信息
                    QueryDetail(); //查找实盘列表
                } else {
                    var ret = jsonData.info;
                    if (ret == '-1') { Msg.info("error", $g("RowidM为空：" )+ ret); } else if (ret == '-2') { Msg.info("error", $g("IncLocBt为空：") + ret); } else if (ret == '-3') { Msg.info("error", $g("SQL查询失败：") + ret); } else if (ret == '-4') { Msg.info("error", $g("存在该批次药品：") + ret); } else if (ret == '-5') { Msg.info("error", $g("insti为空：") + ret); } else { Msg.info("error", $g("保存批次失败：") + ret); }
                }
            }
        });
    }



    //保存实盘数据
    function save() {
        if (InstDetailGrid.activeEditor != null) {
            InstDetailGrid.activeEditor.completeEdit();
        }
        var rowCount = InstDetailStore.getCount();
        var ListDetail = '';
        for (var i = 0; i < rowCount; i++) {
            var rowData = InstDetailStore.getAt(i);
            //新增或修改过的数据
            if (rowData.dirty || rowData.data.newRecord) {
                var Parref = rowData.get('insti');
                var Rowid = rowData.get('instw');
                var incidesc = rowData.get('desc');
                var UserId = session['LOGON.USERID'];
                //modify 2014-12-04 wyx 
                var bQty = rowData.get('bcountQty'); //基本单位数量
                var pQty = rowData.get('pcountQty'); //大单位数量
                if (bQty == "") {
                    bQty = 0;
                }
                if (pQty == "") {
                    pQty = 0;
                }
                if (bQty < 0 || pQty < 0) {
	                    Msg.info('warning', incidesc+$g(' 录入的实盘数量不能小于零!'));
	                    return;
	                }
                
                
                var CountUomId = rowData.get('uom');
                var StkBin = '';
                var PhaWin = Ext.getCmp('PhaWindow').getValue();
                var Detail = Parref + '^' + Rowid + '^' + UserId + '^' + "" + '^' + CountUomId + '^' + StkBin + '^' + PhaWin + '^' + bQty + "^" + pQty;
                if (incidesc != $g('合计')) {
                    if (ListDetail == '') {
                        ListDetail = Detail;
                    } else {
                        ListDetail = ListDetail + xRowDelim() + Detail;
                    }
                }
            }
        }
        if (ListDetail == '') {
            Msg.info('Warning', $g('没有需要保存的数据!'));
            return;
        }
        var mask = ShowLoadMask(Ext.getBody(), $g("处理中请稍候..."));
        Ext.Ajax.request({
            url: url,
            params: { actiontype: 'SaveTkItmWd', Params: ListDetail },
            method: 'post',
            //waitMsg:'处理中...',
            success: function(response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    Msg.info('success', $g('保存成功!'));
                    InstDetailStore.reload();
                    //QueryDetail();
                } else {
                    var ret = jsonData.info;
                    if (ret == '-1') {
                        Msg.info('warning', $g('没有需要保存的数据!'));
                    } else if (ret == '-2') {
                        Msg.info('error', $g('保存失败!'));
                    } else {
                        Msg.info('error', $g('部分数据保存失败:') + ret);
                    }
                }
            }
        });
    }
    //根据帐盘数据插入实盘列表
    function create(inst, instwWin) {
        if (inst == null || inst == '') {
            Msg.info('warning', $g('请选择盘点单'));
            return;
        }
        var UserId = session['LOGON.USERID'];
        var mask = ShowLoadMask(Ext.getBody(), $g("处理中请稍候..."));
        Ext.Ajax.request({
            url: url,
            params: { actiontype: 'CreateTkItmStkBinWd', Inst: inst, UserId: UserId, InstwWin: instwWin },
            //waitMsg:'处理中...',
            success: function(response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    Select(); //查询盘点单主表信息
                    Msg.info('success', $g('增加成功!'));
                    InstDetailStore.reload();
                    //QueryDetail(inst);    //查找实盘列表
                } else {
                    var ret = jsonData.info;
                    Msg.info("error", $g("提取实盘列表失败：") + ret);
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
            header: $g('代码'),
            dataIndex: 'code',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: $g("名称"),
            dataIndex: 'desc',
            width: 200,
            align: 'left',
            sortable: true
        }, {
            header: $g("规格"),
            dataIndex: 'spec',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: $g('批号'),
            dataIndex: 'batNo',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g('效期'),
            dataIndex: 'expDate',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g("单位"),
            dataIndex: 'uomDesc',
            width: 60,
            align: 'left',
            sortable: true
        }, {
            header: $g('冻结数量'),
            dataIndex: 'freQty',
            width: 80,
            align: 'right',
            sortable: true
        }, {
            header: $g('实盘数(入库单位)'),
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
                                Msg.info('warning', $g('实盘数量不能小于零!'));
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
            header: $g('入库单位'),
            dataIndex: 'puomdesc',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: $g('实盘数量'),
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
                                Msg.info('warning', $g('实盘数量不能小于零!'));
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
            header: $g("单位"),
            dataIndex: 'buomDesc',
            width: 60,
            align: 'left',
            sortable: true
        }, {
            header: $g('总数量(基)'),
            dataIndex: 'countQty',
            width: 80,
            align: 'right',
            sortable: true
        }, {
            header: $g("货位码"),
            dataIndex: 'stkbin',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g("生产企业"),
            dataIndex: 'manf',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g('售价'),
            dataIndex: 'sp',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: $g('进价'),
            dataIndex: 'rp',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: $g('售价金额'),
            dataIndex: 'spamt',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: $g('进价金额'),
            dataIndex: 'rpamt',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: $g('账盘售价金额'),
            dataIndex: 'freezespamt',
            width: 100,
            align: 'right',
            sortable: true
        }, {
            header: $g('账盘进价金额'),
            dataIndex: 'freezerpamt',
            width: 100,
            align: 'right',
            sortable: true
        }, {
            header: $g('差异数量'),
            dataIndex: 'diffQty',
            width: 100,
            align: 'right',
            sortable: true
        }, {
            header: $g('进价差额'),
            dataIndex: 'diffrpamt',
            width: 100,
            align: 'right',
            sortable: true
        }, {
            header: $g('售价差额'),
            dataIndex: 'diffspamt',
            width: 100,
            align: 'right',
            sortable: true
        }, {
            header: $g('系数'),
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
        header: $g('代码'),
        dataIndex: 'code',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g("名称"),
        dataIndex: 'desc',
        width: 200,
        align: 'left',
        sortable: true
    }, {
        header: $g("规格"),
        dataIndex: 'spec',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g('批号'),
        dataIndex: 'batNo',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g('效期'),
        dataIndex: 'expDate',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g("单位"),
        dataIndex: 'uomDesc',
        width: 60,
        align: 'left',
        sortable: true
    }, {
        header: $g('冻结数量'),
        dataIndex: 'freQty',
        width: 80,
        align: 'right',
        sortable: true
    }, {
        header: $g('实盘数量'),
        dataIndex: 'countQty',
        width: 80,
        align: 'right',
        sortable: true

    }, {
        header: $g('差异数量'),
        dataIndex: 'diffQty',
        width: 80,
        align: 'right',
        sortable: true

    }, {
        header: $g("货位码"),
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
        header: $g('代码'),
        dataIndex: 'code',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g("名称"),
        dataIndex: 'desc',
        width: 200,
        align: 'left',
        sortable: true
    }, {
        header: $g("规格"),
        dataIndex: 'spec',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g("单位"),
        dataIndex: 'uomDesc',
        width: 60,
        align: 'left',
        sortable: true
    }, {
        header: $g('实盘数量'),
        dataIndex: 'countQty',
        width: 80,
        align: 'right',
        sortable: true

    }, {
        header: $g('账盘数量'),
        dataIndex: 'freQty',
        width: 80,
        align: 'right',
        sortable: true

    }, {
        header: $g('差异数量'),
        dataIndex: 'diffQty',
        width: 80,
        align: 'right',
        sortable: true

    }, {
        header: $g("货位码"),
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
            header: $g('代码'),
            dataIndex: 'code',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: $g("名称"),
            dataIndex: 'desc',
            width: 200,
            align: 'left',
            sortable: true
        }, {
            header:$g("规格"),
            dataIndex: 'spec',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: $g('批号'),
            dataIndex: 'batNo',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g('效期'),
            dataIndex: 'expDate',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header:$g( "单位"),
            dataIndex: 'uomDesc',
            width: 60,
            align: 'left',
            sortable: true
        }, {
            header: $g('账盘数量'),
            dataIndex: 'freQty',
            width: 80,
            align: 'right',
            sortable: true
        }

        , {
            header: $g("货位码"),
            dataIndex: 'stkbin',
            width: 100,
            align: 'left',
            sortable: true
        }, {
            header: $g("生产企业"),
            dataIndex: 'manf',
            width: 100,
            align: 'left',
            sortable: true
        }
    ]);

    InstDetailGridNoImpCm.defaultSortable = true;
    // 数据集
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

    // 数据集
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

    // 数据集
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

    // 数据集
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
        displayMsg: $g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
        emptyMsg: "No results to display",
        prevText: $g("上一页"),
        nextText: $g("下一页"),
        refreshText: $g("刷新"),
        lastText: $g("最后页"),
        firstText: $g("第一页"),
        beforePageText: $g("当前页"),
        afterPageText: $g("共{0}页"),
        emptyMsg: $g("没有数据")
    });

    StatuTabPagingToolbar.addListener('beforechange', function(toolbar, params) {
        if (InstDetailGrid.activeEditor != null) {
            InstDetailGrid.activeEditor.completeEdit();
        }
        var records = InstDetailStore.getModifiedRecords();
        if (records.length > 0) {
            Msg.info("warning", $g("本页数据发生变化，请先保存！"));
            return false;
        }
    });

    var StatuTabPagingToolbarPc = new Ext.PagingToolbar({
        store: InstDetailStorePc,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: $g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
        emptyMsg: "No results to display",
        prevText: $g("上一页"),
        nextText: $g("下一页"),
        refreshText: $g("刷新"),
        lastText: $g("最后页"),
        firstText: $g("第一页"),
        beforePageText: $g("当前页"),
        afterPageText: $g("共{0}页"),
        emptyMsg: $g("没有数据")
    });

    var StatuTabPagingToolbarYp = new Ext.PagingToolbar({
        store: InstDetailStoreYp,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: $g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
        emptyMsg: "No results to display",
        prevText: $g("上一页"),
        nextText: $g("下一页"),
        refreshText: $g("刷新"),
        lastText: $g("最后页"),
        firstText: $g("第一页"),
        beforePageText: $g("当前页"),
        afterPageText: $g("共{0}页"),
        emptyMsg: $g("没有数据")
    });

    var StatuTabPagingToolbarNoImp = new Ext.PagingToolbar({
        store: InstDetailStoreNoImp,
        pageSize: PageSize,
        displayInfo: true,
        displayMsg: $g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
        emptyMsg: "No results to display",
        prevText:$g( "上一页"),
        nextText: $g("下一页"),
        refreshText: $g("刷新"),
        lastText: $g("最后页"),
        firstText: $g("第一页"),
        beforePageText: $g("当前页"),
        afterPageText: $g("共{0}页"),
        emptyMsg: $g("没有数据")
    });

    var InstDetailGrid = new Ext.grid.EditorGridPanel({
        id: 'InstDetailGrid',
        cm: InstDetailGridCm,
        store: InstDetailStore,
        trackMouseOver: true,
        stripeRows: true,
        sm: new Ext.grid.CellSelectionModel(), // wyx modify 2013-11-18改为行模式
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
                if (incidesc == "合计") { return; }
                if (((bcountqty == "") || (bcountqty == null)) && ((pcountqty == "") || (bcountqty == null))) {
                    return; //未填项不变色
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

    ///yunhaibao,20151123,行修改后计算行信息,后台计算
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
                if (incidesc == "合计") { return; }
                if ((countqty == "") || (countqty == null)) {
                    return; //未填项不变色
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
                if (incidesc == "合计") { return; }
                if ((countqty == "") || (countqty == null)) {
                    return; //未填项不变色
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
     **添加右键菜单,wyx,2013-11-18***
     **/
    //右键菜单代码关键部分 
    var rightClick = new Ext.menu.Menu({
        id: 'rightClickCont',
        items: [{
            id: 'mnuScanItm1',
            handler: ScanItmShow,
            text: $g('查找项'),
            click: true

        }]
    });
    var rightClickDetail = new Ext.menu.Menu({
        id: 'rightClickContDetail',
        items: [{
                id: 'mnuScanItm2',
                handler: ScanItmShow,
                text: $g('查找项'),
                click: true

            }, {
                id: 'mnuEntryBat',
                handler: EntryBatShow,
                text: $g('录入项'),
                click: true,
                hidden: (gParam[0] == 'Y' ? false : true)
            }

        ]
    });

    function rightClickFn(grid, rowindex, e) {
        e.preventDefault();
        rightClick.showAt(e.getXY()); //获取坐标
    }

    function rightClickDetailFn(grid, rowindex, e) {
        e.preventDefault();
        rightClickDetail.showAt(e.getXY()); //获取坐标
    }
    InstDetailGrid.addListener('rowcontextmenu', rightClickDetailFn); //右键菜单代码关键部分 
    InstDetailGridPc.addListener('rowcontextmenu', rightClickFn); //右键菜单代码关键部分 
    InstDetailGridYp.addListener('rowcontextmenu', rightClickFn); //右键菜单代码关键部分
    InstDetailGridNoImp.addListener('rowcontextmenu', rightClickFn); //右键菜单代码关键部分

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
            title: $g('扫描条码录入'),
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

    // 页签
    var talPanel = new Ext.TabPanel({
        activeTab: 0,
        deferredRender: true,
        items: [{
            activate: QueryDetail(),
            title: $g('实盘明细'),
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
            title: $g('汇总预览(按批次)'),
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
            title: $g('汇总预览(按药品)'),
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
            title: $g('未录入药品(明细)'),
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

    // 5.2.页面布局
    var mainPanel = new Ext.Viewport({
        layout: 'border', //表格布局
        items: [{
            region: 'north',
            height: 180,
            title: $g('实盘:录入方式四(按货位批次) [温馨提示:请先点击增加,然后选择货位查询,再进行录入]'),
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