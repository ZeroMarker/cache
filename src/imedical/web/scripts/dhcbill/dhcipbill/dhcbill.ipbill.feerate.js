/**
 * FileName: dhcbill.ipbill.feerate.js
 * Anchor: ZhYW
 * Date: 2019-12-30
 * Description: 住院患者费用比例
 */

var GV = {};

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	initQueryMenu();
	initRateList();
});

function initQueryMenu() {	
	//登记号
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	//账单号
	$HUI.combogrid("#billList", {
		panelWidth: 350,
		panelHeight: 220,
		striped: true,
		editable: false,
		selectOnNavigation: false,
		method: 'GET',
		idField: 'TBill',
		textField: 'TBill',
		columns: [[ {field: 'TBill', title: '账单号', width: 60},
					{field: 'TDateFrm', title: '账单开始日期', width: 100},
					{field: 'TDateTo', title: '账单结束日期', width: 100},
					{field: 'TAdm', title: '就诊ID', width: 80}
			]],
		onLoadSuccess: function (data) {
			setValueById("EpisodeID", "");
			setValueById("BillRowId", "");
			if (data.total == 1) {
				setValueById("billList", data.rows[0].TBill);
			}else {
				$("#billList").combogrid("clear");
				$(".numberbox-f").numberbox("clear");
				$("input:disabled").val("");
				loadRateList();
			}
		},
		onSelect: function (index, row) {
			setValueById("EpisodeID", row.TAdm);
			setValueById("BillRowId", row.TBill);
			getPatInfo();
			loadRateList();
		}
	});
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: "web.UDHCJFBaseCommon",
			MethodName: "regnocon",
			PAPMINo: getValueById("patientNo")
		}, function(patientNo) {
			setValueById("patientNo", patientNo);
			loadBillList();
		});
	}
}

function getPatInfo() {
	$.m({
		ClassName: "web.UDHCJFZYFTZDs",
		MethodName: "GetPatInfo",
		adm: getValueById("EpisodeID"),
		billId: getValueById("BillRowId")
	}, function(rtn) {
		var myAry = rtn.split("^");
		setValueById("admDate", myAry[0]);
		setValueById("dischDate", myAry[1]);
		setValueById("dept", myAry[2]);
		setValueById("bed", myAry[4]);
		setValueById("patName", myAry[5]);
		setValueById("patientNo", myAry[6]);
		setValueById("admReason", myAry[7]);
		setValueById("admDays", myAry[8]);
		setValueById("totalAmt", myAry[9]);
	});
}

function loadBillList() {
	var queryParams = {
		ClassName: "web.UDHCJFZYFTZDs",
		QueryName: "FindBillList",
		patientNo: getValueById("patientNo"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		rows: 9999999
	};
	loadComboGridStore("billList", queryParams);
}

function initRateList() {
	GV.RateList = $HUI.datagrid("#rateList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		data: [],
		columns:[[{title: 'Ticid', field: 'Ticid', hidden: true},
				  {title: '分类', field: 'Ticdesc', width: 120,
					formatter: function (value, row, index) {
						if (value) {
							return "<a href='javascript:;' onclick='billDtl(" + row.Ticid + ")'>" + value + "</a>";
						}
					}
				  },
				  {title: '金额', field: 'Ticfee', width: 120, align: 'right'},
				  {title: '百分比', field: 'Tpercentage', width: 150},
				  {title: 'Ticid1', field: 'Ticid1', hidden: true},
				  {title: '分类', field: 'Ticdesc1', width: 120,
					formatter: function (value, row, index) {
						if (value) {
							return "<a href='javascript:;' onclick='billDtl(" + row.Ticid1 + ")'>" + value + "</a>";
						}
					}
				  },
				  {title: '金额', field: 'Ticfee1', width: 120, align: 'right'},
				  {title: '百分比', field: 'Tpercentage1', width: 150},
				  {title: 'Ticid2', field: 'Ticid2', hidden: true},
				  {title: '分类', field: 'Ticdesc2', width: 120,
					formatter: function (value, row, index) {
						if (value) {
							return "<a href='javascript:;' onclick='billDtl(" + row.Ticid2 + ")'>" + value + "</a>";
						}
					}
				  },
				  {title: '金额', field: 'Ticfee2', width: 120, align: 'right'},
				  {title: '百分比', field: 'Tpercentage2', width: 150},
			]]
	});
}

function loadRateList() {
	var queryParams = {
		ClassName: "web.UDHCJFZYFTZDs",
		QueryName: "FindFeeRate",
		billId: getValueById("BillRowId"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("rateList", queryParams);
}

function billDtl(cateId) {
	var url = "dhcbill.ipbill.billdtl.csp?&EpisodeID=" + getValueById("EpisodeID") + "&BillRowId=" + getValueById("BillRowId") + "&CateRowId=" + cateId;
	websys_showModal({
		url: url,
		title: '费用明细',
		iconCls: 'icon-w-list'
	});
}