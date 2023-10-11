/**
 * FileName: dhcbill.conf.opbillsys.js
 * Author: ZhYW
 * Date: 2019-10-21
 * Description: 门诊系统参数配置
 */

$(function () {
	initMenu();
	initUnAuditSubCateList();
	initSuperAuditLocList();
});

function initMenu() {
	$HUI.linkbutton("#btn-saveCharge", {
		onClick: function() {
			saveChargeClick();
		}
	});
	
	$HUI.linkbutton("#btn-saveAccPay", {
		onClick: function() {
			saveAccPayClick();
		}
	});
	
	$HUI.linkbutton("#btn-saveAudit", {
		onClick: function() {
			saveAuditClick();
		}
	});
	//+2023-03-07 ZhYW 把权力项申请按钮显示到界面上
	BILL_INF.getStatusHtml("HIS-OPBILL-REFAUTHCFG", "btn-saveAudit");
	
	$HUI.linkbutton("#btn-saveOther", {
		onClick: function() {
			saveOtherClick();
		}
	});
	
	var tableName = "Bill_OP_Param";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
	$("#hospital").combobox({
		panelHeight: 150,
		width: 300,
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
			loadDoc();
		}
	});
}

function loadDoc() {
	getSOPFCfgJson();
	setDocVal();
	loadUnAuditSubCateList();
	loadSuperAuditLocList();
}

function setDocVal() {
	//门诊收费
	setValueById("outSearchMode", GV.CfgJsonObj.OPFCOutSearchFlag);            //门诊检索方式
	setValueById("outTimeRange", GV.CfgJsonObj.OPFCOutTimeRange);              //门诊值
	setValueById("emergSearchMode", GV.CfgJsonObj.OPFCEmergencySearchFlag);    //急诊检索方式
	setValueById("emergTimeRange", GV.CfgJsonObj.OPFCEmergencyTimeRange);      //急诊值
	setValueById("skinOrderMode", GV.CfgJsonObj.OPFCOESkinRtnFlag);            //是否限制皮试医嘱收费
	setValueById("prescOrderMode", GV.CfgJsonObj.OPFCOEORDLimitFootFlag);      //药品医嘱收费模式
	setValueById("useFareType", GV.CfgJsonObj.OPFCUseFareType);                //费别类型
	setValueById("prtConInsu", GV.CfgJsonObj.OPFCPRTYBConFlag);                //收费连接医保
	setValueById("guidePrtMode", GV.CfgJsonObj.OPFCPrtGuideFlag);              //导诊单打印模式
	setValueById("skcFootMode", GV.CfgJsonObj.OPFCSKCFootFlag);                //是否选择病种结算
	setValueById("newAdmReaFootMode", GV.CfgJsonObj.OPFCNewAdmReaFootFlag);    //是否选择新费别结算
	setValueById("intervalMin", GV.CfgJsonObj.OPFCIntervalMin);                //异常收费提醒间隔时间
	setValueById("zeroPriceChargeMode", GV.CfgJsonObj.OPFCZeroPriceChargeFlag);        //价格为零的医嘱结算是否进账单
	setValueById("zeroAmtUseYB", GV.CfgJsonObj.OPFCZeroAmtUseYBFlag);	   //零费用结算是否调用调用医保
	
	//门诊集中打印发票
	setValueById("accPayConInsu", GV.CfgJsonObj.OPFCYBConFlag);                //集中打印发票连接医保
	
	//门诊退费审核
	setValueById("auditingMode", GV.CfgJsonObj.OPFCAppFlag);                   //审核模式
	setValueById("auditSpaceTime", GV.CfgJsonObj.OPFCAuditSpaceTime);          //需要审批的间隔时间
	setValueById("treatItmReqMode", GV.CfgJsonObj.OPFCTreatItmReqMode);        //检查、治疗医嘱审核模式
		
	//其他配置
	setValueById("accPreToDep", GV.CfgJsonObj.OPFCOPTransferFlag);              //门诊预交金转住院押金
	setValueById("depToAccPre", GV.CfgJsonObj.OPFCIPTransferFlag);              //住院押金转门诊账户
}

