/**
* dhcbill.ipbill.dischQuery.js
*/

var m_Adm = "";

$(function () {
	initQueryMenu();
	initCombobox();
	initDataGrid();
});

var initQueryMenu = function () {	
	var curDate =  getDefStDate(0);
	$("#Stdate, #EndDate").datebox('setValue', curDate);
	
	$HUI.linkbutton("#Clear", {
		onClick: function () {
			Clear_Click();
		}
	});
	
	$HUI.linkbutton("#Find", {
		onClick: function () {
			Find_Click();
		}
	});
	$HUI.linkbutton("#outExp", {
		onClick: function () {
			outExp_Click();
		}
	});
	
	$HUI.linkbutton('#Printdetail', {
		onClick: function () {
			PrtBillDetail();
		}
	});
	
	$("#regno").keydown(function(e) {
		RegNo_keydown(e);
	});
}

function initDataGrid() {
	$HUI.datagrid('#tableList', {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		selectOnCheck: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		data: [],
		frozenColumns: [[{field: 'name', title: '姓名', width: 80},
						 {field: 'Tregno', title: '登记号', width: 100},
						 {field: 'Tzyno', title: '住院号', width: 80}
			]],
		columns: [[{field: 'Tloc', title: '科室', width: 120},
		           {field: 'Tpatward', title: '病区', width: 120},
		           {field: 'Tsex', title: '性别', width: 50},
		           {field: 'Tadmitdate', title: '入院日期', width: 150},
		           {field: 'TMRDiagnos', title: '诊断', width: 180},
		           {field: 'Tbed', title: '床位', width: 50},
		           {field: 'Tdecease', title: '出院状态', width: 80},
		           {field: 'Tpatfee', title: '未结算费用', width: 100, align: 'right', formatter: formatAmt},
		           {field: 'TPatShareAmt', title: '自付费用', width: 100, align: 'right', formatter: formatAmt},
		           {field: 'TPatAge', title: '年龄', width: 50},
		           {field: 'Tadmreas', title: '费别', width: 100},
		           {field: 'Tconfirmflag', title: '审核标志', width: 80},
		           {field: 'Tdisdate', title: '出院日期', width: 150},
		           {field: 'Tdisc', title: '最终结算状态', width: 100},
		           {field: 'Tdeposit', title: '押金', width: 100, align: 'right', formatter: formatAmt},
		           {field: 'Tremain', title: '余额', width: 100, align: 'right', formatter: formatAmt,
					styler: function(value, row, index) {
						if (+value < 0) {
							return 'background-color:#ffee00; color:red;';
						}
					}
				   },
				   {field: 'AdmDoc', title: '管床医生', width: 80},
				   {field: 'Trcptno', title: '收据号', width: 100},
				   {field: 'TAddress', title: '家庭地址', width: 100},
				   {field: 'TPaplinkphone', title: '电话', width: 100},
				   {field: 'TPatNum', title: '住院次数', width: 80},
				   {field: 'THomePlace', title: '籍贯', width: 100},
				   {field: 'EpisodeID', title: 'EpisodeID', hidden: true},
				   {field: 'TPatientID', title: 'TPatientID', hidden: true},
				   {field: 'TBillno', title: 'TBillno', hidden: true}
			]],
		onSelect: function (rowIndex, rowData) {
			SelectRowHandler(rowIndex, rowData);
		}
	});
}

function RegNo_keydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$m({
			ClassName: "web.UDHCJFBaseCommon",
			MethodName: "regnocon",
			PAPMINo: $('#regno').val(),
		},function(txt) {
			$("#regno").val(txt);
			loadDataGrid();
		});
	}
}

