/// udhcOPAliRefundYCCL.js

var listobj = parent.frames["udhcOPAliRefundyccl_Order"];
var RefundInfoFlag;   //是否可在此界面退费

$(function () {
    init_Layout();

    $("#ReceipNO").focus().keydown(function (e) {
        ReceipNO_KeyDown(e);
    });

    $("#PRTReceipID").keydown(function (e) {
        ReceipID_KeyDown(e);
    });

    $HUI.linkbutton("#RefClear", {
        onClick: function () {
            RefundClear_Click();
        }
    });

    $HUI.linkbutton("#ReTrade", {
        onClick: function () {
            ReTrade_Click();
        }
    });

    $HUI.linkbutton("#RePrintAcert", {
        onClick: function () {
            RePrintAcert_OnClick();
        }
    });

    $HUI.combobox("#RefundPayMode", {
        panelHeight: 150,
        url: $URL + '?ClassName=web.UDHCOPOtherLB&MethodName=ReadPayModeBroker&JSFunName=GetPayModeToHUIJson',
        editable: false,
        valueField: 'id',
        textField: 'text'
    });
});

function RefundClear_Click() {
    IntRefMain();
    parent.frames['udhcOPAliRefundyccl_Order'].location.href = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPAliRefundyccl.Order&ReceipRowid=";
}

function ReceipNO_KeyDown(e) {
    var key = websys_getKey(e);
    if (key == 13) {
        var No = getValueById("ReceipNO");
        if (!No) {
            return;
        }
        var encmeth = getValueById("getReceipID");
        var rtn = cspRunServerMethod(encmeth, 'SetReceipID', "", No, session['LOGON.HOSPID']);
        var ReceipID = getValueById("ReceipID");
        if (ReceipID == "") {
            $("#ReTrade").linkbutton('disable');
            listobj.NoHideAlert('发票号错误: 非收费发票');
            websys_setfocus('ReceipNO');
            return websys_cancel();
        } else {
            $("#ReTrade").linkbutton('enable');
            var encmeth = getValueById("getReceiptinfo");
            var rtn = cspRunServerMethod(encmeth, 'SetReceipInfo', "", ReceipID, session['LOGON.HOSPID']);
            if ((rtn == 0) && (RefundInfoFlag > 0)) {
                ReceipID = ReceipID.split("^")[0];
                parent.frames['udhcOPAliRefundyccl_Order'].location.href = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPAliRefundyccl.Order&ReceipRowid=" + ReceipID;
            }
        }
    }
}

function ReTrade_Click() {
    var ReceipRowid = getValueById("ReceipID");
    var encmeth = getValueById('getRefundRcpt');
    var rtnvalue = cspRunServerMethod(encmeth, ReceipRowid);
    var myary = rtnvalue.split(String.fromCharCode(2));
    var rtn = myary[0].split("^");
    var abortrowid = "";
    var normalrowid = "";
    if (rtn[0] == "-1") {
        abortrowid = rtn[1];
    }
    if (rtn[0] == "-2") {
        abortrowid = rtn[2];
        normalrowid = rtn[1];
    }
    if (rtn[0] == "-3") {
        abortrowid = rtn[2];
        normalrowid = rtn[1];
    }
    if (rtn[0] == "0") {
        listobj.NoHideAlert(rtn[1]);
        return;
    }
    
    //add tangtao 2011-11-06 软POS
    var myPayModeDR = getValueById("RefundPayMode");
    var myJson = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.CTPayMode", id: myPayModeDR}, false);
    var myPayModeCode = myJson.CTPMCode;
    if (myPayModeCode == "ALIPAY") {
        var Guser = session['LOGON.USERID'];
        var ExpStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^^^" + session['LOGON.USERID'] + "^补交易退费";
        var retn = tkMakeServerCall("DHCAliPay.ChargeInterface.AliPayLogic", "AliPay", "OP", normalrowid, abortrowid, "", "D", ExpStr);
        if (retn == "0") {
            listobj.NoHideAlert("补交易成功");
        } else {
            listobj.NoHideAlert("补交易失败，请联系信息部");
            return;
        }
    } else if (myPayModeCode == "WECHATPAY") {
        var Guser = session['LOGON.USERID'];
        var ExpStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^^^" + session['LOGON.USERID'] + "^补交易退费";
        var retn = tkMakeServerCall("DHCWeChatPay.ChargeInterface.WeChatPayLogic", "WeChatPay", "OP", normalrowid, abortrowid, "", "D", ExpStr);
        if (retn == "0") {
            listobj.NoHideAlert("补交易成功");
        } else {
            listobj.NoHideAlert("补交易失败，请联系信息部");
            return;
        }
    } else {
        listobj.NoHideAlert("获取配置失败,该支付方式没有银医卡或者软POS支付配置，不能补交易");
    }
}

