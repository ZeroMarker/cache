/**
 * FileName: dhcbill.conf.page.dailydtllist.js
 * Anchor: ZhYW
 * Date: 2019-11-05
 * Description: 病区日清明细页面配置
 */

$(function() {
	$HUI.linkbutton("#btn-save", {
		onClick: function () {
			saveClick();
		}
	});
	
	var options = {
		onText: '是',
		offText: '否',
		size: 'small',
		onClass: 'primary',
		offClass: 'gray',
		checked: false
	};
	$(".search-table td>div").switchbox(options);
	
	var tableName = "Bill_IP_DailyDetail";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
	$("#hospital").combobox({
		panelHeight: 150,
		width: 350,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			$.m({
				ClassName: "web.DHCBillPageConf",
				MethodName: "GetConfValue",
				pageId: GV.PageId,
				site: GV.Site,
				code: GV.SplitDayCode,
				siteId: newValue
			}, function (rtn) {
				$("#splitDayFlag").switchbox("setValue", (rtn == "1"));      //是否按天拆分打印
			});
			
			$.m({
				ClassName: "web.DHCBillPageConf",
				MethodName: "GetConfValue",
				pageId: GV.PageId,
				site: GV.Site,
				code: GV.SplitColCode,
				siteId: newValue
			}, function (rtn) {
				$("#splitColFlag").switchbox("setValue", (rtn == "1"));      //是否双列打印
			});

			$.m({
				ClassName: "web.DHCBillPageConf",
				MethodName: "GetConfValue",
				pageId: GV.PageId,
				site: GV.Site,
				code: GV.PageAdmCode,
				siteId: newValue
			}, function (rtn) {
				$("#pageAdmFlag").switchbox("setValue", (rtn == "1"));        //是否按患者就诊分页打印
			});
		}
	});
});

/**
* 保存
*/
function saveClick() {
	if (!checkData()) {
		return;
	}
	var hospital = getValueById("hospital");
	
	$.messager.confirm("确认", "确认保存?", function(r) {
		if (r) {
			var confObj = {};
			confObj[GV.SplitDayCode + "VAL"] = $("#splitDayFlag").switchbox("getValue") ? 1 : 0;
			confObj[GV.SplitDayCode + "DESC"] = "是否按天拆分打印";
			
			confObj[GV.SplitColCode + "VAL"] = $("#splitColFlag").switchbox("getValue") ? 1 : 0;
			confObj[GV.SplitColCode + "DESC"] = "是否双列打印";
			
			confObj[GV.PageAdmCode + "VAL"] = $("#pageAdmFlag").switchbox("getValue") ? 1 : 0;
			confObj[GV.PageAdmCode + "DESC"] = "是否按患者就诊分页打印";
			
			var confAry = [];
			$.each(GV.CodeStr.split("^"), function(index, item) {
				var myObj = {};
				myObj.PCSite = GV.Site;
				myObj.PCSiteDR = hospital;
				myObj.PCCode = item;
				myObj.PCValue = confObj[item + "VAL"];
				myObj.PCDesc = confObj[item + "DESC"];
				confAry.push(JSON.stringify(myObj));
			});

			$.m({
				ClassName: "web.DHCBillPageConf",
				MethodName: "SaveConfInfo",
				pageId: GV.PageId,
				confList: confAry
			}, function(rtn) {
				if (rtn == "0") {
					$.messager.popover({msg: "保存成功", type: "success"});
				}else {
					$.messager.popover({msg: "保存失败：" + rtn, type: "error"});
				}
			});
		}
	});
}

function checkData() {
	var bool = true;
	$(".validatebox-text").each(function() {
		if (!$(this).validatebox("isValid")) {
			bool = false;
			return false;
		}
	});
	return bool;
}