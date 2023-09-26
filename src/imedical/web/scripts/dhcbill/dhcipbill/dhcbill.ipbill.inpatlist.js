/**
 * FileName: dhcbill.ipbill.inpatlist.js
 * Anchor: ZhYW
 * Date: 2019-03-06
 * Description: 住院患者查询
 */

$(function () {
	initQueryMenu();
	initPatList()
});

function initQueryMenu() {
	setValueById("stDate", getDefStDate(-30));
	setValueById("endDate", getDefStDate(0));

	$("#btn-find").linkbutton({
		onClick: function () {
			loadPatList();
		}
	});

	$("#btn-clear").linkbutton({
		onClick: function () {
			clear_Click();
		}
	});

	//发票回车查询事件
	$('#receiptNo').keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			loadPatList();
		}
	});

	//科室
	$("#dept").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCIPBillCashier&QueryName=FindDept&ResultSetType=array',
		mode: 'remote',
		valueField: 'id',
		textField: 'text',
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		onSelect: function (rec) {
			var url = $URL + '?ClassName=web.DHCIPBillCashier&QueryName=FindWard&ResultSetType=array';
			$('#ward').combobox('clear').combobox('reload', url);
		},
		onChange: function (newValue, oldValue) {
			if (!newValue) {
				$('#ward').combobox('clear').combobox('loadData', []);
			}
		}
	});

	//病区
	$("#ward").combobox({
		panelHeight: 150,
		editable: false,
		valueField: 'id',
		textField: 'text',
		onBeforeLoad: function (param) {
			param.deptId = getValueById('dept');
		}
	});

	//费别
	$("#admReason").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCIPBillCashier&QueryName=FindAdmReason&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
}

function initPatList() {
	$("#patList").datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		fitColumns: false,
		pageSize: 20,
		data: [],
		columns: [[{title: '登记号', field: 'TpatNo', width: 120},
				   {title: '病案号', field: 'TpatMedicare', width: 80},
				   {title: '姓名', field: 'TpatName', width: 80},
				   {title: '年龄', field: 'Tage', width: 50},
				   {title: '科室', field: 'TpatLoc', width: 120},
				   {title: '病区', field: 'TpatWard', width: 140},
				   {title: '床位', field: 'TpatBed', width: 50},
				   {title: '就诊日期', field: 'TadmDate', width: 100},
				   {title: '就诊时间', field: 'TadmTime', width: 80},
				   {title: '出院日期', field: 'TdiscDate', width: 100},
				   {title: '出院时间', field: 'TdiscTime', width: 80},
				   {title: '性别', field: 'Tsex', width: 50},
				   {title: '费别', field: 'TadmReason', width: 80}
			]],
		onDblClickRow: function (rowIndex, rowData) {
			if (window.parent.frames && window.parent.frames.switchPatient) {
				window.parent.frames.switchPatient(rowData.TPapmi, rowData.TAdm);
				window.parent.frames.hidePatListWin();
			}
		}
	});
}

function loadPatList() {
	var queryParams = {
		ClassName: "web.DHCIPBillCashier",
		QueryName: "FindPatList",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		patLoc: getValueById("dept"),
		patWard: getValueById("ward"),
		admReason: getValueById("admReason"),
		Invoice: getValueById("receiptNo"),
		patName: getValueById("patName"),
		checkedStatus: $("#Medical").radio("getValue") + "^" + $("#Final").radio("getValue") + "^" + $("#PayFlag").radio("getValue") + "^" + $("#CurAdm").radio("getValue"),
		sessionStr: getSessionStr()
	};
	loadDataGridStore("patList", queryParams);
}

/**
 * 清屏
 */
function clear_Click() {
	$(".hisui-combobox").combobox("clear").combobox("reload");
	setValueById("stDate", getDefStDate(-30));
	setValueById("endDate", getDefStDate(0));
	setValueById("patName", "");
	setValueById("receiptNo", "");
	$("#CurAdm").radio("setValue", true);
	$("#patList").datagrid("load", {
		ClassName: "web.DHCIPBillCashier",
		QueryName: "FindPatList",
		stDate: "",
		endDate: "",
		patLoc: "",
		patWard: "",
		admReason: "",
		Invoice: "",
		patName: "",
		checkedStatus: "",
		ExpStr: ""
	});
}