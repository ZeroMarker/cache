/**
 * FileName: dhcbill.ipbill.reg.js
 * Anchor: ZhYW
 * Date: 2019-03-27
 * Description: 住院登记
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkInsuInfo: {
		validator: function(value) {
			var jsonData = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.PACAdmReason", id: getValueById("AdmReason")}, false);
			if (!$.isEmptyObject(jsonData)) {
				return (+jsonData.REANationalCode > 0);
			}
		},
		message: "非医保患者不能输入医保信息"
	}
});

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
		frameEnterKeyCode(e);
	});
	initDOMSeqConf();
	initPanelMenu();
});

/**
* 获取页面DOM元素跳转配置
*/
function initDOMSeqConf() {
	if (GV.Conf.DOMSEQAry.length == 0) {
		saveDOMCahce();
	}else {
		$.each(GV.Conf.DOMSEQAry, function (index, item) {
			if (item.required) {
				$("label[for=" + item.id + "]").addClass("clsRequired");
			}
			if (item.disabled) {
				disableById(item.id);
			}
			//设置首屏焦点，只会有一个焦点
			if (item.focus) {
				GV.FocusId = item.id;
				focusById(item.id);
			}
		});
	}
}

/**
* 缓存DOM元素
*/
function saveDOMCahce() {
	var cacheObj = {};
	$.each($(document).find("label[for]"), function (index, item) {
		var id = $(this).attr("for");
		var text = $(this).text();
		if (!id || !text) {
			return true;
		}
		cacheObj[id] = text;
	});
	$.m({
		ClassName: "web.DHCIPBillRegConf",
		MethodName: "SaveDOMCache",
		obj: JSON.stringify(cacheObj)
	}, function(rtn) {
		$.messager.alert("提示", "请先在【页面功能配置】页面配置", "info");
	});
}

function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 13:
		//弹出alert/confirm提示框时，光标定位到"确定"按钮
		var bool = true;
		$(".messager-button>a .l-btn-text").each(function(index, item) {
			var $okSpan = $(item);
			if ($.inArray($okSpan.text(), ["Ok", "确定"])) {
				$okSpan.parent().parent().trigger("focus");   //确定按钮聚焦
				bool = false;
				return false;
			}
		});
		if (bool) {
			focusNextEle(e.target.id);
		}
		break;
	case 117:
 		regCancelClick();       //F6
		break;
	case 118:
		clearClick();           //F7
		break;
	case 120:
		regSaveClick();         //F9
		break;
	case 121:
		linkAddDepClick();      //F10
		break;
	default:
	}
}

/**
* 设置焦点
*/
function focusNextEle(id) {
	var myIdx = -1;
	$.each(GV.Conf.DOMSEQAry, function (index, item) {
		if (item.id == id) {
			myIdx = index;
			return false;
		}
	});
	if (myIdx < 0) {
		return true;
	}
	var id = "";
	var $obj = "";
	var nextId = "";
	for (var i = (myIdx + 1); i < GV.Conf.DOMSEQAry.length; i++) {
		id = GV.Conf.DOMSEQAry[i].id;
		$obj = $("#" + id);
		if ($obj.parents("tr").is(":hidden")) {
			continue;
		}
		if ($obj.is(":hidden")) {
			if ($obj.next("span").find("input").attr("readonly") == "readonly") {
				continue;
			}
			if ($obj.next("span").find("input").attr("disabled") == "disabled") {
				continue;
			}
		}else {
			if ($obj.attr("disabled") == "disabled") {
				continue;
			}
		}
		nextId = id;
		break;
	}
	if (nextId) {
		focusById(nextId);
		return false;
	}
	return true;
}

function initPanelMenu() {
	//读卡
	$HUI.linkbutton("#Btn-ReadCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});

	//查询
	$HUI.linkbutton("#Btn-Find", {
		onClick: function () {
			findClick();
		}
	});

	//读身份证
	$HUI.linkbutton("#Btn-ReadIDCard", {
		onClick: function () {
			readIDCardClick();
		}
	});

	//交押金
	$HUI.linkbutton("#Btn-AddDeposit", {
		onClick: function () {
			linkAddDepClick();
		}
	});

	//入院登记
	$HUI.linkbutton("#Btn-RegSave", {
		onClick: function () {
			regSaveClick();
		}
	});

	//退院
	$HUI.linkbutton("#Btn-RegCancel", {
		onClick: function () {
			regCancelClick();
		}
	});
	
	//医保登记
	$HUI.linkbutton("#Btn-InsuReg", {
		onClick: function () {
			insuRegClick();
		}
	});
	
	//取消医保登记
	$HUI.linkbutton("#Btn-InsuRegCancel", {
		onClick: function () {
			insuRegCancelClick();
		}
	});
	
	//就诊信息修改
	$HUI.linkbutton("#Btn-RegUpdate", {
		onClick: function () {
			regUpdateClick();
		}
	});

	//修改住院次数
	$HUI.linkbutton("#Btn-TimesUpdate", {
		onClick: function () {
			timesUpdateClick();
		}
	});

	//修改诊断
	$HUI.linkbutton("#Btn-DiagUpdate", {
		onClick: function () {
			diagUpdateClick();
		}
	});

	//清屏
	$HUI.linkbutton("#Btn-Clear", {
		onClick: function () {
			clearClick();
		}
	});

	//信息修改查询
	$HUI.linkbutton("#Btn-SearchUpdateLog", {
		onClick: function () {
			searchUpdateLogClick();
		}
	});
	
	//成人腕带, 儿童腕带, 婴儿腕带
	$("#Menu-WD>.menu-item").click(wristbandPrtClick);
	
	//登记号
	$("#PatientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	//病案号
	$("#MedicareNo").keydown(function (e) {
		medicareNoKeydown(e);
	});
	
	//卡号
	$("#CardNo").keydown(function (e) {
		cardNoKeydown(e);
	});
	
	//年龄
	$("#Age").keydown(function (e) {
		ageKeydown(e);
	});
	
	//出生日期
	$("#BirthDate").keydown(function (e) {
		birthDateKeydown(e);
	});
		
	//新生儿年龄
	$("#BabyAgeDate, #BabyAgeHour, #BabyAgeMinute").keyup(function (e) {
		babyAgeKeyup(e);
	});

	//身份证号
	$("#IDNo").keydown(function (e) {
		IDNoKeydown(e);
	});

	//卡类型
	initCardType();
	//性别
	initSex();
	//民族
	initNation();
	//证件类型
	initCredType();
	//婚姻状况
	initMarital();
	//国(出生)、国(现住)、国籍
	initCountry();
	//省(出生)、省(现住)、省(户口)
	initProvince();
	//市(出生)、市(现住)、市(户口)
	initCity();
	//县(出生)、县(现住)、县(户口)
	initArea();

	//职业
	initOccupation();
	//公费单位
	initHealthCareProvider();
	//与患者关系
	initRelation();
	
	//就诊信息panel
	//就诊列表
	initAdmList();
	//费别
	initAdmReason();
	//科室
	initDept();
	//病区
	initWard();
	//入院医生
	initDoctor();
	//入院途径
	initAdmSource();
	//入院情况
	initAdmCategory();
	//就诊子类
	initEpisSubType();
	//入院病情
	initAdmReferPriority();
	//入院诊断
	initAdmDiag();
	//优惠类型
	initRegConDisc();
	
	//医保信息panel
	//医保类型
	initInsuType();
	//医疗类别
	initInsuAdmType();
	//医保诊断名称
	initInsuDiagList();
	
	$(".combo-text, .spinner-text").keydown(function(e) {
		var key = websys_getKey(e);
		if (key == 13) {
			return focusNextEle($(e.target).parents("td").find("input")[0].id);
		}
	});
	
	//设置默认
	setDefaultValue();

	$("#More-container").click(function () {
		var t = $(this);
		if (t.find(".arrows-b-text").text() == "更多") {
			t.find(".arrows-b-text").text("收起");
			t.find(".spread-b-down").removeClass("spread-b-down").addClass("retract-b-up");
			$("tr.display-more-tr").show();
		} else {
			t.find(".arrows-b-text").text("更多");
			t.find(".retract-b-up").removeClass("retract-b-up").addClass("spread-b-down");
			$("tr.display-more-tr").hide();
		}
	});
}

/**
* 页面的所有元素都加载完毕后
*/
$(window).load(function() {
	//住院证界面链接进来
	if (GV.PatientNo) {
		setValueById("PatientNo", GV.PatientNo);
		setValueById("CardNo", GV.CardNo);
		getRegInfoByIPBook(GV.IPBookID);
	}
});

function initCardType() {
	$HUI.combobox("#CardType", {
		panelHeight: 'auto',
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array',
		editable: false,
		valueField: 'value',
		textField: 'caption',
		onChange: function (newValue, oldValue) {
			initReadCard(newValue);
		}
	});
}

/**
 * 初始化卡类型时卡号和读卡按钮的变化
 * @method initReadCard
 * @param {String} cardType
 * @author ZhYW
 */
function initReadCard(cardType) {
	try {
		var cardTypeAry = cardType.split("^");
		var readCardMode = cardTypeAry[16];
		if (readCardMode == "Handle") {
			disableById("Btn-ReadCard");
			$("#CardNo").attr("readOnly", false);
		} else {
			enableById("Btn-ReadCard");
			setValueById("CardNo", "");
			$("#CardNo").attr("readOnly", true);
		}
	} catch (e) {
		$.messager.popover({msg: e.message, type: "info"});
	}
}

function initSex() {
	$HUI.combobox("#Sex", {
		panelHeight: 'auto',
		method: 'GET',
		url: $URL + '?ClassName=web.UDHCOPOtherLB&MethodName=ReadSex&JSFunName=GetSexToHUIJson',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4
	});
}

function initNation() {
	$HUI.combobox("#Nation", {
		panelHeight: 150,
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBL.CTBASEIF.ICTCardRegLB&MethodName=ReadBaseData&ResultSetType=array&TabName=CTNATION&QueryInfo=^^^HUIJSON',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4
	});
}

function initCredType() {
	$HUI.combobox("#CredType, #ForeignCredType", {
		panelHeight: 150,
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4
	});
	
	$.cm({
		ClassName: "web.DHCIPBillReg",
		QueryName: "FindCredType",
		ResultSetType: "array",
		type: "GET",
	}, function(jsonData) {
		$("#CredType, #ForeignCredType").combobox("loadData", jsonData);
	});
}

function initMarital() {
	$HUI.combobox("#Marital", {
		panelHeight: 150,
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBL.CTBASEIF.ICTCardRegLB&MethodName=ReadBaseData&ResultSetType=array&TabName=CTMarital&QueryInfo=^^^HUIJSON',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4
	});
}

function initCountry() {
	$HUI.combobox("#Country", {
		panelHeight: 150,
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		selectOnNavigation: false,
		blurValidValue: true,
		defaultFilter: 4
	});
}

function initProvince() {
	$HUI.combobox("#HomeProv, #Province, #BirthProv, #HouseProv", {
		panelHeight: 150,
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		selectOnNavigation: false,
		blurValidValue: true,
		defaultFilter: 4,
		onSelect: function (record) {
			var cityId = getCityId($(this)[0].id);
			if (cityId) {
				var url = $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindCity&ResultSetType=array&type=GET&desc=&provId=" + record.id;
				$("#" + cityId).combobox("clear").combobox("reload", url);
			}
		},
		onChange: function (newValue, oldValue) {
			if (!newValue) {
				var cityId = getCityId($(this)[0].id);
				if (cityId) {
					$("#" + cityId).combobox("clear").combobox("loadData", []);
				}
			}
		}
	});
}

function initCity() {
	$HUI.combobox("#HomeCity, #City, #BirthCity, #HouseCity", {
		panelHeight: 150,
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		selectOnNavigation: false,
		blurValidValue: true,
		defaultFilter: 4,
		onSelect: function (record) {
			var areaId = getAreaId($(this)[0].id);
			if (areaId) {
				var url = $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindCityArea&ResultSetType=array&desc=&cityId=" + record.id;
				$("#" + areaId).combobox("clear").combobox("reload", url);
			}
		},
		onChange: function (newValue, oldValue) {
			if (!newValue) {
				var areaId = getAreaId($(this)[0].id);
				if (areaId) {
					$("#" + areaId).combobox("clear").combobox("loadData", []);
				}
			}
		}
	});
}

function initArea() {
	$HUI.combobox("#CityArea, #BirthArea, #HouseArea", {
		panelHeight: 150,
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4,
		onSelect: function (record) {
			//取邮编
			if ($(this)[0].id == "CityArea") {
				setPostCode("", "", record.id, "PostCode");
			}else if ($(this)[0].id == "HouseArea") {
				setPostCode("", "", record.id, "HousePostCode");
			}
		}
	});
}

function getCityId(provId) {
	var cityId = "";
	$.each($("#" + provId).parent().siblings().children("input"), function (index, itm) {
		if ((itm.id.toUpperCase().indexOf("CITY") != -1) && ($(this).hasClass("combobox-f"))) {
			cityId = itm.id;
			return false;
		}
	});
	return cityId;
}

function getAreaId(cityId) {
	var areaId = "";
	$.each($("#" + cityId).parent().siblings().children("input"), function (index, itm) {
		if ((itm.id.toUpperCase().indexOf("AREA") != -1) && ($(this).hasClass("combobox-f"))) {
			areaId = itm.id;
			return false;
		}
	});
	return areaId;
}

/**
* 根据地址获取邮编
*/
function setPostCode(prov, city, area, postCodeId) {
	var tabName = "CTZIP";
	var queryInfo = prov + "^" + city + "^" + area;
	$.m({
		ClassName: "web.DHCBL.CTBASEIF.ICTCardRegLB",
		MethodName: "ReadBaseData",
		type: "GET",
		TabName: "CTZIP",
		QueryInfo: queryInfo
	}, function (rtn) {
		var myAry = rtn.split("$c(2)");
		var postCode = (myAry.length > 1) ? myAry[1] : "";
		setValueById(postCodeId, postCode);
	});
}

function initOccupation() {
	$HUI.combobox("#Occupation", {
		panelHeight: 150,
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBL.CTBASEIF.ICTCardRegLB&MethodName=ReadBaseData&ResultSetType=array&TabName=CTOCCUPATION&QueryInfo=^^^HUIJSON',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4
	});
}

function initHealthCareProvider() {
	$HUI.combobox("#HealthCareProvider", {
		panelHeight: 150,
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBL.CTBASEIF.ICTCardRegLB&MethodName=ReadBaseData&ResultSetType=array&TabName=HCPDR&QueryInfo=^^^HUIJSON',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4
	});
}

function initRelation() {
	$HUI.combobox("#Relation", {
		panelHeight: 150,
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBL.CTBASEIF.ICTCardRegLB&MethodName=ReadBaseData&ResultSetType=array&TabName=CTRelation&QueryInfo=^^^HUIJSON',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4
	});
}

function initAdmList() {
	$HUI.combogrid("#AdmList", {
		panelWidth: 530,
		panelHeight: 200,
		striped: true,
		fitColumns: false,
		editable: false,
		method: 'GET',
		idField: 'admId',
		textField: 'admNo',
		columns: [[{field: 'admNo', title: "就诊号", width: 100},
				   {field: 'admDate', title: '就诊日期', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.admTime;
							}
						}
					},
					{field: 'admDept', title: '就诊科室', width: 100},
					{field: 'admWard', title: '就诊病区', width: 120},
					{field: 'admBed', title: '床号', width: 60},
					{field: 'admStatus', title: '就诊状态', width: 80},
					{field: 'admId', title: '就诊ID', width: 80}
			]],
		onLoadSuccess: function (data) {
			setValueById("AdmList", "");
			if (data.total > 0) {
				setValueById("AdmList", getValueById("EpisodeID"));
			}
		},
		onSelect: function (index, row) {
			if (row.admId != getValueById("EpisodeID")) {
				selectAdmListHandler(row);
				getInsuAdmInfo();         //获取医保登记信息
			}
		}
	});
}

