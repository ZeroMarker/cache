/*
 * 体检第三方支付服务  DHCPEPayService.js
 * @Author   wangguoying
 * @DateTime 2019-12-27
 */


/**
 * 备注：
 *
 *    需要调用此文件的方法时，界面应引入计费组如下函数：
 *    1、DHCBillPayService.js
 *    2、DHCBillMisPosPay.js
 *    3、DHCBillPayByScanCode.js
 *    4、DHCBillPayScanCodeService.js
 * 
 *    第三方支付方式包含互联网组扫码付  ^DHCPESetting("DHCPE","ExtPayModeCode")="^MISPOS^SMF^"
 *   互联网组扫码付 ^DHCPESetting("DHCPE","DHCScanCode")="^SMF^"
 *   8.4之后应该不需要再区分互联组支付了，统一走计费函数
 *   计费回调参数对象：  8.4之后收费和退费做了格式统一
 *   var rtnValue = {
        ResultCode: 0,
        ResultMsg: "该支付方式不需调用接口收费",
        ETPRowID: ""
    };
 */


var $PEPay = {};



/**
 * [返回对象]
 * ResultCode：结果代码 
 *                 0：成功             
 *              -100：医保结算失败
 *              -200：结算失败，发票未回滚，需要信息科处理
 *              -300：第三方结算失败
 *              -400:程序异常
 *              -500:退费失败
 * ResultMsg：描述
 * ETPRowID：计费组的交易订单ID
 * PEBarCodePayStr：互联网交易信息
 * ExpStr:返回的扩展信息  如医保结算需返回  医保ID^自费金额
 */
$PEPay.Result = {
    ResultCode: "0",
    ResultMsg: "",
    ETPRowID: "",
    PEBarCodePayStr: "",
    ExpStr: ""
}


/**
 * [支付参数对象，用于计费回调时使用]
 *  Invprt: 发票ID
 *  UserId: 收费员ID
 *  InsuID: 医保ID
 *  AdmSorce: 医疗类别
 *  AdmReason: 费别
 */
$PEPay.Param = {
    Invprt: "", //发票ID
    UserId: "", //收费员ID
    InsuID: "", //医保ID
    AdmSorce: "", //医疗类别
    AdmReason: "", //费别
    InvNoStr: "", //发票号^发票名称^不打发票^费别^纳税人识别号
    PayedInfo: "",
    PeAdmType: "",
    PeAdmId: "",
    Amount: "",
    CardAccID: ""
};


/**
 * 计费回调之后，需要调用体检的回调函数（执行真正结算及后续操作）
 */
$PEPay.callback = undefined;


/**
 * [医保结算]
 * @param    {[int]}    invprt    [体检发票Id]
 * @param    {[float]}    amount    [金额]
 * @param    {[int]}    userId    [用户ID]
 * @param    {[int]}    AdmSorce [Pac_admreason.rea_AdmSource]
 * @param    {[int]}    admReason [Pac_admreason.Rowid]
 * @return   {object}    $PEPay.Result
 * @Author   wangguoying
 * @DateTime 2019-12-27
 */
