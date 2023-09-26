/**
 * FileName: dhcbill.ipbill.uppatinfo.js
 * Anchor: ZhYW
 * Date: 2019-04-14
 * Description: 就诊信息修改查询
 */

$(function () {
	initQueryMenu();
	initUpdateList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setText", getDefStDate(0));
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadUpdateList();
		}
	});
	
	//登记号
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	//操作员
	$("#guser").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCJFDepositSearch&QueryName=FindIPCashier&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
	});
	
	$HUI.combogrid("#admList", {
		panelWidth: 530,
		panelHeight: 200,
		striped: true,
		editable: false,
		idField: "admId",
		textField: "admNo",
		columns: [[{field: "admNo", title: "就诊号", width: 100},
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
			]]
	});
}

function initUpdateList() {
	$HUI.datagrid("#updateList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		fitColumns: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		columns: [[{title: '登记号', field: 'Tregno', width: 100},
				   {title: '患者姓名', field: 'Tname', width: 80},
				   {title: '入院时间', field: 'Tadmdate', width: 150,
					formatter: function(value, row, index) {
						if (value) {
							return value + " " + row.Tadmtime;
						}
					}
				   },
				   {title: '出院时间', field: 'Tdischdate', width: 150,
					formatter: function(value, row, index) {
						if (value) {
							return value + " " + row.Tdischdate;
						}
					}
				   },
				   {title: '修改项目', field: 'Titmname', width: 80},
				   {title: '旧记录', field: 'Tolddesc', width: 80},
				   {title: '新记录', field: 'Tnewdesc', width: 80},
				   {title: '修改时间', field: 'Tupdate', width: 150,
					formatter: function(value, row, index) {
						if (value) {
							return value + " " + row.Tuptime;
						}
					}
				   },
				   {title: '修改人', field: 'Tupuser', width: 80},
				   {title: '科室', field: 'Tadmdep', width: 100},
				   {title: '病区', field: 'Tadmward', width: 100},
				   {title: '床号', field: 'Tbedno', width: 50},
				   {title: '来源', field: 'Tflag', width: 50}
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.DHCIPBillReg",
			QueryName: "FindUpPatList",
			stDate: getValueById("stDate"),
			endDate: getValueById("endDate"),
			patientId: getValueById("papmi"),
			episodeId: $("#admList").combogrid("getValue"),
			userId: getValueById("guser"),
			patName: getValueById("patName")
		}
	});
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var patientNo = $.trim(getValueById("patientNo"));
		if (!patientNo) {
			return;
		}
		$.m({
			ClassName: "web.DHCOPCashierIF",
			MethodName: "GetPAPMIByNo",
			PAPMINo: patientNo,
			ExpStr: ""
		}, function(papmi) {
			if (papmi) {
				$.m({
					ClassName: "web.DHCOPCashierIF",
					MethodName: "GetPatientByRowId",
					PAPMI: papmi,
					ExpStr: ""
				}, function(rtn) {
					var myAry = rtn.split("^");
					setValueById("papmi", myAry[0]);
					setValueById("patientNo", myAry[1]);
					setValueById("patName", myAry[2]);
					loadAdmList();
				});
			}else {
				$.messager.popover({msg: "登记号输入错误", type: "info"});
				$.m({
					ClassName: "web.UDHCJFBaseCommon",
					MethodName: "regnocon",
					PAPMINo: patientNo
				}, function(patientNo) {
					setValueById("patientNo", patientNo);
				});
			}
		});
	}
}

/**
 * 加载就诊列表
 */
function loadAdmList() {
	var queryParams = {
		ClassName: "web.DHCIPBillReg",
		QueryName: "FindAdmList",
		papmi: getValueById("papmi"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadComboGridStore("admList", queryParams);
}

function loadUpdateList() {
	var queryParams = {
		ClassName: "web.DHCIPBillReg",
		QueryName: "FindUpPatList",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		patientId: getValueById("papmi"),
		episodeId: $("#admList").combogrid("getValue"),
		userId: getValueById("guser"),
		patName: getValueById("patName"),
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("updateList", queryParams);
}