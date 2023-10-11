/*!
 *@creator:yunhaibao
 *@createdate:2016-08-06
 *@description:药房的一些默认配置
 *@others:
 */
var DhcphaGridTrHeight = 34;
var LastEditSel = ""; //最后编辑行
var JqGridCanEdit = true;
var DhcphaReadCardCommon_ops;
var OPKey_HotKey;
var OPKey_MainGrid = "";
var HospId = session['LOGON.HOSPID'];
var userAgent = navigator.userAgent; //获取浏览器的类型
$(function () {
	var pathname = window.location.pathname;
	pathname = pathname.split("/csp/")[0];
	DHCPHA_CONSTANT.URL.PATH = pathname;
	DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL = pathname + "/csp/" + DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL;
	DHCPHA_CONSTANT.URL.COMMON_INPHA_URL = pathname + "/csp/" + DHCPHA_CONSTANT.URL.COMMON_INPHA_URL;
	DHCPHA_CONSTANT.URL.COMMON_PHA_URL = pathname + "/csp/" + DHCPHA_CONSTANT.URL.COMMON_PHA_URL;
	DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL = pathname + "/csp/" + DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL;
	$("input[type=checkbox][name!=swich]").dhcphaCheck(); //所有checkbox
	$("input[type=text]").on("keypress", function (e) {
		if (window.event.keyCode == "13") {
			KeyDownListener();
		}
	});
	GetPhaHisCommonParmas();
});

// 监听两次回车是否太快
function KeyDownListener() {
	var keydowndate = new Date();
	var keydowntime = keydowndate.getTime();
	if (DHCPHA_CONSTANT.VAR.LASTENTERTIME != "" && DHCPHA_CONSTANT.VAR.LASTENTERTIME != undefined) {
		var minustime = keydowntime - DHCPHA_CONSTANT.VAR.LASTENTERTIME;
		if (minustime < 600) {
			dhcphaMsgBox.alert($g("回车速度太快!"));
		}
	}
	DHCPHA_CONSTANT.VAR.LASTENTERTIME = keydowntime;
}
// @description 初始化卡类型
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
	// 默认卡类型
	$.ajax({
		type: "POST", // 提交方式 post 或者get
		url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + "?action=GetCardType&style=select2",
		data: "json",
		success: function (data) {
			// var jsondata=eval(data);  // 不建议用eval
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
			dhcphaMsgBox.alert($g("获取默认卡类型失败!"));
		}
	});
}
//@description:读卡调用
//@params:变量对象,回掉函数
//@csp need add:DHCWeb.OPCommonManageCard.JS
DhcphaReadCardCommon_CallBack = null; // 间接记录回调
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
	// 回调
	if (patCarNo != "") {
		readRet = DHCACC_GetAccInfo("", patCarNo, "", "PatInfo", CardTypeCallBack);
	} else {
		readRet = DHCACC_GetAccInfo7(CardTypeCallBack);
	}

}

