/**
 * FileName: dhcbill.ipbill.preiptransqry.js
 * Author: LUANZH
 * Date: 2023-03-09
 * Description: 预住院转入查询
 */

$(function() {
	initQueryMenu();
	initPreIPAdmList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);

	//查询
	$HUI.linkbutton("#btn-find", {
		onClick: function() {
			findClick();
		}
	});

	//清屏
	$HUI.linkbutton("#btn-clean", {
		onClick: function() {
			cleanClick();
		}
	});

	//转入类型
	$HUI.combobox('#admType', {
		panelHeight: 'auto',
		data: [{
			value: 'O',
			text: $g('门诊'),
			selected: true
		}, {
			value: 'I',
			text: $g('住院')
		}],
		editable: false,
		valueField: 'value',
		textField: 'text'
	});

	//转入科室
	$HUI.combobox("#dept", {
		panelHeight: 180,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryIPDept&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 5,
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
	
	//操作人
	$HUI.combobox("#user", {
		panelHeight: 150,
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QrySSUser&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		mode: 'remote',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		onBeforeLoad: function (param) {
			param.desc = param.q;
		}
	});
}

function initPreIPAdmList() {
	var toolbar = [{
		text: '导出',
		iconCls: 'icon-export',
		handler: function() {
			exportList();
		}
	}];
	GV.PreIPTransList = $HUI.datagrid("#preIPTransList", {
		fit: true,
		border: false,
		toolbar: toolbar,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		className: "web.DHCBillPreIPAdmTrans",
		queryName: "QryPreIPAdmTransList",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["PatientId", "AdmDate", "TransDate"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == 'AdmTime') {
					cm[i].formatter = function(value, row, index) {
						if (row.AdmDate) {
							return row.AdmDate + " " + value;
						}
					};
				}
				if (cm[i].field == 'TransTime') {
					cm[i].formatter = function(value, row, index) {
						if (row.TransDate) {
							return row.TransDate + " " + value;
						}
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["AdmTime", "TransTime", "AdmWard"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		}
	});
}

function findClick() {
	var queryParams = {
		ClassName: "web.DHCBillPreIPAdmTrans",
		QueryName: "QryPreIPAdmTransList",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		admType: getValueById("admType"),
		deptId: getValueById("dept"),
		userId: getValueById("user")
	};
	loadDataGridStore("preIPTransList", queryParams);
}

function cleanClick() {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	setValueById("admType", "O");
	$(".combobox-f:not(#admType)").combobox("clear");
	$("#user").combobox("loadData", []);
	GV.PreIPTransList.options().pageNumber = 1;   //跳转到第一页
	GV.PreIPTransList.loadData({total: 0, rows: []});
}

function exportList() {
	var stDate = getValueById("stDate");
	var endDate = getValueById("endDate");
	var admType = getValueById("admType");
	var deptId = getValueById("dept");
	var userId = getValueById("user");
	var fileName = "DHCBILL-IPBILL-PreIPAdmTrans.rpx&stDate=" + stDate + "&endDate=" + endDate + "&admType=" + admType + "&deptId=" + deptId + "&userId=" + userId;
	var width = $(window).width() * 0.8;
	var height = $(window).height() * 0.8;
	DHCCPM_RQPrint(fileName, width, height);
}
