/*!
 *@creator:yunhaibao
 *@createdate:2016-08-06
 *@description:ҩ����һЩĬ������
 *@others:
 */
var DhcphaGridTrHeight = 34;
var LastEditSel = ""; //���༭��
var JqGridCanEdit = true;
var DhcphaReadCardCommon_ops;
var OPKey_HotKey;
var OPKey_MainGrid = "";
var HospId = session['LOGON.HOSPID'];
var userAgent = navigator.userAgent; //��ȡ�����������
$(function () {
	var pathname = window.location.pathname;
	pathname = pathname.split("/csp/")[0];
	DHCPHA_CONSTANT.URL.PATH = pathname;
	DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL = pathname + "/csp/" + DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL;
	DHCPHA_CONSTANT.URL.COMMON_INPHA_URL = pathname + "/csp/" + DHCPHA_CONSTANT.URL.COMMON_INPHA_URL;
	DHCPHA_CONSTANT.URL.COMMON_PHA_URL = pathname + "/csp/" + DHCPHA_CONSTANT.URL.COMMON_PHA_URL;
	DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL = pathname + "/csp/" + DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL;
	$("input[type=checkbox][name!=swich]").dhcphaCheck(); //����checkbox
	$("input[type=text]").on("keypress", function (e) {
		if (window.event.keyCode == "13") {
			KeyDownListener();
		}
	});
	GetPhaHisCommonParmas();
});

// �������λس��Ƿ�̫��
function KeyDownListener() {
	var keydowndate = new Date();
	var keydowntime = keydowndate.getTime();
	if (DHCPHA_CONSTANT.VAR.LASTENTERTIME != "" && DHCPHA_CONSTANT.VAR.LASTENTERTIME != undefined) {
		var minustime = keydowntime - DHCPHA_CONSTANT.VAR.LASTENTERTIME;
		if (minustime < 600) {
			dhcphaMsgBox.alert($g("�س��ٶ�̫��!"));
		}
	}
	DHCPHA_CONSTANT.VAR.LASTENTERTIME = keydowntime;
}
// @description ��ʼ��������
// @params id
function InitSelectCardType(_options) {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + "?action=GetCardType&style=select2",
		minimumResultsForSearch: Infinity,
		width: "8em",
		allowClear: false
	};
	$(_options.id).dhcphaSelect(selectoption);
	$("_options.id").on("select2:select", function (event) {
		// alert(event)
	});
	// Ĭ�Ͽ�����
	$.ajax({
		type: "POST", // �ύ��ʽ post ����get
		url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + "?action=GetCardType&style=select2",
		data: "json",
		success: function (data) {
			// var jsondata=eval(data);  // ��������eval
			var jsondata = JSON.parse(data);
			var jsondatalen = jsondata.length;
			for (var i = 0; i < jsondatalen; i++) {
				var idata = jsondata[i];
				var idatadesc = idata.text;
				var idataid = idata.id;
				var idataidarr = idataid.split("^");
				var defaultflag = idataidarr[8];
				if (defaultflag == "Y") {
					var select2option = "<option value=" + "'" + idataid + "'" + "selected>" + idatadesc + "</option>";
					$(_options.id).append(select2option);
				}
			}
		},
		error: function () {
			dhcphaMsgBox.alert($g("��ȡĬ�Ͽ�����ʧ��!"));
		}
	});
}
//@description:��������
//@params:��������,�ص�����
//@csp need add:DHCWeb.OPCommonManageCard.JS
DhcphaReadCardCommon_CallBack = null; // ��Ӽ�¼�ص�
DhcphaReadCardCommon_ops = null;
function DhcphaReadCardCommon(_options, _fn) {
	if (_fn == undefined) {
		_fn = "";
		DhcphaReadCardCommon_CallBack = _fn;
	} else {
		DhcphaReadCardCommon_CallBack = _fn;
	}
	var txtcardno = _options.CardNoId;
	var txtpatno = _options.PatNoId;
	DhcphaReadCardCommon_ops = _options;
	var patCarNo = $("#" + txtcardno).val();
	var readRet;
	// �ص�
	if (patCarNo != "") {
		readRet = DHCACC_GetAccInfo("", patCarNo, "", "PatInfo", CardTypeCallBack);
	} else {
		readRet = DHCACC_GetAccInfo7(CardTypeCallBack);
	}

}

