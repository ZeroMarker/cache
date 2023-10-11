//名称	DHCPEAdvancePayment.Find.hisui.js
//功能	体检卡管理	
//创建	2019.07.01
//创建人  xy
//

/** 支付参数 */
var $Pay = {
	TradeType: "",
	InStrings: "",
	NoPrint: "",
	Fee: ""
}

/** @type {Boolean} [体检卡走电子发票标记] */
var _EINVOICE = false;

$(function () {

	var eInvoice = tkMakeServerCall("web.DHCPE.AdvancePayment", "HadEInvoiceFlag", session["LOGON.USERID"], session["LOGON.CTLOCID"], session["LOGON.GROUPID"]);
	_EINVOICE = eInvoice == "1" ? true : false;

	InitCombobox();

	//默认时间
	Initdate();

	InitAdvancePaymentGrid();

	//查询
	$("#BFind").click(function () {
		BFind_click();
	});


	//清屏
	$("#BClear").click(function () {
		BClear_click();
	});


	//读卡
	$("#BReadCard").click(function () {
		ReadCardClickHandle();
	});

	$("#RegNo").keydown(function (e) {

		if (e.keyCode == 13) {
			BFind_click();
		}

	});


	$("#CardNo").keydown(function (e) {
		if (e.keyCode == 13) {
			CardNo_Change();
		}

	});

	$("#TJCardType").combobox({
		onSelect: function () {
			CardType_change();
		}
	});

	$("#ATJCardType").combobox({
		onSelect: function () {
			ATJCardType_change();
		}
	});

	//新增
	$("#BNew").click(function () {
		BNew_click();
	});


	$("#ARegNo").keydown(function (e) {
		if (e.keyCode == 13) {
			$(this).unbind("change");
			ARegNo_change();
		}

	});

	$("#ARegNo").change(function () {
		ARegNo_change();
	});

	$("#ACardNo").keydown(function (e) {
		if (e.keyCode == 13) {
			ACardNo_Change();
		}

	});

	$("#PayMode").combobox({
		onSelect: function () {
			PayMode_change();
		}
	});
	CardType = $("#TJCardType").combobox('getValue');
	if (CardType == "C") {
		$("#EndLineDate").datebox('enable');
	} else {
		$("#EndLineDate").datebox('disable');

	}

	//默认体检卡类型为"预缴金"
	$("#TJCardType").combobox('setValue', "R");


})
/****************************************************新增区域代码**********************************/
function PayMode_change() {
	var PayModeNew = $("#PayMode").combobox('getValue');
	if (($("#PayMode").combobox('getValue') == undefined) || ($("#PayMode").combobox('getValue') == "")) {
		var PayModeNew = "";
	}
	var PayModeDesc = tkMakeServerCall("web.DHCPE.Cashier", "GetPayModeDesc", PayModeNew);
	if ((PayModeDesc != "") && (PayModeDesc.indexOf("支票") >= 0)) {
		$("#No").attr('disabled', false);
	} else {

		$("#No").attr('disabled', true);
		$("#No").val("");
	}

}

//新增
function BNew_click() {

	$("#myWin").show();

	var myWin = $HUI.dialog("#myWin", {
		iconCls: 'icon-w-card',
		resizable: true,
		title: '体检卡管理',
		modal: true,
		buttonAlign: 'center',
		buttons: [{
			iconCls: 'icon-w-add',
			text: '新建',
			id: 'BSave',
			handler: function () {
				BSave_click()
			}
		}, {
			iconCls: 'icon-w-update',
			text: '修改状态',
			id: 'BChangeStatus',
			handler: function () {
				BChangeStatus()
			}
		}, {
			iconCls: 'icon-w-card',
			text: '读卡',
			id: 'BReadCard_btn',
			handler: function () {
				BReadCard()
			}
		}, {
			iconCls: 'icon-w-clean',
			text: '清屏',
			id: 'BClear_btn',
			handler: function () {
				BClear()
			}
		}, {
			iconCls: 'icon-w-close',
			text: '关闭',
			handler: function () {
				myWin.close();
			}
		}]
	});

	$('#form-save').form("clear");
	$("#ATJCardType").combobox('setValue', "R");
	$("#AStatus").combobox('setValue', "N");
	FillData(1);
	SetInvNo();
	AElementEnble();
	$("#PayMode").combobox('setValue', "1");
	$("#No").attr('disabled', true);

}



//修改状态
function BChangeStatus() {

	var RowID = $("#RowID").val();
	if (RowID == "") {
		$.messager.alert("提示", "没有要修改的记录", "info");
		return false;
	}
	var Status = $("#AStatus").combobox('getValue');
	var Remark = $("#MRemark").val();
	var Strings = RowID + "^" + Status + "^" + Remark;
	var ret = tkMakeServerCall("web.DHCPE.AdvancePayment", "UpdateData", "3", Strings)
	var RetArr = ret.split("^");
	if (RetArr[0] != 0) {
		$.messager.alert("提示", RetArr[0], "info");
		return false;
	}
	$.messager.alert("提示", "操作完成", "success");


	AElementEnble();
}


//清屏
function BClear() {
	$("#ARegNo,#AName,#ACardTypeNew,#ACardNo,#Sex,#Age,#Amount,#Remark,#Fee,#MRemark,#No,#InvName,#RowID,#PADM,#Tel,#IDCard").val("");
	$(".hisui-checkbox").checkbox('setValue', false);
	$("#AStatus").combobox('setValue', "N");
	$("#PayMode").combobox('setValue', "1");
	$("#EndLineDate").datebox('setValue');

	var RowID = $("#RowID").val()
	if (RowID == "") {

		SetCElement("BSave", "新建");
		$("#Rebate").attr('disabled', false);

	}
}


function ACardNo_Change() {
	var myCardNo = $("#ACardNo").val();
	if (myCardNo == "") {
		$.messager.alert("提示", "卡号为空", "info");
		return;
	}
	var myrtn = DHCACC_GetAccInfo("", myCardNo, "", "", CardTypeCallBack);
	return false;

}

//读卡
function BReadCard() {
	DHCACC_GetAccInfo7(CardTypeCallBack);
}