function CardTypeCallBack(rtn) {
	var readRet = rtn;
	if (readRet == false) {
		dhcphaMsgBox.alert($g("卡无效!"));
		return;
	}
	var txtcardno = DhcphaReadCardCommon_ops.CardNoId;
	var txtpatno = DhcphaReadCardCommon_ops.PatNoId;
	var txtcardtype = DhcphaReadCardCommon_ops.CardTypeId;
	var readRetArr = readRet.split("^");
	var readRtn = readRetArr[0];
	switch (readRtn) {
	case "0":
		//卡有效
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
		dhcphaMsgBox.alert($g("请检查读卡器，或者输入卡号后重试！"));
		break;
	case "-200":
		dhcphaMsgBox.alert($g("卡无效!"));
		break;
	case "-201":
		//现金
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

//@description 获取病人医嘱信息,加载信息到指定div
//@params 医嘱id
function AppendPatientOrdInfo(_options) {
	$.ajax({
		type: "POST", //提交方式 post 或者get
		url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + "?action=GetPatientOrdInfo&orditem=" + _options.orditem,
		data: "json",
		success: function (data) {
			var retdata = JSON.parse(data)[0];
			var imageid = "";
			if (retdata.patsex == "女") {
				//非女即男
				imageid = "icon-female.png";
			} else if (retdata.patsex == "男") {
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
			alert($g("获取病人医嘱信息失败!"));
		}
	});
}

//@description 获取病人基本信息,加载信息到指定div
//@params 医嘱id
function AppendPatientBasicInfo(_options) {
	var retdata = GetPatientBasicInfo(_options.input, _options.gettype);
	var imageid = "";
	if (retdata.patsex == "女") {
		//非女即男
		imageid = "icon-female.png";
	} else if (retdata.patsex == "男") {
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

//@description 获取病人基本信息
//@params 卡号/登记号 , 类型(登记号:patno/卡号:cardno)
function GetPatientBasicInfo(inputNo, noType) {
	var patinfo = tkMakeServerCall("web.DHCSTPharmacyCommon", "GetPatientBasicInfo", inputNo, noType);
	patinfo = JSON.parse(patinfo)[0];
	return patinfo;
}

//@description 获取his信息的公共变量参数
//@params 登记号长度,卡号长度
function GetPhaHisCommonParmas() {
	$.ajax({
		type: "POST", //提交方式 post 或者get
		url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + "?action=GetPhaHisCommonParmas",
		data: "json",
		success: function (data) {
			var jsondata = JSON.parse(data); // data需要双引号
			var hisPatNoLen = jsondata[0].patNoLen;
			if (hisPatNoLen > 0) {
				DHCPHA_CONSTANT.DEFAULT.PATNOLEN = hisPatNoLen;
			}
		},
		error: function () {
			alert($g("获取公共参数失败!"));
		}
	});
}

//@description 数字补0
//@input: no,length
function NumZeroPadding(inputNum, numLength) {
	if (inputNum == "") {
		return inputNum;
	}
	var inputNumLen = inputNum.length;
	if (inputNumLen > numLength) {
		//$.messager.alert('错误提示',"输入错误！");
		dhcphaMsgBox.alert($g("输入错误！"));
		return "";
	}
	for (var i = 0; i < inputNumLen; i++) {
		var para = inputNum[i];
		if (isNaN(para) || para.trim() == "" || String(para).indexOf(".") > -1 || !(parseInt(inputNum) > 0)) {
			dhcphaMsgBox.alert($g("输入错误！"));
			return "";
		}
	}
	for (var i = 1; i <= numLength - inputNumLen; i++) {
		inputNum = "0" + inputNum;
	}
	return inputNum;
}

//@description:jqGrid可编辑的内容的颜色
function addTextCellAttr(rowId, val, rawObject, cm, rdata) {
	if (rawObject.planId == null) {
		return "style='color:black;font-weight:bold;'";
	}
}

//@description:判断表格数据是否为空
//@return: true:空
function DhcphaGridIsEmpty(_grid_id, _grid_type) {
	if (_grid_type == undefined) {
		_grid_type = "";
	}
	if (_grid_type == "") {
		//默认jqGrid
		var grid_records = $(_grid_id).getGridParam("records");
		if (grid_records == 0) {
			dhcphaMsgBox.alert($g("当前界面内容无明细数据!"));
			return true;
		}
		return false;
	}
}

//@description:判断表格数据是否选中
//@return: true:选中
function DhcphaGridIsSelect(_grid_id, _grid_type) {
	if (_grid_type == undefined) {
		_grid_type = "";
	}
	if (_grid_type == "") {
		//默认jqGrid
		var grid_select = $(_grid_id).jqGrid("getGridParam", "selrow");
		if (grid_select == "" || grid_select == null) {
			dhcphaMsgBox.alert($g("请先选中数据,再进行操作!"));
			return false;
		}
		return true;
	}
}

//@description:jqGrid可编辑的内容的颜色
function addTextCellAttr(rowId, val, rawObject, cm, rdata) {
	if (rawObject.planId == null) {
		return "style='color:black;font-weight:bold;'";
	}
}

//@description:初始化inci下拉
function InitLocInci(_options) {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + "?action=GetLocInciDsByAlias&style=select2&locId=" + _options.locid,
		placeholder: $g("药品名称")+"...",
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

//@description:转换日期为yyyy-MM-dd格式
//@params: (t-1)
function FormatDateT(input) {
	input = input.trim();
	input = input.toUpperCase();
	var formatdate = tkMakeServerCall("web.DHCSTKUTIL", "GetDate", "", "", input);
	return formatdate;
}

//@description:转换日期为yyyy-MM-dd格式
//@params: (t-1)
function FormatDateYMD(input) {
	input = input.trim();
	input = input.toUpperCase();
	var formatdate = tkMakeServerCall("web.DHCSTKUTIL", "GetYMDDate", "", "", input);
	return formatdate;
}

//@description:判断浏览器类型
function BrowserType() {
	var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
}

//@description:获取在用网卡mac地址,IE
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
		var service = locator.ConnectServer("."); //连接本机服务器
		var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration Where IPEnabled =True"); //查询使用SQL标准
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

//判断数组中是否包含元素
Array.prototype.contains = function (obj) {
	var i = this.length;
	while (i--) {
		if (this[i] === obj) {
			return true;
		}
	}
	return false;
};

///前台daterange格式转换,传到后台统一以"-"分割
function FormatDateRangePicker(inputValue) {
	if (inputValue == "") {
		return inputValue;
	}
	if (!inputValue) {
		return inputValue;
	}
	inputValue = inputValue.replace("至", "-");
	return inputValue;
}

///查询界面的除条件外的表格高度
///contentcnt:panel div_content 个数
function GridCanUseHeight(contentcnt) {
	var height1 = $("[class='container-fluid dhcpha-condition-container']").height();
	var height2 = parseFloat($("[class='panel div_content']").css("margin-top"));
	var height3 = parseFloat($("[class='panel div_content']").css("margin-bottom"));
	var height4 = parseFloat($("[class='panel-heading']").outerHeight());
	var contenth = height1 + height2 + height3 + height4 + 20;
	var tableheight = $(window).height() - contenth * contentcnt;
	return tableheight;
}

///查询条件高度,查询条件以div包裹
function QueryConditionHeight() {
	var conditionheight = $("#dhcpha-query-condition").height() + $("#dhcpha-query-condition").offset().top;
	return conditionheight;
}

///表格中panelheading高度
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

///表格为jqgrid时计算整体表格可用高度,tnum表头页码区域总个数
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

/// 修改csp路径为完整路径
function ChangeCspPathToAll(pathcsp) {
	var pathname = window.location.pathname;
	pathname = pathname.split("/csp/")[0];
	pathcsp = pathname + "/csp/" + pathcsp;
	return pathcsp;
}

//补位的方法
//第一个目标数
//第二个参数位数
//第三个是填充的元素
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
		dhcphaMsgBox.alert($g("该患者无对应卡信息,不能进行预扣费!"));
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
			dhcphaMsgBox.alert($g("该患者无对应卡信息,不能进行预扣费!"));
			return false;
		}
		dhcphaMsgBox.confirm($g("是否确认扣费? 点击[确认]生成，点击[取消]退出"), function (r) {
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
			title: "预扣费",
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
 * 转换数字,主要给jqgrid输入数字keyup的时候判断,目前没负数的问题,因此直接转正
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
		num1 = num1.replace(/[^0-9]/g, "") * 1; // 替换非数字为空
		var num2 = str.substring(dpos + 1, str.length);
		num2 = num2.replace(/[^0-9]/g, "");
		var num = num1 + "." + num2;
	} else {
		var num = str.replace(/[^0-9]/g, "") * 1;
	}
	return num;
}

/**
 * 处方审核拒绝原因选择,内容Load csp,如进入系统已经加载过,则之后不会重复加载
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
		// 如果不是重新加载,则重新修改内容
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
		title: "拒绝原因选择与录入",
		iconCls: "icon-w-list",
		width: "80%",
		height: "80%",
		closable: false,
		onClose: function () {}, // 不能去掉,否则默认销毁窗体
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
 *	草药配送信息选择框,内容Load csp,如进入系统已经加载过,则之后不会重复加载
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
		// 如果不是重新加载,则重新修改内容
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
		title: "配送信息",
		iconCls: "icon-w-list",
		width: "55%",
		height: "90%",
		closable: false,
		onClose: function () {}, // 不能去掉,否则默认销毁窗体
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
			//给界面增加快捷键，向下键选择发药列表数据
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
			//给界面增加快捷键，向上键选择发药列表数据
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
 * BootStrap嵌的HISUI药学分类
 */
function ShowPHAINPhcCat(paramOpts, callBack) {
	var phccatURL = ChangeCspPathToAll("pha.in.v3.ux.phccat.csp");
	var uxId = "PHA_IN_V3_UX_PHCCAT"
		if (top.$("#" + uxId).html() != undefined) {
			top.$("#" + uxId).panel("options").onBeforeClose = DoReturn;
			top.$("#" + uxId).window("open");
			// 如果不是重新加载,则重新修改内容
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
		title: "药学分类",
		iconCls: "icon-w-list",
		width: "600",
		height: "500",
		closable: true,
		onClose: function () {}, // 不能去掉,否则默认销毁窗体
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
		// 如果不是重新加载,则重新修改内容
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
		title: "患者信息",
		iconCls: "icon-w-list",
		width: "800",
		height: "450",
		closable: true,
		onClose: function () {}
		// 不能去掉,否则默认销毁窗体
	});

}

///	病历浏览  初始化病人信息(仅就诊id)
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

///	病历浏览  清除病人信息(仅就诊id)
function ClearErpMenu() {
	var frm = dhcsys_getmenuform();
	if (frm) {
		if (frm.EpisodeID) {
			frm.EpisodeID.value = "";
		}
	}
}

//获取图片路径
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
	var logonType = ""; // 登录类型，UKEY|PHONE|FACE|SOUND|"" 空时弹出配置签名方式
	var singleLogon = 0; // 是否弹出单登录方式: 0-弹出多页签签名，1-单种签名方式
	var forceOpen = 0; // 强制弹出签名窗口(默认0:没有登录过则弹出，登录过则不弹出;1:强制弹出签名窗口)
	dhcsys_getcacert({
		modelCode: modelName, /*签名模块中代码*/
		callback: function (cartn) {
			debugger
			// 签名窗口关闭后,会进入这里
			if (cartn.IsSucc) {
				if (cartn.ContainerName == "") {
					_callback(); // CA 未开启
				} else {
					if ("object" == typeof cartn && cartn.ContainerName !== '') {
						_callback(); // 写后面的业务代码
					}
				}
			} else {
				alert("签名失败！");
				return false;
			}
		}
		//isHeaderMenuOpen:true, //是否在头菜单打开签名窗口. 默认true
		//SignUserCode:"YF01",   //期望签名人HIS工号，会校验证书用户与HIS工号. 默认空
		//signUserType:"",   // 默认空，表示签名用户与当前HIS用户一致。ALL时不验证用户与证书
		//notLoadCAJs:1,  //登录成功后，不向头菜单加载CA
		//loc:deptDesc,   //科室id或描述，默认当前登录科室
		//groupDesc:groupDesc,  //安全组描述，默认当前登录安全组
		//caInSelfWindow:1  //用户登录与切换科室功能， 业务组不用
	});
}

// 药品的颜色和图标样式函数
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