function selectAdmListHandler(row) {
	var episodeId = row.admId;
	$.cm({
		ClassName: "web.DHCIPBillReg",
		MethodName: "GetAdmInfo",
		type: "GET",
		episodeId: episodeId,
		sessionStr: getSessionStr()
	}, function (json) {
		setAdmInfo(json);
	});
}

function initAdmReason() {
	$HUI.combobox("#AdmReason", {
		panelHeight: 150,
		method: 'GET',
		url: $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindGrpAdmRea&ResultSetType=array",
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.groupId = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		onSelect: function (rec) {
			$("#InsuInfo-Panel").find(".validatebox-text").each(function() {
				$(this).validatebox("isValid");
			});
		},
		onChange: function(newValue, oldValue) {
			if (newValue && !getValueById("SocialStatus")) {
				//通过费别取默认社会地位
				$.m({
					ClassName: "web.DHCIPBillReg",
					MethodName: "getSocSatStr",
					type: "GET",
					admReaId: newValue
				}, function(rtn) {
					var myAry = rtn.split("^");
					setValueById("SocialStatus", myAry[0]);
				});
			}
		}
	});
}

function initDept() {
	$HUI.combobox("#Dept", {
		panelHeight: 150,
		method: 'GET',
		url: $URL + '?ClassName=web.DHCIPBillReg&QueryName=FindIPDept&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		selectOnNavigation: false,
		blurValidValue: true,
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		onSelect: function (record) {
			var url = $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindWard&ResultSetType=array&deptId=" + record.id + "&IPBookId=";
			$("#Ward").combobox("clear").combobox("reload", url);
			
			url = $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindDoctor&ResultSetType=array&deptId=" + record.id + "&desc=";
			$("#Doctor").combobox("clear").combobox("reload", url);
		},
		onChange: function (newValue, oldValue) {
			if (!newValue) {
				$("#Ward").combobox("clear").combobox("loadData", []);
				$("#Doctor").combobox("clear").combobox("loadData", []);
			}
		}
	});
}

function initWard() {
	$HUI.combobox("#Ward", {
		panelHeight: 150,
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4,
		onLoadSuccess: function (data) {
			if (data.length == 1) {
				$(this).combobox("select", data[0].id);
			}
		}
	});
}

function initDoctor() {
	$HUI.combobox("#Doctor", {
		panelHeight: 150,
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4
	});
}

function initAdmSource() {
	$HUI.combobox("#AdmSource", {
		panelHeight: 'auto',
		method: 'GET',
		url: $URL + '?ClassName=web.DHCIPBillReg&QueryName=FindInAdmSource&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4
	});
}

function initAdmCategory() {
	$HUI.combobox("#AdmCategory", {
		panelHeight: 'auto',
		method: 'GET',
		url: $URL + '?ClassName=web.DHCIPBillReg&QueryName=FindAdmCategory&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4
	});
}

function initEpisSubType() {
	$HUI.combobox("#EpisSubType", {
		panelHeight: 'auto',
		method: 'GET',
		url: $URL + '?ClassName=web.UDHCJFBaseCommon&QueryName=epislookup&ResultSetType=array&desc=',
		valueField: 'typeid',
		textField: 'type',
		blurValidValue: true,
		defaultFilter: 4
	});
}

function initAdmReferPriority() {
	$HUI.combobox("#AdmReferPriority", {
		panelHeight: 'auto',
		method: 'GET',
		url: $URL + '?ClassName=web.DHCIPBillReg&QueryName=FindPACRefPriority&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4
	});
}

function initAdmDiag() {
	$HUI.combobox("#AdmDiagnos", {
		panelHeight: 150,
		mode: 'remote',
		method: 'GET',
		valueField: 'HIDDEN',
		textField: 'desc',
		delay: 300,
		blurValidValue: true,
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			if ($.trim(param.q).length > 1) {
				$.extend($(this).combobox("options"), {url: $URL})
				param.ClassName = "web.DHCMRDiagnos";
				param.QueryName = "LookUpWithAlias";
				param.ResultSetType = "array";
				param.desc = param.q;
			}
		}
	});
}