$PEPay.insurancePay = function(invprt, amount, userId, AdmSorce, AdmReason) {
    this.Result = {
        ResultCode: "0",
        ResultMsg: "",
        ETPRowID: "",
        PEBarCodePayStr: "",
        ExpStr: ""
    };
    var StrikeFlag = "N";
    var GroupID = session['LOGON.GROUPID'];
    var HOSPID = session['LOGON.HOSPID'];
    var InsuNo = ""; //医保个人编号、医保卡号、医保号的加密串 供磁卡的地方用 
    var CardType = ""; //有无医保卡
    var YLLB = getValueById("YLLB"); //医疗类别（普通门诊、门诊特病、门诊工伤、门诊生育）
    var DicCode = ""; //病种代码
    var DicDesc = "";
    var BillSource = "01"; //结算来源
    var Type = "";
    var MoneyType = "";
    var TJPayMode = $("#PayMode").combogrid("getValue");

    var ExpStr = StrikeFlag + "^" + GroupID + "^" + InsuNo + "^" + CardType + "^" + YLLB + "^" + DicCode + "^" + DicDesc + "^" + amount + "^" + BillSource + "^" + Type + "^^" + "^" + HOSPID + "^" + TJPayMode + "!" + amount + "^" + MoneyType

    try {
        //var ret = InsuPEDivide("0", userId, invprt, AdmSorce, AdmReason, ExpStr, "N"); //医保组函数  DHCInsuPort.js
        var ret = InsuPEDivide("0", userId, invprt, AdmSorce, AdmReason, ExpStr, "NotCPPFlag"); //医保组函数 DHCInsuPort.js
        var InsuArr = ret.split("^");
        var ret = InsuArr[0];
        if ((ret == "-3") || (ret == "-4")) { //失败
            //回滚刚收费的发票


            var Return = tkMakeServerCall("web.DHCPE.DHCPEBillCharge", "CancelCashier", invprt, userId);
            if (Return == "") {
                this.Result.ResultCode = -100;
                this.Result.ResultMsg = "医保结算失败";
                return this.Result;
            } else {
                this.Result.ResultCode = -200;
                this.Result.ResultMsg = "回滚失败，请联系信息科：" + Return;
                return this.Result;
            }

        } else if (ret == "-1") {
            if (parent.parent.ALertWin) parent.parent.ALertWin.SetIAmount(amount);
            this.Result.ExpStr = "^" + amount;
            $.messager.alert("提示", "医保结算失败,本次收费为全自费", "info");
        } else {
            if (parent.parent.ALertWin) parent.parent.ALertWin.SetIAmount(InsuArr[2]);
            this.Result.ExpStr = InsuArr[1] + "^" + amount;
            $.messager.alert("提示", "医保结算成功,病人自费金额为:" + InsuArr[2], "info");
        }
    } catch (e) {
        this.Result.ResultCode = -404;
        this.Result.ResultMsg = "调用医保失败^" + e.message;
        return this.Result;
    }
    return this.Result;
}

/**
 * [第三方支付]
 * @param   {[Func]} callback [支付回调函数]                                 
 * @return   {object}    $PEPay.Result
 * @Author   wangguoying
 * @DateTime 2019-12-27
 */
$PEPay.extPay = function(callback) {
    this.Result = {
        ResultCode: "0",
        ResultMsg: "",
        ETPRowID: "",
        PEBarCodePayStr: "",
        ExpStr: ""
    };

    this.callback = callback;
    var payInfo = tkMakeServerCall("web.DHCPE.CashierEx", "GetPayInfoByPayCode", this.Param.Invprt); //验证是否需要第三方支付
    if (payInfo == "") {
        this.end();
        return;
    }
    var char1 = String.fromCharCode(1)
    var baseInfo = payInfo.split(char1)[1];
    var patId = baseInfo.split("^")[0];
    var paadm = baseInfo.split("^")[1];
    var scanFlag = baseInfo.split("^")[2];
    if (scanFlag == "1") {
        return this.scancodePay(payInfo, this.Param.Invprt, this.Param.UserId, this.Param.InsuID, this.Param.AdmSorce, this.Param.admReason);
    }
    var payInfo = payInfo.split(char1)[0];
    var payArr = payInfo.split("^");
    var payDR = payArr[0];
    var payCode = payArr[1];
    var payAmt = payArr[2];

    if (parseFloat(payAmt) <= 0) {
        this.end();
        return;
    }
    //科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)
    var expStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'] + "^" + patId + "^" + paadm + "^^C^" + this.Param.Invprt;
    PayService("PE", payDR, payAmt, expStr, this.extPay_callBack); //调用计费函数

}

/**
 * [结束时回调]
 * @return   {[type]}    [description]
 * @Author   wangguoying
 * @DateTime 2020-12-22
 */
$PEPay.end = function() {
    if (typeof this.callback == 'function') {
        this.callback(this.Param, this.Result);
    }
    return;
}