function CardTypeCallBack(myrtn) {
	//alert(myrtn)

	var CardNo = $("#ACardNo").val();
	var CardTypeNew = $("#ACardTypeNew").val();
	$("#ARegNo,#AName,#Sex,#Age,#Amount,#Remark,#Fee,#MRemark,#No,#InvName,#PADM,#Tel,#IDCard").val("");
	$(".hisui-checkbox").checkbox('setValue', false);
	$("#AStatus").combobox('setValue', "N");
	$("#PayMode").combobox('setValue', "1");
	//$(".textbox").val('');
	$("#ACardTypeNew").val(CardTypeNew);

	var myary = myrtn.split("^");
	var rtn = myary[0];
	if ((rtn == "0") || (rtn == "-201")) {
		var PatientID = myary[4];
		var PatientNo = myary[5];
		var CardNo = myary[1];
		$("#CardTypeRowID").val(myary[8]);
		$("#ACardNo").focus().val(CardNo);
		$("#ARegNo").val(PatientNo);
		ARegNo_change();
	} else if (rtn == "-200") {
		/*$.messager.alert("提示","卡无效!","info",function(){
			$("#ACardNo").val(CardNo).focus();
		});
		*/
		$.messager.popover({
			msg: "卡无效!",
			type: "info"
		});
		$("#CardNo").focus().val(CardNo);

		return false;
	}
}

function ARegNo_change() {
	var Type = $("#ATJCardType").combobox('getValue');
	if (($("#ATJCardType").combobox('getValue') == undefined) || ($("#ATJCardType").combobox('getValue') == "")) {
		var Type = "";
	}
	if (Type == "") {
		$.messager.alert("提示", "请选择体检卡类型", "info");
		return false;
	}
	$("#RowID").val("");
	var RowID = $("#RowID").val();
	if (RowID == "") {

		SetCElement("BSave", "新建");
		$("#Rebate").attr('disabled', false);

	}

	FillPatientData();
	AElementEnble();

}

function FillPatientData() {
	var HospID = session['LOGON.HOSPID']
	var LocID = session['LOGON.CTLOCID']
	var Type = $("#ATJCardType").combobox('getValue');
	if (($("#ATJCardType").combobox('getValue') == undefined) || ($("#ATJCardType").combobox('getValue') == "")) {
		var Type = "";
	}

	var RegNo = $("#ARegNo").val();
	if (RegNo == "") return;

	var Data = tkMakeServerCall("web.DHCPE.AdvancePayment", "GetPatientInfo", RegNo, Type, HospID, LocID)
	if (Type != "C") {
		if (Data == "") {
			$("#AName,#ACardTypeNew,#ACardNo,#Sex,#Age,#Amount,#Remark,#Fee,#MRemark,#No,#InvName,#PADM,#Tel,#IDCard").val("");
			$(".hisui-checkbox").checkbox('setValue', false);
			$("#AStatus").combobox('setValue', "N");
			$("#PayMode").combobox('setValue', "1");
			$.messager.popover({
				msg: "无效的登记号",
				type: "info"
			});

			return false;
		}
		var DataArr = Data.split("^");
		$("#ARegNo").val(DataArr[0]);
		$("#AName").val(DataArr[1]);
		$("#Age").val(DataArr[2]);
		$("#Sex").val(DataArr[3]);
		$("#Tel").val(DataArr[6]);
		$("#IDCard").val(DataArr[7]);
		$("#ACardNo").val(DataArr[4]);
		//根据登记号带出卡类型 
		var CardTypeNewStr = tkMakeServerCall("web.DHCPE.PreIBIUpdate", "CardTypeByRegNo", $("#ARegNo").val());
		if (CardTypeNewStr != "") {

			var CardTypeNew = CardTypeNewStr.split("^")[1];
			$("#ACardTypeNew").val(CardTypeNew);
		}

		if (DataArr[5] == "") {
			$("#Amount,#Remark").val("");
		}
		if (DataArr[5] != "") {
			$("#RowID").val(DataArr[5]);
			FillData(0);
		}
	} else {
		if (Data == "") {
			$("#AName,#ACardTypeNew,#ACardNo,#Sex,#Age,#Amount,#Remark,#Fee,#MRemark,#No,#InvName,#PADM,#Tel,#IDCard").val("");
			$(".hisui-checkbox").checkbox('setValue', false);
			$("#AStatus").combobox('setValue', "N");
			$("#PayMode").combobox('setValue', "1");
			return false;
		}
		var DataArr = Data.split("^");

		$("#ARegNo").val(DataArr[0]);
		$("#AName").val(DataArr[1]);
		$("#Age").val(DataArr[2]);
		$("#Sex").val(DataArr[3]);
		$("#ACardNo").val(DataArr[4]);
		$("#AStatus").combobox('setValue', DataArr[6]);
		$("#Tel").val(DataArr[7]);
		$("#IDCard").val(DataArr[8]);
		$("#EndLineDate").datebox('setValue',DataArr[9]),
		$("#Rebate").val(DataArr[10]);
		if (DataArr[5] != "") {
			$("#RowID").val(DataArr[5]);
			FillData(0);
		}
	}
	var Fee = $("#Fee").val();
	if (Fee == "") {
		//websys_setfocus("Fee");
	} else {
		//websys_setfocus("BSave");
	}
	return true;
}

function FillData(Flag) {
	var RowID = $("#RowID").val();
	//alert(RowID)
	if (RowID == "") {
		SetCElement("BSave", "新建");
		$("#Rebate").attr('disabled', false);
		return false;
	} else {


		var Type = $("#ATJCardType").combobox('getValue');
		if (($("#ATJCardType").combobox('getValue') == undefined) || ($("#ATJCardType").combobox('getValue') == "")) {
			var Type = "";
		}
		if ((Type != "R") && (Type != "C")) {
			$("#BSave").linkbutton('disable');

		} else {
			$("#BSave").linkbutton('enable');
			SetCElement("BSave", "充值");
			$("#Rebate").attr('disabled', true);

		}
	}

	var Data = tkMakeServerCall("web.DHCPE.AdvancePayment", "GetData", RowID)
	var DataArr = Data.split("^");

	if (Type == "C") {
		$("#ARegNo").val(DataArr[1]);
	}
	if (Type != "C") {
		$("#ARegNo").val(DataArr[0]);
	}

	$("#ATJCardType").combobox('setValue', DataArr[2]);

	$("#Amount").val(changeTwoDecima(DataArr[3]));
	$("#AStatus").combobox('setValue', DataArr[4]);
	$("#Remark").val(DataArr[8]);

	//SetOneData("PassWord",DataArr[9]);
	if (Flag == 1) {
		FillPatientData()
	}

}