function SetReceipID(value) {
    try {
        var myAry = value.split('^');
        var ReceipID = myAry[0];
        var sFlag = myAry[1];
        if (sFlag == 'PRT') {
            setValueById("ReceipID", ReceipID);
            setValueById("PRTReceipID", ReceipID);
        }
    } catch (e) {
	}
}

function SetReceipInfo(value) {
    RefundInfoFlag = 1;
    var myAry = value.split("^");
    setValueById("PatientID", myAry[0]);
    setValueById("PatientName", myAry[1]);
    setValueById("PatientSex", myAry[2]);
    setValueById("Sum", parseFloat(myAry[3]).toFixed(2));
    setValueById("RefundPayMode", myAry[9]);
    setValueById("INSDivDR", myAry[13]);
    setValueById("InsType", myAry[17]);

    var myColPFlag = myAry[10];
    if (myColPFlag == 1) {
        RefundInfoFlag = -1;
        listobj.NoHideAlert(t["ColPTip"]);
        websys_setfocus('ReceipNO');
        return websys_cancel();
    }
    if (["A", "S"].indexOf(myAry[4]) == -1) {
		RefundInfoFlag = -1;
        listobj.NoHideAlert("此收据没有退费信息");
        return websys_cancel();
    }
    if (myAry[5] == "1") {
        //listobj.NoHideAlert(t['12']);
        //websys_setfocus('ReceipNO');
        //return websys_cancel();
    }
}

function AddIDToOrder(ReceipID) {
    var lnk = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPRefundyccl.Order&ReceipRowid=" + ReceipID;
    var AdmCharge = parent.frames['udhcOPRefundyccl_Order'];
    AdmCharge.location.href = lnk;
}

function IntRefMain() {
    var lnk = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPAliRefundYCCL";
    window.location.href = lnk;
}

function RePrintAcert_OnClick() {
    var UserName = session['LOGON.USERNAME'];
    var lnk = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCOPBillFindBankTrade";
    lnk += "&FramName=udhcOPRefundYCCL";
    lnk += "&UserName=" + UserName;
    var NewWin = open(lnk, "DHCOPBillFindBankTrade", "scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function ReceipID_KeyDown(e) {
    var key = websys_getKey(e);
    if (key == 13) {
        var ReceipID = getValueById("PRTReceipID");
        if (!ReceipID) {
            return;
        }
        var jsonObj = getINVPRTJsonObj(ReceipID);
        if (jsonObj.PRTFairType != "F") {
	        listobj.NoHideAlert('发票号错误: 非收费发票');
	        return;
	    }
        var encmeth = getValueById("getReceiptinfo");
        if (cspRunServerMethod(encmeth, 'SetReceipInfo', '', ReceipID, session['LOGON.HOSPID']) == 0) {
	    	setValueById("ReceipID", ReceipID);
	    	if (RefundInfoFlag > 0) {
		    	parent.frames['udhcOPAliRefundyccl_Order'].location.href = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPAliRefundyccl.Order&ReceipRowid=" + ReceipID;
		    }
	    }else {
		    listobj.NoHideAlert("此发票不存在");
		}
    }
}

function init_Layout() {
    $('#cReceipNO').parent().parent().css("width", "60px");
    DHCWeb_ComponentLayout();
}

function getINVPRTJsonObj(prtRowId) {
	return $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.DHCINVPRT", id: prtRowId}, false);
}