function CardTypeCallBack(rtn) {
	var readRet = rtn;
	if (readRet == false) {
		dhcphaMsgBox.alert($g("����Ч!"));
		return;
	}
	var txtcardno = DhcphaReadCardCommon_ops.CardNoId;
	var txtpatno = DhcphaReadCardCommon_ops.PatNoId;
	var txtcardtype = DhcphaReadCardCommon_ops.CardTypeId;
	var readRetArr = readRet.split("^");
	var readRtn = readRetArr[0];
	switch (readRtn) {
	case "0":
		//����Ч
		PatientID = readRetArr[4];
		PatientNo = readRetArr[5];
		CardNo = readRetArr[1];
		$("#" + txtcardno).val(CardNo);
		$("#" + txtpatno).val(PatientNo);
		$("#"+txtcardtype).val(readRetArr[8]);
		//$("#txt-patno").val(PatientNo);
		//$("#txt-cardno").val(CardNo);
		if (typeof DhcphaReadCardCommon_CallBack === 'function') {
			DhcphaReadCardCommon_CallBack();
		}
		break;
	case "-1":
		dhcphaMsgBox.alert($g("������������������뿨�ź����ԣ�"));
		break;
	case "-200":
		dhcphaMsgBox.alert($g("����Ч!"));
		break;
	case "-201":
		//�ֽ�
		PatientID = readRetArr[4];
		PatientNo = readRetArr[5];
		CardNo = readRetArr[1];
		$("#" + txtcardno).val(CardNo);
		$("#" + txtpatno).val(PatientNo);
		$("#"+txtcardtype).val(readRetArr[8]);
		//$("#txt-patno").val(PatientNo);
		//$("#txt-cardno").val(CardNo);
		if (typeof DhcphaReadCardCommon_CallBack === 'function') {
			DhcphaReadCardCommon_CallBack();
		}
		
		break;
	default:
	}
}

//@description ��ȡ����ҽ����Ϣ,������Ϣ��ָ��div
//@params ҽ��id
function AppendPatientOrdInfo(_options) {
	$.ajax({
		type: "POST", //�ύ��ʽ post ����get
		url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + "?action=GetPatientOrdInfo&orditem=" + _options.orditem,
		data: "json",
		success: function (data) {
			var retdata = JSON.parse(data)[0];
			var imageid = "";
			if (retdata.patsex == "Ů") {
				//��Ů����
				imageid = "icon-female.png";
			} else if (retdata.patsex == "��") {
				imageid = "icon-male.png";
			} else {
				imageid = "icon-unmale.png";
			}
			if ($("#patInfo")) {
				$("#patInfo").remove();
			}
			var patname = retdata.patname;
			var patordinfo = "";
			if (retdata.patage != "") {
				patordinfo = "<span>&nbsp;&nbsp;" + retdata.patage + "&nbsp;&nbsp;</span>|&nbsp;&nbsp;";
			}
			if (retdata.prescno != "") {
				patordinfo = patordinfo + "<span>" + retdata.prescno + "&nbsp;&nbsp;</span>|&nbsp;&nbsp;";
			}
			if (retdata.patweight != "") {
				patordinfo = patordinfo + "<span>" + retdata.patweight + "&nbsp;&nbsp;</span>|&nbsp;&nbsp;";
			}
			if (retdata.patbilltype != "") {
				patordinfo = patordinfo + "<span>" + retdata.patbilltype + "&nbsp;&nbsp;</span>|&nbsp;&nbsp;";
			}
			if (retdata.admlocdesc != "") {
				patordinfo = patordinfo + "<span>" + retdata.admlocdesc + "&nbsp;&nbsp;</span>|&nbsp;&nbsp;";
			}
			if (retdata.presctitle != "") {
				patordinfo = patordinfo + "<span>" + retdata.presctitle + "&nbsp;&nbsp;</span>|&nbsp;&nbsp;";
			}
			var pathtml = ' <div class="col-md-12" id="patInfo"><div class="col-md-1">' + '<a href="#" class="thumbnail" style="border:0px;height:20px;">' + "<img src=" + DHCPHA_CONSTANT.URL.PATH + "/scripts/pharmacy/images/" + imageid + ' style="border-radius:35px;height:50px;width:50px">' + "</a>" + "</div>" + ' <div class="col-md-11 col-md_style">' + ' <span style="font-size:17px">' + patname + "&nbsp;&nbsp;&nbsp;</span>" + patordinfo + " </div></div>";
			$(_options.id).append(pathtml);
		},
		error: function () {
			alert($g("��ȡ����ҽ����Ϣʧ��!"));
		}
	});
}

//@description ��ȡ���˻�����Ϣ,������Ϣ��ָ��div
//@params ҽ��id
function AppendPatientBasicInfo(_options) {
	var retdata = GetPatientBasicInfo(_options.input, _options.gettype);
	var imageid = "";
	if (retdata.patsex == "Ů") {
		//��Ů����
		imageid = "icon-female.png";
	} else if (retdata.patsex == "��") {
		imageid = "icon-male.png";
	} else {
		imageid = "icon-unmale.png";
	}
	if ($("#patInfo")) {
		$("#patInfo").remove();
	}
	var patname = retdata.patname;
	var patage = retdata.patage;
	if (patname == undefined) {
		return;
	}
	var pathtml = ' <div class="col-md-12" id="patInfo" style="padding-top:0.3em">' + ' <div style="float:right;padding-top:5px;padding-left:5px">' + patname + "</br>" + patage + "</div>" + '<div style="float:right">' + '<img src="' + DHCPHA_CONSTANT.URL.PATH + "/scripts/pharmacy/images/" + imageid + '" style="border-radius:35px;height:50px;width:50px">' + "</div>" + " </div>";
	$(_options.id).append(pathtml);
}

//@description ��ȡ���˻�����Ϣ
//@params ����/�ǼǺ� , ����(�ǼǺ�:patno/����:cardno)
function GetPatientBasicInfo(inputNo, noType) {
	var patinfo = tkMakeServerCall("web.DHCSTPharmacyCommon", "GetPatientBasicInfo", inputNo, noType);
	patinfo = JSON.parse(patinfo)[0];
	return patinfo;
}