/**
 * [计费支付后回调函数]
 * @param    {[Objet]}    PayCenterRtn [{
                                            ResultCode: "00",
                                            ResultMsg: "该支付方式不需调用接口收费",
                                            ETPRowID: ""
                                        }]
 * @Author   wangguoying
 * @DateTime 2020-08-06
 */
$PEPay.extPay_callBack = function(PayCenterRtn) {
    if (PayCenterRtn.ResultCode != 0) {
        $PEPay.cancelExtCashier(PayCenterRtn.ResultMsg, $PEPay.Param.Invprt, $PEPay.Param.UserId, $PEPay.Param.InsuID, $PEPay.Param.AdmSorce, $PEPay.Param.AdmReason);
    } else {
        if (PayCenterRtn.ETPRowID != "") {
            $PEPay.Result.ETPRowID = PayCenterRtn.ETPRowID;
            //记录下计费订单ID，后边正式结算失败或关联订单失败时，可以根据发票取到订单ID再到异常处理界面进行手工关联
            var relate = tkMakeServerCall("web.DHCPE.CashierEx", "SetRelationTrade", $PEPay.Param.Invprt, PayCenterRtn.ETPRowID);
        }
    }
    $PEPay.end();
    return;
}


/**
 * [互联网扫码付]
 * @param    {[String]}    payInfo   [支付信息]
 * @param    {[int]}    invprt    [发票Id]
 * @param    {[int]}    userId    [用户id]
 * @param    {[int]}    InsuID    [医保结算id]
 * @param    {[int]}    AdmSorce [Pac_admreason.rea_AdmSource]
 * @param    {[int]}    admReason [Pac_admreason.Rowid]
 * @return   {object}    $PEPay.Result
 * @Author   wangguoying
 * @DateTime 2020-01-09
 */
$PEPay.scancodePay = function(payInfo, invprt, userId, InsuID, AdmSorce, admReason) {
    this.Result = {
        ResultCode: "0",
        ResultMsg: "",
        ETPRowID: "",
        PEBarCodePayStr: "",
        ExpStr: ""
    };
    var char1 = String.fromCharCode(1)
    var baseInfo = payInfo.split(char1)[1];
    var patId = baseInfo.split("^")[0];
    var paadm = baseInfo.split("^")[1];
    var scanFlag = baseInfo.split("^")[2];
    if (scanFlag != "1") {
        this.end();
        return;
    }
    var payInfo = payInfo.split(char1)[0];
    var payArr = payInfo.split("^");
    var payDR = payArr[0];
    var payCode = payArr[1];
    var payAmt = payArr[2];
    if (parseFloat(payAmt) <= 0) {
        this.end();
        return;
    }

    var groupId = session['LOGON.GROUPID'];
    var locId = session['LOGON.CTLOCID'];
    var expStr = userId + "^" + groupId + "^" + locId + "^" + session['LOGON.HOSPID'];
    var str = "dhcbarcodepay.csp";
    var payBarCode = window.showModalDialog(str, "", 'dialogWidth:300px;dialogHeight:150px;resizable:yes'); //HTML样式的模态对话框
    if ((payBarCode == "") || (payBarCode == "undefind")) {
        this.cancelExtCashier("未扫码", invprt, userId, InsuID, AdmSorce, admReason);
        this.end();
        return;
    }
    var PEBarCodePayStr = tkMakeServerCall("MHC.BarCodePay", "PEBarCodePay", paadm, payBarCode, invprt, payAmt, payCode, expStr);
    var rtnAry = PEBarCodePayStr.split("^");
    if (rtnAry[0] != 0) {
        this.cancelExtCashier("互联网支付失败", invprt, userId, InsuID, AdmSorce, admReason);
    } else {
        this.Result.PEBarCodePayStr = PEBarCodePayStr;
    }
    this.end();
    return;
}



/**
 * [撤销预结算 支付失败时调用]
 * @param    {[String]}    msg       [提示信息]
 * @param    {[int]}    userId    [用户id]
 * @param    {[int]}    InsuID    [医保结算id]
 * @param    {[int]}    AdmSorce [Pac_admreason.rea_AdmSource]
 * @param    {[int]}    admReason [Pac_admreason.Rowid]
 * @return   {object}    $PEPay.Result
 * @Author   wangguoying
 * @DateTime 2020-01-09
 */
