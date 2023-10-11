/**
 * FileName: dhcbill.ipbill.inpatqry.js
 * Author: ZhYW
 * Date: 2020-09-17
 * Description: 住院患者查询
 */

$(function () {
	var hospComp = GenUserHospComp();
	$.extend(hospComp.jdata.options, {
		onSelect: function(index, row){
			loadConHospMenu();
		},
		onLoadSuccess: function(data){
			loadConHospMenu();
		}
	});
	
	initQueryMenu();
	initAdmList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadAdmList();
		}
	});
	
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	//导出
	$HUI.linkbutton("#btn-export", {
		onClick: function () {
			exportClick();
		}
	});

	//登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	$HUI.combobox("#admStatus", {
		panelHeight: 'auto',
		editable: false,
		valueField: 'value',
		textField: 'text',
		data: [{value: 'A', text: $g('当前在院'), selected: true},
			  {value: 'D', text: $g('已出院')},
			  {value: 'C', text: $g('退院')},
		      {value: 'P', text: $g('已结算')}
		      ]
	});
	
	//病区
	$HUI.combobox("#ward", {
		panelHeight: 200,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true,
		multiple: (CV.WardMulti == 1),
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
	
	//费别
	$HUI.combobox("#insType", {
		panelHeight: 200,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true
	});
	
	//操作员
	$HUI.combobox("#user", {
		panelHeight: 180,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true,
		multiple: (CV.UserMulti == 1)
	});
}

/**
* ZhYW
* 加载跟医院有关的查询元素
*/
function loadConHospMenu() {
	var hospId = $HUI.combogrid("#_HospUserList").getValue();
	
	var url = $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryWard&ResultSetType=array&hospId=" + hospId;
	$("#ward").combobox("clear").combobox("reload", url);

	url = $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryAdmReason&ResultSetType=array&hospId=" + hospId;
	$("#insType").combobox("clear").combobox("reload", url);
	
	url = $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryInvUser&ResultSetType=array&invType=I&hospId=" + hospId;
	$("#user").combobox("clear").combobox("reload", url);
}

function initAdmList() {
	GV.AdmList = $HUI.datagrid("#admList", {
		fit: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		className: "web.UDHCJFinfro",
		queryName: "QryPatientList",
		frozenColumns: [[{title: '登记号', field: 'TRegNo', width: 110},
						 {title: '病案号', field: 'TMrNo', width: 80},
				  		 {title: '患者姓名', field: 'TPatName', width: 100}]],
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TRegNo", "TMrNo", "TPatName", "TWard"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["TAdmId"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "TDept") {
					cm[i].title = '科室病区';
					cm[i].showTip = true;
					cm[i].formatter = function (value, row, index) {
						return value + " " + row.TWard;
					};
				}
				if (cm[i].field == "TMRCIDDesc") {
					cm[i].showTip = true;
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["TSex", "TAge"]) != -1) {
						cm[i].width = 60;
					}
					if ($.inArray(cm[i].field, ["TMRCIDDesc", "TAdmDate", "TDischgDate"]) != -1) {
						cm[i].width = 155;
					}
					if ($.inArray(cm[i].field, ["TDept", "TIDNo"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		}
	});
	
}

function loadAdmList() {
	var wardId = "";
	if ($("#ward").combobox("options").multiple) {
		wardId = $("#ward").combobox("getValues").join("^");
	}else {
		wardId = $("#ward").combobox("getValue");
	}
	var userId = "";
	if ($("#user").combobox("options").multiple) {
		userId = $("#user").combobox("getValues").join("^");
	}else {
		userId = $("#user").combobox("getValue");
	}
	var queryParams = {
		ClassName: "web.UDHCJFinfro",
		QueryName: "QryPatientList",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		insTypeId: getValueById("insType"),
		userId: userId,
		patientNo: getValueById("patientNo"),
		patientName: getValueById("patName"),
		wardId: wardId,
		currFlag: getValueById("admStatus"),
		hospId: $HUI.combogrid("#_HospUserList").getValue()
		//medicareNo: getValueById("medicareNo")  //+by gongxin 2023-05-08 增加病案号查询
	};
	loadDataGridStore("admList", queryParams);
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			return;
		}
		$.m({
			ClassName: "web.UDHCJFBaseCommon",
			MethodName: "regnocon",
			PAPMINo: $(e.target).val()
		}, function(patientNo) {
			$(e.target).val(patientNo);
			loadAdmList();
		});
	}
}

function clearClick() {
	$(":text:not(.pagination-num,.combo-text)").val("");
	$(".combobox-f,.datebox-f").combobox("clear");
	$("#admStatus").combobox("select", "A");
	$(".datebox-f").datebox("setValue", CV.DefDate);
	GV.AdmList.options().pageNumber = 1;   //跳转到第一页
	GV.AdmList.loadData({total: 0, rows: []});
}

/**
* 导出
*/
function exportClick() {
	var stDate = getValueById("stDate");
	var endDate = getValueById("endDate");
	var insType = getValueById("insType");
	var wardId = "";
	if ($("#ward").combobox("options").multiple) {
		wardId = $("#ward").combobox("getValues").join("^");
	}else {
		wardId = $("#ward").combobox("getValue");
	}
	var userId = "";
	if ($("#user").combobox("options").multiple) {
		userId = $("#user").combobox("getValues").join("^");
	}else {
		userId = $("#user").combobox("getValue");
	}
	var patName = getValueById("patName");
	var patientNo = getValueById("patientNo");
	var admStatus = getValueById("admStatus");
	
	var fileName = "DHCBILL-IPBILL-HZYLB.rpx&stDate=" + stDate + "&endDate=" + endDate + "&insTypeId=" + insType;
	fileName += "&userId=" + userId + "&patientNo=" + patientNo + "&patientName=" + patName;
	fileName += "&wardId=" + wardId + "&currFlag=" + admStatus + "&hospId=" + $HUI.combogrid("#_HospUserList").getValue();
	var width = $(window).width() * 0.8;
	var height = $(window).height() * 0.8;
	DHCCPM_RQPrint(fileName, width, height);
}