//@description ��ȡhis��Ϣ�Ĺ�����������
//@params �ǼǺų���,���ų���
function GetPhaHisCommonParmas() {
	$.ajax({
		type: "POST", //�ύ��ʽ post ����get
		url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + "?action=GetPhaHisCommonParmas",
		data: "json",
		success: function (data) {
			var jsondata = JSON.parse(data); // data��Ҫ˫����
			var hisPatNoLen = jsondata[0].patNoLen;
			if (hisPatNoLen > 0) {
				DHCPHA_CONSTANT.DEFAULT.PATNOLEN = hisPatNoLen;
			}
		},
		error: function () {
			alert($g("��ȡ��������ʧ��!"));
		}
	});
}

//@description ���ֲ�0
//@input: no,length
function NumZeroPadding(inputNum, numLength) {
	if (inputNum == "") {
		return inputNum;
	}
	var inputNumLen = inputNum.length;
	if (inputNumLen > numLength) {
		//$.messager.alert('������ʾ',"�������");
		dhcphaMsgBox.alert($g("�������"));
		return "";
	}
	for (var i = 0; i < inputNumLen; i++) {
		var para = inputNum[i];
		if (isNaN(para) || para.trim() == "" || String(para).indexOf(".") > -1 || !(parseInt(inputNum) > 0)) {
			dhcphaMsgBox.alert($g("�������"));
			return "";
		}
	}
	for (var i = 1; i <= numLength - inputNumLen; i++) {
		inputNum = "0" + inputNum;
	}
	return inputNum;
}

//@description:jqGrid�ɱ༭�����ݵ���ɫ
function addTextCellAttr(rowId, val, rawObject, cm, rdata) {
	if (rawObject.planId == null) {
		return "style='color:black;font-weight:bold;'";
	}
}

//@description:�жϱ�������Ƿ�Ϊ��
//@return: true:��
function DhcphaGridIsEmpty(_grid_id, _grid_type) {
	if (_grid_type == undefined) {
		_grid_type = "";
	}
	if (_grid_type == "") {
		//Ĭ��jqGrid
		var grid_records = $(_grid_id).getGridParam("records");
		if (grid_records == 0) {
			dhcphaMsgBox.alert($g("��ǰ������������ϸ����!"));
			return true;
		}
		return false;
	}
}

//@description:�жϱ�������Ƿ�ѡ��
//@return: true:ѡ��
function DhcphaGridIsSelect(_grid_id, _grid_type) {
	if (_grid_type == undefined) {
		_grid_type = "";
	}
	if (_grid_type == "") {
		//Ĭ��jqGrid
		var grid_select = $(_grid_id).jqGrid("getGridParam", "selrow");
		if (grid_select == "" || grid_select == null) {
			dhcphaMsgBox.alert($g("����ѡ������,�ٽ��в���!"));
			return false;
		}
		return true;
	}
}

//@description:jqGrid�ɱ༭�����ݵ���ɫ
function addTextCellAttr(rowId, val, rawObject, cm, rdata) {
	if (rawObject.planId == null) {
		return "style='color:black;font-weight:bold;'";
	}
}

//@description:��ʼ��inci����
function InitLocInci(_options) {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + "?action=GetLocInciDsByAlias&style=select2&locId=" + _options.locid,
		placeholder: $g("ҩƷ����")+"...",
		allowClear: true,
		minimumInputLength: 2,
		width: 250,
		dropdownAutoWidth: true
	};
	if (_options.width != undefined) {
		selectoption.width = _options.width;
	}
	$(_options.id).dhcphaSelect(selectoption);
}

//@description:setcookie
function setCookie(name, value) {
	var oDate = new Date();
	oDate.setDate(oDate.getDate());
	document.cookie = name + "=" + encodeURIComponent(value) + ";expires=" + oDate;
}

//@description:getcookie
function getCookie(name) {
	var cookiearr = document.cookie.split("; ");
	var i = 0;
	for (i = 0; i < cookiearr.length; i++) {
		var cookiearri = cookiearr[i].split("=");
		if (cookiearri[0] == name) {
			var getCookieValue = decodeURIComponent(cookiearri[1]);
			return getCookieValue;
		}
	}
	return "";
}

//@description:removecookie
function removeCookie(name) {
	setCookie(name, "1", -1);
}

//@description:ת������Ϊyyyy-MM-dd��ʽ
//@params: (t-1)
function FormatDateT(input) {
	input = input.trim();
	input = input.toUpperCase();
	var formatdate = tkMakeServerCall("web.DHCSTKUTIL", "GetDate", "", "", input);
	return formatdate;
}

//@description:ת������Ϊyyyy-MM-dd��ʽ
//@params: (t-1)
function FormatDateYMD(input) {
	input = input.trim();
	input = input.toUpperCase();
	var formatdate = tkMakeServerCall("web.DHCSTKUTIL", "GetYMDDate", "", "", input);
	return formatdate;
}

//@description:�ж����������
function BrowserType() {
	var userAgent = navigator.userAgent; //ȡ���������userAgent�ַ���
}