//保留小数点后两位
function changeTwoDecima(num) {

	var num = Math.floor(num * 100) / 100;

	var num = num.toString();

	if (num.indexOf('.') > 0) {
		if (num.split(".")[1].length < 2) {
			num = num + "0"
		};
	} else {
		num = num + ".00"
	}
	return num
}

function BSave_click() {
	var HospID = session['LOGON.HOSPID']
	var LocID = session['LOGON.CTLOCID']
	var UserID = session['LOGON.USERID']

	var Type = $("#ATJCardType").combobox('getValue');
	if (($("#ATJCardType").combobox('getValue') == undefined) || ($("#ATJCardType").combobox('getValue') == "")) {
		var Type = "";
	}
	if (Type == "") {
		$.messager.alert("提示","请选择体检卡类型!","info",function(){
             $("#ATJCardType").combobox('textbox').focus();
          });
		return false

	}

	var RegNo = $.trim($("#ARegNo").val());
	if ((RegNo == "") && (Type == "R")) {
		$.messager.alert("提示","请输入登记号!","info",function(){
             $("#ARegNo").focus();
          });
		return;
	}
	if ((RegNo == "") && (Type == "C")) {
		$.messager.alert("提示","请输入代金卡号!","info",function(){
             $("#ARegNo").focus();
          });
		return;
	}
	if ((Type == "C") && (document.getElementById('BSave').innerHTML.indexOf("新建") > -1)) {
		var flag = tkMakeServerCall("web.DHCPE.AdvancePayment", "IsExsistCardByCardNo", RegNo);
		if (flag == "1") {
			$.messager.alert("提示","该卡号已被使用，请输入可用的卡号!","info",function(){
				$("#ARegNo").focus();
			});
			$("#ARegNo").val("");
			return false;
		}
	}

	var Data = tkMakeServerCall("web.DHCPE.AdvancePayment", "GetPatientInfo", RegNo, Type, HospID, LocID)
	if (Type != "C") {
		if (Data == "") {
			$.messager.alert("提示","无效的登记号","info",function(){
             	$("#ARegNo").focus();
           });
			return false;
		}
	}

	var NoPrint = "N";
	var NoPrintFlag = $("#NoPrintFlag").checkbox('getValue');
	if (NoPrintFlag) {
		NoPrint = "Y";
	} else {
		NoPrint = "N"
	}



	var RowID = $("#RowID").val();
	var APCRowID = "";
	if (RowID != "") {
		var InvID = $("#CurInv").val();
		var InvID = tkMakeServerCall("web.DHCPE.DHCPECommon", "GetInvnoNotZM", InvID);
		if (InvID == "" && !_EINVOICE) {
			$.messager.alert("提示", "没有发票,不能充值", "info");
			return false;
		}
		var Fee = $("#Fee").val();
		if (Fee == "") {
			$.messager.alert("提示","充值金额不能为空","info",function(){
             	$("#Fee").focus();
           });
			return false;
		}
		if ((isNaN(Fee)) || (Fee == "") || (Fee == 0) || (Fee < 0)) {
			$.messager.alert("提示","请输入正确的充值金额","info",function(){
             	$("#Fee").focus();
           });
			return false;
		}

		if ((Fee != "") && (Fee.indexOf(".") != "-1") && (Fee.toString().split(".")[1].length > 2)) {
			$.messager.alert("提示","充值金额小数点后不能超过两位","info",function(){
             	$("#Fee").focus();
           });
			return false;
		}


		var PayMode = $("#PayMode").combobox('getValue');
		if (($("#PayMode").combobox('getValue') == undefined) || ($("#PayMode").combobox('getValue') == "")) {
			var PayMode = "";
		}
		if (PayMode == "") {
			$.messager.alert("提示","支付方式不能为空","info",function(){
             	$("#PayMode").combobox('textbox').focus();
           });
			return false;
		}
		var CardInfo = "";
		var CardInfo = $("#No").val();
		var PayModeDesc = tkMakeServerCall("web.DHCPE.Cashier", "GetPayModeDesc", PayMode);
		if (PayModeDesc.indexOf("支票") >= 0) {

			if (CardInfo == "") {
				$.messager.alert("提示","请输入支票号","info",function(){
             		$("#No").focus();
           		});
				return false;
			}
		}
		var Remark = $("#Remark").val();
		var MRemark = $("#MRemark").val();
		var PADM = $("#PADM").val();
		var InStrings = RowID + "^" + Fee + "^" + InvID + "^" + PayMode + "^" + MRemark + "^" + NoPrint + "^" + PADM + "^" + CardInfo + "^" + Remark;
		//alert(InStrings)
		var Type = $("#ATJCardType").combobox('getValue');
		if (($("#ATJCardType").combobox('getValue') == undefined) || ($("#ATJCardType").combobox('getValue') == "")) {
			var Type = "";
		}
		if (Type == "C") {
			var sName = $.trim($("#AName").val());
			if (sName == "") {
				//$.messager.alert("提示","姓名不能为空","info");	
				//return false;
			}

			var sSex = $("#Sex").val();
			if ((sSex != "") && (sSex != "男") && (sSex != "女") && (sSex != "不限")) {
				$.messager.alert("提示","性别请填写:男、女、不限","info",function(){
             		$("#Sex").focus();
           		});
				return false;
			}
			var sAge = $("#Age").val();
			if (!(IsFloat(sAge))) {
				$.messager.alert("提示","年龄格式非法","info",function(){
             		$("#Age").focus();
           		});
				return false;
			}
			var sTel = $("#Tel").val();
			if (!isMoveTel(sTel)) {
				$.messager.alert("提示","联系电话格式非法","info",function(){
             		$("#Tel").focus();
           		});
				return false;
			}
			var sIDCard = $("#IDCard").val();

			InStrings = InStrings + "&" + sName + "^" + sSex + "^" + sAge + "&" + sTel + "^" + sIDCard
		}
		$Pay = {
				TradeType: "2",
				InStrings: InStrings,
				NoPrint: NoPrint,
				Fee: Fee
			}
		var scanPay = tkMakeServerCall("web.DHCPE.AdvancePayment", "IsScanPay", PayMode,session['LOGON.CTLOCID']);
		if (scanPay == "1") {
			
			//科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)
			var expStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'] + "^" + "" + "^" + "" + "^^C^" + "";
			var PayCenterRtn = PayService("PEDEP", PayMode, Fee, expStr, payCallback);
		} else {
			payCallback({
				ResultCode: "0",
				ResultMsg: "成功",
				"ETPRowID": ""
			});
		}
	} else {
		var RegNo = $.trim($("#ARegNo").val());

		var Type = $("#ATJCardType").combobox('getValue');
		if (($("#ATJCardType").combobox('getValue') == undefined) || ($("#ATJCardType").combobox('getValue') == "")) {
			var Type = "";
		}
		var CardNo = "";
		if (Type != "C") {
			if (RegNo == "") {
				$.messager.alert("提示","登记号不能为空","info",function(){
             		$("#ARegNo").focus();
           		});
				return false;
			}
		} else {

			var CardNo = RegNo;
			var RegNo = "";
			if (CardNo == "") {
				$.messager.alert("提示","卡号不能为空","info",function(){
             		$("#ARegNo").focus();
           		});
				return false;
			}
		}
		var Amount = $("#Amount").val();
		var Status = $("#AStatus").combobox('getValue');
		if (Status != "N") {
			$.messager.alert("提示","不是可用的状态","info",function(){
             	$("#AStatus").combobox('textbox').focus();
           	});
			return false;
		}
		var Date = "",
			Time = "",
			User = ""
		var Remark = $("#Remark").val()
		var PassWord = "";
		if (Type == "C") {
			PassWord = tkMakeServerCall("web.DHCPE.AdvancePayment", "GetPassWord", session['LOGON.CTLOCID']);
		}
		//var PassWord=GetOneData("PassWord")
		var Fee = $("#Fee").val();

		var CardInfo = "";
		var CardInfo = $("#No").val();
		var PayMode = $("#PayMode").combobox('getValue');
		if (($("#PayMode").combobox('getValue') == undefined) || ($("#PayMode").combobox('getValue') == "")) {
			var PayMode = "";
		}
		if (PayMode == "") {
			$.messager.alert("提示","支付方式不能为空","info",function(){
             	$("#PayMode").combobox('textbox').focus();
           	});
			return false;
		}
		var PayModeDesc = tkMakeServerCall("web.DHCPE.Cashier", "GetPayModeDesc", PayMode);
		if (PayModeDesc.indexOf("支票") >= 0) {

			if (CardInfo == "") {
				$.messager.alert("提示","请输入支票号","info",function(){
             		$("#No").focus();
           		});
				return false;
			}
		}

		if (Fee != "") {
			var InvID = $("#CurInv").val();
			var InvID = tkMakeServerCall("web.DHCPE.DHCPECommon", "GetInvnoNotZM", InvID);
			if (InvID == "" && !_EINVOICE) {
				$.messager.alert("提示", "没有发票,不能充值", "info");
				return false;
			}
		} else if (Fee == "") {

			if ((Type == "C") || (Type == "R")) {
				$.messager.alert("提示","充值金额不能为空","info",function(){
             		$("#Fee").focus();
           		});
				return false;
			}
		}
		if ((isNaN(Fee)) || (Fee == "") || (Fee == 0) || (Fee < 0)) {
			$.messager.alert("提示","请输入正确的充值金额","info",function(){
             		$("#Fee").focus();
           		});
			return false;
		}
		if ((Fee != "") && (Fee.indexOf(".") != "-1") && (Fee.toString().split(".")[1].length > 2)) {
			$.messager.alert("提示","充值金额小数点后不能超过两位","info",function(){
             	$("#Fee").focus();
           	});
			return false;
		}
		var PayMode = $("#PayMode").combobox('getValue');
		if (($("#PayMode").combobox('getValue') == undefined) || ($("#PayMode").combobox('getValue') == "")) {
			var PayMode = "";
		}
		if (PayMode == "") {
			$.messager.alert("提示","支付方式不能为空","info",function(){
             	$("#PayMode").combobox('textbox').focus();
           	});
			return false;
		}
		var MRemark = $("#MRemark").val();
		var EndLineDate = "";
		var EndLineDate = $("#EndLineDate").datebox('getValue');
		if (EndLineDate != "") {
			var Flag = tkMakeServerCall("web.DHCPE.AdvancePayment", "GetDateUseFlag", EndLineDate);
			if (Flag == 1) {
				$.messager.alert("提示","截止日期不能小于今天","info",function(){
             		$("#EndLineDate").focus();
           		});
				return false;
			}

		}

		var Rebate = $("#Rebate").val();
		if (Rebate != "") {
			if ((Rebate != "") && ((Rebate <= 0) || (Rebate >= 100))) {
				$.messager.alert("提示","输入的折扣系数应大于0小于100","info",function(){
             		$("#Rebate").focus();
           		});
				return false;
			}

			if (!IsFloat(Rebate)) {
				$.messager.alert("提示","输入的折扣系数格式不正确","info",function(){
             		$("#Rebate").focus();
           		});
				return false;
			}
			var userId = session['LOGON.USERID'];
			var LocID = session['LOGON.CTLOCID'];
			var ReturnStr = tkMakeServerCall("web.DHCPE.CT.ChargeLimit", "GetOPChargeLimitInfo", userId, LocID);
			var OPflagOne = ReturnStr.split("^");
			var DFLimit = OPflagOne[3];
			if (DFLimit == 0) {
				$.messager.alert("提示", "没有打折权限", "info");
				return;
			}
			if (+DFLimit > +Rebate) {
				$.messager.alert("提示", "权限不足,您的折扣权限为:" + DFLimit + "%", "info");
				return;
			}
		}
		if ((MRemark == "") && (Remark != "")) {
			var MRemark = Remark;
		}
		var PADM = $("#PADM").val();
		var InStrings = "^" + RegNo + "^" + CardNo + "^" + Type + "^" + Amount +
			"^" + Status + "^" + Date + "^" + Time + "^" + User +
			"^" + Remark + "^" + PassWord + "^^^^" + EndLineDate + "^" + Rebate + "&" + Fee + "^" + InvID + "^" + PayMode + "^" + MRemark + "^" + NoPrint + "^" + PADM + "^" + CardInfo;
		//alert(InStrings)
		if (Type == "C") {
			var sName = $.trim($("#AName").val());
			if (sName == "") {
				//$.messager.alert("提示","姓名不能为空","info");
				//return false;
			}
			var sSex = $("#Sex").val();
			if ((sSex != "") && (sSex != "男") && (sSex != "女") && (sSex != "不限")) {
				$.messager.alert("提示","性别请填写:男、女、不限","info",function(){
             		$("#Sex").focus();
           		});
				return false;
			}
			var sAge = $("#Age").val();
			if (!(IsFloat(sAge))) {
				$.messager.alert("提示","年龄格式非法","info",function(){
             		$("#Age").focus();
           		});
				return false;
			}
			var sTel = $("#Tel").val();
			if (!isMoveTel(sTel)) {
				$.messager.alert("提示","联系电话格式非法","info",function(){
             		$("#Tel").focus();
           		});
				return false;
			}
			var sIDCard = $("#IDCard").val();

			InStrings = InStrings + "&" + sName + "^" + sSex + "^" + sAge + "&" + sTel + "^" + sIDCard
		}
		$Pay = {
				TradeType: "1",
				InStrings: InStrings,
				NoPrint: NoPrint,
				Fee: Fee
			}
		var scanPay = tkMakeServerCall("web.DHCPE.AdvancePayment", "IsScanPay", PayMode,session['LOGON.CTLOCID']);
		if (scanPay == "1") {
			
			//科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)
			var expStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'] + "^" + "" + "^" + "" + "^^C^" + "";
			var PayCenterRtn = PayService("PEDEP", PayMode, Fee, expStr, payCallback);
		} else {
			payCallback({
				ResultCode: "0",
				ResultMsg: "成功",
				"ETPRowID": ""
			});
		}
	}



}
/**
* [支付回调函数]
* @param    {[Object]}    PayCenterRtn    [{
                                            ResultCode: "00",
                                            ResultMsg: "该支付方式不需调用接口收费",
                                            ETPRowID: ""
                                        }]
* @Author wangguoying
* @Date 2022-01-10
*/
function payCallback(PayCenterRtn) {
	var ETPRowID = "";
	if (PayCenterRtn.ResultCode != 0) {
		$.messager.alert("提示", "第三方支付失败：" + PayCenterRtn.ResultMsg, "error");
		return false;
	} else {
		ETPRowID = PayCenterRtn.ETPRowID;
	}
	var ret = tkMakeServerCall("web.DHCPE.AdvancePayment", "UpdateData", $Pay.TradeType, $Pay.InStrings)
	var RetArr = ret.split("^");
	//alert(ret)
	if (RetArr[0] != 0) {
		$.messager.alert("提示", "体检结算失败：" + RetArr[0] + ",患者已扣费，请后台处理", "error");
		return false;
	} else {
		APCRowID = RetArr[2];
		if (ETPRowID != "") {
			var updRet = tkMakeServerCall("web.DHCPE.AdvancePayment","UpdatePayCodeByETPRowID",APCRowID,ETPRowID,session["LOGON.CTLOCID"])
			if(updRet != "0"){
				$.messager.alert("提示", "已收费，更新真实支付方式失败,请联系信息科！", "error");
				
			}	
			var ReFlag = RelationService(ETPRowID, APCRowID, "PEDEP");
			if (ReFlag.ResultCode != "0") {
				$.messager.alert("提示", "计费关联失败，请联系信息科！\n" + ReFlag.ResultMsg, "info");
			}
		}

	}

	PrintReceipt();
	$("#Fee").val("");
	$.messager.alert("提示", "充值成功!", "success");
	if (($Pay.Fee != "") && ($Pay.NoPrint == "N")) {
		var InvID = $("#CurInv").val();
		PrintInv(InvID)
	}

	BFind_click();
	$('#myWin').dialog('close');
}

