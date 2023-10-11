/**
 * FileName: dhcbill.ipbill.inpatlist.js
 * Author: ZhYW
 * Date: 2019-03-06
 * Description: 住院患者查询
 */

$(function () {
	initQueryMenu();
	initPatList()
});

function initQueryMenu() {
	$("#stDate").datebox("setValue", CV.StDate);
	$("#endDate").datebox("setValue", CV.EndDate);

	$("#btn-find").linkbutton({
		onClick: function () {
			loadPatList();
		}
	});

	$("#btn-clear").linkbutton({
		onClick: function () {
			clearClick();
		}
	});

	//发票回车查询事件
	$("#receiptNo").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			loadPatList();
		}
	});

	//科室
	$("#dept").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryIPDept&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		disabled: (["L", "W"].indexOf(CV.ViewType) != -1),
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
		},
		onLoadSuccess: function(data) {
			if (CV.ViewType != "L") {
				return;
			}
			setValueById("dept", PUBLIC_CONSTANT.SESSION.CTLOCID);
		},
		onChange: function (newValue, oldValue) {
			var url = $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryLocLinkWard&ResultSetType=array&locId=" + (newValue || "");
			$("#ward").combobox("clear").combobox("reload", url);
		}
	});
	
	//病区
	var ward = $.m({ClassName: "User.CTLoc", MethodName: "GetTranByDesc", Prop: "CTLOCDesc", Desc: session['LOGON.CTLOCDESC'], LangId: PUBLIC_CONSTANT.SESSION.LANGID}, false);
	$("#ward").combobox({
		panelHeight: 150,
		editable: false,
		valueField: 'id',
		textField: 'text',
		disabled: (CV.ViewType == "W"),
		data: (CV.ViewType == "W") ? [{id: PUBLIC_CONSTANT.SESSION.WARDID, text: ward, selected: true}] : []
	});

	//费别
	$("#admReason").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryAdmReason&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
	
	//在院状态
	$HUI.combobox("#admStatus", {
		panelHeight: 'auto',
		valueField: 'value',
		textField: 'text',
		editable: false,
		data: [{value: '1', text: $g('当前在院'), selected: true},
			   {value: '2', text: $g('医生确认')},
			   {value: '3', text: $g('护士确认')},
			   {value: '4', text: $g('财务结算')}]
	});
}

function initPatList() {
	GV.PatList = $HUI.datagrid("#patList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		fitColumns: false,
		pageSize: 20,
		className: "web.DHCIPBillCashier",
		queryName: "FindPatList",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TWard", "TAdmDate", "TDiscDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["TPAPMI", "TAdm"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "TAdmTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TAdmDate + " " + value;
					}
				}
				if (cm[i].field == "TDiscTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TDiscDate + " " + value;
					}
				}
				if (cm[i].field == "TLoc") {
					cm[i].title = '科室病区';
					cm[i].formatter = function (value, row, index) {
						return value + " " + row.TWard;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["TSex", "TAge", "TBed"]) != -1) {
						cm[i].width = 70;
					}
					if ($.inArray(cm[i].field, ["TAdmTime", "TDiscTime"]) != -1) {
						cm[i].width = 155;
					}
					if ($.inArray(cm[i].field, ["TLoc"]) != -1) {
						cm[i].width = 175;
					}
				}
			}
		},
		onDblClickRow: function (index, row) {
			if (window.parent.frames && window.parent.frames.switchPatient) {
				window.parent.frames.switchPatient(row.TPAPMI, row.TAdm);
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
        deptId: getValueById("dept"),
        wardId: getValueById("ward"),
        insTypeId: getValueById("admReason"),
        invoiceNo: getValueById("receiptNo"),
        patientName: getValueById("patName"),
        admStatus: getValueById("admStatus"),
        sessionStr: getSessionStr()
    };
    loadDataGridStore("patList", queryParams);
}

/**
 * 清屏
 */
function clearClick() {
	$(":text:not(.pagination-num,.combo-text)").val("");
	if (!CV.ViewType) {
		$("#dept").combobox("setValue", "");
	}
	$("#stDate").datebox("setValue", CV.StDate);
	$("#endDate").datebox("setValue", CV.EndDate);
	$("#admReason").combobox("clear");
	$("#admStatus").combobox("setValue", "1");
	
	GV.PatList.options().pageNumber = 1;   //跳转到第一页
	GV.PatList.loadData({total: 0, rows: []});
}