//@description:��ȡ��������mac��ַ,IE
function GetComputerValidMac() {
	if ((typeof isIECore != "undefined") && (isIECore == false)) {
		if ("undefined" != typeof EnableLocalWeb && EnableLocalWeb == 1) {
			if (getClientIP) {
				var ipData = getClientIP();
				if (ipData != "") {
					return ipData.split("^")[2];
				}
			}
		}
	}
	var macAddr = "";
	try {
		var locator = new ActiveXObject("WbemScripting.SWbemLocator");
		var service = locator.ConnectServer("."); //���ӱ���������
		var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration Where IPEnabled =True"); //��ѯʹ��SQL��׼
		var e = new Enumerator(properties);
		var p = e.item();
		for (; !e.atEnd(); e.moveNext()) {
			var p = e.item();
			if (p.MACAddress == null) {
				continue;
			}
			macAddr = p.MACAddress;
			if (macAddr)
				break;
		}
	} catch(e){
		return macAddr;
	}
	return macAddr;
}

//�ж��������Ƿ����Ԫ��
Array.prototype.contains = function (obj) {
	var i = this.length;
	while (i--) {
		if (this[i] === obj) {
			return true;
		}
	}
	return false;
};

///ǰ̨daterange��ʽת��,������̨ͳһ��"-"�ָ�
function FormatDateRangePicker(inputValue) {
	if (inputValue == "") {
		return inputValue;
	}
	if (!inputValue) {
		return inputValue;
	}
	inputValue = inputValue.replace("��", "-");
	return inputValue;
}

///��ѯ����ĳ�������ı��߶�
///contentcnt:panel div_content ����
function GridCanUseHeight(contentcnt) {
	var height1 = $("[class='container-fluid dhcpha-condition-container']").height();
	var height2 = parseFloat($("[class='panel div_content']").css("margin-top"));
	var height3 = parseFloat($("[class='panel div_content']").css("margin-bottom"));
	var height4 = parseFloat($("[class='panel-heading']").outerHeight());
	var contenth = height1 + height2 + height3 + height4 + 20;
	var tableheight = $(window).height() - contenth * contentcnt;
	return tableheight;
}

///��ѯ�����߶�,��ѯ������div����
function QueryConditionHeight() {
	var conditionheight = $("#dhcpha-query-condition").height() + $("#dhcpha-query-condition").offset().top;
	return conditionheight;
}

///�����panelheading�߶�
function PanelHeadingHeight(num) {
	if (num == undefined) {
		num = 1;
	}
	var height1 = parseFloat($("[class='panel div_content']").css("margin-top"));
	var height2 = parseFloat($("[class='panel div_content']").css("margin-bottom"));
	var height3 = parseFloat($("[class='panel-heading']").outerHeight());
	var panelheight = (height1 + height2 + height3) * num;
	return panelheight;
}

///���Ϊjqgridʱ������������ø߶�,tnum��ͷҳ�������ܸ���
function DhcphaJqGridHeight(pnum, tnum) {
	if (pnum == undefined) {
		pnum = 1;
	}
	var dgheight = $(window).height() - PanelHeadingHeight(pnum) - QueryConditionHeight() - tnum * DhcphaGridTrHeight;
	if (tnum == 1) {
		dgheight = dgheight - 9;
	}
	return dgheight;
}

/// �޸�csp·��Ϊ����·��
function ChangeCspPathToAll(pathcsp) {
	var pathname = window.location.pathname;
	pathname = pathname.split("/csp/")[0];
	pathcsp = pathname + "/csp/" + pathcsp;
	return pathcsp;
}

//��λ�ķ���
//��һ��Ŀ����
//�ڶ�������λ��
//������������Ԫ��
function coverPosition(par1, par2, par3) {
	if (par1.length < par2) {
		for (i = 1; i < par2; i++) {
			par1 = par3 + "" + par1;
		}
	}
	return par1;
}