function initUnAuditSubCateList() {
	GV.UnAuditSubCateList = $HUI.datagrid("#unAuditSubCateList", {
		fit: true,
		striped: true,
		title: '免审核医嘱子类',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		fitColumns: true,
		rownumbers: false,
		loadMsg: '',
		pageSize: 999999999,
		toolbar: [],
		columns: [[{title: 'ck', field: 'ck', checkbox: true},
				   {title: 'id', field: 'id', hidden: true},
		           {title: 'code', field: 'code', hidden: true},
				   {title: '子类名称', field: 'desc', width: 120}
			]],
		onLoadSuccess: function(data) {
			$.each(data.rows, function (index, row) {
				if (row.checked) {
					GV.UnAuditSubCateList.checkRow(index);
				}
			});
		}
	});
}

function loadUnAuditSubCateList() {
	var queryParams = {
		ClassName: "web.DHCOPConfigListBroker",
		QueryName: "FindItemCat",
		hospId: getValueById("hospital"),
		rows: 99999999
	};
	loadDataGridStore("unAuditSubCateList", queryParams);
}

function initSuperAuditLocList() {
	GV.SuperAuditLocList = $HUI.datagrid("#superAuditLocList", {
		fit: true,
		striped: true,
		title: '审核超级权限科室',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		fitColumns: true,
		rownumbers: false,
		loadMsg: '',
		pageSize: 999999999,
		toolbar: [],
		columns: [[{title: 'ck', field: 'ck', checkbox: true},
				   {title: 'id', field: 'id', hidden: true},
		           {title: 'code', field: 'code', hidden: true},
				   {title: '科室名称', field: 'desc', width: 120}
			]],
		onLoadSuccess: function(data) {
			$.each(data.rows, function (index, row) {
				if (row.checked) {
					GV.SuperAuditLocList.checkRow(index);
				}
			});
		}
	});
}

function loadSuperAuditLocList() {
	var queryParams = {
		ClassName: "web.DHCOPConfigListBroker",
		QueryName: "FindSuperAuditLoc",
		hospId: getValueById("hospital"),
		rows: 99999999
	};
	loadDataGridStore("superAuditLocList", queryParams);
}

/**
* 门诊收费配置
*/
function saveChargeClick() {
	var jsonObj = GV.CfgJsonObj;
	jsonObj.OPFCOutSearchFlag = getValueById("outSearchMode");              //门诊检索方式
	jsonObj.OPFCOutTimeRange = getValueById("outTimeRange");                //门诊值
	jsonObj.OPFCEmergencySearchFlag = getValueById("emergSearchMode");      //急诊检索方式
	jsonObj.OPFCEmergencyTimeRange = getValueById("emergTimeRange");        //急诊值
	jsonObj.OPFCOESkinRtnFlag = getValueById("skinOrderMode");              //是否限制皮试医嘱收费
	jsonObj.OPFCOEORDLimitFootFlag = getValueById("prescOrderMode");        //药品医嘱收费模式
	jsonObj.OPFCUseFareType = getValueById("useFareType");                  //费别类型
	jsonObj.OPFCPRTYBConFlag = getValueById("prtConInsu");                  //收费连接医保
	jsonObj.OPFCPrtGuideFlag = getValueById("guidePrtMode");                //导诊单打印模式
	jsonObj.OPFCSKCFootFlag = getValueById("skcFootMode");                  //是否选择病种结算
	jsonObj.OPFCNewAdmReaFootFlag = getValueById("newAdmReaFootMode");      //是否选择新费别结算
	jsonObj.OPFCIntervalMin = getValueById("intervalMin");                  //异常收费提醒间隔时间
	jsonObj.OPFCZeroPriceChargeFlag = getValueById("zeroPriceChargeMode");                  //价格为零的医嘱结算是否进账单
	jsonObj.OPFCZeroAmtUseYBFlag = getValueById("zeroAmtUseYB"); 	//零费用结算是否调用调用医保
	saveData(jsonObj);
}

