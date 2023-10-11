/// DHCOPBillInvInsuList.js
/// Lid
/// 2014-07-08

$(function () {
    init_Layout();
    RefreshDoc();
});

function BulidPLStr() {
    var myRLStr = "";
    $.each($HUI.datagrid('#tDHCOPBillInvInsuList').getChecked(), function (index, row) {
        var myRLRowID = row.PLRowID;
        var myPrtRowID = row.PrtRowID;
        var myFairType = row.TFairType;
        var myAdmSource = row.TAdmSource;
        var myInsTypeDR = row.TInsTypeDR;
        var tmp = myRLRowID + "^" + myPrtRowID + "^" + myFairType + "^" + myInsTypeDR + "^" + myAdmSource;
        myRLStr += tmp + "!";
    });
    return myRLStr;
}

function SelectRowHandler(index, rowData) {
    RefreshDoc();
}

function RefreshDoc() {
    var myRLStr = BulidPLStr();
}

function SelectAll(myCheck) {
    if (myCheck) {
        $HUI.datagrid('#tDHCOPBillInvInsuList').checkAll();
    } else {
        $HUI.datagrid('#tDHCOPBillInvInsuList').uncheckAll();
    }
}

function init_Layout() {
    DHCWeb_ComponentLayout();
    var opt = $HUI.datagrid('#tDHCOPBillInvInsuList').options;
    $.extend(opt, {
	    fitColumns: true,
		onLoadSuccess: function (data) {
            var o = $('#tDHCOPBillInvInsuList');
            $.each(data.rows, function(index, row) {
	            o.datagrid('beginEdit', index);
	        });
            $('.datagrid-sort-icon').text(''); // ����� ���ֺͽ���Ҷ���
            $("input[type='checkbox']").click(function (e) {
                var rowIndex = this.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.rowIndex;
                SelectRowHandler(rowIndex, "");
            });
        }
	});
}

function NoHideAlert(info) {
    $.messager.popover({
        msg: info,
        style: {
            right: '50%',
            top: '30%'
        }
    });
}

