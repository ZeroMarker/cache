// /名称: 入库单制单
// /描述: 入库单制单
// /编写者：zhangdongmei
// /编写日期: 2012.06.27
var rpdecimal = 2 //默认进售价小数
var spdecimal = 2
var impWindow = null;
var colArr = [];
Ext.onReady(function() {
    var gUserId = session['LOGON.USERID'];
    var gLocId = session['LOGON.CTLOCID'];
    var HospId = session['LOGON.HOSPID'];
    var gGroupId = session['LOGON.GROUPID'];
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var Msg_LostModified = '数据已录入或修改，你当前的操作将丢失这些结果，是否继续?';
    if (gParam.length < 1) {
        GetParam(); //初始化参数配置
    }
    if (gParamCommon.length < 1) {
        GetParamCommon(); //初始化公共参数配置 wyx 公共变量取类组设置gParamCommon[9]
    }

    var PhaLoc = new Ext.ux.LocComboBox({
        fieldLabel: '入库部门',
        id: 'PhaLoc',
        name: 'PhaLoc',
        anchor: '80%',
        emptyText: '入库部门...',
        groupId: gGroupId,
        listeners: {
            'select': function(e) {
                var SelLocId = Ext.getCmp('PhaLoc').getValue(); //add wyx 根据选择的科室动态加载类组
                StkGrpType.getStore().removeAll();
                StkGrpType.getStore().setBaseParam("locId", SelLocId)
                StkGrpType.getStore().setBaseParam("userId", UserId)
                StkGrpType.getStore().setBaseParam("type", App_StkTypeCode)
                StkGrpType.getStore().load();
                PurchaseUser.getStore().removeAll(); //根据选择的科室动态加载采购员
                PurchaseUser.getStore().setBaseParam("locId", SelLocId)
                PurchaseUser.getStore().load();
            }
        }

    });

    var Vendor = new Ext.ux.VendorComboBox({
        id: 'Vendor',
        name: 'Vendor',
        anchor: '80%',
        hospId: 1,
        listeners: {
            specialkey: function(field, e) {
                if (e.getKey() == Ext.EventObject.ENTER) {
                    addNewRow();
                }
            }
        }
    });



    // 药品类组
    var StkGrpType = new Ext.ux.StkGrpComboBox({
        id: 'StkGrpType',
        name: 'StkGrpType',
        StkType: App_StkTypeCode, //标识类组类型
        LocId: gLocId,
        UserId: gUserId,
        anchor: '80%'
    });

    // 入库类型
    var OperateInType = new Ext.ux.ComboBox({
        fieldLabel: '入库类型',
        id: 'OperateInType',
        name: 'OperateInType',
        anchor: '90%',
        store: OperateInTypeStore,
        valueField: 'RowId',
        displayField: 'Description',
        allowBlank: true,
        triggerAction: 'all',
        selectOnFocus: true,
        forceSelection: true,
        minChars: 1,
        valueNotFoundText: ''
    });
    OperateInTypeStore.load();
    if(gParam[8]=="N"){
	    OperateInType.setValue("");
    }
    else{
	    // 默认选中第一行数据
	    OperateInTypeStore.on('load', function() {
	        setDefaultInType();
	    });
    }
    function setDefaultInType() {
        var operatecount = OperateInTypeStore.getTotalCount();
        if (operatecount > 0) {
            var operatei = 0;
            for (operatei = 0; operatei < operatecount; operatei++) {
                var defaultflag = OperateInTypeStore.getAt(operatei).data.Default;
                if (defaultflag == "Y") {
                    OperateInType.setValue(OperateInTypeStore.getAt(operatei).data.RowId);
                }
            }
            if (OperateInType.getValue() == "") { //没有默认默认第一条
                //OperateInType.setValue(OperateInTypeStore.getAt(0).data.RowId);
            }
        }
    }

    // 入库单号
    var InGrNo = new Ext.form.TextField({
        fieldLabel: '入库单号',
        id: 'InGrNo',
        name: 'InGrNo',
        anchor: '90%',
        disabled: true
    });
    //=========统计添加=======		
    // 当页条数
    var NumAmount = new Ext.form.TextField({
        emptyText: '当页条数',
        id: 'NumAmount',
        name: 'NumAmount',
        anchor: '90%',
        width: 200
    });

    // 进价合计
    var RpAmount = new Ext.form.TextField({
        emptyText: '进价合计',
        id: 'RpAmount',
        name: 'RpAmount',
        width: 200,
        anchor: '90%'
    });

    // 售价合计
    var SpAmount = new Ext.form.TextField({
        emptyText: '售价合计',
        id: 'SpAmount',
        name: 'SpAmount',
        anchor: '90%',
        width: 200
    });

    //zhangxiao20130815			
    function GetAmount() {
        var RpAmt = 0
        var SpAmt = 0
        var Count = DetailGrid.getStore().getCount();
        for (var i = 0; i < Count; i++) {
            var rowData = DetailStore.getAt(i);
            if (rowData==undefined){
	            continue;
	        }
            var RecQty = rowData.get("RecQty");
            var Rp = rowData.get("Rp");
            var Sp = rowData.get("Sp");
            var RpAmt1 = Number(Rp).mul(RecQty)
            var SpAmt1 = Number(Sp).mul(RecQty);
            RpAmt = accAdd(Number(RpAmt), Number(RpAmt1));
            SpAmt = accAdd(Number(SpAmt), Number(SpAmt1));
        }
        Count = "当前条数:" + " " + Count
        RpAmt = "进价合计:" + " " + RpAmt + " " + "元"
        SpAmt = "售价合计:" + " " + SpAmt + " " + "元"
        Ext.getCmp("NumAmount").setValue(Count)
        Ext.getCmp("RpAmount").setValue(RpAmt)
        Ext.getCmp("SpAmount").setValue(SpAmt)
    }
    //=========统计添加=======	

    // 入库日期
    var InGrDate = new Ext.ux.DateField({
        fieldLabel: '入库日期',
        id: 'InGrDate',
        name: 'InGrDate',
        anchor: '90%',
        value: new Date(),
        disabled: true
    });

    // 采购人员
    var PurchaseUser = new Ext.ux.ComboBox({
        fieldLabel: '采购人员',
        id: 'PurchaseUser',
        store: PurchaseUserStore,
        valueField: 'RowId',
        displayField: 'Description'
    });
    PurchaseUser.getStore().load();
    PurchaseUserStore.addListener('load', function(thisField) {
        var puserlen = thisField.getCount();
        PurchaseUser.setValue("");
        for (var i = 0; i < puserlen; i++) {
            if (PurchaseUserStore.data.items[i].data["Default"] == "Y") {
                PurchaseUser.setValue(PurchaseUserStore.data.items[i].data["RowId"]);
            }
        }
    })

    // 完成标志
    var CompleteFlag = new Ext.form.Checkbox({
        boxLabel: '完成',
        id: 'CompleteFlag',
        name: 'CompleteFlag',
        anchor: '90%',
        checked: false,
        disabled: true
    });

    // 赠药入库标志
    var PresentFlag = new Ext.form.Checkbox({
        boxLabel: '捐赠',
        id: 'PresentFlag',
        name: 'PresentFlag',
        anchor: '90%',
        checked: false
    });

    // 调价换票标志
    var ExchangeFlag = new Ext.form.Checkbox({

        id: 'ExchangeFlag',
        name: 'ExchangeFlag',
        anchor: '90%',
        checked: false,
        boxLabel: '调价换票'
    });

    // 打印入库单按钮
    var PrintBT = new Ext.Toolbar.Button({
        id: "PrintBT",
        text: '打印',
        tooltip: '点击打印入库单',
        width: 70,
        height: 30,
        iconCls: 'page_print',
        handler: function() {
            PrintRec(gIngrRowid, gParam[13]);
        }
    });

    // 查询入库单按钮
    var SearchInGrBT = new Ext.Toolbar.Button({
        id: "SearchInGrBT",
        text: '查询',
        tooltip: '点击查询入库单',
        width: 70,
        height: 30,
        iconCls: 'page_find',
        handler: function() {
            DrugImportGrSearch(DetailStore, Query);
        }
    });

    // 清空按钮
    var ClearBT = new Ext.Toolbar.Button({
        id: "ClearBT",
        text: '清屏',
        tooltip: '点击清屏',
        width: 70,
        height: 30,
        iconCls: 'page_clearscreen',
        handler: function() {
            var compFlag = Ext.getCmp('CompleteFlag').getValue();
            var mod = Modified();
            if (mod && (!compFlag)) {
                Ext.Msg.show({
                    title: '提示',
                    msg: Msg_LostModified,
                    buttons: Ext.Msg.YESNO,
                    fn: function(b, t, o) {
                        if (b == 'yes') {
                            clearData();
                        }
                    },
                    //animEl: 'elId',
                    icon: Ext.MessageBox.QUESTION
                });
            } else {
                clearData();
            }
        }
    });
    // 完成按钮
    var CompleteBT = new Ext.Toolbar.Button({
        id: "CompleteBT",
        text: '完成',
        tooltip: '点击完成',
        width: 70,
        height: 30,
        iconCls: 'page_gear',
        handler: function() {
            var compFlag = Ext.getCmp('CompleteFlag').getValue();
            var mod = isDataChanged();
            if (mod && (!compFlag)) {
                Ext.Msg.confirm('提示', '数据已发生改变,是否需要保存后完成?',
                    function(btn) {
                        if (btn == 'yes') {
                            return;
                        } else {
                            Complete();
                        }

                    }, this);
            } else {
                Complete();
            }
        }
    });

    // 取消完成按钮
    var CancleCompleteBT = new Ext.Toolbar.Button({
        id: "CancleCompleteBT",
        text: '取消完成',
        tooltip: '点击取消完成',
        width: 70,
        height: 30,
        iconCls: 'page_gear',
        handler: function() {
            CancleComplete();
        }
    });
    // 删除按钮
    var DeleteInGrBT = new Ext.Toolbar.Button({
        id: "DeleteInGrBT",
        text: '删除',
        tooltip: '点击删除',
        width: 70,
        height: 30,
        iconCls: 'page_delete',
        handler: function() {
            deleteData();
        }
    });

    /**
     * 清空方法
     */
    function clearData() {
        // Ext.getCmp("PhaLoc").setValue("");
        Ext.getCmp("Vendor").setValue("");
        Ext.getCmp("StkGrpType").setValue("");
        Ext.getCmp("StkGrpType").getStore().load();
        Ext.getCmp("InGrNo").setValue("");
        Ext.getCmp("InGrDate").setValue(new Date());
        Ext.getCmp("PurchaseUser").setValue("");
        Ext.getCmp("PurchaseUser").getStore().load();
        Ext.getCmp("CompleteFlag").setValue(false);
        //=====zhangxiao20130816===
        Ext.getCmp("NumAmount").setValue("");
        Ext.getCmp("RpAmount").setValue("");
        Ext.getCmp("SpAmount").setValue("");
        //=====zhangxiao20130816===
        DetailGrid.store.removeAll();
        DetailGrid.getView().refresh();
        //查询^清除^新增^保存^删除^完成^取消完成			
        changeButtonEnable("1^1^1^0^0^0^0^0");
        Ext.getCmp("PresentFlag").setValue(false);
        Ext.getCmp("ExchangeFlag").setValue(false);
        DHCSTLockToggle(gIngrRowid, "G", "UL");
        gIngrRowid = "";
        SetFieldDisabled(false);
        SetFormOriginal(HisListTab);
    }

    function ImportByExcel() {
        var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
        if (CmpFlag != null && CmpFlag != 0) {
            Msg.info("warning", "入库单已完成不可修改!");
            return;
        }
        if (Ext.getCmp('Vendor').getValue() == '') {
            Msg.info('warning', '请选择供应商!');
            return;
        }
        if (impWindow) {
            impWindow.ShowOpen();
        } else {
	        try{impWindow = new ActiveXObject("MSComDlg.CommonDialog");
	        }
	        catch (err){
		        alert(err+ " 请确认MSComDlg.CommonDialog.reg是否注册成功 ")
	        	window.open("../scripts/dhcst/InGdRec/MSComDlg.CommonDialog.reg", "_blank");
	        	return;
	        }
	        
            impWindow = new ActiveXObject("MSComDlg.CommonDialog");
            impWindow.Filter = "Excel(*.xls;*xlsx)|*.xls;*.xlsx";
            impWindow.FilterIndex = 1;
            // 必须设置MaxFileSize. 否则出错
            impWindow.MaxFileSize = 32767;
            impWindow.ShowOpen();
        }

        var fileName = impWindow.FileName;
        if (fileName == '') {
            Msg.info('warning', '请选择Excel文件!');
            return;
        }
        ReadFromExcel(fileName, impLine);
    }
    
    function ImportBySCIFn(){
    	DrugImportGrSCI(Query);
    }
    
    var ImportButton = new Ext.Button({
            text: '导入数据',
            width: 70,
            height: 30,
            iconCls: 'page_add',
            tooltip: '下拉导入按钮',
            menu: {
                items: [
                    {
                    	text: '云平台订单导入',iconCls : 'page_edit', handler: ImportBySCIFn
                    },
                    {
                        text: 'Excel模板导入',
                        iconCls: 'page_upload',
                        //handler:   //ImportByExcel
                        handler:function(){
								    jsReadExcelAsJson(callBacktest)
								}

                    }, {
                        text: 'Excel模板下载',
                        iconCls: 'page_download',
                        handler: function() {
                            window.open("../scripts/dhcst/InGdRec/药品入库单导入模板.xls", "_blank");
                        }
                    }
                ]
            }
        })
        
    function callBacktest(xmlDocObj)
    {
	    //debugger
	    var length=xmlDocObj.length;
	    var incicode="",invno="",qty="",rp="",rpamt="",batno="",ExpDate=""
	    for (i=0;i<length;i++)
	    {
		    var detail=xmlDocObj[i]
		    impLineNew(detail, i+1) 
		    
	    }
    }
        
        ///根据行数据导入一条记录
    function impLineNew(detail, rowNumber) {
        try {
            //			代码 ------- 发票号---- - 数量----- - 单价----- 金额 - ----批号- ------效期------
            var inciCode = detail.代码;
            var invNo = detail.发票号
            var qty = detail.数量;
            var rp = detail.单价;
            var amt = detail.金额;
            var batNo = detail.批号;
            var expDate = detail.效期;
            var hosp = session["LOGON.HOSPID"];
            if (Ext.isEmpty(inciCode)) {
                return false;
            }
            var url = "dhcst.drugutil.csp?actiontype=GetItmInfoByCode&ItmCode=" + inciCode + "&HospId=" + hosp;
            var responseText = ExecuteDBSynAccess(url);
           
   			if (responseText.trim()!=""){
	            var jsonData = Ext.util.JSON.decode(responseText);
	            if (jsonData.success == 'true') {
	                var list = jsonData.info.split("^");
	                var inci = list[15];
	                var inciCode = list[0];
	                var IncDesc = list[1];
	                var Spec = list[16];
	                var Sp = list[11];
	                var ManfId = list[17];
	                var Manf = list[18];
	                var IngrUomId = list[8];
	                var IngrUom = list[9];
	                var BUomId = list[6];
	                var NotUseFlag = list[19];
	                var Remark = list[20];
	                if (NotUseFlag == 'Y') {
	                    Msg.info('warning', '第' + rowNumber + '行: ' + inciCode + ' 为"不可用"状态!');
	                    return;
	                }
	                //colArr=sortColoumByEnterSort(DetailGrid); //将回车的调整顺序初始化好
	                // 新增一行
	                addNewRow(1);
	                addComboData(PhManufacturerStore, ManfId, Manf);
	                addComboData(ItmUomStore, IngrUomId, IngrUom);
	                var row = DetailGrid.getStore().getCount();
	                var rec = DetailGrid.getStore().getAt(row - 1);
	                rec.set('IncCode', inciCode);
	                rec.set('InvNo', invNo);
	                rec.set('RecQty', qty);
	                rec.set('Rp', rp);
	                rec.set('RpAmt', amt);
	                rec.set('BatchNo', batNo);
	                var d = new Date();
	                d = Date.parseDate(expDate, App_StkDateFormat);
	                rec.set('ExpDate', d);
	                rec.set('IncId', inci);
	                rec.set('IncDesc', IncDesc);
	                rec.set('Spec', Spec);
	                rec.set('Sp', Sp);
	                rec.set('ManfId', ManfId);
	                rec.set('IngrUomId', IngrUomId);
	                rec.set('BUomId', BUomId);
	                rec.set('InfoRemark', Remark);
	            }
            } else {
                Msg.info('error', "药品代码为" + inciCode + ",的药品信息读取错误,请核查!");
                DetailGrid.getStore().removeAll();
                DetailGrid.getView().refresh();
                return false;
            }
            // 变更按钮是否可用
            //查询^清除^新增^保存^删除^完成^取消完成
            changeButtonEnable("0^1^1^1^1^1^0^1^1");
            SetFieldDisabled(true);
            return true;
        } catch (e) {
            alert('读取数据错误,错误信息:' + e.message);
            DetailGrid.getStore().removeAll();
            DetailGrid.getView().refresh();
            return false;
        }

    }


    
        ///根据行数据导入一条记录
    function impLine(s, rowNumber) {
        var ss = s.split('\t');
        try {
            //			代码 ------- 发票号---- - 数量----- - 单价----- 金额 - ----批号- ------效期------
            var inciCode = ss[0];
            var invNo = ss[1];
            var qty = ss[2];
            var rp = ss[3];
            var amt = ss[4];
            var batNo = ss[5];
            var expDate = ss[6];
            var hosp = session["LOGON.HOSPID"];
            if (Ext.isEmpty(inciCode)) {
                return false;
            }
            var url = "dhcst.drugutil.csp?actiontype=GetItmInfoByCode&ItmCode=" + inciCode + "&HospId=" + hosp;
            var responseText = ExecuteDBSynAccess(url);
           
   			if (responseText.trim()!=""){
	            var jsonData = Ext.util.JSON.decode(responseText);
	            if (jsonData.success == 'true') {
	                var list = jsonData.info.split("^");
	                var inci = list[15];
	                var inciCode = list[0];
	                var IncDesc = list[1];
	                var Spec = list[16];
	                var Sp = list[11];
	                var ManfId = list[17];
	                var Manf = list[18];
	                var IngrUomId = list[8];
	                var IngrUom = list[9];
	                var BUomId = list[6];
	                var NotUseFlag = list[19];
	                var Remark = list[20];
	                if (NotUseFlag == 'Y') {
	                    Msg.info('warning', '第' + rowNumber + '行: ' + inciCode + ' 为"不可用"状态!');
	                    return;
	                }
	                //colArr=sortColoumByEnterSort(DetailGrid); //将回车的调整顺序初始化好
	                // 新增一行
	                addNewRow(1);
	                addComboData(PhManufacturerStore, ManfId, Manf);
	                addComboData(ItmUomStore, IngrUomId, IngrUom);
	                var row = DetailGrid.getStore().getCount();
	                var rec = DetailGrid.getStore().getAt(row - 1);
	                rec.set('IncCode', inciCode);
	                rec.set('InvNo', invNo);
	                rec.set('RecQty', qty);
	                rec.set('Rp', rp);
	                rec.set('RpAmt', amt);
	                rec.set('BatchNo', batNo);
	                var d = new Date();
	                d = Date.parseDate(expDate, "Y-n-j");
	                rec.set('ExpDate', d);
	                rec.set('IncId', inci);
	                rec.set('IncDesc', IncDesc);
	                rec.set('Spec', Spec);
	                rec.set('Sp', Sp);
	                rec.set('ManfId', ManfId);
	                rec.set('IngrUomId', IngrUomId);
	                rec.set('BUomId', BUomId);
	                rec.set('InfoRemark', Remark);
	            }
            } else {
                Msg.info('error', "药品代码为" + inciCode + ",的药品信息读取错误,请核查!");
                DetailGrid.getStore().removeAll();
                DetailGrid.getView().refresh();
                return false;
            }
            // 变更按钮是否可用
            //查询^清除^新增^保存^删除^完成^取消完成
            changeButtonEnable("0^1^1^1^1^1^0^1^1");
            SetFieldDisabled(true);
            return true;
        } catch (e) {
            alert('读取数据错误,错误信息:' + e.message);
            DetailGrid.getStore().removeAll();
            DetailGrid.getView().refresh();
            return false;
        }

    }

    var DeleteDetailBT = new Ext.Toolbar.Button({
        id: 'DeleteDetailBT',
        text: '删除一条',
        tooltip: '点击删除',
        width: 70,
        height: 30,
        iconCls: 'page_delete',
        handler: function() {
            deleteDetail();
        }
    });

    var GridColSetBT = new Ext.Toolbar.Button({
        text: '列设置',
        tooltip: '列设置',
        iconCls: 'page_gear',
        width: 70,
        height: 30,
        handler: function() {
            GridColSet(DetailGrid, "DHCSTIMPORT");
        }
    });

    if (gParamCommon[10] == "N") {
        GridColSetBT.hidden = true;
    }

    // 增加按钮
    var AddBT = new Ext.Toolbar.Button({
        id: "AddBT",
        text: '增加一条',
        tooltip: '点击增加',
        width: 70,
        height: 30,
        iconCls: 'page_add',
        handler: function() {
            // 判断入库单是否已审批
            var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
            if (CmpFlag != null && CmpFlag != 0) {
                Msg.info("warning", "入库单已完成不可修改!");
                return;
            }
            // 判断是否选择入库部门和供货厂商
            var phaLoc = Ext.getCmp("PhaLoc").getValue();
            if (phaLoc == null || phaLoc.length <= 0) {
                Msg.info("warning", "请选择入库部门!");
                return;
            }
            var vendor = Ext.getCmp("Vendor").getValue();
            if (vendor == null || vendor.length <= 0) {
                Msg.info("warning", "请选择供应商!");
                return;
            }
            var StkGrpType = Ext.getCmp("StkGrpType").getValue();
            //wyx add 2014-03-17 公共变量取类组设置gParamCommon[9]
            if ((StkGrpType == null || StkGrpType.length <= 0) & (gParamCommon[9] == "N")) {
                Msg.info("warning", "请选择类组!");
                return;
            }
            var operateInType = Ext.getCmp("OperateInType").getValue();
            if ((gParam[8] == "Y") && (operateInType == null || operateInType.length <= 0)) {
                Msg.info("warning", "请选择入库类型!");
                return;
            }
            // 判断是否已经有添加行
            var rowCount = DetailGrid.getStore().getCount();
            if (rowCount > 0) {
                var rowData = DetailStore.data.items[rowCount - 1];
                var data = rowData.get("IncId");
                if (data == null || data.length <= 0) {
                    Msg.info("warning", "已存在新建行!");
                    return;
                }
            }
            addNewRow();
            //查询^清除^新增^保存^删除^完成^取消完成						
            changeButtonEnable("0^1^1^1^1^1^0^0");
        }
    });

    /**
     * 新增一行,addType,参数未1代表导入excel导入
     */
    function addNewRow(addType) {
        var rowCount = DetailGrid.getStore().getCount();
        var InvNo = "";
        var InvDate = "";
        if ((addType != "1") && (rowCount > 0)) {
            var rowData = DetailStore.data.items[rowCount - 1];
            var data = rowData.get("IncId");
            if (data == null || data.length <= 0) {
                var newcolIndex = GetColIndex(DetailGrid, 'IncDesc');
                DetailGrid.startEditing(DetailStore.getCount() - 1, newcolIndex);
                return;
            }
            var InvNo = rowData.get("InvNo");
            var InvDate = rowData.get("InvDate");
        }
        var record = Ext.data.Record.create([{
            name: 'Ingri',
            type: 'string'
        }, {
            name: 'IncId',
            type: 'string'
        }, {
            name: 'IncCode',
            type: 'string'
        }, {
            name: 'IncDesc',
            type: 'string'
        }, {
            name: 'ManfId',
            type: 'string'
        }, {
            name: 'BatchNo',
            type: 'string'
        }, {
            name: 'ExpDate',
            type: 'date'
        }, {
            name: 'IngrUomId',
            type: 'string'
        }, {
            name: 'RecQty',
            type: 'double'
        }, {
            name: 'Rp',
            type: 'double'
        }, {
            name: 'Sp',
            type: 'double'
        }, {
            name: 'Marginnow',
            type: 'double'
        }, {
            name: 'NewSp',
            type: 'double'
        }, {
            name: 'InvNo',
            type: 'string'
        }, {
            name: 'InvMoney',
            type: 'string'
        }, {
            name: 'InvDate',
            type: 'date'
        }, {
            name: 'RpAmt',
            type: 'double'
        }, {
            name: 'SpAmt',
            type: 'double'
        }, {
            name: 'NewSpAmt',
            type: 'double'
        }, {
            name: 'QualityNo',
            type: 'string'
        }, {
            name: 'SxNo',
            type: 'string'
        }, {
            name: 'Remark',
            type: 'string'
        }, {
            name: 'Remarks',
            type: 'string'
        }, {
            name: 'MtDesc',
            type: 'string'
        }, {
            name: 'PubDesc',
            type: 'string'
        }, {
            name: 'Spec',
            type: 'string'
        }, {
            name: 'InfoRemark',
            type: 'string'
        }, {
            name: 'OriginId',
            type: 'string'
        }, {
            name: 'FreeDrugFlag',
            type: 'string'
        }
        ]);

        var NewRecord = new record({
            Ingri: '',
            IncId: '',
            IncCode: '',
            IncDesc: '',
            ManfId: '',
            BatchNo: '',
            ExpDate: '',
            IngrUomId: '',
            RecQty: '',
            Rp: '',
            Marginnow: '',
            Sp: '',
            NewSp: '',
            InvNo: InvNo,
            InvMoney: '',
            InvDate: InvDate,
            RpAmt: '',
            SpAmt: '',
            NewSpAmt: '',
            QualityNo: '',
            SxNo: '',
            Remark: '',
            Remarks: '',
            MtDesc: '',
            PubDesc: '',
            Spec: '',
            InfoRemark: '',
            OriginId:'',
            FreeDrugFlag:''
        });
        DetailStore.add(NewRecord);
        var col = GetColIndex(DetailGrid, 'IncDesc');
        if (addType != 1) {
            DetailGrid.startEditing(DetailStore.getCount() - 1, col);
        }
        SetFieldDisabled(true);
        GetAmount();
    };

    // 保存按钮
    var SaveBT = new Ext.Toolbar.Button({
        id: "SaveBT",
        text: '保存',
        tooltip: '点击保存',
        width: 70,
        height: 30,
        iconCls: 'page_save',
        handler: function() {
            SaveBT.disable();
            setTimeout(ChangeSaveBtn, 3000); //三秒后执行
            if (DetailGrid.activeEditor != null) {
                DetailGrid.activeEditor.completeEdit();
            }
            if (CheckDataBeforeSave() == true) {
                // 调价后保存入库单
                if ((gParam[14] == "Y") & (gParamCommon[7] != 3)) {
                    CreateAdj();
                } else {
                    saveOrder("");
                }
            }
        }
    });

    function ChangeSaveBtn() {
        SaveBT.enable();
    }

    /**
     * 保存入库单前数据检查
     */
    function CheckDataBeforeSave() {
        var nowdate = new Date();
        // 判断入库单是否已审批
        var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
        if (CmpFlag != null && CmpFlag != 0) {
            Msg.info("warning", "入库单已完成不可修改!");
            return false;
        }
        // 判断入库部门和供货商是否为空
        var phaLoc = Ext.getCmp("PhaLoc").getValue();
        if (phaLoc == null || phaLoc.length <= 0) {
            Msg.info("warning", "请选择入库部门!");
            return false;
        }
        var vendor = Ext.getCmp("Vendor").getValue();
        if (vendor == null || vendor.length <= 0) {
            Msg.info("warning", "请选择供应商!");
            return false;
        }
        var IngrTypeId = Ext.getCmp("OperateInType").getValue();
        var PurUserId = Ext.getCmp("PurchaseUser").getValue();
        var PurUserName = Ext.getCmp("PurchaseUser").getRawValue();
        if ((PurUserName == null || PurUserName == "") & (gParam[7] == 'Y')) {
            Msg.info("warning", "采购员不能为空!");
            return false;
        }
        var StkGrpType = Ext.getCmp("StkGrpType").getRawValue();
        if ((StkGrpType == null || StkGrpType.length <= 0) & (gParamCommon[9] == "N")) {
            Msg.info("warning", "请选择类组!");
            return;
        }
        if ((IngrTypeId == null || IngrTypeId == "") & (gParam[8] == 'Y')) {
            Msg.info("warning", "入库类型不能为空!");
            return false;
        }
        // 1.判断入库药品是否为空
        var rowCount = DetailGrid.getStore().getCount();
        // 有效行数
        var count = 0;
        for (var i = 0; i < rowCount; i++) {
            var item = DetailStore.getAt(i).get("IncId");
            if (item != "") {
                count++;
            }
        }
        if (rowCount <= 0 || count <= 0) {
            Msg.info("warning", "请输入入库明细!");
            return false;
        }
        // 2.重新填充背景
        for (var i = 0; i < rowCount; i++) {
            changeBgColor(i, "white");
        }
        // 3.判断重复输入药品
        for (var i = 0; i < rowCount - 1; i++) {
            for (var j = i + 1; j < rowCount; j++) {
                var item_i = DetailStore.getAt(i).get("IncId");
                var item_j = DetailStore.getAt(j).get("IncId");
                var itembatno_i = DetailStore.getAt(i).get("BatchNo");
                var itembatno_j = DetailStore.getAt(j).get("BatchNo");
                var iteminvno_i = DetailStore.getAt(i).get("InvNo");
                var iteminvno_j = DetailStore.getAt(j).get("InvNo");
                var itemdesc = DetailStore.getAt(i).get("IncDesc");
                var icnt = i + 1;
                var jcnt = j + 1;
                if (item_i != "" && item_j != "" &&
                    item_i == item_j && itembatno_i == itembatno_j &&iteminvno_i != "" && iteminvno_j != "" && iteminvno_i == iteminvno_j) {
                    changeBgColor(i, "yellow");
                    changeBgColor(j, "yellow");
                    Msg.info("warning", itemdesc + ",第" + icnt + "," + jcnt + "行" + "药品批号、发票号重复，请重新输入!");
                    return false;
                }
            }
        }
        // 4.药品信息输入错误
        for (var i = 0; i < rowCount; i++) {
            var expDateValue = DetailStore.getAt(i).get("ExpDate");
            var item = DetailStore.getAt(i).get("IncId");
            if (item == null || item == "") {
                break;
            }
            //var ExpDate =new Date(Date.parse(expDateValue.replace(/-/g,"/")));  
            var ExpDate = new Date(Date.parse(expDateValue));
            if ((item != "") && (ExpDate.format("Y-m-d") <= nowdate.format("Y-m-d"))) {
                Msg.info("warning", "有效期不能小于或等于当前日期!");
                var cell = DetailGrid.getSelectionModel().getSelectedCell();
                DetailGrid.getSelectionModel().select(cell[0], 1);
                changeBgColor(i, "yellow");
                return false;
            }
            var qty = DetailStore.getAt(i).get("RecQty");
            if ((item != "") && (qty == null || qty <= 0)) {
                Msg.info("warning", "入库数量不能小于或等于0!");
                var cell = DetailGrid.getSelectionModel().getSelectedCell();
                DetailGrid.getSelectionModel().select(cell[0], 1);
                changeBgColor(i, "yellow");
                return false;
            }
            var realPrice = DetailStore.getAt(i).get("Rp");
            var spPrice = DetailStore.getAt(i).get("Sp");
            var freedrugflag=DetailStore.getAt(i).get('FreeDrugFlag')
            if((freedrugflag=="Y")&&((realPrice!=0)||(spPrice!=0))){
				Msg.info("warning", "免费药入库进价和售价都必须为0!");
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				DetailGrid.getSelectionModel().select(cell[0], 1);
				changeBgColor(i, "yellow");
				return false;
			} 
            if ((item != "") && (realPrice == null || realPrice <= 0)) {
                if ((Ext.getCmp('PresentFlag').getValue() == true)||(freedrugflag=="Y")){
                    if ((realPrice == null || realPrice < 0)) {
                        Msg.info("warning", "捐赠药品或免费药入库进价不能小于0!");
                        var cell = DetailGrid.getSelectionModel().getSelectedCell();
                        DetailGrid.getSelectionModel().select(cell[0], 1);
                        changeBgColor(i, "yellow");
                        return false;
                    }
                    
                }else {
                    Msg.info("warning", "入库进价不能小于或等于0!");
                    var cell = DetailGrid.getSelectionModel().getSelectedCell();
                    DetailGrid.getSelectionModel().select(cell[0], 1);
                    changeBgColor(i, "yellow");
                    return false;
                }
            }
            var desc = DetailStore.getAt(i).get("IncDesc");
//            if (Number(realPrice) > Number(spPrice)) {
//                Msg.info("warning", desc + ",进价不能大于售价!");
//                changeBgColor(i, "yellow");
//                return false;
//            }
            var presentFlag=Ext.getCmp('PresentFlag').getValue()
                 //从新判断仅售价关系  2020-02-14 yangsj 
                 //0 不做任何判断 1 进价必须小于或等于售价 2 赠送入库时可以进价大于售价（其他情况不允许）
                 if ((gParam[18]==1)&&(Number(realPrice) > Number(spPrice)))
                 {
	                 Msg.info("warning", i + 1 + "行,入库进售价关系为1，不允许进价大于售价！");
                     changeBgColor(i, "yellow");
                	 return false;
                 }
                 else if ((gParam[18]==2)&&(Number(realPrice) > Number(spPrice))&&(presentFlag!= true))
                 {
	                 Msg.info("warning", i + 1 + "行,入库进售价关系为2，不允许非捐赠药品进价大于售价！");
                     changeBgColor(i, "yellow");
               		 return false;
                 }
            
            
            var batchNo = DetailStore.getAt(i).get("BatchNo");
            if (batchNo=="") {
                Msg.info("warning", desc + ",请填写批号!");
                changeBgColor(i, "yellow");
                return false;
            }
            var unequalflag = CheckRpEqualSp(i);
            if (unequalflag == false) {
                Msg.info("warning", desc + "为零加成,进售价不符,请核实！");
                changeBgColor(i, "yellow");
            }
            
	        var valVendorPb=gParam[16];
            if ((valVendorPb!="")&&(vendor!="")){
	            var pbVendorStr=tkMakeServerCall("web.DHCST.Common.DrugInfoCommon","GetPbVendor",item);
	            if (pbVendorStr!=""){
		            var pbVendorArr=pbVendorStr.split("^");
		            var pbVendorId=pbVendorArr[0];
	            	if ((pbVendorId!="")&&(vendor!=pbVendorId)){
	                	if (valVendorPb==1){
		                	Msg.info("warning", desc+"的招标供应商为:"+pbVendorArr[1]);
		                }else if(valVendorPb==2){
			            	Msg.info("warning", desc+"药品的招标供应商为:"+pbVendorArr[1]);
			            	return false;
			            }
	                }
	            }
            }
            
        }
        return true;
    }
    //准备调价信息后保存入库记录
    function CreateAdj() {
        var rowCount = DetailGrid.getStore().getCount();
        AdjPriceShow(0, rowCount - 1, "")
    }

    function AdjPriceShow(ind, rowCount, priceStr) {
        if (priceStr != "") {
            var priceArr = priceStr.split("^")
            var rp = priceArr[0]
            var sp = priceArr[1]
            var record1 = DetailStore.getAt(ind - 1);
            record1.set("Rp", rp)
            record1.set("NewSp", sp)
        }
        var record = DetailStore.getAt(ind);
        var IncRowid = record.get("IncId");
        var AdjSpUomId = record.get("IngrUomId");
        var uomdesc = record.get("IngrUom");
        var ResultSp = record.get("Sp"); // record.get("NewSp");
        var ResultRp = record.get("Rp");
        var incicode = record.get("IncCode");
        var incidesc = record.get("IncDesc");
        var StkGrpType = Ext.getCmp("StkGrpType").getValue();
        var strParam = gGroupId + "^" + gLocId + "^" + gUserId
        var url = DictUrl + "ingdrecaction.csp?actiontype=GetPrice&InciId=" + IncRowid + "&UomId=" + AdjSpUomId + "&StrParam=" + strParam + "&StkGrpType=" + StkGrpType;
        var pricestr = ExecuteDBSynAccess(url);
        var priceArr = pricestr.split("^")
        var PriorRp = parseFloat(priceArr[0])
        var PriorSp = parseFloat(priceArr[1])
        var data = IncRowid + "^" + AdjSpUomId + "^" +
            PriorSp + "^" + ResultRp + "^" + gUserId + "^" +
            PriorRp + "^" + ResultSp + "^" + StkGrpType + "^" + gLocId + "^" + incicode + "^" + incidesc + "^" + uomdesc;
        if ((IncRowid != "") && ((parseFloat(PriorRp) != parseFloat(ResultRp)) || (parseFloat(PriorSp) != parseFloat(ResultSp)))) {
            if ((gParamCommon[7]=='1')&&(parseFloat(PriorSp) == parseFloat(ResultSp))){
	            if (ind == rowCount) {
	                saveOrder("");
	            } else {
	                ind++
	                AdjPriceShow(ind, rowCount, "")
	            }
            }else{
	            var ret = confirm(incidesc + "价格发生变化，是否生成调价单?");
	            if (ret == true) {
	                SetAdjPrice(data, saveOrder, AdjPriceShow, ind, rowCount); //循环调用
	            } else {
		        	var freedrugflag=record.get('FreeDrugFlag')
	                if(freedrugflag!="Y"){
			            if (PriorRp <= 0) {
		                    Msg.info("warning", "第"+ ind + 1 + "行,入库进价不能小于或等于0");
		                    return;
		                }   
		            }else{
			            if (PriorRp!=0) {
		                    Msg.info("warning", "第"+ ind + 1 + "行,免费药入库进价必须等于0");
		                    return;
		                } 
			        }
	                record.set("Rp", PriorRp)
	                record.set("NewSp", PriorSp)
	                if (ind == rowCount) {
	                    saveOrder("");
	                } else {
	                    ind++
	                    AdjPriceShow(ind, rowCount, "")
	                }
	            }
            }
        } else {
            if (ind == rowCount) {
                saveOrder("")
            } else {
                ind++
                AdjPriceShow(ind, rowCount, "")
            }
        }
    }

    // 生成调价记录,循环不应用异步
    function SaveAdj(data) {
        var retinfo = ""
        var dataArr = data.split("^")
        var incidesc = dataArr[9]
        var saveRet=tkMakeServerCall("web.DHCST.DHCINGdRec","CreateAdjPrice",data);
        if (saveRet!=0){
	        var errMsg="";
	        if (saveRet==-2){
		    	errMsg="生成单号失败"; 
		    }else if (saveRet==-4){
			    errMsg="存在未生效调价单或当天存在已生效调价单";
			}else if (saveRet==-5){
			    errMsg="调价单生效失败";
			}else{
				errMsg="调价失败";
			}
	    	alert(incidesc + ","+errMsg);
	    	return false;   
	    }
	    return true;
    }

    /*判断药品是否零加成*/
    function CheckRpEqualSp(rownum) {
        var ingdrecData = DetailStore.getAt(rownum);
        var ingdrecInci = ingdrecData.get("IncId"); //药品id
        ///判断药品类组
        var equalflag = tkMakeServerCall("web.DHCST.Common.AppCommon", "GetZeroMarginByInci", ingdrecInci, gGroupId, gLocId, gUserId) //是否需要售价等于进价
        if (equalflag != "Y") {
            return true;
        }
        var ingdrecSp = ingdrecData.get("Sp");
        var ingdrecRp = ingdrecData.get("Rp");
        if (ingdrecSp != ingdrecRp) {
            return false;
        }
    }

    /**
     * 保存入库单
     */
    function saveOrder(priceStr) {
        var IngrNo = Ext.getCmp("InGrNo").getValue();
        var VenId = Ext.getCmp("Vendor").getValue();
        var Completed = (Ext.getCmp("CompleteFlag").getValue() == true ? 'Y' : 'N');
        var LocId = Ext.getCmp("PhaLoc").getValue();
        var CreateUser = gUserId;
        var ExchangeFlag = (Ext.getCmp("ExchangeFlag").getValue() == true ? 'Y' : 'N');
        var PresentFlag = (Ext.getCmp("PresentFlag").getValue() == true ? 'Y' : 'N');
        var IngrTypeId = Ext.getCmp("OperateInType").getValue();
        var PurUserId = Ext.getCmp("PurchaseUser").getValue();
        var StkGrpId = Ext.getCmp("StkGrpType").getValue();
        var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PresentFlag + "^" +
            ExchangeFlag + "^" + IngrTypeId + "^" + PurUserId + "^" + StkGrpId + "^" + "" + "^" + gGroupId + "^" + gLocId + "^" + HospId;
        var ListDetail = "";
        var rowCount = DetailGrid.getStore().getCount();
        //修改最新进价和售价
        if (priceStr != "") {
            var priceArr = priceStr.split("^")
            var rp = priceArr[0]
            var sp = priceArr[1]
            var rowData1 = DetailStore.getAt(rowCount - 1);
            rowData1.set("Rp", rp)
            rowData1.set("NewSp", sp)
        }
        for (var i = 0; i < rowCount; i++) {
            var rowData = DetailStore.getAt(i);
            //新增或数据发生变化时执行下述操作
            if (rowData.data.newRecord || rowData.dirty) {
	            var freedrugflag=rowData.get('FreeDrugFlag')
                var Sp = rowData.get("Sp");
                if(freedrugflag!="Y"){
		            if (Sp <= 0) {
	                    Msg.info("warning", i + 1 + "行,售价不能小于或等于0");
	                    return;
	                }   
	            }else{
		            if (Sp!=0) {
	                    Msg.info("warning", i + 1 + "行,免费药售价必须等于0");
	                    return;
	                } 
		        }
                var Rp = rowData.get("Rp");
                //if (parseFloat(Sp) < parseFloat(Rp)) {
                //    Msg.info("warning", i + 1 + "行,售价不能小于进价");
                //    return;
                //}
                 var presentFlag=Ext.getCmp('PresentFlag').getValue()
                 //从新判断仅售价关系  2020-02-14 yangsj 
                 //0 不做任何判断 1 进价必须小于或等于售价 2 赠送入库时可以进价大于售价（其他情况不允许）
                 if ((gParam[18]==1)&&(parseFloat(Rp)>parseFloat(Sp)))
                 {
	                 Msg.info("warning", i + 1 + "行,入库进售价关系为1，不允许进价大于售价！");
                     return;
                 }
                 else if ((gParam[18]==2)&&(parseFloat(Rp)>parseFloat(Sp))&&(presentFlag!= true))
                 {
	                 Msg.info("warning", i + 1 + "行,入库进售价关系为2，不允许非捐赠药品进价大于售价！");
                     return;
                 }
                
                
                var Ingri = rowData.get("Ingri");
                var IncId = rowData.get("IncId");
                var BatchNo = rowData.get("BatchNo");
                var ExpDate = Ext.util.Format.date(rowData.get("ExpDate"), App_StkDateFormat);
                var ManfId = rowData.get("ManfId");
                var IngrUomId = rowData.get("IngrUomId");
                var RecQty = rowData.get("RecQty");
                
                //新增入库数量是否允许小数判断 2020-02-20 yangsj
                if(gParam[19]!=1)  //1 允许录入小数
                {
                    var buomId=rowData.get("BUomId")
                    var buomQty=RecQty
                    if(buomId!=IngrUomId)
                    {
                        var fac=rowData.get("ConFacPur")
                        buomQty=Number(fac).mul(RecQty);
                    }
                    if((buomQty.toString()).indexOf(".")>=0)
                    {
	                    Msg.info("warning", rowData.get("IncDesc")+" 入库数量换算成基本单位之后存在小数，不能入库！请核对入库配置：入库数量换算为基本单位是否允许小数!");
	                    return;
                    }
                    
                }
    
                var Rp = rowData.get("Rp");
                var NewSp = rowData.get("NewSp");
                var NewSp = Sp;
                var SxNo = rowData.get("SxNo");
                var InvNo = rowData.get("InvNo");
                var InvDate = Ext.util.Format.date(rowData.get("InvDate"), App_StkDateFormat);
                var Remark = rowData.get("Remark");
                var Remarks = rowData.get("Remarks");
                var QualityNo = rowData.get("QualityNo");
                var MtDesc = rowData.get("MtDesc");
                var MtDr = rowData.get("MtDr");
                var OriginId = rowData.get("OriginId");
                var margin=Number(NewSp)/Number(Rp)
                if ((margin!=Infinity)&&(margin>gParam[5])&&(gParam[5]!="")) {
                    Msg.info("warning", "当前药品加成率为"+margin.toFixed(3)+",超限!");
                    return false;
                }
                var str = Ingri + "^" + IncId + "^" + BatchNo + "^" + ExpDate + "^" + ManfId + "^" + 
                		  IngrUomId + "^" + RecQty + "^" + Rp + "^" + NewSp + "^" + SxNo + "^" + 
                		  InvNo + "^" + InvDate + "^" + "" + "^" + Remark + "^" + Remarks + "^" + 
                		  QualityNo + "^" + MtDr + "^" + OriginId;
                if (ListDetail == "") {
                    ListDetail = str;
                } else {
                    ListDetail = ListDetail + RowDelim + str;
                }
                if (gParam[14] != "Y") //是否允许直接调价 LiangQiang 2014-03-14
                {
                    continue;

                }
                var IncDesc = rowData.get("IncDesc");
                var StkGrpType = Ext.getCmp("StkGrpType").getValue();
                var strParam = gGroupId + "^" + gLocId + "^" + gUserId
                if (gParamCommon[7] == '3') {
	            } else {
                    var url = DictUrl + "ingdrecaction.csp?actiontype=GetPrice&InciId=" + IncId + "&UomId=" + IngrUomId + "&StrParam=" + strParam + "&StkGrpType=" + StkGrpType;
                    var pricestr = ExecuteDBSynAccess(url);
                    var priceArr = pricestr.split("^")
                    var PriorRp = priceArr[0]
                    var PriorSp = priceArr[1]
                }
                if ((gParamCommon[7]=='1')&&(PriorSp == NewSp)){
	            	continue;
	            }
                if ((parseFloat(PriorRp) != parseFloat(Rp)) || (parseFloat(PriorSp) != parseFloat(NewSp))) {
                    var pricedata = IncId + "^" + IngrUomId + "^" +
                        NewSp + "^" + Rp + "^" + gUserId + "^" +
                        PriorRp + "^" + PriorSp + "^" + StkGrpType + "^" + gLocId + "^" + IncDesc;
                    var batdata = BatchNo + "^" + ExpDate + "^" + ManfId + "^" + HospId + "^" + Ingri
                    if (gParamCommon[7] == '3') {} else {
                        var saveAdj=SaveAdj(pricedata); //生成调价记录
                        if (saveAdj==false){
	                    	return;
	                    }
                    }
                }
            }
        }

        var url = DictUrl +
            "ingdrecaction.csp?actiontype=Save";
        var loadMask = ShowLoadMask(Ext.getBody(), "处理中...");
        Ext.Ajax.request({
            url: url,
            method: 'POST',
            params: { IngrNo: IngrNo, MainInfo: MainInfo, ListDetail: ListDetail },
            waitMsg: '处理中...',
            success: function(result, request) {
                var jsonData = Ext.util.JSON
                    .decode(result.responseText);
                if (jsonData.success == 'true') {
                    // 刷新界面
                    var IngrRowid = jsonData.info;
                    Msg.info("success", "保存成功!");
                    // 7.显示入库单数据
                    gIngrRowid = IngrRowid;
                    Query(IngrRowid);
                    //根据参数设置自动打印
                    if (gParam[3] == 'Y') {
                        PrintRec(gIngrRowid, gParam[13]);
                    }
                } else {
                    var ret = jsonData.info;
                    if (ret == -99) {
                        Msg.info("error", "加锁失败,不能保存!");
                    } else if (ret == -2) {
                        Msg.info("error", "生成入库单号失败,不能保存!");
                    } else if (ret == -3) {
                        Msg.info("error", "保存入库单失败!");
                    } else if (ret == -4) {
                        Msg.info("error", "未找到需更新的入库单,不能保存!");
                    } else if (ret == -5) {
                        Msg.info("error", "保存入库单明细失败!");
                    } else if (ret == -8) {
                        Msg.info("error", "入库单已完成!");
                    } else if (ret == -9) {
                        Msg.info("error", "入库单已审核!");
                    } else {
                        Msg.info("error", "部分明细保存不成功：" + ret);
                    }
                }
            },
            scope: this
        });
        loadMask.hide();

    }
    // 显示入库单数据
    function Query(IngrRowid) {
        if (IngrRowid == null || IngrRowid.length <= 0 || IngrRowid <= 0) {
            return;
        }
        var LockRet = DHCSTLockToggle(IngrRowid, "G", "L");
        if (LockRet != 0) {
            return false;
        }
        var url = DictUrl +
            "ingdrecaction.csp?actiontype=Select&IngrRowid=" +
            IngrRowid;
        Ext.Ajax.request({
            url: url,
            method: 'POST',
            waitMsg: '查询中...',
            success: function(result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                if (jsonData.success == 'true') {
                    var list = jsonData.info.split("^")
                    if (list.length > 0) {
                        gIngrRowid = IngrRowid;
                        Ext.getCmp("InGrNo").setValue(list[0]);
                        addComboData(Ext.getCmp("Vendor").getStore(), list[1], list[2]);
                        Ext.getCmp("Vendor").setValue(list[1]);
                        addComboData(Ext.getCmp("PhaLoc").getStore(), list[10], list[11]);
                        Ext.getCmp("PhaLoc").setValue(list[10]);
                        addComboData(OperateInTypeStore, list[17], list[18]);
                        Ext.getCmp("OperateInType").setValue(list[17]);
                        Ext.getCmp("PurchaseUser").setValue(list[19]);
                        Ext.getCmp("InGrDate").setValue(list[12]);
                        Ext.getCmp("CompleteFlag").setValue(list[9] == 'Y' ? true : false);
                        Ext.getCmp("PresentFlag").setValue(list[30] == 'Y' ? true : false);
                        Ext.getCmp("ExchangeFlag").setValue(list[31] == 'Y' ? true : false);
                        Ext.getCmp("StkGrpType").setValue(list[27]);
                        // 显示入库单明细数据
                        getDetail(IngrRowid);
                        GetAmount();
                        SetFormOriginal(HisListTab);
                    }
                } else {
                    Msg.info("warning", jsonData.info);
                }
            },
            scope: this
        });
    }

    // 入库明细
    // 访问路径
    var DetailUrl = DictUrl +
        'ingdrecaction.csp?actiontype=QueryIngrDetail&Parref=&start=0&limit=999';

    // 通过AJAX方式调用后台数据
    var proxy = new Ext.data.HttpProxy({
        url: DetailUrl,
        method: "POST"
    });

    // 指定列参数
    var fields = ["Ingri", "IncId", "IncCode", "IncDesc", "ManfId", "Manf", "BatchNo", { name: 'ExpDate', type: 'date', dateFormat: App_StkDateFormat },
        "IngrUomId", "IngrUom", "RecQty", "Rp", "Marginnow", "Sp", "NewSp", "InvNo", "InvMoney", { name: 'InvDate', type: 'date', dateFormat: App_StkDateFormat }, "RpAmt", "SpAmt", "NewSpAmt",
        "QualityNo", "SxNo", "Remark", "Remarks", "MtDesc", "PubDesc", "BUomId", "ConFacPur", "MtDr", "Spec", "InfoRemark","OriginId","OriginDesc",'FreeDrugFlag'
    ];

    // 支持分页显示的读取方式
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "Ingri",
        fields: fields
    });

    // 数据集
    var DetailStore = new Ext.data.Store({
        proxy: proxy,
        reader: reader
    });

    // 显示入库单明细数据
    function getDetail(IngrRowid) {
        if (IngrRowid == null || IngrRowid.length <= 0 || IngrRowid <= 0) {
            return;
        }
        DetailStore.removeAll();
        DetailStore.load({ params: { start: 0, limit: 999, Parref: IngrRowid } });
        var inGrFlag = Ext.getCmp("CompleteFlag").getValue();
        if (inGrFlag == true) {
            changeButtonEnable("1^1^0^0^0^0^1^1");
        } else {
            changeButtonEnable("1^1^1^1^1^1^0^0"); ///
        }
        SetFieldDisabled(true);
    }

    // 变更按钮是否可用
    function changeButtonEnable(str) {
	    try{
	        var list = str.split("^");
	        for (var i = 0; i < list.length; i++) {
	            if (list[i] == "1") {
	                list[i] = false;
	            } else {
	                list[i] = true;
	            }
	        }
	        //查询^清除^新增^保存^删除^完成^取消完成
	        SearchInGrBT.setDisabled(list[0]);
	        ClearBT.setDisabled(list[1]);
	        AddBT.setDisabled(list[2]);
	        SaveBT.setDisabled(list[3]);
	        DeleteInGrBT.setDisabled(list[4]);
	        CompleteBT.setDisabled(list[5]);
	        CancleCompleteBT.setDisabled(list[6]);
	        PrintBT.setDisabled(list[7]);
	    }catch(e){}
    }

    function deleteData() {
        // 判断入库单是否已审批
        var inGrFlag = Ext.getCmp("CompleteFlag").getValue();
        if (inGrFlag != null && inGrFlag != 0) {
            Msg.info("warning", "入库单已完成不可删除!");
            return;
        }
        if (gIngrRowid == "") {
            Msg.info("warning", "没有需要删除的入库单!");
            return;
        }
        Ext.MessageBox.show({
            title: '提示',
            msg: '是否确定删除整张入库单',
            buttons: Ext.MessageBox.YESNO,
            fn: showDeleteGr,
            icon: Ext.MessageBox.QUESTION
        });
    }

    /**
     * 删除入库单提示
     */
    function showDeleteGr(btn) {
        if (btn == "yes") {
            var url = DictUrl +
                "ingdrecaction.csp?actiontype=Delete&IngrRowid=" +
                gIngrRowid;

            Ext.Ajax.request({
                url: url,
                method: 'POST',
                waitMsg: '查询中...',
                success: function(result, request) {
                    var jsonData = Ext.util.JSON
                        .decode(result.responseText);
                    if (jsonData.success == 'true') {
                        // 删除单据
                        Msg.info("success", "入库单删除成功!");
                        clearData();
                    } else {
                        var ret = jsonData.info;
                        if (ret == -1) {
                            Msg.info("error", "入库单已经完成，不能删除!");
                        } else if (ret == -2) {
                            Msg.info("error", "入库单已经审核，不能删除!");
                        } else if (ret == -3) {
                            Msg.info("error", "入库单部分明细已经审核，不能删除!");
                        } else {
                            Msg.info("error", "删除失败,请查看错误日志!");
                        }
                    }
                },
                scope: this
            });
        }
    }

    /**
     * 删除选中行药品
     */
    function deleteDetail() {
        // 判断入库单是否已完成
        var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
        if (CmpFlag != null && CmpFlag != false) {
            Msg.info("warning", "入库单已完成不能删除!");
            return;
        }
        var cell = DetailGrid.getSelectionModel().getSelectedCell();
        if (cell == null) {
            Msg.info("warning", "没有选中行!");
            return;
        }
        // 选中行
        var row = cell[0];
        var record = DetailGrid.getStore().getAt(row);
        var Ingri = record.get("Ingri");
        if (Ingri == "") {
            DetailGrid.getStore().remove(record);
            DetailGrid.getView().refresh();
            GetAmount();
            if (DetailStore.getCount() == 0) {
                SetFieldDisabled(false);
            }
        } else {
            Ext.MessageBox.show({
                title: '提示',
                msg: '是否确定删除该药品信息',
                buttons: Ext.MessageBox.YESNO,
                fn: showResult,
                icon: Ext.MessageBox.QUESTION
            });

        }
    }
    /**
     * 删除提示
     */
    function showResult(btn) {
        if (btn == "yes") {
            var cell = DetailGrid.getSelectionModel().getSelectedCell();
            var row = cell[0];
            var record = DetailGrid.getStore().getAt(row);
            var Ingri = record.get("Ingri");

            // 删除该行数据
            var url = DictUrl +
                "ingdrecaction.csp?actiontype=DeleteDetail&Rowid=" +
                Ingri;

            Ext.Ajax.request({
                url: url,
                method: 'POST',
                waitMsg: '查询中...',
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    if (jsonData.success == 'true') {
                        Msg.info("success", "删除成功!");
                        DetailGrid.getStore().remove(record);
                        DetailGrid.getView().refresh();
                        if (DetailStore.getCount() == 0) {
                            SetFieldDisabled(false);
                        }
                        GetAmount();
                        
                    } else {
                        var ret = jsonData.info;
                        if (ret == -1) {
                            Msg.info("error", "入库单已经完成，不能删除!");
                        } else if (ret == -2) {
                            Msg.info("error", "入库单已经审核，不能删除!");
                        } else if (ret == -4) {
                            Msg.info("error", "该明细数据已经审核，不能删除!");
                        } else {
                            Msg.info("error", "删除失败,请查看错误日志!");
                        }
                    }
                },
                scope: this
            });
        }
    }


    /**
     * 完成入库单
     */
    function Complete() {
        var PurUserName = Ext.getCmp("PurchaseUser").getRawValue();
        if ((PurUserName == null || PurUserName == "") & (gParam[7] == 'Y')) {
            Msg.info("warning", "采购员不能为空!");
            return;
        }
        var StkGrpType = Ext.getCmp("StkGrpType").getRawValue();
        if ((StkGrpType == null || StkGrpType.length <= 0) & (gParamCommon[9] == "N")) {
            Msg.info("warning", "请选择类组!");
            return;
        }
        // 判断入库单是否已完成
        var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
        if (CompleteFlag != null && CompleteFlag != 0) {
            Msg.info("warning", "入库单已完成!");
            return;
        }
        var InGrNo = Ext.getCmp("InGrNo").getValue();
        if (InGrNo == null || InGrNo.length <= 0) {
            Msg.info("warning", "没有需要完成的入库单!");
            return;
        }
        //===========================
        var rowData = DetailStore.getAt(0);
        if (rowData == "" || rowData == undefined) {
            Msg.info("warning", "没有需要完成的数据明细!");
            return;
        }
        //===========================
        var url = DictUrl +
            "ingdrecaction.csp?actiontype=MakeComplete&Rowid=" +
            gIngrRowid + "&User=" + gUserId;
        Ext.Ajax.request({
            url: url,
            method: 'POST',
            waitMsg: '查询中...',
            success: function(result, request) {
                var jsonData = Ext.util.JSON
                    .decode(result.responseText);
                if (jsonData.success == 'true') {
                    // 审核单据
                    Msg.info("success", "成功!");
                    // 显示入库单数据
                    Query(gIngrRowid);
                    //查询^清除^新增^保存^删除^完成^取消完成			
                    changeButtonEnable("1^1^0^0^0^0^1^1");
                } else {
                    var Ret = jsonData.info;
                    if (Ret == -1) {
                        Msg.info("error", "操作失败,入库单Id为空或入库单不存在!");
                    } else if (Ret == -2) {
                        Msg.info("error", "入库单已经完成!");
                    } else {
                        Msg.info("error", "操作失败!");
                    }
                }
            },
            scope: this
        });
    }

    /**
     * 取消完成入库单
     */
    function CancleComplete() {
        var InGrNo = Ext.getCmp("InGrNo").getValue();
        if (InGrNo == null || InGrNo.length <= 0) {
            Msg.info("warning", "没有需要取消完成的入库单!");
            return;
        }
        var url = DictUrl +
            "ingdrecaction.csp?actiontype=CancleComplete&Rowid=" +
            gIngrRowid + "&User=" + gUserId;
        Ext.Ajax.request({
            url: url,
            method: 'POST',
            waitMsg: '查询中...',
            success: function(result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                if (jsonData.success == 'true') {
                    // 审核单据
                    Msg.info("success", "取消成功!");
                    // 显示入库单数据
                    Query(gIngrRowid);
                    //查询^清除^新增^保存^删除^完成^取消完成			
                    changeButtonEnable("1^1^1^1^1^1^0^0");
                } else {
                    var Ret = jsonData.info;
                    if (Ret == -1) {
                        Msg.info("error", "审批失败,入库单Id为空或入库单不存在!");
                    } else if (Ret == -2) {
                        Msg.info("error", "入库单尚未完成!");
                    } else if (Ret == -3) {
                        Msg.info("error", "入库单已审核!");
                    } else {
                        Msg.info("error", "操作失败!");
                    }
                }
            },
            scope: this
        });
    }

    // 单位
    var CTUom = new Ext.form.ComboBox({
        fieldLabel: '单位',
        id: 'CTUom',
        name: 'CTUom',
        anchor: '90%',
        width: 120,
        store: ItmUomStore,
        valueField: 'RowId',
        displayField: 'Description',
        allowBlank: false,
        triggerAction: 'all',
        emptyText: '单位...',
        selectOnFocus: true,
        forceSelection: true,
        minChars: 1,
        pageSize: 10,
        listWidth: 250,
        valueNotFoundText: ''
    });

    // 生产厂商
    var Phmnf = new Ext.ux.ComboBox({
        fieldLabel: '厂商',
        id: 'Phmnf',
        name: 'Phmnf',
        anchor: '90%',
        width: 100,
        store: PhManufacturerStore,
        valueField: 'RowId',
        displayField: 'Description',
        filterName: 'PHMNFName',
        listeners: {
            specialkey: function(field, e) {
                if (e.getKey() == Ext.EventObject.ENTER) {
                    if (setEnterSort(DetailGrid, colArr)) {
                        addNewRow();
                    }
                }
            }
        }
    });
	
	// 效期
    var ExpDateEditor = new Ext.ux.DateField({
        selectOnFocus: true,
        allowBlank: false,
        listeners: {
            specialkey: function(field, e) {
                if (e.getKey() == Ext.EventObject.ENTER) {
                    // 判断入库单是否已完成																		
                    var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
                    if (CompleteFlag != null && CompleteFlag != false) {
                        Msg.info("warning", "入库单已完成!");
                        return;
                    }
                    if (field.getValue() == "") {
                        Msg.info("warning", "有效期不能为空!");
                        return;
                    };
                    var expDate = field.getValue().format('Y-m-d');
                    var flag = ExpDateValidator(expDate);
                    if (flag == false) {
                        Msg.info('warning', '该药品距离失效期少于' + gParam[2] + '天!');
                    }
                    if (setEnterSort(DetailGrid, colArr)) {
                        addNewRow();
                    }
                }
            }
        }
    });

    ExpDateEditor.addListener('blur', function(thisField) {
        if (thisField == null) {
            return;
        }
        var expDate = thisField.getValue();
        if (expDate == null || expDate == "") {
            Msg.info("warning", "有效期不可为空!")
            return;
        } else {
            expDate = expDate.format('Y-m-d');
        }

        var flag = ExpDateValidator(expDate);
        if (flag == false) {
            Msg.info('warning', '该药品距离失效期少于' + gParam[2] + '天!');
            return;
        }
    })
	
	// 发票
    var InvNoEditor = new Ext.form.TextField({
        selectOnFocus: true,
        allowBlank: true,
        listeners: {
            specialkey: function(field, e) {
                if (e.getKey() == Ext.EventObject.ENTER) {
                    // 判断入库单是否已完成																		
                    var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
                    if (CompleteFlag != null && CompleteFlag != false) {
                        Msg.info("warning", "入库单已完成!");
                        return;
                    }
                    var cell = DetailGrid.getSelectionModel().getSelectedCell();
                    var invNo = field.getValue();
                    var flag = InvNoValidator(invNo, gIngrRowid);
                    var col = 0;
                    if (flag == false) {
                        Msg.info("warning", "该发票号已存在于别的入库单");
                    }
                    if (setEnterSort(DetailGrid, colArr)) {
                        addNewRow();
                    }
                }
            }
        }
    })

    InvNoEditor.addListener('blur', function(field) {
        var value = field.getValue();
        var flag = InvNoValidator(value, gIngrRowid);
        if (flag == false) {
            Msg.info("warning", "该发票号已存在于别的入库单");
        }
    });
	
	// 进价
    var RpEditor = new Ext.form.NumberField({
        selectOnFocus: true,
        allowBlank: false,
        decimalPrecision: rpdecimal,
        listeners: {
            specialkey: function(field, e) {
                if (e.getKey() == Ext.EventObject.ENTER) {
                    var cost = field.getValue();
                    var presentFlag=Ext.getCmp('PresentFlag').getValue()
                    var cell = DetailGrid.getSelectionModel().getSelectedCell();
                    var record = DetailGrid.getStore().getAt(cell[0]);
                     
	                    
                    
                    var freedrugflag=record.get('FreeDrugFlag')
                    if ((freedrugflag!="Y")&&((cost == null || cost.length <= 0))) {
                        Msg.info("warning", "进价不能为空!");
                        return;
                    }
                    if((freedrugflag=="Y")&&(cost!=0)){
	                    Msg.info("warning", "免费药进价必须为0!");
                        return; 
	                }
                    if (cost <= 0) {
                        if ((presentFlag== true)||(freedrugflag=="Y")) {
                            if (cost < 0) {
                                Msg.info("warning", "进价不能小于0!");
                                return;
                            }
                        } else {
                            Msg.info("warning", "进价不能小于或等于0!");
                            return;
                        }
                    }
                    if ((gParamCommon[7] == 3) && (gParam[15] == 1)) {
                        var IncId = record.get('IncId')
                        var UomId = record.get('IngrUomId')
                        var Rp = cost;
                        var url = 'dhcst.inadjpriceaction.csp?actiontype=GetMtSp&InciId=' + IncId + '&UomId=' + UomId + '&Rp=' + Rp;
                        var responseText = ExecuteDBSynAccess(url);
                        var jsonData = Ext.util.JSON.decode(responseText);
                        record.set("Sp", jsonData);
                    }
                    //验证加成率
                    var sp = record.get("Sp");
                    
	                 //在通过进价计算售价完成之后再比较进价和售价的关系  2020-02-14 yangsj 
	                 //0 不做任何判断 1 进价必须小于或等于售价 2 赠送入库时可以进价大于售价（其他情况不允许）
	                 if ((gParam[18]==1)&&(cost>sp))
	                 {
		                 Msg.info("warning", "入库进售价关系为1，不允许进价大于售价！");
	                     return;
	                 }
	                 else if ((gParam[18]==2)&&(cost>sp)&&(presentFlag!= true))
	                 {
		                 Msg.info("warning", "入库进售价关系为2，不允许非捐赠药品进价大于售价！");
	                     return;
	                 }
                    
                    
                    var margin = "";
                    if (cost <= 0) {
                        margin = ""
                    } else {
                        margin = sp / cost;
                    }
                    var colIndex = GetColIndex(DetailGrid, 'Rp');
                    DetailGrid.stopEditing(cell[0], colIndex); //弹出前先置完成编辑 LiangQiang 2013-11-22
                    var ingdrecInci = record.get("IncId");
                    var equalflag = tkMakeServerCall("web.DHCST.Common.AppCommon", "GetZeroMarginByInci", ingdrecInci, gGroupId, gLocId, gUserId) //是否需要售价等于进价
                    if ((equalflag != "Y") && ((gParam[5]!=""&&margin > gParam[5]) || margin < 1)) {
	                    alert(gParam[5]+"$"+margin)
                        Ext.MessageBox.confirm('提示', '加成率超出限定范围,继续?',
                            function(btn) {
                                if (btn == 'no') {
                                    var colIndex = GetColIndex(DetailGrid, 'Rp');
                                    DetailGrid.startEditing(cell[0], colIndex);
                                    return;
                                } else {

                                    if (gParamCommon[7] != '3') {
                                        if (setEnterSort(DetailGrid, colArr)) {
                                            addNewRow();
                                        }
                                    } else {
                                        if (setEnterSort(DetailGrid, colArr)) {
                                            addNewRow();
                                        }
                                    }
                                }
                            })
                    } else {
                        if (gParamCommon[7] != '3') {
                            if (setEnterSort(DetailGrid, colArr)) {
                                addNewRow();
                            }
                        } else {
                            var colIndex = GetColIndex(DetailGrid, 'Sp');
                            if (equalflag == "Y") {
                                record.set("Sp", record.get("Rp"));
                            }
                            if (setEnterSort(DetailGrid, colArr)) {
                                addNewRow();
                            }
                        }
                    }
                    // 计算指定行的进货金额
                    var RealTotal = record.get("RecQty") * cost;
                    record.set("RpAmt", RealTotal);
                    record.set("InvMoney", RealTotal);
                    record.set("Marginnow", margin.toFixed(3));
                
                
                  
                }
                
            }
        }
    })
	
	// 售价
    var SpEditor = new Ext.form.NumberField({
        selectOnFocus: true,
        allowBlank: false,
        decimalPrecision: spdecimal,
        listeners: {
            specialkey: function(field, e) {
                if (e.getKey() == Ext.EventObject.ENTER) {
                    var cost = field.getValue();
                    var cell = DetailGrid.getSelectionModel().getSelectedCell();
                    var record = DetailGrid.getStore().getAt(cell[0]);
                    var freedrugflag=record.get('FreeDrugFlag')
                    if (cost == null || cost.length <= 0) {
                        Msg.info("warning", "售价不能为空!");
                        record.set("Sp", 0);
                        return;
                    }
                    if((freedrugflag=="Y")&&(cost!=0)){
	                    Msg.info("warning","免费药售价必须为0!");
                        return;
	                }
                    if ((freedrugflag!="Y")&&(cost <= 0)) {
                        Msg.info("warning","售价不能小于或等于0!");
                        return;
                    }
                    
                    var rp = record.get("Rp");
                    var presentFlag=Ext.getCmp('PresentFlag').getValue()
                     //在通过进价计算售价完成之后再比较进价和售价的关系  2020-02-14 yangsj 
	                 //0 不做任何判断 1 进价必须小于或等于售价 2 赠送入库时可以进价大于售价（其他情况不允许）
	                 if ((gParam[18]==1)&&(rp>cost))
	                 {
		                 Msg.info("warning", "入库进售价关系为1，不允许进价大于售价！");
	                     return;
	                 }
	                 else if ((gParam[18]==2)&&(rp>cost)&&(presentFlag!= true))
	                 {
		                 Msg.info("warning", "入库进售价关系为2，不允许非捐赠药品进价大于售价！");
	                     return;
	                 }
                    
                    
                    // 计算指定行的进货金额
                    var SaleTotal = record.get("RecQty") * cost;
                    record.set("SpAmt", SaleTotal);
                   	if (setEnterSort(DetailGrid, colArr)) {
                        addNewRow();
                    }
                }
            }
        }
    })
    
	// 产地
	var Origin = new Ext.ux.ComboBox({
		fieldLabel : '产地',
		id : 'Origin',
		name : 'Origin',
		anchor : '90%',
		width : 50,
		store : OriginStore,
		filterName:'FilterDesc',
        listeners: {
            specialkey: function(field, e) {
                if (e.getKey() == Ext.EventObject.ENTER) {
                    if (setEnterSort(DetailGrid, colArr)) {
                        addNewRow();
                    }
                }
            }
        }
	});
				
    var nm = new Ext.grid.RowNumberer();
    var DetailCm = new Ext.grid.ColumnModel([nm, {
            header: "rowid",
            dataIndex: 'Ingri',
            width: 100,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: "IncRowid",
            dataIndex: 'IncId',
            width: 80,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: '药品代码',
            dataIndex: 'IncCode',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: '药品名称',
            dataIndex: 'IncDesc',
            width: 230,
            align: 'left',
            sortable: true,
            editor: new Ext.grid.GridEditor(new Ext.form.TextField({
                selectOnFocus: true,
                allowBlank: false,
                listeners: {
                    specialkey: function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            // 判断入库单是否已完成																		
                            var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
                            if (CompleteFlag != null && CompleteFlag != false) {
                                Msg.info("warning", "入库单已完成!");
                                return;
                            }
                            var group = Ext.getCmp("StkGrpType").getValue();
                            GetPhaOrderInfo(field.getValue(), group);
                        }
                    }
                }
            }))
        }, {
            header: "厂商",
            dataIndex: 'ManfId',
            width: 180,
            align: 'left',
            sortable: true,
            editor: new Ext.grid.GridEditor(Phmnf),
            renderer: Ext.util.Format.comboRenderer2(Phmnf, "ManfId", "Manf")
        }, {
            header: "批号",
            dataIndex: 'BatchNo',
            width: 90,
            align: 'left',
            sortable: true,
            editor: new Ext.grid.GridEditor(new Ext.form.TextField({
                selectOnFocus: true,
                allowBlank: false,
                listeners: {
                    specialkey: function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            // 判断入库单是否已完成																		
                            var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
                            if (CompleteFlag != null && CompleteFlag != false) {
                                Msg.info("warning", "入库单已完成!");
                                return;
                            }
                            var batchNo = field.getValue();
                            if (batchNo == null || batchNo.length <= 0) {
                                Msg.info("warning", "批号不能为空!");
                                return;
                            }
                            if (setEnterSort(DetailGrid, colArr)) {
                                addNewRow();
                            }
                        }
                    }
                }
            }))
        }, {
            header: "有效期",
            dataIndex: 'ExpDate',
            width: 100,
            align: 'center',
            sortable: true,
            renderer: Ext.util.Format.dateRenderer(App_StkDateFormat),
            editor: ExpDateEditor
        }, {
            header: "单位",
            dataIndex: 'IngrUomId',
            width: 80,
            align: 'left',
            sortable: true,
            renderer: Ext.util.Format.comboRenderer2(CTUom, "IngrUomId", "IngrUom"),
            editor: new Ext.grid.GridEditor(CTUom),
            listeners: {
                specialkey: function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        if (setEnterSort(DetailGrid, colArr)) {
                            addNewRow();
                        }
                    }
                }
            }
        }, {
            header: "数量",
            dataIndex: 'RecQty',
            width: 80,
            align: 'right',
            sortable: true,
            editor: new Ext.ux.NumberField({
                formatType: 'FmtSQ',
                selectOnFocus: true,
                allowBlank: false,
                listeners: {
                    specialkey: function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            // 判断入库单是否已完成																		
                            var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
                            if (CompleteFlag != null && CompleteFlag != false) {
                                Msg.info("warning", "入库单已完成!");
                                return;
                            }
                            var qty = field.getValue();
                            if (qty == null || qty.length <= 0) {
                                Msg.info("warning", "入库数量不能为空!");
                                return;
                            }
                            if (qty <= 0) {
                                Msg.info("warning", "入库数量不能小于或等于0!");
                                return;
                            }
                            
                             // 计算指定行的进货金额和入库售价
                            var cell = DetailGrid.getSelectionModel().getSelectedCell();
                            var record = DetailGrid.getStore().getAt(cell[0]);
                            
                           
                            //新增入库数量是否允许小数判断 2020-02-20 yangsj
                            if(gParam[19]!=1)  //1 允许录入小数
                            {
	                            var buomId=record.get("BUomId")
	                            var ingrUomId=record.get("IngrUomId")
	                            var buomQty=qty
	                            if(buomId!=ingrUomId)
	                            {
		                            var fac=record.get("ConFacPur")
		                            buomQty=Number(fac).mul(qty);
	                            }
	                            if((buomQty.toString()).indexOf(".")>=0)
	                            {
		                            Msg.info("warning", "入库数量换算成基本单位之后存在小数，不能入库！请核对入库配置：入库数量换算为基本单位是否允许小数!");
	                                return;
	                            }
	                            
                            }
                           
                            var RealTotal = Number(record.get("Rp")).mul(qty);
                            var SaleTotal = Number(record.get("Sp")).mul(qty);
                            var NewSpAmt = Number(record.get("NewSp")).mul(qty);
                            record.set("RpAmt", RealTotal);
                            record.set("SpAmt", SaleTotal);
                            record.set("NewSpAmt", NewSpAmt);
                            record.set("InvMoney", RealTotal);
                            // 判断是否已经有添加行
                            var rowCount = DetailGrid.getStore().getCount();
                            if (rowCount > 0) {
                                var rowData = DetailStore.data.items[rowCount - 1];
                                var data = rowData.get("IncId");
                                if (data == null || data.length <= 0) {
                                    return;
                                }
                            }
                            if (setEnterSort(DetailGrid, colArr)) {
                                addNewRow();
                            }
                        }
                    }
                }
            })
        }, {
            header: "进价",
            dataIndex: 'Rp',
            width: 60,
            align: 'right',
            sortable: true,
            editor: RpEditor
        }, {
            header: "售价",
            dataIndex: 'Sp',
            width: 60,
            align: 'right',
            sortable: true,
            editor: SpEditor
        }, {
            header: "当前加成",
            dataIndex: 'Marginnow',
            width: 60,
            align: 'right',
            sortable: true,
            renderer: function(value) {
                return '<span style="FONT-SIZE:14px;COLOR:#CC0000 ;">' + value + '</span>';
            }
        }, {
            header: "入库售价",
            dataIndex: 'NewSp',
            width: 60,
            align: 'right',
            hidden: true,
            sortable: true,
            editor: new Ext.form.NumberField({
                selectOnFocus: true,
                allowBlank: false,
                listeners: {
                    specialkey: function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var cost = field.getValue();
                            if (cost == null ||
                                cost.length <= 0) {
                                Msg.info("warning", "入库售价不能为空!");
                                return;
                            }
                            if (cost <= 0) {
                                Msg.info("warning",
                                    "入库售价不能小于或等于0!");
                                return;
                            }
                            // 计算指定行的售价金额
                            var cell = DetailGrid.getSelectionModel().getSelectedCell();
                            var record = DetailGrid.getStore().getAt(cell[0]);
                            var NewSpAmt = record.get("RecQty").mul(cost);
                            record.set("NewSpAmt", NewSpAmt);
                            if (setEnterSort(DetailGrid, colArr)) {
                                addNewRow();
                            }
                        }
                    }
                }
            })
        }, {
            header: "发票号",
            dataIndex: 'InvNo',
            width: 80,
            align: 'left',
            sortable: true,
            editor: InvNoEditor
        }, {
            header: "发票金额",
            dataIndex: 'InvMoney',
            width: 80,
            align: 'right',
            editable: false,
            renderer: FormatGridRpAmount,
            editor: new Ext.ux.NumberField({
                formatType: 'FmtRA',
                selectOnFocus: true,
                allowNegative: false,
                allowBlank: false
            })

        },
        {
            header: "发票日期",
            dataIndex: 'InvDate',
            width: 100,
            align: 'center',
            sortable: true,
            renderer: Ext.util.Format.dateRenderer(App_StkDateFormat),
            editor: new Ext.ux.DateField({
                selectOnFocus: true,
                allowBlank: true,
                listeners: {
                    specialkey: function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            // 判断入库单是否已完成																		
                            var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
                            if (CompleteFlag != null && CompleteFlag != false) {
                                Msg.info("warning", "入库单已完成!");
                                return;
                            }
                            var invDate = field.getValue();
                            if (setEnterSort(DetailGrid, colArr)) {
                                addNewRow();
                            }
                        }
                    }
                }
            })
        }, {
            header: "质检单号",
            dataIndex: 'QualityNo',
            width: 90,
            align: 'left',
            sortable: true,
            editor: new Ext.form.TextField({
                selectOnFocus: true,
                allowBlank: true,
                listeners: {
                    specialkey: function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            if (setEnterSort(DetailGrid, colArr)) {
                                addNewRow();
                            }
                            GetAmount();
                        }
                    }
                }
            })

        }, {
            header: "随行单号",
            dataIndex: 'SxNo',
            width: 90,
            align: 'left',
            sortable: true,
            editor: new Ext.form.TextField({
                selectOnFocus: true,
                allowBlank: true,
                listeners: {
                    specialkey: function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            if (setEnterSort(DetailGrid, colArr)) {
                                addNewRow();
                            }
                            GetAmount();
                        }
                    }
                }
            })
        }, {
            header: "进货金额",
            dataIndex: 'RpAmt',
            width: 100,
            align: 'right',
            sortable: true,
            renderer: FormatGridRpAmount,
            editable: (gParam[6] == 'Y' ? true : false),
            editor: new Ext.ux.NumberField({
                formatType: 'FmtRA',
                selectOnFocus: true,
                allowNegative: false,
                allowBlank: false
            })
        }, {
            header: "入库售价合计",
            dataIndex: 'NewSpAmt',
            width: 100,
            align: 'right',
            sortable: true,
            renderer: FormatGridSpAmount
        }, {
            header: "定价类型",
            dataIndex: 'MtDesc',
            width: 180,
            align: 'left',
            sortable: true
        }, {
            header: "招标名称",
            dataIndex: 'PubDesc',
            width: 180,
            align: 'left',
            sortable: true
        }, {
            header: "摘要",
            dataIndex: 'Remark',
            width: 90,
            align: 'left',
            sortable: true,
            editor: new Ext.form.TextField({
                selectOnFocus: true,
                allowBlank: true,
                listeners: {
                    specialkey: function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            if (setEnterSort(DetailGrid, colArr)) {
                                addNewRow();
                            }
                            GetAmount();
                        }
                    }
                }
            })
        }, {
            header: "备注",
            dataIndex: 'Remarks',
            width: 90,
            align: 'left',
            sortable: true,
            editor: new Ext.form.TextField({
                selectOnFocus: true,
                allowBlank: true,
                listeners: {
                    specialkey: function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            if (setEnterSort(DetailGrid, colArr)) {
                                addNewRow();
                            }
                            GetAmount();
                        }
                    }
                }
            })
        }, {
            header: "BUomId",
            dataIndex: 'BUomId',
            width: 100,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: "ConFacPur",
            dataIndex: 'ConFacPur',
            width: 100,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: "MtDr",
            dataIndex: 'MtDr',
            width: 80,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: "MtDr2",
            dataIndex: 'MtDr2',
            width: 80,
            align: 'left',
            sortable: true,
            hidden: true
        }, {
            header: "规格",
            dataIndex: 'Spec',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: "批准文号",
            dataIndex: 'InfoRemark',
            width: 80,
            align: 'left',
            sortable: true
        },{
			header : "产地",
			dataIndex : 'OriginId',
			width : 180,
			align : 'left',
			sortable : true,
			editor : new Ext.grid.GridEditor(Origin),
			renderer :Ext.util.Format.comboRenderer2(Origin,"OriginId","OriginDesc")	 
		}, {
            header: "免费药标识",
            dataIndex: 'FreeDrugFlag',
            width: 80,
            align: 'left',
            sortable: true
        }
    ]);

    var DetailGrid = new Ext.grid.EditorGridPanel({
        id: 'DetailGrid',
        title: '入库单明细',
        region: 'center',
        cm: DetailCm,
        store: DetailStore,
        trackMouseOver: true,
        stripeRows: true,
        loadMask: true,
        sm: new Ext.grid.CellSelectionModel({}),
        tbar: { items: [AddBT, '-', DeleteDetailBT, '-', GridColSetBT] },
        bbar: new Ext.Toolbar({ items: [NumAmount, RpAmount, SpAmount] }),
        clicksToEdit: 1
    });

    DetailGrid.getView().on('refresh', function(Grid) {
        GetAmount()  
    })

    DetailGrid.on('beforeedit', function(e) {
        if (e.field == "ManfId") {
            var store = Ext.getCmp('Phmnf').getStore();
            addComboData(store, e.record.get('ManfId'), e.record.get('Manf'));
        }
        if (e.field == "IngrUomId") {
            var store = Ext.getCmp('CTUom').getStore();
            addComboData(store, e.record.get('IngrUomId'), e.record.get('IngrUom'));
        }
        if (e.field == "Sp") {
            if (gParamCommon[7] != '3') {
                e.cancel = true;
            }
        }
        /*取配置,动态设置小数保留位数,yunhaibao201511224*/
        if ((e.field == "Rp") || (e.field == "Sp")) {
            var ingruomid = e.record.get('IngrUomId');
            var ingrinci = e.record.get('IncId');
            var decimalstr = tkMakeServerCall("web.DHCST.Common.AppCommon", "GetDecimalCommon", gGroupId, gLocId, gUserId, ingrinci, ingruomid);
            var decimalarr = decimalstr.split("^");
            RpEditor.decimalPrecision = decimalarr[0];
            SpEditor.decimalPrecision = decimalarr[2];
        }

    });

    /// 添加右键菜单
    DetailGrid.addListener('rowcontextmenu', rightClickFn); //右键菜单代码关键部分 
    var rightClick = new Ext.menu.Menu({
        id: 'rightClickCont',
        items: [{
            id: 'mnuDelete',
            handler: deleteDetail,
            text: '删除'
        }]
    });

    //右键菜单代码关键部分 
    function rightClickFn(grid, rowindex, e) {
        e.preventDefault();
        rightClick.showAt(e.getXY());
    }

    /**
     * 调用药品窗体并返回结果
     */
    function GetPhaOrderInfo(item, group) {
        var LocId = Ext.getCmp("PhaLoc").getValue();
        if (item != null && item.length > 0) {
            GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",
                getDrugList, DetailGrid);
        }
    }

    /**
     * 返回方法
     */
    function getDrugList(record) {
        //DetailGrid.setDisabled(false)
        if (record == null || record == "") {
            return;
        }
        var inciDr = record.get("InciDr");
        var inciCode = record.get("InciCode");
        var inciDesc = record.get("InciDesc");
        var cell = DetailGrid.getSelectionModel().getSelectedCell();
        // 选中行
        var row = cell[0];
        var rowData = DetailGrid.getStore().getAt(row);
        rowData.set("IncId", inciDr);
        rowData.set("IncCode", inciCode);
        rowData.set("IncDesc", inciDesc);;
        var LocId = Ext.getCmp("PhaLoc").getValue();
        var Params = session['LOGON.GROUPID'] + '^' + session['LOGON.CTLOCID'] + '^' + gUserId;
        //取其它药品信息
        var url = DictUrl +
            "ingdrecaction.csp?actiontype=GetItmInfo&IncId=" +
            inciDr + "&Params=" + Params;
        Ext.Ajax.request({
            url: url,
            method: 'POST',
            waitMsg: '查询中...',
            success: function(result, request) {
                var jsonData = Ext.util.JSON
                    .decode(result.responseText);
                if (jsonData.success == 'true') {
                    var data = jsonData.info.split("^");
                    addComboData(PhManufacturerStore, data[0], data[1]);
                    rowData.set("ManfId", data[0]);
                    addComboData(ItmUomStore, data[2], data[3]);
                    rowData.set("IngrUomId", data[2]);
                    if((Ext.getCmp('PresentFlag').getValue()==true)||(data[19]=="Y")){
	                    rowData.set("Rp", 0);
                    }else{
                    	rowData.set("Rp", Number(data[4]));
                    }
                    if(data[19]=="Y"){
	                    rowData.set("Sp", 0);
	                }else{
                    	rowData.set("Sp", Number(data[5]));
	                }
                    rowData.set("NewSp", Number(data[5]));
                    rowData.set("BatchNo", data[6]);
                    var colIndex = GetColIndex(DetailGrid, 'BatchNo');
                    DetailGrid.stopEditing(cell[0], colIndex); //弹出前先置完成编辑 LiangQiang 2013-11-22																
                    rowData.set("ExpDate", toDate(data[7]));
                    rowData.set("MtDesc", data[8]);
                    rowData.set("PubDesc", data[9]);
                    rowData.set("BUomId", data[10]);
                    rowData.set("ConFacPur", data[11]);
                    rowData.set("MtDr", data[12]);
                    rowData.set("Spec", data[14]);
                    rowData.set("InfoRemark", data[15]);
                    rowData.set("FreeDrugFlag", data[19]);
                    //产地
                    addComboData(OriginStore, data[20], data[21]);
                    rowData.set("OriginId", data[20]);
                    //对比最高售价
                    if (gParam[9] == "Y" & data[13] != "") {
                        if (Number(data[5]) > Number(data[13])) {
                            Msg.info("warning", "当前售价高于最高售价!");
                        }
                    }
                    //验证中标信息
	               	var pbVendorId=data[17];
                    var valVendorPb=gParam[16];
                    if ((valVendorPb!="")&&(pbVendorId!="")){
	                	var selVendorId=Ext.getCmp("Vendor").getValue();
	                	if (selVendorId!=pbVendorId){
		                	if (valVendorPb==1){
			                	Msg.info("warning", "该药品的招标供应商为:"+data[18]);
			                }else if(valVendorPb==2){
				            	Msg.info("warning", "该药品的招标供应商为:"+data[18]);
				            	    var col = GetColIndex(DetailGrid, 'IncDesc');
						            DetailGrid.startEditing(cell[0], col);
				            		return;
				            }
		                }
	                }
                    //光标跳到批号
                    if (setEnterSort(DetailGrid, colArr)) {
                        addNewRow();
                    }
                    if (gParam[17]=='Y'){
	                    //=====================判断资质====================
	                    var vendor = Ext.getCmp("Vendor").getValue();
	                    var inci = record.get("InciDr")
	                    var DataList = vendor + "^" + inci + "^" + data[0]
	                    var urldh = DictUrl + "ingdrecaction.csp?actiontype=Check&DataList=" + DataList
	                    Ext.Ajax.request({
	                        url: urldh,
	                        method: 'POST',
	                        waitMsg: '查询中...',
	                        success: function(result, request) {
	                            var jsonData = Ext.util.JSON
	                                .decode(result.responseText);
	                            if (jsonData.success == 'true') {
	                           
									var ret=jsonData.info;
									if(ret==100){ 
									    Msg.info("warning", "供应商合同已经过期!");
		                                return;
		                            }
		                            if(ret==101){
			                            Msg.info("warning", "供应商合同将在30天内过期!");
										return;
									}
									if(ret==1){ 
									    Msg.info("warning", "供应商工商执照已经过期!");
		                                return;
		                            }
		                            if(ret==30){
			                            Msg.info("warning", "供应商工商执照将在30天内过期!");
										return;
									}
									if(ret==3){  
										Msg.info("warning", "供应商税务执照已经过期!");
										return;
									}
									if(ret==31){  
										Msg.info("warning", "供应商税务执照将在30天内过期!");
										return;
									}
								    if(ret==4){  
										Msg.info("warning", "供应商药品经营许可证已经过期!");
										return;
									}
									if(ret==32){  
										Msg.info("warning", "供应商药品经营许可证将在30天内过期!");
										return;
									}		
									if(ret==5){  
										Msg.info("warning", "供应商器械经营许可证已经过期!");
										return;
									}
									if(ret==33){  
										Msg.info("warning", "供应商器械经营许可证将在30天内过期!");
										return;
									}		
									if(ret==6){  
										Msg.info("warning", "供应商器械注册证已经过期!");
										return;
									}
									if(ret==34){  
										Msg.info("warning", "供应商器械注册证将在30天内过期!");
										return;
									}
									if(ret==7){ 
										Msg.info("warning", "供应商药品注册批件已经过期!");
										return;
									}
									if(ret==35){  
										Msg.info("warning", "供应商药品注册批件将在30天内过期!");
										return;
									}
									if(ret==8){  
										Msg.info("warning", "供应商机构代码已经过期!");
										return;
									}
									if(ret==36){  
										Msg.info("warning", "供应商机构代码将在30天内过期!");
										return;
									}
									if(ret==9){  
										Msg.info("warning", "供应商GSP认证已经过期!");
										return;
									}
									if(ret==37){  
										Msg.info("warning", "供应商GSP认证将在30天内过期!");
										return;
									}
									if(ret==10){  
										Msg.info("warning", "供应商器械生产许可证已经过期!");
										return;
									}
									if(ret==38){  
										Msg.info("warning", "供应商器械生产许可证将在30天内过期!");
										return;
									}
									if(ret==11){  
										Msg.info("warning", "供应商药品生产许可证已经过期!");
										return;
									}
									if(ret==39){  
										Msg.info("warning", "供应商药品生产许可证将在30天内过期!");
										return;
									}
									if(ret==12){  
										Msg.info("warning", "供应商进口注册证已经过期!");
										return;
									}
									if(ret==40){  
										Msg.info("warning", "供应商进口注册证将在30天内过期!");
										return;
									}
									if(ret==13){  
										Msg.info("warning", "供应商进口注册登记表已经过期!");
										return;
									}
									if(ret==41){  
										Msg.info("warning", "供应商进口注册登记表将在30天内过期!");
										return;
									}
									if(ret==14){  
										Msg.info("warning", "供应商代理授权书已经过期!");
										return;
									}
									if(ret==42){  
										Msg.info("warning", "供应商代理授权书将在30天内过期!");
										return;
									}
									if(ret==15){  
										Msg.info("warning", "供应商质量承诺书已经过期!");
										return;
									}
									if(ret==43){  
										Msg.info("warning", "供应商质量承诺书将在30天内过期!");
										return;
									}
									if(ret==16){  
										Msg.info("warning", "供应商业务员授权书已经过期!");
										return;
									}
									if(ret==44){  
										Msg.info("warning", "供应商业务员授权书将在30天内过期!");
										return;
									}
									if(ret==19){  
										Msg.info("warning", "厂商药品生产许可证已经过期!");
										return;
									}
									if(ret==45){  
										Msg.info("warning", "厂商药品生产许可证将在30天内过期!");
										return;
									}
									if(ret==20){  
										Msg.info("warning", "厂商物资生产许可证已经过期!");
										return;
									}
									if(ret==46){  
										Msg.info("warning", "厂商物资生产许可证将在30天内过期!");
										return;
									}
									if(ret==21){  
										Msg.info("warning", "厂商工商执照已经过期!");
										return;
									}
									if(ret==47){  
										Msg.info("warning", "厂商工商执照在30天内过期!");
										return;
									}
									if(ret==22){  
										Msg.info("warning", "厂商工商注册号已经过期!");
										return;
									}
									if(ret==48){  
										Msg.info("warning", "厂商工商注册号将在30天内过期!");
										return;
									}
									if(ret==23){  
										Msg.info("warning", "厂商组织机构代码已经过期!");
										return;
									}
									if(ret==49){  
										Msg.info("warning", "厂商组织机构代码将在30天内过期!");
										return;
									}																																							
									if(ret==24){		
										Msg.info("warning", "厂商器械经营许可证已经过期!");
										return;
									}
									if(ret==50){		
										Msg.info("warning", "厂商器械经营许可证将在30天内过期!");
										return;
									}
									if(ret==26){		
										Msg.info("warning", "批准文号已经过期!");
										return ;
									}
									if(ret==51){		
										Msg.info("warning", "批准文号将在30天内过期!");
										return;
									}
								    if(ret==27){		
										Msg.info("warning", "进口注册证已经过期!");
										return;
									}
									if(ret==52){		
										Msg.info("warning", "进口注册证将在30天内过期!");
										return;
									}	                            
							    }
	                        },
	                        scope: this
	                    });
                    }
	                    //========================判断资质=============================
	                }
	            },
	            scope: this
	        });

    }

    /**
     * 单位展开事件
     */
    CTUom.on('expand', function(combo) {
        var cell = DetailGrid.getSelectionModel().getSelectedCell();
        var record = DetailGrid.getStore().getAt(cell[0]);
        var InciDr = record.get("IncId");
        ItmUomStore.removeAll();
        ItmUomStore.load({ params: { ItmRowid: InciDr } });
    });

    /**
     * 单位变换事件
     */
    CTUom.on('select', function(combo) {
        var cell = DetailGrid.getSelectionModel().getSelectedCell();
        var record = DetailGrid.getStore().getAt(cell[0]);
        var value = combo.getValue(); //目前选择的单位id
        var BUom = record.get("BUomId");
        var ConFac = record.get("ConFacPur"); //大单位到小单位的转换关系					
        var IngrUom = record.get("IngrUomId"); //目前显示的入库单位
        var Sp = Number(record.get("Sp"));
        var Rp = Number(record.get("Rp"));
        var NewSp = Number(record.get("NewSp"));
        var InciRowid = record.get("IncId");
        var Params = session['LOGON.GROUPID'] + '^' + session['LOGON.CTLOCID'] + '^' + gUserId;

        if (value == null || value.length <= 0) {
            return;
        } else if (IngrUom == value) {
            return;
        } else {
            var tmpprice = tkMakeServerCall("web.DHCST.DHCINGdRec", "GetChangRpSp", InciRowid, value, Params)
            var pricestr = tmpprice.split("^");
            record.set("Rp", pricestr[0]);
            record.set("Sp", pricestr[1]);
        }
        var RpAmt = Number(record.get("Rp")).mul(record.get("RecQty"));
        var SpAmt = Number(record.get("Sp")).mul(record.get("RecQty"));
        var NewSpAmt = Number(record.get("NewSp")).mul(record.get("RecQty"));
        record.set("RpAmt", RpAmt);
        record.set("InvMoney", RpAmt);
        record.set("SpAmt", SpAmt);
        record.set("NewSpAmt", NewSpAmt);
        record.set("IngrUomId", combo.getValue());

    });

    // 变换行颜色
    function changeBgColor(row, color) {
        DetailGrid.getView().getRow(row).style.backgroundColor = color;
    }

    var HisListTab = new Ext.form.FormPanel({
        id: 'MainForm',
        labelWidth: 60,
        region: 'north',
        height: DHCSTFormStyle.FrmHeight(3),
        labelAlign: 'right',
        title: '入库单制单',
        frame: true,
        autoScroll: false,
        tbar: [SearchInGrBT, '-', ClearBT, '-', SaveBT, '-', CompleteBT, '-', CancleCompleteBT, '-', PrintBT, '-', DeleteInGrBT, '->', ImportButton],
        items: [{
            xtype: 'fieldset',
            title: '入库信息',
            style: DHCSTFormStyle.FrmPaddingV,
            layout: 'column', // Specifies that the items will now be arranged in columns
            defaults: { border: false },
            items: [{
                columnWidth: 0.35,
                labelWidth: 60,
                xtype: 'fieldset',
                //defaultType: 'textfield',
                border: false,
                items: [PhaLoc, Vendor, StkGrpType]
            }, {
                columnWidth: 0.25,
                labelWidth: 60,
                xtype: 'fieldset',
                //defaultType: 'textfield',
                border: false,
                items: [InGrNo, InGrDate, OperateInType]
            }, {
                columnWidth: 0.2,
                labelWidth: 60,
                xtype: 'fieldset',
                //defaultType: 'textfield',
                border: false,
                items: [PurchaseUser]
            }, {
                columnWidth: 0.2,
                labelWidth: 60,
                xtype: 'fieldset',
                //defaultType: 'textfield',
                border: false,
                items: [CompleteFlag, PresentFlag, ExchangeFlag]
            }]
        }]
    });

    // 页面布局
    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: [HisListTab, DetailGrid],
        renderTo: 'mainPanel'
    });

    RefreshGridColSet(DetailGrid, "DHCSTIMPORT"); //根据自定义列设置重新配置列
    colArr = sortColoumByEnterSort(DetailGrid);
    if (gIngrRowid != null && gIngrRowid != '' && gFlag == 1) {
        Query(gIngrRowid);
    }

    //-------------------Events-------------------//

    //设置Grid悬浮显示窗体
    //Creator:LiangQiang 2013-11-20
    DetailGrid.on('mouseover', function(e) {
        if (gParam[12] != "Y") {
            return;
        }
        var phaLoc = Ext.getCmp("PhaLoc").getValue();
        var rowCount = DetailGrid.getStore().getCount();
        if (rowCount > 0) {
            var ShowInCellIndex = GetColIndex(DetailGrid, 'IncCode'); //在第几列显示
            var index = DetailGrid.getView().findRowIndex(e.getTarget());
            var record = DetailGrid.getStore().getAt(index);
            if (record) {
                var desc = record.data.IncDesc;
                var inci = record.data.IncId;
            }
            ShowInciRecListWin(e, DetailGrid, ShowInCellIndex, desc, inci, phaLoc);
        }

    }, this, { buffer: 200 });

    /*看是否修改*/
    function Modified() {
        var detailCnt = 0
        var rowCount = DetailGrid.getStore().getCount();
        for (var i = 0; i < rowCount; i++) {
            var item = DetailGrid.getStore().getAt(i).get("IncId");
            if (item != "") {
                detailCnt++;
            }
        }
        var result = false;
        //若为新单(gIngrRowid"")，看子表是否有插入
        if ((gIngrRowid <= 0) || (gIngrRowid == '')) {
            if (detailCnt == 0) {
                result = false;
            } else {
                result = true;
            }
        } else { //若不为新单，看主表或子表	
            var mod = Ext.getCmp('MainForm').getForm().isDirty();
            var modGrid = false;
            var rowsModified = DetailGrid.getStore().getModifiedRecords();
            if (rowsModified.length > 0) modGrid = true
            if (mod || modGrid) {
                result = true
            } else {
                result = false
            }
        }
        return result;
    }

    function isDataChanged() {
        var changed = false;
        var count1 = DetailGrid.getStore().getCount();
        //看主表数据是否有修改
        //修改为主表有修改且子表有数据时进行提示
        if ((IsFormChanged(HisListTab)) && (count1 != 0)) {
            changed = true;
        };
        if (changed) return changed;
        //看明细数据是否有修改
        var count = DetailGrid.getStore().getCount();
        for (var index = 0; index < count; index++) {
            var rec = DetailGrid.getStore().getAt(index);
            //新增或数据发生变化时执行下述操作
            if (rec.data.newRecord || rec.dirty) {
                changed = true;
            }
        }
        return changed;
    }

    /*设置原始值，维持初始未修改状态*/
    function setOriginalValue1(formId) {
        if (formId == "") return;
        Ext.getCmp(formId).getForm().items.each(function(f) {
            f.originalValue = String(f.getValue());
        });
    }

    //设置可编辑组件的disabled属性
    function SetFieldDisabled(bool) {
        Ext.getCmp("StkGrpType").setDisabled(bool);
    }

    ///退出或刷新时,界面提示是否保存
    window.onbeforeunload = function() {
        var compFlag = Ext.getCmp('CompleteFlag').getValue();
        var mod = isDataChanged();
        if (mod && (!compFlag)) {
            return "数据已录入或修改,你当前的操作将丢失这些结果,是否继续？";
        }
        DHCSTLockToggle(gIngrRowid, "G", "UL")
    }
})