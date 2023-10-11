/**
 * FileName: dhcbill.conf.page.oppredepaccount.js
 * Anthor: ZhYW
 * Date: 2021-09-11
 * Description: 门诊预交金账页面配置
 */

$(function() {
	$HUI.linkbutton("#btn-save", {
		onClick: function () {
			saveClick();
		}
	});
	
	//结算人
	$HUI.combobox("#footUser", {
		panelHeight: 150,
		required: true,
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 5
	});
	
	var tableName = "Bill_OP_PreDepAccount";
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
				code: GV.FootUsrCode,
				siteId: newValue
			}, function (userId) {
				var url = $URL + "?ClassName=web.DHCBillPageConf&QueryName=FindUserList&ResultSetType=array&hospId=" + newValue;
				$("#footUser").combobox("reload", url).combobox("setValue", userId);
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
		if (!r) {
			return;
		}
		var confObj = {};			
		confObj[GV.FootUsrCode + "VAL"] = getValueById("footUser");
		confObj[GV.FootUsrCode + "DESC"] = "预交金账结算人";
		
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
			if (rtn == 0) {
				$.messager.popover({msg: "保存成功", type: "success"});
				return;
			}
			$.messager.popover({msg: "保存失败：" + rtn, type: "error"});
		});
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