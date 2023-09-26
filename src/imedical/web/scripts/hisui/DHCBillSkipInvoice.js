/// DHCBillSkipInvoice.js

var GV = {
	USERID: session['LOGON.USERID'],
	HOSPID: session['LOGON.HOSPID'],
	CurInvNo: '',
	EndInvNo: '',
	Title: '',
	AbortEndInvNo: ''
};

$(function () {
	ini_LayOuStyle();
	
	$HUI.linkbutton("#Determine", {
		onClick: function () {
			determineClick();
		}
	});
	
	$HUI.validatebox("#voidRea", {
		prompt: ""
	});
	
	$HUI.numberbox("#AbortNum", {
		min: 1,
		isKeyupChange: true,
		fix: false
	});
	
	$("#AbortNum").keyup(function (e) {
		abortNumKeyup(e);
	});
	
	$("#AbortNum").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			if ($(e.target).val()) {
				focusById("voidRea");
			}
		}
	});
	
	GetReceiptNo();
	focusById("AbortNum");
});

function determineClick() {
	var bool = true;
	$(".validatebox-text").each(function() {
		if (!$(this).validatebox("isValid")) {
			bool = false;
			return false;
		}
	});
	if (!bool) {
		return;
	}
	var currentInsType = getValueById("CurrentInsType");
	var receiptType = getValueById("receiptType");
	if (!receiptType) {
		$.messager.popover({msg: '票据类型不能为空', type: 'info'});
		return false;
	}
	var abortNum = getValueById("AbortNum");
	if (!abortNum) {
		$.messager.popover({msg: '请输入作废张数', type: 'info'});
		focusById('AbortNum');
		return false;
	}
	if (parseInt(GV.AbortEndInvNo, 10) < parseInt(GV.CurInvNo, 10)) {
		$.messager.popover({msg: '结束号码不能小于开始号码', type: 'info'});
		return false;
	}
	if (((parseInt(GV.EndInvNo, 10) < parseInt(GV.AbortEndInvNo, 10)))) {
		$.messager.popover({msg: '结束号码不能大于最大号码', type: 'info'});
		return false;
	}
	var voidReason = $.trim(getValueById("voidRea"));
	if (!voidReason) {
		$.messager.popover({msg: '作废原因不能为空', type: 'info'});
		return;
	}
	var myExpStr = GV.USERID + "^" + getValueById("GroupID") + "^" + GV.CurInvNo + "^" + voidReason + "^" + GV.AbortEndInvNo + "^" + abortNum;
	myExpStr += "^" + GV.EndInvNo + "^" + GV.Title + "^" + currentInsType + "^" + receiptType + "^" + GV.HOSPID;
	$.messager.confirm("确认", "是否确认跳号",function (r) {
		if (r) {
			$.m({
				ClassName: "web.DHCBillSkipInvoice",
				MethodName: "SkipInvoice",
				expStr: myExpStr
			}, function(rtn) {
				if (rtn == "0") {
					$.messager.alert("提示", "作废成功", "success", function(){
						websys_showModal("close");
					});
				}else {
					$.messager.alert("提示", "作废失败：" + rtn, "error");
				}
			});
		}
	});
}

function abortNumKeyup(e) {
	if (!$(e.target).validatebox("isValid")) {
		return;
	}
	var num = getValueById('AbortNum') || 1;
 	if(!new RegExp('^[1-9]\\d*$').test(num)) {
		setValueById("AbortNum", "");
	 	return;
	}
	var ssno = "";
	var ssno1;
	var slen;
	var sslen;
	var index = GV.CurInvNo.search(/\d/);      //+2018-02-12 ZhYW 取第一个数字在字符串中所在的位置
	var snost = GV.CurInvNo.substring(0, index);
	var snoend = GV.CurInvNo.substring(index);
	if ((GV.CurInvNo != "") && new RegExp('^[0-9]\\d*$').test(snoend)) {
		ssno1 = parseInt(snoend, 10) + parseInt(num, 10) - 1;
		ssno = ssno1.toString();
		slen = snoend.length;
		sslen = ssno.length;
		for (i = slen; i > sslen; i--) {
			ssno = '0' + ssno;
		}
		GV.AbortEndInvNo = snost + ssno;
		setValueById("AbortEndInvNo", GV.Title + '[' + GV.AbortEndInvNo + ']');
	}
}

function GetReceiptNo() {
	var receiptType = getValueById("receiptType");
	var currentInsType = getValueById('CurrentInsType');
	switch(receiptType) {
	case 'OP':
		//门诊发票
		var myExpStr = getValueById("GroupID") + "^" + "F" + "^" + GV.HOSPID;
		$.m({
			ClassName: "web.DHCBillSkipInvoice",
			MethodName: "GetOPReceiptNo",
			userID: GV.USERID,
			insType: currentInsType,
			expStr: myExpStr
		}, function (rtn) {
			SetReceipNO(rtn);
		});
		break;
	case 'OD':
		//门诊预交金
		$.m({
			ClassName: "web.DHCBillSkipInvoice",
			MethodName: "GetAccPreReceiptNo",
			userID: GV.USERID,
			hospID: GV.HOSPID
		}, function (rtn) {
			SetReceipNO(rtn);
		});
		break;
	case 'IP':
		//住院发票
		$.m({
			ClassName: "web.DHCBillSkipInvoice",
			MethodName: "GetIPReceiptNo",
			userID: GV.USERID,
			insType: currentInsType,
			hospID: GV.HOSPID
		}, function (rtn) {
			SetReceipNO(rtn);
		});
		break;
	default:
		//住院押金
		$.m({
			ClassName: "web.DHCBillSkipInvoice",
			MethodName: "GetIPDepReceiptNo",
			userID: GV.USERID,
			depositType: receiptType,
			hospID: GV.HOSPID
		}, function (rtn) {
			SetReceipNO(rtn);
		});
	}
}

function SetReceipNO(value) {
	var myAry = value.split("^");
	GV.CurInvNo = myAry[0];
	var leftNum = myAry[2];
	GV.EndInvNo = myAry[3];
	GV.Title = myAry[4];
	setValueById("invno", GV.Title + '[' + GV.CurInvNo + ']');
	setValueById("StartInvNo", GV.Title + '[' + GV.CurInvNo + ']');
	setValueById("INVLeftNum", leftNum);
	setValueById("EndInvNo", GV.Title + '[' + GV.EndInvNo + ']');
	
	$("#AbortNum").numberbox("options").max = +leftNum;
}

function ini_LayOuStyle() {
	$('body').css("padding", "0px");
	$('table').css("padding", "0px");
	$('td').css("padding-top", "0px");
	$('td').css('padding', "0px");
	$('td').css('width', "55px");
	$('table').css("border-spacing", "0px 10px");
	$('label').css("margin-right", "10px");
	$('.CellData').parent().parent().parent().css("width", "520px");
	$("#invno, #StartInvNo, #AbortEndInvNo, #INVLeftNum").prop("disabled", true).css({"font-weight": "bold"});
}