function initRegConDisc() {
	$HUI.combobox("#RegConDisc", {
		panelHeight: 150,
		method: 'GET',
		url: $URL + "?ClassName=web.DHCRegConDisCount&MethodName=ReadDHCRegConDisCountBroker&JSFunName=GetRegConToHUIJson&HospId=" + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4
	});
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	try {
		var cardType = getValueById("CardType");
		var cardTypeDR = cardType.split("^")[0];
		var myRtn = "";
		if (cardTypeDR == "") {
			myRtn = DHCACC_GetAccInfo();
		} else {
			myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
		}
		var myAry = myRtn.toString().split("^");
		var rtn = myAry[0];
		switch (rtn) {
		case "0":
			setValueById("CardNo", myAry[1]);
			setValueById("PatientNo", myAry[5]);
			getPatInfo();
			break;
		case "-200":
			$.messager.alert("提示", "卡无效", "info", function () {
				focusById("Btn-ReadCard");
			});
			break;
		case "-201":
			setValueById("CardNo", myAry[1]);
			setValueById("PatientNo", myAry[5]);
			getPatInfo();
			break;
		default:
		}
	} catch (e) {
	}
}

/**
* 查询
*/
function findClick() {
	var name = charTransAsc(getValueById("Name"));    //把汉字转化为ASCII码
	var url = "dhcbill.ipbill.patientinfo.csp?&Name=" + name + "&PatientNo=" + getValueById("PatientNo") + "&IDNo=" + getValueById("IDNo") + "&BirthDate=" + getValueById("BirthDate") + "&HealthFundNo=" + getValueById("HealthFundNo");
	websys_showModal({
		url: url,
		title: "患者信息查询",
		iconCls: "icon-w-find",
		originWindow: window
	});
}

/**
* 查询切换
*/
function switchPatient(patientNo) {
	setValueById("PatientNo", patientNo);
	getPatInfo();
}

/**
* 读身份证
*/
function readIDCardClick() {
	try {
		var myHCTypeDR = "1";
		var myInfo = DHCWCOM_PersonInfoRead(myHCTypeDR);
		//测试串
		//var myInfo = "0^<IDRoot><Age>55</Age><Name>***</Name><Sex>1</Sex><NationDesc>汉</NationDesc><Birth>19620817</Birth><Address>湖南省岳阳市岳阳楼区七里山社区居委会*区**栋***号</Address><CredNo>430105196208171015</CredNo><PhotoInfo></PhotoInfo></IDRoot>"
		var myAry = myInfo.split("^");
		if ((myAry.length > 1) && (myAry[0] == "0")) {
			var IDCardXML = myAry[1];
			var IDObj = new X2JS().xml_str2json(IDCardXML).IDRoot;
			setValueById("IDNo", IDObj["CredNo"]);
			setValueById("Name", IDObj["Name"]);
			var sex = "";
			switch (IDObj["Sex"]) {
			case "1":
				sex = "男";
				break;
			case "2":
				sex = "女";
				break;
			default:
			}
			if (sex) {
				$.m({
					ClassName: "web.UDHCJFBaseCommon",
					MethodName: "GetSexDr",
					Sex: sex
				}, function(rtn) {
					var myAry = rtn.split("^");
					setValueById("Sex", myAry[0]);
				});
			}
			setValueById("BirthDate", formatDate(IDObj["Birth"]));
			
			$.m({
				ClassName: "web.UDHCJFCOMMON",
				MethodName: "GetNationId",
				desc: IDObj["NationDesc"]
			}, function(nationId) {
				setValueById("Nation", nationId);
			});
			
			var age = IDObj["Age"];
			age += (age.indexOf("岁") == -1) ? "岁" : "";
			setValueById("Age", age);
			
			setValueById("Address", IDObj["Address"]);
			
			setValueById("PhotoInfo", IDObj["PhotoInfo"]);
			
			//显示照片
			var src = "";
			if (getValueById("PhotoInfo")) {
				src = "data:image/png;base64," + getValueById("PhotoInfo");
			} else if (getValueById("IDNo")) {
				src = "c://" + getValueById("IDNo") + ".bmp";
			}else {
				src = "../images/uiimages/patdefault.png";
			}
			ShowPicBySrcNew(src, "ImgPic");
		}
	} catch (e) {
		$.messager.popover({msg: "读身份证失败：" + e.message, type: "error"});
	}
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if ($(e.target).val()) {
			setValueById("MedicareNo", "");
			getPatInfo();
		}
	}
}

function medicareNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if ($(e.target).val()) {
			setValueById("PatientNo", "");
			getPatInfo();
		}
	}
}

function cardNoKeydown(e) {
	try {
		var key = websys_getKey(e);
		if (key == 13) {
			var cardNo = getValueById("CardNo");
			if (!cardNo) {
				return;
			}
			var cardType = getValueById("CardType");
			cardNo = formatCardNo(cardType, cardNo);
			var cardTypeAry = cardType.split("^");
			var cardTypeDR = cardTypeAry[0];
			var myRtn = DHCACC_GetAccInfo(cardTypeDR, cardNo, "", "PatInfo");
			var myAry = myRtn.toString().split("^");
			var rtn = myAry[0];
			switch (rtn) {
			case "0":
				setValueById("CardNo", myAry[1]);
				setValueById("PatientNo", myAry[5]);
				getPatInfo();
				break;
			case "-200":
				setTimeout(function () {
					$.messager.alert("提示", "卡无效", "info", function () {
						focusById("CardNo");
					});
				}, 10);
				break;
			case '-201':
				setValueById("CardNo", myAry[1]);
				setValueById("PatientNo", myAry[5]);
				getPatInfo();
				break;
			default:
			}
		}
	} catch (e) {
	}
}

function getPatInfo() {
	setValueById("PatientID", "");
	setValueById("EpisodeID", "");
	setValueById("IPBookID", "");
	
	var papmi = getPatIDByPatNo(getValueById("PatientNo"), getValueById("MedicareNo"));
	if (!papmi) {
		return getRegInfo();
	}
	var admitEpisodeId = getAdmitEpisodeID(papmi);
	if (+admitEpisodeId > 0) {
		return getRegInfo();     //在院患者不再查询住院证
	}
	//有效的住院证
	var rtn = getIPBKNum(papmi);
	var myAry = rtn.split("^");
	var bookNum = myAry[0];
	var bookId = myAry[1];
	if (!(+bookNum > 0)) {
		return getRegInfo();
	}
	$.messager.confirm("确认", "患者存在有效住院证，是否使用住院证办理？", function (r) {
		if (r) {
			if (+bookNum == 1) {
				setValueById("IPBookID", bookId);
				return getRegInfo();
			} else {
				var url = "doc.ipbookquery.hui.csp?PatientID=" + papmi + "&UDHCJFFlag=Y";
				websys_showModal({
					url: url,
					title: "住院证",
					iconCls: "icon-w-list",
					originWindow: window
				});
			}
		}else {
			return getRegInfo();
		}
	});
}

/**
* 根据登记号/病案号获取患者主索引
*/
function getPatIDByPatNo(patientNo, medicareNo) {
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	return $.m({ClassName: "web.DHCIPBillReg", MethodName: "GetPatientID", patientNo: patientNo, medicareNo: medicareNo, expStr: expStr}, false);
}

/**
* 获取有效的住院证
*/
function getIPBKNum(papmi) {
	return $.m({ClassName: "web.DHCDocIPBookingCtl", MethodName: "GetIPBKNum", type: "GET", PatID: papmi}, false);
}

/**
* 通过住院证界面链接过来，住院证界面调用此方法获取患者登记信息
*/
function getRegInfoByIPBook(IPBookId) {
	if (IPBookId) {
		setValueById("IPBookID", IPBookId);
		getRegInfo();
	}
}

/**
* 获取患者登记信息
*/
function getRegInfo() {
	$.cm({
		ClassName: "web.DHCIPBillReg",
		MethodName: "GetRegInfo",
		type: "GET",
		patientNo: getValueById("PatientNo"),
		medicareNo: getValueById("MedicareNo"),
		IPBookId: getValueById("IPBookID"),
		sessionStr: getSessionStr()
	}, function (json) {
		if (json.success == "0") {
			var patJson = JSON.parse(json.PatInfo);
			var admJson = JSON.parse(json.AdmInfo);
			var IPBookJson = JSON.parse(json.IPBookInfo);
			
			setPatInfo(patJson);
			if (admJson.EpisodeID) {
				setAdmInfo(admJson);
				getInsuAdmInfo();       //获取医保登记信息
			}else {
				setDefAdmReason();      //设置患者默认费别
				//有住院证时获取住院证信息
				if (IPBookJson.IPBookID) {
					setIPBookingInfo(IPBookJson);
				}
			}
			loadAdmList();          //加载就诊列表
			disableEle();
		}else {
			switch (json.msg) {
			case "IPBookErr":
				$.messager.alert("提示", "住院证不在有效日期范围内，不能办理入院", "info", function() {
					websys_showModal("close");
				});
				break;
			case "Admission":
				$.messager.alert("提示", "患者正在住院，不能再办理入院", "info", function() {
					websys_showModal("close");
				});
				break;
			case "OnceAdmission":
				$.messager.alert("提示", "患者曾住院，不能办理入院", "info", function() {
					websys_showModal("close");
				});
				break;
			case "NotActive":
				$.messager.alert("提示", "此住院证已为无效状态，不能办理入院", "info", function() {
					websys_showModal("close");
				});
				break;
			default:
				$.messager.popover({msg: json.msg, type: "info"});
			}
		}
	});
}