function initCombobox() {
	$HUI.combobox("#Ward", {
		url: $URL + '?ClassName=web.UDHCJFDischQuery&QueryName=FindWard&ResultSetType=array',
		mode: 'remote',
		valueField: 'id',
		textField: 'text',
		value: PUBLIC_CONSTANT.SESSION.WARDID,
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});

	$HUI.combobox("#Loc", {
		url: $URL + '?ClassName=web.UDHCJFQFPATIENT&QueryName=FindDept&ResultSetType=array',
		mode: 'remote',
		valueField: 'id',
		textField: 'text',
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});

	$HUI.combobox("#PCPName", {
		url: $URL + '?ClassName=web.UDHCJFDischQuery&QueryName=FindCareProv&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.PCPName = "";
			param.HospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
	
	$HUI.combobox("#Patinstype", {
		url: $URL + '?ClassName=web.UDHCJFDischQuery&QueryName=FindAdmReason&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
}

function Find_Click() {
	loadDataGrid();
}

function loadDataGrid() {
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "!" + PUBLIC_CONSTANT.SESSION.CTLOCID + "!" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var queryParams = {
		ClassName: "web.UDHCJFDischQuery",
		QueryName: "GetDisChgPatInfo",
		Medval: $("#Medical").radio("getValue") ? 1 : 0,
		Finalval: $("#Final").radio("getValue") ? 1 : 0,
		Stdate: getValueById("Stdate"),
		EndDate: getValueById("EndDate"),
		locid: getValueById("Loc") || "",
		wardid: getValueById("Ward") || "",
		payflagvalue: $("#Payflag").radio("getValue") ? 1 : 0,
		regno: getValueById("regno"),
		MasterName: getValueById("MasterName"),
		Patzyno: getValueById("Patzyno"),
		CurAdm: $("#CurAdm").radio("getValue") ? 1 : 0,
		DocID: getValueById("PCPName") || "",
		Patinstypeid: getValueById("Patinstype") || "",
		PatbedNo: getValueById("PatbedNo"),
		ExpStr: expStr
	};
	loadDataGridStore("tableList", queryParams);
}

function outExp_Click() {
	var Medval = ($("#Medical").radio("getValue")) ? 1 : 0;
	var Finalval = ($("#Final").radio("getValue")) ? 1 : 0;
	var Stdate = getValueById("Stdate");
	var EndDate = getValueById("EndDate");
	var locid = getValueById("Loc")  || "";
	var wardid = getValueById("Ward")  || "";
	var payflagvalue = ($("#Payflag").radio("getValue"))? 1 : 0;
	var regno = getValueById("regno");
	var MasterName = getValueById("MasterName");
	var Patzyno = getValueById("Patzyno");
	var CurAdm =  ($("#CurAdm").radio("getValue")) ? 1 : 0;
	var DocID = getValueById("PCPName");
	var Patinstypeid = getValueById("Patinstype") || "";
	var ExpStr = PUBLIC_CONSTANT.SESSION.GROUPID + "!" + PUBLIC_CONSTANT.SESSION.CTLOCID + "!" + PUBLIC_CONSTANT.SESSION.HOSPID;
	
	var fileName = "DHCBILL-IPBILL-CYHZTJ.rpx&Medval=" + Medval + "&Finalval=" + Finalval + "&Stdate=" + Stdate;
	fileName += "&EndDate=" + EndDate + "&locid=" + locid + "&wardid=" + wardid + "&payflagvalue=" + payflagvalue;
	fileName += "&regno=" + regno + "&MasterName=" + MasterName + "&Patzyno=" + Patzyno + "&CurAdm=" + CurAdm;
	fileName += "&DocID=" + DocID + "&Patinstypeid=" + Patinstypeid + "&ExpStr=" + ExpStr;
	
	var maxHeight = $(window).height() || 550;
	var maxWidth = $(window).width() || 1366;
	
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}

function PrtBillDetail() {
	var row = $("#tableList").datagrid("getSelected");
	if (!row) {
		return;
	}
	var adm = $.trim(row.EpisodeID);
	if (adm == "") {
		$.messager.alert('提示', '请选择患者', 'info');
		return;
	}
	var billNo = $.trim(row.TBillno);
	if (billNo != "") {
		var url = "dhcbill.ipbill.billdtl.csp?&EpisodeID=" + adm + "&BillRowId=" + billNo;
		websys_showModal({
			url: url,
			title: '费用明细',
			iconCls: 'icon-w-list',
			width: '85%'
		});
	} else {
		$m({
			ClassName: "web.UDHCJFDischQuery",
			MethodName: "JudgeBillNum",
			PAADMRowID: adm
		}, function (rtn) {
			var myAry = rtn.split('^');
			var billNum = myAry[0];
			var billId = myAry[1];
			if (parseInt(billNum) == 1) {
				Bill(billId);
			}else if (parseInt(billNum) > 1) {
				var url = "dhcbill.ipbill.billselect.csp?&EpisodeID=" + adm;
				websys_showModal({
					url: url,
					title: '账单列表',
					iconCls: 'icon-w-list',
					height: 400,
					width: 800
				});
			}
		});
	}
}

function Clear_Click() {
	$("#Stdate, #EndDate").datebox('setValue', getDefStDate(0));
	$("#regno, #Patzyno, #MasterName, #PatbedNo").val("");
	$("#Loc, #Patinstype, #PCPName, #Ward").combobox("clear").combobox("reload");
	$("#Medical, #Payflag, #CurAdm").radio({checked: false});
	$("#Final").radio({checked: true});
	$("#tableList").datagrid("loadData", {
		total: 0,
		rows: []
	});
}

function SelectRowHandler(rowIndex, rowData) {
	m_Adm = $.trim(rowData.EpisodeID);
	var PatientID = rowData.TPatientID;
	var frm = dhcsys_getmenuform();
	if (frm) {
		frm.EpisodeID.value = m_Adm;
		frm.PatientID.value = PatientID;
	}
}

function Bill(billId) {
	if (m_Adm == "") {
		$.messager.alert('提示', '请选择患者', 'info');
		return;
	}
	var computerName = PUBLIC_CONSTANT.SESSION.USERNAME;
	$.m({
		ClassName: "web.UDHCJFBaseCommon",
		MethodName: "Bill",
		itmjs: "",
		itmjsex: "",
		EpisodeID: m_Adm,
		UserRowID: PUBLIC_CONSTANT.SESSION.USERID,
		BillNo: billId,
		ComputerName: computerName,
	}, function (rtn) {
		switch (rtn) {
		case "0":
			if (billId == "") {
				$.messager.alert('提示', '账单为空', 'info');
				return;
			}
			$.m({
				ClassName: 'web.UDHCJFDischQuery',
				MethodName: "JudgePatfee",
				PatientBillId: billId
			},	function(balanceRtn) {
				if (+balanceRtn != 0) {
					$.messager.alert('提示', '患者帐单费用不平', 'info');
					return;
				}
				var url = 'dhcbill.ipbill.billdtl.csp?&EpisodeID=' + m_Adm + '&BillRowId=' + billId;
				websys_showModal({
					url: url,
					title: '费用明细',
					iconCls: 'icon-w-list',
					width: '85%'
				});
			});
			return;
		case "2":
			$.messager.alert('提示', '该患者有两个未结算帐单，不能帐单', 'info');
			return;
		default:
			$.messager.alert('提示', '帐单失败', 'error');
		}
	});
}