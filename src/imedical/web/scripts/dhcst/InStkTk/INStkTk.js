// /名称: 冻结库存
// /描述: 盘点账盘
// /编写者：zhangdongmei
// /编写日期: 2012.08.24
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
    //wyx add参数配置 2014-03-06
    if (gParam.length < 1) {
        GetParam(); //初始化参数配置
    }
    var PhaLoc = new Ext.ux.LocComboBox({
        fieldLabel: $g('科室'),
        id: 'PhaLoc',
        name: 'PhaLoc',
        anchor: '85%',
        emptyText: $g('科室...'),
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
        fieldLabel: $g('日期'),
        id: 'TkDate',
        name: 'TkDate',
        anchor: '85%',
        width: 140,
        disabled: true,
        value: new Date()
    });

    var TkTime = new Ext.form.TextField({
        fieldLabel: $g('时间'),
        id: 'TkTime',
        name: 'TkTime',
        anchor: '85%',
        width: 140,
        disabled: true
    });

    var InstNo = new Ext.form.TextField({
        fieldLabel: $g('盘点单号'),
        id: 'InstNo',
        name: 'InstNo',
        anchor: '85%',
        width: 140,
        disabled: true
    });

    var Complete = new Ext.form.Checkbox({
        fieldLabel: $g('完成'),
        id: 'Complete',
        name: 'Complete',
        width: 80,
        disabled: true
    });

    // 确定按钮
    var returnBT = new Ext.Toolbar.Button({
        text: $g('确定'),
        tooltip: $g('点击确定'),
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

    // 取消按钮
    var cancelBT = new Ext.Toolbar.Button({
        text: $g('关闭'),
        tooltip: $g('点击关闭'),
        iconCls: 'page_delete',
        handler: function () {
            PrintAskWin.hide();
        }
    });
    //打印选择按钮
    var PrintAskWin = new Ext.Window({
        title: $g('打印模式选择'),
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
                boxLabel: $g('按货位-批次打印'),
                id: 'PrintModel2',
                name: 'PrintModel',
                inputValue: '2'
            }, {
                checked: false,
                boxLabel: $g('按药品-批次打印'),
                id: 'PrintModel1',
                name: 'PrintModel',
                inputValue: '1'
            }, {
                checked: false,
                boxLabel: $g('按药品-品种打印'),
                id: 'PrintModel3',
                name: 'PrintModel',
                inputValue: '3'
            }]
        }],
        buttons: [returnBT, cancelBT]
    })
    // 打印盘点单按钮
    var PrintBT = new Ext.Toolbar.Button({
        id: "PrintBT",
        text: $g('打印'),
        tooltip: $g('点击打印盘点单'),
        width: 70,
        height: 30,
        iconCls: 'page_print',
        handler: function () {
	        if(gRowid=="")
	        {
		        Msg.info("warning",$g( "请先生成一张账盘单再打印!"));
		        return;
	        }
            PrintAskWin.show();
        }
    });

    var TkUomStore = new Ext.data.SimpleStore({
        fields: ['RowId', 'Description'],
        data: [
            [0, $g('基本单位')],
            [1, $g('入库单位')]
        ]
    });

    var TkUom = new Ext.form.ComboBox({
        fieldLabel: $g('默认实盘单位'),
        id: 'TkUom',
        name: 'TkUom',
        anchor: '85%',
        width: 140,
        store: TkUomStore,
        valueField: 'RowId',
        displayField: 'Description',
        allowBlank: false,
        triggerAction: 'all',
        emptyText: $g('默认实盘单位...'),
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
        StkType: App_StkTypeCode, //标识类组类型
        LocId: gLocId,
        UserId: gUserId,
        anchor: '90%',
        width: 140
    });
    StkGrpType.on('change', function () {
        Ext.getCmp("DHCStkCatGroup").setValue("");
    });

    var DHCStkCatGroup = new Ext.ux.ComboBox({
        fieldLabel: $g('库存分类'),
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
        fieldLabel: $g('仅管理药'),
        id: 'ManageDrug',
        name: 'ManageDrug',
        anchor: '90%',
        width: 100,
        height: 8,
        checked: false
    });

    var IncludeNotUse = new Ext.form.Checkbox({
        fieldLabel: $g('包含不可用品种'),
        id: 'IncludeNotUse',
        name: 'IncludeNotUse',
        anchor: '90%',
        width: 100,
        height: 8,
        checked: false
    });

    var NotUseFlag = new Ext.form.Checkbox({
        fieldLabel: $g('仅不可用品种'),
        id: 'NotUseFlag',
        name: 'NotUseFlag',
        anchor: '90%',
        width: 100,
        height: 8,
        checked: false
    });
    var InclbZeroFlag = new Ext.form.Checkbox({
        fieldLabel: $g('过滤零批次库存'),
        id: 'InclbZeroFlag',
        name: 'InclbZeroFlag',
        anchor: '90%',
        width: 100,
        height: 8,
        checked: false
    });
      var WithOutSelectLMG = new Ext.form.Checkbox({
	    //fieldLabel: '',
        boxLabel: $g('不包含下方勾选管理组'),
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
        header: $g("描述"),
        dataIndex: 'Desc',
        width: 150,
        align: 'left',
        sortable: true
    }, {
        header: $g("是否包含"),
        dataIndex: 'IfInclude',
        width: 80,
        align: 'left',
        sortable: true
    }
    ]);
    LocManGrpCm.defaultSortable = true;

    // 访问路径
    var LocManGrpUrl = DictUrl +
        'locmangrpaction.csp?actiontype=Query&start=&limit=';
    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
        url: LocManGrpUrl,
        method: "POST"
    });
    // 指定列参数
    // 数据集
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
        title: $g('管理组'),
        sm: sm,
        clicksToEdit: 1,
        loadMask: true,
        height: 200,
        tbar:['->',WithOutSelectLMG],
    });

    // 查询按钮
    var SearchBT = new Ext.Toolbar.Button({
        text: $g('查询'),
        tooltip: $g('点击查询'),
        iconCls: 'page_find',
        width: 70,
        height: 30,
        handler: function () {
            InStkTkSearch(Query);
        }
    });

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
        text: $g('生成盘点单'),
        tooltip: $g('点击生成盘点单'),
        iconCls: 'page_add',
        width: 70,
        height: 30,
        handler: function () {
            StockQtyGrid.store.removeAll();
            save();
        }
    });
    var QueryTmpData = new Ext.Toolbar.Button({
        text: $g('查询预盘数据'),
        tooltip: $g('查询预盘数据'),
        iconCls: 'page_Find',
        width: 70,
        height: 30,
        handler: function () {
            StockQtyGrid.store.removeAll();
            QueryTmpDetail();
        }
    });
    
    
    var GridColSetBT = new Ext.Toolbar.Button({
        text: $g('列设置'),
        tooltip: $g('列设置'),
        iconCls: 'page_gear',
        handler: function () {
            GridColSet(StockQtyGrid, "DHCSTINSTKTK");
        }
    });
    
    //查询盘点单明细(仅供查询使用)
    function QueryTmpDetail()
    {
	    var PhaLocId = Ext.getCmp("PhaLoc").getValue();
        if (PhaLocId == "") {
            Msg.info("warning", $g("请选取科室!"));
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
            Msg.info("warning", $g('有未完成的业务单，不能生成盘点单！') + CompleteStr);
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
            Msg.info("warning", $g("请选取科室!"));
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
            Msg.info("warning", $g('有未完成的业务单，不能生成盘点单！') + CompleteStr);
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

        var mask = ShowLoadMask(Ext.getBody(), $g("处理中..."));
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
                    Msg.info("success", $g("生成盘点单成功!"));
                    Query(InstId);
                } else {
                    var ret = jsonData.info;
                    if (ret == -1) {
                        Msg.info("error", $g("盘点科室不能为空!"));
                    } else if (ret == -2) {
                        Msg.info("error", $g("盘点人不能为空!"));
                    } else if (ret == -3) {
                        Msg.info("error", $g("保存盘点信息失败!"));
                    } else if (ret == -4) {
                        Msg.info("error", $g("生成盘点单号失败!"));
                    } else if (ret == -5) {
                        Msg.info("error", $g("管理组记录插入失败!"));
                    } else if (ret == -6) {
                        Msg.info("error", $g("插入盘点明细失败!"));
                    } else if (ret == -7) {
                        Msg.info("error", $g("没有符合条件的盘点明细!"));
                    } else {
                        Msg.info("error", $g("生成盘点单失败"));
                    }
                }
                mask.hide();
            }
        });
    }

    //查找盘点单及明细信息
    function Query(inst) {
        if (inst == null || inst.length < 1) {
            Msg.info("warning", $g("盘点id不能为空!"));
        }
        gRowid = inst;
        //查询盘点单主信息
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

        //查询盘点单明细
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
        
        

        //查询科室管理组
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
	                            if(ifInclude=="Y") record.set("IfInclude",$g("仅包含"))
	                            else record.set("IfInclude",$g("不包含"))
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
        text: $g('确认完成'),
        tooltip: $g('点击确认完成'),
        iconCls: 'page_gear',
        width: 70,
        height: 30,
        handler: function () {
            InstComplete();
        }
    });

    //确认完成
    function InstComplete() {
        if (gRowid == "" || gRowid == null) {
            Msg.info("warning", $g("没有需要完成的盘点单!"));
            return;
        }
        Ext.Ajax.request({
            url: url,
            params: {
                actiontype: 'Complete',
                Rowid: gRowid
            },
            method: 'post',
            waitMsg: $g('处理中...'),
            success: function (response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                if (jsonData.success == 'true') {
                    Msg.info("success", $g("操作成功!"));
                    Ext.getCmp('Complete').setValue(true);
                } else {
                    var ret = jsonData.info;
                    if (ret == -99) {
                        Msg.info("error", $g("加锁失败!"));
                    } else if (ret == -2) {
                        Msg.info("error", $g("盘点单已经完成!"));
                    } else {
                        Msg.info("error", $g("操作失败!"));
                    }
                }
            }
        });
    }
    var DeleteBT = new Ext.Toolbar.Button({
        text: $g('删除'),
        tooltip: $g('点击删除'),
        iconCls: 'page_delete',
        width: 70,
        height: 30,
        handler: function () {
            Delete();
        }
    });

    //删除
    function Delete() {
        if (gRowid == "" || gRowid == null) {
            Msg.info("warning", $g("没有需要删除的盘点单!"));
            return;
        }
        Ext.Ajax.request({
            url: url,
            params: {
                actiontype: 'Delete',
                Rowid: gRowid
            },
            method: 'post',
            waitMsg: $g('处理中...'),
            success: function (response, opt) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
                if (jsonData.success == 'true') {
                    Msg.info("success", $g("操作成功!"));
                    clearData();
                } else {
                    var ret = jsonData.info;
                    if (ret == -99) {
                        Msg.info("error",$g( "加锁失败!"));
                    } else if (ret == -3) {
                        Ext.MessageBox.confirm($g('提示'), $g('盘点单为账盘完成状态,是否确定删除?'),
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
                                        waitMsg: $g('处理中...'),
                                        success: function (response, opt) {
                                            var jsonData = Ext.util.JSON.decode(response.responseText);
                                            var ret = jsonData.info;
                                            if (jsonData.success == 'true') {
                                                Msg.info("success", $g("操作成功!"));
                                                clearData();
                                            } else if (ret == -1) {
                                                Msg.info("error", $g("盘点单已经实盘汇总，不允许删除!"));
                                            } else if (ret == -2) {
                                                Msg.info("error", $g("盘点单已经调整，不允许删除!"));
                                            }else if (ret == -5) {
                                                Msg.info("error", $g("已经产生库存调整单，不允许删除!"));
                                            } else {
                                                Msg.info("error", $g("操作失败!"));
                                            }

                                        }
                                    })

                                }
                            }
                        )
                    } else if (ret == -1) {
                        Msg.info("error", $g("盘点单已经实盘汇总，不允许删除!"));
                    } else if (ret == -2) {
                        Msg.info("error", $g("盘点单已经调整，不允许删除!"));
                    } else {
                        Msg.info("error", $g("操作失败!"));
                    }
                }
            }
        });
    }
    //检测某科室某月份月报是否有未完成的单据 //add wyx 2014-03-06 
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
        header:$g( "规格"),
        dataIndex: 'spec',
        width: 90,
        align: 'left',
    }, {
        header: $g("基本单位"),
        dataIndex: 'uomDesc',
        width: 80,
        align: 'left',
    }, {
        header: $g('冻结数量'),
        dataIndex: 'freQty',
        width: 100,
        align: 'right',
        sortable: true
    }, {
        header: $g("入库单位"),
        dataIndex: 'purUomDesc',
        width: 80,
        align: 'left',
    }, {
        header: $g('冻结数量(入库单位)'),
        dataIndex: 'purFreQty',
        width: 100,
        align: 'right',
    }, {
        header: $g('冻结日期'),
        dataIndex: 'freDate',
        width: 80,
        align: 'left',
    }, {
        header: $g('冻结时间'),
        dataIndex: 'freTime',
        width: 80,
        align: 'left',
    }, {
        header:$g( "生产企业"),
        dataIndex: 'manf',
        width: 100,
        align: 'left',
    }, {
        header: $g('批号'),
        dataIndex: 'batchNo',
        width: 100,
        align: 'left',
    }, {
        header: $g('效期'),
        dataIndex: 'expDate',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g('货位'),
        dataIndex: 'sbDesc',
        width: 100,
        align: 'left',
        sortable: true
    }, {
        header: $g("条码"),
        dataIndex: 'barcode',
        width: 80,
        align: 'left',
    }, {
        header: $g("备注"),
        dataIndex: 'remark',
        width: 80,
        align: 'left',
    }, {
        header: $g("状态"),
        dataIndex: 'status',
        width: 80,
        align: 'left',
    }, {
        header: $g('账盘进价金额'),
        dataIndex: 'freezeRpAmt',
        width: 120,
        align: 'right',
        sortable: true
    }/*, {
        header: $g('实盘进价金额',
        dataIndex: 'countRpAmt',
        width: 120,
        align: 'right',
        sortable: true,
        hidden: true
    }*/, {
        header: $g('账盘售价金额'),
        dataIndex: 'freezeSpAmt',
        width: 120,
        align: 'right',
        sortable: true
    }/*, {
        header: $g('实盘售价金额'),
        dataIndex: 'countSpAmt',
        width: 120,
        align: 'right',
        sortable: true,
        hidden: true
    }, {
        header: $g('进价差额'),
        dataIndex: 'varianceRpAmt',
        width: 120,
        align: 'right',
        sortable: true,
        hidden: true
    }, {
        header: $g('售价差额'),
        dataIndex: 'varianceSpAmt',
        width: 120,
        align: 'right',
        sortable: true,
        hidden: true
    }*/]);
    //StockQtyCm.defaultSortable = true;

    // 访问路径
    var DspPhaUrl = DictUrl +
        'instktkaction.csp?actiontype=QueryDetail&start=&limit=&sort=rowid&dir=ASC';
    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
        url: DspPhaUrl,
        method: "POST"
    });
    // 指定列参数
    //adjFlag:%String,:%String,inadi:%String
    var fields = ["rowid", "inclb", "code", "desc", "spec", "manf", "barcode", "freQty",
        "freDate", "freTime", "remark", "status", "uomDesc", "batchNo", "expDate", "sbDesc", "purUomDesc", "purFreQty", "freezeSpAmt", "freezeRpAmt", "countSpAmt",
        "countRpAmt", "varianceSpAmt", "varianceRpAmt"
    ];
    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "rowid",
        fields: fields
    });
    // 数据集
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
        displayMsg: $g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
        emptyMsg: "No results to display",
        prevText: $g("上一页"),
        nextText: $g("下一页"),
        refreshText: $g("刷新"),
        lastText: $g("最后页"),
        firstText: $g("第一页"),
        beforePageText: $g("当前页"),
        afterPageText:$g( "共{0}页"),
        emptyMsg: $g("没有数据")
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
            title:$g( '限定范围'),
            xtype: 'fieldset',
            items: [StkGrpType, DHCStkCatGroup, StStkBin, EdStkBin, ManageDrug,
                IncludeNotUse, NotUseFlag, InclbZeroFlag, LocManGrpGrid
            ]
        }]
    });
    var myToolBar = new Ext.Toolbar({
        items: [SearchBT, '-', RefreshBT, '-', QueryTmpData , '-', CreateBT, '-', CompleteBT, '-', PrintBT, '-', GridColSetBT, '-', DeleteBT]
    });

    // 5.2.页面布局
    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: [{
            region: 'north',
            height: 65,
            layout: 'fit', // specify layout manager for items
            title: $g('盘点-账盘'),
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