function setPatInfo(patJson) {
	if (patJson.success != "0") {
		$.messager.popover({msg: patJson.msg, type: "info"});
		return;
	}
	setValueById("PatientID", patJson.PatientID);
	setValueById("PatientNo", patJson.PatientNo);
	setValueById("Name", patJson.Name);
	setValueById("MedicareNo", patJson.MedicareNo);
	setValueById("Sex", patJson.Sex);
	setValueById("IDNo", patJson.IDNo);             //身份证号
	setValueById("Age", patJson.Age);
	setValueById("Nation", patJson.Nation);
	setValueById("BirthDate", patJson.BirthDate);   //出生日期
	setValueById("BirthTime", patJson.BirthTime);   //出生时间
	setValueById("Marital", patJson.Marital);
	setValueById("HomeTel", patJson.HomeTel);    //联系电话
	setValueById("Company", patJson.Company);    //工作单位
	setValueById("WorkTel", patJson.WorkTel);    //办公电话
	setValueById("MobPhone", patJson.MobPhone);
	setValueById("SocialStatus", patJson.SocialStatus);   //社会地位
	setValueById("CredType", patJson.CredType);
	setValueById("CredNo", patJson.CredNo);      //证件号
	setValueById("Country", patJson.Country);    //国籍/地区
	setValueById("Occupation", patJson.Occupation);
	//省(籍贯)
	var homeProvId = patJson.HomeProv
	setValueById("HomeProv", homeProvId);
	//市(籍贯)
	url = $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindCity&ResultSetType=array&desc=&provId=" + homeProvId;
	$("#HomeCity").combobox("reload", url).combobox("setValue", patJson.HomeCity);
	//省(现住)
	var provId = patJson.Province;
	setValueById("Province", provId);
	//市(现住)
	var cityId = patJson.City;
	var url = $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindCity&ResultSetType=array&desc=&provId=" + provId;
	$("#City").combobox("reload", url).combobox("setValue", patJson.City);			
	//区县(现住)
	url = $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindCityArea&ResultSetType=array&desc=&cityId=" + cityId;
	$("#CityArea").combobox("reload", url).combobox("setValue", patJson.CityArea);
	setValueById("Address", patJson.Address);     //地址(现住)
	setValueById("PostCode", patJson.PostCode);   //邮编(现住)
	//省(出生)
	var birthProvId = patJson.BirthProv;
	setValueById("BirthProv", birthProvId);
	//市(出生)
	var birthCityId = patJson.BirthCity;
	url = $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindCity&ResultSetType=array&desc=&provId=" + birthProvId;
	$("#BirthCity").combobox("reload", url).combobox("setValue", birthCityId);
	//县(出生)
	url = $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindCityArea&ResultSetType=array&desc=&cityId=" + birthCityId;
	$("#BirthArea").combobox("reload", url).combobox("setValue", patJson.BirthArea);
	setValueById("BirthAddress", patJson.BirthAddress);         //地址(出生)
	setValueById("CompanyPostCode", patJson.CompanyPostCode);   //邮编(工作)
	//省(户口)
	var houseProvId = patJson.HouseProv;
	setValueById("HouseProv", houseProvId);
	//市(户口)
	var houseCityId = patJson.HouseCity;
	url = $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindCity&ResultSetType=array&desc=&provId=" + houseProvId;
	$("#HouseCity").combobox("reload", url).combobox("setValue", houseCityId);
	//县(户口)
	url = $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindCityArea&ResultSetType=array&desc=&cityId=" + houseCityId;
	$("#HouseArea").combobox("reload", url).combobox("setValue", patJson.HouseArea);
	setValueById("HouseAddress", patJson.HouseAddress);    //地址(户口)
	setValueById("HousePostCode", patJson.HousePostCode);  //邮编(户口)

	setValueById("ForeignName", patJson.ForeignName);         //联系人
	setValueById("Relation", patJson.Relation);               //与患者关系
	setValueById("ForeignPhone", patJson.ForeignPhone);       //联系人电话
	setValueById("ForeignAddress", patJson.ForeignAddress);   //联系人地址
	setValueById("ForeignCredType", patJson.ForeignCredType);   //联系人证件类型
	setValueById("ForeignCredNo", patJson.ForeignCredNo);       //联系人证件号
	setValueById("Remark", patJson.Remark);    //备注
	
	setValueById("BabyAgeDate", patJson.BabyAgeDate);      //天
	setValueById("BabyAgeHour", patJson.BabyAgeHour);      //时
	setValueById("BabyAgeMinute", patJson.BabyAgeMinute);  //分	
	setValueById("HealthFundNo", patJson.HealthFundNo);              //医保手册号
	setValueById("HealthCareProvider", patJson.HealthCareProvider);  //公费单位
	setValueById("HealthCareCardNo", patJson.HealthCareCardNo);      //公费证号
	
	showPatPic();   //显示患者身份证照片
}

/**
* 显示患者身份证照片
*/
function showPatPic() {
	$.m({
		ClassName: "web.DHCIPBillReg",
		MethodName: "GetPatPhotoStream",
		papmi: getValueById("PatientID")
	}, function(photoStream) {
		setValueById("PhotoInfo", photoStream);
		 //显示照片
		var src = photoStream ? ("data:image/png;base64," + photoStream) : "../images/uiimages/patdefault.png";
		ShowPicBySrcNew(src, "ImgPic");
	});
}

/**
* 获取患者住院证信息
*/
function setIPBookingInfo(IPBookJson) {
	if (IPBookJson.success != "0") {
		$.messager.popover({msg: IPBookJson.msg, type: "info"});
		return;
	}	
	setValueById("VisitStatus", IPBookJson.VisitStatus);
	//科室
	var dept = IPBookJson.Dept;
	setValueById("Dept", dept);
	//病区
	url = $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindWard&ResultSetType=array&deptId=" + dept + "&IPBookId=" + getValueById("IPBookID");
	$("#Ward").combobox("reload", url).combobox("setValue", IPBookJson.Ward);
	//入院医生
	url = $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindDoctor&ResultSetType=array&deptId=" + dept + "&desc=";
	$("#Doctor").combobox("reload", url).combobox("setValue", IPBookJson.Doctor);		
	
	setValueById("SuggestDepAmt", IPBookJson.SuggestDepAmt);      //建议押金
	setValueById("AdmSource", IPBookJson.AdmSource);   //入院途径
	setValueById("AdmReferPriority", IPBookJson.AdmReferPriority);  //入院病情(病危、危重、危急)			
	getICDDiagnos(IPBookJson.AdmDiagnos);    //入院诊断
	setValueById("DiagRemark", IPBookJson.DiagRemark);   //诊断备注
}

/**
* 获取患者默认费别
*/
function setDefAdmReason() {
	$.m({
		ClassName: "web.DHCIPBillReg",
		MethodName: "GetPatDefAdmReaID",
		patientId: getValueById("PatientID"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(admReaId) {
		var admReaObj = getAdmReaObj(admReaId);
		var item = {id: admReaId, text: admReaObj.READesc};
		var arr = $("#AdmReason").combobox("getData");
		$.hisui.addArrayItem(arr, 'id', item);
		$("#AdmReason").combobox("loadData", arr).combobox("setValue", admReaId);
	});
}

/**
* 设置默认
*/
function setDefaultValue() {
	//默认现住地址信息
	var regDefObj = new X2JS().xml_str2json(GV.PatUIDefXMLStr).DHCCardRegInfoDefault;
	var url = $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindCountry&ResultSetType=array&type=GET&desc=";
	$("#Country").combobox("reload", url).combobox("setValue", regDefObj.CountryDescLookUpRowID);
	$.cm({
		ClassName: "web.DHCIPBillReg",
		QueryName: "FindProvince",
		ResultSetType: "array",
		type: "GET",
		desc: "",
		countryId: regDefObj.CountryDescLookUpRowID
	}, function(jsonData) {
		$("#BirthProv, #HouseProv, #HomeProv").combobox("loadData", jsonData);
		$("#Province").combobox("loadData", jsonData).combobox("setValue", regDefObj.ProvinceInfoLookUpRowID);
	});
	
	url = $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindCity&ResultSetType=array&type=GET&desc=&provId=" + regDefObj.ProvinceInfoLookUpRowID;
	$("#City").combobox("reload", url).combobox("setValue", regDefObj.CityDescLookUpRowID);
	url = $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindCityArea&ResultSetType=array&type=GET&desc=&cityId=" + regDefObj.CityDescLookUpRowID;
	$("#CityArea").combobox("reload", url);
	
	//默认就诊信息
	setValueById("User", PUBLIC_CONSTANT.SESSION.USERNAME);
	var curDateTime = getCurDateTime();
	var myAry = curDateTime.split(/\s+/);
	setValueById("AdmDate", myAry[0]);
	setValueById("AdmTime", myAry[1]);
	//配置登记界面不能修改入院日期时，入院日期和入院时间禁用
	if (IPBILL_CONF.PARAM.RegEditAdmDate != "Y") {
		disableById("AdmDate");
		disableById("AdmTime");
	}
}

/**
* 取当前时间
*/
function getCurDateTime() {
	return $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "FormDateTime"}, false);
}

function getICDDiagnos(id) {
	$.cm({
		ClassName: "web.DHCBillCommon",
        MethodName: "GetClsPropValById",
        clsName: "User.MRCICDDx",
        id: id
	}, function(json) {
		$("#AdmDiagnos").combobox("loadData", [{"desc": json.MRCIDDesc, "HIDDEN": id, selected: true}]);
	});
}