function PrintReceipt() {
	var CardNo = $("#ARegNo").val()
	var Cost = $("#Fee").val();
	PrintAccSheet(CardNo, Cost);
}

function PrintAccSheet(CardNo, Cost) {
	if (CardNo == "") return;
	if (Cost == "") return;

	var PayModeDR = 21;
	var Type = $("#ATJCardType").combobox('getValue');
	if (($("#ATJCardType").combobox('getValue') == undefined) || ($("#ATJCardType").combobox('getValue') == "")) {
		var Type = "";
	}
	var CurrentBalance = tkMakeServerCall("web.DHCPE.AdvancePayment", "GetAPAmount", PayModeDR + "^" + Type, CardNo);
	var DateTime = tkMakeServerCall("web.DHCPE.Cashier", "GetDateTimeStr");

    Cost = Number(Cost).toFixed(2);
	var Delim = String.fromCharCode(2);
	//var TxtInfo = "CardNo" + Delim + CardNo;
	var TxtInfo = TxtInfo + "^" + "Cost" + Delim + Cost+"元";
	var TxtInfo = TxtInfo + "^" + "CurrentBalance" + Delim + CurrentBalance+"元";
	var TxtInfo = TxtInfo + "^" + "DateTime" + Delim + DateTime;
	var CardNoL = "卡号:"
	if (Type == "R") {
		var CardNoL = "登记号:"+CardNo;
	} else {
		var CardNoL = "卡号:"+CardNo;
	}
	var TxtInfo = TxtInfo + "^" + "CardNoL" + Delim + CardNoL;
	var HosName = "";
	var HosName = tkMakeServerCall("web.DHCPE.DHCPECommon", "GetHospitalName", session['LOGON.HOSPID'])
	var TxtInfo = TxtInfo + "^" + "HosName" + Delim + HosName;
	
	var CurInfo = tkMakeServerCall("web.DHCPE.AdvancePayment", "GetAPAmountInfo", PayModeDR + "^" + Type, CardNo);
	var ret=CurInfo.split("^");
	var TxtInfo = TxtInfo + "^" + "Name" + Delim + ret[0];
	var TxtInfo = TxtInfo + "^" + "PayMode" + Delim + ret[1];
	var RMBDX = tkMakeServerCall("web.DHCPE.DHCPEPAY", "RMBDXXZH", "","",Cost,"2")
	var TxtInfo = TxtInfo + "^" + "RMBDX" + Delim + RMBDX;
	var TxtInfo = TxtInfo + "^" + "User" + Delim + session['LOGON.USERNAME'];
	PrintBalance(TxtInfo);

}
// 打印体检支付卡余额
function PrintBalance(TxtInfo) {
	DHCP_GetXMLConfig("InvPrintEncrypt", "PEReceipt");
	var myobj = document.getElementById("ClsBillPrint");
	var Delim = String.fromCharCode(2);
	var TxtInfoPat = TxtInfo + "^" + "BottomRemark" + Delim + "(商户存根)";
	//DHCP_PrintFun(myobj,TxtInfoPat,"");
	DHC_PrintByLodop(getLodop(), TxtInfoPat, "", "", "");
}

