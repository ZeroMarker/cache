/*
 * FileName: dhcbillmenu.ipconfig.js
 * Author: ZhYW
 * Date: 2019-11-21
 * Description: 住院业务参数配置
 */

$(function () {
	if (BDPAutDisableFlag("Btn-Save")) {
		$("#Btn-Save").hide();
	}
	
	$HUI.linkbutton("#Btn-Save", {
		onClick: function () {
			saveClick();
		}
	});
	//+2023-03-18 ZhYW 把权力项申请按钮显示到界面上
	BILL_INF.getStatusHtml("HIS-IPBILL-PARAMSCFG", "Btn-Save");
	
	$(".combobox-f:not('#Hospital,#IntArcim')").combobox({
		panelHeight: 'auto',
		valueField: 'id',
		textField: 'text', 
		required: true,
		editable: false,
		data: [{id: 'Y',text: $g('是')}, {id:'N', text: $g('否')}]
	});
	
	var tableName = "Bill_IP_Param";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
	$("#Hospital").combobox({
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
			$.cm({
				ClassName: "DHCBILLConfig.DHCBILLSysType",
				MethodName: "GetIPParamConfig",
				hospId: newValue
			}, function (jsonObj) {
				GV.ParamObj = jsonObj;
				$.each(GV.ParamObj,function(key, value) {
					if (key == "IntArcimDR") {
						var arcimDesc = getPropValById('ARC_ItmMast', value, 'ARCIM_Desc');
						$("#IntArcim").combobox("loadData", [{ArcimRowID: value, ArcimDesc: arcimDesc, selected: true}]);
					}else {
						setValueById(key, value);
					}
				});
			});
		}
	});

	$HUI.combobox("#IntArcim", {
		panelHeight: 150,
		mode: 'remote',
		method: 'GET',
		delay: 300,
		valueField: 'ArcimRowID',
		textField: 'ArcimDesc',
		onBeforeLoad: function (param) {
			if ($.trim(param.q).length > 1) {
				$.extend($(this).combobox("options"), {url: $URL})
				param.ClassName = "BILL.COM.ItemMast";
				param.QueryName = "FindARCItmMast";
				param.ResultSetType = "array";
				var sessionStr = PUBLIC_CONSTANT.SESSION.USERID + "^" + "" + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + getValueById("Hospital");
				param.alias = param.q;
				param.sessionStr = sessionStr;
			}
		}
	});
});

function saveClick() {
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
	$.messager.confirm("确认", "确认保存?", function(r) {
		if (!r) {
			return;
		}
		var paramObj = {};
		paramObj.ID = GV.ParamObj.ID || "";
		paramObj.HospitalDR = getValueById("Hospital");
		paramObj.RegEditAdmDate = getValueById("RegEditAdmDate");
		paramObj.RegNeedPatientNo = getValueById("RegNeedPatientNo");
		paramObj.RegCheckAge = getValueById("RegCheckAge");
		paramObj.RegLnkPayDep = getValueById("RegLnkPayDep");
		paramObj.StayToAdmin = getValueById("StayToAdmin");
		paramObj.StrikeDepRequireRcpt = getValueById("StrikeDepRequireRcpt");
		paramObj.RefDepModifyPayM = getValueById("RefDepModifyPayM");
		paramObj.DischgPayDep = getValueById("DischgPayDep");
		paramObj.OutPhBillCondition = getValueById("OutPhBillCondition");
		paramObj.MultiPrintInv = getValueById("MultiPrintInv");
		paramObj.StrikeInvRequireInv = getValueById("StrikeInvRequireInv");
		paramObj.InsuIntPay = getValueById("InsuIntPay");
		paramObj.CheckPayOrNot = getValueById("CheckPayOrNot");
		paramObj.SelectDepToPay = getValueById("SelectDepToPay");
		paramObj.ConfirmPatFee = getValueById("ConfirmPatFee");
		paramObj.IPBookValidFromDate = getValueById("IPBookValidFromDate");
		paramObj.IPBookValidToDate = getValueById("IPBookValidToDate");
		paramObj.AccountFromDate = getValueById("AccountFromDate");
		paramObj.CalcInTimesByHosp = getValueById("CalcInTimesByHosp");
		paramObj.RegCheckUnPay = getValueById("RegCheckUnPay");
		paramObj.IntArcimDR = getValueById("IntArcim");
		paramObj.LostDepPayOrNot = getValueById("LostDepPayOrNot");
		paramObj.RegNeedIPBook = getValueById("RegNeedIPBook");
		$.m({
			ClassName: "DHCBILLConfig.DHCBILLSysType",
			MethodName: "SaveIPParamConf",
			jsonStr: JSON.stringify(paramObj)
		}, function (rtn) {
			var myAry = rtn.split("^");
			var iconCls = (myAry[0] == 0) ? "success" : "error";
			if (CV.EnablePMASystem != 0) {
				$.messager.popover({msg: (myAry[1] || myAry[0]), type: iconCls});
				//把权力项申请按钮显示到界面上
				BILL_INF.getStatusHtml("HIS-IPBILL-PARAMSCFG", "Btn-Save");
			}else {
				//未启用权力系统
				var msg = (myAry[0] == 0) ? "保存成功" : ("保存失败：" + (myAry[1] || myAry[0]));
				$.messager.popover({msg: msg, type: iconCls});
			}
		});
	});
}