function DhcCardPayCommon(_ops, _fn) {
	if (_fn == undefined) {
		_fn = "";
	}
	var txtcardtype= _ops.CardTypeId;
	var txtcardno = _ops.CardNoId;
	var txtpatno = _ops.PatNoId;
	var StDate = _ops.StDate;
	var EndDate = _ops.EndDate;
	
	var CardNo = $("#" + txtcardno).val();
	var PatNo = $("#" + txtpatno).val();
	var PatInfo = tkMakeServerCall("PHA.OP.COM.Method", "GetPatInfoByNo", PatNo, session["LOGON.CTLOCID"]);
	if (PatInfo == "{}") {
		dhcphaMsgBox.alert($g("�û����޶�Ӧ����Ϣ,���ܽ���Ԥ�۷�!"));
		return false;
	}
	var jsonPatInfo = JSON.parse(PatInfo);
	var AdmStr = jsonPatInfo.admDrStr;
	var lastAdm = jsonPatInfo.lastAdm;
	var Papmi = jsonPatInfo.papmiDr;
	var CardType = jsonPatInfo.CardType;
	var CardTypeConfig = jsonPatInfo.CardTypeConfig;
	var guser = session["LOGON.USERID"];
	var groupDR = session["LOGON.GROUPID"];
	var locDR = session["LOGON.CTLOCID"];
	var hospDR = session["LOGON.HOSPID"];
	
	//$("#CardBillCardTypeValue").val(CardType + "^" + CardTypeConfig);
	var mode = tkMakeServerCall("PHA.FACE.IN.Com", "GetCheckOutMode", groupDR + "^" + locDR + "^" + hospDR);
	if (mode == 1) {
		if (CardNo == "") {
			dhcphaMsgBox.alert($g("�û����޶�Ӧ����Ϣ,���ܽ���Ԥ�۷�!"));
			return false;
		}
		dhcphaMsgBox.confirm($g("�Ƿ�ȷ�Ͽ۷�? ���[ȷ��]���ɣ����[ȡ��]�˳�"), function (r) {
			if (r == true) {
				var insType = "";
				var oeoriIDStr = ""; //tkMakeServerCall("PHA.OP.COM.Method", "GetPatOrdInfo",Papmi,StDate,EndDate,Recloc);;
				var cardTypeRowId =$("#" + txtcardtype).val() || "";  
				$("#CardBillCardTypeValue").val(tkMakeServerCall("PHA.FACE.IN.Com", "GetCardTypeInfo", cardTypeRowId));
				var rtn = checkOut(CardNo, Papmi, lastAdm, insType, oeoriIDStr, guser, groupDR, locDR, hospDR);
				if (_fn != "") {
					_fn();
				}
			} else {
				return;
			}
		});
		return;
	} else {
		var CardTypeRowId =$("#" + txtcardtype).val();  
		var url = "dhcbill.opbill.charge.main.csp?ReloadFlag=3&CardNo=" + CardNo + "&SelectAdmRowId=" + AdmStr + "&SelectPatRowId=" + Papmi + "&CardTypeRowId=" + CardTypeRowId;
		websys_showModal({
			url: url,
			title: "Ԥ�۷�",
			iconCls: "icon-w-inv",
			width: "97%",
			height: "85%",
			onClose: function () {
				if (_fn != "") {
					_fn();
				}
				var ret = tkMakeServerCall("PHA.FACE.IN.Com", "UnLockOPAdm", AdmStr, "User.OEOrder");
				if (top) {
					top.$(this).window("destroy");
				}
			}
		});
	}
}
function GetCustomVal(custom) {
	var obj_PrescBillTypeID = document.getElementById(custom);
	if (obj_PrescBillTypeID) {
		return obj_PrescBillTypeID.value;
	} else {
		return "";
	}
}

/**
 * ת������,��Ҫ��jqgrid��������keyup��ʱ���ж�,Ŀǰû����������,���ֱ��ת��
 * @param {String} str
 */
function ParseToNum(str) {
	str = str.toString();
	if (str == "") {
		return "";
	}
	var dpos = str.indexOf(".");
	if (dpos >= 0) {
		var num1 = str.substring(0, dpos);
		num1 = num1.replace(/[^0-9]/g, "") * 1; // �滻������Ϊ��
		var num2 = str.substring(dpos + 1, str.length);
		num2 = num2.replace(/[^0-9]/g, "");
		var num = num1 + "." + num2;
	} else {
		var num = str.replace(/[^0-9]/g, "") * 1;
	}
	return num;
}

/**
 * ������˾ܾ�ԭ��ѡ��,����Load csp,�����ϵͳ�Ѿ����ع�,��֮�󲻻��ظ�����
 */
function ShowPHAPRASelReason(paramOpts, callBack, origOpts) {
	var reasonURL = ChangeCspPathToAll("pha.pra.v1.selreason.csp");
	var wayId = paramOpts.wayId || "";
	var oeori = paramOpts.oeori || "";
	var prescNo = paramOpts.prescNo || "";
	var selType = paramOpts.selType || "";
	if (top.$("#PHA_PRA_V1_SELREASON").html() != undefined) {
		top.$("#PHA_PRA_V1_SELREASON").panel("options").onBeforeClose = DoReturn;
		top.$("#PHA_PRA_V1_SELREASON").window("open");
		// ����������¼���,�������޸�����
		var reasonFrm;
		var frms = top.frames;
		for (var i = frms.length - 1; i >= 0; i--) {
			if (frms[i].TRELOADPAGE == "pha.pra.v1.selreason.csp") {
				reasonFrm = frms[i];
				break;
			}
		}
		reasonFrm.PRA_WAYID = wayId;
		reasonFrm.PRA_OEORI = oeori;
		reasonFrm.PRA_PRESCNO = prescNo;
		reasonFrm.PRA_SELTYPE = selType;
		reasonFrm.ReLoadPRASelReason();
		return;
	}
	websys_showModal({
		id: "PHA_PRA_V1_SELREASON",
		url: reasonURL + "?oeori=" + oeori + "&wayId=" + wayId + "&selType=" + selType + "&prescNo=" + prescNo,
		title: "�ܾ�ԭ��ѡ����¼��",
		iconCls: "icon-w-list",
		width: "80%",
		height: "80%",
		closable: false,
		onClose: function () {}, // ����ȥ��,����Ĭ�����ٴ���
		onBeforeClose: DoReturn
	});
	function DoReturn() {
		var reasonStr = "";
		if (top) {
			var reasonFrm;
			var frms = top.frames;
			for (var i = frms.length - 1; i >= 0; i--) {
				if (frms[i].TRELOADPAGE == "pha.pra.v1.selreason.csp") {
					reasonFrm = frms[i];
					break;
				}
			}
			if (reasonFrm != "") {
				var reasonStr = reasonFrm.PRA_SELREASON_RET;
			}
		}
		callBack(reasonStr, origOpts);
	}
}