function setAdmInfo(admJson) {
	if (admJson.success != "0") {
		$.messager.popover({msg: admJson.msg, type: "info"});
		return;
	}
	setValueById("EpisodeID", admJson.EpisodeID);
	setValueById("VisitStatus", admJson.VisitStatus);
	setValueById("InPatTimes", admJson.InPatTimes);  //住院次数
	//科室
	var dept = admJson.Dept;
	setValueById("Dept", dept);
	//病区
	url = $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindWard&ResultSetType=array&deptId=" + dept + "&IPBookId=" + getValueById("IPBookID");
	$("#Ward").combobox("reload", url).combobox("setValue", admJson.Ward);
	//入院医生
	url = $URL + "?ClassName=web.DHCIPBillReg&QueryName=FindDoctor&ResultSetType=array&deptId=" + dept + "&desc=";
	$("#Doctor").combobox("reload", url).combobox("setValue", admJson.Doctor);

	//就诊费别
	var admReaId = admJson.AdmReason;
	var admReaObj = getAdmReaObj(admReaId);
	var item = {id: admReaId, text: admReaObj.READesc};
	var arr = $("#AdmReason").combobox("getData");
	$.hisui.addArrayItem(arr, 'id', item);
	$("#AdmReason").combobox("loadData", arr).combobox("setValue", admReaId);			

	setValueById("EpisSubType", admJson.EpisSubType);  //就诊子类
	setValueById("AdmCategory", admJson.AdmCategory);  //入院情况

	setValueById("AdmDate", admJson.AdmDate);
	setValueById("AdmTime", admJson.AdmTime);
	setValueById("User", admJson.User);    //操作员

	setValueById("AdmSource", admJson.AdmSource);   //入院途径
	setValueById("AdmReferPriority", admJson.AdmReferPriority);  //入院病情(病危、危重、危急)

	getICDDiagnos(admJson.AdmDiagnos);    //入院诊断
	setValueById("DiagnosType", admJson.DiagnosType);   //诊断类型				
	setValueById("DiagRemark", admJson.DiagRemark);     //诊断备注

	//优惠类型
	var regConDiscId = admJson.RegConDisc;
	var regConDiscObj = getRegConDiscObj(regConDiscId);
	var item = {id: regConDiscId, text: regConDiscObj.RCDDesc};
	var arr = $("#RegConDisc").combobox("getData");
	$.hisui.addArrayItem(arr, 'id', item);
	$("#RegConDisc").combobox("loadData", arr).combobox("setValue", regConDiscId);
}

/**
* 获取费别数据
*/
function getAdmReaObj(id) {
    return $.cm({
        ClassName: "web.DHCBillCommon",
        MethodName: "GetClsPropValById",
        clsName: "User.PACAdmReason",
        id: id
    }, false);
}

/**
* 获取优惠类型数据
*/
function getRegConDiscObj(id) {
    return $.cm({
        ClassName: "web.DHCBillCommon",
        MethodName: "GetClsPropValById",
        clsName: "User.DHCRegConDisCount",
        id: id
    }, false);
}

/**
 * 加载就诊列表
 */