//打印发票
function PrintInv(InvID) {
	var LocID = session['LOGON.CTLOCID']
	var InvName = $("#InvName").val();
	var TaxpayerNum = $("#TaxpayerNum").val();
	var InvName = InvName + "^" + TaxpayerNum;

	var TxtInfo = tkMakeServerCall("web.DHCPE.AdvancePayment", "GetInvoiceInfo", InvID, "1", InvName, LocID);
	var ListInfo = tkMakeServerCall("web.DHCPE.AdvancePayment", "GetInvoiceInfo", InvID, "2", InvName, LocID);
	if (TxtInfo == "") return

	DHCP_GetXMLConfig("InvPrintEncrypt", "PEInvPrint");
	DHC_PrintByLodop(getLodop(), TxtInfo, ListInfo, "", "");

	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}






function ATJCardType_change() {
	AElementEnble();
	$("#ARegNo,#AName,#ACardTypeNew,#ACardNo,#Sex,#Age,#Amount,#Remark,#Fee,#MRemark,#No,#InvName,#Tel,#IDCard,#TaxpayerNum,#Rebate").val("");
	$("#RowID").val("");

}

function AElementEnble() {

	var Type = $("#ATJCardType").combobox('getValue');
	if (($("#ATJCardType").combobox('getValue') == undefined) || ($("#ATJCardType").combobox('getValue') == "")) {
		var Type = "";
	}
	//alert(Type)
	if (Type == "R") {
		$("#BChangeStatus").linkbutton('disable');
		//$("#BReadCard_btn").linkbutton('enable');
		$("#EndLineDate").datebox('disable');
		$("#AStatus").combobox('disable');
		$("#AStatus").combobox('setValue', "N");
		$("#Rebate").attr('disabled',true);

	} else {
		$("#Rebate").attr('disabled', false);
		$("#AStatus").combobox('enable');
		$("#EndLineDate").datebox('enable');
		//$("#BReadCard_btn").linkbutton('disable');
		$("#BChangeStatus").linkbutton('enable');
		var Status = $("#AStatus").combobox('getValue');
		if (Status != "N") {
			$("#BSave").linkbutton('disable');

		} else {
			$("#BSave").linkbutton('enable');
		}
	}

	if ((Type != "R") && (Type != "C")) {
		$("#Fee").attr('disabled', true);
		$("#PayMode").attr('disabled', true);

	} else {
		$("#Fee").attr('disabled', false);
		$("#PayMode").attr('disabled', false);
	}

	if (Type == "C") {

		document.getElementById("cARegNo").innerHTML = "代金卡号";
		//$('#card').hide();
		/*$("#ACardNo").css('display', 'none'); //隐藏
		$("#cACardNo").css('display', 'none'); //隐藏
		$("#ACardTypeNew").css('display', 'none'); //隐藏
		$("#cACardTypeNew").css('display', 'none'); //隐藏*/
		//$("#ARegNo").css('display','none');//隐藏
		$("#ACardTypeNew").attr('disabled', true);
		$("#ACardNo").attr('disabled', true);
       
		$("#ATName").attr('disabled', false);
		$("#Sex").attr('disabled', false);
		$("#Tel").attr('disabled', false);
		$("#IDCard").attr('disabled', false);
		$("#Age").attr('disabled', true);
		//$("#BReadCard").linkbutton('disable');
		
		
	} else {
		document.getElementById("cARegNo").innerHTML = "登记号";
		//$('#card').show();
		/*$("#ACardNo").css('display', 'block'); //显示
		$("#cACardNo").css('display', 'block'); //显示
		$("#ACardTypeNew").css('display', 'block'); //显示
		$("#cACardTypeNew").css('display', 'block'); //显示*/
		$("#ACardTypeNew").attr('disabled', false);
		$("#ACardNo").attr('disabled', false);

		//$("#ARegNo").css('display','block');//显示
		$("#ARegNo").attr('disabled', false);

		$("#ATName").attr('disabled', true);
		$("#Sex").attr('disabled', true);
		$("#Age").attr('disabled', true);
		$("#Tel").attr('disabled', true);
		$("#IDCard").attr('disabled', true);

		//$("#APCardNo").css('display','none');//隐藏

		//$("#BReadCard").linkbutton('enable');

	}

}
//获取当前发票号
function SetInvNo() {
	var userId = session['LOGON.USERID'];
	var LocID = session['LOGON.CTLOCID'];

	//var ret=tkMakeServerCall("web.DHCPE.DHCPEPAY","getcurinvno",userId);
	var ret = tkMakeServerCall("web.DHCPE.DHCPEPAY", "getcurinvno", userId, "N", LocID);

	var invNo = ret.split("^");
	if ((invNo[0] == "") || (invNo[1] == "") && !_EINVOICE) {
		$.messager.alert('提示', '没有正确的发票号', "info");
		return false;
	}

	if (invNo[2] != "") {
		var No = invNo[2] + "" + invNo[0];
	} else {
		var No = invNo[0];
	}
	$("#CurInv").val(No);
	if (_EINVOICE) {
		$("#NoPrintFlag").checkbox("setValue", true);
		$("#NoPrintFlag").checkbox("disable");
	}
}
/****************************************************新增区域代码End**********************************/

