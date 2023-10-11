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
            $('.datagrid-sort-icon').text(''); // 金额列 文字和金额右对齐
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
        NoHideAlert("请选择支付记录");
        return;
    }
    var invCount = myPLInfo.split("!").length;
    //循环打印发票
    var UnYBPatTypeobj = mywin.document.getElementById('UnYBPatType');
    var UnYBPatType = UnYBPatTypeobj.checked;
    //listobj.NoHideAlert("即将打印" + (invCount - 1) + "张发票");
    for (var i = 0; i < invCount - 1; i++) {
        var tmpInvAry = myPLInfo.split("!")[i].split("^");
        var plRowID = tmpInvAry[0];
        var prtRowID = tmpInvAry[1];
        var fairType = tmpInvAry[2];
        var insTypeDR = tmpInvAry[3];
        var admSource = tmpInvAry[4];
        var RegInsuFlag = tkMakeServerCall("web.DHCOPBillInvPrtInsu", "CheckRegInsu", prtRowID);
        if (RegInsuFlag != "Y") {
            $.messager.confirm('提示', "本次缴费的挂号尚未医保分解，是否打印自费发票", function (r) {
                if (r) {
                    UnYBPatType = true;
                    var InsuCharge = tkMakeServerCall("web.DHCOPBillInvPrtInsu", "IsInsuCharge", prtRowID);
                    var insuChargeFlag = InsuCharge.split("^")[0]; //已经分解的小条不再上传发票
                    // 补掉医保接口
                    if ((admSource > 0) && (RegInsuFlag == "Y") && !UnYBPatType && (insuChargeFlag == 0)) {
                        //调用医保接口
                        //挂号不调用医保接口
                        //StrikeFlag^安全组Dr^InsuNo^CardType^YLLB^DicCode^DYLB^总余额^操作员ID^科室ID^医院ID！Money^MoneyType！Money^MoneyType
                        var myYBHand = "";
                        var myCPPFlag = "A"; //空：普通门诊收费，Y:集中打印发票，A:支付宝集中打印发票
                        var LeftAmt = "";
                        var StrikeFlag = "N";
                        var GroupDR = myGroupDr;
                        var InsuNo = "";
                        var CardType = "";
                        var YLLB = "";
                        var DicCode = "";
                        var DYLB = "";
                        var MoneyType = ""; //卡类型
                        var YDFLAG = "";
                        var LeftAmtStr = LeftAmt + "^" + myGuserDr + "^" + myCTLocDr + "^" + myHospitalDr + "!" + LeftAmt + "^" + MoneyType;
                        var myYBExpStr = StrikeFlag + "^" + GroupDR + "^" + InsuNo + "^" + insTypeDR + "^" + myCTLocDr + "^" + myHospitalDr + "^" + myGuserDr;
                        var myYBINS = admSource;
                        var myCurrentInsType = insTypeDR;
                        var myYBrtn = DHCWebOPYB_DataUpdate(myYBHand, myGuserDr, prtRowID, myYBINS, myCurrentInsType, myExpStrYB, myCPPFlag);
                        var myYBarry = myYBrtn.split("^");
                        if (myYBarry[0] == "YBCancle") {
                            listobj.NoHideAlert("支付记录号:" + prtRowID + ", 医保分解失败，需要重新分解");
                            return;
                        }
                        if (myYBarry[0] == "HisCancleFailed") {
                            listobj.NoHideAlert("支付记录号:" + prtRowID + ", 医保分解失败，需要重新分解");
                            return;
                        }
                    }
                    //打印发票
                    var myExpStr = myCTLocDr + "^" + myGroupDr + "^" + myHospitalDr + "^^^";
                    var papmiDr = getValueById("PAPMIRowID");
                    var accMDr = getValueById("PAPMIRowID");
                    //var myrtn = tkMakeServerCall("web.UDHCAccPrtPayFoot", "PrintAPInv", accMDr, papmiDr, prtRowID, myGuserDr, myExpStr);
                    if ((admSource == 0) || (UnYBPatType == true) || (admSource == "")) {
                        //BillPrintNew(myrtn);
                        mywin.BillPrintNew("^" + prtRowID);
                    }
                    NoHideAlert("打印完毕");
                }
                // ClearWin_Click();
            });
        } else {
            var InsuCharge = tkMakeServerCall("web.DHCOPBillInvPrtInsu", "IsInsuCharge", prtRowID);
            var insuChargeFlag = InsuCharge.split("^")[0]; //已经分解的小条不再上传发票
            // 补掉医保接口
            if ((admSource > 0) && (RegInsuFlag == "Y") && !UnYBPatType && (insuChargeFlag == 0)) {
                //调用医保接口
                //挂号不调用医保接口
                //StrikeFlag^安全组Dr^InsuNo^CardType^YLLB^DicCode^DYLB^总余额^操作员ID^科室ID^医院ID！Money^MoneyType！Money^MoneyType
                var myYBHand = "";
                var myCPPFlag = "A"; //空：普通门诊收费，Y:集中打印发票，A:支付宝集中打印发票
                var LeftAmt = "";
                var StrikeFlag = "N";
                var GroupDR = myGroupDr;
                var InsuNo = "";
                var CardType = "";
                var YLLB = "";
                var DicCode = "";
                var DYLB = "";
                var MoneyType = ""; //卡类型
                var YDFLAG = "";
                var LeftAmtStr = LeftAmt + "^" + myGuserDr + "^" + myCTLocDr + "^" + myHospitalDr + "!" + LeftAmt + "^" + MoneyType;
                var myYBExpStr = StrikeFlag + "^" + GroupDR + "^" + InsuNo + "^" + insTypeDR + "^" + myCTLocDr + "^" + myHospitalDr + "^" + myGuserDr;
                var myYBINS = admSource;
                var myCurrentInsType = insTypeDR;
                var myYBrtn = DHCWebOPYB_DataUpdate(myYBHand, myGuserDr, prtRowID, myYBINS, myCurrentInsType, myExpStrYB, myCPPFlag);
                var myYBarry = myYBrtn.split("^");
                if (myYBarry[0] == "YBCancle") {
                    NoHideAlert("支付记录号:" + prtRowID + ", 医保分解失败!需要重新分解");
                    return;
                }
                if (myYBarry[0] == "HisCancleFailed") {
                    NoHideAlert("支付记录号:" + prtRowID + ", 医保分解失败!需要重新分解");
                    return;
                }
            }
            //打印发票
            var myExpStr = myCTLocDr + "^" + myGroupDr + "^" + myHospitalDr + "^^^";
            var papmiDr = getValueById("PAPMIRowID");
            var accMDr = getValueById("PAPMIRowID");
            //var myrtn = tkMakeServerCall("web.UDHCAccPrtPayFoot", "PrintAPInv", accMDr, papmiDr, prtRowID, myGuserDr, myExpStr);
            if ((admSource == 0) || UnYBPatType || (admSource == "")) {
                //BillPrintNew(myrtn);
                mywin.BillPrintNew("^" + prtRowID);
            }
            listobj.NoHideAlert("第" + (i + 1) + "打印完毕");
        }
    }
}