function loadAdmList() {
	var queryParams = {
		ClassName: "web.DHCIPBillReg",
		QueryName: "FindAdmList",
		type: "GET",
		papmi: getValueById("PatientID"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadComboGridStore("AdmList", queryParams);
}

/**
 * 入院登记
 */
function regSaveClick() {
	if ($("#Btn-RegSave").hasClass("l-btn-disabled")) {
		return;
	}

	if (!_checkRequired()) {
		return;
	}
	
	if (!checkData()) {
		return;
	}

	if (getValueById("CardNo")) {
		var cardType = getValueById("CardType");
		var cardTypeAry = cardType.split("^");
		var cardTypeDR = cardTypeAry[0];
		var rtn = $.m({ClassName: "web.DHCOPAdmReg", MethodName: "CheckTempCardEffe", CardTypeId: cardTypeDR, CardNo: getValueById("CardNo")}, false);
		var isTempCard = rtn.split("^")[0];
		if (isTempCard == "Y") {
			$.messager.popover({msg: "该卡为临时卡，不能办理入院", type: "info"});
			return;
		}
	}
	
	var patientNo = getValueById("PatientNo");
	var papmi = getValueById("PatientID");
	if (IPBILL_CONF.PARAM.RegNeedPatientNo == "Y") {
		if (!papmi || !patientNo) {
			focusById("PatientNo");
			$.messager.popover({msg: "该患者登记号不存在，不能办理入院", type: "info"});
			return;
		}
	}
	
	if (!papmi) {
		//患者主索引不存在时，根据患者其余信息查询患者
		if (checkAlreadyPAPER()) {
			return;
		}
	}else {
		var admitEpisodeId = getAdmitEpisodeID(papmi);
		if (+admitEpisodeId > 0) {
			var admHospDR = $.m({ClassName: "web.UDHCHospitalGroup", MethodName: "GetHospitalByAdm", adm: admitEpisodeId}, false);
			var admHospDesc = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetHospitalName", hospitalID: admHospDR}, false);
			$.messager.popover({msg: "该患者正在" + admHospDesc + "住院，不能再办理入院", type: "info"});
			return;
		}
	}
	
	var admStatus = $.m({ClassName: "web.DHCIPBillReg", MethodName: "JudgeAdmStatus", patientId: papmi, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
	if (admStatus) {
		$.messager.confirm("确认", "该患者有" + admStatus + "状态就诊，是否确认办理入院?", function (r) {
			if (r) {
				_linkSave();
			}
		});
	}else {
		_linkSave();
	}
	
	function _linkSave() {
		var qfStatus = $.m({ClassName: "web.DHCIPBillReg", MethodName: "JudgePatStatus", patientId: papmi, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
		if (+qfStatus == -1) {
			$.messager.confirm("确认", "该患者已经欠费结算，是否确认办理入院?", function (r) {
				if (r) {
					_reg();
				}
			});
		} else if (+qfStatus == -2) {
			if (IPBILL_CONF.PARAM.RegCheckUnPay == "Y") {
				$.messager.confirm("确认", "该患者有未结算的帐单，是否确认办理入院?", function (r) {
					if (r) {
						_reg();
					}
				});
			}else {
				$.messager.popover({msg: "该患者有未结算的帐单，不能办理入院", type: "info"});
				return;
			}
		} else {
			$.messager.confirm("确认", "是否确认办理入院?", function (r) {
				if (r) {
					_reg();
				}
			});
		}
	}
	
	function _reg() {
		var episodeId = getValueById("EpisodeID");
		if (episodeId) {
			var jsonObj = getAdmJsonObj(episodeId);
			switch (jsonObj.PAADMVisitStatus) {
			case "P":
				$.messager.popover({msg: "该患者为预住院状态，不能在此办理入院", type: "info"});
				break;
			case "A":
				$.messager.popover({msg: "该患者已经在院，不能再办理入院", type: "info"});
				break;
			default:
				$.messager.popover({msg: "不能选择以前的就诊办理入院", type: "info"});
			}
			return;
		}
		var encmeth = getValueById("PAPersonEntityEncrypt");
		var personXML = getEntityClassInfoToXML(encmeth);
		
		var encmeth = getValueById("PAPersonExpEntityEncrypt");
		var personExpXML = getEntityClassInfoToXML(encmeth);
		
		var encmeth = getValueById("PAAdmEntityEncrypt");
		var admXML = getEntityClassInfoToXML(encmeth);
		
		var expStr = getValueById("PhotoInfo");
		$.m({
			ClassName: "web.DHCIPBillReg",
			MethodName: "SaveRegInfo",
			personXML: personXML,
			personExpXML: personExpXML,
			admXML: admXML,
			sessionStr: getSessionStr(),
			expStr: expStr
		}, function (rtn) {
			var myAry = rtn.split("^");
			var success = myAry[0];
			var msg = myAry[1];
			switch (success) {
			case "0":
				$.messager.alert("提示", msg, "success", function() {
					setValueById("IPBookID", "");   //清空住院证RowID
					if (!getValueById("PatientID")) {
						setValueById("PatientID", myAry[2]);
						setValueById("PatientNo", myAry[3]);
					}
					setValueById("MedicareNo", myAry[4]);
					setValueById("EpisodeID", myAry[5]);
					loadAdmList();
					setValueById("VisitStatus", myAry[6]);
					setValueById("InPatTimes", myAry[7]);
					//医保登记
					if ($("#InsuInfo-Panel").length > 0) {
						insuReg();
					}else {
						//转到交押金界面(允许调用交押金程序)
						if (IPBILL_CONF.PARAM.RegLnkPayDep == "Y") {
							linkAddDepClick();
						}
					}
				});
				break;
			default:
				$.messager.alert("提示", msg, "error");
			}
		});
	}
	
	//必填项目验证
	function _checkRequired() {
		var nullValTextAry = [];
		var firstEleId = "";
		$.each(GV.Conf.DOMSEQAry, function (index, item) {
			if (item.required && !getValueById(item.id)) {
				nullValTextAry.push(item.text);
				if (!firstEleId) {
					firstEleId = item.id;
				}
			}
		});
		if (nullValTextAry.length > 0) {
			$.messager.popover({msg: "请输入<font color=red>" + nullValTextAry.join() + "</font>", type: "info"});
			focusById(firstEleId);
			return false;
		}
		return true;
	}
}

/**
* 获取患者在院就诊
*/
function getAdmitEpisodeID(patientId) {
	return $.m({ClassName: "web.DHCIPBillReg", MethodName: "GetAdmitEpisodeID", patientId: patientId}, false);
}

/**
* 退院
*/
function regCancelClick() {
	var papmi = getValueById("PatientID");
	var episodeId = getValueById("EpisodeID");
	if (!papmi) {
		$.messager.popover({msg: "请选择需要退院的患者", type: "info"});
		return;
	}
	if (!episodeId) {
		$.messager.popover({msg: "患者就诊信息为空，不需办理退院", type: "info"});
		return;
	}
	$.messager.confirm("确认", "是否确认为该患者办理退院?", function (r) {
		if (r) {
			var admReaStr = getAdmReasonInfo(episodeId);
			var admReaAry = admReaStr.split("^");
			var nationalCode = admReaAry[1];
			if (+nationalCode > 0) {
				var insuAdmStr = $.m({ClassName: "web.DHCINSUPort", MethodName: "GetInsuAdmInfoByAdmDr", PAADMDr: episodeId}, false);
				var insuAdmAry = insuAdmStr.split("^");
				if ((insuAdmAry.length > 10) && (insuAdmAry[10] != "B") && (insuAdmAry[10] != "S")) {
					$.messager.popover({msg: "请先取消医保登记再办理退院", type: "info"});
					return;
				}
			}
			$.m({
				ClassName: "web.DHCIPBillReg",
				MethodName: "CancelAdm",
				episodeId: getValueById("EpisodeID"),
				sessionStr: getSessionStr()
			}, function (rtn) {
				var myAry = rtn.split("^");
				var success = myAry[0];
				var msg = myAry[1];
				switch (success) {
				case "0":
					$.messager.alert("提示", msg, "success", function() {
						clearClick();
					});
					break;
				default:
					$.messager.popover({msg: msg, type: "error"});
				}
			});
		}
	});
}

/**
* 获取就诊费别信息
*/
function getAdmReasonInfo(episodeId) {
	return $.m({ClassName: "web.UDHCJFPAY", MethodName: "GetAdmReaNationCode", EpisodeID: episodeId}, false);
}

/**
* 医保登记
*/
function insuRegClick() {
	var papmi = getValueById("PatientID");
	if (!papmi) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	var episodeId = getValueById("EpisodeID");
	if (!episodeId) {
		$.messager.popover({msg: "请选择患者就诊", type: "info"});
		return;
	}
	var admReaStr = getAdmReasonInfo(episodeId);
	var admReaAry = admReaStr.split("^");
	var admReaId = admReaAry[0];
	var nationalCode = admReaAry[1];
	if (+nationalCode > 0) {
		var url = "insuipreg.hui.csp?&PapmiNo=" + getValueById("PatientNo") + "&AdmDr=" + episodeId;
		websys_showModal({
			url: url,
			title: "医保登记",
			iconCls: "icon-w-edit",
			width: "95%",
			height: "90%",
			onClose: function() {
				getInsuAdmInfo();
			}
		});
	}else {
		$.messager.popover({msg: "非医保患者，不需要医保登记", type: "info"});
	}
}

/**
* 取消医保登记
*/
function insuRegCancelClick() {
	var episodeId = getValueById("EpisodeID");
	if (!episodeId) {
		$.messager.popover({msg: "请选择患者就诊", type: "info"});
		return;
	}
	var admReaStr = getAdmReasonInfo(episodeId);
	var admReaAry = admReaStr.split("^");
	var admReaId = admReaAry[0];
	var nationalCode = admReaAry[1];
	if (+nationalCode > 0) {
		var rtn = InsuIPRegStrike(0, PUBLIC_CONSTANT.SESSION.USERID, episodeId, "", admReaId, "");
		if (rtn == 0) {
			$.messager.popover({msg: "取消医保登记成功", type: "success"});
			getInsuAdmInfo();
		}else {
			$.messager.popover({msg: "取消医保登记失败：" + rtn, type: "error"});
		}
	}else {
		$.messager.popover({msg: "非医保患者，不需要取消医保登记", type: "info"});
	}
}

/**
* 就诊信息修改
*/
function regUpdateClick() {
	if (!getValueById("PatientID")) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	if (!_checkRequired()) {
		return;
	}
	
	if (!checkData()) {
		return;
	}

	var encmeth = getValueById("PAPersonEntityEncrypt");
	var personXML = getEntityClassInfoToXML(encmeth);
	
	var encmeth = getValueById("PAPersonExpEntityEncrypt");
	var personExpXML = getEntityClassInfoToXML(encmeth);
	
	var encmeth = getValueById("PAAdmEntityEncrypt");
	var admXML = getEntityClassInfoToXML(encmeth);
	
	var expStr = getValueById("PhotoInfo");
	$.m({
		ClassName: "web.DHCIPBillReg",
		MethodName: "UpdateRegInfo",
		personXML: personXML,
		personExpXML: personExpXML,
		admXML: admXML,
		sessionStr: getSessionStr(),
		expStr: expStr
	}, function (rtn) {
		var myAry = rtn.split("^");
		var success = myAry[0];
		var msg = myAry[1];
		$.messager.popover({msg: msg, type: ((success == "0") ? "success" : "info")});
	});
	
	//必填项目验证
	function _checkRequired() {
		var nullValTextAry = [];
		var firstEleId = "";
		$.each(GV.Conf.DOMSEQAry, function (index, item) {
			if (item.required && !getValueById(item.id)) {
				//没有就诊时，不验证就诊信息
				if (!getValueById("EpisodeID") && ($("#" + item.id).parents(".panel-body")[0].id == "AdmInfo-Panel")) {
					return true;
				}
				nullValTextAry.push(item.text);
				if (!firstEleId) {
					firstEleId = item.id;
				}
			}
		});
		if (nullValTextAry.length > 0) {
			$.messager.popover({msg: "请输入<font color=red>" + nullValTextAry.join() + "</font>", type: "info"});
			focusById(firstEleId);
			return false;
		}
		return true;
	}
}

/**
* 数据合法性校验
*/
function checkData() {
	var bool = true;
	var IDNo = getValueById("IDNo");
	var credNo = getValueById("CredNo");
	if (($("#CredType").combobox("getText").indexOf("身份证") != -1) && credNo) {
		IDNo = credNo;
		setValueById("IDNo", IDNo);
	}
	if (IDNo != "") {
		if (!DHCWeb_IsIdCardNo(IDNo)) {
			focusById("IDNo");
			return false;
		}
		var IDNoInfoAry = DHCWeb_GetInfoFromId(IDNo);
		var IDBirthDate = IDNoInfoAry[2];
		if (getValueById("BirthDate") != IDBirthDate) {
			$.messager.popover({msg: "患者出生日期与身份证信息不符", type: "info"});
			focusById("BirthDate");
   		    return false;
		}
		var IDSex = IDNoInfoAry[3];
		if ($("#Sex").combobox("getText") != IDSex) {
			$.messager.popover({msg: "患者性别与身份证信息不符", type: "info"});
			focusById("Sex");
			return false;
		}
	}
	
	var homeTel = getValueById("HomeTel");
	if (homeTel && !DHCC_IsTelOrMobile(homeTel)) {
		$.messager.popover({msg: "联系电话输入不正确", type: "info"});
		focusById("HomeTel");
		return false;
	}
	var workTel = getValueById("WorkTel");
	if (workTel && !DHCC_IsTelOrMobile(workTel)) {
		$.messager.popover({msg: "办公电话输入不正确", type: "info"});
		focusById("WorkTel");
		return false;
	}
	var mobPhone = getValueById("MobPhone");
	if (mobPhone && !DHCC_IsTelOrMobile(mobPhone)) {
		$.messager.popover({msg: "手机号输入不正确", type: "info"});
		focusById("MobPhone");
		return false;
	}
	if ($("#ForeignCredType").combobox("getText").indexOf("身份证") != -1) {
		var foreignCredNo = getValueById("ForeignCredNo");
		if (foreignCredNo) {
			if (!DHCWeb_IsIdCardNo(foreignCredNo)) {
				focusById("ForeignCredNo");
				return false;
			}
		}
	}
	var foreignPhone = getValueById("ForeignPhone");
	if (foreignPhone && !DHCC_IsTelOrMobile(foreignPhone)) {
		$.messager.popover({msg: "联系人电话输入不正确", type: "info"});
		focusById("ForeignPhone");
		return false;
	}
	var birthDate = getValueById("BirthDate");
	if (birthDate && !validateDate(birthDate)) {
		$.messager.popover({msg: "出生日期输入不正确", type: "info"});
		focusById("BirthDate");
		return false;
	}
	
	$(".validatebox-text").each(function() {
		if (!$(this).validatebox("isValid")) {
			$.messager.popover({msg: "数据验证不通过", type: "info"});
			focusById($(this)[0].id);
			bool = false;
			return false;
		}
	});
	
	return bool;
}

/**
* 修改住院次数
*/
function timesUpdateClick() {
	var episodeId = getValueById("EpisodeID");
	if (!episodeId) {
		$.messager.popover({msg: "请选择患者的就诊记录", type: "info"});
		return;
	}
	var admTimes = getValueById("InPatTimes");
	$.m({
		ClassName: "web.DHCIPBillReg",
		MethodName: "UpdateAdmInPatNo",
		episodeId: episodeId,
		inPatNo: admTimes,
		guser: PUBLIC_CONSTANT.SESSION.USERID
	}, function (rtn) {
		var myAry = rtn.split("^");
		$.messager.popover({msg: myAry[1], type: ((myAry[0] == "0") ? "success" : "info")});
	});
}

/**
* 修改诊断
*/
function diagUpdateClick() {
	var episodeId = getValueById("EpisodeID");
	if (!episodeId) {
		$.messager.popover({msg: "请选择患者的就诊记录", type: "info"});
		return;
	}
	var diagnosType = getValueById("DiagnosType");  //诊断类型
	var admDiagnos = getValueById("AdmDiagnos");    //入院诊断
	var diagRemark = getValueById("DiagRemark");    //诊断备注
	var diagInfo = diagnosType + "^" + admDiagnos + "^" + diagRemark;
	
	diagInfo = diagInfo.replace(/undefined/g, "");   //替换所有的undefined

	$.m({
		ClassName: "web.DHCIPBillReg",
		MethodName: "UpdateDiagnos",
		diagInfo: diagInfo,
		episodeId: episodeId,
		userId: PUBLIC_CONSTANT.SESSION.USERID
	}, function (rtn) {
		var myAry = rtn.split("^");
		var success = myAry[0];
		var msg = myAry[1];
		$.messager.popover({msg: msg, type: ((success == "0") ? "success" : "error")});
	});
}

/**
 * 判断患者姓名、性别、出生日期一致时给予提示;身份证作为唯一索引查找是否有患者信息
 */
function checkAlreadyPAPER() {
	var IDNo = getValueById("IDNo");
	var papmi = getValueById("PatientID");
	var name = getValueById("Name");
	var sex = getValueById("Sex");
	var birthDate = getValueById("BirthDate");
	var healthFundNo = getValueById("HealthFundNo");
	if (papmi) {
		return true;
	}
	if (!IDNo) {
		if (!name || !sex || !birthDate) {
			return false;
		}
	}
	var patInfo = name + "^" + sex + "^" + birthDate + "^" + IDNo + "^" + healthFundNo;
	var patNum = tkMakeServerCall("web.DHCIPBillPAPERInfo", "CheckPatNum", patInfo);
	if (+patNum > 0) {
		$.messager.alert("提示", "系统中已有该患者信息", "info", function () {
			findClick();
		});
		return true;
	}
	return false;
}

/**
* 校验日期是否合法
*/
function validateDate(date) {
	return ($.m({ClassName: "web.DHCIPBillReg", MethodName: "ValidateDate", DateStr: date}, false) == "Yes");
}

/**
* 清屏
*/
function clearClick() {
	$(":text:not(.pagination-num)").val("");
	$(".numberbox-f").numberbox("clear");
	$(".combobox-f").combobox("clear");
	$(".combobox-f:not(#Ward,#Doctor)").combobox("reload");
	$("#Ward,#Doctor").combobox("loadData", []);
	
	$(".combogrid-f").combogrid("clear").combogrid("grid").datagrid("loadData", {
		total: 0,
		rows: []
	});
  	$(".validatebox-text").validatebox("validate");
  	
	setValueById("PhotoInfo", "");
	
	ShowPicBySrcNew("../images/uiimages/patdefault.png", "ImgPic");
	
	setDefaultValue();
	
	setValueById("PatientID", "");
	setValueById("EpisodeID", "");
	setValueById("IPBookID", "");
	disableEle();
	if (GV.FocusId) {
		focusById(GV.FocusId);
	}
}

function disableEle() {
	//若科室/病区/医生未设置为禁用，先将其设置为可用
	var eleStr = "Dept^Ward^Doctor";
	$.each(GV.Conf.DOMSEQAry, function (index, item) {
		if ((eleStr.search(item.id) != -1) && !item.disabled) {
			enableById(item.id);
		}
	});
	
	var episodeId = getValueById("EpisodeID");
	if (episodeId) {
		var jsonObj = getAdmJsonObj(episodeId);
		if (jsonObj.PAADMVisitStatus == "P") {
			$.messager.popover({msg: "该患者为预住院状态，不能在此办理入院", type: "info"});
		}
		disableById("Btn-RegSave");
		$.m({
			ClassName: "web.DHCIPBillReg",
			MethodName: "CheckAdmOrder",
			type: "GET",
			episodeId: episodeId
		}, function (rtn) {
			if (+rtn > 0) {
				disableById("Dept");
				disableById("Ward");
				disableById("Doctor");
			}
		});
	}else {
		enableById("Btn-RegSave");
	}
	
	if (getValueById("IPBookID")) {
		if (getValueById("Dept")) {
			disableById("Dept");
		}
		if (getValueById("Ward")) {
			disableById("Ward");
		}
		if (getValueById("Doctor")) {
			disableById("Doctor");
		}
	}
}

function getAdmJsonObj(episodeId) {
	return $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.PAAdm", id: episodeId}, false);
}

function ageKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (getValueById("BirthDate")) {   //已有出生日期时，不再通过年龄计算
			return;
		}
		var age = getValueById("Age");
		age = age.replace(/\./g, "");
		if (!age) {
			return;
		}
		$.m({
			ClassName:"web.DHCDocCommon",
			MethodName:"GetBirthDateByAge",
			Age: age,
			Type:""
		},function(rtn) {
			setValueById("BirthDate", rtn);
		});
	}
}

function birthDateKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!getValueById("BirthDate")) {
			return;
		}
		getAgeFromBirthDay();
		
		var birthDate = getValueById("BirthDate");
		if (!validateDate(birthDate)) {
			$.messager.popover({msg: "出生日期输入不正确", type: "info"});
			return;
		}
		//判断患者姓名、性别、出生日期一致时给予提示;身份证作为唯一索引查找是否有病人信息
		if (!getValueById("PatientID")) {
			checkAlreadyPAPER();
		}
	}
}

function babyAgeKeyup(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$("#BabyAgeDate, #BabyAgeHour, #BabyAgeMinute").validatebox("isValid")) {
			return;
		}
		var babyAgeDate = getValueById("BabyAgeDate");
		var babyAgeHour = getValueById("BabyAgeHour");
		var babyAgeMinute = getValueById("BabyAgeMinute");
		if (!babyAgeDate && !babyAgeHour && !babyAgeMinute) {
			return;
		}
		var babyAgeStr = babyAgeDate + "天" + babyAgeHour + "小时" + babyAgeMinute + "分钟";
		var date = getValueById("AdmDate");
		var time = getValueById("AdmTime");
		var ageConfig = $.m({ClassName: "web.UDHCJFAgeConfig", MethodName: "GetAgeConfig"}, false);
		if (ageConfig != "Y") {
			var curDateTime = getCurDateTime();
			var myAry = curDateTime.split(/\s+/);
			date = myAry[0];
			time = myAry[1];
		}
		$.m({
			ClassName: "web.UDHCJFCOMMON",
			MethodName: "getbabybirday",
			birstr: babyAgeStr,
			admdate: date,
			admtime: time
		}, function (rtn) {
			switch (rtn) {
			case "1":
				$.messager.popover({msg: "请输入新生儿出生天数", type: "info"});
				break;
			case "2":
				$.messager.popover({msg: "入院日期不能为空", type: "info"});
				break;
			case "3":
				$.messager.popover({msg: "入院时间不能为空", type: "info"});
				break;
			default:
				var myAry = rtn.split("^");
				setValueById("BirthDate", myAry[2]);
				setValueById("BirthTime", myAry[3]);
				getAgeFromBirthDay(myAry[1]);
			}
		});
	}
}

function IDNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var IDNo = getValueById("IDNo");
		if (!IDNo) {
			return;
		}
		if (!DHCWeb_IsIdCardNo(IDNo)) {
			return;
		}
		var IDNoInfoAry = DHCWeb_GetInfoFromId(IDNo);
		var birthDate = IDNoInfoAry[2];
		var sex = IDNoInfoAry[3];
		var age =  IDNoInfoAry[4];
		setValueById("BirthDate", birthDate);
		setValueById("Age", age);
		$.each($("#Sex").combobox("getData"), function (index, item) {
			if (item.text == sex) {
				setValueById("Sex", item.id);
				return false;
			}
		});
	}
}

function getAgeFromBirthDay() {
	var birthDate = formatDate(getValueById("BirthDate"));
	setValueById("BirthDate", birthDate);
	if (!birthDate) {
		return;
	}
	var admDate = getValueById("AdmDate");
	var birthTime = arguments[0] || "";
	var admTime =  getValueById("AdmTime");
	var ageStr = tkMakeServerCall("web.UDHCJFCOMMON", "DispPatAge", birthDate, admDate, birthTime, admTime, PUBLIC_CONSTANT.SESSION.HOSPID);
	var myAry = ageStr.split("||");
	setValueById("Age", myAry[0]);
	if (arguments.length == 0) {
		setValueById("BabyAgeDate", "");
		setValueById("BabyAgeHour", "");
		setValueById("BabyAgeMinute", "");
		setValueById("BirthTime", "");
	}
}

/**
* Creator: ZhYW
* CreatDate: 2019-04-09
*/
function formatDate(date) {
	if (!date) {
		return "";
	}
	if ((date.length != 8) && (date.length != 10)) {
		$.messager.popover({msg: "请输入正确日期", type: "info"});
		return "";
	}
	var dateFormat = tkMakeServerCall("websys.Conversions", "DateFormat");
	var delimiter = "";
	var regExp = "";
	switch(dateFormat) {
		case "3":
			delimiter = "-";
			if (date.length == 8) {
				date = date.substring(0, 4) + "-" + date.substring(4, 6) + "-" + date.substring(6, 8);
			}
			regExp = /^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)$/;
			break;
		case "4":
			delimiter = "/";
			if (date.length == 8) {
				date = date.substring(6, 8) + "/" + date.substring(4, 6) + "/" + date.substring(0, 4);
			}
			regExp = /^(((0[1-9]|[12][0-9]|3[01])\/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])\/(02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29\/02\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))$/;
		default:
	}
	if (!regExp.test(date)) {
		$.messager.popover({msg: "日期输入不正确", type: "info"});
		return "";
	}
	var year = "";
	var month = "";
	var day = "";
	var myAry = date.split(delimiter);
	if (delimiter == "-") {
		year = myAry[0];
		month = myAry[1];
		day = myAry[2];
	}else {
		day = myAry[0];
		month = myAry[1];
		year = myAry[2];
	}
	if (year <= 1840) {
		$.messager.popover({msg: "日期不能小于等于1840年", type: "info"});
		return "";
	}
	var myDate = "";
	switch(dateFormat) {
		case "3":
			myDate = year + "-" + month + "-" + day;
			break;
		case "4":
			myDate = day + "/" + month + "/" + year;
		default:
	}
	return myDate;
}

/**
 * 交押金
 */
function linkAddDepClick() {
	var episodeId = getValueById("EpisodeID");
	if (!episodeId) {
		$.messager.popover({msg: "请选择患者的就诊记录", type: "info"});
		return;
	}
	var jsonObj = getAdmJsonObj(episodeId);
	if (jsonObj.PAADMVisitStatus == "C") {
		$.messager.popover({msg: "患者已退院不能交押金", type: "info"});
		return;
	}
	var url = "dhcbill.ipbill.deposit.pay.if.csp?EpisodeID=" + episodeId;
	websys_showModal({
		url: url,
		title: "交押金",
		iconCls: "icon-w-paid",
		width: "85%",
		height: "85%"
	});
}

function searchUpdateLogClick() {
	var url = "dhcbill.ipbill.uppatinfo.csp?";
	websys_showModal({
		url: url,
		title: "信息修改查询",
		iconCls: "icon-w-find"
	});
}

