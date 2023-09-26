/// DHCBillSkipInvoice.js

var m_Guser = session['LOGON.USERID'];
var m_Hospital = session['LOGON.HOSPID'];
var m_CurInvNo = '';
var m_EndInvNo = '';
var m_Title = '';
var m_AbortEndInvNo = '';

function BodyLoadHandler() {
	var Determineobj = websys_$("Determine");
	if (Determineobj) {
		Determineobj.onclick = Determine_click;
	}
	var cancelobj = websys_$("Cancel");
	if (cancelobj) {
		cancelobj.onclick = Cancel_click;
	}
	var obj = websys_$("AbortNum");
	if (obj) {
		obj.onkeypress = AbortNum_KeyPress;
		obj.onkeyup = AbortNum_OnKeyUp;
	}
	SetItemReadOnly("invno", true);
	SetItemReadOnly("StartInvNO", true);
	SetItemReadOnly("AbortEndInvNo", true);
	SetItemReadOnly("INVLeftNum", true);
	GetReceiptNo();
	websys_setfocus("AbortNum");
}

function Determine_click() {
	var GroupDR = session['LOGON.GROUPID'];
	var currentInsType = websys_$V("CurrentInsType");
	//zhangli  ����Ʊ������ 2017.7.28
	var receiptType = websys_$V("receiptType");
	if (receiptType == "") {
		alert('Ʊ�����Ͳ���Ϊ��!');
		return false;
	}
	var abortNum = websys_$V("AbortNum");
	if (abortNum == "") {
		alert(t['06']);
		websys_setfocus('AbortNum');
		return false;
	}
	var maxNum = websys_$V("INVLeftNum");
	if (parseInt(abortNum, 10) > parseInt(maxNum, 10)) {
		alert(t['07']);
		return false;
	}
	if (parseInt(m_AbortEndInvNo, 10) < parseInt(m_CurInvNo, 10)) {
		alert(t['03']);
		//websys_setfocus('AbortEndInvNo');
		return false;
	}
	if (((parseInt(m_EndInvNo, 10) < parseInt(m_AbortEndInvNo, 10)))) {
		alert(t['04']);
		//websys_setfocus('AbortEndInvNo');
		return false;
	}
	var voidReason = websys_trim(websys_$V("voidRea"));
	if (voidReason == "") {
		alert("����ԭ����Ϊ��!");
		return;
	}
	var myExpStr = m_Guser + "^" + GroupDR + "^" + m_CurInvNo + "^" + voidReason + "^" + m_AbortEndInvNo + "^" + abortNum;
	myExpStr += "^" + m_EndInvNo + "^" + m_Title + "^" + currentInsType + "^" + receiptType + "^" + m_Hospital;
	var myrtn = window.confirm("�Ƿ�ȷ������?");
	if (!myrtn) {
		return myrtn;
	}
	var encmeth = DHCWebD_GetObjValue("getVoidInvEncrypt");
	var rtn = cspRunServerMethod(encmeth, myExpStr);
	if (rtn != 0) {
		alert("���Ϸ�Ʊʧ��, �������:" + rtn);
		return;
	} else {
		alert("���Ϸ�Ʊ�ɹ�.");
		if (receiptType == "IP") {
			window.opener.checkInv();     //+2018-02-23 modify by ZhYW(ֻ��Ҫˢ�·�Ʊ��,����Ҫ����ҳ��ˢ��)
		}else {
			window.opener.location.reload();
		}
	}
	window.close();
}

function Cancel_click() {
	window.close();
}

function checkno(inputtext) {
	var checktext = "1234567890";
	for (var i = 0; i < inputtext.length; i++) {
		var chr = inputtext.charAt(i);
		var indexnum = checktext.indexOf(chr);
		if (indexnum < 0) {
			return false;
		}
	}
	return true;
}

function AbortNum_KeyPress(e) {
	var keyCode = websys_getKey(e);
	if ((keyCode < 48) || (keyCode > 57)) {
		window.event.keyCode = 0;
		return websys_cancel();
	}
}

function AbortNum_OnKeyUp() {
	var num = websys_$V('AbortNum');
	if (num == "" || (parseInt(num, 10) == 0)) {
		return;
	}
	var ssno = "";
	var ssno1;
	var slen;
	var sslen;
	var index = m_CurInvNo.search(/\d/);      //+2018-02-12 ZhYW ȡ��һ���������ַ��������ڵ�λ��
	var snost = m_CurInvNo.substring(0, index);
	var snoend = m_CurInvNo.substring(index);
	if (checkno(num) && (m_CurInvNo != "") && checkno(snoend)) {
		ssno1 = parseInt(snoend, 10) + parseInt(num, 10) - 1;
		ssno = ssno1.toString();
		slen = snoend.length;
		sslen = ssno.length;
		for (i = slen; i > sslen; i--) {
			ssno = '0' + ssno;
		}
		m_AbortEndInvNo = snost + ssno;
		DHCWebD_SetObjValueB("AbortEndInvNo", m_Title + '[' + m_AbortEndInvNo + ']');
	}
}

function GetReceiptNo() {
	var receiptType = websys_$V("receiptType");
	var currentInsType = websys_$V('CurrentInsType');
	if (receiptType == 'OP') {
		//���﷢Ʊ
		var GroupDR = session['LOGON.GROUPID'];
		var myExpStr = GroupDR + "^" + "F" + + "^" + m_Hospital;
		var encmeth = DHCWebD_GetObjValue("GetOPReceipNo");
		var rtn = cspRunServerMethod(encmeth, "SetReceipNO", "", m_Guser, currentInsType, myExpStr);
	} else if (receiptType == 'OD') {
		//����Ԥ����
		var encmeth = DHCWebD_GetObjValue("GetPreReceipNo");
		var rtn = cspRunServerMethod(encmeth, "SetReceipNO", "", m_Guser, receiptType, m_Hospital);
	} else if (receiptType == 'IP') {
		//סԺ��Ʊ
		var encmeth = DHCWebD_GetObjValue("GetIPReceiptNo");
		var rtn = cspRunServerMethod(encmeth, "SetReceipNO", "", m_Guser, currentInsType, m_Hospital);
	}else {
		//סԺѺ��
		var encmeth = DHCWebD_GetObjValue("GetIDReceipNo");
		var rtn = cspRunServerMethod(encmeth, "SetReceipNO", "", m_Guser, receiptType, m_Hospital);
	}
}

function SetReceipNO(value) {
	var myAry = value.split("^");
	m_CurInvNo = myAry[0];
	m_EndInvNo = myAry[3];
	m_Title = myAry[4];
	DHCWebD_SetObjValueB("invno", m_Title + '[' + m_CurInvNo + ']');
	DHCWebD_SetObjValueB("StartInvNo", m_Title + '[' + m_CurInvNo + ']');
	DHCWebD_SetObjValueB("INVLeftNum", myAry[2]);
	DHCWebD_SetObjValueB("EndInvNo", m_Title + '[' + m_EndInvNo + ']');
}

///�����ı����ֻ������
function SetItemReadOnly(ItmName, ReadOnlyFlag) {
	var obj = websys_$(ItmName);
	if (obj) {
		obj.readOnly = ReadOnlyFlag;
	}
}

document.body.onload = BodyLoadHandler;