function CardType_change() {

	ElementEnble();
}

function ElementEnble() {
	CardType = $("#TJCardType").combobox('getValue');
	if (CardType == "C") {
		document.getElementById('cRegNo').innerHTML = "代金卡号";
		$("#CardNo").css('display', 'none');
		$("#cCardNo").css('display', 'none');
		$("#CardTypeNew").css('display', 'none');
		$("#cCardTypeNew").css('display', 'none');
		//$("#BReadCard").css('display','none');


	}
	if (CardType == "R") {
		document.getElementById('cRegNo').innerHTML = "登记号";
		$("#CardNo").css('display', 'block');
		$("#cCardNo").css('display', 'block');
		$("#CardTypeNew").css('display', 'block');
		$("#cCardTypeNew").css('display', 'block');
		//$("#BReadCard").css('display','block');



	}
}

//查询
function BFind_click() {
	var HospID = session['LOGON.HOSPID']
	var CTLocID = session['LOGON.CTLOCID'];
	var Type = $("#TJCardType").combobox('getValue');

	var RegNoLength = tkMakeServerCall("web.DHCPE.DHCPECommon", "GetRegNoLength", CTLocID);
	iRegNo = $("#RegNo").val();

	if (Type == "R") {
		if (iRegNo.length < RegNoLength && iRegNo.length > 0) {
			iRegNo = tkMakeServerCall("web.DHCPE.DHCPECommon", "RegNoMask", iRegNo, CTLocID);
			$("#RegNo").val(iRegNo)
		};
		var columns = [
			[{
					field: 'TRowID',
					title: 'ID',
					hidden: true
				},
				{
					field: 'TRegNo',
					width: 150,
					title: '登记号'
				},
				{
					field: 'TCardNo',
					title: '代金卡号',
					hidden: true
				},
				{
					field: 'TName',
					width: 100,
					title: '姓名'
				},
				{
					field: 'TAmount',
					width: 120,
					title: '金额',
					align: 'right'
				},
				{
					field: 'TStatus',
					width: 60,
					title: '状态'
				},
				{
					field: 'TRemark',
					width: 180,
					title: '备注'
				},
				{
					field: 'TUser',
					width: 120,
					title: '操作员'
				},
				{
					field: 'TDate',
					width: 120,
					title: '日期'
				},
				{
					field: 'TTime',
					width: 120,
					title: '时间'
				},
				{
					field: 'TSex',
					width: 80,
					title: '性别'
				},
				{
					field: 'TAge',
					width: 80,
					title: '年龄'
				},
				{
					field: 'TTel',
					width: 120,
					title: '联系电话'
				},
				{
					field: 'TIDCard',
					width: 200,
					title: '证件号'
				}
				

			]
		];


	}
	if (Type == "C") {
		var columns = [
			[{
					field: 'TRowID',
					title: 'ID',
					hidden: true
				},
				{
					field: 'TRegNo',
					title: '登记号',
					hidden: true
				},
				{
					field: 'TModfyPassWord',
					width: 75,
					title: '修改密码',
					formatter: function (value, row, index) {
						return "<span style='cursor:pointer;padding:0 20px 0px 20px' class='icon-write-order' onclick='ModfyPassWord("+row.TRowID+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
					}
				},
				{
					field: 'TCardNo',
					width: 150,
					title: '代金卡号',
					formatter:function(value, row, index){	
							if(row.TRowID!=""){
								return "<a href='#'  class='grid-td-text' onclick=BModifyName("+row.TRowID+"\)>"+value+"</a>";
					
							}else{return value}
							
							
			
					}
				},
				{
					field: 'TName',
					width: 100,
					title: '姓名'
				},
				{
					field: 'TAmount',
					width: 150,
					title: '金额',
					align: 'right'
				},
				{
					field: 'TStatus',
					width: 60,
					title: '状态'
				},
				{
					field: 'TRemark',
					width: 200,
					title: '备注'
				},
				{
					field: 'TUser',
					width: 120,
					title: '操作员'
				},
				{
					field: 'TDate',
					width: 120,
					title: '日期'
				},
				{
					field: 'TTime',
					width: 120,
					title: '时间'
				},
				{
					field: 'TSex',
					width: 80,
					title: '性别'
				},
				{
					field: 'TAge',
					title: '年龄',
					hidden: true
				},
				{
					field: 'TTel',
					width: 120,
					title: '联系电话'
				},
				{
					field: 'TIDCard',
					width: 200,
					title: '证件号'
				},
				{
					field: 'TEndLineDate',
					width: 120,
					title: '截止日期'
				},
				{
					field: 'TRebate',
					width: 80,
					title: '折扣系数'
				},
				

			]
		];
	}

	$HUI.datagrid("#AdvancePaymentGrid", {
		url: $URL,
		fit: true,
		border: false,
		striped: true,
		fitColumns: false,
		autoRowHeight: false,
		rownumbers: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 100, 200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams: {
			ClassName: "web.DHCPE.APQuery",
			QueryName: "SearchAdvancePaymentNew",
			RegNo: $("#RegNo").val(),
			Name: $("#Name").val(),
			Status: $("#Status").combobox('getValue'),
			BeginDate: $("#BeginDate").datebox('getValue'),
			EndDate: $("#EndDate").datebox('getValue'),
			CardType: $("#TJCardType").combobox('getValue'),
			HospID: HospID

		},
		columns: columns,
	})



}