/**
 *	��ҩ������Ϣѡ���,����Load csp,�����ϵͳ�Ѿ����ع�,��֮�󲻻��ظ�����
 *	MaYuqiang 20211125
 */
function ShowDeliveryDiag(paramOpts, callBack) {
	var deliveryURL = ChangeCspPathToAll("pha.herb.v2.delivery.csp");
	var prescNo = paramOpts.prescNo || "";
	var prescForm = paramOpts.prescForm || "";
	var papmi = paramOpts.papmi || "";
	if (top.$("#PHA_HERB_V2_DELIVERY").html() != undefined) {
		top.$("#PHA_HERB_V2_DELIVERY").panel("options").onBeforeClose = DoHerbRet;
		top.$("#PHA_HERB_V2_DELIVERY").window("open");
		// ����������¼���,�������޸�����
		var deliveryFrm;
		var frms = top.frames;
		for (var i = frms.length - 1; i >= 0; i--) {
			if (frms[i].TRELOADPAGE == "pha.herb.v2.delivery.csp") {
				deliveryFrm = frms[i];
				break;
			}
		}
		deliveryFrm.DY_PRESCNO = prescNo;
		deliveryFrm.DY_PRESCFORM = prescForm;
		deliveryFrm.DY_PAPMI = papmi;
		deliveryFrm.ReLoadDeliveryWin();
		return;
	}
	websys_showModal({
		id: "PHA_HERB_V2_DELIVERY",
		url: deliveryURL + "?gPrescNo=" + prescNo + "&gPrescForm=" + prescForm+ "&gPapmi=" + papmi,
		title: "������Ϣ",
		iconCls: "icon-w-list",
		width: "55%",
		height: "90%",
		closable: false,
		onClose: function () {}, // ����ȥ��,����Ĭ�����ٴ���
		onBeforeClose: DoHerbRet
	});
	function DoHerbRet() {
		var deliveryStr = "";
		if (top) {
			var deliveryFrm;
			var frms = top.frames;
			for (var i = frms.length - 1; i >= 0; i--) {
				if (frms[i].TRELOADPAGE == "pha.herb.v2.delivery.csp") {
					deliveryFrm = frms[i];
					break;
				}
			}
			if (deliveryFrm != "") {
				var deliveryStr = deliveryFrm.HERB_DELIVERY_RET;
			}
		}
		callBack(deliveryStr);
		
	}
}

function HotKeyInit(domCode, gridId) {
	var propStr = tkMakeServerCall("PHA.OP.COM.Method", "GetHotKey", domCode, session["LOGON.GROUPID"], session["LOGON.CTLOCID"], session["LOGON.USERID"]);
	if (propStr != "{}") {
		var propJson = JSON.parse(propStr);
		var OPKey_View = propJson.propData;
		OPKey_HotKey = propJson.propKeyData;
		for (var item in OPKey_View) {
			var doitmid = OPKey_View[item];
			if (!$("#" + doitmid)) {
				continue;
			}
			var domDescOld = $("#" + doitmid)[0].textContent;
			var domDescNew = $("#" + doitmid)[0].textContent + "[" + item + "]";
			var htmlStr = $("#" + doitmid).html();
			$("#" + doitmid)[0].innerHTML = htmlStr.replace(domDescOld, domDescNew);
		}
	}
	OPKey_MainGrid = gridId;
	if (OPKey_MainGrid != "" && $("#" + OPKey_MainGrid)) {
		$("#" + OPKey_MainGrid).focus();
	}
	$(document).keydown(function (event) {
		if (event.keyCode == "40") {
			//���������ӿ�ݼ������¼�ѡ��ҩ�б�����
			if (OPKey_MainGrid == undefined || OPKey_MainGrid == "" || !$("#" + OPKey_MainGrid)) {
				return;
			}
			var selectid = $("#" + OPKey_MainGrid).jqGrid("getGridParam", "selrow");
			var nextSelectid = parseInt(selectid) + 1;

			var rowDatas = $("#" + OPKey_MainGrid).jqGrid("getRowData");
			if (nextSelectid <= rowDatas.length) {
				$("#" + OPKey_MainGrid).setSelection(nextSelectid);
			}
		} else if (event.keyCode == "38") {
			//���������ӿ�ݼ������ϼ�ѡ��ҩ�б�����
			if (OPKey_MainGrid == undefined || OPKey_MainGrid == "" || !$("#" + OPKey_MainGrid)) {
				return;
			}
			var selectid = $("#" + OPKey_MainGrid).jqGrid("getGridParam", "selrow");
			var prveSelectid = parseInt(selectid) - 1;
			if (prveSelectid > 0) {
				$("#" + OPKey_MainGrid).setSelection(prveSelectid);
			}
		} else {
			if (OPKey_HotKey[event.keyCode] != undefined) {
				var domId = OPKey_HotKey[event.keyCode];
				if ($(domId)) {
					$("#" + domId).click();
				}
			}
		}
	});
}
/**
 * BootStrapǶ��HISUIҩѧ����
 */
