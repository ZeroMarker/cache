// /����: ��ⵥ�Ƶ�
// /����: ��ⵥ�Ƶ�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.06.27
var rpdecimal = 2 //Ĭ�Ͻ��ۼ�С��
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
    var Msg_LostModified = '������¼����޸ģ��㵱ǰ�Ĳ�������ʧ��Щ������Ƿ����?';
    if (gParam.length < 1) {
        GetParam(); //��ʼ����������
    }
    if (gParamCommon.length < 1) {
        GetParamCommon(); //��ʼ�������������� wyx ��������ȡ��������gParamCommon[9]
    }

    var PhaLoc = new Ext.ux.LocComboBox({
        fieldLabel: '��ⲿ��',
        id: 'PhaLoc',
        name: 'PhaLoc',
        anchor: '80%',
        emptyText: '��ⲿ��...',
        groupId: gGroupId,
        listeners: {
            'select': function(e) {
                var SelLocId = Ext.getCmp('PhaLoc').getValue(); //add wyx ����ѡ��Ŀ��Ҷ�̬��������
                StkGrpType.getStore().removeAll();
                StkGrpType.getStore().setBaseParam("locId", SelLocId)
                StkGrpType.getStore().setBaseParam("userId", UserId)
                StkGrpType.getStore().setBaseParam("type", App_StkTypeCode)
                StkGrpType.getStore().load();
                PurchaseUser.getStore().removeAll(); //����ѡ��Ŀ��Ҷ�̬���زɹ�Ա
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



    // ҩƷ����
    var StkGrpType = new Ext.ux.StkGrpComboBox({
        id: 'StkGrpType',
        name: 'StkGrpType',
        StkType: App_StkTypeCode, //��ʶ��������
        LocId: gLocId,
        UserId: gUserId,
        anchor: '80%'
    });

    // �������
    var OperateInType = new Ext.ux.ComboBox({
        fieldLabel: '�������',
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
	    // Ĭ��ѡ�е�һ������
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
            if (OperateInType.getValue() == "") { //û��Ĭ��Ĭ�ϵ�һ��
                //OperateInType.setValue(OperateInTypeStore.getAt(0).data.RowId);
            }
        }
    }

    // ��ⵥ��
    var InGrNo = new Ext.form.TextField({
        fieldLabel: '��ⵥ��',
        id: 'InGrNo',
        name: 'InGrNo',
        anchor: '90%',
        disabled: true
    });
    //=========ͳ�����=======		
    // ��ҳ����
    var NumAmount = new Ext.form.TextField({
        emptyText: '��ҳ����',
        id: 'NumAmount',
        name: 'NumAmount',
        anchor: '90%',
        width: 200
    });

    // ���ۺϼ�
    var RpAmount = new Ext.form.TextField({
        emptyText: '���ۺϼ�',
        id: 'RpAmount',
        name: 'RpAmount',
        width: 200,
        anchor: '90%'
    });

    // �ۼۺϼ�
    var SpAmount = new Ext.form.TextField({
        emptyText: '�ۼۺϼ�',
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
        Count = "��ǰ����:" + " " + Count
        RpAmt = "���ۺϼ�:" + " " + RpAmt + " " + "Ԫ"
        SpAmt = "�ۼۺϼ�:" + " " + SpAmt + " " + "Ԫ"
        Ext.getCmp("NumAmount").setValue(Count)
        Ext.getCmp("RpAmount").setValue(RpAmt)
        Ext.getCmp("SpAmount").setValue(SpAmt)
    }
    //=========ͳ�����=======	

    // �������
    var InGrDate = new Ext.ux.DateField({
        fieldLabel: '�������',
        id: 'InGrDate',
        name: 'InGrDate',
        anchor: '90%',
        value: new Date(),
        disabled: true
    });

    // �ɹ���Ա
    var PurchaseUser = new Ext.ux.ComboBox({
        fieldLabel: '�ɹ���Ա',
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

    // ��ɱ�־
    var CompleteFlag = new Ext.form.Checkbox({
        boxLabel: '���',
        id: 'CompleteFlag',
        name: 'CompleteFlag',
        anchor: '90%',
        checked: false,
        disabled: true
    });

    // ��ҩ����־
    var PresentFlag = new Ext.form.Checkbox({
        boxLabel: '����',
        id: 'PresentFlag',
        name: 'PresentFlag',
        anchor: '90%',
        checked: false
    });

    // ���ۻ�Ʊ��־
    var ExchangeFlag = new Ext.form.Checkbox({

        id: 'ExchangeFlag',
        name: 'ExchangeFlag',
        anchor: '90%',
        checked: false,
        boxLabel: '���ۻ�Ʊ'
    });

    // ��ӡ��ⵥ��ť
    var PrintBT = new Ext.Toolbar.Button({
        id: "PrintBT",
        text: '��ӡ',
        tooltip: '�����ӡ��ⵥ',
        width: 70,
        height: 30,
        iconCls: 'page_print',
        handler: function() {
            PrintRec(gIngrRowid, gParam[13]);
        }
    });

    // ��ѯ��ⵥ��ť
    var SearchInGrBT = new Ext.Toolbar.Button({
        id: "SearchInGrBT",
        text: '��ѯ',
        tooltip: '�����ѯ��ⵥ',
        width: 70,
        height: 30,
        iconCls: 'page_find',
        handler: function() {
            DrugImportGrSearch(DetailStore, Query);
        }
    });

    // ��հ�ť
    var ClearBT = new Ext.Toolbar.Button({
        id: "ClearBT",
        text: '����',
        tooltip: '�������',
        width: 70,
        height: 30,
        iconCls: 'page_clearscreen',
        handler: function() {
            var compFlag = Ext.getCmp('CompleteFlag').getValue();
            var mod = Modified();
            if (mod && (!compFlag)) {
                Ext.Msg.show({
                    title: '��ʾ',
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
    // ��ɰ�ť
    var CompleteBT = new Ext.Toolbar.Button({
        id: "CompleteBT",
        text: '���',
        tooltip: '������',
        width: 70,
        height: 30,
        iconCls: 'page_gear',
        handler: function() {
            var compFlag = Ext.getCmp('CompleteFlag').getValue();
            var mod = isDataChanged();
            if (mod && (!compFlag)) {
                Ext.Msg.confirm('��ʾ', '�����ѷ����ı�,�Ƿ���Ҫ��������?',
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

    // ȡ����ɰ�ť
    var CancleCompleteBT = new Ext.Toolbar.Button({
        id: "CancleCompleteBT",
        text: 'ȡ�����',
        tooltip: '���ȡ�����',
        width: 70,
        height: 30,
        iconCls: 'page_gear',
        handler: function() {
            CancleComplete();
        }
    });
    // ɾ����ť
    var DeleteInGrBT = new Ext.Toolbar.Button({
        id: "DeleteInGrBT",
        text: 'ɾ��',
        tooltip: '���ɾ��',
        width: 70,
        height: 30,
        iconCls: 'page_delete',
        handler: function() {
            deleteData();
        }
    });

    /**
     * ��շ���
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
        //��ѯ^���^����^����^ɾ��^���^ȡ�����			
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
            Msg.info("warning", "��ⵥ����ɲ����޸�!");
            return;
        }
        if (Ext.getCmp('Vendor').getValue() == '') {
            Msg.info('warning', '��ѡ��Ӧ��!');
            return;
        }
        if (impWindow) {
            impWindow.ShowOpen();
        } else {
	        try{impWindow = new ActiveXObject("MSComDlg.CommonDialog");
	        }
	        catch (err){
		        alert(err+ " ��ȷ��MSComDlg.CommonDialog.reg�Ƿ�ע��ɹ� ")
	        	window.open("../scripts/dhcst/InGdRec/MSComDlg.CommonDialog.reg", "_blank");
	        	return;
	        }
	        
            impWindow = new ActiveXObject("MSComDlg.CommonDialog");
            impWindow.Filter = "Excel(*.xls;*xlsx)|*.xls;*.xlsx";
            impWindow.FilterIndex = 1;
            // ��������MaxFileSize. �������
            impWindow.MaxFileSize = 32767;
            impWindow.ShowOpen();
        }

        var fileName = impWindow.FileName;
        if (fileName == '') {
            Msg.info('warning', '��ѡ��Excel�ļ�!');
            return;
        }
        ReadFromExcel(fileName, impLine);
    }
    
    function ImportBySCIFn(){
    	DrugImportGrSCI(Query);
    }
    
    var ImportButton = new Ext.Button({
            text: '��������',
            width: 70,
            height: 30,
            iconCls: 'page_add',
            tooltip: '�������밴ť',
            menu: {
                items: [
                    {
                    	text: '��ƽ̨��������',iconCls : 'page_edit', handler: ImportBySCIFn
                    },
                    {
                        text: 'Excelģ�嵼��',
                        iconCls: 'page_upload',
                        //handler:   //ImportByExcel
                        handler:function(){
								    jsReadExcelAsJson(callBacktest)
								}

                    }, {
                        text: 'Excelģ������',
                        iconCls: 'page_download',
                        handler: function() {
                            window.open("../scripts/dhcst/InGdRec/ҩƷ��ⵥ����ģ��.xls", "_blank");
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
        
        ///���������ݵ���һ����¼
    function impLineNew(detail, rowNumber) {
        try {
            //			���� ------- ��Ʊ��---- - ����----- - ����----- ��� - ----����- ------Ч��------
            var inciCode = detail.����;
            var invNo = detail.��Ʊ��
            var qty = detail.����;
            var rp = detail.����;
            var amt = detail.���;
            var batNo = detail.����;
            var expDate = detail.Ч��;
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
	                    Msg.info('warning', '��' + rowNumber + '��: ' + inciCode + ' Ϊ"������"״̬!');
	                    return;
	                }
	                //colArr=sortColoumByEnterSort(DetailGrid); //���س��ĵ���˳���ʼ����
	                // ����һ��
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
                Msg.info('error', "ҩƷ����Ϊ" + inciCode + ",��ҩƷ��Ϣ��ȡ����,��˲�!");
                DetailGrid.getStore().removeAll();
                DetailGrid.getView().refresh();
                return false;
            }
            // �����ť�Ƿ����
            //��ѯ^���^����^����^ɾ��^���^ȡ�����
            changeButtonEnable("0^1^1^1^1^1^0^1^1");
            SetFieldDisabled(true);
            return true;
        } catch (e) {
            alert('��ȡ���ݴ���,������Ϣ:' + e.message);
            DetailGrid.getStore().removeAll();
            DetailGrid.getView().refresh();
            return false;
        }

    }


    
        ///���������ݵ���һ����¼
    function impLine(s, rowNumber) {
        var ss = s.split('\t');
        try {
            //			���� ------- ��Ʊ��---- - ����----- - ����----- ��� - ----����- ------Ч��------
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
	                    Msg.info('warning', '��' + rowNumber + '��: ' + inciCode + ' Ϊ"������"״̬!');
	                    return;
	                }
	                //colArr=sortColoumByEnterSort(DetailGrid); //���س��ĵ���˳���ʼ����
	                // ����һ��
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
                Msg.info('error', "ҩƷ����Ϊ" + inciCode + ",��ҩƷ��Ϣ��ȡ����,��˲�!");
                DetailGrid.getStore().removeAll();
                DetailGrid.getView().refresh();
                return false;
            }
            // �����ť�Ƿ����
            //��ѯ^���^����^����^ɾ��^���^ȡ�����
            changeButtonEnable("0^1^1^1^1^1^0^1^1");
            SetFieldDisabled(true);
            return true;
        } catch (e) {
            alert('��ȡ���ݴ���,������Ϣ:' + e.message);
            DetailGrid.getStore().removeAll();
            DetailGrid.getView().refresh();
            return false;
        }

    }

    var DeleteDetailBT = new Ext.Toolbar.Button({
        id: 'DeleteDetailBT',
        text: 'ɾ��һ��',
        tooltip: '���ɾ��',
        width: 70,
        height: 30,
        iconCls: 'page_delete',
        handler: function() {
            deleteDetail();
        }
    });

    var GridColSetBT = new Ext.Toolbar.Button({
        text: '������',
        tooltip: '������',
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

    // ���Ӱ�ť
    var AddBT = new Ext.Toolbar.Button({
        id: "AddBT",
        text: '����һ��',
        tooltip: '�������',
        width: 70,
        height: 30,
        iconCls: 'page_add',
        handler: function() {
            // �ж���ⵥ�Ƿ�������
            var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
            if (CmpFlag != null && CmpFlag != 0) {
                Msg.info("warning", "��ⵥ����ɲ����޸�!");
                return;
            }
            // �ж��Ƿ�ѡ����ⲿ�ź͹�������
            var phaLoc = Ext.getCmp("PhaLoc").getValue();
            if (phaLoc == null || phaLoc.length <= 0) {
                Msg.info("warning", "��ѡ����ⲿ��!");
                return;
            }
            var vendor = Ext.getCmp("Vendor").getValue();
            if (vendor == null || vendor.length <= 0) {
                Msg.info("warning", "��ѡ��Ӧ��!");
                return;
            }
            var StkGrpType = Ext.getCmp("StkGrpType").getValue();
            //wyx add 2014-03-17 ��������ȡ��������gParamCommon[9]
            if ((StkGrpType == null || StkGrpType.length <= 0) & (gParamCommon[9] == "N")) {
                Msg.info("warning", "��ѡ������!");
                return;
            }
            var operateInType = Ext.getCmp("OperateInType").getValue();
            if ((gParam[8] == "Y") && (operateInType == null || operateInType.length <= 0)) {
                Msg.info("warning", "��ѡ���������!");
                return;
            }
            // �ж��Ƿ��Ѿ��������
            var rowCount = DetailGrid.getStore().getCount();
            if (rowCount > 0) {
                var rowData = DetailStore.data.items[rowCount - 1];
                var data = rowData.get("IncId");
                if (data == null || data.length <= 0) {
                    Msg.info("warning", "�Ѵ����½���!");
                    return;
                }
            }
            addNewRow();
            //��ѯ^���^����^����^ɾ��^���^ȡ�����						
            changeButtonEnable("0^1^1^1^1^1^0^0");
        }
    });

    /**
     * ����һ��,addType,����δ1������excel����
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

    // ���水ť
    var SaveBT = new Ext.Toolbar.Button({
        id: "SaveBT",
        text: '����',
        tooltip: '�������',
        width: 70,
        height: 30,
        iconCls: 'page_save',
        handler: function() {
            SaveBT.disable();
            setTimeout(ChangeSaveBtn, 3000); //�����ִ��
            if (DetailGrid.activeEditor != null) {
                DetailGrid.activeEditor.completeEdit();
            }
            if (CheckDataBeforeSave() == true) {
                // ���ۺ󱣴���ⵥ
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
     * ������ⵥǰ���ݼ��
     */
    function CheckDataBeforeSave() {
        var nowdate = new Date();
        // �ж���ⵥ�Ƿ�������
        var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
        if (CmpFlag != null && CmpFlag != 0) {
            Msg.info("warning", "��ⵥ����ɲ����޸�!");
            return false;
        }
        // �ж���ⲿ�ź͹������Ƿ�Ϊ��
        var phaLoc = Ext.getCmp("PhaLoc").getValue();
        if (phaLoc == null || phaLoc.length <= 0) {
            Msg.info("warning", "��ѡ����ⲿ��!");
            return false;
        }
        var vendor = Ext.getCmp("Vendor").getValue();
        if (vendor == null || vendor.length <= 0) {
            Msg.info("warning", "��ѡ��Ӧ��!");
            return false;
        }
        var IngrTypeId = Ext.getCmp("OperateInType").getValue();
        var PurUserId = Ext.getCmp("PurchaseUser").getValue();
        var PurUserName = Ext.getCmp("PurchaseUser").getRawValue();
        if ((PurUserName == null || PurUserName == "") & (gParam[7] == 'Y')) {
            Msg.info("warning", "�ɹ�Ա����Ϊ��!");
            return false;
        }
        var StkGrpType = Ext.getCmp("StkGrpType").getRawValue();
        if ((StkGrpType == null || StkGrpType.length <= 0) & (gParamCommon[9] == "N")) {
            Msg.info("warning", "��ѡ������!");
            return;
        }
        if ((IngrTypeId == null || IngrTypeId == "") & (gParam[8] == 'Y')) {
            Msg.info("warning", "������Ͳ���Ϊ��!");
            return false;
        }
        // 1.�ж����ҩƷ�Ƿ�Ϊ��
        var rowCount = DetailGrid.getStore().getCount();
        // ��Ч����
        var count = 0;
        for (var i = 0; i < rowCount; i++) {
            var item = DetailStore.getAt(i).get("IncId");
            if (item != "") {
                count++;
            }
        }
        if (rowCount <= 0 || count <= 0) {
            Msg.info("warning", "�����������ϸ!");
            return false;
        }
        // 2.������䱳��
        for (var i = 0; i < rowCount; i++) {
            changeBgColor(i, "white");
        }
        // 3.�ж��ظ�����ҩƷ
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
                    Msg.info("warning", itemdesc + ",��" + icnt + "," + jcnt + "��" + "ҩƷ���š���Ʊ���ظ�������������!");
                    return false;
                }
            }
        }
        // 4.ҩƷ��Ϣ�������
        for (var i = 0; i < rowCount; i++) {
            var expDateValue = DetailStore.getAt(i).get("ExpDate");
            var item = DetailStore.getAt(i).get("IncId");
            if (item == null || item == "") {
                break;
            }
            //var ExpDate =new Date(Date.parse(expDateValue.replace(/-/g,"/")));  
            var ExpDate = new Date(Date.parse(expDateValue));
            if ((item != "") && (ExpDate.format("Y-m-d") <= nowdate.format("Y-m-d"))) {
                Msg.info("warning", "��Ч�ڲ���С�ڻ���ڵ�ǰ����!");
                var cell = DetailGrid.getSelectionModel().getSelectedCell();
                DetailGrid.getSelectionModel().select(cell[0], 1);
                changeBgColor(i, "yellow");
                return false;
            }
            var qty = DetailStore.getAt(i).get("RecQty");
            if ((item != "") && (qty == null || qty <= 0)) {
                Msg.info("warning", "�����������С�ڻ����0!");
                var cell = DetailGrid.getSelectionModel().getSelectedCell();
                DetailGrid.getSelectionModel().select(cell[0], 1);
                changeBgColor(i, "yellow");
                return false;
            }
            var realPrice = DetailStore.getAt(i).get("Rp");
            var spPrice = DetailStore.getAt(i).get("Sp");
            var freedrugflag=DetailStore.getAt(i).get('FreeDrugFlag')
            if((freedrugflag=="Y")&&((realPrice!=0)||(spPrice!=0))){
				Msg.info("warning", "���ҩ�����ۺ��ۼ۶�����Ϊ0!");
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				DetailGrid.getSelectionModel().select(cell[0], 1);
				changeBgColor(i, "yellow");
				return false;
			} 
            if ((item != "") && (realPrice == null || realPrice <= 0)) {
                if ((Ext.getCmp('PresentFlag').getValue() == true)||(freedrugflag=="Y")){
                    if ((realPrice == null || realPrice < 0)) {
                        Msg.info("warning", "����ҩƷ�����ҩ�����۲���С��0!");
                        var cell = DetailGrid.getSelectionModel().getSelectedCell();
                        DetailGrid.getSelectionModel().select(cell[0], 1);
                        changeBgColor(i, "yellow");
                        return false;
                    }
                    
                }else {
                    Msg.info("warning", "�����۲���С�ڻ����0!");
                    var cell = DetailGrid.getSelectionModel().getSelectedCell();
                    DetailGrid.getSelectionModel().select(cell[0], 1);
                    changeBgColor(i, "yellow");
                    return false;
                }
            }
            var desc = DetailStore.getAt(i).get("IncDesc");
//            if (Number(realPrice) > Number(spPrice)) {
//                Msg.info("warning", desc + ",���۲��ܴ����ۼ�!");
//                changeBgColor(i, "yellow");
//                return false;
//            }
            var presentFlag=Ext.getCmp('PresentFlag').getValue()
                 //�����жϽ��ۼ۹�ϵ  2020-02-14 yangsj 
                 //0 �����κ��ж� 1 ���۱���С�ڻ�����ۼ� 2 �������ʱ���Խ��۴����ۼۣ��������������
                 if ((gParam[18]==1)&&(Number(realPrice) > Number(spPrice)))
                 {
	                 Msg.info("warning", i + 1 + "��,�����ۼ۹�ϵΪ1����������۴����ۼۣ�");
                     changeBgColor(i, "yellow");
                	 return false;
                 }
                 else if ((gParam[18]==2)&&(Number(realPrice) > Number(spPrice))&&(presentFlag!= true))
                 {
	                 Msg.info("warning", i + 1 + "��,�����ۼ۹�ϵΪ2��������Ǿ���ҩƷ���۴����ۼۣ�");
                     changeBgColor(i, "yellow");
               		 return false;
                 }
            
            
            var batchNo = DetailStore.getAt(i).get("BatchNo");
            if (batchNo=="") {
                Msg.info("warning", desc + ",����д����!");
                changeBgColor(i, "yellow");
                return false;
            }
            var unequalflag = CheckRpEqualSp(i);
            if (unequalflag == false) {
                Msg.info("warning", desc + "Ϊ��ӳ�,���ۼ۲���,���ʵ��");
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
		                	Msg.info("warning", desc+"���б깩Ӧ��Ϊ:"+pbVendorArr[1]);
		                }else if(valVendorPb==2){
			            	Msg.info("warning", desc+"ҩƷ���б깩Ӧ��Ϊ:"+pbVendorArr[1]);
			            	return false;
			            }
	                }
	            }
            }
            
        }
        return true;
    }
    //׼��������Ϣ�󱣴�����¼
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
	            var ret = confirm(incidesc + "�۸����仯���Ƿ����ɵ��۵�?");
	            if (ret == true) {
	                SetAdjPrice(data, saveOrder, AdjPriceShow, ind, rowCount); //ѭ������
	            } else {
		        	var freedrugflag=record.get('FreeDrugFlag')
	                if(freedrugflag!="Y"){
			            if (PriorRp <= 0) {
		                    Msg.info("warning", "��"+ ind + 1 + "��,�����۲���С�ڻ����0");
		                    return;
		                }   
		            }else{
			            if (PriorRp!=0) {
		                    Msg.info("warning", "��"+ ind + 1 + "��,���ҩ�����۱������0");
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

    // ���ɵ��ۼ�¼,ѭ����Ӧ���첽
    function SaveAdj(data) {
        var retinfo = ""
        var dataArr = data.split("^")
        var incidesc = dataArr[9]
        var saveRet=tkMakeServerCall("web.DHCST.DHCINGdRec","CreateAdjPrice",data);
        if (saveRet!=0){
	        var errMsg="";
	        if (saveRet==-2){
		    	errMsg="���ɵ���ʧ��"; 
		    }else if (saveRet==-4){
			    errMsg="����δ��Ч���۵������������Ч���۵�";
			}else if (saveRet==-5){
			    errMsg="���۵���Чʧ��";
			}else{
				errMsg="����ʧ��";
			}
	    	alert(incidesc + ","+errMsg);
	    	return false;   
	    }
	    return true;
    }

    /*�ж�ҩƷ�Ƿ���ӳ�*/
    function CheckRpEqualSp(rownum) {
        var ingdrecData = DetailStore.getAt(rownum);
        var ingdrecInci = ingdrecData.get("IncId"); //ҩƷid
        ///�ж�ҩƷ����
        var equalflag = tkMakeServerCall("web.DHCST.Common.AppCommon", "GetZeroMarginByInci", ingdrecInci, gGroupId, gLocId, gUserId) //�Ƿ���Ҫ�ۼ۵��ڽ���
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
     * ������ⵥ
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
        //�޸����½��ۺ��ۼ�
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
            //���������ݷ����仯ʱִ����������
            if (rowData.data.newRecord || rowData.dirty) {
	            var freedrugflag=rowData.get('FreeDrugFlag')
                var Sp = rowData.get("Sp");
                if(freedrugflag!="Y"){
		            if (Sp <= 0) {
	                    Msg.info("warning", i + 1 + "��,�ۼ۲���С�ڻ����0");
	                    return;
	                }   
	            }else{
		            if (Sp!=0) {
	                    Msg.info("warning", i + 1 + "��,���ҩ�ۼ۱������0");
	                    return;
	                } 
		        }
                var Rp = rowData.get("Rp");
                //if (parseFloat(Sp) < parseFloat(Rp)) {
                //    Msg.info("warning", i + 1 + "��,�ۼ۲���С�ڽ���");
                //    return;
                //}
                 var presentFlag=Ext.getCmp('PresentFlag').getValue()
                 //�����жϽ��ۼ۹�ϵ  2020-02-14 yangsj 
                 //0 �����κ��ж� 1 ���۱���С�ڻ�����ۼ� 2 �������ʱ���Խ��۴����ۼۣ��������������
                 if ((gParam[18]==1)&&(parseFloat(Rp)>parseFloat(Sp)))
                 {
	                 Msg.info("warning", i + 1 + "��,�����ۼ۹�ϵΪ1����������۴����ۼۣ�");
                     return;
                 }
                 else if ((gParam[18]==2)&&(parseFloat(Rp)>parseFloat(Sp))&&(presentFlag!= true))
                 {
	                 Msg.info("warning", i + 1 + "��,�����ۼ۹�ϵΪ2��������Ǿ���ҩƷ���۴����ۼۣ�");
                     return;
                 }
                
                
                var Ingri = rowData.get("Ingri");
                var IncId = rowData.get("IncId");
                var BatchNo = rowData.get("BatchNo");
                var ExpDate = Ext.util.Format.date(rowData.get("ExpDate"), App_StkDateFormat);
                var ManfId = rowData.get("ManfId");
                var IngrUomId = rowData.get("IngrUomId");
                var RecQty = rowData.get("RecQty");
                
                //������������Ƿ�����С���ж� 2020-02-20 yangsj
                if(gParam[19]!=1)  //1 ����¼��С��
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
	                    Msg.info("warning", rowData.get("IncDesc")+" �����������ɻ�����λ֮�����С����������⣡��˶�������ã������������Ϊ������λ�Ƿ�����С��!");
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
                    Msg.info("warning", "��ǰҩƷ�ӳ���Ϊ"+margin.toFixed(3)+",����!");
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
                if (gParam[14] != "Y") //�Ƿ�����ֱ�ӵ��� LiangQiang 2014-03-14
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
                        var saveAdj=SaveAdj(pricedata); //���ɵ��ۼ�¼
                        if (saveAdj==false){
	                    	return;
	                    }
                    }
                }
            }
        }

        var url = DictUrl +
            "ingdrecaction.csp?actiontype=Save";
        var loadMask = ShowLoadMask(Ext.getBody(), "������...");
        Ext.Ajax.request({
            url: url,
            method: 'POST',
            params: { IngrNo: IngrNo, MainInfo: MainInfo, ListDetail: ListDetail },
            waitMsg: '������...',
            success: function(result, request) {
                var jsonData = Ext.util.JSON
                    .decode(result.responseText);
                if (jsonData.success == 'true') {
                    // ˢ�½���
                    var IngrRowid = jsonData.info;
                    Msg.info("success", "����ɹ�!");
                    // 7.��ʾ��ⵥ����
                    gIngrRowid = IngrRowid;
                    Query(IngrRowid);
                    //���ݲ��������Զ���ӡ
                    if (gParam[3] == 'Y') {
                        PrintRec(gIngrRowid, gParam[13]);
                    }
                } else {
                    var ret = jsonData.info;
                    if (ret == -99) {
                        Msg.info("error", "����ʧ��,���ܱ���!");
                    } else if (ret == -2) {
                        Msg.info("error", "������ⵥ��ʧ��,���ܱ���!");
                    } else if (ret == -3) {
                        Msg.info("error", "������ⵥʧ��!");
                    } else if (ret == -4) {
                        Msg.info("error", "δ�ҵ�����µ���ⵥ,���ܱ���!");
                    } else if (ret == -5) {
                        Msg.info("error", "������ⵥ��ϸʧ��!");
                    } else if (ret == -8) {
                        Msg.info("error", "��ⵥ�����!");
                    } else if (ret == -9) {
                        Msg.info("error", "��ⵥ�����!");
                    } else {
                        Msg.info("error", "������ϸ���治�ɹ���" + ret);
                    }
                }
            },
            scope: this
        });
        loadMask.hide();

    }
    // ��ʾ��ⵥ����
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
            waitMsg: '��ѯ��...',
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
                        // ��ʾ��ⵥ��ϸ����
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

    // �����ϸ
    // ����·��
    var DetailUrl = DictUrl +
        'ingdrecaction.csp?actiontype=QueryIngrDetail&Parref=&start=0&limit=999';

    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
        url: DetailUrl,
        method: "POST"
    });

    // ָ���в���
    var fields = ["Ingri", "IncId", "IncCode", "IncDesc", "ManfId", "Manf", "BatchNo", { name: 'ExpDate', type: 'date', dateFormat: App_StkDateFormat },
        "IngrUomId", "IngrUom", "RecQty", "Rp", "Marginnow", "Sp", "NewSp", "InvNo", "InvMoney", { name: 'InvDate', type: 'date', dateFormat: App_StkDateFormat }, "RpAmt", "SpAmt", "NewSpAmt",
        "QualityNo", "SxNo", "Remark", "Remarks", "MtDesc", "PubDesc", "BUomId", "ConFacPur", "MtDr", "Spec", "InfoRemark","OriginId","OriginDesc",'FreeDrugFlag'
    ];

    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: "results",
        id: "Ingri",
        fields: fields
    });

    // ���ݼ�
    var DetailStore = new Ext.data.Store({
        proxy: proxy,
        reader: reader
    });

    // ��ʾ��ⵥ��ϸ����
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

    // �����ť�Ƿ����
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
	        //��ѯ^���^����^����^ɾ��^���^ȡ�����
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
        // �ж���ⵥ�Ƿ�������
        var inGrFlag = Ext.getCmp("CompleteFlag").getValue();
        if (inGrFlag != null && inGrFlag != 0) {
            Msg.info("warning", "��ⵥ����ɲ���ɾ��!");
            return;
        }
        if (gIngrRowid == "") {
            Msg.info("warning", "û����Ҫɾ������ⵥ!");
            return;
        }
        Ext.MessageBox.show({
            title: '��ʾ',
            msg: '�Ƿ�ȷ��ɾ��������ⵥ',
            buttons: Ext.MessageBox.YESNO,
            fn: showDeleteGr,
            icon: Ext.MessageBox.QUESTION
        });
    }

    /**
     * ɾ����ⵥ��ʾ
     */
    function showDeleteGr(btn) {
        if (btn == "yes") {
            var url = DictUrl +
                "ingdrecaction.csp?actiontype=Delete&IngrRowid=" +
                gIngrRowid;

            Ext.Ajax.request({
                url: url,
                method: 'POST',
                waitMsg: '��ѯ��...',
                success: function(result, request) {
                    var jsonData = Ext.util.JSON
                        .decode(result.responseText);
                    if (jsonData.success == 'true') {
                        // ɾ������
                        Msg.info("success", "��ⵥɾ���ɹ�!");
                        clearData();
                    } else {
                        var ret = jsonData.info;
                        if (ret == -1) {
                            Msg.info("error", "��ⵥ�Ѿ���ɣ�����ɾ��!");
                        } else if (ret == -2) {
                            Msg.info("error", "��ⵥ�Ѿ���ˣ�����ɾ��!");
                        } else if (ret == -3) {
                            Msg.info("error", "��ⵥ������ϸ�Ѿ���ˣ�����ɾ��!");
                        } else {
                            Msg.info("error", "ɾ��ʧ��,��鿴������־!");
                        }
                    }
                },
                scope: this
            });
        }
    }

    /**
     * ɾ��ѡ����ҩƷ
     */
    function deleteDetail() {
        // �ж���ⵥ�Ƿ������
        var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
        if (CmpFlag != null && CmpFlag != false) {
            Msg.info("warning", "��ⵥ����ɲ���ɾ��!");
            return;
        }
        var cell = DetailGrid.getSelectionModel().getSelectedCell();
        if (cell == null) {
            Msg.info("warning", "û��ѡ����!");
            return;
        }
        // ѡ����
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
                title: '��ʾ',
                msg: '�Ƿ�ȷ��ɾ����ҩƷ��Ϣ',
                buttons: Ext.MessageBox.YESNO,
                fn: showResult,
                icon: Ext.MessageBox.QUESTION
            });

        }
    }
    /**
     * ɾ����ʾ
     */
    function showResult(btn) {
        if (btn == "yes") {
            var cell = DetailGrid.getSelectionModel().getSelectedCell();
            var row = cell[0];
            var record = DetailGrid.getStore().getAt(row);
            var Ingri = record.get("Ingri");

            // ɾ����������
            var url = DictUrl +
                "ingdrecaction.csp?actiontype=DeleteDetail&Rowid=" +
                Ingri;

            Ext.Ajax.request({
                url: url,
                method: 'POST',
                waitMsg: '��ѯ��...',
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode(result.responseText);
                    if (jsonData.success == 'true') {
                        Msg.info("success", "ɾ���ɹ�!");
                        DetailGrid.getStore().remove(record);
                        DetailGrid.getView().refresh();
                        if (DetailStore.getCount() == 0) {
                            SetFieldDisabled(false);
                        }
                        GetAmount();
                        
                    } else {
                        var ret = jsonData.info;
                        if (ret == -1) {
                            Msg.info("error", "��ⵥ�Ѿ���ɣ�����ɾ��!");
                        } else if (ret == -2) {
                            Msg.info("error", "��ⵥ�Ѿ���ˣ�����ɾ��!");
                        } else if (ret == -4) {
                            Msg.info("error", "����ϸ�����Ѿ���ˣ�����ɾ��!");
                        } else {
                            Msg.info("error", "ɾ��ʧ��,��鿴������־!");
                        }
                    }
                },
                scope: this
            });
        }
    }


    /**
     * �����ⵥ
     */
    function Complete() {
        var PurUserName = Ext.getCmp("PurchaseUser").getRawValue();
        if ((PurUserName == null || PurUserName == "") & (gParam[7] == 'Y')) {
            Msg.info("warning", "�ɹ�Ա����Ϊ��!");
            return;
        }
        var StkGrpType = Ext.getCmp("StkGrpType").getRawValue();
        if ((StkGrpType == null || StkGrpType.length <= 0) & (gParamCommon[9] == "N")) {
            Msg.info("warning", "��ѡ������!");
            return;
        }
        // �ж���ⵥ�Ƿ������
        var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
        if (CompleteFlag != null && CompleteFlag != 0) {
            Msg.info("warning", "��ⵥ�����!");
            return;
        }
        var InGrNo = Ext.getCmp("InGrNo").getValue();
        if (InGrNo == null || InGrNo.length <= 0) {
            Msg.info("warning", "û����Ҫ��ɵ���ⵥ!");
            return;
        }
        //===========================
        var rowData = DetailStore.getAt(0);
        if (rowData == "" || rowData == undefined) {
            Msg.info("warning", "û����Ҫ��ɵ�������ϸ!");
            return;
        }
        //===========================
        var url = DictUrl +
            "ingdrecaction.csp?actiontype=MakeComplete&Rowid=" +
            gIngrRowid + "&User=" + gUserId;
        Ext.Ajax.request({
            url: url,
            method: 'POST',
            waitMsg: '��ѯ��...',
            success: function(result, request) {
                var jsonData = Ext.util.JSON
                    .decode(result.responseText);
                if (jsonData.success == 'true') {
                    // ��˵���
                    Msg.info("success", "�ɹ�!");
                    // ��ʾ��ⵥ����
                    Query(gIngrRowid);
                    //��ѯ^���^����^����^ɾ��^���^ȡ�����			
                    changeButtonEnable("1^1^0^0^0^0^1^1");
                } else {
                    var Ret = jsonData.info;
                    if (Ret == -1) {
                        Msg.info("error", "����ʧ��,��ⵥIdΪ�ջ���ⵥ������!");
                    } else if (Ret == -2) {
                        Msg.info("error", "��ⵥ�Ѿ����!");
                    } else {
                        Msg.info("error", "����ʧ��!");
                    }
                }
            },
            scope: this
        });
    }

    /**
     * ȡ�������ⵥ
     */
    function CancleComplete() {
        var InGrNo = Ext.getCmp("InGrNo").getValue();
        if (InGrNo == null || InGrNo.length <= 0) {
            Msg.info("warning", "û����Ҫȡ����ɵ���ⵥ!");
            return;
        }
        var url = DictUrl +
            "ingdrecaction.csp?actiontype=CancleComplete&Rowid=" +
            gIngrRowid + "&User=" + gUserId;
        Ext.Ajax.request({
            url: url,
            method: 'POST',
            waitMsg: '��ѯ��...',
            success: function(result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                if (jsonData.success == 'true') {
                    // ��˵���
                    Msg.info("success", "ȡ���ɹ�!");
                    // ��ʾ��ⵥ����
                    Query(gIngrRowid);
                    //��ѯ^���^����^����^ɾ��^���^ȡ�����			
                    changeButtonEnable("1^1^1^1^1^1^0^0");
                } else {
                    var Ret = jsonData.info;
                    if (Ret == -1) {
                        Msg.info("error", "����ʧ��,��ⵥIdΪ�ջ���ⵥ������!");
                    } else if (Ret == -2) {
                        Msg.info("error", "��ⵥ��δ���!");
                    } else if (Ret == -3) {
                        Msg.info("error", "��ⵥ�����!");
                    } else {
                        Msg.info("error", "����ʧ��!");
                    }
                }
            },
            scope: this
        });
    }

    // ��λ
    var CTUom = new Ext.form.ComboBox({
        fieldLabel: '��λ',
        id: 'CTUom',
        name: 'CTUom',
        anchor: '90%',
        width: 120,
        store: ItmUomStore,
        valueField: 'RowId',
        displayField: 'Description',
        allowBlank: false,
        triggerAction: 'all',
        emptyText: '��λ...',
        selectOnFocus: true,
        forceSelection: true,
        minChars: 1,
        pageSize: 10,
        listWidth: 250,
        valueNotFoundText: ''
    });

    // ��������
    var Phmnf = new Ext.ux.ComboBox({
        fieldLabel: '����',
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
	
	// Ч��
    var ExpDateEditor = new Ext.ux.DateField({
        selectOnFocus: true,
        allowBlank: false,
        listeners: {
            specialkey: function(field, e) {
                if (e.getKey() == Ext.EventObject.ENTER) {
                    // �ж���ⵥ�Ƿ������																		
                    var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
                    if (CompleteFlag != null && CompleteFlag != false) {
                        Msg.info("warning", "��ⵥ�����!");
                        return;
                    }
                    if (field.getValue() == "") {
                        Msg.info("warning", "��Ч�ڲ���Ϊ��!");
                        return;
                    };
                    var expDate = field.getValue().format('Y-m-d');
                    var flag = ExpDateValidator(expDate);
                    if (flag == false) {
                        Msg.info('warning', '��ҩƷ����ʧЧ������' + gParam[2] + '��!');
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
            Msg.info("warning", "��Ч�ڲ���Ϊ��!")
            return;
        } else {
            expDate = expDate.format('Y-m-d');
        }

        var flag = ExpDateValidator(expDate);
        if (flag == false) {
            Msg.info('warning', '��ҩƷ����ʧЧ������' + gParam[2] + '��!');
            return;
        }
    })
	
	// ��Ʊ
    var InvNoEditor = new Ext.form.TextField({
        selectOnFocus: true,
        allowBlank: true,
        listeners: {
            specialkey: function(field, e) {
                if (e.getKey() == Ext.EventObject.ENTER) {
                    // �ж���ⵥ�Ƿ������																		
                    var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
                    if (CompleteFlag != null && CompleteFlag != false) {
                        Msg.info("warning", "��ⵥ�����!");
                        return;
                    }
                    var cell = DetailGrid.getSelectionModel().getSelectedCell();
                    var invNo = field.getValue();
                    var flag = InvNoValidator(invNo, gIngrRowid);
                    var col = 0;
                    if (flag == false) {
                        Msg.info("warning", "�÷�Ʊ���Ѵ����ڱ����ⵥ");
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
            Msg.info("warning", "�÷�Ʊ���Ѵ����ڱ����ⵥ");
        }
    });
	
	// ����
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
                        Msg.info("warning", "���۲���Ϊ��!");
                        return;
                    }
                    if((freedrugflag=="Y")&&(cost!=0)){
	                    Msg.info("warning", "���ҩ���۱���Ϊ0!");
                        return; 
	                }
                    if (cost <= 0) {
                        if ((presentFlag== true)||(freedrugflag=="Y")) {
                            if (cost < 0) {
                                Msg.info("warning", "���۲���С��0!");
                                return;
                            }
                        } else {
                            Msg.info("warning", "���۲���С�ڻ����0!");
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
                    //��֤�ӳ���
                    var sp = record.get("Sp");
                    
	                 //��ͨ�����ۼ����ۼ����֮���ٱȽϽ��ۺ��ۼ۵Ĺ�ϵ  2020-02-14 yangsj 
	                 //0 �����κ��ж� 1 ���۱���С�ڻ�����ۼ� 2 �������ʱ���Խ��۴����ۼۣ��������������
	                 if ((gParam[18]==1)&&(cost>sp))
	                 {
		                 Msg.info("warning", "�����ۼ۹�ϵΪ1����������۴����ۼۣ�");
	                     return;
	                 }
	                 else if ((gParam[18]==2)&&(cost>sp)&&(presentFlag!= true))
	                 {
		                 Msg.info("warning", "�����ۼ۹�ϵΪ2��������Ǿ���ҩƷ���۴����ۼۣ�");
	                     return;
	                 }
                    
                    
                    var margin = "";
                    if (cost <= 0) {
                        margin = ""
                    } else {
                        margin = sp / cost;
                    }
                    var colIndex = GetColIndex(DetailGrid, 'Rp');
                    DetailGrid.stopEditing(cell[0], colIndex); //����ǰ������ɱ༭ LiangQiang 2013-11-22
                    var ingdrecInci = record.get("IncId");
                    var equalflag = tkMakeServerCall("web.DHCST.Common.AppCommon", "GetZeroMarginByInci", ingdrecInci, gGroupId, gLocId, gUserId) //�Ƿ���Ҫ�ۼ۵��ڽ���
                    if ((equalflag != "Y") && ((gParam[5]!=""&&margin > gParam[5]) || margin < 1)) {
	                    alert(gParam[5]+"$"+margin)
                        Ext.MessageBox.confirm('��ʾ', '�ӳ��ʳ����޶���Χ,����?',
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
                    // ����ָ���еĽ������
                    var RealTotal = record.get("RecQty") * cost;
                    record.set("RpAmt", RealTotal);
                    record.set("InvMoney", RealTotal);
                    record.set("Marginnow", margin.toFixed(3));
                
                
                  
                }
                
            }
        }
    })
	
	// �ۼ�
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
                        Msg.info("warning", "�ۼ۲���Ϊ��!");
                        record.set("Sp", 0);
                        return;
                    }
                    if((freedrugflag=="Y")&&(cost!=0)){
	                    Msg.info("warning","���ҩ�ۼ۱���Ϊ0!");
                        return;
	                }
                    if ((freedrugflag!="Y")&&(cost <= 0)) {
                        Msg.info("warning","�ۼ۲���С�ڻ����0!");
                        return;
                    }
                    
                    var rp = record.get("Rp");
                    var presentFlag=Ext.getCmp('PresentFlag').getValue()
                     //��ͨ�����ۼ����ۼ����֮���ٱȽϽ��ۺ��ۼ۵Ĺ�ϵ  2020-02-14 yangsj 
	                 //0 �����κ��ж� 1 ���۱���С�ڻ�����ۼ� 2 �������ʱ���Խ��۴����ۼۣ��������������
	                 if ((gParam[18]==1)&&(rp>cost))
	                 {
		                 Msg.info("warning", "�����ۼ۹�ϵΪ1����������۴����ۼۣ�");
	                     return;
	                 }
	                 else if ((gParam[18]==2)&&(rp>cost)&&(presentFlag!= true))
	                 {
		                 Msg.info("warning", "�����ۼ۹�ϵΪ2��������Ǿ���ҩƷ���۴����ۼۣ�");
	                     return;
	                 }
                    
                    
                    // ����ָ���еĽ������
                    var SaleTotal = record.get("RecQty") * cost;
                    record.set("SpAmt", SaleTotal);
                   	if (setEnterSort(DetailGrid, colArr)) {
                        addNewRow();
                    }
                }
            }
        }
    })
    
	// ����
	var Origin = new Ext.ux.ComboBox({
		fieldLabel : '����',
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
            sortable: true,
            editor: new Ext.grid.GridEditor(new Ext.form.TextField({
                selectOnFocus: true,
                allowBlank: false,
                listeners: {
                    specialkey: function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            // �ж���ⵥ�Ƿ������																		
                            var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
                            if (CompleteFlag != null && CompleteFlag != false) {
                                Msg.info("warning", "��ⵥ�����!");
                                return;
                            }
                            var group = Ext.getCmp("StkGrpType").getValue();
                            GetPhaOrderInfo(field.getValue(), group);
                        }
                    }
                }
            }))
        }, {
            header: "����",
            dataIndex: 'ManfId',
            width: 180,
            align: 'left',
            sortable: true,
            editor: new Ext.grid.GridEditor(Phmnf),
            renderer: Ext.util.Format.comboRenderer2(Phmnf, "ManfId", "Manf")
        }, {
            header: "����",
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
                            // �ж���ⵥ�Ƿ������																		
                            var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
                            if (CompleteFlag != null && CompleteFlag != false) {
                                Msg.info("warning", "��ⵥ�����!");
                                return;
                            }
                            var batchNo = field.getValue();
                            if (batchNo == null || batchNo.length <= 0) {
                                Msg.info("warning", "���Ų���Ϊ��!");
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
            header: "��Ч��",
            dataIndex: 'ExpDate',
            width: 100,
            align: 'center',
            sortable: true,
            renderer: Ext.util.Format.dateRenderer(App_StkDateFormat),
            editor: ExpDateEditor
        }, {
            header: "��λ",
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
            header: "����",
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
                            // �ж���ⵥ�Ƿ������																		
                            var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
                            if (CompleteFlag != null && CompleteFlag != false) {
                                Msg.info("warning", "��ⵥ�����!");
                                return;
                            }
                            var qty = field.getValue();
                            if (qty == null || qty.length <= 0) {
                                Msg.info("warning", "�����������Ϊ��!");
                                return;
                            }
                            if (qty <= 0) {
                                Msg.info("warning", "�����������С�ڻ����0!");
                                return;
                            }
                            
                             // ����ָ���еĽ�����������ۼ�
                            var cell = DetailGrid.getSelectionModel().getSelectedCell();
                            var record = DetailGrid.getStore().getAt(cell[0]);
                            
                           
                            //������������Ƿ�����С���ж� 2020-02-20 yangsj
                            if(gParam[19]!=1)  //1 ����¼��С��
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
		                            Msg.info("warning", "�����������ɻ�����λ֮�����С����������⣡��˶�������ã������������Ϊ������λ�Ƿ�����С��!");
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
                            // �ж��Ƿ��Ѿ��������
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
            header: "����",
            dataIndex: 'Rp',
            width: 60,
            align: 'right',
            sortable: true,
            editor: RpEditor
        }, {
            header: "�ۼ�",
            dataIndex: 'Sp',
            width: 60,
            align: 'right',
            sortable: true,
            editor: SpEditor
        }, {
            header: "��ǰ�ӳ�",
            dataIndex: 'Marginnow',
            width: 60,
            align: 'right',
            sortable: true,
            renderer: function(value) {
                return '<span style="FONT-SIZE:14px;COLOR:#CC0000 ;">' + value + '</span>';
            }
        }, {
            header: "����ۼ�",
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
                                Msg.info("warning", "����ۼ۲���Ϊ��!");
                                return;
                            }
                            if (cost <= 0) {
                                Msg.info("warning",
                                    "����ۼ۲���С�ڻ����0!");
                                return;
                            }
                            // ����ָ���е��ۼ۽��
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
            header: "��Ʊ��",
            dataIndex: 'InvNo',
            width: 80,
            align: 'left',
            sortable: true,
            editor: InvNoEditor
        }, {
            header: "��Ʊ���",
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
            header: "��Ʊ����",
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
                            // �ж���ⵥ�Ƿ������																		
                            var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
                            if (CompleteFlag != null && CompleteFlag != false) {
                                Msg.info("warning", "��ⵥ�����!");
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
            header: "�ʼ쵥��",
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
            header: "���е���",
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
            header: "�������",
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
            header: "����ۼۺϼ�",
            dataIndex: 'NewSpAmt',
            width: 100,
            align: 'right',
            sortable: true,
            renderer: FormatGridSpAmount
        }, {
            header: "��������",
            dataIndex: 'MtDesc',
            width: 180,
            align: 'left',
            sortable: true
        }, {
            header: "�б�����",
            dataIndex: 'PubDesc',
            width: 180,
            align: 'left',
            sortable: true
        }, {
            header: "ժҪ",
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
            header: "��ע",
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
            header: "���",
            dataIndex: 'Spec',
            width: 80,
            align: 'left',
            sortable: true
        }, {
            header: "��׼�ĺ�",
            dataIndex: 'InfoRemark',
            width: 80,
            align: 'left',
            sortable: true
        },{
			header : "����",
			dataIndex : 'OriginId',
			width : 180,
			align : 'left',
			sortable : true,
			editor : new Ext.grid.GridEditor(Origin),
			renderer :Ext.util.Format.comboRenderer2(Origin,"OriginId","OriginDesc")	 
		}, {
            header: "���ҩ��ʶ",
            dataIndex: 'FreeDrugFlag',
            width: 80,
            align: 'left',
            sortable: true
        }
    ]);

    var DetailGrid = new Ext.grid.EditorGridPanel({
        id: 'DetailGrid',
        title: '��ⵥ��ϸ',
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
        /*ȡ����,��̬����С������λ��,yunhaibao201511224*/
        if ((e.field == "Rp") || (e.field == "Sp")) {
            var ingruomid = e.record.get('IngrUomId');
            var ingrinci = e.record.get('IncId');
            var decimalstr = tkMakeServerCall("web.DHCST.Common.AppCommon", "GetDecimalCommon", gGroupId, gLocId, gUserId, ingrinci, ingruomid);
            var decimalarr = decimalstr.split("^");
            RpEditor.decimalPrecision = decimalarr[0];
            SpEditor.decimalPrecision = decimalarr[2];
        }

    });

    /// ����Ҽ��˵�
    DetailGrid.addListener('rowcontextmenu', rightClickFn); //�Ҽ��˵�����ؼ����� 
    var rightClick = new Ext.menu.Menu({
        id: 'rightClickCont',
        items: [{
            id: 'mnuDelete',
            handler: deleteDetail,
            text: 'ɾ��'
        }]
    });

    //�Ҽ��˵�����ؼ����� 
    function rightClickFn(grid, rowindex, e) {
        e.preventDefault();
        rightClick.showAt(e.getXY());
    }

    /**
     * ����ҩƷ���岢���ؽ��
     */
    function GetPhaOrderInfo(item, group) {
        var LocId = Ext.getCmp("PhaLoc").getValue();
        if (item != null && item.length > 0) {
            GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",
                getDrugList, DetailGrid);
        }
    }

    /**
     * ���ط���
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
        // ѡ����
        var row = cell[0];
        var rowData = DetailGrid.getStore().getAt(row);
        rowData.set("IncId", inciDr);
        rowData.set("IncCode", inciCode);
        rowData.set("IncDesc", inciDesc);;
        var LocId = Ext.getCmp("PhaLoc").getValue();
        var Params = session['LOGON.GROUPID'] + '^' + session['LOGON.CTLOCID'] + '^' + gUserId;
        //ȡ����ҩƷ��Ϣ
        var url = DictUrl +
            "ingdrecaction.csp?actiontype=GetItmInfo&IncId=" +
            inciDr + "&Params=" + Params;
        Ext.Ajax.request({
            url: url,
            method: 'POST',
            waitMsg: '��ѯ��...',
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
                    DetailGrid.stopEditing(cell[0], colIndex); //����ǰ������ɱ༭ LiangQiang 2013-11-22																
                    rowData.set("ExpDate", toDate(data[7]));
                    rowData.set("MtDesc", data[8]);
                    rowData.set("PubDesc", data[9]);
                    rowData.set("BUomId", data[10]);
                    rowData.set("ConFacPur", data[11]);
                    rowData.set("MtDr", data[12]);
                    rowData.set("Spec", data[14]);
                    rowData.set("InfoRemark", data[15]);
                    rowData.set("FreeDrugFlag", data[19]);
                    //����
                    addComboData(OriginStore, data[20], data[21]);
                    rowData.set("OriginId", data[20]);
                    //�Ա�����ۼ�
                    if (gParam[9] == "Y" & data[13] != "") {
                        if (Number(data[5]) > Number(data[13])) {
                            Msg.info("warning", "��ǰ�ۼ۸�������ۼ�!");
                        }
                    }
                    //��֤�б���Ϣ
	               	var pbVendorId=data[17];
                    var valVendorPb=gParam[16];
                    if ((valVendorPb!="")&&(pbVendorId!="")){
	                	var selVendorId=Ext.getCmp("Vendor").getValue();
	                	if (selVendorId!=pbVendorId){
		                	if (valVendorPb==1){
			                	Msg.info("warning", "��ҩƷ���б깩Ӧ��Ϊ:"+data[18]);
			                }else if(valVendorPb==2){
				            	Msg.info("warning", "��ҩƷ���б깩Ӧ��Ϊ:"+data[18]);
				            	    var col = GetColIndex(DetailGrid, 'IncDesc');
						            DetailGrid.startEditing(cell[0], col);
				            		return;
				            }
		                }
	                }
                    //�����������
                    if (setEnterSort(DetailGrid, colArr)) {
                        addNewRow();
                    }
                    if (gParam[17]=='Y'){
	                    //=====================�ж�����====================
	                    var vendor = Ext.getCmp("Vendor").getValue();
	                    var inci = record.get("InciDr")
	                    var DataList = vendor + "^" + inci + "^" + data[0]
	                    var urldh = DictUrl + "ingdrecaction.csp?actiontype=Check&DataList=" + DataList
	                    Ext.Ajax.request({
	                        url: urldh,
	                        method: 'POST',
	                        waitMsg: '��ѯ��...',
	                        success: function(result, request) {
	                            var jsonData = Ext.util.JSON
	                                .decode(result.responseText);
	                            if (jsonData.success == 'true') {
	                           
									var ret=jsonData.info;
									if(ret==100){ 
									    Msg.info("warning", "��Ӧ�̺�ͬ�Ѿ�����!");
		                                return;
		                            }
		                            if(ret==101){
			                            Msg.info("warning", "��Ӧ�̺�ͬ����30���ڹ���!");
										return;
									}
									if(ret==1){ 
									    Msg.info("warning", "��Ӧ�̹���ִ���Ѿ�����!");
		                                return;
		                            }
		                            if(ret==30){
			                            Msg.info("warning", "��Ӧ�̹���ִ�ս���30���ڹ���!");
										return;
									}
									if(ret==3){  
										Msg.info("warning", "��Ӧ��˰��ִ���Ѿ�����!");
										return;
									}
									if(ret==31){  
										Msg.info("warning", "��Ӧ��˰��ִ�ս���30���ڹ���!");
										return;
									}
								    if(ret==4){  
										Msg.info("warning", "��Ӧ��ҩƷ��Ӫ���֤�Ѿ�����!");
										return;
									}
									if(ret==32){  
										Msg.info("warning", "��Ӧ��ҩƷ��Ӫ���֤����30���ڹ���!");
										return;
									}		
									if(ret==5){  
										Msg.info("warning", "��Ӧ����е��Ӫ���֤�Ѿ�����!");
										return;
									}
									if(ret==33){  
										Msg.info("warning", "��Ӧ����е��Ӫ���֤����30���ڹ���!");
										return;
									}		
									if(ret==6){  
										Msg.info("warning", "��Ӧ����еע��֤�Ѿ�����!");
										return;
									}
									if(ret==34){  
										Msg.info("warning", "��Ӧ����еע��֤����30���ڹ���!");
										return;
									}
									if(ret==7){ 
										Msg.info("warning", "��Ӧ��ҩƷע�������Ѿ�����!");
										return;
									}
									if(ret==35){  
										Msg.info("warning", "��Ӧ��ҩƷע����������30���ڹ���!");
										return;
									}
									if(ret==8){  
										Msg.info("warning", "��Ӧ�̻��������Ѿ�����!");
										return;
									}
									if(ret==36){  
										Msg.info("warning", "��Ӧ�̻������뽫��30���ڹ���!");
										return;
									}
									if(ret==9){  
										Msg.info("warning", "��Ӧ��GSP��֤�Ѿ�����!");
										return;
									}
									if(ret==37){  
										Msg.info("warning", "��Ӧ��GSP��֤����30���ڹ���!");
										return;
									}
									if(ret==10){  
										Msg.info("warning", "��Ӧ����е�������֤�Ѿ�����!");
										return;
									}
									if(ret==38){  
										Msg.info("warning", "��Ӧ����е�������֤����30���ڹ���!");
										return;
									}
									if(ret==11){  
										Msg.info("warning", "��Ӧ��ҩƷ�������֤�Ѿ�����!");
										return;
									}
									if(ret==39){  
										Msg.info("warning", "��Ӧ��ҩƷ�������֤����30���ڹ���!");
										return;
									}
									if(ret==12){  
										Msg.info("warning", "��Ӧ�̽���ע��֤�Ѿ�����!");
										return;
									}
									if(ret==40){  
										Msg.info("warning", "��Ӧ�̽���ע��֤����30���ڹ���!");
										return;
									}
									if(ret==13){  
										Msg.info("warning", "��Ӧ�̽���ע��ǼǱ��Ѿ�����!");
										return;
									}
									if(ret==41){  
										Msg.info("warning", "��Ӧ�̽���ע��ǼǱ���30���ڹ���!");
										return;
									}
									if(ret==14){  
										Msg.info("warning", "��Ӧ�̴�����Ȩ���Ѿ�����!");
										return;
									}
									if(ret==42){  
										Msg.info("warning", "��Ӧ�̴�����Ȩ�齫��30���ڹ���!");
										return;
									}
									if(ret==15){  
										Msg.info("warning", "��Ӧ��������ŵ���Ѿ�����!");
										return;
									}
									if(ret==43){  
										Msg.info("warning", "��Ӧ��������ŵ�齫��30���ڹ���!");
										return;
									}
									if(ret==16){  
										Msg.info("warning", "��Ӧ��ҵ��Ա��Ȩ���Ѿ�����!");
										return;
									}
									if(ret==44){  
										Msg.info("warning", "��Ӧ��ҵ��Ա��Ȩ�齫��30���ڹ���!");
										return;
									}
									if(ret==19){  
										Msg.info("warning", "����ҩƷ�������֤�Ѿ�����!");
										return;
									}
									if(ret==45){  
										Msg.info("warning", "����ҩƷ�������֤����30���ڹ���!");
										return;
									}
									if(ret==20){  
										Msg.info("warning", "���������������֤�Ѿ�����!");
										return;
									}
									if(ret==46){  
										Msg.info("warning", "���������������֤����30���ڹ���!");
										return;
									}
									if(ret==21){  
										Msg.info("warning", "���̹���ִ���Ѿ�����!");
										return;
									}
									if(ret==47){  
										Msg.info("warning", "���̹���ִ����30���ڹ���!");
										return;
									}
									if(ret==22){  
										Msg.info("warning", "���̹���ע����Ѿ�����!");
										return;
									}
									if(ret==48){  
										Msg.info("warning", "���̹���ע��Ž���30���ڹ���!");
										return;
									}
									if(ret==23){  
										Msg.info("warning", "������֯���������Ѿ�����!");
										return;
									}
									if(ret==49){  
										Msg.info("warning", "������֯�������뽫��30���ڹ���!");
										return;
									}																																							
									if(ret==24){		
										Msg.info("warning", "������е��Ӫ���֤�Ѿ�����!");
										return;
									}
									if(ret==50){		
										Msg.info("warning", "������е��Ӫ���֤����30���ڹ���!");
										return;
									}
									if(ret==26){		
										Msg.info("warning", "��׼�ĺ��Ѿ�����!");
										return ;
									}
									if(ret==51){		
										Msg.info("warning", "��׼�ĺŽ���30���ڹ���!");
										return;
									}
								    if(ret==27){		
										Msg.info("warning", "����ע��֤�Ѿ�����!");
										return;
									}
									if(ret==52){		
										Msg.info("warning", "����ע��֤����30���ڹ���!");
										return;
									}	                            
							    }
	                        },
	                        scope: this
	                    });
                    }
	                    //========================�ж�����=============================
	                }
	            },
	            scope: this
	        });

    }

    /**
     * ��λչ���¼�
     */
    CTUom.on('expand', function(combo) {
        var cell = DetailGrid.getSelectionModel().getSelectedCell();
        var record = DetailGrid.getStore().getAt(cell[0]);
        var InciDr = record.get("IncId");
        ItmUomStore.removeAll();
        ItmUomStore.load({ params: { ItmRowid: InciDr } });
    });

    /**
     * ��λ�任�¼�
     */
    CTUom.on('select', function(combo) {
        var cell = DetailGrid.getSelectionModel().getSelectedCell();
        var record = DetailGrid.getStore().getAt(cell[0]);
        var value = combo.getValue(); //Ŀǰѡ��ĵ�λid
        var BUom = record.get("BUomId");
        var ConFac = record.get("ConFacPur"); //��λ��С��λ��ת����ϵ					
        var IngrUom = record.get("IngrUomId"); //Ŀǰ��ʾ����ⵥλ
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

    // �任����ɫ
    function changeBgColor(row, color) {
        DetailGrid.getView().getRow(row).style.backgroundColor = color;
    }

    var HisListTab = new Ext.form.FormPanel({
        id: 'MainForm',
        labelWidth: 60,
        region: 'north',
        height: DHCSTFormStyle.FrmHeight(3),
        labelAlign: 'right',
        title: '��ⵥ�Ƶ�',
        frame: true,
        autoScroll: false,
        tbar: [SearchInGrBT, '-', ClearBT, '-', SaveBT, '-', CompleteBT, '-', CancleCompleteBT, '-', PrintBT, '-', DeleteInGrBT, '->', ImportButton],
        items: [{
            xtype: 'fieldset',
            title: '�����Ϣ',
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

    // ҳ�沼��
    var mainPanel = new Ext.Viewport({
        layout: 'border',
        items: [HisListTab, DetailGrid],
        renderTo: 'mainPanel'
    });

    RefreshGridColSet(DetailGrid, "DHCSTIMPORT"); //�����Զ�������������������
    colArr = sortColoumByEnterSort(DetailGrid);
    if (gIngrRowid != null && gIngrRowid != '' && gFlag == 1) {
        Query(gIngrRowid);
    }

    //-------------------Events-------------------//

    //����Grid������ʾ����
    //Creator:LiangQiang 2013-11-20
    DetailGrid.on('mouseover', function(e) {
        if (gParam[12] != "Y") {
            return;
        }
        var phaLoc = Ext.getCmp("PhaLoc").getValue();
        var rowCount = DetailGrid.getStore().getCount();
        if (rowCount > 0) {
            var ShowInCellIndex = GetColIndex(DetailGrid, 'IncCode'); //�ڵڼ�����ʾ
            var index = DetailGrid.getView().findRowIndex(e.getTarget());
            var record = DetailGrid.getStore().getAt(index);
            if (record) {
                var desc = record.data.IncDesc;
                var inci = record.data.IncId;
            }
            ShowInciRecListWin(e, DetailGrid, ShowInCellIndex, desc, inci, phaLoc);
        }

    }, this, { buffer: 200 });

    /*���Ƿ��޸�*/
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
        //��Ϊ�µ�(gIngrRowid"")�����ӱ��Ƿ��в���
        if ((gIngrRowid <= 0) || (gIngrRowid == '')) {
            if (detailCnt == 0) {
                result = false;
            } else {
                result = true;
            }
        } else { //����Ϊ�µ�����������ӱ�	
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
        //�����������Ƿ����޸�
        //�޸�Ϊ�������޸����ӱ�������ʱ������ʾ
        if ((IsFormChanged(HisListTab)) && (count1 != 0)) {
            changed = true;
        };
        if (changed) return changed;
        //����ϸ�����Ƿ����޸�
        var count = DetailGrid.getStore().getCount();
        for (var index = 0; index < count; index++) {
            var rec = DetailGrid.getStore().getAt(index);
            //���������ݷ����仯ʱִ����������
            if (rec.data.newRecord || rec.dirty) {
                changed = true;
            }
        }
        return changed;
    }

    /*����ԭʼֵ��ά�ֳ�ʼδ�޸�״̬*/
    function setOriginalValue1(formId) {
        if (formId == "") return;
        Ext.getCmp(formId).getForm().items.each(function(f) {
            f.originalValue = String(f.getValue());
        });
    }

    //���ÿɱ༭�����disabled����
    function SetFieldDisabled(bool) {
        Ext.getCmp("StkGrpType").setDisabled(bool);
    }

    ///�˳���ˢ��ʱ,������ʾ�Ƿ񱣴�
    window.onbeforeunload = function() {
        var compFlag = Ext.getCmp('CompleteFlag').getValue();
        var mod = isDataChanged();
        if (mod && (!compFlag)) {
            return "������¼����޸�,�㵱ǰ�Ĳ�������ʧ��Щ���,�Ƿ������";
        }
        DHCSTLockToggle(gIngrRowid, "G", "UL")
    }
})