function CardNo_Change() {
	var myCardNo = $("#CardNo").val();
	if (myCardNo == "") {
		$.messager.alert("提示", "卡号为空", "info");
		return;
	}
	var myrtn = DHCACC_GetAccInfo("", myCardNo, "", "", CardNoKeyDownCallBack);
	return false;

}
//读卡
function ReadCardClickHandle() {
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}

function CardNoKeyDownCallBack(myrtn) {
	//alert(myrtn)
	var CardNo = $("#CardNo").val();
	var CardTypeNew = $("#CardTypeNew").val();
	$(".textbox").val('');
	$("#CardTypeNew").val(CardTypeNew);
	var myary = myrtn.split("^");
	var rtn = myary[0];
	if ((rtn == "0") || (rtn == "-201")) {
		var PatientID = myary[4];
		var PatientNo = myary[5];
		var CardNo = myary[1];
		$("#CardTypeRowID").val(myary[8]);
		$("#CardNo").focus().val(CardNo);
		$("#RegNo").val(PatientNo);
		BFind_click();
	} else if (rtn == "-200") {
		$.messager.popover({
			msg: "卡无效!",
			type: "info"
		});
		$("#CardNo").focus().val(CardNo);
		/*$.messager.alert("提示","卡无效!","info",function(){
			$("#CardNo").val(CardNo).focus();
		});
		*/

		return false;
	}
}

//清屏
function BClear_click() {
	$("#RegNo,#Name,#CardTypeNew,#CardNo").val("");
	$(".hisui-combobox").combobox('setValue', "");
	$("#BReadCard").linkbutton('enable');
	//默认时间
	Initdate();
	//默认体检卡类型为"预缴金"
	$("#TJCardType").combobox('setValue', "R");
	CardType_change()
	BFind_click();

}


var columns = [
	[{
			field: 'TRowID',
			title: 'ID',
			hidden: true
		},
		{
			field: 'TRegNo',
			width: '150',
			title: '登记号'
		},
		{
			field: 'TCardNo',
			title: '代金卡号',
			hidden: true
		},
		{
			field: 'TName',
			width: '100',
			title: '姓名'
		},
		{
			field: 'TAmount',
			width: '150',
			title: '金额',
			align: 'right'
		},
		{
			field: 'TStatus',
			width: '60',
			title: '状态'
		},
		{
			field: 'TRemark',
			width: '200',
			title: '备注'
		},
		{
			field: 'TUser',
			width: '120',
			title: '操作员'
		},
		{
			field: 'TDate',
			width: '120',
			title: '日期'
		},
		{
			field: 'TTime',
			width: '120',
			title: '时间'
		},
		{
			field: 'TSex',
			width: '80',
			title: '性别'
		},
		{
			field: 'TAge',
			width: '80',
			title: '年龄'
		},
		{
			field: 'TTel',
			width: '120',
			title: '联系电话'
		},
		{
			field: 'TIDCard',
			width: '200',
			title: '证件号'
		}
		

	]
];