function ShowPHAINPhcCat(paramOpts, callBack) {
	var phccatURL = ChangeCspPathToAll("pha.in.v3.ux.phccat.csp");
	var uxId = "PHA_IN_V3_UX_PHCCAT"
		if (top.$("#" + uxId).html() != undefined) {
			top.$("#" + uxId).panel("options").onBeforeClose = DoReturn;
			top.$("#" + uxId).window("open");
			// ����������¼���,�������޸�����
			var returnFrm;
			var frms = top.frames;
			for (var i = frms.length - 1; i >= 0; i--) {
				if (frms[i].TRELOADPAGE == "pha.in.v3.ux.phccat.csp") {
					returnFrm = frms[i];
					break;
				}
			}
			returnFrm.ReLoadUXPhcCat();
			return;
		}
		websys_showModal({
		id: uxId,
		url: phccatURL,
		title: "ҩѧ����",
		iconCls: "icon-w-list",
		width: "600",
		height: "500",
		closable: true,
		onClose: function () {}, // ����ȥ��,����Ĭ�����ٴ���
		onBeforeClose: DoReturn
	});
	function DoReturn() {
		var phccatObj = {};
		if (top) {
			var returnFrm;
			var frms = top.frames;
			for (var i = frms.length - 1; i >= 0; i--) {
				if (frms[i].TRELOADPAGE == "pha.in.v3.ux.phccat.csp") {
					returnFrm = frms[i];
					break;
				}
			}
			if (returnFrm != "") {
				phccat = returnFrm.PHA_IN_V1_UX_PHCCAT_RET;
			}
		}
		callBack(phccat);
	}
}
function ShowPatInfoWindow(_opts) {
	var admInfoURL = ChangeCspPathToAll("pha.op.v4.patinfo.csp");
	var uxId = "PHA_AdmDetail";
	var ordItmId = _opts.ordItmId || "";
	var admId = _opts.admId || "";
	var prescNo = _opts.prescNo || "";
	if (top.$("#" + uxId).html() != undefined) {
		top.$("#" + uxId).window("open");
		// ����������¼���,�������޸�����
		var returnFrm;
		var frms = top.frames;
		for (var i = frms.length - 1; i >= 0; i--) {
			if (frms[i].TRELOADPAGE == "pha.op.v4.patinfo.csp") {
				returnFrm = frms[i];
				break;
			}
		}
		returnFrm.PHA_Oeori = ordItmId;
		returnFrm.PHA_PrescNo = prescNo;
		returnFrm.PHA_AdmId = admId;
		returnFrm.ReLoadUXAdmDetail();
		return;
	}
	websys_showModal({
		id: uxId,
		url: admInfoURL + "?admId=" + admId + "&prescNo=" + prescNo + "&ordItmId=" + ordItmId,
		title: "������Ϣ",
		iconCls: "icon-w-list",
		width: "800",
		height: "450",
		closable: true,
		onClose: function () {}
		// ����ȥ��,����Ĭ�����ٴ���
	});

}

///	�������  ��ʼ��������Ϣ(������id)
function InitErpMenu(PrescNo) {
	var frm = dhcsys_getmenuform();
	if (frm) {
		var patAdm = tkMakeServerCall("PHA.OP.COM.Method", "GetAdmIdByPresc", PrescNo);
		if (patAdm == "") {
			return;
		}
		frm.EpisodeID.value = patAdm;
	}
}

///	�������  ���������Ϣ(������id)
function ClearErpMenu() {
	var frm = dhcsys_getmenuform();
	if (frm) {
		if (frm.EpisodeID) {
			frm.EpisodeID.value = "";
		}
	}
}

//��ȡͼƬ·��
function GetHttpFile(_name) {
	if (_name == "") {
		return "";
	}
	if (HttpSrc == "") {
		var httpSrc = tkMakeServerCall("PHA.COM.Upload", "GetFtpHttpSrc", DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID)
			var httpSrcArr = httpSrc.split("^");
		if (httpSrcArr[0] < 0) {
			return "";
		} else {
			HttpSrc = httpSrcArr[1];
		}
	}
	var httpHref = window.location.href;
	var httpPre = 'http://';
	if (httpHref.indexOf('https') >= 0) {
		httpPre = 'https://';
	}
	var httpSrc = httpPre + HttpSrc + _name;
	return httpSrc;
}

function DoOPInterfaceCom(_objParams) {
	var computerIP = ClientIPAddress;
	var User = session['LOGON.USERID'];
	var LocId = session['LOGON.CTLOCID'];
	var InfoStr = computerIP + "^" + User;
	_objParams.InfoStr = InfoStr;
	_objParams.phlLocId = LocId;

	var retInfo = tkMakeServerCall("PHA.OP.COM.Face", "OPInterfaceCom", JSON.stringify(_objParams));
	var RetArr = retInfo.split("^");
	var len = RetArr.length;
	var retValue = RetArr[0];
	if (retValue < 0) {
		if (len > 1) {
			dhcphaMsgBox.alert(RetArr[1]);

		}
		return false;
	}
	return true;
}

