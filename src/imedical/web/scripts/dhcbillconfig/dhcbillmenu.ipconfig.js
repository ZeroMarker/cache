/*
 * FileName: dhcbillmenu.ipconfig.js
 * User: ZhYW
 * Date: 2019-11-21
 * Function: 住院业务参数配置
 * Description: 
 */

var GV = {
	ParamObj: {}
};

$(function () {
	if (BDPAutDisableFlag("BtnUpdate")) {
		$("#BtnUpdate").hide();
	}
	
	$HUI.linkbutton("#BtnUpdate", {
		onClick: function () {
			saveClick();
		}
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
						$.m({
							ClassName: "web.DHCBillCommon",
							MethodName: "GetDescById",
							tabName: "ARC_ItmMast",
							idCol: "ARCIM_RowId",
							idVal: value,
							descCol: "ARCIM_Desc"
						}, function(desc) {
							$("#IntArcim").combobox("loadData", [{ArcimRowID: value, ArcimDesc: desc, selected: true}]);
						});
					}else {
						setValueById(key, value);
					}
				});
			});
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
		if (r) {
			var paramObj = {};
			paramObj.ID = GV.ParamObj.ID || "";
			paramObj.HospitalDR = getValueById("Hospital");
			paramObj.RegEditAdmDate = getValueById("RegEditAdmDate");
			paramObj.RegNeedPatientNo = getValueById("RegNeedPatientNo");
			paramObj.RegCheckAge = getValueById("RegCheckAge");
			paramObj.RegLnkPayDep = getValueById("RegLnkPayDep");
			paramObj.StrikeDepRequireRcpt = getValueById("StrikeDepRequireRcpt");
			paramObj.RefDepModifyPayM = getValueById("RefDepModifyPayM");
			paramObj.AbortDepRenewPrint = getValueById("AbortDepRenewPrint");
			paramObj.DischgPayDep = getValueById("DischgPayDep");
			paramObj.OutPhBillCondition = getValueById("OutPhBillCondition");
			paramObj.PrintQFInv = getValueById("PrintQFInv");
			paramObj.MultiPrintInv = getValueById("MultiPrintInv");
			paramObj.StrikeInvRequireInv = getValueById("StrikeInvRequireInv");
			paramObj.AbortInvRenewPrint = getValueById("AbortInvRenewPrint");
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
			$.cm({
				ClassName: "DHCBILLConfig.DHCBILLSysType",
				MethodName: "SaveIPParamConf",
				jsonStr: JSON.stringify(paramObj)
			}, function (rtn) {
				$.messager.popover({msg: rtn.msg, type: ((rtn.success == 0) ? "success" : "error")});
			});
		}
	});
}