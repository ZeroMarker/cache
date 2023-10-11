/* 
 * FileName: dhcbill.opbill.refnotrecharge.js
 * Author: WangXQ
 * Date: 2023-03-02
 * Description: 门诊已退费未重收患者查询
 */

$(function () {
	var hospComp = GenUserHospComp();
	$.extend(hospComp.jdata.options, {
		onSelect: function(index, row) {
			loadConHospMenu();
		},
		onLoadSuccess: function(data){
			loadConHospMenu();
		}
	});
	
	initQueryMenu();
	initPatList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	
    //读卡
    $("#btn-readCard").linkbutton({
        onClick: function () {
            readHFMagCardClick();
        }
    });

    //查询
	$("#btn-find").linkbutton({
		onClick: function () {
			loadPatList();
		}
	});

    //卡号回车查询事件
	$("#CardNo").focus().keydown(function (e) {
		cardNoKeydown(e);
	});
	
    //登记号回车查询事件
    $("#patientNo").keydown(function (e) {
        patientNoKeydown(e);
    });

    //清屏
    $("#btn-clean").linkbutton({
        onClick: function () {
            clearClick();
        }
    });

    //操作员
    $HUI.combobox("#user", {
		panelHeight: 180,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});

    //执行状态
	$("#execStatus").combobox({
		panelHeight: 150,
		valueField: 'value',
		textField: 'text',
		editable: false,
		data: [{value: '', text:$g('全部')},
			   {value: '1', text:$g('已执行')},
			   {value: '0', text:$g('未执行')}
		]
	});
}

function loadConHospMenu() {
	var hospId = $HUI.combogrid("#_HospUserList").getValue();
	var url = $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryInvUser&ResultSetType=array&invType=O&hospId=" + hospId;
	$("#user").combobox("clear").combobox("reload", url);
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
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

function magCardCallback(rtnValue) {
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
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
		setValueById("patientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		break;
	default:
	}
	if (patientId != "") {
		setPatientInfo(patientId);
	}
}

//加载明细列表
function loadPatList() {
	var queryParams = {
		ClassName: "BILL.OP.BL.ReChgOrder",
		QueryName: "QryRefedNoChrgPat",
        patientNo: getValueById("patientNo"),
        patientName: getValueById("patientName"),
        execStatus: getValueById("execStatus"),
        userId: getValueById("user"),
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		hospId: $HUI.combogrid("#_HospUserList").getValue()
	};
	loadDataGridStore("patList", queryParams);
}

//初始化明细列表
function initPatList() {
	var toolbar = [{
			text: '导出',
			iconCls: 'icon-export',
			handler: function () {
				exportClick();
			}
		}];
    $HUI.datagrid("#patList", {
        fit: true,
        border: false,
        singleSelect: true,
        rownumbers: true,
        pagination: true,
		pageSize: 20,
        toolbar: toolbar,
        className: "BILL.OP.BL.ReChgOrder",
        queryName: "QryRefedNoChrgPat",
        onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["chargeDate", "refundDate"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "chargeTime") {
					cm[i].formatter = function(value, row, index) {
						return row.chargeDate + " " + value;
					};
				}
				if (cm[i].field == "refundTime") {
					cm[i].formatter = function(value, row, index) {
						return row.refundDate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "ordDesc") {
						cm[i].width = 270;
					}
					if ($.inArray(cm[i].field, ["chargeTime", "refundTime", "recipelNo"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
        }
    });
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key != 13) {
		return;
	}
	if (!$(e.target).val()) {
		return;
	}
	var patientId = getPAPMIByRegNo($(e.target).val());
	if (!patientId) {
		$.messager.popover({msg: "登记号错误，请重新输入", type: "info"});
		focusById("patientNo");
		return;
	}
    setPatientInfo(patientId)
}

/**
* 根据登记号查询患者主索引
*/
function getPAPMIByRegNo(patientNo) {
	return (patientNo != "") ? $.m({ClassName: "web.DHCOPCashierIF", MethodName: "GetPAPMIByNo", PAPMINo: patientNo, ExpStr: ""}, false) : "";
}

function setPatientInfo(patientId) {
	$.cm({
		ClassName: "BILL.COM.PAPatMas",
		MethodName: "GetPatientInfo",
		patientId: patientId,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(json) {
		setValueById("patientNo", json.PatientNo);
		setValueById("patientName", json.PatName);
		loadPatList();
	});
}

/**
 * 清屏
 */
function clearClick() {
	focusById("CardNo");
	$(":text:not(.pagination-num,.combo-text)").val("");
	$("#CardTypeRowId").val("");
	$(".combobox-f").combobox("clear").combobox("reload");
	setValueById("PatientNo", "");
	setValueById("execStatus", "");
	$(".datebox-f").datebox("setValue", CV.DefDate);
	
	$HUI.datagrid("#patList").options().pageNumber = 1;   //跳转到第一页
    $HUI.datagrid("#patList").loadData({total: 0, rows: []});
}

/**
 * 导出
 */
function exportClick() {
	try{
		$.messager.progress({title: "提示", msg: '正在导出数据', text: '导出中....'});
		$.cm({
			ResultSetType: "ExcelPlugin",
			ExcelName: "已退费未重收明细列表",
			PageName: page,
			ClassName: "BILL.OP.BL.ReChgOrder",
			QueryName: "QryRefedNoChrgPat",
			patientNo: getValueById("patientNo"),
			patientName: getValueById("patientName"),
			execStatus: getValueById("execStatus"),
			user: getValueById("user"),
			stDate: getValueById("stDate"),
			endDate: getValueById("endDate"),
			hospId: $HUI.combogrid("#_HospUserList").getValue()
		}, function() {
			setTimeout('$.messager.progress("close");', 3 * 1000);
		});
	} catch(e) {
		$.messager.alert("提示", e.message, "error");
		$.messager.progress("close");
	};
}