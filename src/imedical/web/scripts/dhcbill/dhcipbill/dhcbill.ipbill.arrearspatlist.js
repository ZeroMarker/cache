/**
 * FileName: dhcbill.ipbill.arrearspatlist.js
 * Author: 罗超越
 * Date: 2021-12-26
 * Description: 欠费患者查询
 */

$(function () {
	initQueryMenu();
	initPatList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadPatList();
		}
	});
	
	//余额
	$HUI.combobox("#arrearsFlag", {
		panelHeight: 'auto',
		editable: false,
		valueField: 'value',
		textField: 'text',
		data: [{value: '-1', text: $g('小于0'), selected: true},
			  {value: '0', text: $g('等于0')},
			  {value: '1', text: $g('大于0')}
			  ]
	});
	
	//在院状态
	$HUI.combobox("#admStatus", {
		panelHeight: 'auto',
		editable: false,
		valueField: 'value',
		textField: 'text',
		data:[{value: 'A', text: $g('在院'), selected: true},
			  {value: 'D', text: $g('出院未结算')}
			 ]
	});
	
	$HUI.combobox("#dept", {
		panelHeight: 180,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryIPDept&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true,
		filter: function(q, row) {
			var opts = $(this).combobox("options");
			var mCode = false;
			if (row.contactName) {
				mCode = row.contactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
			return mCode || mValue;
		}
	});
	
	$HUI.combobox("#ward", {
		panelHeight: 180,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryWard&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true,
		filter: function(q, row) {
			var opts = $(this).combobox("options");
			var mCode = false;
			if (row.contactName) {
				mCode = row.contactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
			return mCode || mValue;
		}
	});
	
	$HUI.combobox("#insTypeId", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryAdmReason&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
}

/**
* 打印
*/
function printClick() {
	var stDate = getValueById("stDate");
	var endDate = getValueById("endDate");
	var arrearsFlag = getValueById("arrearsFlag");
	var admStatus = getValueById("admStatus");
	var deptId = getValueById("dept");
	var wardId = getValueById("ward");
	var insTypeId = getValueById("insTypeId");
	var fileName = "DHCBILL-IPBILL-QFPATIENT.rpx" + "&stDate=" + stDate + "&endDate=" + endDate;
	fileName += "&arrearsFlag=" + arrearsFlag + "&admStatus=" + admStatus + "&deptId=" + deptId;
	fileName += "&wardId=" + wardId + "&insTypeId=" + insTypeId + "&sessionStr=" + getSessionStr();
	var maxWidth = $(window).width() * 0.8;
	var maxHeight = $(window).height() * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}

function initPatList() {
	var toolbar = [{
			text: '打印',
			iconCls: 'icon-print',
			handler: function () {
				printClick();
			}
		}
	];
	GV.PatList = $HUI.datagrid("#patList", {
		fit: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		toolbar: toolbar,
		className: "web.UDHCJFQFPATIENT",
		queryName: "QryArrPatList",
		frozenColumns: [[{field: 'regNo', title: '登记号', width: 100},
						 {field: 'mrNo', title: '病案号', width: 80},
						 {field: 'patName', title: '患者姓名', width: 80}
			]],
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["regNo", "mrNo", "patName", "ward", "admDate", "dischDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["adm", "arrFlag", "arrUser", "arrDate", "arrTime"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "admTime") {
					cm[i].formatter = function(value, row, index) {
						return row.admDate + " " + value;
					};
				}
				if (cm[i].field == "dischTime") {
					cm[i].formatter = function(value, row, index) {
						return row.dischDate + " " + value;
					};
				}
				if (cm[i].field == "dept") {
					cm[i].title = "科室病区";
					cm[i].formatter = function(value, row, index) {
						return row.ward + " " + row.dept;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "dept") {
						cm[i].width = 200;
					}
					if ($.inArray(cm[i].field, ["admTime", "dischTime", "IDNo"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		}
	});
}

function loadPatList() {
	var queryParams = {
		ClassName: "web.UDHCJFQFPATIENT",
		QueryName: "QryArrPatList",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		arrearsFlag: getValueById("arrearsFlag"),
		admStatus: getValueById("admStatus"),
		deptId: getValueById("dept"),
		wardId: getValueById("ward"),
		insTypeId: getValueById("insTypeId"),
		sessionStr: getSessionStr()
	};
	loadDataGridStore("patList", queryParams);
}