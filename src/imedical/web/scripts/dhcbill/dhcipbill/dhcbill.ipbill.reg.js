/**
 * FileName: dhcbill.ipbill.reg.js
 * Author: ZhYW
 * Date: 2019-03-27
 * Description: 住院登记
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkInsuInfo: {
		validator: function(value) {
			var insTypeId = getValueById("AdmReason");
			if (!insTypeId) {
				return false;
			}
			var nationalCode = getPropValById("PAC_AdmReason", insTypeId, "REA_NationalCode");
			return (nationalCode > 0);
		},
		message: $g("非医保患者不能输入医保信息")
	}
});

$(function () {
	$(document).keydown(function (e) {
		frameEnterKeyCode(e);
	});
	initDOMSeqConf();
	initPanelMenu();
});

/**
* 获取页面DOM元素跳转配置
*/
function initDOMSeqConf() {
	if (CV.Conf.DOMSEQAry.length == 0) {
		return saveDOMCahce();
	}
	
	$.each(CV.Conf.DOMSEQAry, function (index, item) {
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

/**
* 缓存DOM元素
*/
function saveDOMCahce() {
	var cacheObj = {};
	$(document).find("label[for]").each(function () {
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
		$.messager.alert("提示", "请先在【页面功能配置->住院登记】页面配置", "info");
	});
}

function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 13:
		//弹出alert/confirm提示框时，光标定位到"确定"按钮
		var bool = true;
		$(".messager-button>a .l-btn-text").each(function(index, item) {
			if ($.inArray($(this).text(), ["Ok", "确定"]) != -1) {
				$(this).parent().parent().trigger("focus");   //确定按钮聚焦
				bool = false;
				return false;
			}
		});
		if (bool) {
			focusNextEle(e.target.id);
		}
		break;
	case 117:
 		e.preventDefault();      //F6
 		regCancelClick();
		break;
	case 118:
		e.preventDefault();
		clearClick();           //F7
		break;
	case 120:
		e.preventDefault();
		regSaveClick();         //F9
		break;
	case 121:
		e.preventDefault();
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
	$.each(CV.Conf.DOMSEQAry, function (index, item) {
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
	for (var i = (myIdx + 1), len = CV.Conf.DOMSEQAry.length; i < len; i++) {
		id = CV.Conf.DOMSEQAry[i].id;
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
	
	//读医保卡
	$HUI.linkbutton("#Btn-ReadInsuCard", {
		onClick: function () {
			readInsuCardClick();
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
	$("#MenuWD>.menuitem").click(wristbandPrtClick);
	
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
	$("#BirthDate + .datebox .combo-text").keydown(function (e) {
		birthDateKeydown(e);
	});

	//新生儿年龄
	$("input[id^='BabyAge']").keydown(function (e) {
		babyAgeKeydown(e);
	});

	//身份证号
	$("#IDNo").keydown(function (e) {
		IDNoKeydown(e);
	});
	
	//证件号
	$("#CredNo").keydown(function (e) {
		credNoKeydown(e);
	});
	
	//修改绿色通道信息  +WangXQ 2023-03-17
	$HUI.linkbutton("#Btn-GreenRecUpdate", {
		onClick: function () {
			greenRecUpdateClick();
		}
	});

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
	//街道(出生)、街道(现住)、街道(户口)
	initStreet();
	//社区(出生)、社区(现住)、社区(户口)
	initCommunity();
	//地址(出生)、地址(现住)、地址(户口)
	//initAddress();
	
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
	//推荐医生
	initAdviseDoc();
	//入院途径
	initAdmSource();
	//入院情况
	initAdmCategory();
	//就诊子类
	initEpisSubType();
	//入院病情
	initAdmReferPriority();
	//初步诊断
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
	initMenuWDPrint();
	$(".combo-text, .spinner-text").keydown(function(e) {
		var key = websys_getKey(e);
		if (key == 13) {
			e.stopPropagation();
			return focusNextEle($(e.target).parents("td").find("input")[0].id);
		}
	});
	
	//设置默认
	setDefaultValue();
	
	var $tb = $("#More-container");
	var _narrow = function () {
		$tb.find(".arrows-b-text").text($g("更多"));
		$tb.find(".retract-b-up").removeClass("retract-b-up").addClass("spread-b-down");
		$("tr.display-more-tr").hide();
	}
	
	var _spread = function () {
		$tb.find(".arrows-b-text").text($g("收起"));
		$tb.find(".spread-b-down").removeClass("spread-b-down").addClass("retract-b-up");
		$("tr.display-more-tr").show();
	}
	
	var _setHeight = function () {
		var l = $tb.parents(".layout");
		var n = l.layout("panel", "north");
		var oldHeight = n.panel("panel").outerHeight();
		n.panel("resize", {height: "auto"});
		var newHeight = n.panel("panel").outerHeight();
		l.layout("resize", {height: (l.height() + newHeight - oldHeight)});
	}
	
	if ($(window).height() > CV.OuterHeight) {
		if ($tb.find(".arrows-b-text").text() == $g("更多")) {
			_spread();
			_setHeight();
		}
	}
	
	$tb.click(function () {
		if ($tb.find(".arrows-b-text").text() == $g("更多")) {
			_spread();
		} else {
			_narrow();
		}
	});

}

/**
* 页面的所有元素都加载完毕后
*/
$(window).load(function() {
	//住院证界面链接进来
	var IPBookID = getValueById("IPBookID");
	if (IPBookID) {
		getRegInfoByIPBook(IPBookID);
	} else if (CV.MrClass == "I") {
		//挂菜单进来
		var frm = dhcsys_getmenuform();
		if(frm && frm.PatientID.value) {
			$("#PatientNo").val(frm.PatientID.value);
			setValueById("MedicareNo", "");
			getPatInfo();
		}
	}
});

function initSex() {
	var opts = {
        panelHeight: 'auto',
		method: 'GET',
		url: $URL + '?ClassName=web.UDHCOPOtherLB&MethodName=ReadSex&JSFunName=GetSexToHUIJson',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 5
    };
    $("input[id$='Sex']").combobox(opts);
    
    $("#Sex").combobox($.extend(opts, {
            url: $URL+ '?ClassName=web.UDHCOPOtherLB&MethodName=ReadSex&JSFunName=GetSexToHUIJson',
            onLoadSuccess: function (data) {
                $("input[id$='Sex']:not(#Sex)").combobox("loadData", data);
            }
        }));
}

function initNation() {
	$HUI.combobox("#Nation", {
		panelHeight: 150,
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBL.CTBASEIF.ICTCardRegLB&MethodName=ReadBaseData&ResultSetType=array&TabName=CTNATION&QueryInfo=^^^HUIJSON',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 5
	});
}

function initCredType() {
    var opts = {
        panelHeight: 150,
        valueField: 'id',
        textField: 'text',
        blurValidValue: true,
        defaultFilter: 5
    };
	$("input[id$='CredType']").combobox(opts);
	
    $("#CredType").combobox($.extend(opts, {
            url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryCredType&ResultSetType=array',
            onLoadSuccess: function (data) {
                $("input[id$='CredType']:not(#CredType)").combobox("loadData", data);
            }
        }));
}

function initMarital() {
	$HUI.combobox("#Marital", {
		panelHeight: 150,
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBL.CTBASEIF.ICTCardRegLB&MethodName=ReadBaseData&ResultSetType=array&TabName=CTMarital&QueryInfo=^^^HUIJSON',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 5
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
		defaultFilter: 5,
		onSelect: function(rec) {
			//国籍/地区变化时，省(籍贯)随之变化，清空市(籍贯)
			var provUrl = getProvUrl(rec.id);
			$("#HomeProv").combobox("reload", provUrl).combobox("clear");
		},
		onChange: function(newValue, oldValue) {
			if (!newValue) {
				$("#HomeProv").combobox("clear").combobox("loadData", []);
			}
		}
	});
}

function initProvince() {
	$HUI.combobox("input[id$='Prov'], #Province", {
		panelHeight: 150,
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		selectOnNavigation: false,
		blurValidValue: true,
		defaultFilter: 5,
		onSelect: function (rec) {
			var cityId = getCityId($(this)[0].id);
			if (cityId) {
				var url = getCityUrl(rec.id);
				$("#" + cityId).combobox("clear").combobox("reload", url);
			}
			var areaId = getAreaId(cityId);
			if (areaId) {
				$("#" + areaId).combobox("clear").combobox("loadData", []);
			}
			var streetId = getStreetId(areaId);
			if (streetId) {
				$("#" + streetId).combobox("clear").combobox("loadData", []);
			}
			var communityId = getCommunityId(streetId);
			if (communityId) {
				$("#" + communityId).combobox("clear").combobox("loadData", []);
			}
		},
		onChange: function (newValue, oldValue) {
			if (!newValue) {
				var cityId = getCityId($(this)[0].id);
				if (cityId) {
					$("#" + cityId).combobox("clear").combobox("loadData", []);
				}
				var areaId = getAreaId(cityId);
				if (areaId) {
					$("#" + areaId).combobox("clear").combobox("loadData", []);
				}
				var streetId = getStreetId(areaId);
				if (streetId) {
					$("#" + streetId).combobox("clear").combobox("loadData", []);
				}
				var communityId = getCommunityId(streetId);
				if (communityId) {
					$("#" + communityId).combobox("clear").combobox("loadData", []);
				}
			}
		}
	});
}

function initCity() {
	$HUI.combobox("input[id$='City']", {
		panelHeight: 150,
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		selectOnNavigation: false,
		blurValidValue: true,
		defaultFilter: 5,
		onSelect: function (rec) {
			var areaId = getAreaId($(this)[0].id);
			if (areaId) {
				var url = getCityAreaUrl(rec.id);
				$("#" + areaId).combobox("clear").combobox("reload", url);
			}
			var streetId = getStreetId(areaId);
			if (streetId) {
				$("#" + streetId).combobox("clear").combobox("loadData", []);
			}
			var communityId = getCommunityId(streetId);
			if (communityId) {
				$("#" + communityId).combobox("clear").combobox("loadData", []);
			}
		},
		onChange: function (newValue, oldValue) {
			if (!newValue) {
				var areaId = getAreaId($(this)[0].id);
				if (areaId) {
					$("#" + areaId).combobox("clear").combobox("loadData", []);
				}
				var streetId = getStreetId(areaId);
				if (streetId) {
					$("#" + streetId).combobox("clear").combobox("loadData", []);
				}
				var communityId = getCommunityId(streetId);
				if (communityId) {
					$("#" + communityId).combobox("clear").combobox("loadData", []);
				}
			}
		}
	});
}

function initArea() {
	$HUI.combobox("input[id$='Area']", {
		panelHeight: 150,
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 5,
		onSelect: function (rec) {
			//取邮编
			var postCodeId = getPostCodeId($(this)[0].id);
			if (postCodeId != "") {
				setPostCode("", "", rec.id, postCodeId);
			}
			//获取街道数据
			var streetId = getStreetId($(this)[0].id);
			if (streetId) {
				var url = getStreetUrl(rec.id);
				$("#" + streetId).combobox("clear").combobox("reload", url);
			}
			var communityId = getCommunityId(streetId);
			if (communityId) {
				$("#" + communityId).combobox("clear").combobox("loadData", []);
			}
		},
		onChange: function (newValue, oldValue) {
			if (!newValue) {
				var streetId = getStreetId($(this)[0].id);
				if (streetId) {
					$("#" + streetId).combobox("clear").combobox("loadData", []);
				}
				var communityId = getCommunityId(streetId);
				if (communityId) {
					$("#" + communityId).combobox("clear").combobox("loadData", []);
				}
			}
		}
	});
}

/**
* 街道
*/
function initStreet() {
	$HUI.combobox("input[id$='Street']", {
		panelHeight: 150,
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 5,
		onSelect: function (rec) {
			var communityId = getCommunityId($(this)[0].id);
			if (communityId) {
				var url = getCommunityUrl(rec.id);
				$("#" + communityId).combobox("clear").combobox("reload", url);
			}
		},
		onChange: function (newValue, oldValue) {
			if (!newValue) {
				var communityId = getCommunityId($(this)[0].id);
				if (communityId) {
					$("#" + communityId).combobox("clear").combobox("loadData", []);
				}
			}
		}
	});
}

/**
* 社区
*/
function initCommunity() {
	$HUI.combobox("input[id$='Community']", {
		panelHeight: 150,
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 5
	});
}

function getCityId(provId) {
	if (provId == "Province") {
		return "City";
	}
	var cityId = "";
	$("input[id$='City']").each(function(index, itm) {
		if (itm.id == provId.replace(/Prov/, "City")) {
			cityId = itm.id;
			return false;
		}
	});
	return cityId;
}

function getAreaId(cityId) {
	if (cityId == "City") {
		return "CityArea";
	}
	var areaId = "";
	$("input[id$='Area']").each(function(index, itm) {
		if (itm.id == cityId.replace(/City/, "Area")) {
			areaId = itm.id;
			return false;
		}
	});
	return areaId;
}

function getStreetId(areaId) {
	if (areaId == "CityArea") {
		return "Street";
	}
	var streetId = "";
	$("input[id$='Street']").each(function(index, itm) {
		if (itm.id == areaId.replace(/Area/, "Street")) {
			streetId = itm.id;
			return false;
		}
	});
	return streetId;
}

function getCommunityId(streetId) {
	var communityId = "";
	$("input[id$='Community']").each(function(index, itm) {
		if (itm.id == streetId.replace(/Street/, "Community")) {
			communityId = itm.id;
			return false;
		}
	});
	return communityId;
}

function getPostCodeId(areaId) {
	if (areaId == "CityArea") {
		return "PostCode";
	}
	var postCodeId = "";
	$("input[id$='PostCode']").each(function(index, itm) {
		if (itm.id == areaId.replace(/Area/, "PostCode")) {
			postCodeId = itm.id;
			return false;
		}
	});
	return postCodeId;
}

/**
* 地址
*/
function initAddress() {
	$HUI.lookup("#Address, #BirthAddress, #HouseAddress", {
		panelWidth: 350,
		isCombo: true,
		minQueryLen: 2,
		fitColumns: true,
		singleSelect: true,
		pagination: true,
		showPageList: false,
		displayMsg: '',
		delay: 300,
		mode: 'remote',
		idField: 'provid',
		textField: 'provdesc',
		columns:[[
		    {field: 'provdesc', title:'地址', width: 330},
			{field: 'provid', hidden: true},
			{field: 'AddressIDStr', hidden: true}
		]],
		url: $URL,
		queryParams: {
			ClassName: "web.DHCBL.CTBASEIF.ICTCardRegLB",
			QueryName: "admaddressNewlookup"
		},
		onBeforeLoad: function(param) {
			param.desc = param.q;
			return true;
		},
		onBeforeShowPanel: function(){
			if (!$.trim($(this).val())) {
				return false;
			}
		}
	});
	
	var _getSelectedAddrAry = function(row) {
		var adddressIDStr = row.AddressIDStr;  //国家Id^省Id^市Id^区县Id^社区Id
		if (!adddressIDStr) {
			return [];
		}
		return adddressIDStr.split("^");
	};
	
	$.extend($HUI.lookup("#Address").options(), {
		onSelect: function(index, row) {
			var myAry = _getSelectedAddrAry(row);
			if (myAry.length == 0) {
				return true;
			}
			var countryId = myAry[0];
			var provId = myAry[1];
			var cityId = myAry[2];
			var cityAreaId = myAry[3];
			var communityId = myAry[4];   //社区
			var streetId = myAry[5];      //街道 2022-09-05 ZhYW
			//省(现住)
			setValueById("Province", provId);
			//市(现住)
			var url = getCityUrl(provId);
			$("#City").combobox("reload", url).combobox("setValue", cityId);
			//区县(现住)
			var url = getCityAreaUrl(cityId);
			$("#CityArea").combobox("reload", url).combobox("setValue", cityAreaId);
			//2022-09-05 ZhYW 街道(现住)
			setValueById("Street", streetId);
			//邮编(现住)
			setPostCode("", "", cityAreaId, "PostCode");
		}
	});
	
	$.extend($HUI.lookup("#BirthAddress").options(), {
		onSelect: function(index, row) {
			var myAry = _getSelectedAddrAry(row);
			if (myAry.length == 0) {
				return true;
			}
			var countryId = myAry[0];
			var provId = myAry[1];
			var cityId = myAry[2];
			var cityAreaId = myAry[3];
			var communityId = myAry[4];   //社区
			var streetId = myAry[5];      //街道 2022-09-05 ZhYW
			//省(出生)
			setValueById("BirthProv", provId);
			//市(出生)
			var url = getCityUrl(provId);
			$("#BirthCity").combobox("reload", url).combobox("setValue", cityId);
			//县(出生)
			var url = getCityAreaUrl(cityId);
			$("#BirthArea").combobox("reload", url).combobox("setValue", cityAreaId);
			//2022-09-05 ZhYW 街道(出生)
			setValueById("BirthStreet", streetId);
		}
	});
	
	$.extend($HUI.lookup("#HouseAddress").options(), {
		onSelect: function(index, row) {
			var myAry = _getSelectedAddrAry(row);
			if (myAry.length == 0) {
				return true;
			}
			var countryId = myAry[0];
			var provId = myAry[1];
			var cityId = myAry[2];
			var cityAreaId = myAry[3];
			var communityId = myAry[4];   //社区
			var streetId = myAry[5];      //街道 2022-09-05 ZhYW
			//省(户口)
			setValueById("HouseProv", provId);
			//市(户口)
			var url = getCityUrl(provId);
			$("#HouseCity").combobox("reload", url).combobox("setValue", cityId);
			//县(户口)
			var url = getCityAreaUrl(cityId);
			$("#HouseArea").combobox("reload", url).combobox("setValue", cityAreaId);
			//2022-09-05 ZhYW 街道(户口)
			setValueById("HouseStreet", streetId);
			//邮编(户口)
			setPostCode("", "", cityAreaId, "HousePostCode");
		}
	});
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
		defaultFilter: 5
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
		defaultFilter: 5
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
		defaultFilter: 5
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
				   {field: 'admDate', title: '就诊时间', width: 150,
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
			if (!getValueById("IPBookID") && ($.hisui.indexOfArray(data.rows, "admId", getValueById("EpisodeID")) == -1)) {
				clearAdmPanel();
			}
			setValueById("AdmList", ((data.total > 0) ? getValueById("EpisodeID") : ""));
		},
		onSelect: function (index, row) {
			if (row.admId != getValueById("EpisodeID")) {
				selectAdmListHandler(row.admId);
			}
		}
	});
}

function selectAdmListHandler(episodeId) {
	var admJson = getAdmJson(episodeId);
	setAdmInfo(admJson);
	getInsuAdmInfo(episodeId);        //获取医保登记信息
}

function getAdmJson(episodeId) {
	return $.cm({ClassName: "web.DHCIPBillReg", MethodName: "GetAdmInfo", type: "GET", episodeId: episodeId, sessionStr: getSessionStr()}, false);
}

/**
* 清空就诊信息面板
*/
function clearAdmPanel() {
	$("#MRDiagList").empty().css({cursor: "default"}).tooltip("destroy");   //+2023-01-18 ZhYW
	$("#AdmInfo-Panel :text:not(.combo-text),#AdmInfo-Panel textarea").val("");
	$("#AdmInfo-Panel .numberbox-f").numberbox("clear");
	$("#AdmInfo-Panel .combobox-f:not(#AdmReason)").combobox("clear");
	$("#Ward,#Doctor,#AdmDiagnos,#AdviseDoc").combobox("loadData", []);
	$("#AdmDiagnos").combobox("enable");
	$("#DiagRemark").prop("disabled", false);
	$("#AdmSource,#AdmCategory,#EpisSubType,#AdmReferPriority,#RegConDisc").combobox("reload");
	//若科室/病区/医生未设置为禁用，将其设置为可用
	$.each(CV.Conf.DOMSEQAry, function (index, item) {
		if (($.inArray(item.id, ["Dept", "Ward", "Doctor"]) != -1) && !item.disabled) {
			enableById(item.id);
		}
	});
	
	var USERNAME = $.m({ClassName: "User.SSUser", MethodName: "GetTranByDesc", Prop: "SSUSRName", Desc: PUBLIC_CONSTANT.SESSION.USERNAME, LangId: PUBLIC_CONSTANT.SESSION.LANGID}, false);
	setValueById("User", USERNAME);
	var curDateTime = getCurDateTime();
	var myAry = curDateTime.split(/\s+/);
	setValueById("AdmDate", myAry[0]);
	setValueById("AdmTime", myAry[1]);
}

function initAdmReason() {
	$HUI.combobox("#AdmReason", {
		panelHeight: 150,
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryGrpAdmReason&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 5,
		onBeforeLoad: function (param) {
			param.groupId = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		onSelect: function (rec) {
			$("#InsuInfo-Panel").find(".validatebox-text").each(function() {
				$(this).validatebox("isValid");
			});
		}
	});
}

function initDept() {
	$HUI.combobox("#Dept", {
		panelHeight: 150,
		method: 'GET',
		url: $URL + '?ClassName=web.DHCIPBillReg&QueryName=FindIPDept&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		selectOnNavigation: false,
		blurValidValue: true,
		defaultFilter: 5,
		filter: function(q, row) {
			var opts = $(this).combobox("options");
			var mCode = false;
			if (row.contactName) {
				mCode = row.contactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
			return mCode || mValue;
		},
		onSelect: function (rec) {
			//病区
			loadWardDataByDept(rec.id, "");
			//入院医生
			loadDoctorDataByDept(rec.id);
		},
		onChange: function (newValue, oldValue) {
			if (!newValue) {
				$("#Ward, #Doctor").combobox("clear").combobox("loadData", []);
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
		defaultFilter: 5
	});
}

function initDoctor() {
	$HUI.combobox("#Doctor", {
		panelHeight: 150,
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 5
	});
}

/**
* 2022-08-30
* ZhYW
* 推荐医生
*/
function initAdviseDoc() {
	$HUI.combobox("#AdviseDoc", {
		panelHeight: 150,
		mode: 'remote',
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		delay: 300,
		blurValidValue: true,
		defaultFilter: 5,
		onBeforeLoad: function (param) {
			if ($.trim(param.q).length > 1) {
				$.extend($(this).combobox("options"), {url: $URL});
				param.ClassName = "web.DHCBillOtherLB";
				param.QueryName = "QryDoctor";
				param.ResultSetType = "array";
				param.desc = param.q;
				param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID
			}
		}
	});
}

function initAdmSource() {
	$HUI.combobox("#AdmSource", {
		panelHeight: 'auto',
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryInAdmSource&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 5
	});
}

function initAdmCategory() {
	$HUI.combobox("#AdmCategory", {
		panelHeight: 'auto',
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryAdmCategory&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 5,
		onChange : function(newValue, oldValue){
			var admCateCode = getPropValById("PAC_AdmCategory", newValue, "ADMCAT_Code");
			if (admCateCode != "01") {
				disableById("Btn-GreenRecUpdate");
			}else{
				enableById("Btn-GreenRecUpdate");
			}
		}
	});
}

function initEpisSubType() {
	$HUI.combobox("#EpisSubType", {
		panelHeight: 'auto',
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryEpisSubType&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 5
	});
}

function initAdmReferPriority() {
	$HUI.combobox("#AdmReferPriority", {
		panelHeight: 'auto',
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryRefPriority&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 5
	});
}

function initAdmDiag() {
	$HUI.combobox("#AdmDiagnos", {
		panelHeight: 150,
		mode: 'remote',
		method: 'GET',
		valueField: 'DiagRowID',
		textField: 'DiagDesc',
		delay: 300,
		blurValidValue: true,
		defaultFilter: 5,
		onBeforeLoad: function (param) {
			if ($.trim(param.q).length > 1) {
				$.extend($(this).combobox("options"), {url: $URL});
				param.ClassName = "BILL.COM.MRDiagnos";
				param.QueryName = "FindMRDiagnos";
				param.ResultSetType = "array";
				param.alias = param.q;
				param.sessionStr = getSessionStr()
			}
		}
	});
}

function initRegConDisc() {
	$HUI.combobox("#RegConDisc", {
		panelHeight: 150,
		method: 'GET',
		url: $URL + '?ClassName=web.DHCRegConDisCount&MethodName=ReadDHCRegConDisCountBroker&JSFunName=GetRegConToHUIJson&HospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 5
	});
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	if ($("#Btn-ReadCard").linkbutton("options").disabled) {
		return;
	}
	$("#Btn-ReadCard").linkbutton("toggleAble");
	DHCACC_GetAccInfo7(magCardCallback);
}

function cardNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var cardNo = getValueById("CardNo");
		if (!cardNo) {
			return;
		}
		DHCACC_GetAccInfo("", cardNo, "", "", magCardCallback);
	}
}

/**
 * 读医保卡
 */
function readInsuCardClick() {
	if ($("#Btn-ReadInsuCard").linkbutton("options").disabled) {
		return;
	}
	$("#Btn-ReadInsuCard").linkbutton("toggleAble");
	var rtn = InsuReadCard(0, PUBLIC_CONSTANT.SESSION.USERID, "", "", "00A^^^");
	var myAry = rtn.split("|");
	if (myAry[0] == 0) {
		var insuReadInfo = myAry[1];
		var insuReadAry = insuReadInfo.split("^");
		var insuCardNo = insuReadAry[1];	//医保卡号
		var credNo = insuReadAry[7];	    //身份证号
		$("#CardNo").val(credNo);
		if (credNo != "") {
			DHCACC_GetAccInfo("", credNo, "", "", magCardCallback);
		}
	}
}

function magCardCallback(rtnValue) {
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("PatientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		break;
	case "-200":
		$.messager.alert("提示", "卡无效", "info", function () {
			focusById("CardNo");
		});
		break;
	case "-201":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("PatientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		break;
	default:
	}
	
	if (patientId != "") {
		getPatInfo();
	}
}

/**
* 查询
*/
function findClick() {
	var name = charTransAsc(getValueById("Name"));    //把汉字转化为ASCII码
	var url = "dhcbill.ipbill.patientinfo.csp?Name=" + name + "&PatientNo=" + getValueById("PatientNo") + "&IDNo=" + getValueById("IDNo") + "&BirthDate=" + getValueById("BirthDate") + "&HealthFundNo=" + getValueById("HealthFundNo");
	websys_showModal({
		url: url,
		title: "患者信息查询",
		iconCls: "icon-w-find",
		callbackFunc: switchPatient
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
	if ($("#Btn-ReadIDCard").linkbutton("options").disabled) {
		return;
	}
	$("#Btn-ReadIDCard").linkbutton("toggleAble");
	try {
		var myHCTypeDR = "1";
		var myInfo = DHCWCOM_PersonInfoRead(myHCTypeDR);
		//测试串
		//var myInfo = "0^<IDRoot><Age>55</Age><Name>***</Name><Sex>1</Sex><NationDesc>汉</NationDesc><Birth>19620817</Birth><Address>湖南省岳阳市岳阳楼区七里山社区居委会*区**栋***号</Address><CredNo>430105196208171015</CredNo><PhotoInfo></PhotoInfo></IDRoot>"
		var myAry = myInfo.split("^");
		if ((myAry.length > 1) && (myAry[0] == 0)) {
			var IDCardXML = myAry[1];
			var IDObj = new X2JS().xml_str2json(IDCardXML).IDRoot;
			
			var IDNo = IDObj["CredNo"];
			setValueById("IDNo", IDNo);   //身份证号
			setValueById("Name", IDObj["Name"]);
			
			getInfoBasedIDCard(IDNo);
			
			$.m({
				ClassName: "web.UDHCJFCOMMON",
				MethodName: "GetNationId",
				desc: IDObj["NationDesc"]
			}, function(nationId) {
				setValueById("Nation", nationId);
			});
			setValueById("Address", IDObj["Address"]);
			
			var photoStream = IDObj["PhotoInfo"];
			setValueById("PhotoInfo", photoStream);
			
			//显示照片
			var src = "";
			if (photoStream) {
				src = "data:image/png;base64," + photoStream;
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

function getPatInfo() {
	clearHideEle();
	
	var patientId = getPatIDByPatNo(getValueById("PatientNo"), getValueById("MedicareNo"));
	if (!patientId) {
		return getRegInfo();
	}
	var admitEpisodeId = getAdmitEpisodeID(patientId);
	if (admitEpisodeId > 0) {
		return getRegInfo();     //在院患者不再查询住院证
	}
	//有效的住院证
	var rtn = getIPBKNum(patientId);
	var myAry = rtn.split("^");
	var bookNum = myAry[0];
	var bookId = myAry[1];
	if (!(bookNum > 0)) {
		return getRegInfo();
	}
	$.messager.confirm("确认", "患者存在有效住院证，是否使用住院证办理？", function (r) {
		if (!r) {
			return getRegInfo();
		}
		if (bookNum == 1) {
			setValueById("IPBookID", bookId);
			return getRegInfo();
		}
		var url = "doc.ipbookquery.hui.csp?PatientID=" + patientId + "&UDHCJFFlag=Y";
		websys_showModal({
			url: url,
			title: "住院证",
			iconCls: "icon-w-list",
			callbackFunc: getRegInfoByIPBook
		});
	});
}

/**
* 根据登记号/病案号获取患者主索引
*/
function getPatIDByPatNo(patientNo, medicareNo) {
	return $.m({ClassName: "web.DHCIPBillReg", MethodName: "GetPatientID", patientNo: patientNo, medicareNo: medicareNo, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
}

/**
* 获取有效的住院证
*/
function getIPBKNum(patientId) {
	return $.m({ClassName: "web.DHCDocIPBookingCtl", MethodName: "GetIPBKNum", PatID: patientId, ActiveFlag: "", LogonHospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
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
		MethodName: "GetRegInfoToHtml",
		type: "GET",
		patientNo: getValueById("PatientNo"),
		medicareNo: getValueById("MedicareNo"),
		IPBookId: getValueById("IPBookID"),
		sessionStr: getSessionStr()
	}, function (json) {
		if (json.success == 0) {
			var patJson = JSON.parse(json.PatInfo);
			var admJson = JSON.parse(json.AdmInfo);
			var IPBookJson = JSON.parse(json.IPBookInfo);

			setPatInfo(patJson);
			if (admJson.EpisodeID) {
				setAdmInfo(admJson);
				getInsuAdmInfo(admJson.EpisodeID);       //获取医保登记信息
			}else {
				setDefAdmReason();      //设置患者默认费别
				//有住院证时获取住院证信息
				if (IPBookJson.IPBookID) {
					setIPBookingInfo(IPBookJson);
				}
			}
			loadAdmList();          //加载就诊列表
			disableEle();
			return;
		}
		$.messager.alert("提示", json.msg, "info", function() {
			if (websys_showModal("options")) {
				websys_showModal("close");
			}
		});
	});
}

function setPatInfo(patJson) {
	if (patJson.success != 0) {
		$.messager.popover({msg: patJson.msg, type: "info"});
		return;
	}

	//WangXQ 清空患者医保信息面板 20230329
	if ($("#InsuInfo-Panel").length != 0) {
		clearInsuPanel();
	}

	setValueById("PatientID", patJson.PatientID);
	setValueById("PatientNo", patJson.PatientNo);
	setValueById("Name", patJson.Name);
	setValueById("MedicareNo", patJson.MedicareNo);
	setValueById("Sex", patJson.Sex);
	setValueById("IDNo", patJson.IDNo);             //身份证号
	setValueById("Age", patJson.Age);
	setValueById("AgeYear", patJson.AgeYear);       //+2022-12-13 ZhYW 患者年龄(岁)
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
	
	var provUrl = getProvUrl(patJson.Country);
	//省(籍贯)
	$("#HomeProv").combobox("reload", provUrl).combobox("setValue", patJson.HomeProv);
	//市(籍贯)
	var url = getCityUrl(patJson.HomeProv);
	$("#HomeCity").combobox("reload", url).combobox("setValue", patJson.HomeCity);
	//县(籍贯)
	var url = getCityAreaUrl(patJson.HomeCity);
	$("#HomeArea").combobox("reload", url).combobox("setValue", patJson.HomeArea);
	//省(现住)
	$("#Province").combobox("reload", provUrl).combobox("setValue", patJson.Province);
	//市(现住)
	var url = getCityUrl(patJson.Province);
	$("#City").combobox("reload", url).combobox("setValue", patJson.City);			
	//区县(现住)
	var url = getCityAreaUrl(patJson.City);
	$("#CityArea").combobox("reload", url).combobox("setValue", patJson.CityArea);
	//街道(现住)
	var url = getStreetUrl(patJson.CityArea);
	$("#Street").combobox("reload", url).combobox("setValue", patJson.Street);
	//社区(现住)
	var url = getCommunityUrl(patJson.Street);
	$("#Community").combobox("reload", url).combobox("setValue", patJson.Community);
	setValueById("Address", patJson.Address);     //地址(现住)
	setValueById("PostCode", patJson.PostCode);   //邮编(现住)
	//省(出生)
	$("#BirthProv").combobox("reload", provUrl).combobox("setValue", patJson.BirthProv);
	//市(出生)
	var url = getCityUrl(patJson.BirthProv);
	$("#BirthCity").combobox("reload", url).combobox("setValue", patJson.BirthCity);
	//县(出生)
	var url = getCityAreaUrl(patJson.BirthCity);
	$("#BirthArea").combobox("reload", url).combobox("setValue", patJson.BirthArea);
	//街道(出生)
	var url = getStreetUrl(patJson.BirthArea);
	$("#BirthStreet").combobox("reload", url).combobox("setValue", patJson.BirthStreet);
	//社区(出生)
	var url = getCommunityUrl(patJson.BirthStreet);
	$("#BirthCommunity").combobox("reload", url).combobox("setValue", patJson.BirthCommunity);
	setValueById("BirthAddress", patJson.BirthAddress);         //地址(出生)
	setValueById("CompanyPostCode", patJson.CompanyPostCode);   //邮编(工作)
	//省(户口)
	$("#HouseProv").combobox("reload", provUrl).combobox("setValue", patJson.HouseProv);
	//市(户口)
	var url = getCityUrl(patJson.HouseProv);
	$("#HouseCity").combobox("reload", url).combobox("setValue", patJson.HouseCity);
	//县(户口)
	var url = getCityAreaUrl(patJson.HouseCity);
	$("#HouseArea").combobox("reload", url).combobox("setValue", patJson.HouseArea);
	//街道(户口)
	var url = getStreetUrl(patJson.HouseArea);
	$("#HouseStreet").combobox("reload", url).combobox("setValue", patJson.HouseStreet);
	//地址(户口)
	var url = getCommunityUrl(patJson.HouseStreet);
	$("#HouseCommunity").combobox("reload", url).combobox("setValue", patJson.HouseCommunity);
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
	
	var photoStream = getPropValById("PA_Person", patJson.PatientID, "PAPER_Photo");
	setValueById("PhotoInfo", photoStream);      //照片信息(Base64编码串)
	var src = photoStream ? ("data:image/png;base64," + photoStream) : "../images/uiimages/patdefault.png";
	ShowPicBySrcNew(src, "ImgPic");    //显示照片
}

/**
* 获取患者住院证信息
*/
function setIPBookingInfo(IPBookJson) {
	if (IPBookJson.success != 0) {
		$.messager.popover({msg: IPBookJson.msg, type: "info"});
		return;
	}
	setValueById("EpisodeID", IPBookJson.EpisodeID);
	setValueById("VisitStatus", IPBookJson.VisitStatus);
	//科室
	setDeptValue(IPBookJson.Dept);
	
	var allowEditDept = isChangeDept();    //用住院证登记时是否可更改入院科室
	if (IPBookJson.Dept && !allowEditDept) {
		disableById("Dept");
	}
	
	//病区
	loadWardDataByDept(IPBookJson.Dept, IPBookJson.IPBookID, IPBookJson.Ward);
	if (IPBookJson.Ward && !allowEditDept) {
		disableById("Ward");
	}
	
	//入院医生
	loadDoctorDataByDept(IPBookJson.Dept, IPBookJson.Doctor);
	if (IPBookJson.Doctor) {
		disableById("Doctor");
	}
	
	if (IPBookJson.AdmDate) {
		setValueById("AdmDate", IPBookJson.AdmDate);
	}
	if (IPBookJson.AdmTime) {
		setValueById("AdmTime", IPBookJson.AdmTime);
	}
	setValueById("SuggestDepAmt", IPBookJson.SuggestDepAmt);        //建议押金
	setValueById("AdmSource", IPBookJson.AdmSource);                //入院途径
	setValueById("AdmReferPriority", IPBookJson.AdmReferPriority);  //入院病情(病危、危重、危急)			

	//推荐医生
	setAdviseDocValue(IPBookJson.AdviseDoc);
	
	getDiagListByIPBook(IPBookJson.IPBookID);   //2023-01-18 ZhYW 根据住院证获取门诊诊断
	
	if (!IPBookJson.EditMRDiag) {
		//将初步诊断和诊断备注清空且禁用
		$("#AdmDiagnos").combobox("clear").combobox("loadData", []).combobox("disable");
		$("#DiagRemark").val("").prop("disabled", true);
	}else {
		$("#AdmDiagnos").combobox("enable");
		$("#DiagRemark").prop("disabled", false);
	}
}

/**
* 获取患者默认费别
*/
function setDefAdmReason() {
	$.m({
		ClassName: "web.DHCIPBillReg",
		MethodName: "GetPatDefInsTypeId",
		patientId: getValueById("PatientID"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(admReaId) {
		if (admReaId) {
			setAdmReasonValue(admReaId);
		}
	});
}

/**
* 设置默认
*/
function setDefaultValue() {
	//默认现住地址信息
	var regDefObj = new X2JS().xml_str2json(CV.PatUIDefXMLStr).DHCCardRegInfoDefault;
	var url = $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryCountry&ResultSetType=array&type=GET&desc=";
	$("#Country").combobox("reload", url).combobox("setValue", regDefObj.CountryDescLookUpRowID);
	//+2023-04-20 ZhYW
	var addrDefAry = CV.AddrDef.split(",");
	if ($.inArray("籍贯", addrDefAry) == -1) {
		addrDefAry.push("籍贯");
	}
	var provUrl = getProvUrl(regDefObj.CountryDescLookUpRowID);
	var cityUrl = getCityUrl(regDefObj.ProvinceInfoLookUpRowID);
	var areaUrl = getCityAreaUrl(regDefObj.CityDescLookUpRowID);
	$("input[id$='Prov'], #Province").combobox("reload", provUrl);
	if ($.inArray("籍贯", addrDefAry) != -1) {
		//省(籍贯)
		$("#HomeProv").combobox("setValue", regDefObj.ProvinceInfoLookUpRowID);
		//市(籍贯)
		$("#HomeCity").combobox("reload", cityUrl).combobox("setValue", regDefObj.CityDescLookUpRowID);
		//县(籍贯)
		$("#HomeArea").combobox("reload", areaUrl);
	}
	if ($.inArray("现住", addrDefAry) != -1) {
		//省(现住)
		$("#Province").combobox("setValue", regDefObj.ProvinceInfoLookUpRowID);
		//市(现住)
		$("#City").combobox("reload", cityUrl).combobox("setValue", regDefObj.CityDescLookUpRowID);
		//县(现住)
		$("#CityArea").combobox("reload", areaUrl);
	}
	if ($.inArray("出生", addrDefAry) != -1) {
		//省(出生)
		$("#BirthProv").combobox("setValue", regDefObj.ProvinceInfoLookUpRowID);
		//市(出生)
		$("#BirthCity").combobox("reload", cityUrl).combobox("setValue", regDefObj.CityDescLookUpRowID);
		//县(出生)
		$("#BirthArea").combobox("reload", areaUrl);
	}
	if ($.inArray("户口", addrDefAry) != -1) {
		//省(户口)
		$("#HouseProv").combobox("setValue", regDefObj.ProvinceInfoLookUpRowID);
		//市(户口)
		$("#HouseCity").combobox("reload", cityUrl).combobox("setValue", regDefObj.CityDescLookUpRowID);
		//县(户口)
		$("#HouseArea").combobox("reload", areaUrl);
	}
	//默认就诊信息
	var USERNAME = $.m({ClassName: "User.SSUser", MethodName: "GetTranByDesc", Prop: "SSUSRName", Desc: PUBLIC_CONSTANT.SESSION.USERNAME, LangId: PUBLIC_CONSTANT.SESSION.LANGID}, false);
	setValueById("User", USERNAME);
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

function setAdmInfo(admJson) {
	if (admJson.success != 0) {
		$.messager.popover({msg: admJson.msg, type: "info"});
		return;
	}
	setValueById("MedicareNo", admJson.MedicareNo);
	setValueById("EpisodeID", admJson.EpisodeID);
	setValueById("VisitStatus", admJson.VisitStatus);
	setValueById("InPatTimes", admJson.InPatTimes);     //住院次数
	
	//科室
	setDeptValue(admJson.Dept);
	
	//病区
	var IPBookId = getValueById("IPBookID");
	loadWardDataByDept(admJson.Dept, IPBookId, admJson.Ward);
	
	//入院医生
	loadDoctorDataByDept(admJson.Dept, admJson.Doctor);

	//就诊费别
	setAdmReasonValue(admJson.AdmReason);
	
	//就诊子类
	setValueById("EpisSubType", admJson.EpisSubType);
	//入院情况
	setValueById("AdmCategory", admJson.AdmCategory);

	setValueById("AdmDate", admJson.AdmDate);
	setValueById("AdmTime", admJson.AdmTime);
	//操作员
	setValueById("User", admJson.User);
	//入院途径
	setValueById("AdmSource", admJson.AdmSource);
	//入院病情(病危、危重、危急)
	setValueById("AdmReferPriority", admJson.AdmReferPriority);
	//初步诊断
	setDiagnosValue(admJson.AdmDiagnos);
	//诊断类型
	setValueById("DiagnosType", admJson.DiagnosType);
	//诊断备注
	setValueById("DiagRemark", admJson.DiagRemark);
	//优惠类型
	setRegConDiscValue(admJson.RegConDisc);
	//推荐医生
	setAdviseDocValue(admJson.AdviseDoc);
	//+2022-09-02 ZhYW 就诊备注(患者便签)
	setValueById("AdmRemark", admJson.AdmRemark);
	if (!(IPBookId > 0)) {
		getDiagListByAdm(admJson.EpisodeID);   //2023-01-18 ZhYW 根据住院就诊获取诊断
	}
	if (!admJson.EditMRDiag) {
		//将初步诊断和诊断备注清空且禁用
		$("#AdmDiagnos").combobox("clear").combobox("loadData", []).combobox("disable");
		$("#DiagRemark").val("").prop("disabled", true);
	}else {
		$("#AdmDiagnos").combobox("enable");
		$("#DiagRemark").prop("disabled", false);
	}
}

function setDeptValue(deptId) {
	var data = $("#Dept").combobox("getData");
	if (deptId && !$.hisui.getArrayItem(data, "id", deptId)) {
		var dept = getPropValById("CT_Loc", deptId, "CTLOC_Desc");
		var item = {id: deptId, text: dept};
		$.hisui.addArrayItem(data, "id", item);
		$("#Dept").combobox("loadData", data).combobox("setValue", deptId);
		return;
	}
	setValueById("Dept", (deptId || ""));
}

/**
* 根据科室加载病区数据
*/
function loadWardDataByDept(deptId, IPBookId, defaultId) {
	$.cm({
		ClassName: "web.DHCIPBillReg",
		QueryName: "FindWard",
		ResultSetType: "array",
		deptId: deptId,
		IPBookId: IPBookId
	}, function(data) {
		if (defaultId && !$.hisui.getArrayItem(data, "id", defaultId)) {
			var text = getPropValById("PAC_Ward", defaultId, "WARD_Desc");
			text = $.m({ClassName: "User.PACWard", MethodName: "GetTranByDesc", Prop: "WARDDesc", Desc: text, LangId: PUBLIC_CONSTANT.SESSION.LANGID}, false);
			var item = {id: defaultId, text: text};
			$.hisui.addArrayItem(data, "id", item);
		}else if (data.length == 1) {
			defaultId = data[0].id;
		};
		$("#Ward").combobox("loadData", data).combobox("setValue", (defaultId || ""));
	});
}

/**
* 根据科室加载入院医生数据
*/
function loadDoctorDataByDept(deptId, defaultId) {
	$.cm({
		ClassName: "web.DHCBillOtherLB",
		QueryName: "QryDeptDoctor",
		ResultSetType: "array",
		deptId: deptId,
		desc: ""
	}, function(data) {
		if (defaultId && !$.hisui.getArrayItem(data, "id", defaultId)) {
			var text = getPropValById("CT_CareProv", defaultId, "CTPCP_Desc");
			text = $.m({ClassName: "User.CTCareProv", MethodName: "GetTranByDesc", Prop: "CTPCPDesc", Desc: text, LangId: PUBLIC_CONSTANT.SESSION.LANGID}, false);
			var item = {id: defaultId, text: text};
			$.hisui.addArrayItem(data, "id", item);
		}else if (data.length == 1) {
			defaultId = data[0].id;
		};
		$("#Doctor").combobox("loadData", data).combobox("setValue", (defaultId || ""));
	});
}

function setAdmReasonValue(admReaId) {
	var data = $("#AdmReason").combobox("getData");
	if (admReaId && !$.hisui.getArrayItem(data, "id", admReaId)) {
		var text = getPropValById("PAC_AdmReason", admReaId, "REA_Desc");
		text = $.m({ClassName: "User.PACAdmReason", MethodName: "GetTranByDesc", Prop: "READesc", Desc: text, LangId: PUBLIC_CONSTANT.SESSION.LANGID}, false);
		var item = {id: admReaId, text: text};
		$.hisui.addArrayItem(data, "id", item);
		$("#AdmReason").combobox("loadData", data).combobox("setValue", admReaId);
		return;
	}
	setValueById("AdmReason", (admReaId || ""));
}

function setRegConDiscValue(discId) {
	var data = $("#RegConDisc").combobox("getData");
	if (discId && !$.hisui.getArrayItem(data, "id", discId)) {
		var text = getPropValById("DHC_RegConDisCount", discId, "RCD_Desc");
		text = $.m({ClassName: "User.DHCRegConDisCount", MethodName: "GetTranByDesc", Prop: "RCDDesc", Desc: text, LangId: PUBLIC_CONSTANT.SESSION.LANGID}, false);
		var item = {id: discId, text: text};
		$.hisui.addArrayItem(data, "id", item);
		$("#RegConDisc").combobox("loadData", data).combobox("setValue", discId);
		return;
	}
	setValueById("RegConDisc", (discId || ""));
}

/**
* 初步诊断
*/
function setDiagnosValue(diagId) {
	var data = $("#AdmDiagnos").combobox("getData");
	if (diagId && !$.hisui.getArrayItem(data, "DiagRowID", diagId)) {
		var text = getPropValById("MRC_ICDDx", diagId, "MRCID_Desc");
		text = $.m({ClassName: "User.MRCICDDx", MethodName: "GetTranByDesc", Prop: "MRCIDDesc", Desc: text, LangId: PUBLIC_CONSTANT.SESSION.LANGID}, false);
		var item = {DiagRowID: diagId, DiagDesc: text};
		$.hisui.addArrayItem(data, "DiagRowID", item);
		$("#AdmDiagnos").combobox("loadData", data).combobox("setValue", diagId);
		return;
	}
	setValueById("AdmDiagnos", (diagId || ""));
}

/**
* 2022-08-30
* ZhYW
* 推荐医生
*/
function setAdviseDocValue(docId) {
	var data = $("#AdviseDoc").combobox("getData");
	if (docId && !$.hisui.getArrayItem(data, "id", docId)) {
		var text = getPropValById("CT_CareProv", docId, "CTPCP_Desc");
		text = $.m({ClassName: "User.CTCareProv", MethodName: "GetTranByDesc", Prop: "CTPCPDesc", Desc: text, LangId: PUBLIC_CONSTANT.SESSION.LANGID}, false);
		var item = {id: docId, text: text};
		$.hisui.addArrayItem(data, "id", item);
		$("#AdviseDoc").combobox("loadData", data).combobox("setValue", docId);
		return;
	}
	setValueById("AdviseDoc", (docId || ""));
}

/**
 * 加载就诊列表
 */
function loadAdmList() {
	var queryParams = {
		ClassName: "web.DHCIPBillReg",
		QueryName: "FindAdmList",
		patientId: getValueById("PatientID"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		rows: 99999
	}
	loadComboGridStore("AdmList", queryParams);
}

/**
 * 入院登记
 */
function regSaveClick() {
	var _validate = function () {
		return new Promise(function (resolve, reject) {
			//必填项目验证
			var bool = true;
			var couCode = getCountryCode();
			var id = "";
			var text = "";
			var nullValTextAry = [];
			var firstEleId = "";
			$(document).find("label[for][class='clsRequired']").each(function () {
				id = $(this).attr("for");
				text = $(this).text();
				if (!id || !text) {
					return true;
				}
				if (getValueById(id)) {
					return true;
				}
				if (($.inArray(id, GV.ForeignNoReqdFields) != -1) && (couCode != CV.CHNCode)) {
					return true;
				}
				bool = false;
				nullValTextAry.push(text);
				if (!firstEleId) {
					firstEleId = id;
				}
			});
			if (!bool) {
				$.messager.popover({msg: ($g("请输入") + " <font color=\"red\">" + nullValTextAry.join() + "</font>"), type: "info"});
				focusById(firstEleId);
				return reject();
			}
			bool = checkData();
			if (!bool) {
				return reject();
			}
			$(".validatebox-text").each(function() {
				if (!$(this).validatebox("isValid")) {
					$.messager.popover({msg: "数据验证不通过", type: "info"});
					focusById($(this)[0].id);
					bool = false;
					return false;
				}
			});
			if (!bool) {
				return reject();
			}
			if (IPBILL_CONF.PARAM.RegNeedPatientNo == "Y") {
				if (!patientId || !patientNo) {
					focusById("PatientNo");
					$.messager.popover({msg: "该患者登记号不存在，不能办理入院", type: "info"});
					return reject();
				}
			}
			//患者主索引不存在时，根据患者其余信息查询患者
			if ((!(patientId > 0)) && checkAlreadyPAPER()) {
				return reject();
			}
			if (!isAbleReg(episodeId)) {
				var msg = "";
				var visitStatus = getVisitStatus(episodeId);
				switch (visitStatus) {
				case "P":
					msg = "预住院患者，必须通过住院证办理入院";
					break;
				case "A":
					msg = "该患者已经在院，不能再办理入院";
					break;
				default:
					msg = "不能选择以前的就诊办理入院";
				}
				$.messager.popover({msg: msg, type: "info"});
				return reject();
			}
			//调用后端程序校验数据合法性
			$.m({
				ClassName: "web.DHCIPBillReg",
				MethodName: "CheckRegDataHTML",
				personXML: personXML,
				personExpXML: personExpXML,
				admXML: admXML,
				sessionStr: getSessionStr()
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					return resolve();
				}
				$.messager.popover({msg: (myAry[1] || myAry[0]), type: "info"});
				return reject();
			});
		});
	};
	
	var _cfr = function () {
		return new Promise(function (resolve, reject) {
			if (!patientId) {
				$.messager.confirm("确认", "是否确认办理入院？", function (r) {
					return r ? resolve() : reject();
				});
				return;
			}
			
			var tipAry = [];
			
			var _shiftTips = function() {
				if (tipAry.length == 0) {
					return resolve();
				}
				var msg = tipAry.shift().msg;  //删除第一项，获取数组第一项的值
				$.messager.confirm("确认", ($g(msg)+  "，" + $g("是否确认办理入院") + "？"), function (r) {
					if (!r) {
						return reject();
					}
					_shiftTips();   //递归
				});
			};
			
			$.cm({
				ClassName: "web.DHCIPBillReg",
				MethodName: "GetPreRegCfrTips",
				patientId: patientId,
				deptId: deptId,
				insTypeId: insTypeId
			}, function(json) {
				tipAry = json;
				if (tipAry.length == 0) {
					$.messager.confirm("确认", "是否确认办理入院？", function (r) {
						return r ? resolve() : reject();
					});
					return;
				}
				_shiftTips();
			});
		});
	};
	
	/**
	* 入院登记
	*/
	var _reg = function () {
		return new Promise(function (resolve, reject) {
			var className = "web.DHCIPBillReg";
			var methodName = "SaveRegInfo";
			if (episodeId) {
				//预住院就诊时，调用预住院转住院程序
				className = "web.DHCBillPreIPAdmTrans";
				methodName = "Trans2IPFromReg";
			}
			var expStr = photoInfo;
			$.m({
				ClassName: className,
				MethodName: methodName,
				personXML: personXML,
				personExpXML: personExpXML,
				admXML: admXML,
				sessionStr: getSessionStr(),
				expStr: expStr
			}, function (rtn) {
				resolve(rtn);
			});
		});
	};
	
	var _regSucLoad = function(rtnValue) {
		var myAry = rtnValue.split("^");
		var success = myAry[0];
		var msg = myAry[1];
		switch (success) {
		case "0":
			$.messager.alert("提示", msg, "success", function() {
				patientId = myAry[2];
				episodeId = myAry[3];
				if (!getValueById("PatientID")) {
					patientNo = getPropValById("PA_PatMas", patientId, "PAPMI_No");
					setValueById("PatientID", patientId);
					setValueById("PatientNo", patientNo);
				}
				if (!getValueById("EpisodeID")) {
					setValueById("EpisodeID", episodeId);
				}
				loadAdmList();
				var admJson = getAdmJson(episodeId);
				setValueById("MedicareNo", admJson.MedicareNo);
				setValueById("VisitStatus", admJson.VisitStatus);
				setValueById("InPatTimes", admJson.InPatTimes);     //住院次数
				
				//+2022-11-04 ZhYW 自动打印腕带
				if (isAutoPrintWrist()) {
					autoPrtWristband();
				}
				
				var promise = Promise.resolve();
				promise
					.then(insuReg)                  //医保登记
					.then(_isEditGreenRec)          //绿色通道信息编辑弹窗 +WangXQ 2023-03-17
					.then(showAccompanyEdit)        //ZhYW 2022-06-07 陪护人信息维护后打开交押金界面
					.then(function() {
						if (IPBILL_CONF.PARAM.RegLnkPayDep != "Y") {
							return;
						}
						//转到交押金界面(允许调用交押金程序)
						linkAddDepClick();
					});
			});
			break;
		default:
			$.messager.alert("提示", msg, "error");
		}
	};
	
	var _isEditGreenRec = function() {
		return new Promise(function (resolve, reject) {
			var admCateId = getValueById("AdmCategory");
			if (admCateId == "") {
				return resolve();
			}
			var admCateCode = getPropValById("PAC_AdmCategory", admCateId, "ADMCAT_Code");
			if (admCateCode != "01") {
				return resolve();
			}
			$.messager.confirm("确认", "该患者入院情况是绿色通道，是否编辑绿色通道信息？", function (r) {
				if (!r) {
					return resolve();
				}
				return showGreenRecDiag("N");
			});
		});
	};
	if ($("#Btn-RegSave").linkbutton("options").disabled) {
		return;
	}
	$("#Btn-RegSave").linkbutton("disable");
	
	var patientNo = getValueById("PatientNo");
	var patientId = getValueById("PatientID");
	
	var episodeId = getValueById("EpisodeID");
	
	var deptId = getValueById("Dept");
	var wardId = getValueById("Ward");
	var insTypeId = getValueById("AdmReason");

	var encmeth = getValueById("PAPersonEntityEncrypt");
	var personXML = getEntityClassInfoToXML(encmeth);
	
	var encmeth = getValueById("PAPersonExpEntityEncrypt");
	var personExpXML = getEntityClassInfoToXML(encmeth);
	
	var encmeth = getValueById("PAAdmEntityEncrypt");
	var admXML = getEntityClassInfoToXML(encmeth);
	
	var photoInfo = getValueById("PhotoInfo");

	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_reg)
		.then(function(rtn) {
			_regSucLoad(rtn);
			$("#Btn-RegSave").linkbutton("enable");
		}, function() {
			$("#Btn-RegSave").linkbutton("enable");
		});
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
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!patientId) {
				$.messager.popover({msg: "请选择需要退院的患者", type: "info"});
				return reject();
			}
			if (!episodeId) {
				$.messager.popover({msg: "患者就诊信息为空，不需办理退院", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _insuRegStrike = function() {
		return new Promise(function (resolve, reject) {
			var admReaStr = getAdmReasonInfo(episodeId);
			var admReaAry = admReaStr.split("^");
			var admReaId = admReaAry[0];
			var nationalCode = admReaAry[1];
			if (!(nationalCode > 0)) {
				return resolve();
			}
			var insuAdmStr = $.m({ClassName: "web.DHCINSUPort", MethodName: "GetInsuAdmInfoByAdmDr", PAADMDr: episodeId}, false);
			var insuAdmAry = insuAdmStr.split("^");
			if (!insuAdmAry[10] || (["B", "S"].indexOf(insuAdmAry[10]) != -1)) {
				return resolve();
			}
			$.messager.confirm("确认", "患者已做医保登记，需先取消医保登记，是否确认取消？", function (r) {
				if (!r) {
					$.messager.popover({msg: "请先取消医保登记再办理退院", type: "info"});
					return reject();
				}
				var rtn = InsuIPRegStrike(0, PUBLIC_CONSTANT.SESSION.USERID, episodeId, "", admReaId, "");
				if (rtn != 0) {
					$.messager.popover({msg: "取消医保登记失败：" + rtn + "，不能办理退院", type: "error"});
					return reject();
				}
				resolve();
			});
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认为该患者办理退院？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _cancel = function () {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "web.DHCIPBillReg",
				MethodName: "CancelAdm",
				episodeId: getValueById("EpisodeID"),
				sessionStr: getSessionStr()
			}, function (rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: myAry[1], type: "success"});
					return resolve();
				}
				$.messager.popover({msg: (myAry[1] || myAry[0]), type: "error"});
				reject();
			});
		});
	};
	
	var _success = function() {
		clearClick();
	};
	
	if ($("#Btn-RegCancel").linkbutton("options").disabled) {
		return;
	}
	$("#Btn-RegCancel").linkbutton("disable");
	
	var patientId = getValueById("PatientID");
	var episodeId = getValueById("EpisodeID");
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_insuRegStrike)
		.then(_cfr)
		.then(_cancel)
		.then(function() {
			_success();
			$("#Btn-RegCancel").linkbutton("enable");
		}, function() {
			$("#Btn-RegCancel").linkbutton("enable");
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
	var patientId = getValueById("PatientID");
	if (!patientId) {
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
	if (!(nationalCode > 0)) {
		$.messager.popover({msg: "非医保患者，不需要医保登记", type: "info"});
		return;
	}
	var url = "insuipreg.hui.csp?PapmiNo=" + getValueById("PatientNo") + "&AdmDr=" + episodeId;
	websys_showModal({
		url: url,
		title: "医保登记",
		iconCls: "icon-w-edit",
		width: "95%",
		height: "98%",
		onClose: function() {
			getInsuAdmInfo(episodeId);
		}
	});
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
	if (!(nationalCode > 0)) {
		$.messager.popover({msg: "非医保患者，不需要取消医保登记", type: "info"});
		return;
	}
	var rtn = InsuIPRegStrike(0, PUBLIC_CONSTANT.SESSION.USERID, episodeId, "", admReaId, "");
	if (rtn != 0) {
		$.messager.popover({msg: "取消医保登记失败：" + rtn, type: "error"});
		return;
	}
	$.messager.popover({msg: "取消医保登记成功", type: "success"});
	getInsuAdmInfo(episodeId);
}

/**
* 就诊信息修改
*/
function regUpdateClick() {
	var _validate = function () {
		return new Promise(function (resolve, reject) {
			if (!getValueById("PatientID")) {
				$.messager.popover({msg: "请选择患者", type: "info"});
				return reject();
			}
			var episodeId = getValueById("EpisodeID");
			var bool = true;
			var couCode = getCountryCode();
			var id = "";
			var text = "";
			//必填项目验证
			var nullValTextAry = [];
			var firstEleId = "";
			$(document).find("label[for][class='clsRequired']").each(function () {
				id = $(this).attr("for");
				text = $(this).text();
				if (!id || !text) {
					return true;
				}
				if (getValueById(id)) {
					return true;
				}
				if (($.inArray(id, GV.ForeignNoReqdFields) != -1) && (couCode != CV.CHNCode)) {
					return true;
				}
				//没有就诊时，不验证就诊信息
				if (!episodeId && ($(this).parents(".panel-body")[0].id == "AdmInfo-Panel")) {
					return true;
				}
				bool = false;
				nullValTextAry.push(text);
				if (!firstEleId) {
					firstEleId = id;
				}
			});
			if (!bool) {
				$.messager.popover({msg: "请输入<font color='red'>" + nullValTextAry.join() + "</font>", type: "info"});
				focusById(firstEleId);
				return reject();
			}
			bool = checkData();
			if (!bool) {
				return reject();
			}
			$(".panel-body:not(#InsuInfo-Panel)[id] .validatebox-text").each(function() {
				if (!$(this).validatebox("isValid")) {
					$.messager.popover({msg: "数据验证不通过", type: "info"});
					focusById($(this)[0].id);
					bool = false;
					return false;
				}
			});
			if (!bool) {
				return reject();
			}
						
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认修改？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _update = function() {
		return new Promise(function (resolve, reject) {
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
				if (success == 0) {
					$.messager.popover({msg: msg, type: "success"});
					return resolve();
				}
				$.messager.popover({msg: msg, type: "error"});
				reject();
			});
		});
	};
	
	if ($("#Btn-RegUpdate").linkbutton("options").disabled) {
		return;
	}
	$("#Btn-RegUpdate").linkbutton("disable");

	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_update)
		.then(function() {
			$("#Btn-RegUpdate").linkbutton("enable");
		}, function() {
			$("#Btn-RegUpdate").linkbutton("enable");
		});
}

/**
* 数据合法性校验
*/
function checkData() {
	var bool = true;
	
	var credNo = getValueById("CredNo");
	var credTypeId = getValueById("CredType");
	if ((credNo != "")  && (credTypeId > 0)) {
		var credTypeCode = getPropValById("DHC_CredType", credTypeId, "CRT_Code");
		if (credTypeCode == "01") {         //"01"为身份证
			setValueById("IDNo", credNo);
		}
	}
	
	var IDNo = getValueById("IDNo");
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
	
	var foreignCredNo = getValueById("ForeignCredNo");
	var foreignCredTypeId = getValueById("ForeignCredType");
	if ((foreignCredNo != "")  && (foreignCredTypeId > 0)) {
		var foreignCredTypeCode = getPropValById("DHC_CredType", foreignCredTypeId, "CRT_Code");
		if (foreignCredTypeCode == "01") {    //"01"为身份证
			if (!DHCWeb_IsIdCardNo(foreignCredNo)) {
				focusById("ForeignCredNo");
				return false;
			}
		}
	}
	var birthDate = getValueById("BirthDate");
	if (birthDate && !validateDate(birthDate)) {
		$.messager.popover({msg: "出生日期输入不正确", type: "info"});
		focusById("BirthDate");
		return false;
	}
	
	var birthTime = getValueById("BirthTime");
	var sexId = getValueById("Sex");
	var maritalId = getValueById("Marital");
	//婚姻状况控制
	if ($.inArray(maritalId, GV.MarriedIdAry) != -1) {
		var limitAge = GV.MarriedLimitAge[sexId];
		if (limitAge > 0) {
			var admDate = getValueById("AdmDate");
			var admTime =  getValueById("AdmTime");
			var ageStr = dispPatAge(birthDate, admDate, birthTime, admTime);
			var ageAry = ageStr.split("||");
			var ageYear = ageAry[1];
			if (ageYear < limitAge) {
				$.messager.popover({msg: ($g("患者年龄小于") + limitAge + $g("岁，婚姻状况不能选择") + $("#Marital").combobox("getText")), type: "info"});
				focusById("Marital");
				return false;
			}
		}
	}
	
	return true;
}

/**
 * 判断患者姓名、性别、出生日期一致时给予提示;身份证作为唯一索引查找是否有患者信息
 */
function checkAlreadyPAPER() {
	var IDNo = getValueById("IDNo");
	var patientId = getValueById("PatientID");
	var name = getValueById("Name");
	var sex = getValueById("Sex");
	var birthDate = getValueById("BirthDate");
	var healthFundNo = getValueById("HealthFundNo");
	if (patientId) {
		return true;
	}
	if (!IDNo) {
		if (!name || !sex || !birthDate) {
			return false;
		}
	}
	var patInfo = name + "^" + sex + "^" + birthDate + "^" + IDNo + "^" + healthFundNo;
	var patNum = $.m({ClassName: "web.DHCIPBillPAPERInfo", MethodName: "CheckPatNum", PatInfo: patInfo}, false);
	if (patNum > 0) {
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
	return ($.m({ClassName: "web.DHCIPBillReg", MethodName: "ValidateDate", date: date}, false) == "Y");
}

/**
* 清屏
*/
function clearClick() {
	$("#MRDiagList, #RegInfoList").empty().css({cursor: "default"}).tooltip("destroy");   //+2023-01-18 ZhYW
	$(":text:not(.pagination-num,.combo-text),textarea").val("");
	$(".numberbox-f").numberbox("clear");
	$(".combobox-f").combobox("clear");
	$(".combobox-f:not(#Ward,#Doctor,#AdmDiagnos,#AdviseDoc)").combobox("reload");
	$("#Ward,#Doctor,#AdmDiagnos,#AdviseDoc").combobox("loadData", []);
	$(".datebox-f:not(#AdmDate)").datebox("clear");
	$("#AdmDiagnos").combobox("enable");
	$("#DiagRemark").prop("disabled", false);
	$(".combogrid-f").combogrid("clear").combogrid("grid").datagrid("loadData", {
		total: 0,
		rows: []
	});
  	$(".validatebox-text").validatebox("validate");
  	
	setValueById("PhotoInfo", "");
	
	ShowPicBySrcNew("../images/uiimages/patdefault.png", "ImgPic");
	
	setDefaultValue();
	
	clearHideEle();
	
	enableById("Btn-RegSave");
	if (GV.FocusId) {
		focusById(GV.FocusId);
	}
	//若科室/病区/医生未设置为禁用，先将其设置为可用
	$.each(CV.Conf.DOMSEQAry, function (index, item) {
		if ((["Dept", "Ward", "Doctor"].indexOf(item.id) != -1) && !item.disabled) {
			enableById(item.id);
		}
	});
}

/**
* 清空隐藏元素的值
*/
function clearHideEle() {
	setValueById("PatientID", "");
	setValueById("AgeYear", "");        //+2022-12-14 ZhYW 置空患者年龄(岁)
	setValueById("SocialStatus", "");   //社会地位
	setValueById("EpisodeID", "");
	setValueById("IPBookID", "");
}

function disableEle() {
	var episodeId = getValueById("EpisodeID");
	if (isAbleReg(episodeId)) {
		enableById("Btn-RegSave");
		return;
	}
	
	disableById("Btn-RegSave");
	var visitStatus = getVisitStatus(episodeId);
	if (visitStatus == "P") {
		$.messager.popover({msg: "该患者为预住院状态，不能在此办理入院", type: "info"});
	}
	
	//判断是否允许修改科室、病区
	$.m({
		ClassName: "web.DHCIPBillReg",
		MethodName: "AllowUpdtAdmDeptWard",
		type: "GET",
		adm: episodeId
	}, function (rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] != 0) {
			disableById("Dept");
			disableById("Ward");
		}
	});
	
	//判断是否允许修改入院医生
	$.m({
		ClassName: "web.DHCIPBillReg",
		MethodName: "AllowUpdtAdmDoc",
		type: "GET",
		adm: episodeId
	}, function (rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] != 0) {
			disableById("Doctor");
		}
	});
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
		//+2022-12-14 ZhYW 输入是纯数字时，认为输入的是年龄(岁)
		if (/^\d+$/.test(age)) {
			setValueById("AgeYear", age);
		}
		$.m({
			ClassName: "web.DHCDocCommon",
			MethodName: "GetBirthDateByAge",
			Age: age,
			Type: ""
		},function(rtn) {
			setValueById("BirthDate", rtn);
		});
	}
}

function birthDateKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var birthDate = getValueById("BirthDate");
		if (!birthDate) {
			return;
		}
		if (!validateDate(birthDate)) {
			$.messager.popover({msg: "出生日期输入不正确", type: "info"});
			return;
		}
		getAgeFromBirthDay();
		
		//判断患者姓名、性别、出生日期一致时给予提示;身份证作为唯一索引查找是否有病人信息
		if (!getValueById("PatientID")) {
			checkAlreadyPAPER();
		}
	}
}

function babyAgeKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$("input[id^='BabyAge']").validatebox("isValid")) {
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
		getInfoBasedIDCard($(e.target).val());
	}
}

/**
* 证件号回车事件
*/
function credNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var credTypeId = getValueById("CredType");
		var credTypeCode = getPropValById("DHC_CredType", credTypeId, "CRT_Code");
		if (credTypeCode == "01") {   //"01"为身份证
			getInfoBasedIDCard($(e.target).val());
		}
	}
}

/**
* 根据身份证获取患者信息
*/
function getInfoBasedIDCard(IDNo) {
	if (!IDNo) {
		return;
	}
	if (!DHCWeb_IsIdCardNo(IDNo)) {
		return;
	}
	var json = getInfoByFromIDNo(IDNo);
	if (json.success != 0) {
		$.messager.popover({msg: json.msg, type: "info"});
		return;
	}
	setValueById("BirthDate", json.birthDate);
	setValueById("Age", json.age);
	setValueById("Sex", json.sexId);
	
	if (json.provId > 0) {
		var cityUrl = getCityUrl(json.provId);
		var areaUrl = getCityAreaUrl(json.cityId);
		var streetUrl = getStreetUrl(json.cityAreaId);
		if (CV.BuildAddrHomeByIDCard == "Y") {
			//籍贯
			if ($.hisui.indexOfArray($("#HomeProv").combobox("getData"), "id", json.provId) != -1) {
				//省(籍贯)
				$("#HomeProv").combobox("setValue", json.provId);
				//市(籍贯)
				$("#HomeCity").combobox("reload", cityUrl).combobox("setValue", json.cityId);
				//县(籍贯)
				$("#HomeArea").combobox("reload", areaUrl).combobox("setValue", json.cityAreaId);
			}
		}
		if (CV.BuildAddrLookUpByIDCard == "Y") {
			//现住
			if ($.hisui.indexOfArray($("#Province").combobox("getData"), "id", json.provId) != -1) {
				//省(现住)
				$("#Province").combobox("setValue", json.provId);
				//市(现住)
				$("#City").combobox("reload", cityUrl).combobox("setValue", json.cityId);
				//县(现住)
				$("#CityArea").combobox("reload", areaUrl).combobox("setValue", json.cityAreaId);
				//街道(现住)
				$("#Street").combobox("reload", streetUrl);
			}
		}
		if (CV.BuildAddrBirthByIDCard == "Y") {
			//出生
			if ($.hisui.indexOfArray($("#BirthProv").combobox("getData"), "id", json.provId) != -1) {
				//省(出生)
				$("#BirthProv").combobox("setValue", json.provId);
				//市(出生)
				$("#BirthCity").combobox("reload", cityUrl).combobox("setValue", json.cityId);
				//县(出生)
				$("#BirthArea").combobox("reload", areaUrl).combobox("setValue", json.cityAreaId);
				//街道(出生)
				$("#BirthStreet").combobox("reload", streetUrl);
			}
		}
		if (CV.BuildAddrHouseByIDCard == "Y") {
			//户口
			if ($.hisui.indexOfArray($("#HouseProv").combobox("getData"), "id", json.provId) != -1) {
				//省(户口)
				$("#HouseProv").combobox("setValue", json.provId);
				//市(户口)
				$("#HouseCity").combobox("reload", cityUrl).combobox("setValue", json.cityId);
				//县(户口)
				$("#HouseArea").combobox("reload", areaUrl).combobox("setValue", json.cityAreaId);
				//街道(户口)
				$("#HouseStreet").combobox("reload", streetUrl);
			}
		}
	}
	
	getPatInfoByIDNo(IDNo);
}

/**
* 查询患者登记信息
*/
function getPatInfoByIDNo(IDNo) {
	if (!IDNo) {
		return;
	}
	$.cm({
		ClassName: "BILL.COM.PAPatMas",
		MethodName: "GetPatInfoByIDNo",
		IDNo: IDNo
	}, function(data) {
		if (data.success != 0) {
			return;
		}
		setValueById("PatientNo", data.patientNo);
		setValueById("Name", data.patName);
		setValueById("MedicareNo", "");  //这里需置空病案号，以便根据登记号查询患者信息
		getPatInfo();
	});
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
	var ageStr = dispPatAge(birthDate, admDate, birthTime, admTime);
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
* 调用计算年龄方法获取患者年龄
*/
function dispPatAge(birthDate, admDate, birthTime, admTime) {
	return tkMakeServerCall("web.UDHCJFCOMMON", "DispPatAge", birthDate, admDate, birthTime, admTime, PUBLIC_CONSTANT.SESSION.HOSPID);
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
	return new Promise(function (resolve, reject) {
		var episodeId = getValueById("EpisodeID");
		if (!episodeId) {
			$.messager.popover({msg: "请选择患者的就诊记录", type: "info"});
			return resolve();
		}
		var visitStatus = getVisitStatus(episodeId);
		if (visitStatus == "C") {
			$.messager.popover({msg: "患者已退院不能交押金", type: "info"});
			return resolve();
		}
		var suggestDepAmt = getValueById("SuggestDepAmt");   //建议押金(来源于住院证)
		var argObj = {
			EpisodeID: episodeId,
			PayAmt: suggestDepAmt
		};
		BILL_INF.showPayDeposit(argObj);
	});
}

function searchUpdateLogClick() {
	var url = "dhcbill.ipbill.uppatinfo.csp";
	websys_showModal({
		url: url,
		title: "信息修改查询",
		iconCls: "icon-w-find"
	});
}

function initMenuWDPrint() {
	$.cm({
		ClassName: "BILL.CFG.COM.GeneralCfg",
		QueryName: "GetResultForQuery",
		ResultSetType: "array",
		RelaCode: "IPCHRG.IPReg.WDDYANPZ",
		SourceData: "",
		TgtData: "",
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function (rows) {
		var menuAry = [];
		var id = "";
		rows.forEach(function(row) {
			if (row.code == "adult") {
				id = "Btn-WDPrt";
			}
			if (row.code == "child") {
				id = "Btn-ChildWDPrt";
			}
			if (row.code == "baby") {
				id = "Btn-BabyWDPrt";
			}
			menuAry.push({text: row.desc, id: id, handler: wristbandPrtClick});
		});
		menuAry.forEach(function(item) {
			$("#MenuWD").menu("appendItem", item);
		});
	});
}

function wristbandPrtClick() {
	var episodeId = getValueById("EpisodeID");
	if (!episodeId) {
		$.messager.popover({msg: "请选择就诊记录", type: "info"});
		return;
	}
	var visitStatus = getVisitStatus(episodeId);
	if (visitStatus != "A") {
		$.messager.popover({msg: "请先办理入院再打印腕带", type: "info"});
		return;
	}
	var type = "WristStraps";
	switch(this.id) {
	case "Btn-WDPrt":
		//成人
		type = "WristStraps";
		break;
	case "Btn-ChildWDPrt":
		//儿童
		type = "WristStrapschild";
		break;
	case "Btn-BabyWDPrt":
		//婴儿
		type = "WristStrapsinfant";
		break;
	default:
	}
	OutSidePrint(episodeId, type);
}

/**
 * Insu-加载医保类型
 */
function initInsuType() {
	$HUI.combobox("#InsuType", {
		panelHeight: 100,
		url: $URL + '?ClassName=web.INSUDicDataCom&QueryName=QueryDic&ResultSetType=array',
		validType: ['checkInsuInfo'],
		valueField: 'cCode',
		textField: 'cDesc',
		method: 'GET',
		blurValidValue: true,
		defaultFilter: 5,
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
			$("#InsuDiagDesc").combogrid("clear").combogrid("grid").datagrid("loadData", {
				total: 0,
				rows: []
			});
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
		url: $URL + '?ClassName=web.INSUDicDataCom&QueryName=QueryDic&ResultSetType=array',
		method: 'GET',
		blurValidValue: true,
		defaultFilter: 5,
		onBeforeLoad: function(param) {
			var insuType = getValueById("InsuType");
			if (!insuType) {
				return false;
			}
			param.Type = "med_type" + insuType;
			param.Code = "";
			param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		loadFilter: function(data) {
			var j = 0;
			var newData = [];
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
			if ((index > -1)&&(data != "")) {
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
		url: $URL + '?ClassName=web.DHCINSUIPReg&QueryName=GetInsuDiagnosis',
		lazy: true,
		columns: [
			[{field: 'Rowid', hidden: true},
			 {field: 'Code', title: '医保诊断编码', width: 120},
			 {field: 'Desc', title: '医保诊断名称', width: 230}]
		],
		onBeforeLoad: function(param) {
			var insuType = getValueById("InsuType");
			if (!insuType || !$.trim(param.q)) {
				return false;
			}
			param.InsuInDiagDesc = param.q;
			param.InsuType = insuType;
			param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID;
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
function getInsuAdmInfo(episodeId) {
	if ($("#InsuInfo-Panel").length == 0) {
		return;
	}
	if (!episodeId) {
		return;
	}
	var admReaStr = getAdmReasonInfo(episodeId);
	var admReaAry = admReaStr.split("^");
	var admReaId = admReaAry[0];
	var nationalCode = admReaAry[1];
	if (!(nationalCode > 0)) {
		return;
	}
	$.m({
		ClassName: "web.DHCINSUIPReg",
		MethodName: "GetInfoByAdm",
		type: "GET",
		Paadm: episodeId
	}, function (rtn) {
		if (rtn.split("!")[0] != 1) {
			enableById("Btn-InsuReg");
			enableById("Btn-InsuRegCancel");
			return;
		}
		var myAry = rtn.split("!")[1].split("^");
		var actDesc = "";
		switch(myAry[11]) {
		case "A":
			actDesc = "已登记";
			disableById("Btn-InsuReg");
			enableById("Btn-InsuRegCancel");
			$("#InsuActFlag").css({"color": "green"});
			break;
		case "O":
			actDesc = "出院";
			var visitStatus = getVisitStatus(episodeId);
			if (visitStatus == "D") {
				disableById("Btn-InsuReg");
				enableById("Btn-InsuRegCancel");
				break;
			}
			enableById("Btn-InsuReg");
			disableById("Btn-InsuRegCancel");
			break;
		case "S":
			actDesc = "取消登记";
			enableById("Btn-InsuReg");
			disableById("Btn-InsuRegCancel");
			$("#InsuActFlag").css({"color": "red"});
			break;
		default:
		}
		setValueById("InsuActFlag", actDesc);           //医保登记状态
		setValueById("InsuNo", myAry[2]);               //医保号
		setValueById("InsuCardNo", myAry[3]);           //医保卡号
		
		setValueById("InsuType", myAry[18]);
		$("#InsuAdmType").combobox("reload").combobox("setValue", myAry[14]);    //医疗类别combobox
		
		setValueById("InsuPatType", myAry[4]);          //人员类别
		
		$("#InsuDiagDesc").combogrid("grid").datagrid("loadData", {
			total: 1,
			rows: [{"Code": myAry[26], "Desc": myAry[27]}]
		});
		$("#InsuDiagDesc").combogrid("setValue", myAry[26]);   //医保诊断
		
		setValueById("InsuAdmSeriNo", myAry[10]);        //医保就诊号
		//登记信息 +WangXQ 2023-03-31
		var oprtAry = myAry[38].split("|");
		var oprtCode = oprtAry[2];		//手术编码
		var oprtName = oprtAry[3];		//手术名称
		var insuRegInfoAry = [("险种类型：" + myAry[36]), ("待遇类别：" + myAry[37]), ("病种名称：" + myAry[27]), ("病种编码：" + myAry[26]), ("手术名称：" + oprtName), ("手术编码：" + oprtCode)];
		$("#RegInfoList").empty().css({cursor: "default"}).html(insuRegInfoAry.join(";<span style=\"padding:0 3px;\"></span>")).tooltip("destroy");
		if (insuRegInfoAry.length > 0) {
			$("#RegInfoList").tooltip({
				position: 'top',
				content: insuRegInfoAry.join("<br/>")
			}).css({cursor: "pointer"});
		}
	});
}

/**
* 清空医保信息面板
*/
function clearInsuPanel() {
	enableById("Btn-InsuReg");
	enableById("Btn-InsuRegCancel");
	$("#InsuInfo-Panel .validatebox-text").val("").validatebox("validate");
	$("#InsuInfo-Panel .combobox-f").combobox("clear");
	$("#InsuInfo-Panel .combobox-f:not(#InsuType)").combobox("loadData", []);
	$("#InsuInfo-Panel .combogrid-f").each(function() {
    	$(this).combogrid("clear").combogrid("grid").datagrid("loadData", {
			total: 0,
			rows: []
		});
  	});
	$("#RegInfoList").empty().css({cursor: "default"}).tooltip("destroy");   //+2023-03-31 WangXQ
}

/**
* 医保登记交互
*/
function insuReg() {
	return new Promise(function (resolve, reject) {
		if ($("#InsuInfo-Panel").length == 0) {
			return resolve();   //未显示医保信息面板的，不直接医保登记
		}
		var episodeId = getValueById("EpisodeID");
		if (!episodeId) {
			return resolve();
		}
		var admReaStr = getAdmReasonInfo(episodeId);
		var admReaAry = admReaStr.split("^");
		var admReaId = admReaAry[0];
		var nationalCode = admReaAry[1];
		if (!(nationalCode > 0)) {
			return resolve();
		}
		
		//医保类型
		var insuType = getValueById("InsuType");
		//医疗类别
		var insuAdmType = getValueById("InsuAdmType");
		if (!insuType || !insuAdmType) {
			return resolve();
		}
		
		//医保号/医疗证号
		var insuNo = getValueById("InsuNo");
		//医保入院诊断编码
		var insuDiagCode = getValueById("InsuDiagCode");
		//医保入院诊断名称
		var insuDiagDesc = getValueById("InsuDiagDesc");
		//就诊日期
		var admDate = "";  //getValueById("AdmDate");
		//就诊时间
		var admTime = "";  //getValueById("AdmTime");
		//治疗方式
		var zlfsStr = "";
		//补偿方式
		var bcfsStr = "";
		var tmpAry = [];
		tmpAry.push(insuAdmType);
		tmpAry.push(insuDiagCode);
		tmpAry.push(insuDiagDesc);
		tmpAry.push(insuNo);
		tmpAry.push(admDate);
		tmpAry.push(admTime);
		tmpAry.push(zlfsStr);
		tmpAry.push(bcfsStr);
		tmpAry.push(insuType);
		var tmpString = tmpAry.join("^");
		tmpString = tmpString.replace(/undefined/g, "");   //替换所有的undefined
		
		//医保登记
		var flag = InsuIPReg(0, PUBLIC_CONSTANT.SESSION.USERID, episodeId, nationalCode, admReaId, tmpString); //DHCInsuPort.js
		var msg = "医保登记" + ((flag < 0) ? ("失败：" + flag) : "成功");
		var iconCls = (flag < 0) ? "error" : "success";
		$.messager.alert("提示", msg, iconCls, function() {
			 resolve();
		});
	});
}

/**
* 判断就诊能否办理入院
* @就诊为空时可以办理入院
* @住院证对应的预住院就诊可以办理入院
*/
function isAbleReg(episodeId) {
	if (!episodeId) {
		return true;
	}
	if (!getValueById("IPBookID")) {
		return false;
	}
	return (getVisitStatus(episodeId) == "P");
}

/**
* 取就诊在院状态
*/
function getVisitStatus(episodeId) {
	return episodeId ? getPropValById("PA_Adm", episodeId, "PAADM_VisitStatus") : "";
}

function getProvUrl(countryId) {
	return $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryProvince&ResultSetType=array&type=GET&desc=&countryId=" + countryId;
}

function getCityUrl(provId) {
	return $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryCity&ResultSetType=array&type=GET&desc=&provId=" + provId;
}

function getCityAreaUrl(cityId) {
	return $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryCityArea&ResultSetType=array&type=GET&desc=&cityId=" + cityId;
}

function getStreetUrl(cityAreaId) {
	return $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryStreet&ResultSetType=array&type=GET&desc=&cityAreaId=" + cityAreaId;
}

function getCommunityUrl(streetId) {
	return $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryCommunity&ResultSetType=array&type=GET&desc=&streetId=" + streetId;
}

/**
* 陪护人信息维护
*/
function showAccompanyEdit() {
	return new Promise(function (resolve, reject) {
		var isEdit = isEditAccompany();
		if (!isEdit) {
			return resolve();    //无需维护陪护人信息
		}
		var episodeId = getValueById("EpisodeID");
		if (!episodeId) {
			$.messager.popover({msg: "请选择患者的就诊记录", type: "info"});
			return resolve();
		}
		var TRCount = $.cm({
	        ClassName: "Nur.NIS.Service.Accom.NCPAccompany",
	        MethodName: "GetNCPAccompanyInfoNum",
	        hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
	        opType: "P"
	    }, false);
		var MaxTRCount = 12;    //panel里最大展示行数
		if (TRCount > MaxTRCount) {
			TRCount = MaxTRCount;
		};
		var totalHeight = (TRCount * 30) + ((TRCount + 1) * 10);
		if (HISUIStyleCode == "lite") {
			totalHeight = parseInt(totalHeight) + 103;
		}else{
			totalHeight = parseInt(totalHeight) + 107;
		}
		var url = "nur.hisui.ncpaccompanyedit.csp?EpisodeID=" + episodeId + "&bedEnable=N&NCPARRowID=";
		websys_showModal({
			url: url,
			iconCls: 'icon-w-add',
			title: '陪护人信息维护',
			width: 540,
			height: totalHeight,
			CallBackFunc: function() {
				websys_showModal("close");
			},
			onClose: function() {
				resolve();
			}
		});
	});
}

/**
* 是否需要维护陪护人信息
* true:是, false:否
*/
function isEditAccompany() {
	return ($.m({ClassName: "web.DHCIPBillReg", MethodName: "GetRegParamCfg", key: "EditAccompany", hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false) == 1);
}

/**
* 获取选择的国籍编码
*/
function getCountryCode() {
	var couId = getValueById("Country");
	return (couId > 0) ? getPropValById("CT_Country", couId, "CTCOU_Code") : "";
}

/**
* 根据身份证号获取其对应的信息
*/
function getInfoByFromIDNo(pId) {
	return $.cm({ClassName: "BILL.COM.Method", MethodName: "GetInfoByFromIDNo", pId: pId, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
}

/**
* 登记成功后是否自动打印腕带
*/
function isAutoPrintWrist() {
	return ($.m({ClassName: "web.DHCIPBillReg", MethodName: "IsAutoPrintWrist", hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false) == 1);
}

/**
* 用住院证登记时是否可更改入院科室
*/
function isChangeDept() {
	return ($.m({ClassName: "web.DHCIPBillReg", MethodName: "IsChangeDept", hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false) == 1);
}

/**
* ZhYW
* 2022-11-04
* 调用护士站接口根据就诊计算的年龄自动打印腕带
* 用于住院登记成功后自动打印腕带
*/
function autoPrtWristband() {
	var episodeId = getValueById("EpisodeID");
	if (!episodeId) {
		$.messager.popover({msg: "请选择就诊记录", type: "info"});
		return;
	}
	$.cm({
		ClassName: "Nur.NIS.Service.NursingPlan.QuestionSetting",
		MethodName: "GetPatientFlag",
		EpisodeID: episodeId
	}, function(rtn) {
		var type = "WristStraps";
		switch(+rtn) {
		case 1:
			//成人
			type = "WristStraps";
			break;
		case 2:
			//儿童
			type = "WristStrapschild";
			break;
		default:
			//3:婴儿, 4:新生儿
			type = "WristStrapsinfant";
		}
		OutSidePrint(episodeId, type);
	});
}

/**
* ZhYW
* 2023-01-18
* 根据住院证获取门诊诊断
*/
function getDiagListByIPBook(IPBookId) {
	$.m({
		ClassName: "web.DHCDocIPBookNew",
		MethodName: "GetDiagenose",
		BookID: IPBookId
	}, function(diagList) {
		setDiagList(diagList);
	});
}

/**
* ZhYW
* 2023-01-18
* 根据住院就诊获取诊断
*/
function getDiagListByAdm(adm) {
	$.m({
		ClassName: "web.DHCDocIPBookNew",
		MethodName: "GetAdmICDList",
		Adm: adm
	}, function(diagList) {
		setDiagList(diagList);
	});
}

function setDiagList(diagList) {
	var diagAry = [];
	diagList.split("!").forEach(function(currValue) {
		if(!currValue) {
			return true;
		}
		var diagnos = currValue.split(PUBLIC_CONSTANT.SEPARATOR.CH2)[1];
		diagAry.push(diagnos);
	});
	$("#MRDiagList").empty().css({cursor: "default"}).html(diagAry.join(";<span style=\"padding:0 3px;\"></span>")).tooltip("destroy");
	if (diagAry.length > 0) {
		$("#MRDiagList").tooltip({
	    	content: diagAry.join("<br/>")
		}).css({cursor: "pointer"});
	}
}

/**
 * WangXQ
 * 2023-03-17
 * 绿色通道信息编辑弹窗
*/
function greenRecUpdateClick() {
	var episodeId = getValueById("EpisodeID");
	if (!episodeId){
		$.messager.popover({msg: "请选择患者的就诊记录", type: "info"});
		return;
	}
	var admCategDR = getPropValById("PA_Adm", episodeId, "PAADM_AdmCateg_DR");
	if (!admCategDR) {
		$.messager.popover({msg: "非绿色通道患者，不能编辑绿色通道信息", type: "info"});
		return;
	}
	var admCateCode = getPropValById("PAC_AdmCategory", admCategDR, "ADMCAT_Code");
	if (admCateCode != "01"){
		$.messager.popover({msg: "非绿色通道患者，不能编辑绿色通道信息", type: "info"});
		return;
	}
	showGreenRecDiag("Y");
}

/**
 * WangXQ
 * 2023-03-17
 * 绿色通道信息编辑弹窗
*/
function showGreenRecDiag(isUpdtOpt) {
	return new Promise(function (resolve, reject) {
		var _content = "<div id=\"greenRecDlg\">"
						+ "<table class=\"search-table\">"
							+ "<tr>"
								+ "<td class=\"r-label r-label-50\"><label class=\"clsRequired\">" + $g("有效时长") + "</label></td>"
								+ "<td><input id=\"GreenRecValiDuration\" class=\"textbox\"/></td>"
							+ "</tr>"
							+ "<tr>"
								+ "<td class=\"r-label\"><label>" + $g("单位") + "</label></td>"
								+ "<td><input id=\"GreenRecValiUnit\" class=\"textbox\"/></td>"
							+ "</tr>"
						+ "</table>"
					+ "</div>";
		$("body").append(_content);

		$("#greenRecDlg").dialog({
			title: '绿色通道信息编辑',
			iconCls: 'icon-w-edit',
			resizable: false,
			width: 329,
			height: 187,
			cache: false,
			closable: false,
			buttons:[{
				text: '保存',
				handler: function () {
					var bool = true;
					$("#greenRecDlg .validatebox-text").each(function (index, item) {
						if (!$(this).val()) {
							$.messager.popover({msg: "<font color=\"red\">" + $(this).parents("td").prev().text() + "</font>" + "验证不通过", type: "info"});
							bool = false;
							return false;
						}
					});
					if (!bool) {
						return;
					}
					saveGreenRecInfo(isUpdtOpt).then(function() {
						$("#greenRecDlg").dialog("close");
						resolve();
					});
				}
			}, {
				text: '取消',
				handler: function () {
					$("#greenRecDlg").dialog("close");
					resolve();
				}
			 }
			],
			onClose: function() {
				$("#greenRecDlg").dialog("destroy");
				$("body").remove("#greenRecDlg");
			},
			onOpen: function () {
				$("#GreenRecValiDuration").focus();
			},
			onBeforeOpen: function () {
				$("#GreenRecValiDuration").imedisabled().numberbox({min: 1});
				//绿色通道有效时间单位
				$("#GreenRecValiUnit").combobox({
					panelHeight: 'auto',
					valueField: 'value',
					textField: 'text',
					editable: false,
					data: [
						{value: 'D', text: '天', selected: true},
						{value: 'H', text: '小时'}
					]
				});
				$.m({
					ClassName: "web.DHCIPBillReg",
					MethodName: "GetGreenRecInfo",
					episodeId: getValueById("EpisodeID")
				}, function(rtn) {
					if(rtn) {
						var myAry = rtn.split("^");
						setValueById("GreenRecValiDuration", myAry[0]);
						setValueById("GreenRecValiUnit", myAry[1]);
					}
				});
			}
		}).show();
	});
}

/**
 * WangXQ
 * 2023-03-17
 * 保存绿色通道信息
*/
function saveGreenRecInfo(isUpdtOpt) {
	return new Promise(function (resolve, reject) {
		var encmeth = getValueById("RegExpEntityEncrypt");
		var regExpXML = getEntityClassInfoToXML(encmeth);
		//调用后端程序保存数据
		$.m({
			ClassName: "web.DHCIPBillReg",
			MethodName: "SaveRegExpInfo",
			regExpXML: regExpXML,
			sessionStr: getSessionStr(),
			isUpdtOpt: isUpdtOpt
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "保存成功", type: "success"});
				return resolve();
			}
			$.messager.alert("提示", "保存失败" + (myAry[1] ||  myAry[0]), "error", function(){
				resolve();
			});
			return;
		});
	});
}