/**
* 门诊集中打印发票配置
*/
function saveAccPayClick() {
	var jsonObj = GV.CfgJsonObj;
	jsonObj.OPFCYBConFlag = getValueById("accPayConInsu");                     //集中打印发票连接医保
	saveData(jsonObj);
}

/**
* 门诊退费审核配置
*/
function saveAuditClick() {
	var jsonObj = GV.CfgJsonObj;
	jsonObj.OPFCAppFlag = getValueById("auditingMode");                             //审核模式
	var unAuditSubCateAry = [];
	$.each(GV.UnAuditSubCateList.getChecked(), function(index, row) {
		unAuditSubCateAry.push(row.id);
	});
	var unAuditSubCateStr = unAuditSubCateAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
	jsonObj.OPFCUnAuditOrderCateList = unAuditSubCateStr;                           //免审核医嘱子类
	
	jsonObj.OPFCAuditSpaceTime = getValueById("auditSpaceTime");                    //需要审核的间隔时间
	
	jsonObj.OPFCTreatItmReqMode = getValueById("treatItmReqMode");                  //检查、治疗医嘱审核模式
	
	var superAuditLocAry = [];
	$.each(GV.SuperAuditLocList.getChecked(), function(index, row) {
		superAuditLocAry.push(row.id);
	});
	var superAuditLocStr = superAuditLocAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
	jsonObj.OPFCSuperAuthLoc = superAuditLocStr;                                     //审核超级权限科室
	
	saveOPRefAuthData(jsonObj);
}

/**
* 其他配置
*/
function saveOtherClick() {
	var jsonObj = GV.CfgJsonObj;
	jsonObj.OPFCOPTransferFlag = getValueById("accPreToDep");                    //门诊预交金转住院押金
	jsonObj.OPFCIPTransferFlag = getValueById("depToAccPre");                    //住院押金转门诊账户
	saveData(jsonObj);
}

function saveData(jsonObj) {
	jsonObj.OPFCHospDR = getValueById("hospital");       //医院
	$.messager.confirm("确认", "确认保存？", function(r) {
		if (!r) {
			return;
		}
		$.m({
			ClassName: "web.DHCOPConfig",
			MethodName: "SaveSOPFCfg",
			jsonStr: JSON.stringify(jsonObj)
		}, function(rtn) {
			var myAry = rtn.split("^");
			var iconCls = (myAry[0] == 0) ? "success" : "error";
			var msg = (myAry[0] == 0) ? "保存成功" : ("保存失败：" + (myAry[1] || myAry[0]));
			$.messager.popover({msg: msg, type: iconCls});
		});
	});
}

/**
* 保存门诊退费审核配置数据
*/
function saveOPRefAuthData(jsonObj) {
	jsonObj.OPFCHospDR = getValueById("hospital");       //医院
	$.messager.confirm("确认", "确认保存？", function(r) {
		if (!r) {
			return;
		}
		$.m({
			ClassName: "web.DHCOPConfig",
			MethodName: "SaveOPRefAuthCfg",
			jsonStr: JSON.stringify(jsonObj)
		}, function(rtn) {
			var myAry = rtn.split("^");
			var iconCls = (myAry[0] == 0) ? "success" : "error";
			if (CV.EnablePMASystem != 0) {
				$.messager.popover({msg: (myAry[1] || myAry[0]), type: iconCls});
				//把权力项申请按钮显示到界面上
				BILL_INF.getStatusHtml("HIS-OPBILL-REFAUTHCFG", "btn-saveAudit");
			}else {
				//未启用权力系统
				var msg = (myAry[0] == 0) ? "保存成功" : ("保存失败：" + (myAry[1] || myAry[0]));
				$.messager.popover({msg: msg, type: iconCls});
			}
		});
	});
}

function getSOPFCfgJson() {
	GV.CfgJsonObj = $.cm({ClassName: "web.DHCOPConfig", MethodName: "GetSOPFCfgJsonData", hospId: getValueById("hospital")}, false);
}