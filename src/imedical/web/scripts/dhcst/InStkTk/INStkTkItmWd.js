// /名称:   实盘：录入方式一（根据账盘数据按批次填充实盘数）
// /描述:   实盘：录入方式一（根据账盘数据按批次填充实盘数）
// /编写者：zhangdongmei
// /编写日期: 2012.08.30
Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gStrDetailParams = '';
    var inciRowid = '';
    var url = DictUrl + 'instktkaction.csp';
    var logonLocId = session['LOGON.CTLOCID'];
    var logonUserId = session['LOGON.USERID'];
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
        fieldLabel: $g('实盘窗口'),
        id: 'PhaWindow',
        name: 'PhaWindow',
        anchor: '90%',
        store: INStkTkWindowStore,
        valueField: 'RowId',
        displayField: 'Description',
        disabled: true,
        allowBlank: true,
        triggerAction: 'all',
        emptyText: $g('实盘窗口...'),
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
        StkType: App_StkTypeCode, //标识类组类型
        LocId: logonLocId,
        UserId: logonUserId,
        anchor: '90%',
        width: 140
    });

    var DHCStkCatGroup = new Ext.form.ComboBox({
        fieldLabel: $g('库存分类'),
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
        fieldLabel: $g('货位'),
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

    //盘点单号
    var InstNo = new Ext.form.TextField({
        id: 'InstNo',
        name: 'InstNo',
        fieldLabel: $g('盘点单号'),
        anchor: '90%',
        width: 140,
        disabled: true
    });

    // 查询按钮
    var SearchBT = new Ext.Toolbar.Button({
        text: $g('查询'),
        tooltip: $g('点击查询'),
        iconCls: 'page_find',
        width: 70,
        height: 30,
        handler: function () {
            QueryDetail();
        }
    });

    //设置未填数等于账盘数
    var SetDefaultBT2 = new Ext.Toolbar.Button({
        text: $g('设置未填数等于账盘数'),
        tooltip: $g('点击设置未填数等于账盘数'),
        iconCls: 'page_gear',
        width: 70,
        height: 30,
        handler: function () {
            var ss = Ext.Msg.show({
                title: $g('提示'),
                msg: $g('设置未填实盘数等于账盘数将修改此盘点单所有未录入的记录，是否继续？'),
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
			if(txt != "实盘为0"){
				Msg.info('error', $g('输入确认信息有误，请重新输入！'));
				Ext.Msg.prompt($g("系统提示"),$g("实盘为0对数据影响较大请输入>>>实盘为0<<<来确认操作"),callback);
			}
			else{
				SetDefaultQty(1);
			}
		}
	}
    //设置未填数等于0
    var SetDefaultBT = new Ext.Toolbar.Button({
        text: $g('设置未填数等于0'),
        tooltip: $g('点击设置未填数等于0'),
        iconCls: 'page_gear',
        width: 70,
        height: 30,
        handler: function () {
	        Ext.Msg.prompt($g("系统提示"),$g("实盘为0对数据影响较大请输入>>>实盘为0<<<来确认操作"),callback);
           /* var ss = Ext.Msg.show({
                title: $g('提示'),
                msg: $g('设置未填实盘数等于0将修改此盘点单所有未录入的记录，是否继续？'),
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

    //设置未填实盘数
    function SetDefaultQty(flag) {
        if (gRowid == '') {
            Msg.info('Warning', $g('没有选中的盘点单！'));
            return;
        }
        var InstwWin = Ext.getCmp("PhaWindow").getValue();
        var UserId = session['LOGON.USERID'];
        var mask = ShowLoadMask(Ext.getBody(), $g("处理中请稍候..."));
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
            waitMsg: $g('处理中...'),
            success: function (response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    Msg.info('success', $g('成功!'));
                    QueryDetail();
                } else {
                    var ret = jsonData.info;
                    Msg.info('error', $g('设置未填记录实盘数失败:') + ret);
                }
            }
        });
    }

    // 清空按钮
    var RefreshBT = new Ext.Toolbar.Button({
        text: $g('清屏'),
        tooltip: $g('点击清屏'),
        iconCls: 'page_clearscreen',
        width: 70,
        height: 30,
        handler: function () {
            clearData();
        }
    });

    /**
     * 清空方法
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
        text: $g('保存'),
        tooltip: $g('点击保存'),
        iconCls: 'page_save',
        width: 70,
        height: 30,
        handler: function () {
            save();
        }
    });
    //设置未填数等于账盘数
    var AddItmBT = new Ext.Toolbar.Button({
        text: $g('新增批次'),
        tooltip: $g('新增该盘点单内不存在的批次'),
        iconCls: 'page_add',
        width: 70,
        height: 30,
        handler: function () {
            AddItmQuery();
        }
    });
    //*添加右键菜单,wyx,2013-11-18***
    var GridRowIndex = ""
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
                var incidesc = rowData.get('desc');
                var Rowid = rowData.get('instw');
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

                var CountUomId = rowData.get('uom'); //基本单位
                var StkBin = '';
                var PhaWin = Ext.getCmp('PhaWindow').getValue();
                var Detail = Parref + '^' + Rowid + '^' + UserId + '^' + "" + '^' + CountUomId + '^' + StkBin + '^' + PhaWin + '^' + bQty + "^" + pQty;
                if (incidesc != '合计') {
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
            params: {
                actiontype: 'SaveTkItmWd',
                Params: ListDetail
            },
            method: 'post',
            waitMsg: $g('处理中...'),
            success: function (response, opt) {
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

    //根据账盘数据插入实盘列表
    function create(inst, instwWin) {
        if (inst == null || inst == '') {
            Msg.info('warning', $g('请选择盘点单'));
            return;
        }
        var UserId = session['LOGON.USERID'];
        var mask = ShowLoadMask(Ext.getBody(), $g("处理中请稍候..."));
        Ext.Ajax.request({
            url: url,
            params: {
                actiontype: 'CreateTkItmWd',
                Inst: inst,
                UserId: UserId,
                InstwWin: instwWin
            },
            waitMsg: $g('处理中...'),
            success: function (response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                mask.hide();
                if (jsonData.success == 'true') {
                    Select(); //查询盘点单主表信息
                    //QueryDetail(inst);    //查找实盘列表
                } else {
                    var ret = jsonData.info;
                    Msg.info("error", $g("提取实盘列表失败：") + ret);
                }
            }
        });
    }

    //查找盘点单及明细信息
    function QueryDetail() {
        //查询盘点单明细
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
                    Ext.MessageBox.alert($g("查询错误"), InstDetailStore.reader.jsonData.Error);
                }
            }
        });
        inciRowid = '';
    }

    function Select() {
        if (gRowid == null || gRowid == "") {
            return;
        }
        var mask = ShowLoadMask(Ext.getBody(), $g("处理中请稍候..."));
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
                    QueryDetail(); //查询明细信息
                }
            }

        });
    }
    // 给小于1的数值补0，如果不是数值的值不变
    function SetNumber(val,meta){
			//if (val=="今日已有生效记录")
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
        header: $g('货位码'),
        dataIndex: 'stkbin',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g('代码'),
        dataIndex: 'code',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g("名称"),
        dataIndex: 'desc',
        width: 225,
        align: 'left',
        sortable: true
    }, {
        header: $g("规格"),
        dataIndex: 'spec',
        width: 100,
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
                        if (event.keyCode == 38) { //阻止IE11默认事件导致的上下键不能自动startedit,yunhaibao20151123
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
        sortable: true,
        renderer:SetNumber
    }, {
        header: $g("生产企业"),
        dataIndex: 'manf',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g('实盘日期'),
        dataIndex: 'countDate',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g("实盘时间"),
        dataIndex: 'countTime',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g('实盘人'),
        dataIndex: 'userName',
        width: 80,
        align: 'left',
        sortable: true
    }, {
        header: $g('售价'),
        dataIndex: 'sp',
        width: 80,
        align: 'left',
        sortable: true,
        renderer:SetNumber
    }, {
        header: $g('进价'),
        dataIndex: 'rp',
        width: 80,
        align: 'left',
        sortable: true,
        renderer:SetNumber
        
    }, {
        header: $g('售价金额'),
        dataIndex: 'spamt',
        width: 100,
        align: 'right',
        sortable: true,
        renderer:SetNumber
    }, {
        header: $g('进价金额'),
        dataIndex: 'rpamt',
        width: 100,
        align: 'right',
        sortable: true,
        renderer:SetNumber
    }, {
        header: $g('账盘售价金额'),
        dataIndex: 'freezespamt',
        width: 100,
        align: 'right',
        sortable: true,
        renderer:SetNumber
    }, {
        header: $g('账盘进价金额'),
        dataIndex: 'freezerpamt',
        width: 100,
        align: 'right',
        sortable: true,
        renderer:SetNumber
    }, {
        header: $g('差异数量'),
        dataIndex: 'diffQty',
        width: 100,
        align: 'right',
        sortable: true,
        renderer:SetNumber
    }, {
        header: $g('进价差额'),
        dataIndex: 'diffrpamt',
        width: 100,
        align: 'right',
        sortable: true,
        renderer:SetNumber
    }, {
        header: $g('售价差额'),
        dataIndex: 'diffspamt',
        width: 100,
        align: 'right',
        sortable: true,
        renderer:SetNumber
    }, {
        header: $g('系数'),
        dataIndex: 'incifac',
        width: 80,
        align: 'left',
        sortable: true
    }]);
    InstDetailGridCm.defaultSortable = true;

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

    StatuTabPagingToolbar.addListener('beforechange', function (toolbar, params) {
        if (InstDetailGrid.activeEditor != null) {
            InstDetailGrid.activeEditor.completeEdit();
        }
        var records = InstDetailStore.getModifiedRecords();
        if (records.length > 0) {
            Msg.info("warning", $g("本页数据发生变化，请先保存！"));
            return false;
        }
    });
    var M_InciDesc = new Ext.form.TextField({
        fieldLabel: $g('药品名称'),
        id: 'M_InciDesc',
        name: 'M_InciDesc',
        emptyText: $g('药品名称...'),
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
                if (incidesc == "合计") {
                    return;
                }
                if (((bcountqty == "") || (bcountqty == null)) && ((pcountqty == "") || (bcountqty == null))) {
                    return; //未填项不变色
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

    ///yunhaibao,20151123,行修改后计算行信息,后台计算
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

    //*添加右键菜单,wyx,2013-11-18*** 
    var form = new Ext.form.FormPanel({
        labelWidth: 60,
        labelAlign: 'right',
        frame: true,
        tbar: [SearchBT, '-', RefreshBT, '-', SaveBT, '-', SetDefaultBT, '-', SetDefaultBT2, '-', AddItmBT],
        items: [{
            xtype: 'fieldset',
            title: $g('查询条件'),
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

    // 5.2.页面布局
    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: [{
            region: 'north',
            height: DHCSTFormStyle.FrmHeight(2),
            title: $g('实盘：录入方式一(按批次填充实盘数)'),
            layout: 'fit',
            items: [form]
        }, {
            region: 'center',
            layout: 'fit',
            items: [InstDetailGrid]
        }],
        renderTo: 'mainPanel'
    });

    //自动加载盘点单
    create(gRowid, gInstwWin);
})