function InitAdvancePaymentGrid() {
	$HUI.datagrid("#AdvancePaymentGrid", {
		url: $URL,
		fit: true,
		border: false,
		striped: true,
		fitColumns: false,
		autoRowHeight: false,
		rownumbers: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 100, 200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams: {
			ClassName: "web.DHCPE.APQuery",
			QueryName: "SearchAdvancePaymentNew",
			BeginDate: $("#BeginDate").datebox('getValue'),
			EndDate: $("#EndDate").datebox('getValue'),
			CardType: "R",
			HospID: session['LOGON.HOSPID']

		},
		columns: columns,
		onSelect: function (rowIndex, rowData) {

		}

	})
}

function InitCombobox() {

	//体检卡类型
	var TJTypeObj = $HUI.combobox("#TJCardType", {
		valueField: 'id',
		textField: 'text',
		panelHeight: '70',
		data: [{
				id: 'R',
				text:$g('预缴金')
			},
			{
				id: 'C',
				text:$g('代金卡')
			},

		]

	});

	//状态
	var StatusObj = $HUI.combobox("#Status", {
		valueField: 'id',
		textField: 'text',
		panelHeight: '140',
		data: [{
				id: 'N',
				text: $g('正常')
			},
			{
				id: 'A',
				text: $g('作废')
			},
			{
				id: 'L',
				text: $g('挂失')
			},
			{
				id: 'F',
				text: $g('冻结')
			},


		]

	});

	//体检卡类型
	var ATJTypeObj = $HUI.combobox("#ATJCardType", {
		valueField: 'id',
		textField: 'text',
		panelHeight: '70',
		data: [{
				id: 'R',
				text: $g('预缴金')
			},
			{
				id: 'C',
				text: $g('代金卡')
			},

		]

	});

	//状态
	var AStatusObj = $HUI.combobox("#AStatus", {
		valueField: 'id',
		textField: 'text',
		panelHeight: '140',
		data: [{
				id: 'N',
				text: $g('正常')
			},
			{
				id: 'A',
				text: $g('作废')
			},
			{
				id: 'L',
				text: $g('挂失')
			},
			{
				id: 'F',
				text: $g('冻结')
			},


		]

	});



	// 支付方式	
	var RPObj = $HUI.combobox("#PayMode", {
		url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindTJCardPayMode&ResultSetType=array&LocID=" + session['LOGON.CTLOCID'],
		valueField: 'id',
		textField: 'text',
		panelHeight: '140',
	})

}


//设置默认时间为当天
function Initdate() {
	var today = getDefStDate(0);
	$("#BeginDate").datebox('setValue', today);
	$("#EndDate").datebox('setValue', today);
}

//验证是否为浮点数
function IsFloat(Value) {

	var reg;
	if ("" == $.trim(Value)) {
		return true;
	} else {
		Value = Value.toString();
	}
	reg = /^((\d+\.\d*[1-9]\d*)|(\d*[1-9]\d*\.\d+)|(\d*[1-9]\d*))$/
	//reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("." == Value.charAt(0)) {
		Value = "0" + Value;
	}

	var r = Value.match(reg);
	if (null == r) {
		return false;
	} else {
		return true;
	}

}

function ModfyPassWord(rowid) {
	var PassWordFlag = tkMakeServerCall("web.DHCPE.AdvancePayment", "GetPassWordFlag", session['LOGON.CTLOCID']);
	if (PassWordFlag == "1") {
		var passWord = tkMakeServerCall("web.DHCPE.AdvancePayment", "GetCardPassWordByID", rowid);
		var btns = $.messager.prompt("提示", "请输入原密码:", function (r) {
			if (r) {
				if (r == passWord) {
					var btnsnew = $.messager.prompt("提示", "请输入新密码:", function (r) {
						if (r) {
							var NewPassWord = r;
							var btnsagin = $.messager.prompt("提示", "请再次输入密码:", function (r) {
								if (r) {
									if (r == NewPassWord) {
										var ret = tkMakeServerCall("web.DHCPE.AdvancePayment", "SaveCardPassWordByID", rowid, r);
										$.messager.popover({
											msg: "修改成功",
											type: 'info'
										});
										return false;
									} else {
										$.messager.alert("提示", "密码错误", "info");
										return false;
									}
								} else {
									if (r != undefined) {
										$.messager.popover({
											msg: '请输入有效密码！',
											type: 'info'
										});
										return false;
									}
								}
							}).children("div.messager-button");
							btnsagin.children("a:eq(0)").addClass('green');

						} else {
							if (r != undefined) {
								$.messager.popover({
									msg: '请输入有效密码！',
									type: 'info'
								});
								return false;
							}
						}
					}).children("div.messager-button");
					btnsnew.children("a:eq(0)").addClass('green');

				} else {
					$.messager.alert("提示", "密码错误", "info");
					//$.messager.popover({ msg: "密码错误", type: 'info' });
					return false;
				}
			} else {
				if (r != undefined) {
					$.messager.popover({
						msg: '请输入有效密码！',
						type: 'info'
					});
					return false;
				}
			}
		}).children("div.messager-button");
		btns.children("a:eq(0)").addClass('green');
	} else {
		$.messager.popover({
			msg: "无需修改密码",
			type: 'info'
		});
		return false;
	}
}

function isMoveTel(telephone){
    
	if (telephone=="") return true; 
    var teleReg1 = /^((0\d{2,3})-)(\d{7,8})$/;
    var teleReg2 = /^((0\d{2,3}))(\d{7,8})$/; 
    var mobileReg =/^1[3|4|5|6|7|8|9][0-9]{9}$/;
    if (!teleReg1.test(telephone)&& !teleReg2.test(telephone) && !mobileReg.test(telephone)){ 
        return false; 
    }else{ 
        return true; 
    } 

}
//基本信息修改
function BModifyName(TRowID)
{
	var lnk="dhcpeadvancepaymentreplace.hisui.csp"+"?APRowID="+TRowID;
	 websys_lu(lnk,false,'width=870,height=700,hisui=true,title=基本信息修改')

}