function BtnInvPrint_OnClick() {
    var myGuserDr = session['LOGON.USERID'];
    var myGroupDr = session['LOGON.GROUPID'];
    var myCTLocDr = session['LOGON.CTLOCID'];
    var myHospitalDr = session['LOGON.HOSPID'];
    var myPLInfo = BulidPLStr();
    if (myPLInfo == "") {
        NoHideAlert("��ѡ��֧����¼");
        return;
    }
    var invCount = myPLInfo.split("!").length;
    //ѭ����ӡ��Ʊ
    var UnYBPatTypeobj = mywin.document.getElementById('UnYBPatType');
    var UnYBPatType = UnYBPatTypeobj.checked;
    //listobj.NoHideAlert("������ӡ" + (invCount - 1) + "�ŷ�Ʊ");
    for (var i = 0; i < invCount - 1; i++) {
        var tmpInvAry = myPLInfo.split("!")[i].split("^");
        var plRowID = tmpInvAry[0];
        var prtRowID = tmpInvAry[1];
        var fairType = tmpInvAry[2];
        var insTypeDR = tmpInvAry[3];
        var admSource = tmpInvAry[4];
        var RegInsuFlag = tkMakeServerCall("web.DHCOPBillInvPrtInsu", "CheckRegInsu", prtRowID);
        if (RegInsuFlag != "Y") {
            $.messager.confirm('��ʾ', "���νɷѵĹҺ���δҽ���ֽ⣬�Ƿ��ӡ�Էѷ�Ʊ", function (r) {
                if (r) {
                    UnYBPatType = true;
                    var InsuCharge = tkMakeServerCall("web.DHCOPBillInvPrtInsu", "IsInsuCharge", prtRowID);
                    var insuChargeFlag = InsuCharge.split("^")[0]; //�Ѿ��ֽ��С�������ϴ���Ʊ
                    // ����ҽ���ӿ�
                    if ((admSource > 0) && (RegInsuFlag == "Y") && !UnYBPatType && (insuChargeFlag == 0)) {
                        //����ҽ���ӿ�
                        //�ҺŲ�����ҽ���ӿ�
                        //StrikeFlag^��ȫ��Dr^InsuNo^CardType^YLLB^DicCode^DYLB^�����^����ԱID^����ID^ҽԺID��Money^MoneyType��Money^MoneyType
                        var myYBHand = "";
                        var myCPPFlag = "A"; //�գ���ͨ�����շѣ�Y:���д�ӡ��Ʊ��A:֧�������д�ӡ��Ʊ
                        var LeftAmt = "";
                        var StrikeFlag = "N";
                        var GroupDR = myGroupDr;
                        var InsuNo = "";
                        var CardType = "";
                        var YLLB = "";
                        var DicCode = "";
                        var DYLB = "";
                        var MoneyType = ""; //������
                        var YDFLAG = "";
                        var LeftAmtStr = LeftAmt + "^" + myGuserDr + "^" + myCTLocDr + "^" + myHospitalDr + "!" + LeftAmt + "^" + MoneyType;
                        var myYBExpStr = StrikeFlag + "^" + GroupDR + "^" + InsuNo + "^" + insTypeDR + "^" + myCTLocDr + "^" + myHospitalDr + "^" + myGuserDr;
                        var myYBINS = admSource;
                        var myCurrentInsType = insTypeDR;
                        var myYBrtn = DHCWebOPYB_DataUpdate(myYBHand, myGuserDr, prtRowID, myYBINS, myCurrentInsType, myExpStrYB, myCPPFlag);
                        var myYBarry = myYBrtn.split("^");
                        if (myYBarry[0] == "YBCancle") {
                            listobj.NoHideAlert("֧����¼��:" + prtRowID + ", ҽ���ֽ�ʧ�ܣ���Ҫ���·ֽ�");
                            return;
                        }
                        if (myYBarry[0] == "HisCancleFailed") {
                            listobj.NoHideAlert("֧����¼��:" + prtRowID + ", ҽ���ֽ�ʧ�ܣ���Ҫ���·ֽ�");
                            return;
                        }
                    }
                    //��ӡ��Ʊ
                    var myExpStr = myCTLocDr + "^" + myGroupDr + "^" + myHospitalDr + "^^^";
                    var papmiDr = getValueById("PAPMIRowID");
                    var accMDr = getValueById("PAPMIRowID");
                    //var myrtn = tkMakeServerCall("web.UDHCAccPrtPayFoot", "PrintAPInv", accMDr, papmiDr, prtRowID, myGuserDr, myExpStr);
                    if ((admSource == 0) || (UnYBPatType == true) || (admSource == "")) {
                        //BillPrintNew(myrtn);
                        mywin.BillPrintNew("^" + prtRowID);
                    }
                    NoHideAlert("��ӡ���");
                }
                // ClearWin_Click();
            });
        } else {
            var InsuCharge = tkMakeServerCall("web.DHCOPBillInvPrtInsu", "IsInsuCharge", prtRowID);
            var insuChargeFlag = InsuCharge.split("^")[0]; //�Ѿ��ֽ��С�������ϴ���Ʊ
            // ����ҽ���ӿ�
            if ((admSource > 0) && (RegInsuFlag == "Y") && !UnYBPatType && (insuChargeFlag == 0)) {
                //����ҽ���ӿ�
                //�ҺŲ�����ҽ���ӿ�
                //StrikeFlag^��ȫ��Dr^InsuNo^CardType^YLLB^DicCode^DYLB^�����^����ԱID^����ID^ҽԺID��Money^MoneyType��Money^MoneyType
                var myYBHand = "";
                var myCPPFlag = "A"; //�գ���ͨ�����շѣ�Y:���д�ӡ��Ʊ��A:֧�������д�ӡ��Ʊ
                var LeftAmt = "";
                var StrikeFlag = "N";
                var GroupDR = myGroupDr;
                var InsuNo = "";
                var CardType = "";
                var YLLB = "";
                var DicCode = "";
                var DYLB = "";
                var MoneyType = ""; //������
                var YDFLAG = "";
                var LeftAmtStr = LeftAmt + "^" + myGuserDr + "^" + myCTLocDr + "^" + myHospitalDr + "!" + LeftAmt + "^" + MoneyType;
                var myYBExpStr = StrikeFlag + "^" + GroupDR + "^" + InsuNo + "^" + insTypeDR + "^" + myCTLocDr + "^" + myHospitalDr + "^" + myGuserDr;
                var myYBINS = admSource;
                var myCurrentInsType = insTypeDR;
                var myYBrtn = DHCWebOPYB_DataUpdate(myYBHand, myGuserDr, prtRowID, myYBINS, myCurrentInsType, myExpStrYB, myCPPFlag);
                var myYBarry = myYBrtn.split("^");
                if (myYBarry[0] == "YBCancle") {
                    NoHideAlert("֧����¼��:" + prtRowID + ", ҽ���ֽ�ʧ��!��Ҫ���·ֽ�");
                    return;
                }
                if (myYBarry[0] == "HisCancleFailed") {
                    NoHideAlert("֧����¼��:" + prtRowID + ", ҽ���ֽ�ʧ��!��Ҫ���·ֽ�");
                    return;
                }
            }
            //��ӡ��Ʊ
            var myExpStr = myCTLocDr + "^" + myGroupDr + "^" + myHospitalDr + "^^^";
            var papmiDr = getValueById("PAPMIRowID");
            var accMDr = getValueById("PAPMIRowID");
            //var myrtn = tkMakeServerCall("web.UDHCAccPrtPayFoot", "PrintAPInv", accMDr, papmiDr, prtRowID, myGuserDr, myExpStr);
            if ((admSource == 0) || UnYBPatType || (admSource == "")) {
                //BillPrintNew(myrtn);
                mywin.BillPrintNew("^" + prtRowID);
            }
            listobj.NoHideAlert("��" + (i + 1) + "��ӡ���");
        }
    }
}