function wristbandPrtClick() {
	var adm = getValueById("EpisodeID");
	if (!adm) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	
	var type = "adult";    //"child":儿童, "infant":婴儿, "adult":成人
	switch(this.id) {
	case "Btn-WDPrt":
		type = "adult";
		break;
	case "Btn-ChildWDPrt":
		type = "child";
		break;
	case "Btn-BabyWDPrt":
		type = "infant";
		break;
	default:
	}
	
	$.m({
		ClassName: "web.UDHCJFPAY",
		MethodName: "CheckVisitStatus",
		Adm: adm
	}, function(rtn) {
		if (rtn != "A") {
			$.messager.popover({msg: "请先办理入院再打印腕带", type: "info"});
			return;
		}
		WristStrapsPrint(adm, type);
	});
}

/**
 * Insu-加载医保类型
 */
function initInsuType() {
	$HUI.combobox("#InsuType", {
		panelHeight: 100,
		url: $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic&ResultSetType=array",
		validType: ['checkInsuInfo'],
		valueField: 'cCode',
		textField: 'cDesc',
		method: 'GET',
		blurValidValue: true,
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.Type = "DLLType";
			param.Code = "";
			param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		loadFilter: function(data) {
			for (var i in data) {
				if (data[i].cDesc == "全部") {
					data.splice(i, 1);
				}
			}
			return data;
		},
		onSelect: function(rec) {
			$("#InsuAdmType").combobox("clear").combobox("reload");
			$("#InsuDiagDesc").combogrid("clear").combogrid("grid").datagrid("reload");
		}
	});
}

/**
 * Insu-加载医疗类别
 */
function initInsuAdmType() {
	var index = -1;
	$HUI.combobox("#InsuAdmType", {
		panelHeight: 100,
		validType: ['checkInsuInfo'],
		valueField: 'cCode',
		textField: 'cDesc',
		method: "GET",
		blurValidValue: true,
		defaultFilter: 4,
		onBeforeLoad: function(param) {
			if (getValueById("InsuType")) {
				$("#InsuAdmType").combobox("options").url = $URL;
				param.ClassName = "web.INSUDicDataCom";
				param.QueryName = "QueryDic";
				param.ResultSetType = "array";
				param.Type = "AKA130" + getValueById("InsuType");
				param.Code = "";
				param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID;
			}
		},
		loadFilter: function(data) {
			var j = 0;
			var newData = new Array();
			for (var i in data) {
				if (data[i].DicOPIPFlag == "IP") {
					newData.push(data[i]);
					if (data[i].DicDefaultFlag == "Y") {
						index = j;
					}
					j = j + 1;
				}
			}
			return newData;
		},
		onLoadSuccess: function(data) {
			if (index > -1) {
				$(this).combobox("select", data[index].cCode);
			}
		}
	});
}

/**
 * Insu-加载医保诊断(支持检索)
 */
function initInsuDiagList() {
	$("#InsuDiagDesc").combogrid({
		panelWidth: 400,
		panelHeight: 260,
		validType: ['checkInsuInfo'],
		delay: 300,
		mode: 'remote',
		method: 'GET',
		fitColumns: true,
		pagination: true,
		idField: 'Code',
		textField: 'Desc',
		data: [],
		columns: [
			[{field: 'Rowid', hidden: true},
			 {field: 'Code', title: '医保诊断编码', width: 120},
			 {field: 'Desc', title: '医保诊断名称', width: 230}]
		],
		onBeforeLoad: function(param) {
			$(this).datagrid("options").url = null;   //加这句是因为删除内容时会再发起一次请求
			if (getValueById("InsuType") && ($.trim(param.q).length > 1)) {
				$(this).datagrid("options").url = $URL;
				param.ClassName = "web.DHCINSUIPReg";
				param.QueryName = "GetInsuDiagnosis";
				param.InsuInDiagDesc = param.q;
				param.AdmReasonDesc = getValueById("InsuType");
				param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID;
			}
		},
		onLoadSuccess: function(data) {
			if (data.total > 0) {
				$(this).combogrid("grid").datagrid("selectRow", 0);
			}
		},
		onSelect: function(index, row) {
			setValueById("InsuDiagCode", row.Code || "");
		},
		onChange: function(newValue, oldValue) {
			if (!newValue) {
				setValueById("InsuDiagCode", "");
			}
		}
	});
}

/**
 * Insu-获取医保就诊信息函数
 */
function getInsuAdmInfo() {
	if ($("#InsuInfo-Panel").length == 0) {
		return;
	}
	clearInsuPanel();
	var episodeId = getValueById("EpisodeID");
	if (!episodeId) {
		return;
	}
	var admReaStr = getAdmReasonInfo(episodeId);
	var admReaAry = admReaStr.split("^");
	var admReaId = admReaAry[0];
	var nationalCode = admReaAry[1];
	if (+nationalCode <= 0) {
		return;
	}
	$.m({
		ClassName: "web.DHCINSUIPReg",
		MethodName: "GetInfoByAdm",
		type: "GET",
		Paadm: episodeId
	}, function (rtn) {
		if (rtn.split("!")[0] != "1") {
			enableById("Btn-InsuReg");
			enableById("Btn-InsuRegCancel");
		} else {
			var myAry = rtn.split("!")[1].split("^");
			var actDesc = "";
			if (myAry[11] == "A") {
				actDesc = "已登记";
				disableById("Btn-InsuReg");
				enableById("Btn-InsuRegCancel");
				$("#InsuActFlag").css({"color": "green"});
			}
			if (myAry[11] == "O") {
				actDesc = "出院";
				disableById("Btn-InsuReg");
				disableById("Btn-InsuRegCancel");
			}
			if (myAry[11] == "S") {
				actDesc = "取消登记";
				enableById("Btn-InsuReg");
				disableById("Btn-InsuRegCancel");
				$("#InsuActFlag").css({"color": "red"});
			}
			setValueById("InsuActFlag", actDesc);           //医保登记状态
			setValueById("InsuNo", myAry[2]);               //医保号
			setValueById("InsuCardNo", myAry[3]);           //医保卡号
			
			setValueById("InsuType", myAry[18]);
			$("#InsuAdmType").combobox("reload").combobox("setValue", myAry[14]);    //医疗类别Combobox
			
			setValueById("InsuPatType", myAry[4]);          //人员类别
			
			$("#InsuDiagDesc").combogrid("grid").datagrid("loadData", {
				total: 1,
				rows: [{"Code": myAry[26], "Desc": myAry[27]}]
			});
			$("#InsuDiagDesc").combogrid("setValue", myAry[26]);   //医保诊断
			
			setValueById("InsuTreatType", myAry[36]);        //待遇类别
			setValueById("InsuAdmSeriNo", myAry[10]);        //医保就诊号
			
			//setValueById("xzlx", myAry[37]);               //险种类型
			//setValueById("InsuCenter", myAry[8]);          //医保统筹区
			//setValueById("ZLFS", myAry[38]);               //治疗方式
			//setValueById("BCFS", myAry[39]);               //补偿方式
		}
	});
}

/**
* 清空医保信息面板
*/
function clearInsuPanel() {
	enableById("Btn-InsuReg");
	enableById("Btn-InsuRegCancel");
	$("#InsuInfo-Panel").find(":text").val("");
	$("#InsuInfo-Panel").find(".combobox-f:not(#InsuType)").combobox("clear").combobox("loadData", []);
	$("#InsuInfo-Panel").find(".combogrid-f").each(function() {
    	$("#" + this.id).combogrid("clear").combogrid("grid").datagrid("loadData", {
			total: 0,
			rows: []
		});
  	});
}

/**
* 医保登记交互
*/
function insuReg() {
	var episodeId = getValueById("EpisodeID");
	if (!episodeId) {
		return;
	}
	var admReaStr = getAdmReasonInfo(episodeId);
	var admReaAry = admReaStr.split("^");
	var admReaId = admReaAry[0];
	var nationalCode = admReaAry[1];
	if (+nationalCode <= 0) {
		if (IPBILL_CONF.PARAM.RegLnkPayDep == "Y") {
			linkAddDepClick();
		}
		return;
	}
	
	//医保类型
	var insuType = getValueById("InsuType");
	//医疗类别
	var insuAdmType = getValueById("InsuAdmType");	
	if (!insuType || !insuAdmType) {
		if (IPBILL_CONF.PARAM.RegLnkPayDep == "Y") {
			linkAddDepClick();
		}
		return;
	}
	
	//医保号/医疗证号
	var insuNo = getValueById("InsuNo");

	//医保入院诊断编码
	var insuDiagCode = getValueById("InsuDiagCode");
	//医保入院诊断名称
	var insuDiagDesc = getValueById("InsuDiagDesc");

	//就诊日期
	var admDate = ""; //getValueById("AdmDate");

	//就诊时间
	var admTime = ""; //getValueById("AdmTime");

	//治疗方式
	var ZLFSStr = "";
	//var ZLFSStr = getValueById("ZLFS");

	//补偿方式
	var BCFSStr = "";
	//var BCFSStr = getValueById("BCFS");

	var tmpString = insuAdmType + "^" + insuDiagCode + "^" + insuDiagDesc + "^" + insuNo + "^" + admDate + "^" + admTime + "^" + ZLFSStr + "^" + BCFSStr + "^" + insuType
	
	tmpString = tmpString.replace(/undefined/g, "");   //替换所有的undefined
	
	//医保登记
	var flag = InsuIPReg(0, PUBLIC_CONSTANT.SESSION.USERID, episodeId, nationalCode, admReaId, tmpString); //DHCInsuPort.js
	var msg = (+flag < 0) ? ("医保登记失败：" + flag) : "医保登记成功";
	var iconCls = (+flag < 0) ? "error" : "success";
	$.messager.alert("提示", msg, iconCls, function() {
		//转到交押金界面(允许调用交押金程序)
		if (IPBILL_CONF.PARAM.RegLnkPayDep == "Y") {
			linkAddDepClick();
		}
	});
}