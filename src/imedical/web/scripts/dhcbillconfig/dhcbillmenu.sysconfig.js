/*
 * FileName: dhcbillmenu.sysconfig.js
 * User: TangTao
 * Date: 2014-04-10
 * Function: 系统参数配置
 * Description:
 */

var GV = {
	ParaRowId: ""
};

$(function () {
	if (BDPAutDisableFlag("BtnUpdate")) {
		$("#BtnUpdate").hide();
	}
	
	var tableName = "Bill_Com_TarPara";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
	$("#Hospital").combobox({
		panelHeight: 150,
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
			url = $URL + "?ClassName=DHCBILLConfig.DHCBILLSysType&QueryName=FindAdmReason&ResultSetType=array";
			$("#DefAdmReason").combobox('clear').combobox("reload", url);

			initForm();
		}
	});
	
	//缺省收费类别
	$("#DefAdmReason").combobox({
		valueField: 'RowID',
		textField: 'READesc',
		editable: false,
		required: true,
		onBeforeLoad:function(param) {
			$.extend(param, {
						Code: "",
						Desc: "",
						HospId: getValueById("Hospital")
					});
			return true;
		}
	});
});

function initForm() {
	$.cm({
		ClassName: "DHCBILLConfig.DHCBILLSysType",
		MethodName: "GetTarPara",
		HospId: getValueById("Hospital")
	}, function (rtn) {
		var CfgAry = rtn.split("^");
		GV.ParaRowId = (CfgAry[0] || "");
		setValueById("DefAdmReason", (CfgAry[3] || ""));    //缺省收费类别
		setValueById("DefBabyBill", (CfgAry[5] || ""));     //包含新生儿费用
		setValueById("DefAgeCalc", (CfgAry[15] || ""));	    //年龄计算方式
	});
}

$("#BtnUpdate").bind("click", function () {
	var ParaObj = {};
	ParaObj.ParaRowId = GV.ParaRowId;
	ParaObj.TMDefaultTariff = getValueById("DefPrice");
	ParaObj.TMBillCondition = getValueById("DefCondition");
	ParaObj.TMBillMode = getValueById("DefCharge");
	ParaObj.TMDefaultInsType = getValueById("DefAdmReason");
	ParaObj.TMReBillMode = getValueById("DefReBill");
	ParaObj.TMDiscountType = getValueById("DefRate");
	ParaObj.TMNewBornToMother = getValueById("DefBabyBill");
	ParaObj.TMAgeCalcMode = getValueById("DefAgeCalc");
	ParaObj.TMHospDR = getValueById("Hospital");
	var bool = true;
	$(".validatebox-text").each(function() {
		if (!$(this).validatebox("isValid")) {
			$.messager.popover({msg: "数据验证不通过", type: "info"});
			focusById($(this)[0].id);
			bool = false;
			return false;
		}
	});
	if (!bool) {
		return;
	}
	
	$.messager.confirm('确认', '确认保存？', function(r){
		if (r){
		    $.cm({
				ClassName: "DHCBILLConfig.DHCBILLSysType",
				MethodName: "UpdatePara",
				jsonStr: JSON.stringify(ParaObj)
			}, function (rtn) {
				if (rtn == 0) {
					$.messager.popover({msg: "保存成功", type: "success"});
					initForm();
				} else {
					$.messager.popover({msg: "保存失败：" + rtn, type: "error"});
				}
			});
		}
	});
});