$PEPay.cancelExtCashier = function(msg, invprt, userId, InsuID, AdmSorce, AdmReason) {
    this.Result = {
        ResultCode: "-300",
        ResultMsg: "第三方支付失败:" + msg,
        ETPRowID: "",
        PEBarCodePayStr: "",
        ExpStr: ""
    };
    //如果医保成功，撤销医保结算
    if (InsuID != "") {
        var insuStr = ""
        try {
            var insuRet = InsuPEDivideStrike("0", userId, InsuID, AdmSorce, AdmReason, insuStr, "N");
            if (insuRet != "0") {
                this.Result.ResultMsg = "结算失败,医保未退费,请和信息中心联系";
                return this.Result;
            }
        } catch (e) {
            this.Result.ResultMsg = "结算失败,医保未退费,请和信息中心联系\n" + e.message;
            return this.Result;
        }
    }
    var Return = tkMakeServerCall("web.DHCPE.DHCPEBillCharge", "CancelCashier", invprt, userId);
    if (Return != "") {
        this.Result.ResultCode = -200;
        this.Result.ResultMsg = "第三方支付失败,发票未回滚，请联系信息科：" + Return;
    }
    

    return this.Result;
}



/**
 * [第三方退费]
 * @param    {[int]}    dropInvprt [被退的发票ID]
 * @param    {[int]}    oriInvprt [原发票ID]
 * @return   {object}    $PEPay.Result
 * @Author   wangguoying
 * @DateTime 2019-12-27
 */
$PEPay.extRefund = function(dropInvprt, oriInvprt) {
    this.Result = {
        ResultCode: "0",
        ResultMsg: "",
        ETPRowID: "",
        PEBarCodePayStr: "",
        ExpStr: ""
    };
    var refundInfo = tkMakeServerCall("web.DHCPE.CashierEx", "GetPOSRefundPara", "", dropInvprt, oriInvprt);
    if (refundInfo == "") {
        return this.Result;
    }
    var char1 = String.fromCharCode(1);
    var PEBarCodePayStr = refundInfo.split(char1)[1]; //互联网扫码付支付记录
    refundInfo = refundInfo.split(char1)[0];
    var refundDr = refundInfo.split("^")[1];
    var refundAmt = parseFloat(refundInfo.split("^")[2]);
    var oldETPRowID = refundInfo.split("^")[3];
    var oldINvID = refundInfo.split("^")[4]; //正票
    var dropInvID = refundInfo.split("^")[5]; //负票              
    var newInvID = refundInfo.split("^")[6] //新票
    var oriInvID = refundInfo.split("^")[7] //原始正票
    var paadm = refundInfo.split("^")[8];
    var scanFlag = refundInfo.split("^")[9] //互联网扫码付


    if (scanFlag == "1") {
        var updateRtn = tkMakeServerCall("MHC.BarCodePay", "updatePEBarCodePay", paadm, PEBarCodePayStr, "D", "");
        if (updateRtn.split("^")[0] != "0") {
            this.Result.ResultCode = -500;
            this.Result.ResultMsg = "体检退费成功，调用互联网退费接口失败,请补交易！\n" + updateRtn;
        } else {
            //记录第三方退费成功 
            var record = tkMakeServerCall("web.DHCPE.CashierEx", "RecordPOSRefund", dropInvID);
        }
    } else {
        var expStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'];
        var refRtn = RefundPayService("PE", oriInvID, dropInvID, newInvID, refundAmt, "PE", expStr);
        if (refRtn.ResultCode != 0) {
            this.Result.ResultCode = -500;
            this.Result.ResultMsg = "体检退费成功，调用第三方退费接口失败,请补交易！\n" + refRtn.ResultMsg;
        } else {
            //记录第三方退费成功 
            var record = tkMakeServerCall("web.DHCPE.CashierEx", "RecordPOSRefund", dropInvID);
        }
    }
    return this.Result;
}