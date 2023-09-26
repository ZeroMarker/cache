/**
 * FileName: dhcbill.conf.opbillsys.js
 * Anchor: ZhYW
 * Date: 2019-10-21
 * Description: 门诊系统参数配置
 */

var GV = {
	CfgJsonObj: {}
};

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
	
	//门诊集中打印发票
	setValueById("accPayConInsu", GV.CfgJsonObj.OPFCYBConFlag);                //集中打印发票连接医保
	
	//门诊退费审核
	setValueById("auditingMode", GV.CfgJsonObj.OPFCAppFlag);                   //审核模式
	setValueById("auditSpaceTime", GV.CfgJsonObj.OPFCAuditSpaceTime);          //需要审批的间隔时间
		
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
	
	var superAuditLocAry = [];
	$.each(GV.SuperAuditLocList.getChecked(), function(index, row) {
		superAuditLocAry.push(row.id);
	});
	var superAuditLocStr = superAuditLocAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
	jsonObj.OPFCSuperAuthLoc = superAuditLocStr;                                     //审核超级权限科室
		
	saveData(jsonObj);
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
		if (r) {
			$.m({
				ClassName: "web.DHCOPConfig",
				MethodName: "SaveSOPFCfg",
				jsonStr: JSON.stringify(jsonObj),
				expStr: ""
			}, function(rtn) {
				if(rtn == "0") {
					$.messager.popover({msg: "保存成功", type: "success"});
					getSOPFCfgJson();
				}else {
					$.messager.popover({msg: "保存失败：" + rtn, type: "error"});
				}
			});
		}
	});
}

function getSOPFCfgJson() {
	GV.CfgJsonObj = $.cm({ClassName: "web.DHCOPConfig", MethodName: "GetSOPFCfgJsonData", hospId: getValueById("hospital")}, false);
}