function CACert(modelName, _callback) {
	var logonType = ""; // ��¼���ͣ�UKEY|PHONE|FACE|SOUND|"" ��ʱ��������ǩ����ʽ
	var singleLogon = 0; // �Ƿ񵯳�����¼��ʽ: 0-������ҳǩǩ����1-����ǩ����ʽ
	var forceOpen = 0; // ǿ�Ƶ���ǩ������(Ĭ��0:û�е�¼���򵯳�����¼���򲻵���;1:ǿ�Ƶ���ǩ������)
	dhcsys_getcacert({
		modelCode: modelName, /*ǩ��ģ���д���*/
		callback: function (cartn) {
			debugger
			// ǩ�����ڹرպ�,���������
			if (cartn.IsSucc) {
				if (cartn.ContainerName == "") {
					_callback(); // CA δ����
				} else {
					if ("object" == typeof cartn && cartn.ContainerName !== '') {
						_callback(); // д�����ҵ�����
					}
				}
			} else {
				alert("ǩ��ʧ�ܣ�");
				return false;
			}
		}
		//isHeaderMenuOpen:true, //�Ƿ���ͷ�˵���ǩ������. Ĭ��true
		//SignUserCode:"YF01",   //����ǩ����HIS���ţ���У��֤���û���HIS����. Ĭ�Ͽ�
		//signUserType:"",   // Ĭ�Ͽգ���ʾǩ���û��뵱ǰHIS�û�һ�¡�ALLʱ����֤�û���֤��
		//notLoadCAJs:1,  //��¼�ɹ��󣬲���ͷ�˵�����CA
		//loc:deptDesc,   //����id��������Ĭ�ϵ�ǰ��¼����
		//groupDesc:groupDesc,  //��ȫ��������Ĭ�ϵ�ǰ��¼��ȫ��
		//caInSelfWindow:1  //�û���¼���л����ҹ��ܣ� ҵ���鲻��
	});
}

// ҩƷ����ɫ��ͼ����ʽ����
// Huxt 2021-08-05
// cellattr: DrugColor
function DrugColor(rowIndex, val, rowData, cm, field) {
	if (rowData.drugIcon) {
		var drugIconArr = rowData.drugIcon.split('|');
		var _dColor = drugIconArr[0],
		_dBackColor = drugIconArr[1];
		return 'style="color:' + _dColor + ';background-color:' + _dBackColor + ';"';
	}
	return '';
}
// formatter: DrugIcon
function DrugIcon(val, options, rowData) {
	var iconStr = "";
	if (rowData.drugIcon) {
		var drugIconArr = rowData.drugIcon.split('|');
		var oneIconStr = '',
		oneIconArr = [];
		for (var ic = 2; ic < drugIconArr.length; ic++) {
			oneIconStr = drugIconArr[ic];
			if (oneIconStr != '') {
				oneIconArr = oneIconStr.split(':');
				iconStr += "<img src='../scripts/pha/in/v1/drugicon/" + oneIconArr[0] + "' title='" + oneIconArr[1] + "' class='pha-drugicon' />";
			}
		}
		return iconStr;
	}
	return iconStr;
}
// loadComplete: function () { DrugTips(); }
function DrugTips(){
	$(".pha-drugicon").hover(function(e){
		var $t = $(e.target)
		var imgX = $t.offset().left; 
		var imgY = $t.offset().top; 
		var imgSrc = $t.attr('src');
		var imgTitle = $t.attr('title');
		var imgWidth = $t.width();
		var imgHeight = $t.height();
		$t.attr('title', '');
		if (imgTitle != '' && imgTitle != null) {
			$t.attr('tips_title', imgTitle);
		}
		imgTitle = $t.attr('tips_title') || '';
		var tipWidth = 300;
		var tipHeight = 138;
		var povId = 'pha_drug_icon_tips';
		if ($('#' + povId).length == 0) {
			var povCss = '';
			povCss += 'width:' + tipWidth + 'px;';
			povCss += 'height:' + tipHeight + 'px;';
			povCss += 'top:' + (imgY - (tipHeight / 2)) + 'px;';
			povCss += 'left:' + (imgX + imgWidth + 4) + 'px;'
			$('body').append('</div><div id="' + povId + '" class="pha-drugicon-tips-body" style="' + povCss + '"></div>');
		} else {
			$('#' + povId).css('top', imgY - (tipHeight / 2));
			$('#' + povId).css('left', imgX + imgWidth + 4);
		}
		var eHtml = '';
		eHtml += '<div class="pha-drugicon-tips">';
		eHtml += '<table style="margin-top:2px;">';
		eHtml += '<tr>';
		eHtml += '<td valign="top" align="left" style="width:115px;">';
		eHtml += '<img src="' + imgSrc + '" style="width:100px;height:100px;" />';
		eHtml += '</td>';
		eHtml += '<td valign="top" align="left" style="width:150px;">';
		eHtml += '<label>' + imgTitle + '<label>';
		eHtml += '</td>';
		eHtml += '</tr>';
		eHtml += '</table>';
		eHtml += '</div>';
		$('#' + povId).html(eHtml);
		$('#' + povId).show();
	}, function(){
		var povId = 'pha_drug_icon_tips';
		$('#' + povId).html('');
		$('#' + povId).hide();
	});
}